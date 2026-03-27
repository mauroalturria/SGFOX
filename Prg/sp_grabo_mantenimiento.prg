****
** Inserto datos de reclamos
****
Parameter mopcion,musulog,mCodSector,mEstado, mFechaIngSolic, mFechaSolicUsu, mInternoTE,;
	mPrioridad,mProbTec,mSector,mUsuario,mFechaSolucion,msolucion,mmotivo,mUsuFallaDetec,;
	mIdTipoRepar,mTipoDeTarea,mfechaprevtec, mTipoEspera, mNroReclamo, mHorasEst, motadd,;
	mcodigovax,mclasOrden,mfpteccon, mIdArea, mIdSubArea

If vartype(mfpteccon)#"N"
	mfpteccon = 1
Endif

mfechanula 	  = ctod('01/01/1900')
mfechaprevtec = IIF(EMPTY(mfechaprevtec), ctod('01/01/1900'),mfechaprevtec)

Do case
Case mopcion = 1		&& inserto nuevo registro

	mfechaactiva     = sp_busco_mantfactiva(mFechaIngSolic)
	mFechaAsignacion = ctot('01/01/1900')
	
	mret = sqlexec(mcon1, "insert into TabMantenimiento(usulog,CodSector,Estado,FechaIngSolic,FechaSolicUsu,"+;
		"InternoTE,Prioridad,ProbTec,Sector,Usuario,FechaSolucion,Solucion,Motivo,UsuFallaDetec,IdTipoRepar,"+;
		"TipoDeTarea,TipoEspera,fechaprevtec,otadd,codigovax,clasOrden,fechaprevtecconf,fechaactivacion,idArea,idSubArea)"+;
		" values(?musulog,?mCodSector,?mEstado,?mFechaIngSolic,?mFechaSolicUsu,?mInternoTE,?mPrioridad,"+;
		"?mProbTec,?mSector,?mUsuario,?mFechaSolucion,?msolucion,?mmotivo,?mUsuFallaDetec,?mIdTipoRepar,"+;
		"?mTipoDeTarea,?mTipoEspera,?mfechaprevtec,?motadd,?mcodigovax,?mclasOrden,?mfpteccon,?mfechaactiva,?mIdArea,?mIdSubArea)")

Case mopcion = 2		&& actualizo anulacion de ingreso
	mret = sqlexec(mcon1, "update TabMantenimiento set Estado = ?mEstado "+;
		", FechaSolucion = ?mFechaSolucion " + ;
		" where id  = ?mNroReclamo "  )

Case mopcion = 3		&& actualizo ingreso completo
	mret = sqlexec(mcon1, "update TabMantenimiento set "+;
		"InternoTE=?mInternoTE,"+;
		"Prioridad=?mPrioridad," +;
		"Sector=?mSector,"+;
		"Estado=?mEstado,"+;
		"ProbTec=?mProbTec,"+;
		"FechaSolucion=?mFechaSolucion,"+;
		"Solucion=?mSolucion,"+;
		"Motivo=?mmotivo,"+;
		"TipoDeTarea=?mTipoDeTarea,"+;
		"IdTipoRepar=?mIdTipoRepar,"+;
		"UsuFallaDetec=?mUsuFallaDetec,"+;
		"fechaprevtec=?mfechaprevtec,"+;
		"TipoEspera=?mTipoEspera,"+;
		"HorasEst=?mHorasEst,"+;
		"clasOrden=?mclasOrden,"+;
		"fechaprevtecconf=?mfpteccon"+;
		" where id = ?mNroReclamo")

Case mopcion = 4
	mret = sqlexec(mcon1, "update TabMantenimiento set  "+;
		"InternoTE = ?mInternoTE,"+;
		"codsector = ?mcodsector,"+;
		"Sector = ?mSector,"+;
		"FechaSolucion = ?mFechaSolucion,"+;
		"FechaSolicUsu  = ?mfechaSolicUsu,"+;
		"UsuFallaDetec = ?mUsuFallaDetec,"+;
		"HorasEst = ?mHorasEst " +;
		"where id = ?mNroReclamo and estado = ?mestado "  )

Case mopcion = 5		&& actualizo solo algun campo
	mret = sqlexec(mcon1, "update TabMantenimiento set "+;
		"clasOrden=?mclasOrden "+;
		" where id = ?mNroReclamo")

Endcase

If mret < 1
	If mopcion = 1
		Messagebox('ERROR EN EL INGRESO DE ORDEN DE TRABAJO'+chr(10)+;
			'REINTENTE O AVISE A SISTEMAS',16,'ERROR')
	Else
		Messagebox('ERROR EN LA ACTUALIZACION DE ORDEN DE TRABAJO'+chr(10)+;
			'REINTENTE O AVISE A SISTEMAS',16,'ERROR')
	Endif
Endif


