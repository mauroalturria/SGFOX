*** busqueda de prestaciones madre - hija
Lparameters  xmcodprest, xmcodentag
If xmcodprest>0
	mret = SQLExec(mcon1, "select TWP_codent,  TWP_CodPrestP,pre_descriprest from Tabwprestacrel,prestacions " + ;
		" where TWP_CodPrestP = pre_codprest and TWP_codent = ?xmcodentag  and TWP_CodPrestH= ?xmcodprest  and " + ;
		" TWP_FecPasiva = '1900-01-01' and CodAmbito = ?mxambito  ", "mwkprestPrevia")
Else
	mret = SQLExec(mcon1, "select TWP_codent,  TWP_CodPrestP,pre_descriprest from Tabwprestacrel,prestacions " + ;
		" where TWP_CodPrestP = pre_codprest and TWP_CodPrestH= ?xmcodprest  and " + ;
		" TWP_FecPasiva = '1900-01-01' and CodAmbito = ?mxambito  ", "mwkprestPrevia")
Endif
If mret < 0
	Messagebox("ERROR EN LA LECTURA DE INCIDENTES DE SEGURIDAD",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

