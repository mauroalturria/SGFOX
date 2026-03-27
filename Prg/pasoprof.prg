public mcon1, mret

	if !used("mwkserver1")
		DO sp_conexion
		thisform.disconnec = .t.
	ENDIF


	select mwkprofes
	go top
	
	do while !eof('mwkprofes')
	
		mnombre = iif (empty(mwkprofes.c_nombre), alltrim(mwkprofes.c_apelli), alltrim(mwkprofes.c_apelli) + ',' + alltrim(mwkprofes.c_nombre))
		mdambula	= 1
		mdalta		= 1
		mgral		= 0
		
		mret = sqlexec(mcon1, "insert into prestadores(nombre, domicilio, telefono, telcelular, " + ;
						"telradio, dguardia, dinterna, dambula, bloqueo, codiva, codloca, codpcia, " + ;
						"codprof, codespe, coduniv, cuil) " + ;
						"values(?mnombre, '', '', '', '', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0)")
		
		
		if mret < 1
			messagebox("no anda")
			cancel
		else
		
			skip 1 in mwkprofes
		endif
		 
	enddo
