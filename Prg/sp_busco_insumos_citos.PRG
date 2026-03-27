*
* Busqueda de Insumos, medicamentos citostaticos
*
Lparameters mdabuscar, mtipo, mver, mbusaprox, mwhere

If Vartype(mbusaprox) <> "C"
	mbusaprox = "N"
Endif

If Vartype(mver) <> "N"
	mver = 0
Endif

If Vartype(mwhere) <> "D"
	mwhere = ""
Endif

Do Case

Case mtipo = 1 Or mtipo = 6

	If Used('mwkcitosp')
		Use In mwkcitosp
	Endif

	mret = SQLExec(mcon1,"select TCP_partida,TCP_fechacarga,TFI_descripcion,TCI_resto,TCI_marca,TCI_medida " + ;
		" From TabFarmCitosP"+;
		" Join TabFarmIns On TabFarmIns.Id = TabFarmCitosP.TCP_institucion"+;
		" Join TabFarmCitosI On TabFarmCitosI.TCI_partida = TabFarmCitosP.TCP_partida"+;
		" where TCP_fechapasiva is null"+;
		iif(mtipo = 6," and TCP_registracio = ?mdabuscar ","")+;
		iif(!Empty(mwhere)," and TCP_fecha >= ?mwhere ","")+;
		" group by TCP_partida", "mwkcitosp")


*!*		mret = sqlexec(mcon1,"select TCP_partida,TCP_fechacarga,TFI_descripcion,TCI_resto,TCI_marca " + ;
*!*			"from TabFarmCitosP,TabFarmIns,TabFarmCitosI Where TabFarmIns.Id = TCP_institucion"+;
*!*			" and TCP_fechapasiva is null"+;
*!*			" and TCP_partida = TCI_partida"+;
*!*			iif(mtipo=6," and TCP_registracio=?mdabuscar ","")+;
*!*			" group by TCP_partida", "mwkcitosp")

