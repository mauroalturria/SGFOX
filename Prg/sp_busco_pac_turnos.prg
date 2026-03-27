*!*
*!*	mcual = 1
*!*	mfecha1 = ctod("17/09/2009")
*!*	mfecha2 = ctod("17/09/2009")
*!*	mbuscog = ' and confirmado = 1 '
*!*	------------------------------------------------------------------
Parameter mcual, mfecha1, mfecha2, mbuscog, mCursor

If type ('mbuscog')#"C"
	mbuscog = ''
Endif

If Vartype(mCursor)#"C"
	mCursor = "mwkturno1"
Endif

mf1 = prg_dtoc(mfecha1)
mf2 = prg_dtoc(mfecha2+1)

Do case


Case  mcual = 1


	mret = sqlexec(mcon1, "Select Turnos.fechatomado, REG_nombrepac, " + ;
		"ent_descrient, reg_nrohclinica, reg_numdocumento  , Turnos.codesp,Turnos.codprest ," + ;
		"reg_telefonos, reg_domicilio, afi_nroafiliado, " + ;
		"ent_codent, reg_nroregistrac, TPV_Observa, tpv_estado, Turnos.id,REG_email " + ;
		"from Turnos " + ;
		"Inner Join afiliacion on " + ;
		"afiliacion.registracio = Turnos.afiliado and " + ;
		"afiliacion.afi_codentidad = Turnos.codent " + ;
		"left outer join entidades on turnos.codent = entidades.ent_codent " + ;
		"left outer join registracio on afiliacion.registracio = registracio.reg_nroregistrac " + ;
		"left outer join tabpacvip on afiliacion.registracio = tabpacvip.tpv_nroreg " + ;
		"where " + ;
		"Turnos.fechatur >= ?mf1 and " + ;
		"Turnos.fechatur < ?mf2 " + mbuscog , mCursor)

Case  mcual = 3


	mret = sqlexec(mcon1, "Select Turnos.fechatomado, REG_nombrepac, " + ;
		"ent_descrient, reg_nrohclinica, reg_numdocumento  , Turnos.codesp,Turnos.codprest ," + ;
		"reg_telefonos, reg_domicilio, " + ;
		"ent_codent, reg_nroregistrac, TPV_Observa, tpv_estado, Turnos.id, " + ;
		"TabHCArchivo.Id as IdHcArchivo, Prestadores.nombre,REG_email  " + ;
		"from Turnos " + ;
		"afiliacion.registracio = Turnos.afiliado and " + ;
		"left outer join entidades on turnos.codent = entidades.ent_codent " + ;
		"left outer join registracio on Turnos.afiliado  = registracio.reg_nroregistrac " + ;
		"left outer join tabpacvip on Turnos.afiliado = tabpacvip.tpv_nroreg " + ;
		"left outer join TabHCArchivo on registracio.REG_nroregistrac = TabHCArchivo.hca_registrac " + ;
		"left outer join Prestadores on turnos.codmed = Prestadores.id " + ;
		"where " + ;
		"Turnos.fechatur = ?mf1 " + mbuscog , mCursor)


Endcase


If mret <= 0
	Messagebox("ERROR DE LECTURA DE CB ",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif
