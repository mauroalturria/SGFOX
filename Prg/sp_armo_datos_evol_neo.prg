* EVOLUCION *

Parameters mAsp

mTextoE = ""

* Aspecto

Do case

Case mASp = 1


If Used("mwkNeoEAspecto")
	If Reccount("mwkNeoEAspecto")>0
		Select mwkNeoEAspecto
		mTextoE1 = Iif(mwkNeoEAspecto.asp_tempcentral>0,"Temperatura Central: " + Alltrim(Transform(mwkNeoEAspecto.asp_tempcentral))+Chr(13),"")
		mTextoE2 = Iif(mwkNeoEAspecto.asp_tempaxilar>0,"Temperatura Axilar: " + Alltrim(Transform(mwkNeoEAspecto.asp_tempaxilar))+Chr(13),"")
		mTextoE3 = Iif(Empty(mwkNeoEAspecto.asp_aspecto),"",Proper(mwkNeoEAspecto.asp_aspecto) + Chr(13))
		
		If Len(mTextoE1 + mTextoE2 + mTextoE3)>0
			mTextoE0 = Chr(13) + "- ASPECTO:" + Chr(13) 
			mTextoE = mTextoE0 + mTextoE1 + mTextoE2 + mTextoE3
		Endif

	Endif
Endif

Return mTextoE


* ----------------------------

Case mAsp = 2

* Piel

If Used("mwkNeoEPiel")
	If Reccount("mwkNeoEPiel")>0
		Select mwkNeoEPiel
*		mIngreso0 = Chr(13) + "- PIEL:" + Chr(13)
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
			mTextoE0 = Chr(13) + "- PIEL:" + Chr(13) 
			mTextoE = mTextoE0 + mTextoE1 + mTextoE2 + mTextoE3 + mTextoE4 + mTextoE5 + mTextoE6 + mTextoE7 + mTextoE8 + mTextoE9
		Endif

	Endif
Endif

Return mTextoE

Endcase


* ----------------------------

* Respiratorio

mIngreso = mIngreso + Chr(13) + "- ASPECTO RESPIRATORIO:" + Chr(13) 

If Used("mwkNeoERespira")
	If Reccount("mwkNeoERespira")>0
		Select mwkNeoERespira