*!*	*!*		mret = sqlexec(mcon1,"select TCP_partida,TCP_fechacarga,TFI_descripcion " + ;
*!*	*!*			"from TabFarmCitosP,TabFarmIns,TabFarmCitosI Where TabFarmIns.Id = TCP_institucion"+;
*!*	*!*			" and TCP_fechapasiva is null"+;
*!*	*!*			" and TCP_partida = TCI_partida"+;
*!*	*!*			" and "+iif(mver=0,"TCI_resto > 0","TCI_resto >= 0") + iif(mtipo=6," and TCP_registracio=?mdabuscar ","")+;
*!*	*!*			" group by TCP_partida", "mwkcitosp")

	If mret < 0
		=Aerr(eros)
		Messagebox("ERROR "+eros(3)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
		Return
	Endif

	If Used('mwkfaraudit0')
		Use In mwkfaraudit0
	Endif

	mret = SQLExec(mcon1, "select TCI_partida,TCI_insumocodigo,TCI_insumodescrip,TCI_resto,TCI_devolucion,"+;
		"TCI_devolucion as TCI_devolant, TCI_tipoinsumo as TCI_tinsumo, TCI_vence, TCP_registracio,"+;
		"TCI_lote,TBC_udosis,TBC_dosis,TabFarmCitosI.id as lcid,TCI_marca, TCI_gtin, TCI_serie, TCI_medida" + ;
		" from TabFarmCitosI" + ;
		" join TabFarmBaseCo on TabFarmBaseCo.TBC_inscod = TabFarmCitosI.TCI_insumocodigo"+;
		" join TabFarmCitosP on TCP_partida = TCI_partida " + Iif(!Empty(mwhere)," and TCP_fecha >= ?mwhere ","")+;
		iif(mtipo = 6," and TCP_registracio = ?mdabuscar ","")+;
		" group by TCI_insumocodigo, TCI_partida, TCI_serie, TCI_vence, TCI_lote", "mwkfaraudit0")


*!*		mret = sqlexec(mcon1, "select TCI_partida,TCI_insumocodigo,TCI_insumodescrip,TCI_resto,TCI_devolucion,"+;
*!*			"TCI_devolucion as TCI_devolant, TCI_tipoinsumo as TCI_tinsumo, TCI_vence, TCP_registracio,"+;
*!*			"TCI_lote,TBC_udosis,TBC_dosis,TabFarmCitosI.id as lcid,TCI_marca" + ;
*!*			" from TabFarmCitosI" + ;
*!*			" join TabFarmBaseCo on TabFarmBaseCo.TBC_inscod = TabFarmCitosI.TCI_insumocodigo"+;
*!*			" join TabFarmCitosP on TCP_partida = TCI_partida " + iif(mtipo=6," and TCP_registracio=?mdabuscar ","")+;
*!*			" group by TCI_insumocodigo, TCI_partida, TCI_vence, TCI_lote", "mwkfaraudit0")


*!*	*!*		mret = sqlexec(mcon1, "select TCI_partida,TCI_insumocodigo,TCI_insumodescrip,TCI_resto,TCI_devolucion,"+;
*!*	*!*			"TCI_devolucion as TCI_devolant, TCI_tipoinsumo as TCI_tinsumo, TCI_vence, TCP_registracio,"+;
*!*	*!*			"TCI_lote,TBC_udosis,TBC_dosis" + ;
*!*	*!*			" from TabFarmCitosI" + ;
*!*	*!*			" join TabFarmBaseCo on TabFarmBaseCo.TBC_inscod = TabFarmCitosI.TCI_insumocodigo"+;
*!*	*!*			" join TabFarmCitosP on TCP_partida = TCI_partida " + iif(mtipo=6," and TCP_registracio=?mdabuscar ","")+;
*!*	*!*			" where "+iif(mver=0,"TCI_resto > 0","TCI_resto >= 0")+;
*!*	*!*			" group by TCI_insumocodigo, TCI_partida", "mwkfaraudit0")
*!*	*!*


*!*	*!*		mret = sqlexec(mcon1, "select TCI_partida,TCI_insumocodigo,TCI_insumodescrip,TCI_resto,TCI_devolucion,"+;
*!*	*!*			"TCI_devolucion as TCI_devolant, TCI_tipoinsumo as TCI_tinsumo, TCI_vence, TCP_registracio,"+;
*!*	*!*			"TCI_lote,TBC_udosis,TBC_dosis" + ;
*!*	*!*			" from TabFarmCitosI" + ;
*!*	*!*			" join TabFarmBaseCo on TabFarmBaseCo.TBC_inscod = TabFarmCitosI.TCI_insumocodigo"+;
*!*	*!*			" join TabFarmCitosP on TCP_partida = TCI_partida " + iif(mtipo=6," and TCP_registracio=?mdabuscar ","")+;
*!*	*!*			" where "+iif(mver=0,"TCI_resto > 0","TCI_resto >= 0")+;
*!*	*!*			" group by TCI_insumocodigo, TCI_partida", "mwkfaraudit0")


*!*	*!*	*!*		mret = sqlexec(mcon1, "select TCI_partida,TCI_insumocodigo,TCI_insumodescrip,TCI_resto,TCI_devolucion,"+;
*!*	*!*	*!*			"TCI_devolucion as TCI_devolant, TCI_tipoinsumo as TCI_tinsumo, TCI_vence, TCP_registracio,"+;
*!*	*!*	*!*			"TCI_lote,TBC_udosis,TBC_dosis" + ;
*!*	*!*	*!*		    " from TabFarmCitosI,TabFarmBaseCo" + ;
*!*	*!*	*!*			" join TabFarmCitosP on TCP_partida = TCI_partida " + iif(mtipo=6," and TCP_registracio=?mdabuscar ","")+;
*!*	*!*	*!*			" where "+iif(mver=0,"TCI_resto > 0","TCI_resto >= 0")+;
*!*	*!*	*!*			" and TabFarmBaseCo.TBC_inscod = TabFarmCitosI.TCI_insumocodigo", "mwkfaraudit0")

	If mret < 0
		=Aerr(eros)
		Messagebox("ERROR "+eros(3)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
		Return
	Else

*!*     10-02-2011 Ctrl ante inexistancia de registros
		Use In Select("mwkfaraudit1")
		If Reccount('mwkfaraudit0') > 0
			Select *,sp_busnom(TCP_registracio,1) As lnombre,;
				sp_busnom(TCP_registracio,2) As hclinica,;
				sp_busnom(TCP_registracio,3) As documento,;
				sp_busnom(TCP_registracio,4) As lentidad,;
				sp_busnom(TCP_registracio,5) As lafiliado;
				from mwkfaraudit0 Into Cursor mwkfaraudit0
			Select * From mwkfaraudit0 Into Cursor mwkfaraudit1
		Endif
*!*

	Endif

Case mtipo = 2
	mret = 0
	Select * From mwkfaraudit0 Where TCI_insumocodigo=mdabuscar Into Cursor mwkfaraudit1

Case mtipo = 3
	mret = 0
	Select * From mwkfaraudit0 Where TCI_partida=mdabuscar Into Cursor mwkfaraudit1
	If mbusaprox = "S"
		If Used('mwkfaraudit1')
			If Reccount('mwkfaraudit1')=0
				Select * From mwkfaraudit0 Where TCI_partida Like ('%'+Alltrim(mdabuscar)+'%') Into Cursor mwkfaraudit1
			Endif
		Endif
	Endif

Case mtipo = 4
	If Used('mwkcitosp')
		Use In mwkcitosp
	Endif
	mret = SQLExec(mcon1,"select TCP_partida,TCP_fechacarga,TFI_descripcion,TCI_resto,TCI_marca " + ;
		"from TabFarmCitosP,TabFarmIns,TabFarmCitosI,TabFarmCitosE"+;
		" Where TabFarmIns.Id = TCP_institucion and TCP_fechapasiva is null and"+;
		" TCP_partida = TCI_partida and TCE_partida = TCP_partida"+;
		" and TCE_fechapasiva is null group by TCP_partida", "mwkcitosp")
	If mret < 0
		=Aerr(eros)
		Messagebox("ERROR "+eros(3)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
	Endif
	Return

Case mtipo = 5
	If Used('mwkfaraudit0')
		Use In mwkfaraudit0
	Endif
	mret = SQLExec(mcon1, "select TCI_partida,TCI_insumocodigo,TCI_insumodescrip,TCI_resto,TCI_devolucion,"+;
		"TCI_devolucion as TCI_devolant, TCI_tipoinsumo as TCI_tinsumo,TCI_marca "+;
		"from TabFarmCitosI " + ;
		"where TCI_partida = ?mdabuscar", "mwkfaraudit0")
	If mret < 0
		=Aerr(eros)
		Messagebox("ERROR "+eros(3)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
		Return
	Else
		If Reccount('mwkfaraudit0')>0
			Select * From mwkfaraudit0 Into Cursor mwkfaraudit1
		Endif
	Endif

	If Used("mwkpacdat")
		Use In mwkpacdat
	Endif
	mret = SQLExec(mcon1,"select TCE_nombrepac,TCE_fechaemite from TabFarmCitosE where TCE_partida = ?mdabuscar","mwkpacdat")
	If mret < 0
		=Aerr(eros)
		Messagebox("ERROR "+eros(3)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
		Return
	Endif

Endcase

If mtipo = 5
	If mret < 0
		=Aerr(eros)
		Messagebox("ERROR "+eros(3)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
		Return
	Else
		If Reccount('mwkfaraudit1') > 0
			Select mwkfaraudit
			Zap
			Select * From mwkfaraudit1 Order By TCI_partida Into Cursor mwkfaraudit2
			Select mwkfaraudit2
			Go Top
			Scan
				mpartida = mwkfaraudit2.TCI_partida
				mcodinsu = mwkfaraudit2.TCI_insumocodigo
				mdescrip = mwkfaraudit2.TCI_insumodescrip
				Insert Into mwkfaraudit;
					(TCI_audita,TCI_partida,TCI_codinsumo,TCI_descrip,TCI_cantidad,TCI_fvence) Values ;
					(0,mpartida,mcodinsu,mdescrip,0)
			Endscan
		Endif
	Endif

Else

	If mret < 0
		=Aerr(eros)
		Messagebox("ERROR "+eros(3)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
		Return
	Else

		If Used('mwkfaraudit1')
			If Reccount('mwkfaraudit1')>0
				Select mwkfaraudit
				Zap
				Select * From mwkfaraudit1 Order By TCI_partida Into Cursor mwkfaraudit2
				Select mwkfaraudit2
				Go Top

				Scan All
					mpartida = mwkfaraudit2.TCI_partida
					mcodinsu = mwkfaraudit2.TCI_insumocodigo
					mdescrip = mwkfaraudit2.TCI_insumodescrip
					mresto   = mwkfaraudit2.TCI_resto
					mdevoluc = mwkfaraudit2.TCI_devolucion
					mtipinsu = mwkfaraudit2.TCI_tinsumo
					mfcvence = mwkfaraudit2.TCI_vence
					mnombres = mwkfaraudit2.lnombre
					If mtipo = 1 Or mtipo = 6 Or mtipo = 3
						mloten     = mwkfaraudit2.TCI_lote
						mdosis     = mwkfaraudit2.TBC_udosis
						mdosis2    = mwkfaraudit2.TBC_dosis
						If NVL(mwkfaraudit2.TBC_dosis,0) > 0
							munidad    = mwkfaraudit2.TCI_resto / mwkfaraudit2.TBC_dosis
						Else
							munidad    = 0
						Endif
						mhclinica  = mwkfaraudit2.hclinica
						mdocumento = mwkfaraudit2.documento
						mlentidad  = mwkfaraudit2.lentidad
						mlafiliado = mwkfaraudit2.lafiliado
						mlcid      = mwkfaraudit2.lcid
						mlote      = mwkfaraudit2.TCI_lote
						mmarca     = Nvl(mwkfaraudit2.TCI_marca,'')
						mgtin      = Nvl(mwkfaraudit2.TCI_gtin,'')
						mserie     = Nvl(mwkfaraudit2.TCI_serie,'')
						mmedida    = mwkfaraudit2.TCI_medida
					Else
						mloten     = ""
						mdosis     = ""
						mdosis2    = 0
						munidad    = 0
						mhclinica  = ""
						mdocumento = 0
						mlentidad  = ""
						mlafiliado = ""
						mlcid      = 0
						mlote      = ""
						mgtin      = ""
						mserie     = ""
						mmedida    = 0
					Endif
					Insert Into mwkfaraudit;
						(TCI_audita,TCI_partida,TCI_codinsumo,TCI_descrip,TCI_unidades,TCI_resto,TCI_devolucion,TCI_motivo,;
						TCI_devolant,TCI_tinsumo,TCI_fvence,TCI_nombre,TCI_lote,;
						hclinica,documento,lentidad,lafiliado,;
						TCI_udosis,TCI_udosis2,TCI_dosis,lcid,TCI_lote,TCI_marca,TCI_gtin,TCI_serie,TCI_medida);
						values ;
						(0,mpartida,mcodinsu,mdescrip,Round(munidad,2),mresto,0,'',mdevoluc,mtipinsu,mfcvence,mnombres,;
						mloten,;
						mhclinica,mdocumento,mlentidad,mlafiliado,;
						mdosis,mdosis,mdosis2,mlcid,mlote,mmarca,mgtin,mserie,mmedida)
				Endscan


			Endif
		Endif
	Endif
Endif

Function sp_busnom(mlregistra, mtipo)
mbusca = ''
Do Case
Case mtipo = 1
	Use In Select("mwkresulta")

*!*	mret = sqlexec(mcon1,"select REG_nombrepac as lnomb"+;
*!*		" from REGISTRACIO where REG_nroregistrac = ?mlregistra","mwkresulta")

	mret = SQLExec(mcon1,"select REG_nombrepac as lnomb,"+;
		"REG_nrohclinica as hclinica,REG_numdocumento as documento, entidades.ENT_descrient as lentidad,"+;
		"AFI_nroafiliado as lafiliado"+;
		" from REGISTRACIO "+;
		" join afiliacion on afiliacion.registracio = registracio.REG_nroregistrac"+;
		" join entidades on entidades.ENT_codent = afiliacion.AFI_codentidad"+;
		" where REG_nroregistrac = ?mlregistra","mwkresulta")

	If mret < 0
		Messagebox("EN CONSULTA DE PACIENTES REGISTRADOS"+Chr(10)+;
			"AVISE A SISTEMAS",16,"ERROR")
	Else
		If Used('mwkresulta')
			If Reccount('mwkresulta')>0
				mbusca = mwkresulta.lnomb

*!*					if mwkresulta.documento = 18755706
*!*					set step on
*!*					endif


			Endif
		Endif
	Endif

	If Len(Alltrim(mbusca))=0
		Use In Select("mwkresulta")

*!*		mret = sqlexec(mcon1,"select nombre as lnomb"+;
*!*			" from preregistra where preregistra.id = ?mlregistra","mwkresulta")

		mret = SQLExec(mcon1,"select nombre as lnomb,"+;
			"nrodocumento as documento, entidades.ENT_descrient as lentidad,afiliado as lafiliado"+;
			" from preregistra "+;
			" join entidades on entidades.ENT_codent = preregistra.codent"+;
			" where preregistra.id = ?mlregistra","mwkresulta")

		If mret < 0
			Messagebox("EN CONSULTA DE PACIENTES PREREGISTRADOS"+Chr(10)+;
				"AVISE A SISTEMAS",16,"ERROR")
		Else
			If Used('mwkresulta')
				If Reccount('mwkresulta')>0
					Select lnomb,Space(10) As hclinica,documento,lentidad,lafiliado From mwkresulta Into Cursor mwkresulta
					mbusca = mwkresulta.lnomb
				Endif
			Endif
		Endif
	Endif
Case mtipo = 2
	mbusca = mwkresulta.hclinica
Case mtipo = 3
	mbusca = mwkresulta.documento
Case mtipo = 4
	mbusca = mwkresulta.lentidad
Case mtipo = 5
	mbusca = mwkresulta.lafiliado
	Use In Select("mwkresulta")
Endcase

Return mbusca
