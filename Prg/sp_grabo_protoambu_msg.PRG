*
* Ambulatorio, grabar datos de la llamada al paciente por cambio de turno
*
Lparameters mfecha, mcmed, mesta, mobserv, mproto, mcusu, mestact

If  vartype(mestact)#"N"
	mestact = 0 &&& Inserto nuevo
Endif

mfecha = sp_busco_fecha_serv("DT")

If mestact = 0
	mret = SQLEXEC(mcon1," insert into TabAmbMsg (TAM_Fechah,TAM_codmed,"+;
		"TAM_estado,TAM_mensaje,TAM_protocolo,TAM_usuario) "+;
		" values(?mfecha,?mcmed,?mesta,?mobserv,?mproto,?mcusu)")
Else
	mret = SQLEXEC(mcon1,"update TabAmbMsg set TAM_estado = ?mesta "+;
		" where TAM_codmed = ?mcmed and TAM_protocolo = ?mproto and TAM_estado = ?mestact ")
Endif

If mret < 0
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Messagebox("EN LA ACTUALIZACION DEL MAESTRO DE MENSAJES"+chr(10)+;
		"AVISAR A SISTEMAS", 16, "ERROR")
Endif
