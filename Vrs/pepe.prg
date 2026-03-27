do sp_conexion

	mfecha = date()
	mfechor = datetime()
	
	mret = sqlexec(mcon1, "insert into tabfacturas(ptovta, tpocte, letracte, nrocte, fechacte, " + ;
							"importe, codent, nroregistracio, nrovale, tpopac, apliptovta, " + ;
							"aplitpocte, apliletracte, aplinrocte, cuenta, usuario, fechahora) " + ;
							"values(2, 5, 'B', 2485, ?mfecha, 2, " + ;
							"980, 2801727, 9214160, 'GUA', 2, 1, 'B', " + ;
							"93881, '4085-C', 99999, ?mfechor)")

	susp
	
=sqldisconnect(mcon1)