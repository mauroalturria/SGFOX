*****************************************************************
* Trae nombre y codigo de los médicos que se encuentran activos *
* y recibe un parametro que indica si lo quiero de ambulatorio, *
* internacion o guardia - el nombre del campo.                  *   
*****************************************************************
PUBLIC MCON1
do sp_conexion

mret = SQLExec(mcon1,"SELECT nombre, estado, bloquedesde, bloquehasta, " + ;
					"codpostal, cuil, esp_descripcion, codesp, " + ;
					"dambula, dguardia, dinterna, domicilio, fecalta, fecpasiva, " + ;
					"fecaltag, fecpasivag, fecaltai, fecpasivai, " + ;
					"fecnac, matriculas, telcelular, telefono, tabpcia.descrip as pcia, " + ;
					"tabloca.descrip as loca, tabprofesion.descrip as profesion, " + ;
					"tabestudios.descrip as estudios, email " + ; 	
					"FROM prestadores, tabloca, tabpcia, especialid, tabprofesion, tabestudios " + ;
				    "WHERE codesp = trim(esp_codesp) and codloca = tabloca.id and " + ;
				   	"codpcia = tabpcia.id and coduniv = tabestudios.id and " + ;
				    "codprof = tabprofesion.id order by nombre", "mwkMedico" )

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
endif	

=sqldisconnect(mcon1)


