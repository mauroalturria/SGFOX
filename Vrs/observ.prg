****
** Listado estadistico para Morgulis primero disponible, cantidad ocupados, libres
****
PUBLIC mcon1
mcon1= SQLCONNECT('Conec01','_system','sys')

	mret = sqlexec(mcon1, "SELECT REG_nombrepac , REG_nrohclinica , "+;
			"REG_bloq_estado , REG_bloq_oper , REG_bloq_comen ,"+;
			" REG_bloq_fecha , REG_nroregistrac,NOMAPE "+;
			" FROM REGISTRACIO LEFT JOIN TABUSUARIO "+;
			" ON REG_bloq_oper=CODIGOVAX "+;
			"WHERE REG_bloq_comen IS NOT NULL  " + ;
			"", "mwktodosb")

	if mret < 0
		=aerr(eros)
		messagebox(EROS(2))
	endif
	
	
	
	