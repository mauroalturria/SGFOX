***
*** Valido de usuario
***

Parameter midusua, mpassw, mexe
lcErrorAnt = On("ERROR")
* ------------- Modificado 29/8/16 ----------------
If Vartype(mexe)#"C"
	mexe = ""
Endif
If mexe#"PISOS" And mexe#"INCIDENTES"
	On Error frmloguin1.mierror(Error( ),Message())
Endif
If myip='172.16.1.7'
*SET STEP ON
Endif
* -------------------------------------------------
Use In Select("mwkusuario")
Use In Select("mwkusuariobaja")

mmail = Lower(midusua)
mfecpas = Ctod('01/01/1900')
mfechoy = sp_busco_fecha_serv('DD')
If mpassw = "*¿*¿*¿*¿"
	mret = SQLExec(mcon1, "select * from tabusuario " + ;
		"where (idusuario = ?midusua OR codigovax = ?midusua OR nrodocumento= ?midusua OR Leg_ID = ?midusua  ) " + ;
		" and fecpasiva = ?mfecpas ", "mwkusuario")
Else
*MESSAGEBOX("tabusuario")
	mret = SQLExec(mcon1, "select * from tabusuario " + ;
		"where (idusuario = ?midusua ) "+;
		" and password = ?mpassw " + ;
		" and fecpasiva = ?mfecpas ", "mwkusuario")
	If Reccount( "mwkusuario")= 0
		mret = SQLExec(mcon1, "select * from tabusuario " + ;
			"where ( nrodocumento= ?midusua  ) "+;
			" and password = ?mpassw " + ;
			" and fecpasiva = ?mfecpas ", "mwkusuario")
		If Reccount( "mwkusuario")= 0
			mret = SQLExec(mcon1, "select * from tabusuario " + ;
				"where codigovax = ?midusua "+;
				" and password = ?mpassw " + ;
				" and fecpasiva = ?mfecpas ", "mwkusuario")
		Endif
		If Reccount( "mwkusuario")= 0
			mret = SQLExec(mcon1, "select * from tabusuario " + ;
				"where  Leg_ID = ?midusua "+;
				" and password = ?mpassw " + ;
				" and fecpasiva = ?mfecpas ", "mwkusuario")
		Endif
	Endif
Endif
On Error &lcErrorAnt
If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	Do sp_desconexion With "sp_valido_usuario"
	Cancel
Endif

If mwkusuario.fecexpira <= mfechoy
	If mwkusuario.diasaviso=Ctod("01/01/2100")
		diasrestan = mfechoy+7
		 
		mcodid = mwkusuario.Id
		mret = SQLExec(mcon1, 'update tabusuario set diasaviso = ?diasrestan '  +;
			'where id = ?mcodid')
		mret = SQLExec(mcon1, "select * from tabusuario " + ;
			"where id = ?mcodid  ", "mwkusuario")
	Endif
Endif

If !Eof('mwkusuario')
	mcoduser  = mwkusuario.Id
	mfecpas	  = Ctod('01/01/1900')
	msql_sec2 = ''
	If !Empty(mexe)
		mbusexe = 'nomexe = ?mexe and '
	Else
		mbusexe = ''
	Endif
**,launcher
*MESSAGEBOX("tabpermisosexe")
	mret = SQLExec(mcon1, "select nomexe,versionactual,launcher,versionminima,tabexe.id as idexe  " + ;
		"from tabpermisosexe, tabexe " + ;
		"where codusuario  = ?mcoduser and " + mbusexe + ;
		"tabpermisosexe.fecpasiva = ?mfecpas and " + ;
		"tabexe.fecpasiva = ?mfecpas and " + ;
		"codexe = tabexe.id " + ;
		"order by nomexe", "mwkexe")
	If mret < 0
		= Aerr(eros)
		Messagebox(eros(3))
	Endif
*	MESSAGEBOX("tabpermisosambito ")
	mret = SQLExec(mcon1, "select ambito, codambito,codusuario,tabambito.id " + ;
		"from tabpermisosambito , tabambito " + ;
		"where codambito = tabambito.id and " + ;
		"codusuario = ?mcoduser and tabpermisosambito.fecpasiva = ?mfecpas  " + ;
		" order by tabambito.id ", "mwkusuambito")   &&tabpermisosambito.fecpasiva = ?mfecpas

	Do sp_busco_sectores With '', msql_sec2, 0, mcoduser
	&msql_sec2
Else
*	MESSAGEBOX("tabusuario ")
	mret = SQLExec(mcon1, "select * from tabusuario " + ;
		"where (idusuario = ?midusua ) "+;
		" and password = ?mpassw " + ;
		"  ", "mwkusuariobaja")
	If Reccount( "mwkusuario")= 0
		mret = SQLExec(mcon1, "select * from tabusuario " + ;
			"where ( nrodocumento= ?midusua  ) "+;
			" and password = ?mpassw " + ;
			" ", "mwkusuariobaja")
		If Reccount( "mwkusuario")= 0
			mret = SQLExec(mcon1, "select * from tabusuario " + ;
				"where codigovax = ?midusua "+;
				" and password = ?mpassw " + ;
				"  ", "mwkusuariobaja")
		Endif
		If Reccount( "mwkusuario")= 0
			mret = SQLExec(mcon1, "select * from tabusuario " + ;
				"where  Leg_ID = ?midusua "+;
				" and password = ?mpassw " + ;
				"  ", "mwkusuariobaja")
		Endif


	Endif
endif