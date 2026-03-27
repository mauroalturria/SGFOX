*
* Log Preparaciones //  1 : Armo Log, 2 : Actualizo - comunica Kardex, 3 : Limpia log, 4 : Trae Log
*
Lparameters lidpre, ltipo, mPantalla,cTabla

Local mTipoInsumo

mcomunica = 'N'
mTipoInsumo  = ""
mPantalla = Iif(Vartype(mPantalla) <> "C","",mPantalla)
cTabla = Iif(Vartype(cTabla) <> "C","mwkfarm49",cTabla)


Do Case

Case ltipo = 1

***If !Used("mwkfarm49")
	If !Used(cTabla)
		Return .F.
	Endif

Case ltipo = 2 Or ltipo = 3

	If !Empty(mPantalla)
		mTipoInsumo = Iif(mPantalla = "E", " FPT_esExterno = 'S' "," FPT_esExterno <> 'S' ")

		mret = SQLExec(mcon1,"delete from ZabFarmPreTmp where FPT_preparacion = ?lidpre and" + mTipoInsumo)
	Else
		mret = SQLExec(mcon1,"delete from ZabFarmPreTmp where FPT_preparacion = ?lidpre ")
	Endif

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

***Select mwkfarm49
	Select &cTabla.
	Go Top

	Dimension vdt[27]
	Scan All

		vdt[1] = &cTabla.._vale
		vdt[2] = &cTabla.._codins
		vdt[3] = &cTabla.._insumo
		vdt[4] = &cTabla.._paciente
		vdt[5] = &cTabla.._cantidad
		vdt[6] = &cTabla.._entregad
		vdt[7] = &cTabla.._tipo
		vdt[8] = &cTabla.._frio
		vdt[9] = &cTabla.._observ
		vdt[10] = &cTabla.._sector
		vdt[11] = &cTabla.._hab
		vdt[12] = &cTabla.._cama
		vdt[13] = &cTabla.._fechaval
		vdt[14] = &cTabla.._cta
		vdt[15] = &cTabla.._horaVal
		vdt[16] = &cTabla.._secu
		vdt[17] = &cTabla.._verifica
		vdt[18] = &cTabla..lpuntero
		vdt[19] = &cTabla..mlcolor
		vdt[20] = &cTabla.._PAC_edad
		vdt[21] = &cTabla.._ENT_descrient
		vdt[22] = &cTabla..enPyxis
		vdt[23] = &cTabla.._gtin
		vdt[24] = &cTabla.._serie
		vdt[25] = &cTabla..esExterno
        vdt[26] = &cTabla..FPT_ParaAlta
        vdt[27] = &cTabla..armario
        
		mret = SQLExec(mcon1,"insert into ZabFarmPreTmp (FPT_vale,FPT_codins,FPT_insumo,FPT_paciente,"+;
			"FPT_cantidad,FPT_entregad,FPT_tipo,FPT_frio,FPT_observ,FPT_sector,FPT_hab,FPT_cama,"+;
			"FPT_fechaval,FPT_cta,FPT_horaval,FPT_secu,FPT_verifica,FPT_lpuntero,FPT_mlcolor,"+;
			"FPT_edad,FPT_descrient,FPT_enPyxis,FPT_gtin,FPT_serie,FPT_esExterno,FPT_preparacion,FPT_comunicaKardex,FPT_ParaAlta,FPT_armario)"+;
			" values "+;
			"(?vdt[1],?vdt[2] ,?vdt[3] ,?vdt[4] ,?vdt[5] ,?vdt[6] ,?vdt[7] ,"+;
			"?vdt[8] ,?vdt[9] ,?vdt[10],?vdt[11],?vdt[12],?vdt[13],?vdt[14],"+;
			"?vdt[15],?vdt[16],?vdt[17],?vdt[18],?vdt[19],?vdt[20],?vdt[21],"+;
			"?vdt[22],?vdt[23],?vdt[24],?vdt[25],?lidpre,?mcomunica,?vdt[26],?vdt[27])")

		If mret < 0
			=Aerr(eros)
			mmsgerr = eros(3)
			mdetalle= "Error Inicialización Log Preparaciones Paso 2"
			Do sp_insert_tabCtrlErr With mdetalle, mmsgerr , mwkusuario.idusuario, "Log Preparaciones"
			Messagebox("Error Inicialización Log Preparaciones Paso 2", 48, "ERROR - FAVOR DE AVISAR A SISTEMAS")
			mretorno = .F.
			Exit
		Endif

		Select &cTabla.

	Endscan