*		mIngreso0 = Chr(13) + "- ASPECTO RESPIRATORIO:" + Chr(13)
		mIngresoR = Iif(Empty(mwkNeoERespira.res_sigdifresp),"","Signos de Dificultad Respiratoria: " + Proper(mwkNeoERespira.res_sigdifresp)+Chr(13))
		mIngresoR = mIngresoR + Iif(Empty(mwkNeoERespira.res_frecresp),"","Frecuencia Respiratoria: " + Alltrim(mwkNeoERespira.res_frecresp)+Chr(13))
		mOximetria = Iif(Empty(mwkNeoERespira.res_preductal),"","Preductal: " + Alltrim(mwkNeoERespira.res_preductal))+;
			Iif(Empty(mwkNeoERespira.res_preductalfio2),"", " - Fio2: " + Alltrim(mwkNeoERespira.res_preductalfio2)) + ;
			Iif(Empty(mwkNeoERespira.res_postductal),""," / Post-Ductal: " + Alltrim(mwkNeoERespira.res_postductal)) + ;
			Iif(Empty(mwkNeoERespira.res_postductalfio2),""," - Fio2: " + Alltrim(mwkNeoERespira.res_postductalfio2))
		If !Empty(mOximetria)
			mIngresoR = mIngresoR + "Oximetría del pulso (Saturación): " + mOximetria + Chr(13)
		Endif
		mIngresoR = mIngresoR + Iif(mwkNeoERespira.res_apnea=1,"Apnea: Sí"+Chr(13),Iif(mwkNeoERespira.res_apnea=2,"Apnea: No"+Chr(13),""))
		mAsistencia = mwkNeoERespira.res_asistresp
		If mAsistencia>1
			mIngresoR = mIngresoR + "Asistencia Respiratoria: "
			Do Case
			Case mAsistencia = 1
				mIngresoR = mIngresoR + "ARM"
			Case mAsistencia = 2
				mIngresoR = mIngresoR + "HALO"
			Case mAsistencia = 3
				mIngresoR = mIngresoR + "CPAP"
			Case mAsistencia = 4
				mIngresoR = mIngresoR + "Cánula Nasal"
			Case mAsistencia = 5
				mIngresoR = mIngresoR + "Cánula Nasal Alto Flujo"
			Case mAsistencia = 6
				mIngresoR = mIngresoR + "Enfriamiento Pasivo: " + Iif(Empty(mwkNeoERespira.res_enfpasivo),"", Proper(mwkNeoERespira.res_enfpasivo) + " horas"+Chr(13))
			Case mAsistencia = 7
				mIngresoR = mIngresoR + "Hipotermia Terapéutica: " + Iif(Empty(mwkNeoERespira.res_terapeu),"", Proper(mwkNeoERespira.res_terapeu) + " días"+Chr(13))
			Case mAsistencia = 8
				mIngresoR = mIngresoR + "iNO: " + Iif(Empty(mwkNeoERespira.res_ppmon),"", Proper(mwkNeoERespira.res_ppmon) + " ppm" +Chr(13))
			Endcase
		Endif
		mIngresoR = mIngresoR + Iif(mwkNeoERespira.res_drenaje=1,"Drenaje: Si" ,Iif(mwkNeoERespira.res_drenaje=2,"Drenaje: No" + Chr(13),""))
		If mwkNeoERespira.res_drenaje=1
			mIngresoR = mIngresoR + Iif(Empty(mwkNeoERespira.res_tipodrena),""," - Tipo de Drenaje: " + Proper(mwkNeoERespira.res_tipodrena))
			mIngresoR = mIngresoR + Iif(Empty(mwkNeoERespira.res_permanencia),""," - Tiempo de Permanencia del drenaje: " + Proper(mwkNeoERespira.res_permanencia)+Chr(13))
		Endif
		mIngresoR = mIngresoR + Iif(Empty(mwkNeoERespira.res_medicacion),"","Medicación: " + Proper(mwkNeoERespira.res_medicacion)+Chr(13))
		mIngresoR = mIngresoR + Iif(Empty(mwkNeoERespira.res_estudios),"","Estudios: " + Proper(mwkNeoERespira.res_estudios)+Chr(13))
		mIngresoR = mIngresoR + Iif(Empty(mwkNeoERespira.res_respotros),"","Otros: " + Proper(mwkNeoERespira.res_respotros)+Chr(13))

		If Len(mIngresoR)>0
			mIngreso = mIngreso + mIngresoR
		Endif

	Endif
Endif

* ----------------------------

* Cardiovascular (Hay que ver cuando carga con el cursor)

mIngreso = mIngreso + Chr(13) + "- ASPECTO CARDIACO:" + Chr(13) 

