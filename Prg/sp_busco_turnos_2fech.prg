*!*	Turnos + Registracio
*!*	Parametros mFechades, mfechahas
*!*	Resultado mwktur2fech
*!*	------------------------------------------------------------------
lparameters mFecha, mOpcion,mbusco,mfechasta

if vartype(mfechasta)#"D"
	mfechahas =  prg_dtoc(mfecha+1)
else
	mfechahas =  prg_dtoc(mfechasta+1)
endif
mfechades =  prg_dtoc(mfecha)
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''	
endif
do case
	case mOpcion = 1
		MCAMPO = "FECHATUR"

		mRet = SqlExec(mcon1, "Select Registracio.REG_nombrepac, " + ;
			"Registracio.REG_fecnacimiento, Registracio.REG_numdocumento, " + ;
			" Turnos.* " + ;
			" From Turnos, Registracio " + ;
			"Where "+mccpoamb + mbusco + MCAMPO + ;
			" >= ?mfechades and " + MCAMPO + " < ?mfechahas and " + ;
			" Registracio.reg_nroregistrac = Turnos.Afiliado" + ;
			" and  turnos.codreserva<>'' and Turnos.afiliado > 1 "+;
			"Union " + ;
			"Select PreRegistra.Nombre as REG_nombrepac, " + ;
			"PreRegistra.fechanac as REG_fecnacimiento, PreRegistra.coddocu as REG_numdocumento, " + ;
			" Turnos.* " + ;
			" From Turnos, PreRegistra " + ;
			"Where "+mccpoamb + mbusco + MCAMPO + ;
			" >= ?mfechades and " + MCAMPO + " < ?mfechahas and " + ;
			" PreRegistra.Afiliado = Turnos.Afiliado and  turnos.codreserva<>'' and Turnos.afiliado > 1 ", "mwktur2fech")

	case mOpcion = 2

		MCAMPO = "FECHATOMADO"
		mfechahas =  prg_dtoc(mfecha+1)
		mRet = SqlExec(mcon1, "Select Registracio.REG_nombrepac, " + ;
			"Registracio.REG_fecnacimiento, Registracio.REG_numdocumento, " + ;
			" Turnos.* " + ;
			" From Turnos, Registracio " + ;
			"Where " + mccpoamb+ mbusco + "fechatur >= ?mfechades and " + MCAMPO + ;
			" >= ?mfechades and " + MCAMPO + " < ?mfechahas and " + ;
			" Registracio.reg_nroregistrac = Turnos.Afiliado" + ;
			" and  turnos.codreserva<>'' and Turnos.afiliado > 1 "+;
			"Union " + ;
			"Select PreRegistra.Nombre as REG_nombrepac, " + ;
			"PreRegistra.fechanac as REG_fecnacimiento, PreRegistra.coddocu as REG_numdocumento, " + ;
			" Turnos.* " + ;
			" From Turnos, PreRegistra " + ;
			"Where " + mccpoamb + mbusco + "fechatur >= ?mfechades and " + MCAMPO + ;
			" >= ?mfechades and " + MCAMPO + " < ?mfechahas and " + ;
			" PreRegistra.id  = Turnos.Afiliado and turnos.codreserva<>'' and Turnos.afiliado > 1 ", "mwktur2fech")

endcase

if mRet <= 0
	messagebox("Error al generar el cursor ",48 , "VALIDACION")
	cancel
endif

