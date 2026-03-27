***********
*  busca tipo de componente
*********
mret =	sqlexec(mcon1,"select * from TabStTipoComp order by descr","mwktipoComp")
if mret<1
	=aerr(eros)
	messagebox(eros(2))
endif
