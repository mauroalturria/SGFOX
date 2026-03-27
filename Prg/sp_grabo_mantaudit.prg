PARAMETERS mfechaasig,midot,mEstado,mcomentario

	mret = sqlexec(mcon1,"insert into Tabmantaudit(fechaasig,idot,IdEstado,comentario) "+;
	"values(?mfechaasig,?midot,?mEstado,?mcomentario)")
	if mret < 1 
		=aerr(eros)
		messagebox('ERROR EN EL INGRESO, REINTENTE O AVISE A SISTEMAS', 64,'Validacion')	
	endif