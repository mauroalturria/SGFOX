*!*
*!*	mcual = 1
*!*	mfecha1 = ctod("17/09/2009")
*!*	mfecha2 = ctod("17/09/2009")
*!*	mbuscog = ' and confirmado = 1 '
*!*	------------------------------------------------------------------
parameter mcual, mfecha1, mfecha2, mbuscog

if type ('mbuscog')#"C"
	mbuscog = ''
endif

mf1 = prg_dtoc(mfecha1)
mf2 = prg_dtoc(mfecha2+1)

do case


	case  mcual = 1


		mret = sqlexec(mcon1, "Select Turnos.fechatomado, REG_nombrepac, " + ;
			"ent_descrient, reg_nrohclinica, reg_numdocumento  , Turnos.codesp,Turnos.codprest ," + ;
			"reg_telefonos, reg_domicilio, afi_nroafiliado, " + ;
			"ent_codent, reg_nroregistrac, TPV_Observa, tpv_estado " + ;
			"from Turnos " + ;
			"Inner Join afiliacion on " + ;
			"afiliacion.registracio = Turnos.afiliado and " + ;
			"afiliacion.afi_codentidad = Turnos.codent " + ;
			"left outer join entidades on turnos.codent = entidades.ent_codent " + ;
			"left outer join registracio on afiliacion.registracio = registracio.reg_nroregistrac " + ;
			"left outer join tabpacvip on afiliacion.registracio = tabpacvip.tpv_nroreg " + ;
			"where " + ;
			"Turnos.fechatur >= ?mf1 and " + ;
			"Turnos.fechatur < ?mf2 " + mbuscog , "mwkturno1")

		if mret <= 0
			= aerr(eros)
			messagebox(eros(3)+"ERROR AL CREAR EL CURSOR, REINTENTE", 16, "Validación")
		endif

endcase
