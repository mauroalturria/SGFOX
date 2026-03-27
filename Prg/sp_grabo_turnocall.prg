*****************
* graba datos de la llamada al paciente por cambio de turno
***************

lparameters mcodreserva,mfechacall,mestado,mobserva,musuario

mret = SQLEXEC(mcon1," insert into Turnoscall (codreserva,fechacall,estado,observa,usuario) "+;
	" values(?mcodreserva,?mfechacall,?mestado,?mobserva,?musuario) ")

if mret < 0
	messagebox("ERROR AL CREAR EL CURSOR, AVISAR A SISTEMAS", 16, "Validación")
endif