If Used("mwkNeoECardio")
	If Reccount("mwkNeoECardio")>0
		Select mwkNeoICardio
		mCardio12 = Iif(Empty(mwkNeoICardio.car_otrasdrogas),"","Otras Drogas: " + Chr(13) + Alltrim(Proper(mwkNeoICardio.car_otrasdrogas))+Chr(13))
		mCardioa = Iif(mwkNeoICardio.car_sildena=1,"Sildenafil = Si" + Chr(13),"")
		mCardiob = Iif(mwkNeoICardio.car_pge1=1,"PGE1 = Si" + Chr(13),"")
		mCardioc = Iif(mwkNeoICardio.car_ino=1,"iNO = Si" + Chr(13),"")
		mCardiod = Iif(mwkNeoICardio.car_indomet=1,"Indomet = Si" + Chr(13),"")
		mCardioe = Iif(mwkNeoICardio.car_aas=1,"AAS = Si" + Chr(13),"")
		mCardio = ""
		If Len(mCardioa + mCardiob + mCardioc + mCardiod + mCardioe)>0
			mCardio = "Otras Drogas:" + Chr(13) + mCardioa + mCardiob + mCardioc + mCardiod + mCardioe
		Endif

		mCardio11 = Iif (Empty(mwkNeoICardio.car_estcomple),"","Estudios Complementarios: " + Chr(13) + Alltrim(Proper(mwkNeoICardio.car_estcomple)) + Chr(13))
		mCardio10 = Iif (Empty(mwkNeoICardio.car_media),"","TA Media: " + Alltrim(mwkNeoICardio.car_media) + Chr(13))
		mCardio9 = Iif (Empty(mwkNeoICardio.car_diastolica),"","TA Diastólica: " + Alltrim(mwkNeoICardio.car_diastolica) + Chr(13))
		mCardio8 = Iif (Empty(mwkNeoICardio.car_sistolica),"","TA Sistólica: " + Alltrim(mwkNeoICardio.car_sistolica) + Chr(13))
		mCardio7 = Iif (Empty(mwkNeoICardio.car_freccard),"","Frecuencia Cardíaca: " + Alltrim(mwkNeoICardio.car_freccard) + Chr(13))
		mCardio6 = Iif (mwkNeoICardio.car_arritmia = 1,"Arritmia: Si" + Chr(13),Iif (mwkNeoICardio.car_arritmia = 2,"Arritmia: No" + Chr(13),""))
		mCardio5 = Iif (Empty(mwkNeoICardio.car_descriarritmia),"","Arritmia: " + Alltrim(mwkNeoICardio.car_descriarritmia) + Chr(13))

		mCardio4 = Iif (Empty(mwkNeoICardio.car_capilar),"","Relleno Capilar: " + Proper(Alltrim(mwkNeoICardio.car_capilar)) + Chr(13))
		mCardio3 = Iif (Empty(mwkNeoICardio.car_pulperif),"","Pulsos Periféricos: " + Proper(Alltrim(mwkNeoICardio.car_pulperif)) + Chr(13))
		mCardio2 = Iif (Empty(mwkNeoICardio.car_ruidos),"","Ruidos: " + Proper(Alltrim(mwkNeoICardio.car_ruidos)) + Chr(13))
		mCardio1 = Iif (Empty(mwkNeoICardio.car_soplo),"","Soplos: " + Proper(Alltrim(mwkNeoICardio.car_soplo)) + Chr(13))

		If Len(mCardio1 + mCardio2 + mCardio3 + mCardio4 + mCardio5 + mCardio6 + mCardio7 + mCardio8 + mCardio9 + mCardio10 + mCardio11 + mCardio12 + mCardio)>0
*			mIngreso =  mIngreso + Chr(13) + "- ASPECTO CARDIOVASCULAR:" + Chr(13) + Chr(13)
			mIngreso = mIngreso + mCardio1 + mCardio2 + mCardio3 + mCardio4 + mCardio5 + mCardio6 + mCardio7 + mCardio8 + mCardio9 + mCardio10 + mCardio11 + mCardio12 + mCardio
		Endif

	Endif
Endif

If !Used("mwkNeoIMedicaCardio")
* Cargo la medicación = Drogas Vasoactivas
	lSQL = "select * from ZabNeoVarios where var_idevol = ?midevol And var_medcardio = 1 And var_tiporegistro = 'I'"
	If !Prg_EjecutoSql(lcSql,"mwkNeoIMedicaCardio")
		Return .F.
	Endif
Endif

If Used("mwkNeoIMedicaCardio")
	If Reccount("mwkNeoIMedicaCardio")>0
		Select mwkNeoIMedicaCardio
		mIngreso = mIngreso + Chr(13) + "Medicación Cardiovascular:" + Chr(13)
		Scan All
			mMediCardio1 = "Medicamento: " + Alltrim(Proper(mwkNeoIMedicaCardio.var_medicamento))
			mMediCardio2 = "Dosis: " + Alltrim(Proper(mwkNeoIMedicaCardio.var_dosis ))
			mIngreso = mIngreso + mMediCardio1 + mMediCardio2 + Chr(13)
		Endscan
	Endif
Endif


* ----------------------------

* Abdominal

mIngreso = mIngreso + Chr(13) + "- ASPECTO ABDOMINAL:" + Chr(13) 

