parameters midPuesto


mret =	sqlexec(mcon1," select descr,idComp,idpuesto,tipocomp->descr as tipocomp,tabStDetPuesto.id"+;
	"  from tabStDetPuesto " +;
	" left join tabStComponente on tabStComponente.id = tabStDetPuesto.idComp " +;
	" where idpuesto = ?midPuesto ","mwkDetPuesto")

if mret<1
	=aerr(eros)
	messagebox(eros(2))
endif

