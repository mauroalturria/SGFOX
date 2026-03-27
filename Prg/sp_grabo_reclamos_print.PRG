*!*	------------------------------------------------------------------------------------
*!*	Registro LOG de copias de impresiones / Proveedor de toner
*!*	------------------------------------------------------------------------------------
Lparameters mlmaq, mcopi, muser, mfech, midPuesto, mProv

mret = SQLExec(mcon1,"insert into TabStPrinter " + ;
	" (TSP_maquina, TSP_copias, TSP_idusuario, TSP_fechamov, TSP_idpuesto, TSP_PrvId) " + ;
	" values (?mlmaq, ?mcopi, ?muser, ?mfech, ?midPuesto, ?mProv) ")

If mret < 1
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif