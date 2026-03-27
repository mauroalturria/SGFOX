
Do sp_conexion
Use in select('arreglar')
Select * from protquirint where id = 0 into cursor vacios
Use dbf('vacios') alias arreglar in 0 again
Select arreglar
SET STEP ON
Scan
	mNroregistrac = Nroregistrac
	mbusco = " and pac_codhci = ?mNroregistrac "
	mfechaqd = FechaQuirof - 1
	mfechaqh = FechaQuirof
	mid = id1
	lactua = .f.
	If mNroregistrac <> 0
		mret = sqlexec(mcon1,"select id,FechaHoraQuir from TabProtQuir where quirofano = ?mid ","mwkBuscoq")
		If reccount("mwkBuscoq") =0
			Do sp_busco_pac_internados with  mbusco
			If reccount('mwkpacint') > 0
				Select mwkpacint
				Go bottom
				mCodAdm       = PAC_codadmision
				mpacmedicoadm = pac_medicoadmision
				mpaccodmedicoadm = PAC_codmedicoadm
				mNombrePaci   = pac_nombrepaciente
				mret = sqlexec(mcon1,"select id,codadmision from TabProtQuir "+;
					"where codadmision = ?mCodAdm and FechaHoraQuir>=?mfechaqd  ","mwkBuscoPaci")
				If mret < 0
					Messagebox("EN CONSULTA PROTOCOLO QUIRURGICO",16,"ERROR")
					Do log_errores with error(), message(), message(1), program(), lineno()
					Set step on
				Endif
				If reccount("mwkBuscoPaci")>0
					Select mwkBuscoPaci
					Go bottom
					midProt = id
					If reccount('mwkBuscoPaci') > 0
						mret = sqlexec(mcon1,"update TabProtQuir set quirofano = ?mid where id  = ?midProt ")
						lactua = .t.
					Endif
				Else
					Do sp_grabo_prot_quir with 1,mCodAdm , 1,'', 0,mpaccodmedicoadm ,mpacmedicoadm ,0,'',1,0,mfechaqh
					mret = sqlexec(mcon1,"select id,codadmision from TabProtQuir "+;
						"where codadmision = ?mCodAdm ","mwkBuscoPaci")
					Select mwkBuscoPaci
					Go bottom
					midProt = id
					If reccount('mwkBuscoPaci') > 0
						lactua = .t.
						mret = sqlexec(mcon1,"update TabProtQuir set quirofano = ?mid where id  = ?midProt ")
					Endif

				Endif
				If mret < 0
					Messagebox("EN ACTUALIZACION PROTOCOLO QUIRURGICO",16,"ERROR")
					Do log_errores with error(), message(), message(1), program(), lineno()
					Set step on
				Endif
			Else
				Do sp_busco_cta_activa with mNroregistrac,mfechaqd
				Select PAC_fechaadmision, PAC_codadmision  from mwkctasamb ;
					where PAC_tipopaciente = "AMB" and PAC_fechaadmision = mfechaqh into cursor mwkcontrol
				Select mwkcontrol
				Scan
					mCodAdm	= PAC_codadmision
					mret = sqlexec(mcon1,"select id,codadmision from TabProtQuir "+;
						"where codadmision = ?mCodAdm ","mwkBuscoPaci")
					If mret < 0
						Messagebox("EN CONSULTA PROTOCOLO QUIRURGICO",16,"ERROR")
						Do log_errores with error(), message(), message(1), program(), lineno()
						Set step on
					Endif
					Select mwkBuscoPaci
					If reccount('mwkBuscoPaci') > 0
						Scan
							midProt = id
							mret = sqlexec(mcon1,"update TabProtQuir set quirofano = ?mid where id  = ?midProt ")
							lactua = .t.
						Endscan
					Endif
					If mret < 0
						Messagebox("EN ACTUALIZACION PROTOCOLO QUIRURGICO",16,"ERROR")
						Do log_errores with error(), message(), message(1), program(), lineno()
						Set step on
					Endif

				Endscan
			Endif
			If !lactua && busco en pacientes de alta
				mret = sqlexec(mcon1, "select PAC_fechaadmision, PAC_horaadmision, PAC_fechaalta, PAC_codhci"+;
					", PAC_codadmision  ,PAC_codmedicoadm, PAC_operadm, PAC_medicoadmision"+;
					" FROM pacientes "+ ;
					" where  PAC_codhci = ?mNroregistrac  and PAC_fechaadmision<=?mfechaqh and PAC_fechaalta >=?mfechaqh " +;
					" ","mwkctainter")
				If reccount('mwkctainter') > 0
					Select mwkctainter
					Go bottom
					mCodAdm       = PAC_codadmision
					mpacmedicoadm = pac_medicoadmision
					mpaccodmedicoadm = PAC_codmedicoadm
					mret = sqlexec(mcon1,"select id,codadmision from TabProtQuir "+;
						"where codadmision = ?mCodAdm and FechaHoraQuir>=?mfechaqd  ","mwkBuscoPaci")
					If mret < 0
						Messagebox("EN CONSULTA PROTOCOLO QUIRURGICO",16,"ERROR")
						Do log_errores with error(), message(), message(1), program(), lineno()
						Set step on
					Endif
					If reccount("mwkBuscoPaci")>0
						Select mwkBuscoPaci
						Go bottom
						midProt = id
						If reccount('mwkBuscoPaci') > 0
							mret = sqlexec(mcon1,"update TabProtQuir set quirofano = ?mid where id  = ?midProt ")
							lactua = .t.
						Endif
					Else
						Do sp_grabo_prot_quir with 1,mCodAdm , 1,'', 0,mpaccodmedicoadm ,mpacmedicoadm ,0,'',1,0,mfechaqh
						mret = sqlexec(mcon1,"select id,codadmision from TabProtQuir "+;
							"where codadmision = ?mCodAdm ","mwkBuscoPaci")
						Select mwkBuscoPaci
						Go bottom
						midProt = id
						If reccount('mwkBuscoPaci') > 0
							lactua = .t.
							mret = sqlexec(mcon1,"update TabProtQuir set quirofano = ?mid where id  = ?midProt ")
						Endif

					Endif
				Endif
			Endif

		Endif
	Endif
	Select arreglar
	replace listo with lactua
Endscan
Do sp_desconexion