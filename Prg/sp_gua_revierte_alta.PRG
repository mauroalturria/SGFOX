*
* Guardia reversión estado del protocolo
*
Parameters mlhoracie, mlmedico, mlestant, mlestact, mlproto

mret = sqlexec(mcon1,"insert into TabGuaCtrlLog"+;
	"(TGL_horaCierreant,TGL_codmed,TGL_estant,TGL_estact,TGL_protocolo)"+;
	" values "+;
	"(?mlhoracie,?mlmedico,?mlestant,?mlestact,?mlproto)")

If mret < 0
	Messagebox("EN EL REGISTRO DEL LOG DE MOVIMIENTO DE REVERSION DEL ESTADO"+chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
	Do log_errores with error(), message(), message(1), program(), lineno()
	Return .F.
Endif

Return .T.



