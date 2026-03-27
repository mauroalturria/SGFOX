*
* VP, detalle de Insumos por Vale para preparacion, cantidades (solicitadas / entregas)
*
Lparameters midpre, mTipoPro

If Vartype(mTipoPro) <> "C"
	mTipoPro = "A"
Endif

Dimension vd[10]

vd[01] = midpre
vd[02] = Int(Val(mwkfarm49a._vale))
vd[03] = Alltrim(mwkfarm49a._codins)
vd[04] = mwkfarm49a._cantidad
vd[05] = mwkfarm49a._entregad
vd[06] = mwkfarm49a._tipo
vd[07] = Alltrim(mwkfarm49a._sector)
vd[08] = Alltrim(mwkfarm49a._observ)
vd[09] = mwkfarm49a._cama
vd[10] = mwkfarm49a._hab

muser = mwkusuario.idusuario

If mTipoPro = "A"

*!* 2018-10-09 Ctrl si existe, sugerido por Silvia, a raiz de los problemas de corte de luz, etc. para evitar duplicados

	Use In Select("mwkctrlen")

	mret = SQLExec(mcon1, "SELECT * FROM TabFarmVPDetEnt"+;
		" WHERE TVE_IdPre = ?vd[1] and TVE_Vale = ?vd[2] and TVE_Sector = ?vd[7] and TVE_insumocodigo = ?vd[3]", "mwkctrlen")

	If mret < 0
		mltabla = "VP - MAESTRO DETALLE DE INSUMOS"
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

	If Used("mwkctrlen")
		If Reccount("mwkctrlen") = 0

			mret = SQLExec(mcon1, "INSERT INTO TabFarmVPDetEnt (TVE_IdPre, TVE_Vale, TVE_insumocodigo, TVE_Soli, TVE_Entrega,"+;
				" TVE_TipoEnt, TVE_Sector, TVE_ObsItem, TVE_usuario, TVE_Modif, TVE_Cama, TVE_Hab)"+;
				" VALUES (?vd[1], ?vd[2], ?vd[3], ?vd[4], ?vd[5], ?vd[6], ?vd[7], ?vd[8], ?muser, ?vd[5], ?vd[9], ?vd[10])")

		Endif
	Endif

	Use In Select("mwkctrle")

Else

	mret = SQLExec(mcon1, "UPDATE TabFarmVPDetEnt SET TVE_Entrega = ?vd[5], TVE_TipoEnt = ?vd[06]"+;
		" WHERE TVE_IdPre = ?vd[1] and TVE_Vale = ?vd[2] and TVE_Sector = ?vd[7] and TVE_insumocodigo = ?vd[3]")

Endif

If mret < 0
	mltabla = "VP - MAESTRO DETALLE DE INSUMOS"
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Release vd

Return .T.