If Used("mwkNeoIAbdomen")
	If Reccount("mwkNeoIAbdomen")>0
		Select mwkNeoIAbdomen
		mAbdo = ""
		mAbdo1 = Iif(mwkNeoIAbdomen.abd_sondagng=1,"SOG/SNG: Si" + Chr(13), Iif(mwkNeoIAbdomen.abd_sondagng=2,"SOG/SNG: No" + Chr(13),""))
		mAbdo2 = Iif(mwkNeoIAbdomen.abd_ruidogas=1,"Residuo Gástrico: Si" + Chr(13), Iif(mwkNeoIAbdomen.abd_ruidogas=2,"Residuo Gástrico: No" + Chr(13), ""))
		mAbdo3 = Iif(Empty(mwkNeoIAbdomen.abd_tiporg),"","Tipo RG: " + Proper(Alltrim(mwkNeoIAbdomen.abd_tiporg))+Chr(13))
		mAbdo4 = Iif(Empty(mwkNeoIAbdomen.abd_cantrg),"","Cantidad RG: " + Proper(Alltrim(mwkNeoIAbdomen.abd_cantrg))+Chr(13))
		mAbdo5 = Iif(Empty(mwkNeoIAbdomen.abd_examenabdo),"","Exámen Clínico Abdominal: " + Proper(Alltrim(mwkNeoIAbdomen.abd_examenabdo))+Chr(13))
		mAbdo6 = Iif(Empty(mwkNeoIAbdomen.abd_estudiosabdo),"","Estudios Abdominales: " + Proper(Alltrim(mwkNeoIAbdomen.abd_estudiosabdo))+Chr(13))
		mAbdo7 = Iif(Empty(mwkNeoIAbdomen.abd_medicaabdo),"","Medicaciones: " + Proper(Alltrim(mwkNeoIAbdomen.abd_medicaabdo))+Chr(13))
		mAbdo8 = Iif(Empty(mwkNeoIAbdomen.abd_datosabdo),"","Datos Relevantes: " + Proper(Alltrim(mwkNeoIAbdomen.abd_datosabdo))+Chr(13))
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
		mNeuro6 = Iif(Empty(mwkNeoINeuro.neu_estucompneuro),"",Proper(Alltrim(mwkNeoINeuro.neu_estucompneuro))+Chr(13))
		mNeuro7 = Iif(Empty(mwkNeoINeuro.neu_datosneuro),"",Proper(Alltrim(mwkNeoINeuro.neu_datosneuro))+Chr(13))

		If Len(mNeuro + mTono + mNeuro1 + mNeuro2 + mNeuro3 + mNeuro4 + mNeuro5 + mNeuro6 + mNeuro7)>0
			mIngreso = mIngreso + mNeuro + Chr(13) + mTono + Chr(13) + mNeuro1 + mNeuro2 + mNeuro3 + mNeuro4 + mNeuro5 + mNeuro6 + mNeuro7
		Endif


* Cargo la medicación de Neuro

		If !Used("mwkNeoIMedicaNeuro")

			lcSQL = "select * from ZabNeoVarios where var_idevol = ?midevol And var_medneuro = 1 And var_tiporegistro = 'I'"
			If !Prg_EjecutoSql(lcSql,"mwkNeoIMedicaNeuro")
				Return .F.
			Endif
		Endif

		If Used("mwkNeoIMedicaNeuro")
			If Reccount("mwkNeoIMedicaNeuro")>0
				Select mwkNeoIMedicaNeuro
				mIngreso = mIngreso + Chr(13) + "Medicación Neurológica:" + Chr(13)
				Scan All
					mMediNeuro1 = "Medicamento: " + Alltrim(Proper(mwkNeoIMedicaNeuro.var_medicamento))
					mMediNeuro2 = "Dosis: " + Alltrim(Proper(mwkNeoIMedicaNeuro.var_dosis ))
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

mIngreso = mIngreso + Chr(13) + "- ASPECTO INFECTOLOGICO:" + Chr(13)

* General:

If Used("mwkNeoIInfecto")
	If Reccount("mwkNeoIInfecto")>0
		Select mwkNeoIInfecto
		mInfecto1 = Iif(Empty(mwkNeoIInfecto.inf_estcomple),"","Estudios Complementarios: " + Alltrim(Proper(mwkNeoIInfecto.inf_estcomple))+Chr(13))
		mInfecto2 = Iif(Empty(mwkNeoIInfecto.inf_inginfecto),"","Resúmen de Ingreso: " + Alltrim(Proper(mwkNeoIInfecto.inf_inginfecto))+Chr(13))
		If Len(mInfecto1 + mInfecto2)>0
			mIngreso = mIngreso + mInfecto2 + Chr(13) + mInfecto1
		Endif
	Endif
Endif



* Cultivos:

If !Used("mwkNeoICultivo")

	lSQL = "select * from ZabNeoVarios where var_idevol = ?midevol And var_cultivos = 1 And var_tiporegistro = 'I'"
	If !Prg_EjecutoSql(lcSql,"mwkNeoICultivo")
		Return .F.
	Endif
