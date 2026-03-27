*
* Armo cursores cabecera/detalle, Rutnia Mumps Recepcion de Materiales
*
Lparameters mlidcabe

Use in select("mwkcabe")
Use in select("mwkdeta")

mret = sqlexec(mcon1,"select * from TabMovCab where id = ?mlidcabe","mwkcabe")

If mret < 0
	Messagebox("ERROR EN CONSULTA DE MOVIMIENTO DE RECEPCION CABECERA",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

mret = sqlexec(mcon1,"select * from TabMovDet where TMD_idmcab = ?mlidcabe","mwkdeta")

If mret < 0
	Messagebox("ERROR EN CONSULTA DE MOVIMIENTO DE RECEPCION DETALLE",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

Return .T.
