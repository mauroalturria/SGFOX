****
** busco sectores
****
lparameters cwhere 
mret = sqlexec(mcon1, "SELECT ID,Codigo,Signo,TipoComp FROM DEPOSITOCOMPRO " + ;
			cwhere + " order by TipoComp", "mwkTMdep")
if mret < 0
	=aerr(eros)
	messagebox(eros(3)) 
endif	
