*
* Censos busqueda de destinatarios
*
Use In Select("mwkcensos")
mfnull = Ctod("01/01/1900")

*!*	mret = SQLExec(mcon1,"select * from TabCensosRel"+;
*!*	" where TCR_fechapasiva = ?mfnull order by TCR_iddestino","mwkcensos")

mret = SQLExec(mcon1,"select TabCensosRel.*, TabCensosDestinos.TCD_email as lmail, TabCensosDestinos.TCD_destino as ldestinomsg "+;
	" from TabCensosRel "+;
	" inner join TabCensosDestinos on TabCensosDestinos.id =  TabCensosRel.TCR_iddestino"+;
	" and TCD_fechapasiva = ?mfnull "+;
	" where TCR_fechapasiva = ?mfnull "+;
	" order by TCR_iddestino","mwkcensos")

If mret < 0
	MTABLA = "CENSOS DETINATARIOS"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Return .T.
