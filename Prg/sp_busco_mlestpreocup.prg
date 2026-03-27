
mret = SQLEXEC(mcon1," select * from TabMlEstPreocup " , "mwkEstPreocup")
if mret < 0
	=aerr(eros)
	messagebox(eros(3))
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif