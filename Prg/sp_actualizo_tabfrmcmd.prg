****
** actualizo la tabla de cmd x frm
****

parameter mfrmid, msecid, mcmdid, mcual

	if mcual = 1	&& agrego cmd
	
		mfecpas = ctod('01/01/1900')
		mret = sqlexec(mcon1, "insert into tabfrmcmd(codcmd, codfrm, codsector, fecpasiva) " + ;
								"values(?mcmdid, ?mfrmid, ?msecid, ?mfecpas)")
								
	endif
	
	if mcual = 2	&& quito cmd
	
		mfecpas = sp_busco_fecha_serv('DD')
		mret = sqlexec(mcon1, "update tabfrmcmd set fecpasiva = ?mfecpas " + ;
								"where codfrm = ?mfrmid and codcmd = ?mcmdid and " + ;
								 "codsector =?msecid ")
								
	endif							
	if mcual = 3	&& quito todos los cmd
	
		mfecpas = sp_busco_fecha_serv('DD')
		mret = sqlexec(mcon1, "update tabfrmcmd set fecpasiva = ?mfecpas " + ;
								"where codfrm = ?mfrmid and codsector =?msecid ")
								
	endif							