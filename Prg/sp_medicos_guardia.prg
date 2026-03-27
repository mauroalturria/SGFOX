*****************************************************************
* Trae nombre y codigo de los médicos que se encuentran activos *
* y recibe un parametro que indica si lo quiero de ambulatorio, *
* internacion o guardia - el nombre del campo.                  *
*****************************************************************

parameter mcdguardia, mcdinterna, mcprof
mfecturno	= ttod(mwkfecserv.fechahora)
mfecha2 	= ctot('01/01/1900')
if type ('mcprof')#"C"
	mcprof = ''
endif

mret = sqlexec(mcon1,"SELECT prestadores.id, nombre, estado, bloquedesde, bloquehasta, mensaje ,codprof,dguardia,codesp, TPF_filtro " + ;
	" FROM Prestadores " + ;
	" Left join TabProfFiltro on Prestadores.id = TabProfFiltro.TPF_codmed " + ;
	" left outer join tabmensaje on "+;
	"	prestadores.id = tabmensaje.codmed and " + ;
	"	tabmensaje.fecbaja = ?mfecha2 " + ;
	"WHERE (fecpasivap = ?mfecha2 or fecpasivap > ?mfecturno) and (&mcdguardia = 1  or &mcdinterna = 1) and " + ;
	"(fecpasivag = ?mfecha2 or fecpasivag > ?mfecturno) " + mcprof +;
	"ORDER BY nombre", "mwkMedico" )

mret = sqlexec(mcon1,"SELECT Prestadores.id, nombre,TPF_filtro " + ;
	" FROM Prestadores " + ;
	" Left join TabProfFiltro on Prestadores.id = TabProfFiltro.TPF_codmed " + ;
	"ORDER BY nombre", "mwkMedicosall1" )

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	do sp_desconexion with "Err sp_medicos_guardia"
	cancel

endif
