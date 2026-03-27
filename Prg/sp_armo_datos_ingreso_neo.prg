*** Informe Ingreso ***

Parameters midevol,mFecNac

* Aspecto

mIngreso = Chr(13) + "- ASPECTO:" + Chr(13)

If Used("mwkNeoIAspecto")
	If Reccount("mwkNeoIAspecto")>0
		Select mwkNeoIAspecto
*		mIngreso0 = "- ASPECTO:" + Chr(13)
		mIngreso1 = Iif(mwkNeoIAspecto.asp_tempcentral>0,"Temperatura Central: " + Alltrim(Transform(mwkNeoIAspecto.asp_tempcentral))+Chr(13),"")
		mIngreso2 = Iif(mwkNeoIAspecto.asp_tempaxilar>0,"Temperatura Axilar: " + Alltrim(Transform(mwkNeoIAspecto.asp_tempaxilar))+Chr(13),"")
		mIngreso3 = Iif(Empty(mwkNeoIAspecto.asp_aspecto),"",Proper(mwkNeoIAspecto.asp_aspecto) + Chr(13))

		If Len(mIngreso1 + mIngreso2 + mIngreso3)>0
			mIngreso = mIngreso + mIngreso1 + mIngreso2 + mIngreso3
		Endif

	Endif
Endif

* ----------------------------


* Piel

mIngreso = mIngreso + Chr(13) + "- PIEL:" + Chr(13)

If Used("mwkNeoIPiel")
	If Reccount("mwkNeoIPiel")>0
		Select mwkNeoIPiel
*		mIngreso0 = Chr(13) + "- PIEL:" + Chr(13)
		mnColorPiel = mwkNeoIPiel.pie_pielcolor
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
		mIngreso1 =  Iif(!Empty(mcColorPiel),"Color de Piel: " + mcColorPiel + Chr(13),"")
		mIngreso2 =  Iif(!Empty(mwkNeoIPiel.pie_otrospiel),"Nota: " + mwkNeoIPiel.pie_otrospiel + Chr(13),"")
		mIngreso3 =  Iif(!Empty(mwkNeoIPiel.pie_plesion),"Lesiones: " + mwkNeoIPiel.pie_plesion + Chr(13),"")
		mIngreso4 =  Iif(!Empty(mwkNeoIPiel.pie_pnevos),"Nevos: " + mwkNeoIPiel.pie_pnevos + Chr(13),"")
		mIngreso5 =  Iif(!Empty(mwkNeoIPiel.pie_angiomas),"Angiomas: " + mwkNeoIPiel.pie_angiomas + Chr(13),"")
		mIngreso6 =  Iif(!Empty(mwkNeoIPiel.pie_maculas),"Máculas: " + mwkNeoIPiel.pie_maculas + Chr(13),"")
		mIngreso7 =  Iif(!Empty(mwkNeoIPiel.pie_alopesicas),"Zonas Alopésicas: " + mwkNeoIPiel.pie_alopesicas + Chr(13),"")
		mIngreso8 =  Iif(!Empty(mwkNeoIPiel.pie_cefalohemato),"Cefalohematoma: " + mwkNeoIPiel.pie_cefalohemato + Chr(13),"")
		mIngreso9 =  Iif(!Empty(mwkNeoIPiel.pie_caput),"Caput Succedaneum: " + mwkNeoIPiel.pie_caput + Chr(13),"")

		If Len(mIngreso1 + mIngreso2 + mIngreso3 + mIngreso4 + mIngreso5 + mIngreso6 + mIngreso7 + mIngreso8 + mIngreso9)>0
			mIngreso = mIngreso + mIngreso1 + mIngreso2 + mIngreso3 + mIngreso4 + mIngreso5 + mIngreso6 + mIngreso7 + mIngreso8 + mIngreso9
		Endif

	Endif
Endif

* ----------------------------

* Respiratorio

mIngreso = mIngreso + Chr(13) + "- ASPECTO RESPIRATORIO:" + Chr(13)

If Used("mwkNeoIRespira")
	If Reccount("mwkNeoIRespira")>0
		Select mwkNeoIRespira
