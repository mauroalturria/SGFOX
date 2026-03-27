*********************************************************************************
* Ejecuta el cursor de prestaciones, trae el codigo y la descripción ordenada *
* por descripción para listar combos                                            *
*********************************************************************************


mret = sqlexec(mcon1,"select pre_descriprest, pre_codprest , pre_codservicio, " + ;
	"pre_especialidad, pre_duracion " + ;
	"FROM prestacions, medpresta " + ;
	"where medpresta.codprest = prestacions.pre_codprest and " + ;
	"pre_fechapasiva is null and " + ;
	"(?mfecturno >= medpresta.fecvigend OR " + ;
	"?mfecturno < medpresta.fecvigend) and " + ;
	"?mfecturno <  medpresta.fecvigenh and " + ;
	"medpresta.codmed = ?mid_medico "+ ;
	"group by pre_descriprest " + ;
	"ORDER BY pre_descriprest", "mwkbustexto")
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	do sp_desconexion with "error"
	cancel
endif
