***
*** Busco centros medicos
***

mret = SQLExec(mcon1, "select * "+;
	" from Tabctromedico where activo = 1 " , "mwkambitoCM")
If mret < 0
	Do log_errores With Error(), Message(),'Tabctromedico ', Program(), Lineno()

Endif
