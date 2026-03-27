****
** BUSCA PACIENTES PREREGISTRADOS
****
Parameter mnrodoc

mret = sqlexec(mcon1,"select * from preregistra " + ;
	"where nrodocumento = ?mnrodoc and " + ;
	"nroregistracio is null" , "mwkencontrado")

If mret < 0
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	Do prg_cancelo
Endif

