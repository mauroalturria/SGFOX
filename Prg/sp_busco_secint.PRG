*
* Descripcion de sectores de internacion
*

Use in select("mwksecintd")
mret = sqlexec(mcon1,"select * from Tabsectorint"+;
	" where grupo < 2 and id < 100000"+;
	" order by descrip", "mwksecintd")

If mret < 0
	=Aerror(merror)
	Messagebox(merror(3))
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

Use in select("mwksecint")
mret = sqlexec(mcon1, "select * from tabsectorint"+;
	" where grupo = 0 and id < 100000"+;
	" order by descrip", "mwksecint")

If mret < 0
	=Aerror(merror)
	Messagebox(merror(3))
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

Return .T.
