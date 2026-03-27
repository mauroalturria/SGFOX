*********************************************************************************
* BUSCA historias en rotacion                                                    *
*********************************************************************************
lparameters mbuscar

	mret = sqlexec(mcon1,"select REG_nrohclinica,  REG_nombrepac, TabHCArchivo.*,TabHCMovst.* " +;
			" from TabHCMovst,TabHCArchivo,registracio,TabHCUbica    "+;
			" where hca_registrac = hcm_registrac and codubi = hca_motfalta and "+;
			" hca_registrac = REG_nroregistrac and "+ mbuscar , "mwkmovh_INV" )
	if mret < 0
		=aerr(eros)
		messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	endif
	
