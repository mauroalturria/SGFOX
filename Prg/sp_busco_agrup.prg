****
** busco agrupamientos
****

parameter mbusca
if type('mbusca')#"C"
	mbusca = ''
endif
mret = sqlexec(mcon1,"select ID,TNA_CodAgr,TNA_Descripcion from TabNutagr " + mbusca + ;
	" order by TNA_CodAgr"  , "mwkTNagr")
if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif