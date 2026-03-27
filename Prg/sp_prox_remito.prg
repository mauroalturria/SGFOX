****
** Obtengo proximo remito
****
mret = sqlexec(mcon1, "SELECT RemitoBono FROM TabDatos", "mwkremito")
mremito = mwkremito.RemitoBono +1
mret = sqlexec(mcon1, "update TabDatos set RemitoBono =?mremito ")
mret = sqlexec(mcon1, "SELECT RemitoBono FROM TabDatos", "mwkremito")

if mret<1
	=aerr(eros)
	Message(eros(3))
endif
