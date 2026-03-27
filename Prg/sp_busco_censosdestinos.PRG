*
* Devuelve el contenido de la tabla censosdestinos
*
Lparameters mpasivados

If Vartype(mpasivados) <> "C"
	mpasivados = "N"
Endif

If mpasivados = "S"
	mfnull = Ctod("01/01/1900")
	mwhere = " where TCD_fechapasiva = ?mfnull"
Else
	mwhere = ""
Endif

mret = SQLExec(mcon1,"select * from TabCensosDestinos " + mwhere,"mwkcensosdestinos")

If mret < 0
	Messagebox("ERROR EN LA LECTURA DE CENSOS-DESTINOS",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

Return .T.
