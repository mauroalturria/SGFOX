*
* Guardia lee reversión estado del protocolo
*
Parameters mlproto,mbusco
If Vartype(mbusco)<>"C"
	mbusco = ''
Endif
mret = SQLExec(mcon1,"select * from TabGuaCtrlLog"+;
	" where TGL_protocolo = ?mlproto "+ mbusco, "mwkctrrever")

If mret < 0
	Messagebox("EN EL REGISTRO DEL LOG DE MOVIMIENTO"+Chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

Return .T.



