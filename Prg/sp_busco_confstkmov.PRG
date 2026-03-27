*
* Busco Conforme de Recepción x ID Cabecera
*
Lparameters mbusca

Use in select("mwkbcnfcab")

mret = sqlexec(mcon1,"Select * from STOCKMOVIMCABE"+;
	" Where codmov = 'CR' "+;
	" And NROMOV = ?mbusca","mwkbcnfcab")

If mret < 0
	Messagebox("ERROR EN CONSULTA ID REGISTRO DE MOVIMIENTO DE STK CABECERA",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

Return .T.


