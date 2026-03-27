Lparameters tnCodServ

mret = sqlexec(mcon1,"select pre_descriprest, pre_codprest , pre_codservicio, " + ;
	"pre_especialidad, pre_duracion  " + ;
	"FROM prestacions " + ;
	"where pre_fechapasiva is null and " + ;
	"prestacions.pre_agendaturnos = 'S' and " + ;
	"pre_codservicio = ?tnCodServ " + ;
	"Order by pre_descriprest", "mwkPrestaServ")

If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
 	Return .f.
Endif  