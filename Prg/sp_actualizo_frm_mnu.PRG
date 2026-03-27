****
** actualizo la tabla de permisos de frm para menu principal
****
parameter muserid, msecid, mgruid, mfrmid, mcual
 
mCodigoVax = mwkUsuario.Codigovax && se agrega el codigoVax 091102
 
if mcual = 1	&& agrego frm

	mfecpas = ctod('01/01/1900')
	mret = sqlexec(mcon1, "insert into tabpermisosfrm(codfrm, codgrupo, codsector, " + ;
		"codusuario, fecpasiva, CodigoVax) " + ;
		"values(?mfrmid, ?mgruid, ?msecid, ?muserid, ?mfecpas, ?mCodigoVax)")

endif

if mcual = 2	&& quito frm

	mfecpas = sp_busco_fecha_serv('DD')
	mret = sqlexec(mcon1, "update tabpermisosfrm set fecpasiva = ?mfecpas, CodigoVax = ?mCodigoVax " + ;
		"where codfrm = ?mfrmid and codgrupo = ?mgruid and " + ;
		"codsector = ?msecid and codusuario = ?muserid ")

endif
if mcual = 3	&& quito todos los forms
	mfecpas = sp_busco_fecha_serv('DD')
	if mgruid = 0
		mret = sqlexec(mcon1, "update tabpermisosfrm set fecpasiva = ?mfecpas, CodigoVax = ?mCodigoVax " + ;
			"where codsector = ?msecid " + ;
			"and codusuario = ?muserid ")
	else
		mret = sqlexec(mcon1, "update tabpermisosfrm set fecpasiva = ?mfecpas, CodigoVax = ?mCodigoVax " + ;
			"where codsector = ?msecid " + ;
			"and codusuario = ?muserid and codgrupo = ?mgruid ")
	endif	
endif
if mcual = 4	&& agrego frm si no existe

	mfecpas = ctod('01/01/1900')
	mret = sqlexec(mcon1, "select *  from tabpermisosfrm " + ;
		"where codusuario  = ?muserid and " + ;
		"codsector = ?msecid and " + ;
		"fecpasiva = ?mfecpas and codfrm = ?mfrmid", "mwkexiste")
	if reccount('mwkexiste') = 0
		mret = sqlexec(mcon1, "insert into tabpermisosfrm(codfrm, codgrupo, codsector, " + ;
			"codusuario, fecpasiva, CodigoVax) " + ;
			"values(?mfrmid, ?mgruid, ?msecid, ?muserid, ?mfecpas, ?mCodigoVax)")
	endif
endif
