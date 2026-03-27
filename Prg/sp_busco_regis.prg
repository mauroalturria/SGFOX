*******
*** Busco los datos del quirofano de un paciente
*******
parameters mnroregistrac
mret = sqlexec(mcon1," select nroregistrac,estado  from Tabquirofano "+;
	"where nroregistrac  = ?mnroregistrac  " , "mwkBuscoNumReg")
if mret<1
	=aerr(eros)
	messagebox(eros(3)  )
endif