Case ltipo = 4

	Use In Select("mwkfarm49")


	Do Case
	Case mPantalla = "E"
		mTipoInsumo = " and FPT_esExterno = 'S' "
	Case mPantalla = "K"
		mTipoInsumo = " and FPT_esExterno = 'N' "
	Case mPantalla = ""
		mTipoInsumo = ""
	Endcase

***mTipoInsumo = Iif(mPantalla = "E", " FPT_esExterno = 'S' "," FPT_esExterno <> 'S' ")
**mTipoInsumo = Iif(mPantalla = "E", " esExterno = 'S' "," esExterno <> 'S' ")

	mret = SQLExec(mcon1,"select FPT_vale as _vale,FPT_codins as _codins,FPT_insumo as _insumo,FPT_paciente as _paciente,"+;
		"FPT_cantidad as _cantidad,FPT_entregad as _entregad,FPT_tipo as _tipo,FPT_frio as _frio,FPT_observ as _observ,"+;
		"FPT_sector as _sector,FPT_hab as _hab,FPT_cama as _cama,"+;
		"FPT_fechaval as _fechaval,FPT_cta as _cta,FPT_horaval as _horaVal,FPT_secu as _secu,FPT_verifica as _verifica,"+;
		"FPT_lpuntero as lpuntero,FPT_mlcolor as mlcolor,"+;
		"FPT_edad as _PAC_edad,FPT_descrient as _ENT_descrient,FPT_enPyxis as enPyxis,FPT_gtin as _gtin,FPT_serie as _serie,"+;
		"FPT_esExterno as esExterno, FPT_comunicaKardex as comunicaKardex,FPT_entregad,NVL(FPT_ParaAlta,'N') as FPT_ParaAlta, " + ;	
		"nvl(FPT_armario,'   ') as armario " +;	
		"from ZabFarmPreTmp where FPT_preparacion=?lidpre " + mTipoInsumo,"mwkfarm49")

*!*		mret = SQLExec(mcon1,"select FPT_vale as _vale,FPT_codins as _codins,FPT_insumo as _insumo,FPT_paciente as _paciente,"+;
*!*			"FPT_cantidad as _cantidad,FPT_entregad as _entregad,FPT_tipo as _tipo,FPT_frio as _frio,FPT_observ as _observ,"+;
*!*			"FPT_sector as _sector,FPT_hab as _hab,FPT_cama as _cama,"+;
*!*			"FPT_fechaval as _fechaval,FPT_cta as _cta,FPT_horaval as _horaVal,FPT_secu as _secu,FPT_verifica as _verifica,"+;
*!*			"FPT_lpuntero as lpuntero,FPT_mlcolor as mlcolor,"+;
*!*			"FPT_edad as _PAC_edad,FPT_descrient as _ENT_descrient,FPT_enPyxis as enPyxis,FPT_gtin as _gtin,FPT_serie as _serie,"+;
*!*			"FPT_comunicaKardex as comunicaKardex " + ;
*!*			"from ZabFarmPreTmp where FPT_preparacion=?lidpre ","mwkfarm49_1")

	If mret < 0
		=Aerr(eros)
		mmsgerr = eros(3)
		mdetalle= "Error Inicialización Log Preparaciones Paso 4"
		Do sp_insert_tabCtrlErr With mdetalle, mmsgerr , mwkusuario.idusuario, "Log Preparaciones"
		Messagebox("Error Inicialización Log Preparaciones Paso 2", 48, "ERROR - FAVOR DE AVISAR A SISTEMAS")
		mretorno = .F.
	Endif

    
** FPT_esExterno as esExterno,

*!*		Select *, sp_esExternoKardex(_codins ) As esExterno From mwkfarm49_1 Into Cursor mwkfarm49_2

*!*		mStatement = "select * from mwkfarm49_2 where " + mTipoInsumo + " into cursor mwkfarm49"
*!*		&mStatement

*!*		Use In Select("mwkfarm49_1")
*!*		Use In Select("mwkfarm49_2")

Endcase

Return mretorno
