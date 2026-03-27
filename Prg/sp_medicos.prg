*****************************************************************
* Trae nombre y codigo de los médicos que se encuentran activos *
* y recibe un parametro que indica si lo quiero de ambulatorio, *
* internacion o guardia - el nombre del campo.                  *
*****************************************************************
lparameters fechadia

if type ('fechadia')#"D"
	mfecturno	= sp_busco_fecha_serv('DD')
else
	mfecturno	= fechadia
endif

mfecpasmsg = prg_dtoc(mfecturno)
mfecha2 	= ctot('01/01/1900')
mfecpasms  = ' ( estado = 1 or fecpasiva > ?mfecturno )'

if vartype (mcdedonde)#"C"
	mcdedonde = 'dambula'
endif
mcdedonde = IIF(EMPTY(mcdedonde),'dambula',mcdedonde )
if mcdedonde = 'dambula'
	mfecpas = ' estado = 1 or fecpasiva > ?mfecturno '
	mfecpasms = '  estado = 1 or fecpasiva > ?mfecturno or '+;
		'(dguardia= 1 and (fecpasivag = ?mfecha2  or fecpasivag > ?mfecturno))  '
else
	mfecpas = ' fecpasivag = ?mfecha2  or fecpasivag > ?mfecturno '
endif

mfecha2 	= ctot('01/01/1900')

*!*	-----------------------------------------------------------------------------------------------------
if used("mwkMedico")
	use in mwkMedico
endif
	
mret = SQLExec(mcon1,"SELECT prestadores.id, nombre, estado, bloquedesde, bloquehasta,"+;
	" prestadores.codesp ,TPF_filtro, " + ;
	" domicilio, email, telefono, telcelular, codloca,codprof,enreldep,fecpasivap  "+; 
	" FROM prestadores " + ;
	" Left join TabProfFiltro on Prestadores.id = TabProfFiltro.TPF_codmed " + ;
	" WHERE (fecpasivap = ?mfecha2 or fecpasivap > ?mfecturno) "+;
	" and &mcdedonde = 1 and ( &mfecpas ) " + ;
	" and prestadores.id > 1 ORDER BY nombre ", "mwkMedico" )

if mRet <= 0
	do log_errores with error(), message(), message(1), program(), lineno()
	return .f.
endif
*!*	mret = SQLExec(mcon1,"SELECT id, nombre, estado, bloquedesde, bloquehasta " + ;
*!*					   "FROM prestadores WHERE (&mfecpas ) " + ;
*!*					   "ORDER BY nombre", "mwkmedsoli" )

*!*	-----------------------------------------------------------------------------------------------------
if used("mwkmedsoli")
	use in mwkmedsoli
endif

mret = SQLExec(mcon1,"SELECT prestadores.id, nombre, estado, bloquedesde, bloquehasta ,TPF_filtro,codprof,enreldep,fecpasivap  " + ;
	" FROM prestadores " + ;
	" Left join TabProfFiltro on Prestadores.id = TabProfFiltro.TPF_codmed " + ;
	"  WHERE (fecpasivap = ?mfecha2 or fecpasivap > ?mfecturno) and "+ mfecpasms  + ;
	" ORDER BY nombre", "mwkmedsoli" )

if mRet <= 0
	do log_errores with error(), message(), message(1), program(), lineno()
	return .f.
endif

*!*	-----------------------------------------------------------------------------------------------------
if used("mwkMedicosall")
	use in mwkMedicosall
endif

mret = SQLExec(mcon1,"SELECT prestadores.id, nombre ,TPF_filtro,fecpasivap,codprof,enreldep  " + ;
	" FROM prestadores " + ;
	" Left join TabProfFiltro on Prestadores.id = TabProfFiltro.TPF_codmed " + ;
	" WHERE (fecpasivap = ?mfecha2 or fecpasivap > ?mfecturno) and  &mcdedonde = 1 ORDER BY nombre", "mwkMedicosall" )

if mRet <= 0
	do log_errores with error(), message(), message(1), program(), lineno()
	return .f.
endif

*!*	-----------------------------------------------------------------------------------------------------
if used("mwkMedicosall1")
	use in mwkMedicosall1
endif

mret = SQLExec(mcon1,"SELECT prestadores.id, nombre ,TPF_filtro,fecpasivap,cuil,dni,codprof,enreldep  " + ;
	" FROM prestadores " + ;
	" Left join TabProfFiltro on Prestadores.id = TabProfFiltro.TPF_codmed " + ;
	" ORDER BY nombre", "mwkMedicosall1" )

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	do log_errores with error(), message(), message(1), program(), lineno()
	do sp_desconexion with "Err sp_medicos"
	cancel
else

*!*	-----------------------------------------------------------------------------------------------------
	if used("MWkmedBloq")
		use in MWkmedBloq
	endif

	mret =SQLExec(mcon1,"SELECT codmed "+;
		" FROM tabbloqueoAmb  "+;
		" WHERE fvigenh >= ?mfecturno "+;
		" group by codmed ","MWkmedBloq")

	if mRet <= 0
		do log_errores with error(), message(), message(1), program(), lineno()
		return .f.
	endif
*!*	-----------------------------------------------------------------------------------------------------

*	SELECT id, nombre FROM mwkmedicos ORDER BY nombre into cursor mwkmedsoli
*	select mwkmedicos
*	use

endif
