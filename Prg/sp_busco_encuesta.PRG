*
* Busqueda de encuetas
*
Lparameters mproto

Use in select("mwkencues")

mret = sqlexec(mcon1,"select * from TabEncuestas"+;
	" where TEC_protocolo = ?mproto","mwkencues")

If mret < 0
	Messagebox("ERROR EN LA LECTURA DE ENCUESTAS",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

Return .T.
