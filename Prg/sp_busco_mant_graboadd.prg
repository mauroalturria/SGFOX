parameter mopcion, musulog, mCodSector, mEstado, mFechaIngSolic,;
					mFechaSolicUsu, mInternoTE,musuario,;
					motadd,musufalladetec,msector
					
mfechaprevtec = CTOD('01/01/1900')
mfechasolucion = CTOT('01/01/1900')
	mret = sqlexec(mcon1, "insert into TabMantenimiento(usulog, CodSector,"+;
					" Estado, FechaIngSolic, FechaSolicUsu, "+;
					" InternoTE,usuario,otadd,usufalladetec,fechaprevtec,fechasolucion,"+;
					" estado,idtiporepar,prioridad,motivo,tipodetarea,tipoespera,sector   )"+;
					 " values(?musulog, ?mCodSector," + ;
					" ?mEstado, ?mFechaIngSolic,"+;
					" ?mFechaSolicUsu,?mInternoTE,?musuario," + ;
					" ?motadd,?musufalladetec,?mfechaprevtec,?mfechasolucion,0,0,0,0,0,0,?msector )")

	if mret < 1
		=aerr(eros)
		messagebox('ERROR EN EL INGRESO, REINTENTE O AVISE A SISTEMAS', 64,'Validacion')	
	endif