*		mIngreso0 = Chr(13) + "- ASPECTO RESPIRATORIO:" + Chr(13)
		mIngresoR = Iif(Empty(mwkNeoIRespira.res_sigdifresp),"","Signos de Dificultad Respiratoria: " + Proper(mwkNeoIRespira.res_sigdifresp) + Chr(13))
		mIngresoR = mIngresoR + Iif(Empty(mwkNeoIRespira.res_frecresp),"","Frecuencia Respiratoria: " + Alltrim(mwkNeoIRespira.res_frecresp) + " Resp/Min." + Chr(13))
		mOximetria = Iif(Empty(mwkNeoIRespira.res_preductal),"","Preductal: " + Alltrim(mwkNeoIRespira.res_preductal))+;
			Iif(Empty(mwkNeoIRespira.res_preductalfio2),"", " - Fio2: " + Alltrim(mwkNeoIRespira.res_preductalfio2)) + ;
			Iif(Empty(mwkNeoIRespira.res_postductal),""," / Post-Ductal: " + Alltrim(mwkNeoIRespira.res_postductal)) + ;
			Iif(Empty(mwkNeoIRespira.res_postductalfio2),""," - Fio2: " + Alltrim(mwkNeoIRespira.res_postductalfio2))
		If !Empty(mOximetria)
			mIngresoR = mIngresoR + "Oximetría del pulso (Saturación): " + mOximetria + Chr(13)
		Endif
		mIngresoR = mIngresoR + Iif(mwkNeoIRespira.res_apnea=1,"Apnea: Sí"+Chr(13),Iif(mwkNeoIRespira.res_apnea=2,"Apnea: No"+Chr(13),""))
		mAsistencia = mwkNeoIRespira.res_asistresp

		If mAsistencia>0
			Do Case
			Case mAsistencia = 1
				mIngresoAsis = "ARM"
			Case mAsistencia = 2
				mIngresoAsis = "HALO"
			Case mAsistencia = 3
				mIngresoAsis = "CPAP"
			Case mAsistencia = 4
				mIngresoAsis = "Cánula Nasal"
			Case mAsistencia = 5
				mIngresoAsis = "Cánula Nasal Alto Flujo"
			Case mAsistencia = 6
				mIngresoAsis = "Enfriamiento Pasivo: " + Iif(mwkNeoIRespira.res_enfpasivo=0,"", Alltrim(Str(mwkNeoIRespira.res_enfpasivo)) + " horas"+Chr(13))
			Case mAsistencia = 7
				mIngresoAsis = "Hipotermia Terapéutica: " + Iif(mwkNeoIRespira.res_terapeu=0,"", Alltrim(Str(mwkNeoIRespira.res_terapeu)) + " días"+Chr(13))
			Case mAsistencia = 8
				mIngresoAsis = "iNO: " + Iif(Empty(mwkNeoIRespira.res_ppmon),"", Alltrim(mwkNeoIRespira.res_ppmon) + " ppm" +Chr(13))
			Endcase
			mIngresoR = mIngresoR + "Asistencia Respiratoria: " + mIngresoAsis + Chr(13)
		Endif

		mIngresoR = mIngresoR + Iif(mwkNeoIRespira.res_drenaje=1,"Drenaje: Si" ,Iif(mwkNeoIRespira.res_drenaje=2,"Drenaje: No" + Chr(13),""))
		If mwkNeoIRespira.res_drenaje=1
			mIngresoR = mIngresoR + Iif(Empty(mwkNeoIRespira.res_tipodrena),""," - Tipo de Drenaje: " + Alltrim(Proper(mwkNeoIRespira.res_tipodrena)))
			mIngresoR = mIngresoR + Iif(Empty(mwkNeoIRespira.res_permanencia),""," - Tiempo de Permanencia del drenaje: " + Alltrim(Proper(mwkNeoIRespira.res_permanencia)+Chr(13)))
		Endif
		mIngresoR = mIngresoR + Iif(mwkNeoIRespira.res_hfaltafreq=1,"Alta Frecuencia (HF): Si"+Chr(13),Iif(mwkNeoIRespira.res_hfaltafreq=2,"Alta Frecuencia (HF): No" + Chr(13),""))
		mIngresoR = mIngresoR + Iif(Empty(mwkNeoIRespira.res_medicacion),"","Medicación: " + Proper(mwkNeoIRespira.res_medicacion)+Chr(13))
		mIngresoR = mIngresoR + Iif(Empty(mwkNeoIRespira.res_estudios),"","Estudios: " + Proper(mwkNeoIRespira.res_estudios)+Chr(13))
		mIngresoR = mIngresoR + Iif(Empty(mwkNeoIRespira.res_respotros),"","Datos Relevantes: " + Proper(mwkNeoIRespira.res_respotros)+Chr(13))

		If Len(mIngresoR)>0
			mIngreso = mIngreso + mIngresoR
		Endif

	Endif
Endif

* ----------------------------

* Cardiovascular (Hay que ver cuando carga con el cursor)

mIngreso = mIngreso + Chr(13) + "- ASPECTO CARDIACO:" + Chr(13)

If Used("mwkNeoICardio")
	If Reccount("mwkNeoICardio")>0
		Select mwkNeoICardio
		mCardio12 = Iif(Empty(mwkNeoICardio.car_notascardio),"","Otra Medicación (Notas): " + Alltrim(Proper(mwkNeoICardio.car_notascardio)) + Chr(13))
		mCardioa = Iif(mwkNeoICardio.car_sildena=1,"Sildenafil - ","")
		mCardiob = Iif(mwkNeoICardio.car_pge1=1,"PGE1 - ","")
		mCardioc = Iif(mwkNeoICardio.car_ino=1,"iNO - ","")
		mCardiod = Iif(mwkNeoICardio.car_indomet=1,"Indomet - ","")
		mCardioe = Iif(mwkNeoICardio.car_aas=1,"AAS","")
		mCardio = ""

		If Len(mCardioa + mCardiob + mCardioc + mCardiod + mCardioe)>0
*			mCardio = "Otras Drogas: " + Iif(Empty(mCardioa),"",mCardioa + " - ") + Iif(Empty(mCardiob),"",mCardiob + " - ") + Iif(Empty(mCardioc),"",mCardioc + " - ") + Iif(Empty(mCardiod),"",mCardiod + " - ") + mCardioe
			mCardio = "Otras Drogas: " + mCardioa + mCardiob + mCardioc + mCardiod + mCardioe
			mCardio = Iif(Right(Alltrim(mCardio),1)="-",Left(mCardio,Len(mCardio)-2),mCardio)
		Endif

		mCardio11 = Iif (Empty(mwkNeoICardio.car_estcomple),"","Estudios Complementarios: " + Alltrim(Proper(mwkNeoICardio.car_estcomple)) + Chr(13))
		mCardio10 = Iif (Empty(mwkNeoICardio.car_media),"","TA Media: " + Alltrim(mwkNeoICardio.car_media) + " mmHg" + Chr(13))
		mCardio9 = Iif (Empty(mwkNeoICardio.car_diastolica),"","TA Diastólica: " + Alltrim(mwkNeoICardio.car_diastolica) + " mmHg" + Chr(13))
		mCardio8 = Iif (Empty(mwkNeoICardio.car_sistolica),"","TA Sistólica: " + Alltrim(mwkNeoICardio.car_sistolica) + " mmHg" + Chr(13))
		If Val(mwkNeoICardio.car_freccard)>0
			mCardio7 = Iif (Empty(mwkNeoICardio.car_freccard),"","Frecuencia Cardíaca: " + Alltrim(mwkNeoICardio.car_freccard) + " L/M" + Chr(13))
		Else
			mCardio7 = ""
		Endif
		mCardio5 = Iif (mwkNeoICardio.car_arritmia = 1,"Arritmia: Si" + Chr(13),Iif (mwkNeoICardio.car_arritmia = 2,"Arritmia: No" + Chr(13),""))
		mCardio6 = ""
		If mwkNeoICardio.car_arritmia>0
			mCardio6 = Iif (Empty(mwkNeoICardio.car_descriarritmia),"","Arritmia: " + Alltrim(mwkNeoICardio.car_descriarritmia) + Chr(13))
		Endif
		mCardio4 = Iif (Empty(mwkNeoICardio.car_capilar),"","Relleno Capilar: " + Proper(Alltrim(mwkNeoICardio.car_capilar)) + Chr(13))
		mCardio3 = Iif (Empty(mwkNeoICardio.car_pulperif),"","Pulsos Periféricos: " + Proper(Alltrim(mwkNeoICardio.car_pulperif)) + Chr(13))
		mCardio2 = Iif (Empty(mwkNeoICardio.car_ruidos),"","Ruidos: " + Proper(Alltrim(mwkNeoICardio.car_ruidos)) + Chr(13))
		mCardio1 = Iif (Empty(mwkNeoICardio.car_soplo),"","Soplos: " + Proper(Alltrim(mwkNeoICardio.car_soplo)) + Chr(13))

		If Len(mCardio1 + mCardio2 + mCardio3 + mCardio4 + mCardio5 + mCardio6 + mCardio7 + mCardio8 + mCardio9 + mCardio10 + mCardio11 + mCardio12 + mCardio)>0
*			mIngreso =  mIngreso + Chr(13) + "- ASPECTO CARDIOVASCULAR:" + Chr(13) + Chr(13)
			mIngreso = mIngreso + mCardio1 + mCardio2 + mCardio3 + mCardio4 + mCardio5 + mCardio6 + mCardio7 + mCardio8 + mCardio9 + mCardio10 + mCardio11 
		Endif

	Endif
Endif

If Used("mwkNeoIMedicaCardio_1")
	Use In mwkNeoIMedicaCardio_1
Endif

* Cargo la medicación = Drogas Vasoactivas
*lcSQL = "select * from ZabNeoVarios where var_idevol = ?midevol And var_medcardio = 1 And var_tiporegistro = 'I'"
lcSQL = "select * from ZabNeoVarios inner join tabestados on ZabNeoVarios.VAR_idtipodroga = tabestados.id where var_idevol = ?midevol And var_medcardio = 1 And var_tiporegistro = 'I'"
If !Prg_EjecutoSql(lcSQL,"mwkNeoIMedicaCardio_1")
	Return .F.
Endif


If Used("mwkNeoIMedicaCardio_1")
	If Reccount("mwkNeoIMedicaCardio_1")>0
		Select mwkNeoIMedicaCardio_1
		mIngreso = mIngreso + Chr(13) + "Medicación Cardiovascular:" + Chr(13)
		Scan All
			mMediCardio0 = "Droga: " + Alltrim(Proper(mwkNeoIMedicaCardio_1.Descrip)) + Iif(Empty(mwkNeoIMedicaCardio_1.var_medicamento),""," - Nombre: " + Alltrim(Proper(mwkNeoIMedicaCardio_1.var_medicamento)))
*			mMediCardio1 = "Medicamento: " + Alltrim(Proper(mwkNeoIMedicaCardio_1.var_medicamento))
			mMediCardio2 = "Dosis: " + Alltrim(Proper(mwkNeoIMedicaCardio_1.var_dosis))
			mIngreso = mIngreso + mMediCardio0 + " - " + mMediCardio2 + Chr(13)
		Endscan
	Endif
Endif

mIngreso = mIngreso + mCardio + Chr(13) + mCardio12


* ----------------------------

* Abdominal

mIngreso = mIngreso + Chr(13) + "- ASPECTO ABDOMINAL:" + Chr(13)

If Used("mwkNeoIAbdomen")
	If Reccount("mwkNeoIAbdomen")>0
		Select mwkNeoIAbdomen
		mAbdo = ""
		mAbdo1 = Iif(mwkNeoIAbdomen.abd_sondagng=1,"SOG/SNG: Si" + Chr(13), Iif(mwkNeoIAbdomen.abd_sondagng=2,"SOG/SNG: No" + Chr(13),""))
		mAbdo2 = Iif(mwkNeoIAbdomen.abd_succion=1,"Succión: Si" + Chr(13), Iif(mwkNeoIAbdomen.abd_succion=2,"Succión: No" + Chr(13),""))
		mAbdo3 = Iif(mwkNeoIAbdomen.abd_ruidogas=1,"Residuo Gástrico: Si", Iif(mwkNeoIAbdomen.abd_ruidogas=2,"Residuo Gástrico: No" + Chr(13), ""))
		mAbdo4 = Iif(Empty(mwkNeoIAbdomen.abd_tiporg),""," - Tipo RG: " + Proper(Alltrim(mwkNeoIAbdomen.abd_tiporg)))
		mAbdo5 = Iif(Empty(mwkNeoIAbdomen.abd_cantrg),""," - Cantidad RG: " + Proper(Alltrim(mwkNeoIAbdomen.abd_cantrg))+ " mL" +Chr(13))
		mAbdo6 = Iif(Empty(mwkNeoIAbdomen.abd_examenabdo),"","Exámen Clínico Abdominal: " + Proper(Alltrim(mwkNeoIAbdomen.abd_examenabdo))+Chr(13))
		mAbdo7 = Iif(Empty(mwkNeoIAbdomen.abd_estudiosabdo),"","Estudios Abdominales: " + Proper(Alltrim(mwkNeoIAbdomen.abd_estudiosabdo))+Chr(13))
		mAbdo8 = Iif(Empty(mwkNeoIAbdomen.abd_medicaabdo),"","Medicaciones: " + Proper(Alltrim(mwkNeoIAbdomen.abd_medicaabdo))+Chr(13))
		mAbdo9 = Iif(Empty(mwkNeoIAbdomen.abd_datosabdo),"","Datos Relevantes: " + Proper(Alltrim(mwkNeoIAbdomen.abd_datosabdo))+Chr(13))
		If Len(mAbdo1 + mAbdo2 + mAbdo3 + mAbdo4 + mAbdo5 + mAbdo6 + mAbdo7 + mAbdo8)>0
			mIngreso = mIngreso + mAbdo1 + mAbdo2 + mAbdo3 + mAbdo4 + mAbdo5 + mAbdo6 + mAbdo7 + mAbdo8
		Endif
	Endif
