****
** actualizo movimiento de Historias CON Turno y sin turno 
****

parameter  mnregistrac, mfechaIngr,mabm

mfechanula = "1900-01-01 00:00:00"
musuari = mwkusuario.idusuario
if mabm = 1
	mret= sqlexec(mcon1," update TabHCMovct set hcm_fechaIngr = ?mfechaIngr, hcm_usuario = ?musuari " + ;
		" where hcm_registrac = ?mnregistrac and hcm_fechaIngr = ?mfechanula " )

	if mret < 0
		messagebox('NO SE ACTUALIZO.  REINTENTE', 16, 'Validacion')
		mret = 0
	endif
	mret= sqlexec(mcon1," update TabHCMovst set hcm_fechaIngr = ?mfechaIngr, hcm_usuario = ?musuari  " + ;
		" where hcm_registrac = ?mnregistrac and hcm_fechaIngr = ?mfechanula " )

	if mret < 0
		messagebox('NO SE ACTUALIZO.  REINTENTE', 16, 'Validacion')
		mret = 0
	endif
else
	mret= sqlexec(mcon1," update TabHCMovct set hcm_fechaIngr = ?mfechanula " + ;
		" where hcm_registrac = ?mnregistrac and hcm_fechaingr =?mfechaIngr " )

	if mret < 0
		messagebox('NO SE ACTUALIZO.  REINTENTE', 16, 'Validacion')
		mret = 0
	endif
	mret= sqlexec(mcon1," update TabHCMovst set hcm_fechaIngr = ?mfechanula " + ;
		" where hcm_registrac = ?mnregistrac and hcm_fechaingr =?mfechaIngr " )

	if mret < 0
		messagebox('NO SE ACTUALIZO.  REINTENTE', 16, 'Validacion')
		mret = 0
	endif
endif