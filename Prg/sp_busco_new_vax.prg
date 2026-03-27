****
** busco codigo vax
****
mret = sqlexec(mcon1, "SELECT newvax FROM TabDatos ", "mwknewvax")
if mret<1
	=aerr(eros)
	Message(eros(3))
endif
