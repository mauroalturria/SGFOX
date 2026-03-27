****
** busco ingredientes
****

parameter mbusca
if type('mbusca')#"C"
	mbusca=''
endif
mret = sqlexec(mcon1,"select * from TabNutIngr " + mbusca + ;
	" order by TN_Ingrediente " , "mwkTNIngr")
