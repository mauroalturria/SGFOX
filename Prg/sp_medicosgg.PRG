*****************************************************************
* Trae nombre y codigo de los médicos que se encuentran activos *
* y recibe un parametro que indica si lo quiero de ambulatorio, *
* internacion o guardia - el nombre del campo.                  *
*****************************************************************
Lparameters fechadia

If Type ('fechadia')#"D"
	mfecturno	= sp_busco_fecha_serv('DD')
Else
	mfecturno	= fechadia
Endif

mfecpasmsg = prg_dtoc(mfecturno)
mfecha2 	= Ctot('01/01/1900')
mfecpasms  = ' ( estado = 1 or fecpasiva > ?mfecturno )'

If Type ('mcdedonde ')#"C"
	mcdedonde = 'dambula'
Endif

If mcdedonde = 'dambula'
	mfecpas = ' estado = 1 or fecpasiva > ?mfecturno '
	mfecpasms = '  estado = 1 or fecpasiva > ?mfecturno or '+;
		'(dguardia= 1 and (fecpasivag = ?mfecha2  or fecpasivag > ?mfecturno))  '

	mfecpasaux = ' estado = 1 or fecpasiva > ?mfecturno '
	mfecpasmsaux = '  estado = 1 or fecpasiva > mfecturno or '+;
		'(dguardia= 1 and (fecpasivag = mfecha2  or fecpasivag > mfecturno))  '

Else
	mfecpas = ' fecpasivag = ?mfecha2  or fecpasivag > ?mfecturno '
	mfecpasaux = ' fecpasivag = ?mfecha2  or fecpasivag > ?mfecturno '
Endif

mfecha2 = Ctot('01/01/1900')

Use In Select("mwkMedicosall1")
Use In Select("mwkMMCompleto")

mret = SQLExec(mcon1,"SELECT prestadores.id, nombre ,TPF_filtro, fecpasivap, codprof, enreldep,  " + ;
	" estado, bloquedesde, bloquehasta, codesp, domicilio, email, telefono, telcelular, codloca,  " + ;
	" dguardia, dambula, fecpasiva, fecpasivag " + ;
	" FROM prestadores " + ;
	" Left join TabProfFiltro on Prestadores.id = TabProfFiltro.TPF_codmed " + ;
	" ORDER BY nombre", "mwkMMCompleto" )

If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

Select Id, nombre ,TPF_filtro,fecpasivap,codprof,enreldep ;
	From mwkMMCompleto ;
	into Cursor mwkMedicosall1 ;

*!*	-----------------------------------------------------------------------------------------------------
If Used("mwkMedico")
	Use In mwkMedico
Endif

Select Id, nombre, estado, bloquedesde, bloquehasta, ;
	codesp ,TPF_filtro, ;
	domicilio, email, telefono, telcelular, codloca, codprof, enreldep, fecpasivap  ;
	FROM mwkMMCompleto ;
	WHERE (fecpasivap = mfecha2 Or fecpasivap > mfecturno) ;
	and &mcdedonde = 1 And ( &mfecpasaux ) ;
	and Id > 1 ;
	ORDER By nombre ;
	into Cursor mwkMedico

*!*	-----------------------------------------------------------------------------------------------------

Use In Select("mwkmedsoli")

Select Id, nombre, estado, bloquedesde, bloquehasta ,TPF_filtro, codprof, enreldep, fecpasivap  ;
	From mwkMMCompleto ;
	WHERE (fecpasivap = mfecha2 Or fecpasivap > mfecturno) And &mfecpasmsaux ;
	ORDER By nombre ;
	into Cursor mwkmedsoli ;

*!*	-----------------------------------------------------------------------------------------------------
Use In Select("mwkMedicosall")

Select Id, nombre, TPF_filtro, fecpasivap, codprof, enreldep ;
	From mwkMMCompleto ;
	WHERE (fecpasivap = mfecha2 Or fecpasivap > mfecturno) And  &mcdedonde = 1 ;
	ORDER By nombre ;
	into Cursor mwkMedicosall;

*!*	-----------------------------------------------------------------------------------------------------
Use In Select("MWkmedBloq")

mret = SQLExec(mcon1,"SELECT codmed "+;
	" FROM tabbloqueoAmb  "+;
	" WHERE fvigenh >= ?mfecturno "+;
	" group by codmed ","MWkmedBloq")

If mret <= 0
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif
*!*	-----------------------------------------------------------------------------------------------------

Use In Select("mwkMMCompleto")


