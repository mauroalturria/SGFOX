****
** actualizo movimiento de Historias SIN Turno
****
parameter  mnregistrac, mfechasal, mcodmed, mdescMed, mcodesp, mdescEsp, mretira, morigen, mfechaTur ,musu
	
mfechaIngr = ctod("01/01/1900")    

	mret= sqlexec(mcon1," insert into TabHCMovst (hcm_registrac, hcm_fechasal, hcm_codmed, hcm_descMed " + ;
		", hcm_codesp, hcm_descEsp, hcm_retira, hcm_origen, hcm_fechaTur, hcm_fechaIngr,hcm_usuario ) " + ; 
		" values ( ?mnregistrac, ?mfechasal, ?mcodmed, ?mdescMed, ?mcodesp, ?mdescEsp, " + ;
		"?mretira, ?morigen, ?mfechaTur, ?mfechaIngr,?musu ) " )

if mret < 0
	messagebox('NO SE ACTUALIZO.  REINTENTE', 16, 'Validacion')
	mret = 0
endif