Endif
*-----------------------------------------------------

* Neuro

mIngreso = mIngreso + Chr(13) + "- ASPECTO NEUROLOGICO:" + Chr(13)

If Used("mwkNeoINeuro")
	If Reccount("mwkNeoINeuro")>0
		Select mwkNeoINeuro
		mNeuro = ""
		mopNeuro = mwkNeoINeuro.neu_sensorio
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
		mopTono = mwkNeoINeuro.neu_tono
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

		mNeuro1 = Iif(mwkNeoINeuro.neu_reflejos=1,"Reflejos Arcáicos: Presentes" + Chr(13),Iif(mwkNeoINeuro.neu_reflejos=2,"Reflejos Arcáicos: Ausentes"+Chr(13),""))
		mNeuro2 = Iif(mwkNeoINeuro.neu_convulneuro=1,"Convulsiones: Si" + Chr(13),Iif(mwkNeoINeuro.neu_convulneuro=2,"Convulsiones: No" + Chr(13),""))
		mNeuro3 = Iif(mwkNeoINeuro.neu_apnea=1,"Apnea: Si" + Chr(13),Iif(mwkNeoINeuro.neu_apnea=2,"Apnea: No" + Chr(13),""))
		mNeuro4 = Iif(Empty(mwkNeoINeuro.neu_pupilas),"","Pupilas: " + Proper(Alltrim(mwkNeoINeuro.neu_pupilas))+Chr(13))
		mNeuro5 = Iif(Empty(mwkNeoINeuro.neu_fontanela),"","Fontanela: " + Proper(Alltrim(mwkNeoINeuro.neu_fontanela))+Chr(13))
		mNeuro6 = Iif(Empty(mwkNeoINeuro.neu_estucompneuro),"","Estudios Complementarios: " + Proper(Alltrim(mwkNeoINeuro.neu_estucompneuro))+Chr(13))
		mNeuro7 = Iif(Empty(mwkNeoINeuro.neu_datosneuro),"","Datos Relevantes: " + Proper(Alltrim(mwkNeoINeuro.neu_datosneuro))+Chr(13))

		If Len(mNeuro + mTono + mNeuro1 + mNeuro2 + mNeuro3 + mNeuro4 + mNeuro5 + mNeuro6 + mNeuro7)>0
			mIngreso = mIngreso + mNeuro + Chr(13) + mTono + Chr(13) + mNeuro1 + mNeuro2 + mNeuro3 + mNeuro4 + mNeuro5 + mNeuro6 + mNeuro7
		Endif


* Cargo la medicación de Neuro

		If !Used("mwkNeoIMedicaNeuro")

			lcSQL = "select * from ZabNeoVarios where var_idevol = ?midevol And var_medneuro = 1 And var_tiporegistro = 'I'"
			If !Prg_EjecutoSql(lcSQL,"mwkNeoIMedicaNeuro")
				Return .F.
			Endif
		Endif

		If Used("mwkNeoIMedicaNeuro")
			If Reccount("mwkNeoIMedicaNeuro")>0
				Select mwkNeoIMedicaNeuro
				mIngreso = mIngreso + Chr(13) + "Medicación Neurológica:" + Chr(13)
				Scan All
					mMediNeuro1 = "Medicamento: " + Alltrim(Proper(mwkNeoIMedicaNeuro.var_medicamento))
					mMediNeuro2 = " - Dosis: " + Alltrim(Proper(mwkNeoIMedicaNeuro.var_dosis ))
					mIngreso = mIngreso + mMediNeuro1 + mMediNeuro2 + Chr(13)
				Endscan
			Endif
		Endif



	Endif
Endif

* ------------------------------

* Osteo-Articular y Funcional

mIngreso = mIngreso + Chr(13) + "- ASPECTO OSETO-ARTICULAR Y FUNCIONAL:" + Chr(13)


