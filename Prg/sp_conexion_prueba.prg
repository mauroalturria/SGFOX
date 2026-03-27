****
**** Armo la Conexion a la base
****
lparameters mdatabase
xp_sqlconn 	= "Driver={InterSystems ODBC};PORT=1972;SERVER=172.16.5.60;DATABASE=CATALOGO;Uid=_system;Pwd=sys"	
mcon2= SQLCONNECT(xp_sqlconn,'_system','sys')
	
	if mcon2 < 0
		=aerr(eros)
		MESSAGEBOX(eros(3))
   		do prg_cancelo
	endif
	