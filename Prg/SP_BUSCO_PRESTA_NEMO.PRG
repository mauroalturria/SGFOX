****
** busco prestaciones por servicio y nemonico
****

parameter mcodserv

mret = sqlexec(mcon1,"select pre_descriprest, pre_codprest , pre_codservicio, " + ;
	"pre_especialidad, pre_duracion, ser_descripserv " + ;
	"FROM prestacions, servicios " + ;
	"where pre_fechapasiva is null and " + ;
	"pre_automatica <> 'S' and " + ;
	"pre_codservicio = ser_codserv and " + ;
	"pre_codservicio = ?mcodserv " + ;
	"group by pre_codprest " + ;
	"ORDER BY pre_codprest", "mwkbustexto")
