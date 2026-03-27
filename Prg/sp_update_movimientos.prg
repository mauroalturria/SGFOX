****
** actualizo movimiento de Historias CON Turno y sin turno 
****

parameter   mFechaIngr,mAbm,mNroadm,mUsuario 

mfechanula = "1900-01-01 00:00:00"

	mret= sqlexec(mcon1,"select max(id) as idNroad from TabHCIMovst  where hcmnroadm = ?mNroadm","mwkIdNroAdm")
	SELECT mwkIdNroAdm
	midNroad   = idNroad  


	mret= sqlexec(mcon1," update TabHCIMovst set hcmfechaIngr = ?mfechaIngr,hcmusuario = ?mUsuario" + ;
		" where hcmnroadm = ?mnroadm and id = ?midNroad  " )

	if mret < 0
		messagebox('NO SE ACTUALIZO.  REINTENTE', 16, 'Validacion')
		mret = 0
	endif
	mret= sqlexec(mcon1," update TabHCIMovst set hcmfechaIngr = ?mfechaIngr ,hcmusuario = ?mUsuario" + ;
		" where hcmnroadm = ?mnroadm and id = ?midNroad " )


