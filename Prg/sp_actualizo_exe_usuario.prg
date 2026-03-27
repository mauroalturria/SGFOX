****
** actualizo la tabla de ejecutables por usuario
****
parameter muserid, mexeid, mcual, mtipo, msectorid

mCodigoVax = mwkUsuario.Codigovax && se agrega el codigoVax 091102

mtipo = iif(vartype(mtipo) # "N", 1, mtipo)

Do case
	Case mtipo = 2 && sector 
			 && el ususario queda en 0 
			 && en codigovax se guarda el sector 
			 && no queda registrado quien modifica el permiso

		muserid = 0 
		mCodigoVax = msectorid
		if mcual = 1	&& agrego exe
			mfecpas = ctod('01/01/1900')
			mret = sqlexec(mcon1, "insert into tabpermisosexe(codexe, codusuario, fecpasiva, codigovax) " + ;
				"values(?mexeid, ?muserid, ?mfecpas, ?mCodigoVax )")
		endif

		if mcual = 2	&& quito exe
			mfecpas = sp_busco_fecha_serv ('DD')

			mret = sqlexec(mcon1, "update tabpermisosexe set fecpasiva = ?mfecpas, CodigoVax = ?msectorid " + ;
				" where codexe = ?mexeid and codusuario = ?muserid and codigovax = ?mCodigoVax ")
		endif

	Case mtipo = 3 && copy permisos exe

			msectorid = mwkUsuarios2.Codigovax 
			mfecpas = ctod('01/01/1900')
			mret = sqlexec(mcon1, "insert into tabpermisosexe(codexe, codusuario, fecpasiva, codigovax) " + ;
				"values(?mexeid, ?muserid, ?mfecpas, ?mCodigoVax )")
		

	Otherwise  && Usuarios 
	*!*		msectorid = 0 && 091102 se usa solo en frmadminis09.scx 
		msectorid = mwkUsuario.Codigovax 

		if mcual = 1	&& agrego exe
			mfecpas = ctod('01/01/1900')
			mret = sqlexec(mcon1, "insert into tabpermisosexe(codexe, codusuario, fecpasiva, codigovax) " + ;
				"values(?mexeid, ?muserid, ?mfecpas, ?mCodigoVax )")
		endif

		if mcual = 2	&& quito exe
			mfecpas = sp_busco_fecha_serv ('DD')

			mret = sqlexec(mcon1, "update tabpermisosexe set fecpasiva = ?mfecpas, CodigoVax = ?msectorid " + ;
				" where codexe = ?mexeid and codusuario = ?muserid  ") && and codigovax = ?msectorid este fue el cambio
		endif

EndCase