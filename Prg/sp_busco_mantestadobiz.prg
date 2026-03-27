
mret = sqlexec(mcon1, "select cast(0 as integer ) as elegido , descrip,id,codest "+;
" from TabMantest where descrip<>''  ", "mwkEstado")

if mret < 0
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif