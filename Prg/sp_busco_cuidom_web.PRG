*
* Busco en Web la solicitud de Cuidados Domiciliarios
*
Lparameters mlid

Use In Select("mwkctrl6")
mret = SQLExec(mconM,"select id as lid,patologia,resumenhc,preindeqp,observa"+;
	" from tbl_evolucion"+;
	" where idsolicitud = ?mlid and estado = 1","mwkctrl6")

If mret < 0
	MTABLA = "CUIDADOS DOMICILIARIOS EVOLUCIONES WEB"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Return .T.
