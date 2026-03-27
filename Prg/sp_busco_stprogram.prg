*!*	lnOpcion = 1 && solo por id
*!*	lnOpcion = 2 && por Ip, Fecha, Tipo
*!*	lnOpcion = 3 && por Ip, Tipo
*!*	lnOpcion = 4 && por Ip, fecha
 
Parameters lnOpcion, ldFecha, lnTipo, lnId


Do Case
	Case lnOpcion = 1
		mRet = SqlExec(mcon1,"Select * from TabStProgram Where Id = ?lnId ", "MwkStProg")

	Case lnOpcion = 2
		mRet = SqlExec(mcon1,"Select * from TabStProgram " + ;
			"Where Pg_Ip = ?MyIp and Pg_FecAlta = ?ldFecha and Pg_tipo = ?lnTipo", "MwkStProg")

	Case lnOpcion = 3
		mRet = SqlExec(mcon1,"Select * from TabStProgram " + ;
			"Where Pg_Ip = ?MyIp and Pg_tipo = ?lnTipo", "MwkStProg")

	Case lnOpcion = 4
		mRet = SqlExec(mcon1,"Select * from TabStProgram " + ;
			"Where EXISTS(Select 1 from TabStProgram Where Pg_Ip = ?MyIp and Pg_FecAlta >= ?ldFecha) " + ;
			" and Pg_Ip = ?MyIp and Pg_FecAlta >= ?ldFecha ", "MwkStProg")

	Case lnOpcion = 5
		mRet = SqlExec(mcon1,"Select top 1 * from TabStProgram " + ;
			"Where EXISTS(Select 1 from TabStProgram Where Pg_Ip = ?MyIp and Pg_FecAlta >= ?ldFecha) " + ;
			" and Pg_Ip = ?MyIp and Pg_FecAlta >= ?ldFecha ", "MwkStProg")

EndCase	

If mRet <= 0
	MessageBox("ERROR AL GENERAR EL CURSOR DE PROGRAMAS",48 ,"VALIDACION")
	Return .f.
Endif 
