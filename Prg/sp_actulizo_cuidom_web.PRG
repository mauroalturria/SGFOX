*
* Actualizo Cuidados Domiciliarios Web
*
Lparameters mlid, mpatolog, mresumen, mmsg, mmobs

mret = SQLExec(mconM,"update tbl_evolucion set "+;
	" patologia = ?mpatolog,"+;
	" resumenhc = ?mresumen,"+;
	" preindeqp = ?mmsg,"+;
	" observa   = ?mmobs"+;
	" where idsolicitud = ?mlid")

If mret < 0
	MTABLA = "CUIDADOS DOMICILIARIOS EVOLUCION WEB"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA " + MTABLA + Chr(10) + "AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Return .T.
