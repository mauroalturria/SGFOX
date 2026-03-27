****
** busco prestaciones por servicio 8000
****

parameter mcodmed

mret = sqlexec(mcon1,"select pre_descriprest, pre_codprest , pre_codservicio, " + ;
	"pre_especialidad, pre_duracion, ser_descripserv,Pre_retiroestudios  " + ;
	",pre_duracion as PA_duracion, "+;
	" Pre_retiroestudios as PA_retiroestudios "+;
		',PRE_EdadDesde, PRE_EdadHasta '+;
	"FROM prestacions, servicios " + ;
	"where pre_codservicio = ser_codserv and " + ;
	"pre_codservicio in (8000) and pre_fechapasiva is null " + ;
	"group by pre_codprest " + ;
	"ORDER BY pre_codprest", "mwkbustexto")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 48, "Validacion")
	cancel
endif
