*
* Actualizo solicitud de interconsulta
*
Lparameters mestado,mfecnull,mubicaci,mlid

mret = sqlexec(mcon1,"update TabGuaIC set"+;
	" TGI_estado = ?mestado, TGI_horaFin = ?mfecnull, TGI_ubicacion = ?mubicaci"+;
	" where id = ?mlid")

If mret < 0
	Messagebox("EN ACTUALIZACION DE LA SOLICITUD DE INTERCONSULTA"+chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
	Do log_errores with error(), message(), message(1), program(), lineno()
	Return .F.
Endif

Return .T.









