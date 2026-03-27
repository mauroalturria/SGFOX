PARAMETERS lcWhere

mret =	sqlexec(mcon1,"select * from tabStPuesto " + lcwhere,"mwkResuPuesto")
if mret<1
	=aerr(eros)
	messagebox(eros(2))
endif
