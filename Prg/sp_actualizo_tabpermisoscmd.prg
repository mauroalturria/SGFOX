****
** actualizo la tabla de permisos de cmd x frm
****

parameter muserid, mfrmid, msecid, mcmdid, mcual

	if mcual = 1	&& agrego cmd
	
		mfecpas = ctod('01/01/1900')
		mret = sqlexec(mcon1, "insert into tabpermisosfrmcmd(codcmd, codfrm, codsector, codusuario, fecpasiva) " + ;
								"values(?mcmdid, ?mfrmid, ?msecid, ?muserid, ?mfecpas)")
								
	endif
	
	if mcual = 2	&& quito cmd
	
		mfecpas = sp_busco_fecha_serv('DD')
		mret = sqlexec(mcon1, "update tabpermisosfrmcmd set fecpasiva = ?mfecpas " + ;
								"where codfrm = ?mfrmid and codcmd = ?mcmdid and " + ;
								 "codusuario = ?muserid and codsector =?msecid ")
								
	endif							
	if mcual = 3	&& quito todos los cmd
	
		mfecpas = sp_busco_fecha_serv('DD')
		mret = sqlexec(mcon1, "update tabpermisosfrmcmd set fecpasiva = ?mfecpas " + ;
								"where codusuario = ?muserid and codsector =?msecid ")
								
	endif							