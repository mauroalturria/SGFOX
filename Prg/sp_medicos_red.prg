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

if type ('mcdedonde ')#"C"
	mcdedonde = 'dambula'
endif

if mcdedonde = 'dambula'
	mfecpas = ' estado = 1 or fecpasiva > ?mfecturno '
	mfecpasms = '  estado = 1 or fecpasiva > ?mfecturno or '+;
		'(dguardia= 1 and (fecpasivag = ?mfecha2  or fecpasivag > ?mfecturno))  '
else
	mfecpas = ' fecpasivag = ?mfecha2  or fecpasivag > ?mfecturno '
endif

mfecha2 	= ctot('01/01/1900')

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