*** Evolución ***

Parameters mAsp,midevol

mTextoE = ""

If Vartype(mAsp)#'N'
	Return
Endif

Do Case

Case mAsp = 1
* Aspecto

	If Used("mwkNeoEAspecto")
		If Reccount("mwkNeoEAspecto")>0
			Select mwkNeoEAspecto
*		mTextoE0 = "- ASPECTO:" + Chr(13)
			mTextoE1 = Iif(mwkNeoEAspecto.asp_tempcentral>0,"Temperatura Central: " + Alltrim(Transform(mwkNeoEAspecto.asp_tempcentral))+Chr(13),"")
			mTextoE2 = Iif(mwkNeoEAspecto.asp_tempaxilar>0,"Temperatura Axilar: " + Alltrim(Transform(mwkNeoEAspecto.asp_tempaxilar))+Chr(13),"")
			mTextoE3 = Iif(Empty(mwkNeoEAspecto.asp_aspecto),"",Proper(mwkNeoEAspecto.asp_aspecto) + Chr(13))

			If Len(mTextoE1 + mTextoE2 + mTextoE3)>0
				mTextoE = Chr(13) + "- ASPECTO:" + Chr(13)
				mTextoE = mTextoE + mTextoE1 + mTextoE2 + mTextoE3
			Endif

		Endif
	Endif

* ----------------------------

Case mAsp = 2
* Piel

	If Used("mwkNeoEPiel")
		If Reccount("mwkNeoEPiel")>0
			Select mwkNeoEPiel
*		mTextoE0 = Chr(13) + "- PIEL:" + Chr(13)
			mnColorPiel = mwkNeoEPiel.pie_pielcolor
			mcColorPiel = ""
			Do Case
			Case mnColorPiel = 1
				mcColorPiel = "Rosado"
			Case mnColorPiel = 2
				mcColorPiel = "Cianosis"
			Case mnColorPiel = 3
				mcColorPiel = "Pálido"
			Case mnColorPiel = 4
				mcColorPiel = "Ictérico"
			Case mnColorPiel = 5
				mcColorPiel = "Otros"
			Otherwise
				mcColorPiel = ""
			Endcase
			mTextoE1 =  Iif(!Empty(mcColorPiel),"Color de Piel: " + mcColorPiel + Chr(13),"")
			mTextoE2 =  Iif(!Empty(mwkNeoEPiel.pie_otrospiel),"Nota: " + mwkNeoEPiel.pie_otrospiel + Chr(13),"")
			mTextoE3 =  Iif(!Empty(mwkNeoEPiel.pie_plesion),"Lesiones: " + mwkNeoEPiel.pie_plesion + Chr(13),"")
			mTextoE4 =  Iif(!Empty(mwkNeoEPiel.pie_pnevos),"Nevos: " + mwkNeoEPiel.pie_pnevos + Chr(13),"")
			mTextoE5 =  Iif(!Empty(mwkNeoEPiel.pie_angiomas),"Angiomas: " + mwkNeoEPiel.pie_angiomas + Chr(13),"")
			mTextoE6 =  Iif(!Empty(mwkNeoEPiel.pie_maculas),"Máculas: " + mwkNeoEPiel.pie_maculas + Chr(13),"")
			mTextoE7 =  Iif(!Empty(mwkNeoEPiel.pie_alopesicas),"Zonas Alopésicas: " + mwkNeoEPiel.pie_alopesicas + Chr(13),"")
			mTextoE8 =  Iif(!Empty(mwkNeoEPiel.pie_cefalohemato),"Cefalohematoma: " + mwkNeoEPiel.pie_cefalohemato + Chr(13),"")
			mTextoE9 =  Iif(!Empty(mwkNeoEPiel.pie_caput),"Caput Succedaneum: " + mwkNeoEPiel.pie_caput + Chr(13),"")

			If Len(mTextoE1 + mTextoE2 + mTextoE3 + mTextoE4 + mTextoE5 + mTextoE6 + mTextoE7 + mTextoE8 + mTextoE9)>0
				mTextoE = Chr(13) + "- PIEL:" + Chr(13)
				mTextoE = mTextoE + mTextoE1 + mTextoE2 + mTextoE3 + mTextoE4 + mTextoE5 + mTextoE6 + mTextoE7 + mTextoE8 + mTextoE9
			Endif

		Endif
	Endif

* ----------------------------

Case mAsp = 3
* Respiratorio

	If Used("mwkNeoERespira")
		If Reccount("mwkNeoERespira")>0
			Select mwkNeoERespira
*		mTextoE0 = Chr(13) + "- ASPECTO RESPIRATORIO:" + Chr(13)
			mTextoER = Iif(Empty(mwkNeoERespira.res_sigdifresp),"","Signos de Dificultad Respiratoria: " + Proper(mwkNeoERespira.res_sigdifresp) + Chr(13))
			mTextoER = mTextoER + Iif(Empty(mwkNeoERespira.res_frecresp),"","Frecuencia Respiratoria: " + Alltrim(mwkNeoERespira.res_frecresp) + " Resp/Min." + Chr(13))
			mOximetria = Iif(Empty(mwkNeoERespira.res_preductal),"","Preductal: " + Alltrim(mwkNeoERespira.res_preductal))+;
				Iif(Empty(mwkNeoERespira.res_preductalfio2),"", " - Fio2: " + Alltrim(mwkNeoERespira.res_preductalfio2)) + ;
				Iif(Empty(mwkNeoERespira.res_postductal),""," / Post-Ductal: " + Alltrim(mwkNeoERespira.res_postductal)) + ;
				Iif(Empty(mwkNeoERespira.res_postductalfio2),""," - Fio2: " + Alltrim(mwkNeoERespira.res_postductalfio2))
			If !Empty(mOximetria)
				mTextoER = mTextoER + "Oximetría del pulso (Saturación): " + mOximetria + Chr(13)
			Endif
			mTextoER = mTextoER + Iif(mwkNeoERespira.res_apnea=1,"Apnea: Sí"+Chr(13),Iif(mwkNeoERespira.res_apnea=2,"Apnea: No"+Chr(13),""))
			mAsistencia = mwkNeoERespira.res_asistresp

			If mAsistencia>0
				Do Case
				Case mAsistencia = 1
					mTextoEAsis = "ARM"
				Case mAsistencia = 2
					mTextoEAsis = "HALO"
				Case mAsistencia = 3
					mTextoEAsis = "CPAP"
				Case mAsistencia = 4
					mTextoEAsis = "Cánula Nasal"
				Case mAsistencia = 5
					mTextoEAsis = "Cánula Nasal Alto Flujo"
				Case mAsistencia = 6
					mTextoEAsis = "Enfriamiento Pasivo: " + Iif(mwkNeoERespira.res_enfpasivo=0,"", Alltrim(Str(mwkNeoERespira.res_enfpasivo)) + " horas"+Chr(13))
				Case mAsistencia = 7
					mTextoEAsis = "Hipotermia Terapéutica: " + Iif(mwkNeoERespira.res_terapeu=0,"", Alltrim(Str(mwkNeoERespira.res_terapeu)) + " días"+Chr(13))
				Case mAsistencia = 8
					mTextoEAsis = "iNO: " + Iif(Empty(mwkNeoERespira.res_ppmon),"", Alltrim(mwkNeoERespira.res_ppmon) + " ppm" +Chr(13))
				Endcase
				mTextoER = mTextoER + "Asistencia Respiratoria: " + mTextoEAsis + Chr(13)
			Endif

			mTextoER = mTextoER + Iif(mwkNeoERespira.res_drenaje=1,"Drenaje: Si" ,Iif(mwkNeoERespira.res_drenaje=2,"Drenaje: No" + Chr(13),""))
			If mwkNeoERespira.res_drenaje=1
				mTextoER = mTextoER + Iif(Empty(mwkNeoERespira.res_tipodrena),""," - Tipo de Drenaje: " + Alltrim(Proper(mwkNeoERespira.res_tipodrena)))
				mTextoER = mTextoER + Iif(Empty(mwkNeoERespira.res_permanencia),""," - Tiempo de Permanencia del drenaje: " + Alltrim(Proper(mwkNeoERespira.res_permanencia)+Chr(13)))
			Endif
			mTextoER = mTextoER + Iif(mwkNeoERespira.res_hfaltafreq=1,"Alta Frecuencia (HF): Si"+Chr(13),Iif(mwkNeoERespira.res_hfaltafreq=2,"Alta Frecuencia (HF): No" + Chr(13),""))
			mTextoER = mTextoER + Iif(Empty(mwkNeoERespira.res_medicacion),"","Medicación: " + Proper(mwkNeoERespira.res_medicacion)+Chr(13))
			mTextoER = mTextoER + Iif(Empty(mwkNeoERespira.res_estudios),"","Estudios: " + Proper(mwkNeoERespira.res_estudios)+Chr(13))
			mTextoER = mTextoER + Iif(Empty(mwkNeoERespira.res_respotros),"","Datos Relevantes: " + Proper(mwkNeoERespira.res_respotros)+Chr(13))

			If Len(mTextoER)>0
				mTextoE = Chr(13) + "- ASPECTO RESPIRATORIO:" + Chr(13)
				mTextoE = mTextoE + mTextoER
			Endif

		Endif
	Endif

* ----------------------------

Case mAsp = 4
* Cardiovascular (Hay que ver cuando carga con el cursor)

	If Used("mwkNeoECardio")
		If Reccount("mwkNeoECardio")>0
			Select mwkNeoECardio
			mCardio12 = Iif(Empty(mwkNeoECardio.car_notascardio),"","Otras Drogas (Notas): " + Alltrim(Proper(mwkNeoECardio.car_notascardio)) + Chr(13))
			mCardioa = Iif(mwkNeoECardio.car_sildena=1,"Sildenafil - ","")
			mCardiob = Iif(mwkNeoECardio.car_pge1=1,"PGE1 - ","")
			mCardioc = Iif(mwkNeoECardio.car_ino=1,"iNO - ","")
			mCardiod = Iif(mwkNeoECardio.car_indomet=1,"Indomet - ","")
			mCardioe = Iif(mwkNeoECardio.car_aas=1,"AAS","")
			mCardio = ""

			If Len(mCardioa + mCardiob + mCardioc + mCardiod + mCardioe)>0
*			mCardio = "Otras Drogas: " + Iif(Empty(mCardioa),"",mCardioa + " - ") + Iif(Empty(mCardiob),"",mCardiob + " - ") + Iif(Empty(mCardioc),"",mCardioc + " - ") + Iif(Empty(mCardiod),"",mCardiod + " - ") + mCardioe
				mCardio = "Otras Drogas: " + mCardioa + mCardiob + mCardioc + mCardiod + mCardioe
				mCardio = Iif(Right(Alltrim(mCardio),1)="-",Left(mCardio,Len(mCardio)-2),mCardio)
			Endif

			mCardio11 = Iif (Empty(mwkNeoECardio.car_estcomple),"","Estudios Complementarios: " + Alltrim(Proper(mwkNeoECardio.car_estcomple)) + Chr(13))
			mCardio10 = Iif (Empty(mwkNeoECardio.car_media),"","TA Media: " + Alltrim(mwkNeoECardio.car_media) + " mmHg" + Chr(13))
			mCardio9 = Iif (Empty(mwkNeoECardio.car_diastolica),"","TA Diastólica: " + Alltrim(mwkNeoECardio.car_diastolica) + " mmHg" + Chr(13))
			mCardio8 = Iif (Empty(mwkNeoECardio.car_sistolica),"","TA Sistólica: " + Alltrim(mwkNeoECardio.car_sistolica) + " mmHg" + Chr(13))
			If Val(mwkNeoECardio.car_freccard)>0
				mCardio7 = Iif (Empty(mwkNeoECardio.car_freccard),"","Frecuencia Cardíaca: " + Alltrim(mwkNeoECardio.car_freccard) + " L/M" + Chr(13))
			Else
				mCardio7 = ""
			Endif
			mCardio5 = Iif (mwkNeoECardio.car_arritmia = 1,"Arritmia: Si" + Chr(13),Iif (mwkNeoECardio.car_arritmia = 2,"Arritmia: No" + Chr(13),""))
			mCardio6 = ""
			If mwkNeoECardio.car_arritmia>0
				mCardio6 = Iif (Empty(mwkNeoECardio.car_descriarritmia),"","Arritmia: " + Alltrim(mwkNeoECardio.car_descriarritmia) + Chr(13))
			Endif
			mCardio4 = Iif (Empty(mwkNeoECardio.car_capilar),"","Relleno Capilar: " + Proper(Alltrim(mwkNeoECardio.car_capilar)) + Chr(13))
			mCardio3 = Iif (Empty(mwkNeoECardio.car_pulperif),"","Pulsos Periféricos: " + Proper(Alltrim(mwkNeoECardio.car_pulperif)) + Chr(13))
			mCardio2 = Iif (Empty(mwkNeoECardio.car_ruidos),"","Ruidos: " + Proper(Alltrim(mwkNeoECardio.car_ruidos)) + Chr(13))
			mCardio1 = Iif (Empty(mwkNeoECardio.car_soplo),"","Soplos: " + Proper(Alltrim(mwkNeoECardio.car_soplo)) + Chr(13))

			If Len(mCardio1 + mCardio2 + mCardio3 + mCardio4 + mCardio5 + mCardio6 + mCardio7 + mCardio8 + mCardio9 + mCardio10 + mCardio11 + mCardio12 + mCardio)>0
*			mTextoE =  mTextoE + Chr(13) + "- ASPECTO CARDIOVASCULAR:" + Chr(13) + Chr(13)
				mTextoE = Chr(13) + "- ASPECTO CARDIACO:" + Chr(13)
				mTextoE = mTextoE + mCardio1 + mCardio2 + mCardio3 + mCardio4 + mCardio5 + mCardio6 + mCardio7 + mCardio8 + mCardio9 + mCardio10 + mCardio11 
			Endif

		Endif
	Endif

	If Used("mwkNeoEMedicaCardio_1")
		Use In mwkNeoEMedicaCardio_1
	Endif

* Cargo la medicación = Drogas Vasoactivas
*   lcSQL = "select * from ZabNeoVarios where var_idevol = ?midevol And var_medcardio = 1 And var_tiporegistro = 'I'"
*   lcSQL = "select * from ZabNeoVarios inner join tabestados on ZabNeoVarios.VAR_idtipodroga = tabestados.id where var_idevol = ?midevol And var_medcardio = 1 And var_tiporegistro = 'E'"
*	If !Prg_EjecutoSql(lcSQL,"mwkNeoEMedicaCardio_1")
*		Return .F.
*	Endif

mCardio = ''

*!*		If Used("mwkNeoEMedicaCardio_1")
*!*			If Reccount("mwkNeoEMedicaCardio_1")>0
*!*				Select mwkNeoEMedicaCardio_1
*!*				mTextoE = mTextoE + Chr(13) + "Medicación Cardiovascular:" + Chr(13)
*!*				Scan All
*!*					mMediCardio0 = "Droga: " + Alltrim(Proper(mwkNeoEMedicaCardio_1.Descrip)) + Iif(Empty(mwkNeoEMedicaCardio_1.var_medicamento),""," - Nombre: " + Alltrim(Proper(mwkNeoEMedicaCardio_1.var_medicamento)))
*!*	*			mMediCardio1 = "Medicamento: " + Alltrim(Proper(mwkNeoEMedicaCardio_1.var_medicamento))
*!*					mMediCardio2 = "Dosis: " + Alltrim(Proper(mwkNeoEMedicaCardio_1.var_dosis))
*!*					mTextoE = mTextoE + mMediCardio0 + " - " + mMediCardio2 + Chr(13)
*!*				Endscan
*!*			Endif
*!*		Endif

mTextoE = mTextoE + mCardio + Chr(13) + mCardio12

* ----------------------------

Case mAsp = 5
* Abdominal

	If Used("mwkNeoEAbdomen")
		If Reccount("mwkNeoEAbdomen")>0
			Select mwkNeoEAbdomen
			mAbdo = ""
			mAbdo1 = Iif(mwkNeoEAbdomen.abd_sondagng=1,"SOG/SNG: Si" + Chr(13), Iif(mwkNeoEAbdomen.abd_sondagng=2,"SOG/SNG: No" + Chr(13),""))
			mAbdo2 = Iif(mwkNeoEAbdomen.abd_succion=1,"Succión: Si" + Chr(13), Iif(mwkNeoEAbdomen.abd_succion=2,"Succión: No" + Chr(13),""))
			mAbdo3 = Iif(mwkNeoEAbdomen.abd_ruidogas=1,"Residuo Gástrico: Si", Iif(mwkNeoEAbdomen.abd_ruidogas=2,"Residuo Gástrico: No" + Chr(13), ""))
			mAbdo4 = Iif(Empty(mwkNeoEAbdomen.abd_tiporg),""," - Tipo RG: " + Proper(Alltrim(mwkNeoEAbdomen.abd_tiporg)))
			mAbdo5 = Iif(Empty(mwkNeoEAbdomen.abd_cantrg),""," - Cantidad RG: " + Proper(Alltrim(mwkNeoEAbdomen.abd_cantrg))+ " mL" +Chr(13))
			mAbdo6 = Iif(Empty(mwkNeoEAbdomen.abd_examenabdo),"","Exámen Clínico Abdominal: " + Proper(Alltrim(mwkNeoEAbdomen.abd_examenabdo))+Chr(13))
			mAbdo7 = Iif(Empty(mwkNeoEAbdomen.abd_estudiosabdo),"","Estudios Abdominales: " + Proper(Alltrim(mwkNeoEAbdomen.abd_estudiosabdo))+Chr(13))
			mAbdo8 = Iif(Empty(mwkNeoEAbdomen.abd_medicaabdo),"","Medicaciones: " + Proper(Alltrim(mwkNeoEAbdomen.abd_medicaabdo))+Chr(13))
			mAbdo9 = Iif(Empty(mwkNeoEAbdomen.abd_datosabdo),"","Datos Relevantes: " + Proper(Alltrim(mwkNeoEAbdomen.abd_datosabdo))+Chr(13))
			If Len(mAbdo1 + mAbdo2 + mAbdo3 + mAbdo4 + mAbdo5 + mAbdo6 + mAbdo7 + mAbdo8)>0
				mTextoE = Chr(13) + "- ASPECTO ABDOMINAL:" + Chr(13)
				mTextoE = mTextoE + mAbdo1 + mAbdo2 + mAbdo3 + mAbdo4 + mAbdo5 + mAbdo6 + mAbdo7 + mAbdo8
			Endif
		Endif
	Endif
*-----------------------------------------------------

* Neuro
Case mAsp = 6

	If Used("mwkNeoENeuro")
		If Reccount("mwkNeoENeuro")>0
			Select mwkNeoENeuro
			mNeuro = ""
			mopNeuro = mwkNeoENeuro.neu_sensorio
			Do Case
			Case mopNeuro = 1
				mNeuro = "Sensorio: Normal"
			Case mopNeuro = 2
				mNeuro = "Sensorio: Deprimido"
			Case mopNeuro = 3
				mNeuro = "Sensorio: Alternante"
			Case mopNeuro = 4
				mNeuro = "Sensorio: Excitado"
			Otherwise
				mNeuro = ""
			Endcase

			mTono = ""
			mopTono = mwkNeoENeuro.neu_tono
			Do Case
			Case mopTono = 1
				mTono = "Tono: Normal"
			Case mopTono = 2
				mTono = "Tono: Hipotónico"
			Case mopTono = 3
				mTono = "Tono: Hipertónico"
			Otherwise
				mTono = ""
			Endcase

			mNeuro1 = Iif(mwkNeoENeuro.neu_reflejos=1,"Reflejos Arcáicos: Presentes" + Chr(13),Iif(mwkNeoENeuro.neu_reflejos=2,"Reflejos Arcáicos: Ausentes"+Chr(13),""))
			mNeuro2 = Iif(mwkNeoENeuro.neu_convulneuro=1,"Convulsiones: Si" + Chr(13),Iif(mwkNeoENeuro.neu_convulneuro=2,"Convulsiones: No" + Chr(13),""))
			mNeuro3 = Iif(mwkNeoENeuro.neu_apnea=1,"Apnea: Si" + Chr(13),Iif(mwkNeoENeuro.neu_apnea=2,"Apnea: No" + Chr(13),""))
			mNeuro4 = Iif(Empty(mwkNeoENeuro.neu_pupilas),"","Pupilas: " + Proper(Alltrim(mwkNeoENeuro.neu_pupilas))+Chr(13))
			mNeuro5 = Iif(Empty(mwkNeoENeuro.neu_fontanela),"","Fontanela: " + Proper(Alltrim(mwkNeoENeuro.neu_fontanela))+Chr(13))
			mNeuro6 = Iif(Empty(mwkNeoENeuro.neu_estucompneuro),"","Estudios Complementarios: " + Proper(Alltrim(mwkNeoENeuro.neu_estucompneuro))+Chr(13))
			mNeuro7 = Iif(Empty(mwkNeoENeuro.neu_datosneuro),"","Datos Relevantes: " + Proper(Alltrim(mwkNeoENeuro.neu_datosneuro))+Chr(13))

			If Len(mNeuro + mTono + mNeuro1 + mNeuro2 + mNeuro3 + mNeuro4 + mNeuro5 + mNeuro6 + mNeuro7)>0
				mTextoE = Chr(13) + "- ASPECTO NEUROLOGICO:" + Chr(13)
				mTextoE = mTextoE + mNeuro + Chr(13) + mTono + Chr(13) + mNeuro1 + mNeuro2 + mNeuro3 + mNeuro4 + mNeuro5 + mNeuro6 + mNeuro7
			Endif


* Cargo la medicación de Neuro

*!*				If !Used("mwkNeoEMedicaNeuro")

*!*					lcSQL = "select * from ZabNeoVarios where var_idevol = ?midevol And var_medneuro = 1 And var_tiporegistro = 'E'"
*!*					If !Prg_EjecutoSql(lcSQL,"mwkNeoEMedicaNeuro")
*!*						Return .F.
*!*					Endif
*!*				Endif

*!*				If Used("mwkNeoEMedicaNeuro")
*!*					If Reccount("mwkNeoEMedicaNeuro")>0
*!*						Select mwkNeoEMedicaNeuro
*!*						mTextoE = mTextoE + Chr(13) + "Medicación Neurológica:" + Chr(13)
*!*						Scan All
*!*							mMediNeuro1 = "Medicamento: " + Alltrim(Proper(mwkNeoEMedicaNeuro.var_medicamento))
*!*							mMediNeuro2 = " - Dosis: " + Alltrim(Proper(mwkNeoEMedicaNeuro.var_dosis ))
*!*							mTextoE = mTextoE + mMediNeuro1 + mMediNeuro2 + Chr(13)
*!*						Endscan
*!*					Endif
*!*				Endif



		Endif
	Endif

* ------------------------------

Case mAsp = 7
* Osteo-Articular y Funcional

	If Used("mwkNeoEOseo")
		If Reccount("mwkNeoEOseo")>0
			Select mwkNeoEOseo
			mOseo1 = Iif(mwkNeoEOseo.ose_clavicula=1,"Fractura de Clavícula" + Chr(13),"")
			mOseo2 = Iif(mwkNeoEOseo.ose_barlow=1,"Maniobra de Ortolani y Barlow: Positiva" + Chr(13),Iif(mwkNeoEOseo.ose_parabraq=2,"Maniobra de Ortolani y Barlow: Negativa" + Chr(13),""))
			mOseo3 = Iif(mwkNeoEOseo.ose_clickcadera=1,"Click de Cadera: Positiva" + Chr(13),Iif(mwkNeoEOseo.ose_piebot=2,"Click de Cadera: Negativa" + Chr(13),""))
			mOseo4 = Iif(mwkNeoEOseo.ose_parabraq=1,"Parálisis Braquial: Si" + Chr(13),Iif(mwkNeoEOseo.ose_parabraq=2,"Parálisis Braquial: No" + Chr(13),""))
			mOseo5 = Iif(mwkNeoEOseo.ose_piebot=1,"Pie Bot Reductible" + Chr(13),Iif(mwkNeoEOseo.ose_piebot=2,"Pie Bot No Reductible" + Chr(13),""))
			mOseo6 = Iif(Empty(mwkNeoEOseo.ose_datosoesto),"","Datos Relevantes: " + Proper(Alltrim(mwkNeoEOseo.ose_datosoesto))+Chr(13))

			If Len(mOseo1 + mOseo2 + mOseo3 + mOseo4 + mOseo5 + mOseo6)>0
				mTextoE = Chr(13) + "- ASPECTO OSETO-ARTICULAR Y FUNCIONAL:" + Chr(13)
				mTextoE = mTextoE + mOseo1 + mOseo2 + mOseo3 + mOseo4 + mOseo5 + mOseo6
			Endif


		Endif
	Endif
* ------------------------------

Case mAsp = 8
*!*	* Infecto

* General:

	If Used("mwkNeoEInfecto")
		If Reccount("mwkNeoEInfecto")>0
			Select mwkNeoEInfecto
			mInfecto1 = Iif(Empty(mwkNeoEInfecto.inf_estcomple),"","Estudios Complementarios: " + Alltrim(Proper(mwkNeoEInfecto.inf_estcomple))+Chr(13))
			mInfecto2 = Iif(Empty(mwkNeoEInfecto.inf_inginfecto),"","Resúmen de Ingreso: " + Alltrim(Proper(mwkNeoEInfecto.inf_inginfecto))+Chr(13))
			If Len(mInfecto1 + mInfecto2)>0
				mTextoE = Chr(13) + "- ASPECTO INFECTOLOGICO:" + Chr(13)
				mTextoE = mTextoE + mInfecto2 + Chr(13) + mInfecto1
			Endif
		Endif
	Endif


* ----------------------------

Case mAsp = 9
* Hemato

	If Used("mwkNeoEHemato")
		If Reccount("mwkNeoEHemato")>0
			Select mwkNeoEHemato

			mHemato0 = Iif(Empty(mwkNeoEHemato.hem_grupoyfactor),"","Grupo y Factor: " + Alltrim(Upper(mwkNeoEHemato.hem_grupoyfactor))+Chr(13))
			mHemato10 = Iif(Empty(mwkNeoEHemato.hem_otroslabo),"","Otros Laboratorios: " + Proper(Alltrim(mwkNeoEHemato.hem_otroslabo))+Chr(13))
			mHemato1 = Iif(Empty(mwkNeoEHemato.hem_pc),"","PCD: " + Proper(Alltrim(mwkNeoEHemato.hem_pc))+Chr(13))
			mHemato2 = Iif(Empty(mwkNeoEHemato.hem_bit),"","BIT: " + Proper(Alltrim(mwkNeoEHemato.hem_bit))+Chr(13))
			mHemato3 = Iif(Empty(mwkNeoEHemato.hem_bid),"","BID: " + Proper(Alltrim(mwkNeoEHemato.hem_bid))+Chr(13))
			mHemato4 = Iif(Empty(mwkNeoEHemato.hem_hto),"","Hto: " + Proper(Alltrim(mwkNeoEHemato.hem_hto))+Chr(13))
			mHemato5 = Iif(Empty(mwkNeoEHemato.hem_lmt),"","Días de LMT: " + Proper(Alltrim(mwkNeoEHemato.hem_lmt))+Chr(13))
*!*		.cboGyF.RowSource = "" ver esto
*!*		.cboGyF.ControlSource = "" ver esto en la tabla
			mHemato6 = Iif(mwkNeoEHemato.hem_anemia=1,"Anemia del PT: Si" + Chr(13),Iif(mwkNeoEHemato.hem_anemia=2,"Anemia del PT: No" + Chr(13),""))
			mHemato7 = Iif(mwkNeoEHemato.hem_transfusiones=1,"Transfusiones: Si " + Chr(13),Iif(mwkNeoEHemato.hem_transfusiones=2,"Transfusiones: No " + Chr(13),""))
			mHemato8 = ""
			If mwkNeoEHemato.hem_transfusiones=1
				mFecUltTransf = Alltrim(Dtoc(mwkNeoEHemato.hem_ultimatransf))
				mHemato8 = Iif(mFecUltTransf = '01/01/1900',"","Ultima Transfusión: " + mFecUltTransf +Chr(13))
			Endif
			mHemato9 = Iif(Empty(mwkNeoEHemato.hem_reticulo),"","Reticulocitos: " + Proper(Alltrim(mwkNeoEHemato.hem_reticulo))+Chr(13))

			If Len(mHemato0 + mHemato1 + mHemato2 + mHemato3 + mHemato4 + mHemato5 + mHemato6 + mHemato7 + mHemato8 + mHemato9 + mHemato10)>0
				mTextoE = Chr(13) + "- ASPECTO HEMATOLOGICO:" + Chr(13)
				mTextoE = mTextoE + mHemato0 + mHemato1 + mHemato2 + mHemato3 + mHemato4 + mHemato5 + mHemato6 + mHemato7 + mHemato8 + mHemato9 + mHemato10
			Endif

		Endif
	Endif

* ------------------------------

Case mAsp = 10
* Antropometria

	If Used("mwkNeoEAntro")
		If Reccount("mwkNeoEAntro")>0
			Select mwkNeoEAntro
			mAntro1 = Iif(mwkNeoEAntro.ant_peso>0,"Peso: " + Transform(mwkNeoEAntro.ant_peso) + " gramos." ,"")
			mAntro2 = Iif(mwkNeoEAntro.ant_talla>0,"Talla: " + Alltrim(Transform(mwkNeoEAntro.ant_talla,'99,99')) + " cms." ,"")
			mAntro3 = Iif(mwkNeoEAntro.ant_pc>0,"Perímetro Cefálico: " + Alltrim(Transform(mwkNeoEAntro.ant_pc,'99,99')) + " cms." ,"")
			mAntroP3 = Iif(mwkNeoEAntro.ant_pcper>0," (Percentilo): " + Transform(mwkNeoEAntro.ant_pcper) ,"")
			mAntroP2 = Iif(mwkNeoEAntro.ant_tallaper>0," (Percentilo): " + Transform(mwkNeoEAntro.ant_tallaper) ,"")
			mAntroP1 = Iif(mwkNeoEAntro.ant_pesoper>0," (Percentilo): " + Transform(mwkNeoEAntro.ant_pesoper) , "")

			If Len(mAntro1 + mAntro2 + mAntro3)>0
				mTextoE = Chr(13) + "- ANTROPOMETRIA:" + Chr(13)
				mAntro1 = Iif(Empty(mAntro1),"",mAntro1 + mAntroP1 + Chr(13))
				mAntro2 = Iif(Empty(mAntro2),"",mAntro2 + mAntroP2 + Chr(13))
				mAntro3 = Iif(Empty(mAntro3),"",mAntro3 + mAntroP3 + Chr(13))
				mTextoE = mTextoE + mAntro1 + mAntro2 + mAntro3
			Endif

		Endif
	Endif
* ------------------------------

Case mAsp = 11
* Oftalmo

	If Used("mwkNeoEOftalmo")
		If Reccount("mwkNeoEOftalmo")>0
			Select mwkNeoEOftalmo
			mOftalmo1 = Iif(Empty(mwkNeoEOftalmo.oft_datos),"","Datos Clínicos: " + Alltrim(Proper(mwkNeoEOftalmo.oft_datos)) + Chr(13))
			mOftalmo2 = Iif(mwkNeoEOftalmo.oft_fondojo=1,"Fondo de Ojo: Si" + Chr(13),Iif(mwkNeoEOftalmo.oft_fondojo=2,"Fondo de Ojo: No" + Chr(13),""))
			mOftalmo3 = Iif(Empty(mwkNeoEOftalmo.oft_fechaproxctrl),"","Fecha de Próximo Control: " + Alltrim(mwkNeoEOftalmo.oft_fechaproxctrl)+ Chr(13))
			mOftalmo4 = Iif(Empty(mwkNeoEOftalmo.oft_medicacion),"","Medicación: " + Proper(Alltrim(mwkNeoEOftalmo.oft_medicacion)) + Chr(13))

			If Len(mOftalmo1 + mOftalmo2 + mOftalmo3 + mOftalmo4)>0
				mTextoE = Chr(13) + "- ASPECTO OFTALMOLOGICO:" + Chr(13)
				mTextoE = mTextoE + mOftalmo1 + mOftalmo2 + mOftalmo3 + mOftalmo4
			Endif
		Endif
	Endif


* ------------------------------

Case mAsp = 12
* Metabolico

* Trastornos metabólicos

	If Used("mwkNeoEMetabo")
		If Reccount("mwkNeoEMetabo")>0
			Select mwkNeoEMetabo

			mMeta1 = Iif(mwkNeoEMetabo.met_acimetabo=1,"Acidosis Metabólica" + Chr(13),"")
			mMeta2 = Iif(mwkNeoEMetabo.met_acirespi=1,"Acidosis Respiratoria" + Chr(13),"")
			mMeta3 = Iif(mwkNeoEMetabo.met_alcmetabo=1,"Alcalosis Metabólica" + Chr(13),"")
			mMeta4 = Iif(mwkNeoEMetabo.met_alcarespi=1,"Alcalosis Respiratoria" + Chr(13),"")
			mMeta5 = Iif(mwkNeoEMetabo.met_hipercalcemia=1,"Hipercalcemia" + Chr(13),"")
			mMeta6 = Iif(mwkNeoEMetabo.met_hiperglu=1,"Hiperglucemia" + Chr(13),"")
			mMeta7 = Iif(mwkNeoEMetabo.met_hipercalemia=1,"HiperKalemia" + Chr(13),"")
			mMeta8 = Iif(mwkNeoEMetabo.met_hipernatremia=1,"Hipernatremia" + Chr(13),"")
			mMeta9 = Iif(mwkNeoEMetabo.met_hipocalcemia=1,"Hipocalcemia" + Chr(13),"")
			mMeta10 = Iif(mwkNeoEMetabo.met_hipoglu=1,"Hipoglucemia" + Chr(13),"")
			mMeta11 = Iif(mwkNeoEMetabo.met_hipocalemia=1,"HipoKalemia" + Chr(13),"")
			mMeta12 = Iif(mwkNeoEMetabo.met_hiponatremia=1,"Hiponatremia" + Chr(13),"")
			mMeta13 = Iif(mwkNeoEMetabo.met_osteopenia=1,"Osteopenia" + Chr(13),"")
			mMeta14 = Iif(mwkNeoEMetabo.met_otros=1,"Otros trastornos metabólicos" + Chr(13),"")
			mMeta15 = Iif(Empty(mwkNeoEMetabo.met_otrostrasto),"",Proper(Alltrim(mwkNeoEMetabo.met_otrostrasto)))

			If Len(mMeta1 + mMeta2 + mMeta3 + mMeta4 + mMeta5 + mMeta6 + mMeta7 + mMeta8 + mMeta9 + mMeta10 + mMeta11 + mMeta12 + mMeta13 + mMeta14 + mMeta15) > 0
				If Len(mMeta14)>0
					mMeta14 = mMeta14 + mMeta15
				Endif
				mTextoE = mTextoE + "- TRASTORNOS METABOLICOS: " + Chr(13) + mMeta1 + mMeta2 + mMeta3 + mMeta4 + mMeta5 + mMeta6 + mMeta7 + mMeta8 + mMeta9 + mMeta10 + mMeta11 + mMeta12 + mMeta13 + mMeta14
			Endif

		Endif
	Endif


