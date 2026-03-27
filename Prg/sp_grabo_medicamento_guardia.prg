****
** graba los medicamentos de guardia
****

parameter mcual

	
	if mcual = 1
	
		mcp1 = mwk1.insumos
		mfp1 = ctod('01/01/1900')
	
		mret = sqlexec(mcon1, "insert into guardiainsumos(codinsumo, fechapasiva) " + ;
								"values(?mcp1, ?mfp1)")
	endif
	
	if mcual = 2
		
		mcp1 = mwk2.insumos
		mfp1 = sp_busco_fecha_serv('DD')
		mfp2 = ctod('01/01/1900')
		
		mret = sqlexec(mcon1, "update guardiainsumos " + ;
								"set fechapasiva = ?mfp1 " + ;
								"where codinsumo = ?mcp1 and fechapasiva = ?mfp2 ")
	
	endif							
