*********************************************************************************
* Ejecuta el cursor de prestaciones, trae el codigo y la descripción ordenada *
* por descripción para listar combos                                            *
*********************************************************************************

mret = sqlexec(mcon1,"select pre_descriprest, pre_codprest , pre_codservicio, " + ;
	"pre_especialidad, pre_duracion " + ;
	"FROM prestacions " + ;
	"where pre_fechapasiva is null and pre_agendaturnos = 'S' " + ;
	"group by pre_codprest " + ;
	"", "mwkpresta")
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	do sp_desconexion with "error"
	cancel
endif