If Used("mwkNeoIOseo")
	If Reccount("mwkNeoIOseo")>0
		Select mwkNeoIOseo
		mOseo1 = Iif(mwkNeoIOseo.ose_clavicula=1,"Fractura de Clavícula" + Chr(13),"")
		mOseo2 = Iif(mwkNeoIOseo.ose_barlow=1,"Maniobra de Ortolani y Barlow: Positiva" + Chr(13),Iif(mwkNeoIOseo.ose_parabraq=2,"Maniobra de Ortolani y Barlow: Negativa" + Chr(13),""))
		mOseo3 = Iif(mwkNeoIOseo.ose_clickcadera=1,"Click de Cadera: Positiva" + Chr(13),Iif(mwkNeoIOseo.ose_piebot=2,"Click de Cadera: Negativa" + Chr(13),""))
		mOseo4 = Iif(mwkNeoIOseo.ose_parabraq=1,"Parálisis Braquial: Si" + Chr(13),Iif(mwkNeoIOseo.ose_parabraq=2,"Parálisis Braquial: No" + Chr(13),""))
		mOseo5 = Iif(mwkNeoIOseo.ose_piebot=1,"Pie Bot Reductible" + Chr(13),Iif(mwkNeoIOseo.ose_piebot=2,"Pie Bot No Reductible" + Chr(13),""))
		mOseo6 = Iif(Empty(mwkNeoIOseo.ose_datosoesto),"","Datos Relevantes: " + Proper(Alltrim(mwkNeoIOseo.ose_datosoesto))+Chr(13))

		If Len(mOseo1 + mOseo2 + mOseo3 + mOseo4 + mOseo5 + mOseo6)>0
			mIngreso = mIngreso + mOseo1 + mOseo2 + mOseo3 + mOseo4 + mOseo5 + mOseo6
		Endif


	Endif
Endif
* ------------------------------


*!*	* Infecto

mFIngreso = ""
mFIngreso0 = Chr(13) + "- ASPECTO INFECTOLOGICO:"
mFingreso1 = ""
mFingreso2 = ""
mFingreso3 = ""

* General:

If Used("mwkNeoIInfecto")
	If Reccount("mwkNeoIInfecto")>0
		Select mwkNeoIInfecto
		mInfecto1 = Iif(Empty(mwkNeoIInfecto.inf_estcomple),"","Estudios Complementarios: " + Alltrim(Proper(mwkNeoIInfecto.inf_estcomple))+Chr(13))
		mInfecto2 = Iif(Empty(mwkNeoIInfecto.inf_inginfecto),"","Resúmen de Ingreso: " + Alltrim(Proper(mwkNeoIInfecto.inf_inginfecto))+Chr(13))
		If Len(mInfecto1 + mInfecto2)>0
			mFIngreso1 = mFingreso0 + Chr(13) + mInfecto2 + Chr(13) + mInfecto1
		Endif
	Endif
Endif

* Cultivos:

If !Used("mwkNeoICultivo")

	lcSQL = "select * from ZabNeoVarios where var_idevol = ?midevol And var_cultivos = 1 And var_tiporegistro = 'I'"
	If !Prg_EjecutoSql(lcSQL,"mwkNeoICultivo")
		Return .F.
	Endif
Endif

If Used("mwkNeoICultivo")
	If Reccount("mwkNeoICultivo")>0
		Select mwkNeoICultivo
		If Len(mFingreso1)=0
		mFingreso2 = mFingreso0 + Chr(13) + "Cultivos:" + Chr(13)
		Else
		mFingreso2 = Chr(13) + "Cultivos:" + Chr(13)
		endif
*		mIngreso = mIngreso + Chr(13) + "Cultivos:" + Chr(13)
		Scan All
			mCultivo1 = Iif(Empty(mwkNeoICultivo.var_material),"","Material: " + Alltrim(Proper(mwkNeoICultivo.var_material)))
			mCultivo2 = Iif(Empty(mwkNeoICultivo.var_fechaestudios),""," - Fecha: " + Alltrim((Dtoc(mwkNeoICultivo.var_fechaestudios))))
			mCultivo3 = Iif(mwkNeoICultivo.var_optresulta=1,' - Resultado: Positivo',Iif(mwkNeoICultivo.var_optresulta=2,' - Resultado: Negativo',''))
			mCultivo4 = Iif(Empty(mwkNeoICultivo.var_germen),""," - Germen: " + Alltrim(Proper(mwkNeoICultivo.var_germen)))
			mCultivo5 = Iif(Empty(mwkNeoICultivo.var_tratamiento),""," - Tratamiento: " + Alltrim(Proper(mwkNeoICultivo.var_tratamiento)))
			mFIngreso2 = mFIngreso2 + mCultivo1 + mCultivo2 + mCultivo3 + mCultivo4 + mCultivo5 + Chr(13)
		Endscan
	Endif
Endif

* Accesos:

lcSQL = "select * from ZabNeoVarios join TabEstados on TabEstados.id = ZabNeoVarios.VAR_tipoacceso where ZabNeoVarios.var_idevol = ?midevol and ZabNeoVarios.var_tiporegistro = 'I'"
If !Prg_EjecutoSql(lcSQL,"mwkNeoIAccesos1")
	Return .F.
Endif

If Used("mwkNeoIAccesos1")
	If Reccount("mwkNeoIAccesos1")>0
		Select mwkNeoIAccesos1
		If Len(mFingreso2)=0
		mFIngreso3 = mFIngreso0 + Chr(13) + "Accesos:" + Chr(13)
		Else
		mFIngreso3 = Chr(13) + "Accesos:" + Chr(13)
		Endif
		Scan All
			mAccesos1 = Iif(Empty(mwkNeoIAccesos1.Descrip),"","Tipo de Acceso: " + Alltrim(Proper(mwkNeoIAccesos1.Descrip)))
			mAccesos2 = Iif(Empty(mwkNeoIAccesos1.var_localizacion),"","Localización: " + Alltrim(Proper(mwkNeoIAccesos1.var_localizacion)))
			mAccesos3 = Iif(mwkNeoIAccesos1.var_permanencia>0,"Permanencia: " + Alltrim(Transform(mwkNeoIAccesos1.var_permanencia))+" días.","")
			mFIngreso3 = mFIngreso3 + mAccesos1 + " - " + mAccesos2 + " - " + mAccesos3 + Chr(13)
		Endscan
	Endif
