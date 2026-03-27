PARAMETERS mid 

lcWhere = IIF(EMPTY(mid ),''," where id =?mid ")
mret =	sqlexec(mcon1,"select * from tabstmod  " +lcwhere +" order by descr  ","mwkMod")
if mret<1
	=aerr(eros)
	messagebox(eros(2))
endif
