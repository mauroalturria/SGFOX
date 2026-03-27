
	mptovta = 1
	mfecha	= date()
	
	mret = sqlexec(mcon1, "select tpocte, letracte, nrocte " + ;
							"from tabfacturas where ptovta = ?mptovta and " + ;
							"fechacte = ?mfecha " + ;
							"order by tpocte, letracte, nrocte", "mwkveo")
							
							
	mcuenta = mwkveo.nrocte 
	mtpo	= mwkveo.tpocte
	mlet	= mwkveo.letracte
	
	do while !eof('mwkveo')
	
		do while mtpo = mwkveo.tpocte and mlet = mwkveo.letracte
		
			if mcuenta < mwkveo.nrocte
				?mcuenta
			else			
				skip 1 in mwkveo
			endif
				
			mcuenta = mcuenta + 1
		enddo
	
		mcuenta = mwkveo.nrocte
		mtpo	= mwkveo.tpocte
		mlet	= mwkveo.letracte
		
	enddo
	
	
	