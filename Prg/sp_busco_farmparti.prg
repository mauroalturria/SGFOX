*
* Busqueda de Partida
*
Lparameters mlparti

Use in select("mwkclparti")

mret = sqlexec(mcon1,"select * from TabFarmCitosP"+;
	" where TCP_partida = ?mlparti","mwkclparti")

If mret < 0
	Messagebox("EN BUSQUEDA MAESTRO PARTIDAS",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

Return .T.