Endif

mIngreso = mIngreso + mFingreso1 + mFingreso2 + mFingreso3 + Chr(13)

* Hemato

mIngreso = mIngreso  + Chr(13) + "- ASPECTO HEMATOLOGICO:" + Chr(13)

If Used("mwkNeoIHemato")
	If Reccount("mwkNeoIHemato")>0
		Select mwkNeoIHemato

		mHemato0 = Iif(Empty(mwkNeoIHemato.hem_grupoyfactor),"","Grupo y Factor: " + Alltrim(Upper(mwkNeoIHemato.hem_grupoyfactor))+Chr(13))
		mHemato10 = Iif(Empty(mwkNeoIHemato.hem_otroslabo),"","Otros Laboratorios: " + Proper(Alltrim(mwkNeoIHemato.hem_otroslabo))+Chr(13))
		mHemato1 = Iif(Empty(mwkNeoIHemato.hem_pc),"","PCD: " + Proper(Alltrim(mwkNeoIHemato.hem_pc))+Chr(13))
		mHemato2 = Iif(Empty(mwkNeoIHemato.hem_bit),"","BIT: " + Proper(Alltrim(mwkNeoIHemato.hem_bit))+Chr(13))
		mHemato3 = Iif(Empty(mwkNeoIHemato.hem_bid),"","BID: " + Proper(Alltrim(mwkNeoIHemato.hem_bid))+Chr(13))
		mHemato4 = Iif(Empty(mwkNeoIHemato.hem_hto),"","Hto: " + Proper(Alltrim(mwkNeoIHemato.hem_hto))+Chr(13))
		mHemato5 = Iif(Empty(mwkNeoIHemato.hem_lmt),"","Días de LMT: " + Proper(Alltrim(mwkNeoIHemato.hem_lmt))+Chr(13))
*!*		.cboGyF.RowSource = "" ver esto
*!*		.cboGyF.ControlSource = "" ver esto en la tabla
		mHemato6 = Iif(mwkNeoIHemato.hem_anemia=1,"Anemia del PT: Si" + Chr(13),Iif(mwkNeoIHemato.hem_anemia=2,"Anemia del PT: No" + Chr(13),""))
		mHemato7 = Iif(mwkNeoIHemato.hem_transfusiones=1,"Transfusiones: Si " + Chr(13),Iif(mwkNeoIHemato.hem_transfusiones=2,"Transfusiones: No " + Chr(13),""))
		mHemato8 = ""
		If mwkNeoIHemato.hem_transfusiones=1
			mFecUltTransf = Alltrim(Dtoc(mwkNeoIHemato.hem_ultimatransf))
			mHemato8 = Iif(mFecUltTransf = '01/01/1900',"","Ultima Transfusión: " + mFecUltTransf +Chr(13))
		Endif
		mHemato9 = Iif(Empty(mwkNeoIHemato.hem_reticulo),"","Reticulocitos: " + Proper(Alltrim(mwkNeoIHemato.hem_reticulo))+Chr(13))

		If Len(mHemato0 + mHemato1 + mHemato2 + mHemato3 + mHemato4 + mHemato5 + mHemato6 + mHemato7 + mHemato8 + mHemato9 + mHemato10)>0
			mIngreso = mIngreso + mHemato0 + mHemato1 + mHemato2 + mHemato3 + mHemato4 + mHemato5 + mHemato6 + mHemato7 + mHemato8 + mHemato9 + mHemato10
		Endif

	Endif
Endif

* ------------------------------

* Antropometria

mIngreso = mIngreso + Chr(13) + "- ANTROPOMETRIA:" + Chr(13)

If Used("mwkNeoIAntro")
	If Reccount("mwkNeoIAntro")>0
		Select mwkNeoIAntro
		mAntro1 = Iif(mwkNeoIAntro.ant_peso>0,"Peso al Ingreso: " + Transform(mwkNeoIAntro.ant_peso) + " gramos." ,"")
		mAntro2 = Iif(mwkNeoIAntro.ant_talla>0,"Talla al Ingreso: " + Alltrim(Transform(mwkNeoIAntro.ant_talla,'@99,99')) + " cms." ,"")
		mAntro3 = Iif(mwkNeoIAntro.ant_pc>0,"Perímetro Cefálico al ingreso: " + Alltrim(Transform(mwkNeoIAntro.ant_pc,'@99,99')) + " cms." ,"")
		mAntroP3 = Iif(mwkNeoIAntro.ant_pcper>0," (Percentilo): " + Transform(mwkNeoIAntro.ant_pcper) ,"")
		mAntroP2 = Iif(mwkNeoIAntro.ant_tallaper>0," (Percentilo): " + Transform(mwkNeoIAntro.ant_tallaper) ,"")
		mAntroP1 = Iif(mwkNeoIAntro.ant_pesoper>0," (Percentilo): " + Transform(mwkNeoIAntro.ant_pesoper) , "")

		If Len(mAntro1 + mAntro2 + mAntro3)>0
			mAntro1 = Iif(Empty(mAntro1),"",mAntro1 + mAntroP1 + Chr(13))
			mAntro2 = Iif(Empty(mAntro2),"",mAntro2 + mAntroP2 + Chr(13))
			mAntro3 = Iif(Empty(mAntro3),"",mAntro3 + mAntroP3 + Chr(13))
			mIngreso = mIngreso + mAntro1 + mAntro2 + mAntro3
		Endif

	Endif
Endif
* ------------------------------

* Oftalmo

mIngreso = mIngreso + Chr(13) + "- ASPECTO OFTALMOLOGICO:" + Chr(13)

