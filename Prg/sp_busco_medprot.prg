*
* Busqueda de médicos que atendieron el protocolo solicitado
*
Parameters mprotocolo

Use in select("mwkProtocolo")

mret = SQLEXEC(mcon1,"select guardia.codmed from guardia "+;
	" where guardia.protocolo = ?mprotocolo and guardia.codmed > 1 "+;
	" union select TGD_medDer as codmed from TabGuaDeriv where TGD_protocolo = ?mprotocolo"+;
	" union select EGM_codmed as codmed from TabGuaEvolMed where EGM_proto = ?mprotocolo","mwkProtocolo")

If mret < 0
	Messagebox("EN CONSULTA DE MEDICOS PARA EL PROTOCOLO SOLICITADO"+chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
	Do log_errores with error(), message(), message(1), program(), lineno()
	Return .F.
Endif

Return .T.
