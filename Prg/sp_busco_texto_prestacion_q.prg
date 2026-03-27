*********************************************************************************
* Ejecuta el cursor de prestaciones, trae el codigo y la descripción ordenada *
* por descripción para listar combos                                            *
*********************************************************************************
lparameters mctexto
mret = sqlexec(mcon1,"select pre_descriprest, pre_codprest , pre_codservicio, " + ;
	"pre_especialidad, pre_duracion, ser_descripserv " + ;
	"FROM prestacions left join servicios on prestacions.pre_codservicio = servicios.ser_codserv  "  + ;
	"where pre_fechapasiva is null and " + ;
	"pre_descriprest LIKE '%&mctexto%' and ser_descripserv like '%CIRUGIA%' " + ;
	"group by pre_codprest " + ;
	"ORDER BY pre_codprest", "mwkbustexto")
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	do prg_cancelo
endif


*						"pre_automatica <> 'S' and " + ;

