Lparameters tcWhere, tcNomCur

If Vartype(tcWhere) # "C"
	tcWhere = ""
Endif 	

If Vartype(tcNomCur) # "C"
	tcNomCur = "mwkPrestEnt"
Endif 	

mret = Sqlexec(mcon1,"SELECT * FROM TabPrestEnt " + tcWhere,"mwkPrestEnt")

If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA - CONTROL TURNOS",48,"VALIDACION")
	Return .f.
Endif 	