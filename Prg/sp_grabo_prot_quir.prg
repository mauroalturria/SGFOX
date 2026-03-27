****
** Grabo datos del protocolo quirurgico
****
parameter mopcion,mCodadmision, mTipopac, mObserva,mUrgencia,mcodmedadm,mmedicoadm;
	,mcodcie10diagn,mdescripdiagn,mfirmaCons,malerta,mifecha
if vartype(mfirmaCons) # "N"
	mfirmaCons=1
endif
mfechaHora	= iif(vartype(mifecha)#"T" and vartype(mifecha)#"D",sp_busco_fecha_serv('DT'),mifecha)
mfirmaCons = IIF(mfirmaCons>0,mfirmaCons- 1,mfirmaCons )
do case
	case  mopcion= 1		&& inserto nuevo registro
		mret = sqlexec(mcon1, "insert into TabProtQuir(Codadmision ,Observa , TipoPac, "+;
			"Urgencia,CodMedicoAdm ,MedicoAdmision, codcie10diagn , descripdiagn, "+;
			"FirmaConsentimiento,FechaHoraQuir, observado )"+;
			" values(?mCodadmision, ?mObserva, ?mTipopac, ?mUrgencia,?mcodmedadm,"+;
			"?mmedicoadm, ?mcodcie10diagn , ?mdescripdiagn,?mfirmaCons,?mfechaHora, ?malerta)")
		if mret < 0
			Messagebox("ERROR AL GUARDAR LA AUTORIZACION",16,"ERROR")
			Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
		endif
	case mopcion= 2		&& actualizo ingreso
		mret = sqlexec(mcon1, "select id from TabProtQuir where Codadmision =?mCodadmision","mwkcontrol")
		if mret < 0
			=aerr(eros)
			messagebox(eros(3)+' AVISE error 2', 64,'Validacion')
		endif
		mid = mwkcontrol.id
		if mid > 0
			mret = sqlexec(mcon1, "update TabProtQuir  set Observa = ?mObserva,"+;
				"Urgencia= ?mUrgencia, CodMedicoAdm = ?mcodmedadm, TipoPac = ?mTipopac,"+;
				"MedicoAdmision = ?mmedicoadm , codcie10diagn = ?mcodcie10diagn , "+;
				"descripdiagn = ?mdescripdiagn, FirmaConsentimiento = ?mfirmaCons , observado =?malerta where ID = ?mid"  )
			if mret < 0
				Messagebox("ERROR AL GUARDAR LA AUTORIZACION",16,"ERROR")
				Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
			endif
		else
			mret = sqlexec(mcon1, "insert into TabProtQuir(Codadmision , Observa , "+;
				"TipoPac, Urgencia,CodMedicoAdm ,MedicoAdmision, codcie10diagn , "+;
				"descripdiagn, FirmaConsentimiento,FechaHoraQuir,observado  ) "+;
				"values(?mCodadmision, ?mObserva, ?mTipopac, ?mUrgencia,"+;
				"?mcodmedadm,?mmedicoadm, ?mcodcie10diagn , ?mdescripdiagn, "+;
				"?mfirmaCons,?mfechaHora,?malerta )")
			if mret < 0
				Messagebox("ERROR AL GUARDAR LA AUTORIZACION",16,"ERROR")
				Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
			endif
		endif
	case mopcion= 3		&& da de baja
		mret = sqlexec(mcon1, "select id from TabProtQuir where Codadmision =?mCodadmision","mwkcontrol")
		mid = mwkcontrol.id
		if mid > 0
			mret = sqlexec(mcon1, "update TabProtQuir  set TipoPac = 0 "+;
				" where Codadmision =?mCodadmision "  )
			if mret < 0
				Messagebox("ERROR AL GUARDAR LA AUTORIZACION",16,"ERROR")
				Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
			endif
		endif

	case mopcion= 4		&& actualizo solo consentimiento medico y grabo el LOG
		select mwkusuario
		go top
		musuario = codigovax
		mret = sqlexec(mcon1, "select id,FirmaConsentimiento  from TabProtQuir where Codadmision =?mCodadmision","mwkcontrol")
		mid = mwkcontrol.id
		mfirmaCons = iif(mwkcontrol.FirmaConsentimiento,"1","0")
*!*			if mid > 0
*!*				mret = sqlexec(mcon1, "update TabProtQuir  set FirmaConsentimiento = 0 where Codadmision =?mCodadmision"  )
*!*			endif
		mret = sqlexec(mcon1, "insert into TabQuirofLog ( Dato , FechaMod , UsuarioQ "+;
			", IdTabQuirofano ,ValorActual , ValorAnterior) "+;
			"values(?mCodadmision, ?mfechaHora, ?musuario , ?mid, '0',?mfirmaCons) " )
		if mret < 0
			Messagebox("ERROR AL GUARDAR LA AUTORIZACION",16,"ERROR")
			Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
		endif
endcase

