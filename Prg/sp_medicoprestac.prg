*****************************************************************
* Esta rutina ejecuta el cursor de médicos que tienen 
* prestaciones ya asignadas, recibe como variables el 
* codigo del médico,especialidad, prestacion, Día de la semana
* hora desde y hasta disponibles del médico
*****************************************************************
*do sp_conexion.prg

mret=sqlexec(mcon1,"Select * From medpresta",'MWKmedpresta')

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	mret=0
	CANCEL

endif	