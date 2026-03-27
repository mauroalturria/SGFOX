************
*	Grabo ???
*************
parameters midcomp, midpuesto,mabm

if mabm = 1
	mret =	sqlexec(mcon1," SELECT * from tabStDetPuesto where idComp = ?midComp and idpuesto = ?mIdPuesto ", "mwkValidPresu")
	if reccount('mwkValidPresu') > 0
		return
	endif
	mret =	sqlexec(mcon1," INSERT into tabStDetPuesto (idComp,idpuesto) VALUES (?midComp, ?mIdPuesto )")
endif
if mabm = 3
	mret =	sqlexec(mcon1," delete from tabStDetPuesto where idComp = ?midComp and idpuesto = ?mIdPuesto ")
endif
if mret<1
	=aerr(eros)
	messagebox(eros(2))
endif
