****
** grabo un registro de llamada
****
parameter moperador, mfecha, mhora, mextension, mnumero, msolicitado, mobserva

	mnro = strtran(	strtran( mnumero, "-", ""), "/", "")

	mret = sqlexec(mcon1, "insert into tabregcall( Usuario, fecha, hora" + ;
				", extension, numero, numeroneto, solicitado, observa) " + ;
				"values( ?moperador, ?mfecha, ?mhora, ?mextension"+;
				", ?mnumero, ?mnro, ?msolicitado, ?mobserva)")
							
	if mret < 0
		messagebox('NO SE ACTUALIZO LA TABLA DE REGISTRO DE LLAMADOS.'+chr(13);
		  			+'INTENTE NUEVAMENTE', 16, 'Validacion')
		do prg_cancelo
	endif						