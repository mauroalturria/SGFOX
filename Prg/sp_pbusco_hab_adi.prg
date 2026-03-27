mret = sqlexec(mcon1, "SELECT id,descrip,subestado as precio from tabestados where id in (23,24,25)"  , "mwkHabAdicio")

if mret < 0
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif