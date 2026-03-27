****
** actualizo movimiento de Historias CON Turno
****

parameter  mnregistrac, mfechasal, mcodmed, mcodesp, morigen, mfechaTur,musu
	
	mfechaIngr = ctod("01/01/1900")    
	mret= sqlexec(mcon1," insert into TabHCMovct (hcm_registrac, hcm_fechasal, hcm_codmed" + ;
		", hcm_codesp, hcm_origen, hcm_fechaTur, hcm_fechaIngr,hcm_usuario ) values ( ?mnregistrac " + ;
		", ?mfechasal, ?mcodmed, ?mcodesp, ?morigen, ?mfechaTur, ?mfechaIngr,?musu ) " )

if mret < 0
	messagebox('NO SE ACTUALIZO.  REINTENTE', 16, 'Validacion')
	mret = 0
endif