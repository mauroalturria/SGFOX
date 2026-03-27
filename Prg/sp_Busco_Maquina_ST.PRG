Parameters lcWhere

If used('mwkResuPuesto')
	Use in mwkResuPuesto
Endif

mret =	sqlexec(mcon1,"select * from tabStPuesto " + lcWhere,"mwkResuPuesto")
If mret<1
	=aerr(eros)
	Messagebox(eros(2))
Endif
