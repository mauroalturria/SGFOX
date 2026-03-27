*!*	------------------------------------------------------
*!*	Actualizo Datos de Alimentacion
*!*	------------------------------------------------------
Lparameters nopcion, mid, mpresta, mvale, mfechacarga, mobserva, mcant, mhora

mfechanull = Ctot("01/01/1900")

If Type('mcant')#"N"
	mcant = 1
Endif

If Type('mhora')#"N"
	mfhora = sp_busco_fecha_serv('DT')
	mhora = Hour(mfhora)*100 + Minute(mfhora)
Endif

If nopcion = 1  &&&  alta o modificacion

	mret = SQLExec(mcon1, "insert into TabNutDetAmb " + ;
		"( TND_idPaciente, TND_codPrest, TND_NroVale, TND_FHoraCarga, " + ;
		"TND_observa, TND_fecbaja, TND_Cantidad, TND_hora ) " + ;
		" values (?mid, ?mpresta, ?mvale, ?mfechacarga, " + ;
		"?mobserva, ?mfechanull, ?mcant,?mhora )")

	If mRet <= 0
		Messagebox("ERROR AL AGREGAR EL DETALLE ",16,"ERROR")
		Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
		Return .F.
	Endif 
Else
	&& AGREGO EL MENSAJE PARA VER SI PASA POR ACA
	Messagebox("ERROR AL ACTUALIZAR",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()

Endif