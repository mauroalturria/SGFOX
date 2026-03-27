****
** busco Ubicaciones
****

parameter mbusca
if type('mbusca')#"C"
	mbusca = ''
endif


mret = sqlexec(mcon1,"select ID,codubi, descrip, abrevio from TabHCUbica" + mbusca, "mwkThcubica")
if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif
