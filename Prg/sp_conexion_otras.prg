****
**** Armo la Conexion a la base
****
lparameters mdatabase
	xp_sqlconn 	= "DRIVER=InterSystems ODBC;DSN=Conec01;SERVER=cache6400"+;
				";DATABASE=" + alltrim(mdatabase) + ";UID=_system;PWD=sys"			

	mcon2= SQLCONNECT(xp_sqlconn,'_system','sys')
	
	if mcon2 < 0
		=aerr(eros)
		MESSAGEBOX(eros(3))
   		do prg_cancelo
	endif
	