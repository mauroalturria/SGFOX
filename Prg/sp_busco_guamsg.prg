*!*	 Msg de Guardia para un medico
*!*	-----------------------------------------------------
Lparameters mabm, mCodMed, mProto, mbusco,mfecdes,mfechas

If Vartype(mbusco)#"C"
	mbusco = ''
Endif
If Vartype(mfecdes)="D"
	mfechad = prg_dtoc(mfecdes)
	mfechah = prg_dtoc(mfechas+1)
Else
	mfechad = prg_dtoc(Ctod("01/01/1900"))
	mfechah = prg_dtoc(Date())
Endif
Do Case
Case mabm = 1
*!*			mProto && no se usa en esta opcion
	If Used('mwkGuaMsgp')
		Use In mwkGuaMsgp
	Endif

	mret = SQLExec(mcon1,"select TabGuaMsg.Id, TabGuaMsg.TGM_FechaH, " + ;
		" TabGuaMsg.TGM_CodMed, TabGuaMsg.TGM_Estado,cast(TabGuaMsg.TGM_Usuario as INTEGER) as codigomed, " + ;
		" TabGuaMsg.TGM_Mensaje, TabGuaMsg.TGM_Protocolo, TabGuaMsg.TGM_Usuario, " + ;
		" TabUsuario.email " + ;
		" from TabGuaMsg left join TabUsuario on TabGuaMsg.TGM_Usuario = TabUsuario.IdUsuario " + ;
		" Where TabGuaMsg.TGM_CodMed = ?mCodMed " + ;
		" and TabGuaMsg.TGM_Protocolo in ('0','1') " + mbusco + ;
		" Order by TGM_FechaH Desc" ,"mwkGuaMsgp")
	If !Used('mwkMedicosall')
		Do sp_medicos_all
	Endif
	Select mwkGuaMsgp.Id, TGM_FechaH, TGM_CodMed, TGM_Estado,codigomed, TGM_Mensaje,;
		TGM_Protocolo, Iif(codigomed = 0,TGM_Usuario,nombre) As TGM_Usuario,email;
		from mwkGuaMsgp Left Join mwkMedicosall On codigomed = mwkMedicosall.Id;
		into Cursor mwkGuaMsg

Case mabm = 2
*!*
	mbuscar = " and TabGuaMsg.TGM_Protocolo = ?mproto "  + mbusco

	mret = SQLExec(mcon1,"select TabGuaMsg.Id, TabGuaMsg.TGM_Mensaje as msg , " + ;
		" b.TGM_Mensaje as Respuesta, TabGuaMsg.TGM_FechaH, " + ;
		" TabGuaMsg.TGM_Protocolo, " + ;
		" TabGuaMsg.TGM_Usuario, " + ;
		" TabGuaMsg.TGM_CodMed, CAST(TabGuaMsg.TGM_Estado AS INTEGER) as TGM_Estado, " + ;
		" TabUsuario.email " + ;
		" from TabGuaMsg, TabUsuario " + ;
		" Left join TabGuaMsg b on TabGuaMsg.id = b.TGM_Protocolo " + ;
		" Where TabGuaMsg.TGM_Usuario = TabUsuario.IdUsuario " + ;
		mbuscar + ;
		" and TabGuaMsg.TGM_FechaH >= ?mfechad  and TabGuaMsg.TGM_FechaH < ?mfechah  " ,"mwkGuaMsg")

Otherwise
	mbuscar = " and TabGuaMsg.TGM_Protocolo = ?mproto "  + mbusco
	mret = SQLExec(mcon1, "select TGM_protocolo ,TGM_Fechah , TGM_estado , TGM_mensaje , TGM_usuario  " + ;
		" from TabGuaMsg " + ;
		" where TGM_Fechah >= ?mfechad  and TGM_estado <> 9 and TGM_codmed = ?mCodMed " + ;
		mbuscar , "mwkGuaMsg")
Endcase

If mret < 1
	=Aerr(eros)
	Messagebox(eros(3)+"ERROR EN LA GENERACION DE LOS DATOS",16,"VALIDACION")
Endif
