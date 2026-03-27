****
** actualizo la tabla de sector - usuario
****

parameter muserid, msecid, mcual, msecpref,mgruid
if type('mgruid')#"N"
	mgruid = 10
endif
	mfechanula = ctod('01/01/1900')
	mfecpas = sp_busco_fecha_serv('DD')

	if mcual = 1	&& agrego sector
	
		mret = sqlexec(mcon1, "insert into tabsectorusuario(codsector, codusuario, codgrupo,fecpasiva) " + ;
								"values(?msecid, ?muserid, ?mgruid, ?mfechanula )") 
								
	endif
	
	if mcual = 2	&& quito sector
	
		mret = sqlexec(mcon1, "Update tabsectorusuario set fecpasiva = ?mfecpas " + ;
								" where codsector = ?msecid and codusuario = ?muserid ")
								
	endif							
&&& si mcual = 3 solo actualiza el sector	
	if mcual <= 3
		mret = sqlexec(mcon1, "update tabsectorusuario set preferido=0 " + ;
									" where codusuario = ?muserid ")
		mret = sqlexec(mcon1, "update tabsectorusuario set preferido=1 " + ;
								" where codsector = ?msecpref and codusuario = ?muserid ")
	endif
	if mcual = 4
	
		mret = sqlexec(mcon1, "select *  from tabpermisosfrm " + ;
			"where codusuario  = ?muserid and " + ;
			"codsector = ?msecid and codgrupo <> ?mgruid and " + ;
			"fecpasiva = ?mfechanula  ", "mwkpasar")
		if reccount('mwkpasar') >0
			mret = sqlexec(mcon1, "update tabpermisosfrm set fecpasiva = ?mfecpas " + ;
				"where codsector = ?msecid and fecpasiva = ?mfechanula " + ;
				"and codusuario = ?muserid and codgrupo <> ?mgruid ")
			select mwkpasar
			scan 
				msecid	= codsector 
				mfrmid 	= codfrm
				mret = sqlexec(mcon1, "select *  from tabpermisosfrm " + ;
					"where codusuario  = ?muserid and " + ;
					"codsector = ?msecid and codgrupo = ?mgruid and " + ;
					"fecpasiva = ?mfechanula and codfrm = ?mfrmid ", "mwkexiste")
				if reccount('mwkexiste') = 0
					mret = sqlexec(mcon1, "insert into tabpermisosfrm(codfrm, codgrupo, codsector, " + ;
						"codusuario, fecpasiva) " + ;
						"values(?mfrmid, ?mgruid, ?msecid, ?muserid, ?mfechanula )")
				endif
			endscan
		endif
		mret = sqlexec(mcon1, "update tabsectorusuario set codgrupo = ?mgruid" + ;
			" where codsector = ?msecid and codusuario = ?muserid ")
							
	endif			
	