****
** Busco Condiciones de Pago
****

mret = sqlexec(mcon1, "SELECT * FROM SQLUser.TabPCPago " , "mwkcdp")
if mret < 0
	=aerr(eros)
	messagebox(eros(3))
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif