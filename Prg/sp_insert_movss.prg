****
** actualizo falta de movimiento de Historias CON Turno
****

parameter  mnregistrac, mfechamov, mcodmed, mcodesp, mestado, mfechaTur,musu
mret= sqlexec(mcon1," select * from TabHCnsal "+;
	" where hcn_registrac = ?mnregistrac and hcn_codmed = ?mcodmed"+;
	" and hcn_codesp= ?mcodesp and hcn_fechaTur = ?mfechaTur " ,"mwkssmov" )

if reccount('mwkssmov')=0

	mret= sqlexec(mcon1," insert into TabHCnsal "+;
		"(hcn_registrac, hcn_fechamov, hcn_codmed, hcn_codesp," + ;
		" hcn_fechaTur, hcn_estado,hcn_usuario ) values " + ;
		"( ?mnregistrac , ?mfechamov, ?mcodmed, ?mcodesp, " + ;
		"?mfechaTur, ?mestado, ?musu ) " )
else
	mret= sqlexec(mcon1," update TabHCnsal set hcn_estado = ?mestado,"+;
		" hcn_usuario = ?musu"+;
		" where hcn_registrac = ?mnregistrac and hcn_codmed = ?mcodmed"+;
		" and hcn_codesp= ?mcodesp and hcn_fechaTur = ?mfechaTur " 	)
endif

if mret < 0

	messagebox('NO SE ACTUALIZO.  REINTENTE', 16, 'Validacion')
	mret = 0
endif