Endif

If Used("mwkNeoICultivo")
	If Reccount("mwkNeoICultivo")>0
		Select mwkNeoICultivo
		mIngreso = mIngreso + Chr(13) + "Cultivos:" + Chr(13)
		Scan All
			mCultivo1 = Iif(Empty(mwkNeoICultivo.var_material),"","Material: " + Alltrim(Proper(mwkNeoICultivo.var_material)))
			mCultivo2 = Iif(Empty(mwkNeoICultivo.var_fechaestudios),"Fecha: " + (Dtoc(mwkNeoICultivo.var_fechaestudios)),"")
			mCultivo3 = Iif(mwkNeoICultivo.var_optresulta=1,'Resultado: Positivo',Iif(mwkNeoICultivo.var_optresulta=2,'Resultado: Negativo',''))
			mCultivo4 = Iif(Empty(mwkNeoICultivo.var_germen),"","Germen: " + Alltrim(Proper(mwkNeoICultivo.var_germen)))
			mCultivo5 = Iif(Empty(mwkNeoICultivo.var_tratamiento),"","Tratamiento: " + Alltrim(Proper(mwkNeoICultivo.var_tratamiento)))
			mIngreso = mIngreso + mCultivo1 + " - " + mCultivo2 + " - " + mCultivo3 + " - " + mCultivo4 + " - " + mCultivo5 + Chr(13)
		Endscan
	Endif
Endif

* Accesos:

* Hay que hacer un cambio en tabestado (definir estado y subestado asi queda todo igual. Hacer los cambios en las consultas dentro del form)


If !Used("mwkNeoIAccesos")
	lcSql = "select * from ZabNeoVarios where var_idevol = ?midevol And var_accesos = 1 And var_tiporegistro = 'I'"
	If !Prg_EjecutoSql(lcSql,"mwkNeoIAccesos")
		Return .F.
	Endif
Endif

If Used("mwkNeoIAccesos")
	If Reccount("mwkNeoIAccesos")>0
		Select mwkNeoIAccesos
		mIngreso = mIngreso + Chr(13) + "Accesos:" + Chr(13)
		Scan All
			mAccesos1 = Iif(Empty(mwkNeoIAccesos.Descrip),"","Tipo de Acceso: " + Alltrim(Proper(mwkNeoICultivo.var_material)))
			mAccesos2 = Iif(Empty(mwkNeoIAccesos.var_localizacion),"","Fecha: " + (Dtoc(mwkNeoICultivo.var_fechaestudios)))
			mAccesos3 = Iif(mwkNeoIAcceso.var_permanencia>0,"Permanencia: " + Alltrim(Transform(mwkNeoIAcceso.var_permanencia)),"")

			mIngreso = mIngreso + mAccesos1 + " - " + mAccesos2 + " - " + mAccesos3 + Chr(13)
		Endscan
	Endif
Endif





*!*	With This.pgConsulta.pgAnam.cnTNEO_INGRESO1.cntIng.pgIngreso.page8

*!*		Select mwkNeoIInfecto
*!*		Go Top In mwkNeoIInfecto
*!*		Select * From mwkNeoIInfecto Into Cursor mwkNeoIInfecto0

*!*	* Cargo Cultivos:

*!*	*!*		If Used("mwkNeoIVarios")
*!*	*!*			Select * From mwkNeoIVarios Where var_cultivos = 1 And var_tiporegistro = "I" Into Cursor mwkNeoICultivo Readwrite
*!*	*!*		Else
*!*	*!*			Messagebox("No hay cultivos cargados",0,"ERROR - CULTIVOS")
*!*	*!*			Return .F.
*!*	*!*		Endif


*!*		With .CntBack.pgfInfecto

*!*			With .page1
*!*				With .grid1
*!*					.RecordSource = "mwkNeoICultivo"
*!*					.coLUMN1.ControlSource = "mwkNeoICultivo.var_material"
*!*					.coLUMN2.ControlSource = "nvl(mwkNeoICultivo.var_fechaestudios,Ctod(' / / '))"
*!*					.COLUMN3.ControlSource = "iif(mwkNeoICultivo.var_optresulta=1,'Positivo',IIF(mwkNeoICultivo.var_optresulta=2,'Negativo','Sin Valor'))"
*!*					.COLUMN4.ControlSource = "mwkNeoICultivo.var_germen"
*!*					.Column5.ControlSource = "mwkNeoICultivo.var_tratamiento"
*!*					.COLUMN3.DynamicForeColor = "iif(mwkNeoICultivo.var_optresulta = 1,RGB(255,0,0),iif(mwkNeoICultivo.var_optresulta = 2,RGB(0,140,0),RGB(0,0,0)))"
*!*				Endwith
*!*			Endwith

