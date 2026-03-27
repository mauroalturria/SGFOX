****
** Pedido de insumos todos o por descripcion
** 01/06/2016, Marcelo Torres.
** Parametro mSector, cuando viene desde FrmPac_internados->Frmpisos03 o FrmAutor07.
** Se usa para excluir insumos en los sectores que no estan definidos.
****

Parameters mctexto,mgrupo,lac,ccursor, mSector

LOCAL nEstado

**SET STEP ON

If Vartype(mgrupo)#"C"
	mgrupo = " in ('D','O','A','C') "
Endif
If Vartype(ccursor)#"C"
	ccursor=  "mwkbustexto"
Endif
If Vartype(mSector) <> "C"   &&Marcelo Torres, 01/06/2016
	mSector = ""
Endif

If "LIKE" $ Upper(mctexto)
	mbusco = mctexto
Else
	mbusco = Iif(Empty(mctexto),'',	" and INS_descriinsumo LIKE '%&mctexto%' " )
Endif

mret = SQLExec(mcon1,"select INS_descriinsumo, INS_codinsumo, INS_grupo, "+;
	"insumos.insumos, INS_CODPUNTERO ,INS_MedSensi, INS_DDD, INS_UniDDD,INS_Contenido,ins_codatc " + ;
	"from insumos " + ;
	"where INS_fechapasivo is null and ins_grupo "+ mgrupo + mbusco +;
	"order by INS_descriinsumo",ccursor)

If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	Do sp_desconexion With "Err buscotextoinsumo"
	Cancel
Endif

** ----------- Filtramos por criterio de Sector.
** ----------- Marcelo Torres, 01/06/2016
If !Empty(mSector)

	mret = SQLExec(mcon1,"select * from TabEstados where propietario = 7 and tipo = 22 ","mwkTabSecRestric")

	If mret <= 0

		Messagebox("ERROR EN LA LECTURA DE TABESTADOS",26,"ERROR")
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.

	Endif

	nEstado = 0

	Select mwkTabSecRestric
	Go Top
	Scan All

		If At(mSector,mwkTabSecRestric.Descrip) > 0
			nEstado = mwkTabSecRestric.Estado
		Endif

	Endscan

	If nEstado = 0
		mret = SQLExec(mcon1,"select * from TabInsRestriccion","mwkTabInsRestriccion")
		Select * From (ccursor) Where &ccursor..Ins_codpuntero Not In (Select TIR_codpuntero From mwkTabInsRestriccion Where TIR_codpuntero = &ccursor..Ins_codpuntero) Into Cursor (ccursor)
	Else
		mret = SQLExec(mcon1,"select * from TabInsRestriccion where tir_tipo <> ?nEstado","mwkTabInsRestriccion")
		Select * From (ccursor) Where &ccursor..Ins_codpuntero Not In (Select TIR_codpuntero From mwkTabInsRestriccion Where TIR_codpuntero = &ccursor..Ins_codpuntero) Into Cursor (ccursor)
	Endif


Endif

Use In Select("mwkTabSecRestric")
Use In Select("mwkTabInsRestriccion")
** ------------------------------------------------------
If lac
	If Used("mwkac")
		Select * From &ccursor Left Join mwkac On INSCodPuntero = Ins_codpuntero Into Cursor &ccursor
	Else
		mret = SQLExec(mcon1,"select Agru, Criterio,INSCodPuntero"+;
			" from Inscriteriosolic where Agru = 29 and criterio in (9,12,13,14,16,17)"+;
			" group by INSCodPuntero","mwkac")
		Select * From &ccursor Left Join mwkac On INSCodPuntero = Ins_codpuntero Into Cursor &ccursor
	Endif
Endif
