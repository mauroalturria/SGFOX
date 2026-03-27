*****
**  busco telefonos de profesionales
*****

parameter msql_age

mfecnull 	= ctod('01/01/1900')
diadehoy = sp_busco_fecha_serv("DD")-7
mret = SQLExec(mcon1,"SELECT nombre, ESP_descripcion, telefono, telcelular, " + ;
	"telradio, codesp, id " + ;
	"FROM prestadores, especialid " + ;
	"WHERE (fecpasivap= ?mfecnull or fecpasivap>?diadehoy ) and " + ;
	"trim(codesp) = trim(ESP_codesp) and id > 1 "	+ ;
	"ORDER BY nombre", "mwkMedtel" )

msql_age = "select nombre, ESP_descripcion, iif(empty(telcelular),"+;
	" telefono, telcelular) as telcelular, " + ;
 	" telradio, codesp, id " + ;
	" from mwkmedtel where id <> 306 into cursor mwkagenda"