If Used("mwkNeoIOftalmo")
	If Reccount("mwkNeoIOftalmo")>0
		Select mwkNeoIOftalmo
		mOftalmo1 = Iif(Empty(mwkNeoIOftalmo.oft_datos),"","Datos Clínicos: " + Alltrim(Proper(mwkNeoIOftalmo.oft_datos)) + Chr(13))
		mOftalmo2 = Iif(mwkNeoIOftalmo.oft_fondojo=1,"Fondo de Ojo: Si" + Chr(13),Iif(mwkNeoIOftalmo.oft_fondojo=2,"Fondo de Ojo: No" + Chr(13),""))
		mOftalmo3 = Iif(Empty(mwkNeoIOftalmo.oft_fechaproxctrl),"","Fecha de Próximo Control: " + Alltrim(mwkNeoIOftalmo.oft_fechaproxctrl)+ Chr(13))
		mOftalmo4 = Iif(Empty(mwkNeoIOftalmo.oft_medicacion),"","Medicación: " + Proper(Alltrim(mwkNeoIOftalmo.oft_medicacion)) + Chr(13))

		If Len(mOftalmo1 + mOftalmo2 + mOftalmo3 + mOftalmo4)>0
			mIngreso = mIngreso + mOftalmo1 + mOftalmo2 + mOftalmo3 + mOftalmo4
		Endif
	Endif
Endif


* ------------------------------

* Metabolico

* Cargo Pesquisas

mIngreso = mIngreso + Chr(13) + "- ASPECTO METABOLICO:" + Chr(13)

If !Used("mwkNeoIngPesq")

	lcSQL = "select * from ZabNeoVarios where var_idevol = ?midevol and var_pesquisa = 1 and var_tiporegistro = 'I' order by var_fechahora desc"

	If !Prg_EjecutoSql(lcSQL,"mwkNeoIngPesq")
		Return .F.
	Endif
Endif

If Used("mwkNeoIngPesq")
	If Reccount("mwkNeoIngPesq")>0
		Select mwkNeoIngPesq
		mIngreso = mIngreso + Chr(13) + "- PESQUISA NEONATAL:" + Chr(13)
		Scan All
			mPesq1 = Iif(mwkNeoIngPesq.var_nropesq>0,"Nro de Pesquisa: " + Transform(mwkNeoIngPesq.var_nropesq) + " - ","")
			mPesq2 = Iif(Empty(mwkNeoIngPesq.var_fechaestudios),""," Fecha de Estudio: " + Dtoc(mwkNeoIngPesq.var_fechaestudios) + " - ")
			mPesq3 = Iif(Empty(mwkNeoIngPesq.var_resultado),""," Resultado: " + Alltrim(Proper(mwkNeoIngPesq.var_resultado))+ " - ")
			mPesq4 = Iif(Empty(mwkNeoIngPesq.var_nota),""," Nota: " + Alltrim(Proper(mwkNeoIngPesq.var_nota)))
			mIngreso = mIngreso + mPesq1 + mPesq2 + mPesq3 + mPesq4 + Chr(13)
		Endscan
	Endif
Endif

* Trastornos metabólicos

If Used("mwkNeoIMetabo")
	If Reccount("mwkNeoIMetabo")>0
		Select mwkNeoIMetabo

		mMeta1 = Iif(mwkNeoIMetabo.met_acimetabo=1,"Acidosis Metabólica" + Chr(13),"")
		mMeta2 = Iif(mwkNeoIMetabo.met_acirespi=1,"Acidosis Respiratoria" + Chr(13),"")
		mMeta3 = Iif(mwkNeoIMetabo.met_alcmetabo=1,"Alcalosis Metabólica" + Chr(13),"")
		mMeta4 = Iif(mwkNeoIMetabo.met_alcarespi=1,"Alcalosis Respiratoria" + Chr(13),"")
		mMeta5 = Iif(mwkNeoIMetabo.met_hipercalcemia=1,"Hipercalcemia" + Chr(13),"")
		mMeta6 = Iif(mwkNeoIMetabo.met_hiperglu=1,"Hiperglucemia" + Chr(13),"")
		mMeta7 = Iif(mwkNeoIMetabo.met_hipercalemia=1,"HiperKalemia" + Chr(13),"")
		mMeta8 = Iif(mwkNeoIMetabo.met_hipernatremia=1,"Hipernatremia" + Chr(13),"")
		mMeta9 = Iif(mwkNeoIMetabo.met_hipocalcemia=1,"Hipocalcemia" + Chr(13),"")
		mMeta10 = Iif(mwkNeoIMetabo.met_hipoglu=1,"Hipoglucemia" + Chr(13),"")
		mMeta11 = Iif(mwkNeoIMetabo.met_hipocalemia=1,"HipoKalemia" + Chr(13),"")
		mMeta12 = Iif(mwkNeoIMetabo.met_hiponatremia=1,"Hiponatremia" + Chr(13),"")
		mMeta13 = Iif(mwkNeoIMetabo.met_osteopenia=1,"Osteopenia" + Chr(13),"")
		mMeta14 = Iif(mwkNeoIMetabo.met_otros=1,"Otros trastornos metabólicos" + Chr(13),"")
		mMeta15 = Iif(Empty(mwkNeoIMetabo.met_otrostrasto),"",Proper(Alltrim(mwkNeoIMetabo.met_otrostrasto)))

		If Len(mMeta1 + mMeta2 + mMeta3 + mMeta4 + mMeta5 + mMeta6 + mMeta7 + mMeta8 + mMeta9 + mMeta10 + mMeta11 + mMeta12 + mMeta13 + mMeta14 + mMeta15) > 0
			If Len(mMeta14)>0
				mMeta14 = mMeta14 + mMeta15
			Endif
			mIngreso = mIngreso + "- TRASTORNOS METABOLICOS: " + Chr(13) + mMeta1 + mMeta2 + mMeta3 + mMeta4 + mMeta5 + mMeta6 + mMeta7 + mMeta8 + mMeta9 + mMeta10 + mMeta11 + mMeta12 + mMeta13 + mMeta14
		Endif

	Endif
