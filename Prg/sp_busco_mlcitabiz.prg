PARAMETERS mfechad,mfechah

mret = SQLEXEC(mcon1," select * from TabMlCita "+;
 "where CitaFecha >=?mfechad and CitaFecha <=?mfechaH  and CitaEstado = 1 ", "mwkCitaBiz")
if mret < 0
	=aerr(eros)
	messagebox(eros(3))
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif