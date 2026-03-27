*
* Log Preparaciones //  1 : Armo Log, 2 : Actualizo - comunica Kardex, 3 : Limpia log, 4 : Trae Log
*
Lparameters lidpre, ltipo

mcomunica = 'N'

Do Case

Case ltipo = 1

	If !Used("mwkfarm49")
		Return .F.
	Endif

Case ltipo = 2 Or ltipo = 3

	mret = SQLExec(mcon1,"delete from ZabFarmPreTmp where FPT_preparacion = ?lidpre")

	If mret < 0
		=Aerr(eros)
		mmsgerr = eros(3)
		mdetalle= "Error Inicialización Log Preparaciones Paso 1"
		Do sp_insert_tabCtrlErr With mdetalle, mmsgerr , mwkusuario.idusuario, "Log Preparaciones"
		Messagebox("Error Inicialización Log Preparaciones Paso 1", 48, "ERROR - FAVOR DE AVISAR A SISTEMAS")
		Return .F.
	Endif

	If ltipo = 2
		mcomunica = 'S'
	Endif

Endcase

mretorno  = .T.

Do Case

Case ltipo = 1 Or ltipo = 2

	Select mwkfarm49
	Go Top

	Dimension vdt[25]
	Scan All

		vdt[1] = _vale
		vdt[2] = _codins
		vdt[3] = _insumo
		vdt[4] = _paciente
		vdt[5] = _cantidad
		vdt[6] = _entregad
		vdt[7] = _tipo
		vdt[8] = _frio
		vdt[9] = _observ
		vdt[10] = _sector
		vdt[11] = _hab
		vdt[12] = _cama
		vdt[13] = _fechaval
		vdt[14] = _cta
		vdt[15] = _horaVal
		vdt[16] = _secu
		vdt[17] = _verifica
		vdt[18] = lpuntero
		vdt[19] = mlcolor
		vdt[20] = _PAC_edad
		vdt[21] = _ENT_descrient
		vdt[22] = enPyxis
		vdt[23] = _gtin
		vdt[24] = _serie
		vdt[25] = esExterno

		mret = SQLExec(mcon1,"insert into ZabFarmPreTmp (FPT_vale,FPT_codins,FPT_insumo,FPT_paciente,"+;
			"FPT_cantidad,FPT_entregad,FPT_tipo,FPT_frio,FPT_observ,FPT_sector,FPT_hab,FPT_cama,"+;
			"FPT_fechaval,FPT_cta,FPT_horaval,FPT_secu,FPT_verifica,FPT_lpuntero,FPT_mlcolor,"+;
			"FPT_edad,FPT_descrient,FPT_enPyxis,FPT_gtin,FPT_serie,FPT_esExterno,FPT_preparacion,FPT_comunicaKardex)"+;
			" values "+;
			"(?vdt[1],?vdt[2] ,?vdt[3] ,?vdt[4] ,?vdt[5] ,?vdt[6] ,?vdt[7] ,"+;
			"?vdt[8] ,?vdt[9] ,?vdt[10],?vdt[11],?vdt[12],?vdt[13],?vdt[14],"+;
			"?vdt[15],?vdt[16],?vdt[17],?vdt[18],?vdt[19],?vdt[20],?vdt[21],"+;
			"?vdt[22],?vdt[23],?vdt[24],?vdt[25],?lidpre,?mcomunica)")

		If mret < 0
			=Aerr(eros)
			mmsgerr = eros(3)
			mdetalle= "Error Inicialización Log Preparaciones Paso 2"
			Do sp_insert_tabCtrlErr With mdetalle, mmsgerr , mwkusuario.idusuario, "Log Preparaciones"
			Messagebox("Error Inicialización Log Preparaciones Paso 2", 48, "ERROR - FAVOR DE AVISAR A SISTEMAS")
			mretorno = .F.
			Exit
		Endif

	Endscan

Case ltipo = 4

	Use In Select("mwkfarm49")

	mret = SQLExec(mcon1,"select FPT_vale as _vale,FPT_codins as _codins,FPT_insumo as _insumo,FPT_paciente as _paciente,"+;
		"FPT_cantidad as _cantidad,FPT_entregad as _entregad,FPT_tipo as _tipo,FPT_frio as _frio,FPT_observ as _observ,"+;
		"FPT_sector as _sector,FPT_hab as _hab,FPT_cama as _cama,"+;
		"FPT_fechaval as _fechaval,FPT_cta as _cta,FPT_horaval as _horaVal,FPT_secu as _secu,FPT_verifica as _verifica,"+;
		"FPT_lpuntero as lpuntero,FPT_mlcolor as mlcolor,"+;
		"FPT_edad as _PAC_edad,FPT_descrient as _ENT_descrient,FPT_enPyxis as enPyxis,FPT_gtin as _gtin,FPT_serie as _serie,"+;
		"FPT_esExterno as esExterno, FPT_comunicaKardex as comunicaKardex from ZabFarmPreTmp where FPT_preparacion=?lidpre","mwkfarm49")

	If mret < 0
		=Aerr(eros)
		mmsgerr = eros(3)
		mdetalle= "Error Inicialización Log Preparaciones Paso 4"
		Do sp_insert_tabCtrlErr With mdetalle, mmsgerr , mwkusuario.idusuario, "Log Preparaciones"
		Messagebox("Error Inicialización Log Preparaciones Paso 2", 48, "ERROR - FAVOR DE AVISAR A SISTEMAS")
		mretorno = .F.
	Endif

Endcase

Return mretorno