Endif


* ------------------------------

* Nutricional

mIngreso = mIngreso + Chr(13) + "- ASPECTO NUTRICIONAL:" + Chr(13)

If Used("mwkNeoINutri")
	If Reccount("mwkNeoINutri")>0
		Select mwkNeoINutri

		mNutri1 = Iif(mwkNeoINutri.nut_ayuno=1,"Ayuno: Si" + Chr(13),Iif(mwkNeoINutri.nut_ayuno=2,"Ayuno: No" + Chr(13),""))
		mNutri2 = Iif(mwkNeoINutri.nut_npt=1,"NPT: Si" + Chr(13),Iif(mwkNeoINutri.nut_npt=2,"NPT: No" + Chr(13),""))
		mNutri3 = Iif(Empty(mwkNeoINutri.nut_composicion),"","Composición: " + Proper(Alltrim(mwkNeoINutri.nut_composicion)) + Chr(13))
		mNutri4 = Iif(Empty(mwkNeoINutri.nut_php),"","PHP: " + Proper(Alltrim(mwkNeoINutri.nut_php)) + Chr(13))
		mNutri5 = Iif(mwkNeoINutri.nut_viaenteral=1,"Vía Enteral: Si" + Chr(13),Iif(mwkNeoINutri.nut_viaenteral=2,"Vía Enteral: No" + Chr(13),""))
		mNutri6 = Iif(Empty(mwkNeoINutri.nut_aporte),"","Aporte: " + Alltrim(Proper(mwkNeoINutri.nut_aporte)) + Chr(13))
		mNutri7 = Iif(Empty(mwkNeoINutri.nut_aportecalprot),"","Aporte Calórico/Proteico: " + Alltrim(Proper(mwkNeoINutri.nut_aportecalprot)) + Chr(13))
		mNutri8 = Iif(Empty(mwkNeoINutri.nut_tcm),"","TCM %: " + Alltrim(Proper(mwkNeoINutri.nut_tcm)) + Chr(13))
		mNutri9 = Iif(Empty(mwkNeoINutri.nut_tipoleche),"","Tipo de Leche: " + Alltrim(Proper(mwkNeoINutri.nut_tipoleche)) + Chr(13))
		mNutri10 = Iif(Empty(mwkNeoINutri.nut_polime),"","Polimerosa %: " + Alltrim(Proper(mwkNeoINutri.nut_polime)) + Chr(13))
		mNutri11 = Iif(Empty(mwkNeoINutri.nut_incremento),"","Incremento Semanal de Peso: " + Alltrim(Proper(mwkNeoINutri.nut_incremento)) + Chr(13))
		mNutri12 = Iif(Empty(mwkNeoINutri.nut_formadmin),"","Forma de Administración: " + Alltrim(Proper(mwkNeoINutri.nut_formadmin)) + Chr(13))
		mNutri13 = Iif(Empty(mwkNeoINutri.nut_fechaViaoral),"","Fecha de Inicio de la Vía Oral: " + Alltrim(Dtoc(mwkNeoINutri.nut_fechaViaoral)) + Chr(13))

		If Len(mNutri1 + mNutri2 + mNutri3 + mNutri4 + mNutri5 + mNutri6 + mNutri7 + mNutri8 + mNutri9 + mNutri10 + mNutri11 + mNutri12 + mNutri13)>0
			mIngreso = mIngreso + mNutri1 + mNutri2 + mNutri3 + mNutri4 + mNutri5 + mNutri6 + mNutri7 + mNutri8 + mNutri9 + mNutri10 + mNutri11 + mNutri12 + mNutri13
		Endif

	Endif
Endif

* ------------------------------

* Malformaciones

If !Used("mwkNeoMalforma")
	lcSQL = "select * from ZabNeoIEMalforma join tabestados on ZabNeoIEMalforma.MAL_nromalforma = tabestados.id "+;
		" where ZabNeoIEMalforma.MAL_idevol = ?midevol and mal_tiporegistro = 'I' order by mal_fechahora desc"
	If !Prg_EjecutoSql(lcSQL,"mwkNeoMalforma")
		Return .F.
	Endif
Endif

Select mwkNeoMalforma
Go Top In mwkNeoMalforma

If Used("mwkNeoMalforma")
	If Reccount("mwkNeoMalforma")>0
		mIngreso = mIngreso + Chr(13) + "- MALFORMACIONES: " + Chr(13)
		Scan All
			mMalfo1 = Iif(Empty(mwkNeoMalforma.Descrip),"","Tipo: " + Alltrim(Proper(mwkNeoMalforma.Descrip)))
			mMalfo2 = Iif(Empty(mwkNeoMalforma.mal_otrasdescrip),""," - Descripción: " + Alltrim(Proper(mwkNeoMalforma.mal_otrasdescrip)))
			mIngreso = mIngreso + mMalfo1 + mMalfo2 + Chr(13)
		Endscan
	Endif
Endif

* ------------------------------

* Quirofano
If Used("mwkNeoIQuiro")
	If Reccount("mwkNeoIQuiro")>0
		Select mwkNeoIQuiro
		mIngreso = mIngreso + Iif(Empty(mwkNeoIQuiro.qui_quiro),"",Chr(13) + "- ASPECTO QUIRURGICO: " + Chr(13) + Alltrim(Proper(mwkNeoIQuiro.qui_quiro)))
	Endif
Endif
* ------------------------------

Return mIngreso
