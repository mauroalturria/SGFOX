**Parameters tcset,tnidreg
Parameters tcset,mWhere

** mret = SQLExec(mcon1,"UPDATE tabpacobitoalta SET "+ tcset + "WHERE %id = ?tnidreg")
mret = SQLExec(mcon1,"UPDATE TabAltaPac SET "+ tcset + "WHERE" +mWhere)

If mret < 1
	Messagebox("ERROR AL ACTUALIZAR DATOS, INTENTE NUEVAMENTE",64,"SISTEMAS")
	Do Log_errores With Error(), Message(), Message(1)
	Return .F.
Endif
