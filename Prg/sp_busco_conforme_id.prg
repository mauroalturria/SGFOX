*
* Busco ID conforme de Recepción de un remito Interno de Proveedor
*
Lparameters mbusca

Use in select("mwkidcab")

mret = sqlexec(mcon1,"select id as lidcab from TabMovCab"+;
	" where TMC_remitopro = ?mbusca","mwkidcab")

If mret < 0
	Messagebox("ERROR EN CONSULTA ID REGISTRO DE MOVIMIENTO DE RECEPCION CABECERA",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

Return .T.