* ------------------------------

Case mAsp = 13
* Nutricional

	If Used("mwkNeoENutri")
		If Reccount("mwkNeoENutri")>0
			Select mwkNeoENutri

			mNutri1 = Iif(mwkNeoENutri.nut_ayuno=1,"Ayuno: Si" + Chr(13),Iif(mwkNeoENutri.nut_ayuno=2,"Ayuno: No" + Chr(13),""))
			mNutri2 = Iif(mwkNeoENutri.nut_npt=1,"NPT: Si" + Chr(13),Iif(mwkNeoENutri.nut_npt=2,"NPT: No" + Chr(13),""))
			mNutri3 = Iif(Empty(mwkNeoENutri.nut_composicion),"","Composición: " + Proper(Alltrim(mwkNeoENutri.nut_composicion)) + Chr(13))
			mNutri4 = Iif(Empty(mwkNeoENutri.nut_php),"","PHP: " + Proper(Alltrim(mwkNeoENutri.nut_php)) + Chr(13))
			mNutri5 = Iif(mwkNeoENutri.nut_viaenteral=1,"Vía Enteral: Si" + Chr(13),Iif(mwkNeoENutri.nut_viaenteral=2,"Vía Enteral: No" + Chr(13),""))
			mNutri6 = Iif(Empty(mwkNeoENutri.nut_aporte),"","Aporte: " + Alltrim(Proper(mwkNeoENutri.nut_aporte)) + Chr(13))
			mNutri7 = Iif(Empty(mwkNeoENutri.nut_aportecalprot),"","Aporte Calórico/Proteico: " + Alltrim(Proper(mwkNeoENutri.nut_aportecalprot)) + Chr(13))
			mNutri8 = Iif(Empty(mwkNeoENutri.nut_tcm),"","TCM %: " + Alltrim(Proper(mwkNeoENutri.nut_tcm)) + Chr(13))
			mNutri9 = Iif(Empty(mwkNeoENutri.nut_tipoleche),"","Tipo de Leche: " + Alltrim(Proper(mwkNeoENutri.nut_tipoleche)) + Chr(13))
			mNutri10 = Iif(Empty(mwkNeoENutri.nut_polime),"","Polimerosa %: " + Alltrim(Proper(mwkNeoENutri.nut_polime)) + Chr(13))
			mNutri11 = Iif(Empty(mwkNeoENutri.nut_incremento),"","Incremento Semanal de Peso: " + Alltrim(Proper(mwkNeoENutri.nut_incremento)) + Chr(13))
			mNutri12 = Iif(Empty(mwkNeoENutri.nut_formadmin),"","Forma de Administración: " + Alltrim(Proper(mwkNeoENutri.nut_formadmin)) + Chr(13))
			mNutri13 = Iif(mwkNeoENutri.nut_fechaViaoral=Ctod('01/01/1900'),"","Fecha de Inicio de la Vía Oral: " + Alltrim(Dtoc(mwkNeoENutri.nut_fechaViaoral)) + Chr(13))

			If Len(mNutri1 + mNutri2 + mNutri3 + mNutri4 + mNutri5 + mNutri6 + mNutri7 + mNutri8 + mNutri9 + mNutri10 + mNutri11 + mNutri12 + mNutri13)>0
				mTextoE = Chr(13) + "- ASPECTO NUTRICIONAL:" + Chr(13)
				mTextoE = mTextoE + mNutri1 + mNutri2 + mNutri3 + mNutri4 + mNutri5 + mNutri6 + mNutri7 + mNutri8 + mNutri9 + mNutri10 + mNutri11 + mNutri12 + mNutri13
			Endif

		Endif
	Endif

* ------------------------------

Case mAsp = 14
* Malformaciones

	If !Used("mwkNeoMalforma")
		lcSQL = "select * from ZabNeoIEMalforma join tabestados on ZabNeoIEMalforma.MAL_nromalforma = tabestados.id "+;
			" where ZabNeoIEMalforma.MAL_idevol = ?midevol and mal_tiporegistro = 'E' order by mal_fechahora desc"
		If !Prg_EjecutoSql(lcSQL,"mwkNeoMalforma")
			Return .F.
		Endif
	Endif

	Select mwkNeoMalforma
	Go Top In mwkNeoMalforma

	If Used("mwkNeoMalforma")
		If Reccount("mwkNeoMalforma")>0
			mTextoE = mTextoE + Chr(13) + "- MALFORMACIONES: " + Chr(13)
			Scan All
				mMalfo1 = Iif(Empty(mwkNeoMalforma.Descrip),"","Tipo: " + Alltrim(Proper(mwkNeoMalforma.Descrip)))
				mMalfo2 = Iif(Empty(mwkNeoMalforma.mal_otrasdescrip),""," - Descripción: " + Alltrim(Proper(mwkNeoMalforma.mal_otrasdescrip)))
				mTextoE = mTextoE + mMalfo1 + mMalfo2 + Chr(13)
			Endscan
		Endif
	Endif

