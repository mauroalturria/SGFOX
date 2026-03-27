*!*	Parametros mFecha, mOpcion, mbusco, mfechasta
*!*	Resultado mwkturnosControl
*!*	------------------------------------------------------------------
lparameters mFecha, mOpcion, mbusco, mfechasta

if vartype(mfechasta)#"D"
	mfechahas =  prg_dtoc(mfecha+1)
else
	mfechahas =  prg_dtoc(mfechasta+1)
endif
mfechades =  prg_dtoc(mfecha)

if mxambito >1
	mccpoamb = "  turnos.codambito = ?mxambito and "
else
	mccpoamb = ''
endif

do case
	case mOpcion = 1
		MCAMPO = "FECHATUR"
		mxsql = "select turnos.afiliado,turnos.fechatomado, upper(turnos.usuario) as usuario,nomape,"    +;
			"tabsectores.descrip as sector, fechatur, horatur, " +;
			"turnos.id, turnos.tipotomado, " +;
			"turnos.codreserva, turnos.codesp, turnos.diasem, turnos.codprest, " + ;
			"turnos.codserv,turnos.codent, turnos.codmed, turnos.tipoturno, " + ;
			"prestacions.PRE_descriprest, Entidades.ENT_descrient, " + ;
			"cast(CASE WHEN Trim(Nvl(REG_nombrepac,'')) = '' THEN Trim(preregistra.nombre) "+;
			" ELSE Trim(Nvl(REG_nombrepac,'')) END As CHARACTER(100)) as paciente, " + ;
			"CAST (CASE WHEN Nvl(REG_numdocumento,0) = 0 THEN Preregistra.nrodocumento "+;
			" ELSE Nvl(REG_numdocumento,0) END AS INTEGER ) as Documento, " + ;
			"entg.ENT_descrient as pre_descriprestG, Entidades.ENT_codagrup " + ;
			" From Turnos " + ;
			"left join tabusuario on turnos.usuario= tabusuario.idusuario " +;
			"left join tabsectorusuario on tabusuario.id = tabsectorusuario.codusuario and preferido = 1 " +;
			"left join tabsectores on tabsectorusuario.codsector = tabsectores.id " +;
			"left join prestacions on prestacions.pre_codprest = turnos.codprest " +;
			"left join Entidades on Entidades.ent_codent = turnos.codent " +;
			"left join registracio on registracio.REG_nroregistrac = turnos.afiliado " +;
			"left join preregistra on preregistra.id = turnos.afiliado " + ;
			"Left join entidades entg on entg.ent_codent = Entidades.ENT_codagrup " + ;
			"Where  turnos.codreserva<>'' and " + mccpoamb+ MCAMPO + ;
			" >= ?mfechades and " + MCAMPO + " < ?mfechahas and " + ;
			" Registracio.reg_nroregistrac = Turnos.Afiliado" + ;
			" and Turnos.afiliado > 1 "+ mbusco

		mRet = sqlexec(mcon1, mxsql , "mwkturnosControl")

	case mOpcion = 2

		MCAMPO = "FECHATOMADO"
		mfechahas =  prg_dtoc(mfecha+1)
		mxsql = "select turnos.afiliado,turnos.fechatomado, upper(turnos.usuario) as usuario,nomape,"    +;
			"tabsectores.descrip as sector, fechatur, horatur, " +;
			"turnos.id, turnos.tipotomado, " +;
			"turnos.codreserva, turnos.codesp, turnos.diasem, turnos.codprest, " + ;
			"turnos.codserv,turnos.codent, turnos.codmed, turnos.tipoturno, " + ;
			"prestacions.PRE_descriprest, Entidades.ENT_descrient, " + ;
			"cast(CASE WHEN Trim(Nvl(REG_nombrepac,'')) = '' THEN Trim(preregistra.nombre) "+;
			" ELSE Trim(Nvl(REG_nombrepac,'')) END As CHARACTER(100)) as paciente, " + ;
			"CAST (CASE WHEN Nvl(REG_numdocumento,0) = 0 THEN Preregistra.nrodocumento "+;
			" ELSE Nvl(REG_numdocumento,0) END AS INTEGER ) as Documento, " + ;
			"entg.ENT_descrient as pre_descriprestG, Entidades.ENT_codagrup " + ;
			" From Turnos " + ;
			"left join tabusuario on turnos.usuario= tabusuario.idusuario " +;
			"left join tabsectorusuario on tabusuario.id = tabsectorusuario.codusuario and preferido = 1 " +;
			"left join tabsectores on tabsectorusuario.codsector = tabsectores.id " +;
			"left join prestacions on prestacions.pre_codprest = turnos.codprest " +;
			"left join Entidades on Entidades.ent_codent = turnos.codent " +;
			"left join registracio on registracio.REG_nroregistrac = turnos.afiliado " +;
			"left join preregistra on preregistra.id = turnos.afiliado " + ;
			"Left join entidades entg on entg.ent_codent = Entidades.ENT_codagrup " + ;
			"Where  turnos.codreserva<>'' and " + mccpoamb +" fechatur >= ?mfechades and " + MCAMPO + ;
			" >= ?mfechades and " + MCAMPO + " < ?mfechahas and " + ;
			" Registracio.reg_nroregistrac = Turnos.Afiliado " + ;
			" and Turnos.afiliado > 1 " + mbusco

		mRet = sqlexec(mcon1,mxsql , "mwkturnosControl")

endcase


if mret <= 0
	aerror(eros)
	if mwkusuario.codigovax = 54035
		strtofile(mxsql ,"C:erorcito.txt")

		messagebox(eros(3))
		messagebox(eros(2))
	endif
*!*	canc
	do Log_errores with error(), message(), message(1), program(), lineno()
	messagebox("ERROR DE LECTURA",48,"VALIDACION")
	return .f.
endif