*!*	* Cargo Accesos:

*!*			With .page2
*!*				If !Used("mwkNeoIAcceso")
*!*					Messagebox("No hay accesos cargados",0,"ERROR - ACCESOS")
*!*					With .grid1
*!*						.RecordSource = ""
*!*						.coLUMN1.ControlSource = ""
*!*						.coLUMN2.ControlSource = ""
*!*						.COLUMN3.ControlSource = ""
*!*					Endwith
*!*				Else
*!*					With .grid1
*!*						.RecordSource = "mwkNeoIAcceso"
*!*						.coLUMN1.ControlSource = "mwkNeoIAcceso.descrip"
*!*						.coLUMN2.ControlSource = "mwkNeoIAcceso.var_localizacion"
*!*						.COLUMN3.ControlSource = "mwkNeoIAcceso.var_permanencia"
*!*					Endwith
*!*				Endif
*!*			Endwith

*!*			With .page3
*!*				.edEstComple.ControlSource  = "mwkNeoIInfecto.inf_estcomple"
*!*			Endwith
*!*		Endwith

*!*		.txtIngreso.ControlSource		= "mwkNeoIInfecto.inf_inginfecto"
*!*	Endwith
*!*	* ------------------------------

* Hemato

mIngreso = mIngreso  + Chr(13) + "- ASPECTO HEMATOLOGICO:" + Chr(13)

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
		mAntro2 = Iif(mwkNeoIAntro.ant_talla>0,"Talla al Ingreso: " + Alltrim(Transform(mwkNeoIAntro.ant_talla,'99,99')) + " cms." ,"")
		mAntro3 = Iif(mwkNeoIAntro.ant_pc>0,"Perímetro Cefálico al ingreso: " + Alltrim(Transform(mwkNeoIAntro.ant_pc,'99,99')) + " cms." ,"")
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

	lcSql = "select * from ZabNeoVarios where var_idevol = ?midevol and var_pesquisa = 1 and var_tiporegistro = 'I' order by var_fechahora desc"

	If !Prg_EjecutoSql(lcSql,"mwkNeoIngPesq")
		Return .F.
	Endif
Endif

If Used("mwkNeoIngPesq")
	If Reccount("mwkNeoIngPesq")>0
		Select mwkNeoIngPesq
		mIngreso = mIngreso + Chr(13) + "- PESQUISA NEONATAL:" + Chr(13)
		Scan All
			mPesq1 = Iif(mwkNeoIngPesq.var_nropesq>0,"Nro de Pesquisa: " + Transform(mwkNeoIngPesq.var_nropesq),"")
			mPesq2 = Iif(Empty(mwkNeoIngPesq.var_fechaestudios),""," Fecha de Estudio: " + Dtoc(mwkNeoIngPesq.var_fechaestudios))
			mPesq3 = Iif(Empty(mwkNeoIngPesq.var_resultado),""," Resultado: " + Alltrim(Proper(mwkNeoIngPesq.var_resultado)))
			mPesq4 = Iif(Empty(mwkNeoIngPesq.var_nota),""," Nota: " + Alltrim(Proper(mwkNeoIngPesq.var_nota)))
			mIngreso = mIngreso + mPesq1 + mPesq2 + mPesq3 + mPesq4
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
	lcSql = "select * from ZabNeoIEMalforma join tabestados on ZabNeoIEMalforma.MAL_nromalforma = tabestados.id "+;
		" where ZabNeoIEMalforma.MAL_idevol = ?midevol and mal_tiporegistro = 'I' order by mal_fechahora desc"
	If !Prg_EjecutoSql(lcSql,"mwkNeoMalforma")
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
		mIngreso = mIngreso + Iif(Empty(mwkNeoIQuiro.qui_quiro),"","- ASPECTO QUIRURGICO: " + Chr(13) + Alltrim(Proper(mwkNeoIQuiro.qui_quiro)))
	Endif
Endif
* ------------------------------

Return mIngreso