* ------------------------------

Case mAsp = 15
* Quirofano
	If Used("mwkNeoEQuiro")
		If Reccount("mwkNeoEQuiro")>0
			Select mwkNeoEQuiro
			mTextoE = mTextoE + Iif(Empty(mwkNeoEQuiro.qui_quiro),"","- ASPECTO QUIRURGICO: " + Chr(13) + Alltrim(Proper(mwkNeoEQuiro.qui_quiro)))
		Endif
	Endif
* ------------------------------

Case mAsp = 16
* Cultivos:

	If Used("mwkNeoECultivo")
		Use In mwkNeoECultivo
	Endif

	lcSQL = "select * from ZabNeoVarios where var_idevol = ?midevol and var_cultivos = 1 and var_tiporegistro = 'E' order by var_fechahora desc"
*	lcSQL = "select * from ZabNeoVarios where var_idevol = ?midevol And var_cultivos = 1 And var_tiporegistro = 'E'"
	If !Prg_EjecutoSql(lcSQL,"mwkNeoECultivo")
		Return .F.
	Endif


	If Used("mwkNeoECultivo")
		If Reccount("mwkNeoECultivo")>0
			Select mwkNeoECultivo
			mTextoE = mTextoE + Chr(13) + "Cultivos:" + Chr(13)
			Scan All
				mCultivo1 = Iif(Empty(mwkNeoECultivo.var_material),"","Material: " + Alltrim(Proper(mwkNeoECultivo.var_material)))
				mCultivo2 = Iif(Empty(mwkNeoECultivo.var_fechaestudios),""," - Fecha: " + Alltrim((Dtoc(mwkNeoECultivo.var_fechaestudios))))
				mCultivo3 = Iif(mwkNeoECultivo.var_optresulta=1,' - Resultado: Positivo',Iif(mwkNeoECultivo.var_optresulta=2,' - Resultado: Negativo',''))
				mCultivo4 = Iif(Empty(mwkNeoECultivo.var_germen),""," - Germen: " + Alltrim(Proper(mwkNeoECultivo.var_germen)))
				mCultivo5 = Iif(Empty(mwkNeoECultivo.var_tratamiento),""," - Tratamiento: " + Alltrim(Proper(mwkNeoECultivo.var_tratamiento)))
				mTextoE = mTextoE + mCultivo1 + mCultivo2 + mCultivo3 + mCultivo4 + mCultivo5 + Chr(13)
			Endscan
		Endif
	Endif

Case mAsp = 17
* Accesos:

	lcSQL = "select * from ZabNeoVarios join TabEstados on TabEstados.id = ZabNeoVarios.VAR_tipoacceso where ZabNeoVarios.var_idevol = ?midevol and ZabNeoVarios.var_tiporegistro = 'E'"
	If !Prg_EjecutoSql(lcSQL,"mwkNeoEAccesos1")
		Return .F.
	Endif

	If Used("mwkNeoEAccesos1")
		If Reccount("mwkNeoEAccesos1")>0
			Select mwkNeoEAccesos1
			mTextoE = mTextoE + Chr(13) + "Accesos:" + Chr(13)
			Scan All
				mAccesos1 = Iif(Empty(mwkNeoEAccesos1.Descrip),"","Tipo de Acceso: " + Alltrim(Proper(mwkNeoEAccesos1.Descrip)))
				mAccesos2 = Iif(Empty(mwkNeoEAccesos1.var_localizacion),"","Localización: " + Alltrim(Proper(mwkNeoEAccesos1.var_localizacion)))
				mAccesos3 = Iif(mwkNeoEAccesos1.var_permanencia>0,"Permanencia: " + Alltrim(Transform(mwkNeoEAccesos1.var_permanencia))+" días.","")

				mTextoE = mTextoE + mAccesos1 + " - " + mAccesos2 + " - " + mAccesos3 + Chr(13)
			Endscan
		Endif
	Endif


Case mAsp = 18
Case mAsp = 19
Case mAsp = 20
* Pesquisa

* Cargo Pesquisas


	If !Used("mwkNeoEngPesq")

		lcSQL = "select * from ZabNeoVarios where var_idevol = ?midevol and var_pesquisa = 1 and var_tiporegistro = 'E' order by var_fechahora desc"

		If !Prg_EjecutoSql(lcSQL,"mwkNeoEPesq")
			Return .F.
		Endif
	Endif

	If Used("mwkNeoEPesq")
		If Reccount("mwkNeoEPesq")>0
			Select mwkNeoEPesq
			mTextoE = mTextoE + Chr(13) + "- PESQUISA NEONATAL:" + Chr(13)
			Scan All
				mPesq1 = Iif(mwkNeoEPesq.var_nropesq>0,"Nro de Pesquisa: " + Transform(mwkNeoEPesq.var_nropesq) + " - ","")
				mPesq2 = Iif(Empty(mwkNeoEPesq.var_fechaestudios),""," Fecha de Estudio: " + Dtoc(mwkNeoEPesq.var_fechaestudios) + " - ")
				mPesq3 = Iif(Empty(mwkNeoEPesq.var_resultado),""," Resultado: " + Alltrim(Proper(mwkNeoEPesq.var_resultado))+ " - ")
				mPesq4 = Iif(Empty(mwkNeoEPesq.var_nota),""," Nota: " + Alltrim(Proper(mwkNeoEPesq.var_nota)))
				mTextoE = mTextoE + mPesq1 + mPesq2 + mPesq3 + mPesq4 + Chr(13)
			Endscan
		Endif
	Endif


Endcase

Return mTextoE


