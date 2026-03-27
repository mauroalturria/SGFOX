lparameters mwhere
if vartype(mwhere)#"C"
	mwhere= ''
endif
use in select("mwkProc")
mret = sqlexec(mcon1,"Select  * from TabGcProc where tipo <> 9 "+mwhere+" order by codigoproc " ,"mwkProc")

if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	mret=0
	cancel
endif
