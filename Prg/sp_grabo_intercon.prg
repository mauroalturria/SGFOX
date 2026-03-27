*
* Grabo solicitud de interconsulta
*
lparameters mcodmed,mcodprest,mestado,mfecnull,mprot_aux,mprotoco,mubicaci

&& Alta de interconsulta con protocolo auxiliar
horaact = sp_busco_fecha_serv('DT')
fechaact = ttod(horaact)
mret = sqlexec(mcon1,"select id from TabGuaIC "+;
	"where TGI_protocolo = ?mprotoco and TGI_codprest= ?mcodprest","mwkinterid")
if 	reccount("mwkinterid")=0

	mret = sqlexec(mcon1,"insert into TabGuaIC"+;
		" (TGI_codmed,TGI_codprest,TGI_estado,TGI_fechaSol,TGI_horaFin,TGI_horaSol,TGI_protocolo,TGI_ubicacion)"+;
		" values "+;
		" (?mcodmed,?mcodprest,1,?fechaact,?mfecnull,?horaact,?mprot_aux,?mubicaci)")

	if mret < 0
		messagebox("EN EL REGISTRO DE LA SOLICITUD DE INTERCONSULTA"+chr(10)+;
			"AVISE A SISTEMAS",16, "ERROR")
		do log_errores with error(), message(), message(1), program(), lineno()
		return .f.
	endif

&& Busqueda de ID de la interconsulta cargada

	use in select("mwkinterid")

	mret = sqlexec(mcon1,"select id as lid from TabGuaIC where TGI_protocolo = ?mprot_aux","mwkinterid")

	if mret < 0
		messagebox("EN LA CONSULTA DE SOLICITUDES DE INTERCONSULTA"+chr(10)+;
			"AVISE A SISTEMAS",16, "ERROR")
		do log_errores with error(), message(), message(1), program(), lineno()
		return .f.
	endif

	select mwkinterid
	go top

	mlid = mwkinterid.lid

&& Actualizacion por el protocolo original

	mret = sqlexec(mcon1,"update TabGuaIC set TGI_protocolo = ?mprotoco where id = ?mlid")

	if mret < 0
		messagebox("EN LA ACTUALIZACION DE PROTOCOLO, SOLICITUDES DE INTERCONSULTA"+chr(10)+;
			"AVISE A SISTEMAS",16, "ERROR")
		do log_errores with error(), message(), message(1), program(), lineno()
		return .f.
	endif

	return .t.
else
	use in select("mwkinterid")
endif








