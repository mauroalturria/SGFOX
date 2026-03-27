*
* Busqueda log de movimientos Hosp. Dia Oncologico
*
Parameters mlid, mhistorico, mRegistrac

Use In Select("mwkloghdo")

If Vartype(mhistorico)<>"C"

	mhistorico= "N" && Log Normal

Endif

If mhistorico = "N"

	mret = SQLExec(mcon1,"select * from TabAmbOncoLog where TOL_idturno = ?mlid","mwkloghdo")

Else

	mret = SQLExec(mcon1,"select * from TabAmbOncoLog where TOL_idturno in "+;
		"(select TabAmbOnco.id as lid  from TabAmbOnco where TabAmbonco.TAO_Registracio = ?mRegistrac)", "mwkloghdo")

Endif

If mret < 0
	Messagebox("BUSQUEDA LOG HOSP. DE DIA ONCOLOGICO"+Chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

Return .T.
