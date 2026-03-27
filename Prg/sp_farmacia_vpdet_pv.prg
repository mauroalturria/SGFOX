*
* VP, detalle de Insumos por Vale para preparacion, cantidades (solicitadas / entregas)
*
Lparameters midpre, mTipoPro,lkardexweb

Local lResult
Local nCuenta

If Vartype(mTipoPro) <> "C"
	mTipoPro = "A"
Endif

lResult = .T.

Dimension vd[15]

vd[01] = midpre
vd[02] = Val(mwkfarm49a._vale)
vd[03] = mwkfarm49a._codins
vd[04] = mwkfarm49a._cantidad
vd[05] = mwkfarm49a._entregad
vd[06] = mwkfarm49a._tipo
vd[07] = Alltrim(mwkfarm49a._sector)
vd[08] = Alltrim(mwkfarm49a._observ)
vd[09] = mwkfarm49a._cama
vd[10] = mwkfarm49a._hab
vd[11] = 1
**vd[12] = IIF(mwkFarm49.esExterno = 'S','E','K')  && [E]xterno o [K]ardex

* vd[12] = Iif(sp_esExternoKardex_pv(mwkfarm49a._codins) = "S","E","K")
vd[12] = Iif(mwkfarm49a.esexterno = "S","E","K")
vd[13] = Alltrim(mwkfarm49a.armario)

* 17/10/2025
vd[14] = mwkfarm49a._Frio
vd[15] = mwkfarm49a.FPT_ParaAlta

* 21/11/2025
If lkardexweb
	If Empty(vd[13])   &&Si no tiene armario definido, es externo.
		vd[13] = "EX"
	Endif
Else
	vd[13] = vd[12]
Endif

muser = mwkusuario.idusuario

If mTipoPro = "A"

*** --- Primero verificamos que no esté cargado el registro.
*** --- Hubo duplicaciones. Marcelo Torres, 08/09/2020

	Use In Select("mwkTVDE")
	mret = SQLExec(mcon1,"select ID from TabFarmVPDetEnt " +;
		"where TVE_IdPre = ?vd[1] and TVE_Vale = ?vd[2] and TVE_insumocodigo = ?vd[3]","mwkTVDE")

	If mret < 0
		mltabla = "CONSULTA VP - MAESTRO DETALLE DE INSUMOS"
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		lResult = .F.
*** -------- Intentamos guardar igual
*!*			mret = SQLExec(mcon1, "INSERT INTO TabFarmVPDetEnt (TVE_IdPre, TVE_Vale, TVE_insumocodigo, TVE_Soli, TVE_Entrega,"+;
*!*				" TVE_TipoEnt, TVE_Sector, TVE_ObsItem, TVE_usuario, TVE_Modif, TVE_Cama, TVE_Hab, TVE_Estado, TVE_Tipo)"+;
*!*				" VALUES (?vd[1], ?vd[2], ?vd[3], ?vd[4], ?vd[5], ?vd[6], ?vd[7], ?vd[8], ?muser, ?vd[5], ?vd[9], ?vd[10], ?vd[11], ?vd[12])")

	Else

		nCuenta = 0

		Select mwkTVDE
		Go Top
		Scan All
			nCuenta = nCuenta + 1
		Endscan

		Go Top

*If Reccount("mwkTVDE") = 0
		If nCuenta = 0
			mret = SQLExec(mcon1, "INSERT INTO TabFarmVPDetEnt (TVE_IdPre, TVE_Vale, TVE_insumocodigo, TVE_Soli, TVE_Entrega,"+;
				" TVE_TipoEnt, TVE_Sector, TVE_ObsItem, TVE_usuario, TVE_Modif, TVE_Cama, TVE_Hab, TVE_Estado, TVE_Tipo,TVE_Armario, TVE_Frio, TVE_ParaAlta)"+;
				" VALUES (?vd[1], ?vd[2], ?vd[3], ?vd[4], ?vd[5], ?vd[6], ?vd[7], ?vd[8], ?muser, ?vd[5], ?vd[9], ?vd[10], ?vd[11], ?vd[12], ?vd[13], ?vd[14], ?vd[15])")
		Else
			mret = SQLExec(mcon1, "UPDATE TabFarmVPDetEnt SET TVE_Entrega = ?vd[5], TVE_TipoEnt = ?vd[06], TVE_Frio = ?vd[14] "+;
				" WHERE TVE_IdPre = ?vd[1] and TVE_Vale = ?vd[2] and TVE_Sector = ?vd[7] and TVE_insumocodigo = ?vd[3]")
		Endif

	Endif

	Use In Select("mwkTVDE")

Else

	mret = SQLExec(mcon1, "UPDATE TabFarmVPDetEnt SET TVE_Entrega = ?vd[5], TVE_TipoEnt = ?vd[06], TVE_estado = 2 "+;
		" WHERE TVE_IdPre = ?vd[1] and TVE_Vale = ?vd[2] and TVE_Sector = ?vd[7] and TVE_insumocodigo = ?vd[3]")

Endif

If mret < 0
	mltabla = "VP - MAESTRO DETALLE DE INSUMOS"
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	lResult = .F.
Endif

Release vd

Use In Select("mwkTVDE")

Return lResult

