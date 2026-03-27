parameter   mFechaIngr,mAbm,mNroadm,mUsuario

mfechanula = ctot("01/01/1900")

mret= sqlexec(mcon1," update TabHCIMovst set hcmfechaIngr = ?mfechaIngr"+;
	",hcmusuario = ?mUsuario" + ;
	" where hcmnroadm = ?mnroadm and hcmfechaIngr = ?mfechanula " )

if mret < 0
	messagebox('NO SE ACTUALIZO.  REINTENTE', 16, 'Validacion')
	mret = 0
endif
