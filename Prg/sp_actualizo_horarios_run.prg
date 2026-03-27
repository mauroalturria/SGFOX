*
* Actualizo horario
*
Lparameters mserv,mdia,mdesde,mhasta

mret = sqlexec(mcon1,"update TabHorarios set TH_horaDesde = ?mdesde, TH_horaHasta = ?mhasta"+;
	" where TH_codserv = ?mserv and TH_tipoDia = ?mdia ")

If mret < 0
	Messagebox("EN ACTUALIZACION DE medico de cabecera"+chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
	Do log_errores with error(), message(), message(1), program(), lineno()
	Return .F.
Endif

Return .T.









