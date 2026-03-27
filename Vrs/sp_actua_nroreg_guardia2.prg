****
** Actualización de Historias Unificadas, Maestros Anexos no actualizados
***
*Do sp_conexion
If used('mwkctrluni')
	Use in mwkctrluni
Endif
mfec1 = prg_dtoc(ctod("01/11/2007"))
mret  = sqlexec(mcon1,'select * from TabCtrlUnif where fecha >= ?mfec1','mwkctrluni')
If mret < 0
	Messagebox('EN MAESTRO DE UNIFICACION DE HIS.CLIN.',0,'ERROR')
	Return
Endif
Select mwkctrluni
Go top
Scan
	nroregistra = mwkctrluni.REG_nroregistracD && Original
	newregistra = mwkctrluni.REG_nroregistracO && Nuevo
	If mwkctrluni.NroControl = -1              && Unificación
		mret = sqlexec(mcon1, "update Tabguaevol set EG_nroregistrac = ?newregistra "  + ;
			"where EG_nroregistrac = ?nroregistra")
		mret = sqlexec(mcon1, "update TabRegDatos set TRT_Registracio = ?newregistra " + ;
			"where TRT_Registracio = ?nroregistra")
		mret = sqlexec(mcon1, "update TabRegDocu set TRD_Registracio = ?newregistra "  + ;
			"where TRD_Registracio = ?nroregistra")
		mret = sqlexec(mcon1, "update TabRegFoto set TRF_Registracio = ?newregistra "  + ;
			"where TRF_Registracio = ?nroregistra")
		mret = sqlexec(mcon1, "update TabRegTel set TRT_Registracio = ?newregistra "   + ;
			"where TRT_Registracio = ?nroregistra")
		If mret < 0
			Messagebox('EN ACTUALIZACION DE MAESTROS - Unificacion -',0,'ERROR')
			Return
		Endif
*
*       Vip
*
		If used('mwktpvn')
			Use in mwktpvn
		Endif
		mret = sqlexec(mcon1,"select * from TabPacVip Where TPV_NroReg = ?newregistra","mwktpvn")
		If mret < 0
			Messagebox('LOCALIZACION DE REGISTROS EN CURSOR - Unificacion -',0,'ERROR')
			Return
		Endif
		If reccount('mwktpvn') = 0
			mret = sqlexec(mcon1,"update TabPacVip set TPV_NroReg = ?newregistra "+;
				"where TPV_NroReg = ?nroregistra")
			If mret < 0
				Messagebox('ACTUALIZACION DE REGISTROS - Unificacion -',0,'ERROR')
				Return
			Endif
		Endif
	Endif
	If mwkctrluni.NroControl = 1                && Pasaje de Consumos
		If used('mwknewreg')
			Use in mwknewreg
		Endif
		mfec2 = prg_dtoc(mwkctrluni.REG_fecbajapadronD )
		mfec3 = prg_dtoc(mwkctrluni.REG_fecbajapadronO +1 )
		mret = sqlexec(mcon1, "select protocolo "+;
			"from guardia where nroregistrac = ?newregistra and "  +;
			"fechahoraate >= ?mfec2 and fechahoraate < ?mfec3","mwknewreg")
		Select mwknewreg
		Scan
			miprot = mwknewreg.protocolo
			mret = sqlexec(mcon1, "update Tabguaevol set EG_nroregistrac = ?newregistra " + ;
				"where EG_nroregistrac = ?nroregistra and EG_protocolo = ?miprot ")
			If mret < 0
				Messagebox('EN ACTUALIZACION DE MAESTROS - Evoluciones -',0,'ERROR')
				Return
			Endif
		Endscan
	Endif
Endscan
If used('mwkctrluni')
	Use in mwkctrluni
Endif
If used('mwknewreg')
	Use in mwknewreg
Endif
If used('mwktpvn')
	Use in mwktpvn
Endif
Return
