PARAMETERS midUsuario
mret = sqlexec(mcon1, "select CodigoVax,codsector from "+;
" TabMantDetSector where codsector = ?msector  ", "mwkEstxUsuario")

if mret < 0
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif