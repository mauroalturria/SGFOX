Lparameters mCodIns

Local lcSql
Local mBusco

Use In Select("mwkBusco2")
Use In Select("mwkBusco1")
Use In Select("mwkBusco3")
Use In Select("mwkBusco4")

mBusco = mCodIns

lcSql = "select INS_codpuntero FROM INSUMOS WHERE INSUMOS.INS_codinsumo = '" + ALLTRIM(mbusco) + "' "

If !Prg_EjecutoSql(lcSql, "mwkbusco1")
    MESSAGEBOX("Error al intentar consultar tabla INSUMOS. ","VALIDACION")
	Return .F.
Endif

If Used("mwkbusco1")
	If Reccount("mwkbusco1")=0
		Messagebox("INSUMO NO UBICADO EN MAESTROS",48,"ATENCION")  && No ocurrira no obstante p/control
	Else
		mPuntero = mwkbusco1.INS_codpuntero

		lcSql = "select TM_Insumo, TM_presentacion FROM TabMedicamentos WHERE TM_Insumo = ?mpuntero "

		If !Prg_EjecutoSql(lcSql, "mwkbusco2")
		    MESSAGEBOX("Error al intentar consultar tabla TABMEDICAMENTOS. ","VALIDACION")
			Return .F.
		Endif

		If Used("mwkbusco2")
			If Reccount("mwkbusco2")=0
				Messagebox("INSUMO NO UBICADO EN BASE DE CONOCIMIENTO"+Chr(10)+"NO SE PUEDE UBICAR REEMPLAZO !!",48,"ATENCION")  && De ser asi Farmacia deberia actualizar su base
			Else
				mpresenta = mwkbusco2.TM_presentacion

				lcSql = "select TMD_Droga FROM TabMediDrogas WHERE TMD_Insumo = ?mpuntero "

				If !Prg_EjecutoSql(lcSql, "mwkbusco3")
				MESSAGEBOX("Error al intentar consultar tabla TABMEDIDROGAS. ","VALIDACION")
					Return .F.
				Endif

				If Used("mwkbusco3")
					If Reccount("mwkbusco3")=0
						Messagebox("DROGA DEL INSUMO NO UBICADA"+Chr(10)+"NOTIFIQUE EL ERROR !!",48,"ATENCION") && Puede ocurrir por omision borrar un isumo de drogas
						Use In Select("mwkbusco3")
						Return .F.
					Else

						mdroga = mwkbusco3.TMD_Droga

						lcSql = "select INSUMOS.INS_codinsumo, TM_descripcion, TMP_Descripcion, TabMediPresentacion.id as lpresenta, TM_insumo" +;
							" From TabMedicamentos" +;
							" Join INSUMOS on INSUMOS.INS_codpuntero = TabMedicamentos.TM_Insumo" +;
							" Join TabMediPresentacion on TabMediPresentacion.id = ?mpresenta" +;
							" Where TM_presentacion = ?mpresenta "+;
							" and TM_insumo in (select TMD_Insumo FROM TabMediDrogas WHERE TMD_Droga = ?mdroga and TMD_Insumo <> ?mpuntero)"

						If !Prg_EjecutoSql(lcSql, "mwkbusco4")
							Use In Select("mwkBusco3")
							Use In Select("mwkBusco4")
							Return .F.
						Endif

						If Used("mwkbusco4")
							If Reccount("mwkbusco4")=0
								Messagebox("No se encuentra Insumo para reemplazar. Verifique.",48,"ATENCION")
								Use In Select("mwkBusco3")
								Use In Select("mwkBusco4")
								Return .F.
							Endif
						Endif

					Endif
				Endif
			Endif
		Endif
	Endif
Endif

Use In Select("mwkBusco1")
Use In Select("mwkBusco2")
Use In Select("mwkBusco3")
Use In Select("mwkBusco4")

Return .T.
