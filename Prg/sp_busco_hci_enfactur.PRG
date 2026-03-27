*
* Busqueda de HCI que fueron recibidas en facturación
*
Lparameters mdesde, mhasta

Use In Select("mwkctrladm")

mret = SQLExec(mcon1, "SELECT Pacientes.PAC_nombrepaciente, Pacientes.PAC_codadmision" +;
	" FROM Pacientes" +;
	" JOIN Tabhcilog on Tabhcilog.TLO_admision=Pacientes.PAC_codadmision and Tabhcilog.TLO_estado=18"+;
	" WHERE Pacientes.PAC_fechaalta >= ?mdesde"+;
	" AND Pacientes.PAC_fechaalta  <= ?mhasta"+;
	" GROUP BY Pacientes.PAC_codadmision","mwkctrladm")

If mret < 0
	Messagebox("BUSQUEDA DE H.C.I."+Chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

Return .T.
