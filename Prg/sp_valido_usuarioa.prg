***
*** Valido de usuario
***

parameter midusua, mpassw, mexe
lcErrorAnt = on("ERROR")
* ------------- Modificado 29/8/16 ----------------
If Vartype(mexe)#"C"
	mexe = ""
Endif
IF mexe#"PISOS" and mexe#"INCIDENTES"
	on error frmloguin1.mierror(error( ),message())
Endif
* -------------------------------------------------
mmail = LOWER(midusua)
mfecpas = ctod('01/01/1900')
mfechoy = sp_busco_fecha_serv('DD')
if mpassw = "*¿*¿*¿*¿"
	mret = sqlexec(mcon1, "select * from tabusuario " + ;
		"where (idusuario = ?midusua  ) " + ;
		" and fecpasiva = ?mfecpas ", "mwkusuario")
ELSE
*MESSAGEBOX("tabusuario")
	mret = sqlexec(mcon1, "select * from tabusuario " + ;
		"where (idusuario = ?midusua    ) "+;
		" and password = ?mpassw " + ;
		" and fecpasiva = ?mfecpas ", "mwkusuario")
endif
on error &lcErrorAnt
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	do sp_desconexion with "sp_valido_usuario"
	cancel
endif

if mwkusuario.fecexpira <= mfechoy
	if mwkusuario.diasaviso=ctod("01/01/2100")
		diasrestan = mfechoy+7
		mcodid = mwkusuario.id
		mret = sqlexec(mcon1, 'update tabusuario set diasaviso = ?diasrestan '  +;
			'where id = ?mcodid')
		mret = sqlexec(mcon1, "select * from tabusuario " + ;
			"where (idusuario = ?midusua  )"+;
			" and password = ?mpassw " + ;
			" and fecpasiva = ?mfecpas ", "mwkusuario")
	endif
endif

if !eof('mwkusuario')
	mcoduser  = mwkusuario.id
	mfecpas	  = ctod('01/01/1900')
	msql_sec2 = ''
	if !empty(mexe)
		mbusexe = 'nomexe = ?mexe and '
	else
		mbusexe = ''
	endif
**,launcher
*MESSAGEBOX("tabpermisosexe")
	mret = sqlexec(mcon1, "select nomexe,versionactual,launcher,versionminima,tabexe.id as idexe  " + ;
		"from tabpermisosexe, tabexe " + ;
		"where codusuario  = ?mcoduser and " + mbusexe + ;
		"tabpermisosexe.fecpasiva = ?mfecpas and " + ;
		"tabexe.fecpasiva = ?mfecpas and " + ;
		"codexe = tabexe.id " + ;
		"order by nomexe", "mwkexe")
	if mret < 0
		= aerr(eros)
		messagebox(eros(3))
	ENDIF
*	MESSAGEBOX("tabpermisosambito ")
	mret = sqlexec(mcon1, "select ambito, codambito,codusuario,tabambito.id " + ;
		"from tabpermisosambito , tabambito " + ;
		"where codambito = tabambito.id and " + ;
		"codusuario = ?mcoduser and tabpermisosambito.fecpasiva = ?mfecpas  " + ;
		" order by tabambito.id ", "mwkusuambito")   &&tabpermisosambito.fecpasiva = ?mfecpas

	do sp_busco_sectores with '', msql_sec2, 0, mcoduser
	&msql_sec2
ELSE
*	MESSAGEBOX("tabusuario ")
	mret = sqlexec(mcon1, "select * from tabusuario " + ;
		"where (idusuario = ?midusua  ) "+;
		" and password = ?mpassw " + ;
		" ", "mwkusuariobaja")
endif
&&OR codigovax = ?midusua OR nrodocumento= ?midusua OR Leg_ID = ?midusua