*!*	sp_actualizo_TabGuaBalH (tnOpcion, tnId, tnentsal, ttfechaH, tnidevol, tcobserva, tntipo, tnusuario, tnvolumen)
Parameters tnOpcion, tnId, tnentsal, ttfechaH, tprotocolo, tcobserva, tntipo, tnusuario, tnvolumen,tnhora

Do Case
	Case tnOpcion = 1
		lcSql = "Insert into TabGuaBalH " + ;
			" (EB_entsal, EB_fechaH, EB_protocolo, EB_observa, EB_tipo, EB_usuario, EB_volumen,EB_hora) " + ;
			" Values " + ;
			" (?tnentsal, ?ttfechaH, ?tprotocolo, ?tcobserva, ?tntipo, ?tnusuario, ?tnvolumen,?tnhora) "

	Case tnOpcion = 2

		lcSql = "Update TabGuaBalH " + ;
			" Set EB_entsal = ?tnentsal, EB_fechaH = ?ttfechaH, EB_protocolo = ?tprotocolo,EB_hora= ?tnhora, " + ;
			"EB_observa = ?tcobserva, EB_tipo = ?tntipo, EB_usuario = ?tnusuario, EB_volumen = ?tnvolumen " + ;
			"Where id = ?tnId " 

	Otherwise

Endcase

if !Prg_EjecutoSql(lcSql,'',.f.)
	Return .f.
Endif 