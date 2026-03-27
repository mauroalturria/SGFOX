*
* Busco GTIN previamente Trazado por el WS, paso ID del Maestro CACHE
*
Lparameters mlid

Use In Select("mwkctrltra")
lcErrorAnt = On("ERROR")

mret = SQLExec(mcon1,"select * from TabTraMov"+;
	" where id = ?mlid","mwkctrltra")

If mret < 0
	Messagebox("Error al Consulta del GTIN",26,"Error")
	On Error Do log_errores With Error(), Message(), Message(1), Program(), Lineno()

	On Error &lcErrorAnt
	Return .F.
Else
	On Error &lcErrorAnt
Endif


Return .T.

