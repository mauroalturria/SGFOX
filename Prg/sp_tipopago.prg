
mret = sqlexec(mcon1, "select * from tabpcpago", "mwkTipPago")

if mret < 0
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif
	