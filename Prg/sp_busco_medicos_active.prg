*****
**  busco profesionales
*****

lparameter ltodos

mfecha2 	= ctot('01/01/1900')
mhoy        =sp_busco_fecha_srv2('DD')
if vartype(ltodos)#"N"
	ltodos=0
endif
if   ltodos = 1
	mret = sqlexec(mcon1,"SELECT nombre, id,matriculas,codesp " + ;
		"FROM prestadores " + ;
		"WHERE id > 1 "	+ ;
		"ORDER BY nombre", "mwkmedicos" )
else

	mret = sqlexec(mcon1,"SELECT nombre, id,matriculas,codesp " + ;
		"FROM prestadores " + ;
		"WHERE estado = 1 and (fecpasiva >?mhoy or fecpasiva = ?mfecha2)" +;
		"and id > 1 "	+ ;
		"ORDER BY nombre", "mwkmedicos" )
endif
if mret <0
	messagebox('ERROR DE CURSOR',13,'validacion')
	cancel
	mret=0
endif
