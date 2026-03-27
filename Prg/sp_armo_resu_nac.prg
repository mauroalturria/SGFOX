Parameters mNroReg, midevol, mBusco, mMama

* Registración -> Busco la fecha de Nacimiento

lcSQL = "select * from registracio where reg_nroregistrac = ?mNroReg"

If !Prg_EjecutoSql(lcSQL,"mwkFecNac")
	Return .F.
Endif

If Used("mwkFecNac")
	If Reccount("mwkFecNac")>0
		mFecNaci = mwkFecNac.reg_fecnacimiento
	Else
		mFecNaci = ""
	Endif
Endif

Use In mwkFecNac

Do sp_armo_cursores_neo With midevol

If Vartype(mMama)#"C"
	mMama = ""
Endif

Do Case
Case mBusco = 0
	mLinea = "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" + Chr(13) + Chr(13)
Case mBusco = 1
	mLinea = "--------------------------------------------------------------------------------------------" + Chr(13) + Chr(13)
Case mBusco = 2
	mLinea = "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" + Chr(13) + Chr(13)
Otherwise
	mLinea = "" + Chr(13) + Chr(13)
Endcase

mAnamnesis = ""
mAnamnesis1 = ""
mAnamnesis2 = ""
mAnamnesis3 = ""
mAnamnesis4 = ""
mAnamnesis5 = ""
mAnamnesis6 = ""

* Armo la Anamneis para la Epicrisis

* 1) Antecedentes Maternos:

If !Used("mwkNeoAntecMaterno")
	mAnamnesis1 = ""
Else
	Select mwkNeoAntecMaterno
	If Reccount("mwkNeoAntecMaterno")>0

		mfec1900 = Ctot("01/01/1900")
		mfecblank = Ctot("")

		mfec1900d = Ctod("01/01/1900")
		mfecblankd = Ctod("")

*!*	Endif

		If mwkNeoAntecMaterno.nam_fechavdrl = mfec1900
			Replace mwkNeoAntecMaterno.nam_fechavdrl With mfecblank  In mwkNeoAntecMaterno
		Endif
		If mwkNeoAntecMaterno.nam_fechahiv = mfec1900
			Replace mwkNeoAntecMaterno.nam_fechahiv With mfecblank  In mwkNeoAntecMaterno
		Endif
		If mwkNeoAntecMaterno.nam_fechaigg = mfec1900
			Replace mwkNeoAntecMaterno.nam_fechaigg With mfecblank  In mwkNeoAntecMaterno
		Endif
		If mwkNeoAntecMaterno.nam_fechaigm = mfec1900
			Replace mwkNeoAntecMaterno.nam_fechaigm With mfecblank  In mwkNeoAntecMaterno
		Endif
		If mwkNeoAntecMaterno.nam_fechahepb = mfec1900
			Replace mwkNeoAntecMaterno.nam_fechahepb With mfecblank  In mwkNeoAntecMaterno
		Endif
		If mwkNeoAntecMaterno.nam_fechachagas = mfec1900d Or Isnull(mwkNeoAntecMaterno.nam_fechachagas)
			Replace mwkNeoAntecMaterno.nam_fechachagas With mfecblankd  In mwkNeoAntecMaterno
		Endif
		If mwkNeoAntecMaterno.nam_fechatoxo = mfec1900d Or Isnull(mwkNeoAntecMaterno.nam_fechatoxo)
			Replace mwkNeoAntecMaterno.nam_fechatoxo With mfecblankd  In mwkNeoAntecMaterno
		Endif

		Select mwkNeoAntecMaterno
		Go Top


* General

		mTitulo1 = ""
		mTitulo1 = mLinea
		mTitulo1 = mTitulo1 + "Antecedentes Maternos durante el parto" + Chr(13) + Chr(13)
		mTitulo1 = mTitulo1 + mLinea

		mAnamnesis1 = ""
		mAnamnesis1 = mAnamnesis1 + Iif(Empty(mMama),""," Nombre de la madre: " + mMama + Chr(13))
		mAnamnesis1 = mAnamnesis1 + Iif(mwkNeoAntecMaterno.nam_edadmat>0,"	Edad de la madre: " + Alltrim(Str(mwkNeoAntecMaterno.nam_edadmat)) + " años" + Chr(13), "")
		If Nvl(mwkNeoAntecMaterno.nam_gesta,0) + Nvl(mwkNeoAntecMaterno.nam_para,0) + Nvl(mwkNeoAntecMaterno.nam_cesarea,0) + Nvl(mwkNeoAntecMaterno.nam_abortos,0)>0
			mAnamnesis1 = mAnamnesis1 + Iif(Isnull(mwkNeoAntecMaterno.nam_gesta),"","	Gesta: " + Alltrim(Str(mwkNeoAntecMaterno.nam_gesta)))
			mAnamnesis1 = mAnamnesis1 +	Iif(Isnull(mwkNeoAntecMaterno.nam_para),"","  Para: " + Alltrim(Transform(mwkNeoAntecMaterno.nam_para)))
			mAnamnesis1 = mAnamnesis1 +	Iif(Isnull(mwkNeoAntecMaterno.nam_cesarea),"", "  Cesárea: " + Alltrim(Str(mwkNeoAntecMaterno.nam_cesarea)))
			mAnamnesis1 = mAnamnesis1 +	Iif(Isnull(mwkNeoAntecMaterno.nam_abortos),"", "  Abortos: " + Alltrim(Str(mwkNeoAntecMaterno.nam_abortos))) + Chr(13)
		Endif
		mAnamnesis1 = mAnamnesis1 + Iif(Empty(Alltrim(mwkNeoAntecMaterno.nam_grupoyfactor)),"","	Grupo y Factor Materno: " + Alltrim(mwkNeoAntecMaterno.nam_grupoyfactor) + Chr(13))
		mAnamnesis1 = mAnamnesis1 + Iif(mwkNeoAntecMaterno.nam_embarazoctrl=1,"	Embarazo Controlado: Si" + Chr(13),Iif(mwkNeoAntecMaterno.nam_embarazoctrl=2,"	Embarazo Controlado: No" + Chr(13),""))
		mAnamnesis1 = mAnamnesis1 + Iif(mwkNeoAntecMaterno.nam_profilaxis=1,"	Recibió Profilaxis: Si" + Chr(13),Iif(mwkNeoAntecMaterno.nam_profilaxis=2,"	Recibió Profilaxis: No" + Chr(13),""))
		mAnamnesis1 = mAnamnesis1 + Iif(mwkNeoAntecMaterno.nam_egb=1,"	EGB: Si" + Chr(13),Iif(mwkNeoAntecMaterno.nam_egb=2,"	EGB: No"+Chr(13),""))
		mAnamnesis1 = mAnamnesis1 + Iif(mwkNeoAntecMaterno.nam_pci=1,"	PCI: Positiva"+Chr(13),Iif(mwkNeoAntecMaterno.nam_pci=2,"PCI: Negativa"+Chr(13),""))
		mAnamnesis1 = mAnamnesis1 + Iif(mwkNeoAntecMaterno.nam_gammagarh=1,"	Recibió gamaglobulina antiRH: Si" + Chr(13),Iif(mwkNeoAntecMaterno.nam_gammagarh=2,"	Recibió gamaglobulina antiRH: No" + Chr(13),""))

		If Len(mAnamnesis1)>0
			mAnamnesis1 = mAnamnesis1 + Chr(13) + "	Serologías:" + Chr(13)
		Endif

		mAnamnesis1 = mAnamnesis1 + Iif(mwkNeoAntecMaterno.NAM_opvdrl=1,"		VDRL: Positivo - Fecha: " + Dtoc(mwkNeoAntecMaterno.nam_fechavdrl)+Chr(13),Iif(mwkNeoAntecMaterno.NAM_opvdrl=2,"		VDRL: Negativo - Fecha: " + Dtoc(mwkNeoAntecMaterno.nam_fechavdrl)+Chr(13),""))
		mAnamnesis1 = mAnamnesis1 + Iif(mwkNeoAntecMaterno.nam_vdrl>0,"			Valor de VDRL: " + Alltrim(Str(mwkNeoAntecMaterno.nam_vdrl))+Chr(13),"")
		mAnamnesis1 = mAnamnesis1 + Iif(Nvl(mwkNeoAntecMaterno.nam_toxoplasmosis,0)=1,"		Toxoplasmosis: Positivo - Fecha: " + Dtoc(Nvl(mwkNeoAntecMaterno.nam_fechatoxo,Ctod(' / / ')))+Chr(13) ,Iif(Nvl(mwkNeoAntecMaterno.nam_toxoplasmosis,0)=2,"		Toxoplasmosis: Negativo - Fecha: " + Dtoc(Nvl(mwkNeoAntecMaterno.nam_fechatoxo,Ctod(' / / ')))+Chr(13)  ,"" ))
		If mwkNeoAntecMaterno.nam_toxoplasmosis=1
			mAnamnesis1 = mAnamnesis1 + "				IgG: " + Alltrim(Str(mwkNeoAntecMaterno.nam_igg)) + " - Fecha: " + Dtoc(mwkNeoAntecMaterno.nam_fechaigg) + Chr(13)
			mAnamnesis1 = mAnamnesis1 + "				IgM: " + Alltrim(Str(mwkNeoAntecMaterno.nam_igm)) + " - Fecha: " + Dtoc(mwkNeoAntecMaterno.nam_fechaigm) + Chr(13)
		Endif
		mAnamnesis1 = mAnamnesis1 + Iif(mwkNeoAntecMaterno.nam_hiv=1,"		HIV: Positivo - Fecha: " + Dtoc(mwkNeoAntecMaterno.nam_fechahiv) + Chr(13),Iif(mwkNeoAntecMaterno.nam_hiv=2,"		HIV: Negativo - Fecha: " + Dtoc(mwkNeoAntecMaterno.nam_fechahiv)+Chr(13),""))
		mAnamnesis1 = mAnamnesis1 + Iif(mwkNeoAntecMaterno.nam_hepb=1,"		Hepatitis B: Positivo - Fecha: " + Dtoc(mwkNeoAntecMaterno.nam_fechahepb)+Chr(13),Iif(mwkNeoAntecMaterno.nam_hepb=2,"		Hepatitis B: Negativo - Fecha: " + Dtoc(mwkNeoAntecMaterno.nam_fechahepb)+Chr(13),""))
		mAnamnesis1 = mAnamnesis1 + Iif(mwkNeoAntecMaterno.nam_chagas=1,"		Chagas: Positivo - Fecha: " + Dtoc(Nvl(mwkNeoAntecMaterno.nam_fechachagas,Ctod(' / / ')))+Chr(13),Iif(mwkNeoAntecMaterno.nam_chagas=2,"		Chagas: Negativo - Fecha: " + Dtoc(Nvl(mwkNeoAntecMaterno.nam_fechachagas,Ctod(' / / ')))+Chr(13),""))

		If !Empty(mAnamnesis1)
			mAnamnesis1 = mTitulo1 + mAnamnesis1
		Endif

	Endif
Endif


* Enfermedades

If !Used("mwkNeoAntecMatPlus")
	mAnamnesis2 = ""
Else
	Select mwkNeoAntecMatPlus
	If Reccount("mwkNeoAntecMatPlus")>0


		mTitulo2 = mLinea
		mTitulo2 = mTitulo2 + "Enfermedades de la Madre: " + Chr(13) + Chr(13)
		mTitulo2 = mTitulo2 + mLinea

		mAnamnesis2 = ""
		mAnamnesis2 = mAnamnesis2 + Iif(mwkNeoAntecMatEnf.amp_diabetes=1,"	Diabetes: Si" + Chr(13),Iif(mwkNeoAntecMatEnf.amp_diabetes=2,"	Diabetes: No" + Chr(13),""))
		If mwkNeoAntecMatEnf.amp_diabetes = 1
			mAnamnesis2 = mAnamnesis2 + Iif(mwkNeoAntecMatEnf.amp_dbtipo=1,"		Tipo: I ",Iif(mwkNeoAntecMatEnf.amp_dbtipo=2,"		Tipo: II ",""))
			mAnamnesis2 = mAnamnesis2 + Iif(mwkNeoAntecMatEnf.amp_gestaprev=1,"- Gestacional" + Chr(13),Iif(mwkNeoAntecMatEnf.amp_gestaprev=2,"- Previa" + Chr(13),""))
		Endif
		mAnamnesis2 = mAnamnesis2 + Iif(mwkNeoAntecMatEnf.amp_hta=1,"	HTA: Si" + Chr(13),Iif(mwkNeoAntecMatEnf.amp_hta=2,"	HTA: No"+Chr(13),""))
		mAnamnesis2 = mAnamnesis2 + Iif(mwkNeoAntecMatEnf.amp_preeclampsia=1,"	Preeclampsia: Si"+Chr(13),Iif(mwkNeoAntecMatEnf.amp_preeclampsia=2,"	Preeclampsia: No"+Chr(13),""))
		mAnamnesis2 = mAnamnesis2 + Iif(mwkNeoAntecMatEnf.amp_eclampsia=1,"	Eclampsia: Si"+Chr(13),Iif(mwkNeoAntecMatEnf.amp_eclampsia=2,"	Eclampsia: No"+Chr(13),""))
		mAnamnesis2 = mAnamnesis2 + Iif(mwkNeoAntecMatEnf.amp_smehellp=1,"	SME Hellp: Si"+Chr(13),Iif(mwkNeoAntecMatEnf.amp_smehellp=2,"	SME Hellp: No"+Chr(13),""))
		mAnamnesis2 = mAnamnesis2 + Iif(mwkNeoAntecMatEnf.amp_fosfo=1,"	SME Fosfolipídico: Si"+Chr(13),Iif(mwkNeoAntecMatEnf.amp_fosfo=2,"	SME Fosfolipídico: No"+Chr(13),""))
		mAnamnesis2 = mAnamnesis2 + Iif(mwkNeoAntecMatEnf.amp_colageno=1,"	Colagenopatías: Si"+Chr(13),Iif(mwkNeoAntecMatEnf.amp_colageno=2,"	Colagenopatías: No"+Chr(13),""))
		mAnamnesis2 = mAnamnesis2 + Iif(mwkNeoAntecMatEnf.amp_hipotiro=1,"	Hipotiroidismo: Si"+Chr(13),Iif(mwkNeoAntecMatEnf.amp_hipotiro=2,"	Hipotiroidismo: No"+Chr(13),""))
		mAnamnesis2 = mAnamnesis2 + Iif(mwkNeoAntecMatEnf.amp_hipertiro=1,"	Hipertiroidismo: Si"+Chr(13),Iif(mwkNeoAntecMatEnf.amp_hipertiro=2,"	Hipertiroidismo: No"+Chr(13),""))
		mAnamnesis2 = mAnamnesis2 + Iif(mwkNeoAntecMatEnf.amp_cardio=1,"	Cardiopatías: Si"+Chr(13),Iif(mwkNeoAntecMatEnf.amp_cardio=2,"	Cardiopatías: No"+Chr(13),""))
		mAnamnesis2 = mAnamnesis2 + Iif(mwkNeoAntecMatEnf.amp_convulsion=1,"	Convulsiones: Si"+Chr(13),Iif(mwkNeoAntecMatEnf.amp_convulsion=2,"	Convulsiones: No"+Chr(13),""))
		mAnamnesis2 = mAnamnesis2 + Iif(mwkNeoAntecMatEnf.amp_enfpsiq=1,"	Enf. Psiquiátricas: Si"+Chr(13),Iif(mwkNeoAntecMatEnf.amp_enfpsiq=2,"	Enf. Psiquiátricas: No"+Chr(13),""))
		mAnamnesis2 = mAnamnesis2 + Iif(mwkNeoAntecMatEnf.amp_trombo=1,"	Trombofilias: Si"+Chr(13),Iif(mwkNeoAntecMatEnf.amp_trombo=2,"	Trombofilias: No"+Chr(13),""))
		mAnamnesis2 = mAnamnesis2 + Iif(mwkNeoAntecMatEnf.amp_colestasis=1,"	Colestasis: Si"+Chr(13),Iif(mwkNeoAntecMatEnf.amp_colestasis=2,"	Colestasis: No"+Chr(13),""))
		mAnamnesis2 = mAnamnesis2 + Iif(mwkNeoAntecMatEnf.amp_infectouri=1,"	Infección Urinaria: Si ",Iif(mwkNeoAntecMatEnf.amp_infectouri=2,"	Infección Urinaria: No "+Chr(13),""))
		If mwkNeoAntecMatEnf.amp_infectouri=1
			mAnamnesis2 = mAnamnesis2 + Iif(mwkNeoAntecMatEnf.amp_tto=1," - Recibió Tratamiento: Si"+Chr(13),Iif(mwkNeoAntecMatEnf.amp_tto=2,"	Recibió Tratamiento: No"+Chr(13),""))
			mAnamnesis2 = mAnamnesis2 + Iif(Empty(mwkNeoAntecMatEnf.amp_germen),"","		Gérmen: " + Alltrim(mwkNeoAntecMatEnf.amp_germen) + Chr(13))
		Endif

		If !Empty(mAnamnesis2)
			mAnamnesis2 = mTitulo2 + mAnamnesis2
		Endif

	Endif
Endif


* Medicaciones

If !Used("mwkNeoAntecMatMed")
	mAnamnesis3 = ""
Else
	Select mwkNeoAntecMatMed
	If Reccount("mwkNeoAntecMatMed")>0


*	mAnamnesis = mAnamnesis + mLinea
*	mAnamnesis = mAnamnesis + "Medicaciones de la Madre: " + Chr(13) + Chr(13)
*	mAnamnesis = mAnamnesis + mLinea

		mTitulo3 = mLinea
		mTitulo3 = mTitulo3 + "Medicaciones de la Madre: " + Chr(13) + Chr(13)
		mTitulo3 = mTitulo3 + mLinea

		mAnamnesis3 = ""
		mAnamnesis3 = mAnamnesis3 + Iif(mwkNeoAntecMatMed.amm_insulina=1,"	Insulina: Si"+Chr(13),Iif(mwkNeoAntecMatMed.amm_insulina=2,"	Insulina: No"+Chr(13),""))
		mAnamnesis3 = mAnamnesis3 + Iif(mwkNeoAntecMatMed.amm_stodemg=1,"	Sto de mg: Si"+Chr(13),Iif(mwkNeoAntecMatMed.amm_stodemg=2,"	Sto de mg: No"+Chr(13),""))
		mAnamnesis3 = mAnamnesis3 + Iif(mwkNeoAntecMatMed.amm_labetalol=1,"	Labetalol: Si"+Chr(13),Iif(mwkNeoAntecMatMed.amm_labetalol=2,"	Labetalol: No"+Chr(13),""))
		mAnamnesis3 = mAnamnesis3 + Iif(mwkNeoAntecMatMed.amm_corticoide=1,"	Corticoides: Si"+Chr(13),Iif(mwkNeoAntecMatMed.amm_corticoide=2,"	Corticoides: No"+Chr(13),""))
		mAnamnesis3 = mAnamnesis3 + Iif(mwkNeoAntecMatMed.amm_madpulmonar=1,"	Maduración Pulmonar: Si"+Chr(13),Iif(mwkNeoAntecMatMed.amm_madpulmonar=2,"	Maduración Pulmonar: No"+Chr(13),""))
		mAnamnesis3 = mAnamnesis3 + Iif(mwkNeoAntecMatMed.amm_htiro=1,"	Hormonas Tiroideas: Si"+Chr(13),Iif(mwkNeoAntecMatMed.amm_htiro=2,"	Hormonas Tiroideas: No"+Chr(13),""))
		mAnamnesis3 = mAnamnesis3 + Iif(mwkNeoAntecMatMed.amm_antidepre=1,"	Antidepresivos y/o ansiolíticos: Si"+Chr(13),Iif(mwkNeoAntecMatMed.amm_antidepre=2,"	Antidepresivos y/o ansiolíticos: No"+Chr(13),""))
		If mwkNeoAntecMatMed.amm_antidepre=1
			mAnamnesis3 = mAnamnesis3 + Iif(Empty(mwkNeoAntecMatMed.amm_nomantidepre),"","		Nombre: " + Alltrim(mwkNeoAntecMatMed.amm_nomantidepre) + Chr(13))
		Endif
		mAnamnesis3 = mAnamnesis3 + Iif(mwkNeoAntecMatMed.amm_anticonvu=1,"	Anticonvulsionantes: Si"+Chr(13),Iif(mwkNeoAntecMatMed.amm_anticonvu=2,"	Anticonvulsionantes: No"+Chr(13),""))
		mAnamnesis3 = mAnamnesis3 + Iif(Empty(mwkNeoAntecMatMed.amm_otramedicacion),"","	Otras medicaciones: " + Alltrim(mwkNeoAntecMatMed.amm_otramedicacion) + Chr(13) + Chr(13))

		If !Empty(mAnamnesis3)
			mAnamnesis3 = mTitulo3 + mAnamnesis3
		Endif

	Endif
Endif

* Comorbilidades

If !Used("mwkNeoAntecMatCom")
	mAnamnesis4 = ""
Else
	Select mwkNeoAntecMatCom
	If Reccount("mwkNeoAntecMatCom")>0


*	mAnamnesis = mAnamnesis + mLinea
*	mAnamnesis = mAnamnesis + "Comorbilidades de la Madre: " + Chr(13) + Chr(13)
*	mAnamnesis = mAnamnesis + mLinea

		mTitulo4 = mLinea
		mTitulo4 = mTitulo4 + "Comorbilidades de la Madre: " + Chr(13) + Chr(13)
		mTitulo4 = mTitulo4 + mLinea

		mAnamnesis4 = ""
		mAnamnesis4 = mAnamnesis4 + Iif(mwkNeoAntecMatCom.amc_oligoamnios=1,"	Oligoamnios: Si"+Chr(13),Iif(mwkNeoAntecMatCom.amc_oligoamnios=2,"	Oligoamnios: No"+Chr(13),""))
		mAnamnesis4 = mAnamnesis4 + Iif(mwkNeoAntecMatCom.amc_fuma=1,"	Fuma: Si"+Chr(13),Iif(mwkNeoAntecMatCom.amc_fuma=2,"	Fuma: No"+Chr(13),""))
		mAnamnesis4 = mAnamnesis4 + Iif(mwkNeoAntecMatCom.amc_desnutri=1,"	Desnutrición: Si"+Chr(13),Iif(mwkNeoAntecMatCom.amc_desnutri=2,"	Desnutrición: No"+Chr(13),""))
		mAnamnesis4 = mAnamnesis4 + Iif(mwkNeoAntecMatCom.amc_transfusion=1,"	Transfusiones de hemoderivados: Si"+Chr(13),Iif(mwkNeoAntecMatCom.amc_transfusion=2,"	Transfusiones de hemoderivados: No"+Chr(13),""))
		mAnamnesis4 = mAnamnesis4 + Iif(mwkNeoAntecMatCom.amc_consumosustox=1,"	Consumos de Sustancias Tóxicas: Si"+Chr(13),Iif(mwkNeoAntecMatCom.amc_consumosustox=2,"	Consumos de Sustancias Tóxicas: No"+Chr(13),""))

		If mwkNeoAntecMatCom.amc_consumosustox=1
			mAnamnesis4 = mAnamnesis4 + "		("
			mAnamnesis4 = mAnamnesis4 + Iif(mwkNeoAntecMatCom.amc_cocaina=1,"Cocaína - ","")
			mAnamnesis4 = mAnamnesis4 + Iif(mwkNeoAntecMatCom.amc_marihuana=1,"Marihuana - ","")
			mAnamnesis4 = mAnamnesis4 + Iif(mwkNeoAntecMatCom.amc_paco=1,"Paco - ","")
			mAnamnesis4 = mAnamnesis4 + Iif(mwkNeoAntecMatCom.amc_alcohol=1,"Alcohol - ","")
			mAnamnesis4 = mAnamnesis4 + Iif(mwkNeoAntecMatCom.amc_anfetaminas=1,"Anfetaminas - ","")
			mAnamnesis4 = mAnamnesis4 + Iif(mwkNeoAntecMatCom.amc_opioides=1,"Opioides - ","")
			mAnamnesis4 = mAnamnesis4 + Iif(mwkNeoAntecMatCom.amc_chkotrassustox=1,"Otras Sust. Tóxicas: " +;
				Alltrim(mwkNeoAntecMatCom.amc_otrasustoxica),"")
			mAnamnesis4 = mAnamnesis4 + ")" + Chr(13)
		Endif

*mAnamnesis = mAnamnesis + Iif(mwkNeoAntecMatCom.amc_cocaina=1," Cocaína ",Iif(mwkNeoAntecMatCom.amc_marihuana=1," Marihuana ",;
Iif(mwkNeoAntecMatCom.amc_paco=1," Paco ",Iif(mwkNeoAntecMatCom.amc_alcohol=1," Alcohol ",Iif(mwkNeoAntecMatCom.amc_anfetaminas=1,;
" Anfetaminas ",Iif(mwkNeoAntecMatCom.amc_opioides=1," Opioides ",Iif(mwkNeoAntecMatCom.amc_chkotrassustox=1," Otras Sust. Tóxicas: " +;
Alltrim(mwkNeoAntecMatCom.amc_otrasustoxica),""))))))) + Chr(13)

* Otros Datos

		If !Empty(mwkNeoAntecMatCom.amc_otrosdatos)
			mAnamnesis4 = mAnamnesis4 + "	Otros Datos: " + Alltrim(mwkNeoAntecMatCom.amc_otrosdatos) + Chr(13) + Chr(13)
		Endif


		If !Empty(mAnamnesis4)
			mAnamnesis4 = mTitulo4 + mAnamnesis4
		Endif

	Endif
Endif


* DATOS DEL PARTO

If !Used("mwkNeoAntecDatosParto")
	mAnamnesis5 = ""
Else
	Select mwkNeoAntecDatosParto
	If Reccount("mwkNeoAntecDatosParto")>0


* Parto

*	mAnamnesis = mAnamnesis + mLinea
*	mAnamnesis = mAnamnesis + "Datos del Parto: " + Chr(13) + Chr(13)
*	mAnamnesis = mAnamnesis + mLinea

		mTitulo5 = mLinea
		mTitulo5 = mTitulo5 + "Datos del Parto: " + Chr(13) + Chr(13)
		mTitulo5 = mTitulo5 + mLinea

		mAnamnesis5 = ""
		mAnamnesis5 = mAnamnesis5 + Iif(mwkNeoAntecDatosParto.ndp_inicioparto=1,"	Inicio del Parto: Espontáneo"+Chr(13),Iif(mwkNeoAntecDatosParto.ndp_inicioparto=2,"	Inicio del Parto: Inducido"+Chr(13),""))
		mAnamnesis5 = mAnamnesis5 + Iif(mwkNeoAntecDatosParto.ndp_via=1,"	Tipo de Parto: Vaginal"+Chr(13),Iif(mwkNeoAntecDatosParto.ndp_via=2,"	Tipo de Parto: Cesárea"+Chr(13),""))
		mAnamnesis5 = mAnamnesis5 + Iif(mwkNeoAntecDatosParto.ndp_trabparto=1,"	Trabajo de Parto: Sí"+Chr(13),Iif(mwkNeoAntecDatosParto.ndp_trabparto=2,"	Trabajo de Parto: No"+Chr(13),""))
		mAnamnesis5 = mAnamnesis5 + Iif(mwkNeoAntecDatosParto.ndp_instru=1,"	Instrumental: Si (Forceps/Vacum)"+Chr(13),Iif(mwkNeoAntecDatosParto.ndp_instru=2,"	Instrumental: No"+Chr(13),""))
		mAnamnesis5 = mAnamnesis5 + Iif(Empty(mwkNeoAntecDatosParto.ndp_causacesarea),"","	Causa de la cesárea: " + mwkNeoAntecDatosParto.ndp_causacesarea+Chr(13))
		mAnamnesis5 = mAnamnesis5 + Iif(mwkNeoAntecDatosParto.ndp_presenta=1,"	Presentación: Cefálica"+Chr(13),Iif(mwkNeoAntecDatosParto.ndp_presenta=2,"	Presentación: Podálica"+Chr(13),""))
		If mwkNeoAntecDatosParto.ndp_liqAmnio>0
			mAnamnesis5 = mAnamnesis5 + "	Líquido Amniótico: " + Iif(mwkNeoAntecDatosParto.ndp_liqAmnio=1,"Claro",Iif(mwkNeoAntecDatosParto.ndp_liqAmnio=2,"Meconial",;
				Iif(mwkNeoAntecDatosParto.ndp_liqAmnio=3,"Sanguinolento",Iif(mwkNeoAntecDatosParto.ndp_liqAmnio=4,"Ausente",Iif(mwkNeoAntecDatosParto.ndp_liqAmnio=5,"Fétido","")))))+Chr(13)
		Endif
		mAnamnesis5 = mAnamnesis5 + Iif(mwkNeoAntecDatosParto.ndp_monintraparto=1,"	Monitoreo Intraparto: Si"+Chr(13),Iif(mwkNeoAntecDatosParto.ndp_monintraparto=2,"	Monitoreo Intraparto: No"+Chr(13),""))
		mAnamnesis5 = mAnamnesis5 + Iif(mwkNeoAntecDatosParto.ndp_sigSftofetalag=1,"	Signos de Sufrimiento fetal Agudo: Si"+Chr(13),Iif(mwkNeoAntecDatosParto.ndp_sigSftofetalag=2,"	Signos de Sufrimiento fetal Agudo: No"+Chr(13),""))
		mAnamnesis5 = mAnamnesis5 + Iif(Empty(mwkNeoAntecDatosParto.NDP_rupmembrana),'',"	Tiempo de Ruptura de membrana: " + Alltrim(mwkNeoAntecDatosParto.NDP_rupmembrana) + Chr(13))
		mAnamnesis5 = mAnamnesis5 + Iif(mwkNeoAntecDatosParto.NDP_edadgesta>0,"	Edad Gestacional: " + Alltrim(Str(mwkNeoAntecDatosParto.NDP_edadgesta)) + " semanas. " + Chr(13),"")
		mAnamnesis5 = mAnamnesis5 + Iif(mwkNeoAntecDatosParto.ndp_tiponac = 1,"	Nacimiento: Simple"+Chr(13),Iif(mwkNeoAntecDatosParto.ndp_tiponac = 2,"	Nacimiento: Múltiple"+Chr(13),""))
		If mwkNeoAntecDatosParto.ndp_tiponac = 2
			mAnamnesis5 = mAnamnesis5 + Iif(mwkNeoAntecDatosParto.NDP_ordennac>0,"		Orden de Nacimiento: " + Alltrim(Str(mwkNeoAntecDatosParto.NDP_ordennac))+ Chr(13),"")
			mAnamnesis5 = mAnamnesis5 + Iif(mwkNeoAntecDatosParto.NDP_corion=1,"		Corion: Monocorial"+Chr(13),Iif(mwkNeoAntecDatosParto.NDP_corion=2,"		Corion: Bicorial"+Chr(13),""))
			If mwkNeoAntecDatosParto.NDP_corion=1
				mAnamnesis5 = mAnamnesis5 + Iif(mwkNeoAntecDatosParto.NDP_monocorial=1,"		Monocorial: Monoamniótico"+Chr(13),Iif(mwkNeoAntecDatosParto.NDP_monocorial=2,"		Monocorial: Biamniótico"+Chr(13),""))
			Endif
		Endif
		mAnamnesis5 = mAnamnesis5 + Iif(mwkNeoAntecDatosParto.ndp_anomacordon=1,"	Anomalías del cordón: Sí"+Chr(13),Iif(mwkNeoAntecDatosParto.ndp_anomacordon=2,"	Anomalías del cordón: No"+Chr(13),""))
		mAnamnesis5 = mAnamnesis5 + Iif(mwkNeoAntecDatosParto.ndp_ligaduras=1,"	Ligaduras: Menos de 1 min."+Chr(13),Iif(mwkNeoAntecDatosParto.ndp_ligaduras=2,"	Ligaduras: Más de 1 min."+Chr(13),""))
		mAnamnesis5 = mAnamnesis5 + Iif(mwkNeoAntecDatosParto.NDP_corioamnionitis=1," 	Corioamnionitis: Si"+Chr(13),Iif(mwkNeoAntecDatosParto.NDP_corioamnionitis=2," 	Corioamnionitis: No"+Chr(13),""))
		mAnamnesis5 = mAnamnesis5 + Iif(mwkNeoAntecDatosParto.NDP_dppni=1," 	Signos de DPPNI: Si"+Chr(13),Iif(mwkNeoAntecDatosParto.NDP_dppni=2," 	Signos de DPPNI: No"+Chr(13),""))
		mAnamnesis5 = mAnamnesis5 + Iif(Empty(mwkNeoAntecDatosParto.NDP_observa),''," 	Otros Datos: " + Alltrim(mwkNeoAntecDatosParto.NDP_observa)) + Chr(13)

		If !Empty(mAnamnesis5)
			mAnamnesis5 = mTitulo5 + mAnamnesis5
		Endif

	Endif
Endif

* Nacimiento

If !Used("mwkNeoAntecNacimiento")
	mAnamnesis6 = ""
Else
	Select mwkNeoAntecNacimiento
	If Reccount("mwkNeoAntecNacimiento")>0

*	mAnamnesis = mAnamnesis + mLinea
*	mAnamnesis = mAnamnesis + "Nacimiento: " + Chr(13) + Chr(13)
*	mAnamnesis = mAnamnesis + mLinea

		mTitulo6 = mLinea
		mTitulo6 = mTitulo6 + "Nacimiento: " + Chr(13) + Chr(13)
		mTitulo6 = mTitulo6 + mLinea


		mAnamnesis6 = ""
		mAnamnesis6 = mAnamnesis6 + Iif(Empty(mwkNeoAntecDatosParto.NDP_lugardenac),"","	Lugar: " + Alltrim(mwkNeoAntecDatosParto.NDP_lugardenac))

		If Used("mwkNeoAntecNacimiento")
			If !Empty(Alltrim(mwkNeoAntecNacimiento.NAN_fecnacimiento)) And !Empty(Alltrim(mwkNeoAntecNacimiento.NAN_horanacimiento))
				mFecNaci = Ctot(Alltrim(mwkNeoAntecNacimiento.NAN_fecnacimiento) + " " + Alltrim(mwkNeoAntecNacimiento.NAN_horanacimiento))
			Endif
		Endif

		mAnamnesis6 = mAnamnesis6 +	Iif(Empty(Dtoc(mFecNaci)),""," - Fecha: " + Dtoc(mFecNaci))
*	If !Empty(Ctot(mwkNeoAntecNacimiento.NAN_horanacimiento))
		mAnamnesis6 = mAnamnesis6 +	Iif(Empty(mwkNeoAntecNacimiento.NAN_horanacimiento),""," - Hora: " + Alltrim(mwkNeoAntecNacimiento.NAN_horanacimiento))+Chr(13)
*	Else
		mAnamnesis6 = mAnamnesis6 + Chr(13)
*	Endif

*	mAnamnesis = mAnamnesis + "	Medidas al Nacer: "

		mAnamnesis6 = mAnamnesis6 + Iif(mwkNeoAntecNacimiento.nan_pesoRN>0,"	Peso: " + Transform(mwkNeoAntecNacimiento.nan_pesoRN) + " Grs. / ","")
		mAnamnesis6 = mAnamnesis6 + Iif(mwkNeoAntecNacimiento.nan_tallaRN>0,"Talla: " + Transform(mwkNeoAntecNacimiento.nan_tallaRN) + " Cms. / ","")
		mAnamnesis6 = mAnamnesis6 + Iif(mwkNeoAntecNacimiento.nan_pcRN>0,"PC: " + Transform(mwkNeoAntecNacimiento.nan_pcRN) + " Cms." + Chr(13),"")
		mAnamnesis6 = mAnamnesis6 + Iif(mwkNeoAntecNacimiento.nan_orino=1,"	Orinó: Si"+Chr(13),Iif(mwkNeoAntecNacimiento.nan_orino=2,"	Orinó: No"+Chr(13),""))
		mAnamnesis6 = mAnamnesis6 + Iif(mwkNeoAntecNacimiento.nan_meconio=1,"	Expulsó Meconio: Si"+Chr(13),Iif(mwkNeoAntecNacimiento.nan_meconio=2,"	Expulsó Meconio: No"+Chr(13),""))
		mAnamnesis6 = mAnamnesis6 + Iif(mwkNeoAntecNacimiento.nan_vitak=1,"	Vitamina K: Si"+Chr(13),Iif(mwkNeoAntecNacimiento.nan_vitak=2,"	Vitamina K: No"+Chr(13),""))
		mAnamnesis6 = mAnamnesis6 + Iif(mwkNeoAntecNacimiento.nan_vachepb=1,"	Vacuna Hepatitis B: Si"+Chr(13),Iif(mwkNeoAntecNacimiento.nan_vachepb=2,"	Vacuna Hepatitis B: No"+Chr(13),""))
		mAnamnesis6 = mAnamnesis6 + Iif(mwkNeoAntecNacimiento.nan_profiantio=1,"	Profilaxis Antibiótica Ocular: Si"+Chr(13),Iif(mwkNeoAntecNacimiento.nan_profiantio=2,"	Profilaxis Antibiótica Ocular: No"+Chr(13),""))
		mAnamnesis6 = mAnamnesis6 + Iif(mwkNeoAntecNacimiento.nan_barlow=1,"	Maniobra de Barlow y Ortolani: Positivo"+Chr(13),Iif(mwkNeoAntecNacimiento.nan_barlow=2,"	Maniobra de Barlow y Ortolani: Negativo"+Chr(13),""))
		mAnamnesis6 = mAnamnesis6 + Iif(mwkNeoAntecNacimiento.nan_orifnat=1,"	Orificios naturales permeables: Si"+Chr(13),Iif(mwkNeoAntecNacimiento.nan_orifnat=2,"	Orificios naturales permeables: No"+Chr(13),""))
		mAnamnesis6 = mAnamnesis6 + Iif(Empty(mwkNeoAntecNacimiento.nan_eab),'',"	EAB de Cordón: " + Alltrim(mwkNeoAntecNacimiento.nan_eab) + Chr(13))

	Endif
Endif

If !Used("mwkNeoAntecApgar")
	mAnamnesis6 = ""
Else
	Select mwkNeoAntecApgar
	If Reccount("mwkNeoAntecApgar")>0



* Apgar:


		If !Empty(mwkNeoAntecApgar.naa_apgar1tot) And !Empty(mwkNeoAntecApgar.naa_apgar5tot)

			mAnamnesis6 = mAnamnesis6 + Chr(13) + "	APGAR"
			mAnamnesis6 = mAnamnesis6 + Chr(13) + "		Apgar 1': "
			mAnamnesis6 = mAnamnesis6 + Iif(Empty(mwkNeoAntecApgar.naa_apgar1tot),"",mwkNeoAntecApgar.naa_apgar1tot)
			mAnamnesis6 = mAnamnesis6 + " / Apgar 5': "
			mAnamnesis6 = mAnamnesis6 + Iif(Empty(mwkNeoAntecApgar.naa_apgar5tot),"",mwkNeoAntecApgar.naa_apgar5tot)
			mAnamnesis6 = mAnamnesis6 + Iif(mwkNeoAntecApgar.naa_apgar7 < 1,""," / Alcanzó APGAR 7 a los : " + Alltrim(Str(mwkNeoAntecApgar.naa_apgar7)) + " minutos.") + Chr(13) + Chr(13)


* Si es para neo muestro detalle

			mAnamnesis6 = mAnamnesis6 + "		Detalle Apgar 1': "
			mAnamnesis6 = mAnamnesis6 + " Frecuencia Cardíaca: " + Iif(Empty(mwkNeoAntecApgar.naa_apgar1fc),"",mwkNeoAntecApgar.naa_apgar1fc)
			mAnamnesis6 = mAnamnesis6 + " Frecuencia Respiratoria: " + Iif(Empty(mwkNeoAntecApgar.naa_apgar1fr),"",mwkNeoAntecApgar.naa_apgar1fr)
			mAnamnesis6 = mAnamnesis6 + " Tono: " + Iif(Empty(mwkNeoAntecApgar.naa_apgar1to),"",mwkNeoAntecApgar.naa_apgar1to)
			mAnamnesis6 = mAnamnesis6 + " Reflejos: " + Iif(Empty(mwkNeoAntecApgar.naa_apgar1re),"",mwkNeoAntecApgar.naa_apgar1re)
			mAnamnesis6 = mAnamnesis6 + " Color : " + Iif(Empty(mwkNeoAntecApgar.naa_apgar1co),"",mwkNeoAntecApgar.naa_apgar1co)+Chr(13)

			mAnamnesis6 = mAnamnesis6 + "		Detalle Apgar 5': "
			mAnamnesis6 = mAnamnesis6 + " Frecuencia Cardíaca: "+ Iif(Empty(mwkNeoAntecApgar.naa_apgar5fc),"",mwkNeoAntecApgar.naa_apgar5fc)
			mAnamnesis6 = mAnamnesis6 + " Frecuencia Respiratoria: " + Iif(Empty(mwkNeoAntecApgar.naa_apgar5fr),"",mwkNeoAntecApgar.naa_apgar5fr)
			mAnamnesis6 = mAnamnesis6 + " Tono: "+ Iif(Empty(mwkNeoAntecApgar.naa_apgar5to),"",mwkNeoAntecApgar.naa_apgar5to)
			mAnamnesis6 = mAnamnesis6 + " Reflejos: " + Iif(Empty(mwkNeoAntecApgar.naa_apgar5re),"",mwkNeoAntecApgar.naa_apgar5re)
			mAnamnesis6 = mAnamnesis6 + " Color : " + Iif(Empty(mwkNeoAntecApgar.naa_apgar5co),"",mwkNeoAntecApgar.naa_apgar5co)+Chr(13)

		Endif



* Maniobras de Reanimación:

		If mwkNeoAntecApgar.naa_mascara + mwkNeoAntecApgar.naa_intuba + mwkNeoAntecApgar.naa_masaje + mwkNeoAntecApgar.naa_drogas + mwkNeoAntecApgar.naa_alcaliniza + ;
				mwkNeoAntecApgar.naa_estimula > 0

			mAnamnesis6 = mAnamnesis6 + Chr(13) + "	Maniobras de Reanimación: " + Chr(13)

			If mwkNeoAntecApgar.naa_mascara=1 Or mwkNeoAntecApgar.naa_intuba=1
				mAnamnesis6 = mAnamnesis6 + "			Respiración" + Chr(13)
			Endif

			mAnamnesis6 = mAnamnesis6 + Iif(mwkNeoAntecApgar.naa_mascara=1,"				Máscara: Si" + Chr(13),"")
			mAnamnesis6 = mAnamnesis6 + Iif(mwkNeoAntecApgar.naa_intuba=1,"				Intubación: Si" + Chr(13),"")

			If mwkNeoAntecApgar.naa_masaje=1 Or mwkNeoAntecApgar.naa_drogas=1
				mAnamnesis6 = mAnamnesis6 + "			Cardíaca" + Chr(13)
			Endif

			mAnamnesis6 = mAnamnesis6 + Iif(mwkNeoAntecApgar.naa_masaje=1,"				Masaje Externo: Si" + Chr(13),"" )
			mAnamnesis6 = mAnamnesis6 + Iif(mwkNeoAntecApgar.naa_drogas=1,"				Drogas: Si" + Chr(13),"")

			If mwkNeoAntecApgar.naa_alcaliniza=1 Or mwkNeoAntecApgar.naa_estimula=1
				mAnamnesis6 = mAnamnesis6 + "			Metabólica " + Chr(13)
			Endif

			mAnamnesis6 = mAnamnesis6 + Iif(mwkNeoAntecApgar.naa_alcaliniza=1,"				Alcalinizantes: Si" + Chr(13),"" )
			mAnamnesis6 = mAnamnesis6 + Iif(mwkNeoAntecApgar.naa_estimula=1,"			Estimulación Externa: Si" + Chr(13),Iif(mwkNeoAntecApgar.naa_estimula=2,"			Estimulación Externa: No" + Chr(13),""))

		Endif

		If !Empty(mAnamnesis6)
			mAnamnesis6 = mTitulo6 + mAnamnesis6
		Endif

	Endif
Endif

mAnamnesis = mAnamnesis1 + mAnamnesis2 + mAnamnesis3 + mAnamnesis4 + mAnamnesis5 + mAnamnesis6

Return mAnamnesis

*!*	* INGRESO (Indice)

*	mAnamnesis = mAnamnesis + mLinea--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" + Chr(13) + Chr(13)
*	mAnamnesis = mAnamnesis + "INGRESO" + Chr(13)
*	mAnamnesis = mAnamnesis + mLinea--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" + Chr(13) + Chr(13)

*!*	Local mltit(15)

*!*	mltit(1) = "Aspectos"
*!*	mltit(2) = "1. General"
*!*	mltit(3) = "2. Piel y Faneras"
*!*	mltit(4) = "3. Respiratorio"
*!*	mltit(5) = "4. Cardiovascular"
*!*	mltit(6) = "5. Abdominal"
*!*	mltit(7) = "6. Neurológico"
*!*	mltit(8) = "7. Osteo-Articular y Funcional"
*!*	mltit(9) = "8. Infectológico"
*!*	mltit(10) = "9. Hematológico"
*!*	mltit(11) = "10. Oftalmológico"
*!*	mltit(12) = "11. Metabólico"
*!*	mltit(13) = "12. Nutricional"
*!*	mltit(14) = "Antropometría"
*!*	mltit(15) = "Malformaciones y Alteraciones Genéticas"

*!*	For nVar = 1 To 15
*!*		mAnamnesis = mAnamnesis + mltit(nVar) + Chr(13)
*!*	Endfor

*!*	* Cuerpo (Info)

*!*	* Recorro los cursores

*!*	* Aspecto
*!*		Select mwkNeoIAspecto
*!*		mTempCentral = Iif(mwkNeoIAspecto.asp_tempcentral=0,"" , "	Temperatura Central: " + Transform(mwkNeoIAspecto.asp_tempcentral,'99.9') + " ºC" + Chr(13))
*!*		mTempAxilar  = Iif(mwkNeoIAspecto.asp_tempaxilar=0,"" , "	Temperatura Axilar: " + Transform(mwkNeoIAspecto.asp_tempaxilar,'99.9') + " ºC" + Chr(13))
*!*		medAspecto   = Iif(Empty(mwkNeoIAspecto.asp_aspecto),"" , "	Descripción: " + Proper(mwkNeoIAspecto.asp_aspecto) + Chr(13))
*!*		mAnamnesis = mAnamnesis + mLinea
*!*		mAnamnesis = mAnamnesis +  "- Aspecto Geneal:" + Chr(13)+Chr(13)

*!*		mAnamnesis = mAnamnesis + medAspecto + mTempCentral + mTempAxilar


*!*	*!*	* Piel
*!*		Local mPiel(9)

*!*		mPiel(9) = Iif(Empty(mwkNeoIPiel.pie_caput),"", "	Caput Succedaneum: " + Proper(mwkNeoIPiel.pie_caput) + Chr(13))
*!*		mPiel(8) = Iif(Empty(mwkNeoIPiel.pie_alopesicas),"", "	Zonas Alopésicas: " + Proper(mwkNeoIPiel.pie_alopesicas) + Chr(13))
*!*		mPiel(7) = Iif(Empty(mwkNeoIPiel.pie_maculas),"", "	Máculas: " + Proper(mwkNeoIPiel.pie_maculas) + Chr(13))
*!*		mPiel(6) = Iif(Empty(mwkNeoIPiel.pie_cefalohemato),"", "	Cefalohematoma: "  + Proper(mwkNeoIPiel.pie_cefalohemato) + Chr(13))
*!*		mPiel(5) = Iif(Empty(mwkNeoIPiel.pie_pnevos),"", "	Nevos: " + Proper(mwkNeoIPiel.pie_pnevos) + Chr(13))
*!*		mPiel(4) = Iif(Empty(mwkNeoIPiel.pie_plesion),"", "	Lesiones: " + Proper(mwkNeoIPiel.pie_plesion) + Chr(13))
*!*		mPiel(3) = Iif(Empty(mwkNeoIPiel.pie_angiomas),"", "	Angiomas: " + Proper(mwkNeoIPiel.pie_angiomas) + Chr(13))
*!*		mPiel(2) = Iif(Empty(mwkNeoIPiel.pie_otrospiel),"", "	Color de Piel (Detalle): " + Proper(mwkNeoIPiel.pie_otrospiel) + Chr(13))
*!*		mPiel(1) = "Color de Piel: " + Iif(mwkNeoIPiel.pie_pielcolor=1,"Rosado.",Iif(mwkNeoIPiel.pie_pielcolor=2,"Cianosis",Iif(mwkNeoIPiel.pie_pielcolor=3,;
*!*			"Pálido",Iif(mwkNeoIPiel.pie_pielcolor=4,"Rubicundo",Iif(mwkNeoIPiel.pie_pielcolor=5,"Ictérico",Iif(mwkNeoIPiel.pie_pielcolor=6,"Otros",""))))))+Chr(13)
*!*		mAnamnesis = mAnamnesis + mLinea
*!*		mAnamnesis = mAnamnesis + "- Piel y Faneras" + Chr(13) + Chr(13)

*!*		For nVar = 1 To 9
*!*			mAnamnesis = mAnamnesis + mPiel(nVar)
*!*		Endfor


*!*	* Respiratorio
*!*		Local mResp(13)

*!*		mResp(13) = Iif(Empty(mwkNeoIRespira.res_respotros),"","	Otros: " + Proper(mwkNeoIRespira.res_respotros)+Chr(13))
*!*		mResp(12) = Iif(Empty(mwkNeoIRespira.res_medicacion),"","	Medicación: " + Proper(mwkNeoIRespira.res_medicacion)+Chr(13))
*!*		mResp(11) = Iif(Empty(mwkNeoIRespira.res_estudios),"","	Estudios: " + Proper(mwkNeoIRespira.res_estudios)+Chr(13))
*!*		mResp(10) = Iif(Empty(mwkNeoIRespira.res_permanencia),"","	Permanencia: " + Proper(mwkNeoIRespira.res_permanencia)+Chr(13))
*!*		mResp(9) = Iif(Empty(mwkNeoIRespira.res_tipodrena),"","	Tipo de Drenaje: " + Proper(mwkNeoIRespira.res_tipodrena)+Chr(13))
*!*	*mResp(9) = Iif(mwkNeoIRespira.res_drenaje,"","")
*!*		mResp(8) = Iif(Empty(mwkNeoIRespira.res_ppmon),"", Proper(mwkNeoIRespira.res_ppmon) + " ppm" +Chr(13))
*!*		mResp(7) = Iif(Empty(mwkNeoIRespira.res_terapeu),"", Proper(mwkNeoIRespira.res_terapeu) + " días"+Chr(13))
*!*		mResp(6) = Iif(Empty(mwkNeoIRespira.res_enfpasivo),"", Proper(mwkNeoIRespira.res_enfpasivo) + " horas"+Chr(13))
*!*		If mwkNeoIRespira.res_asistresp > 1
*!*			mResp(5) = "	Asistencia Respiratoria: " + Iif(mwkNeoIRespira.res_asistresp=1,"ARM",Iif(mwkNeoIRespira.res_asistresp=2,"HALO",Iif(mwkNeoIRespira.res_asistresp=3,;
*!*				"CPAP",Iif(mwkNeoIRespira.res_asistresp=3,"Cánula Nasal",Iif(mwkNeoIRespira.res_asistresp=4,"Cánula Nasal Alto Flujo",;
*!*				IIF(mwkNeoIRespira.res_asistresp=5,"Enfriamiento Pasivo:",Iif(mwkNeoIRespira.res_asistresp=6,"Hipotermia Terapéutica:",;
*!*				IIF(mwkNeoIRespira.res_asistresp=7,"iNO: ",""))))))))+Chr(13)
*!*		Else
*!*			mResp(5) = ""
*!*		Endif
*!*		mResp(4) = Iif(mwkNeoIRespira.res_apnea=1,"	Apnea: Sí"+Chr(13),Iif(mwkNeoIRespira.res_apnea=2,"	Apnea: No"+Chr(13),""))
*!*		mResp(3) = Iif(Empty(mwkNeoIRespira.res_preductal),"","	Preductal: " + Proper(mwkNeoIRespira.res_preductal))+;
*!*			Iif(Empty(mwkNeoIRespira.res_preductalfio2),"", " Fio2: " + Proper(mwkNeoIRespira.res_preductalfio2)) + Chr(13) +;
*!*			Iif(Empty(mwkNeoIRespira.res_postductal),"","	Post-Ductal: " + Proper(mwkNeoIRespira.res_postductal)) + ;
*!*			Iif(Empty(mwkNeoIRespira.res_postductalfio2),""," Fio2: " + Proper(mwkNeoIRespira.res_postductalfio2))
*!*		If !Empty(mResp(3))
*!*			mResp(3) = "	Oximetría del pulso (Saturación): " + Chr(13) + mResp(3)
*!*		Else
*!*			mResp(3) = ""
*!*		Endif
*!*		mResp(2) = Iif(Empty(mwkNeoIRespira.res_frecresp),"","	Frecuencia Respiratoria: " +Proper(mwkNeoIRespira.res_frecresp)+Chr(13))
*!*		mResp(1) = Iif(Empty(mwkNeoIRespira.res_sigdifresp),"","	Signos de Dificultad Respiratoria: " + Proper(mwkNeoIRespira.res_sigdifresp)+Chr(13))

*!*	*	.page2.edAsist.ControlSource			= mwkNeoIRespira.res_asistresp VER ESTE

*!*		mAnamnesis = mAnamnesis + mLinea
*!*		mAnamnesis = mAnamnesis + "- Respiratorio:" + Chr(13) + Chr(13)

*!*		For nVar = 1 To 13
*!*			mAnamnesis = mAnamnesis + mResp(nVar)
*!*		Endfor


*!*	* Cardiovascular

*!*		Local mCardio(17)

*!*		mCardio(17) = Iif(Empty(mwkNeoICardio.car_otrasdrogas),"","	Otras drogas: " + Proper(mwkNeoICardio.car_otrasdrogas) + Chr(13))
*!*		mCardio(16) = Iif(mwkNeoICardio.car_sildena=1,"- Sildenafil" + Chr(13),"")
*!*		mCardio(15) = Iif(mwkNeoICardio.car_pge1=1,"- PGE1" + Chr(13),"")
*!*		mCardio(14) = Iif(mwkNeoICardio.car_ino=1,"- iNO" + Chr(13),"")
*!*		mCardio(13) = Iif(mwkNeoICardio.car_indomet=1,"- Indomet" + Chr(13),"")
*!*		mCardio(12) = Iif(mwkNeoICardio.car_aas=1,"- AAS" + Chr(13),"")
*!*		mCardio(11) = Iif(Empty(mwkNeoICardio.car_estcomple),"","	Estudios Complementarios: " + Proper(mwkNeoICardio.car_estcomple) + Chr(13))
*!*		mCardio(10) = Iif(Empty(mwkNeoICardio.car_media),"","	Tensión Arterial Media: " + Proper(mwkNeoICardio.car_media) + Chr(13))
*!*		mCardio(9) = Iif(Empty(mwkNeoICardio.car_diastolica),"","	Tensión Arterial Diastólica: " + Proper(mwkNeoICardio.car_diastolica) + Chr(13))
*!*		mCardio(8) = Iif(Empty(mwkNeoICardio.car_sistolica),"","	Tensión Arterial Sistólica: " + Proper(mwkNeoICardio.car_sistolica) + Chr(13))
*!*		mCardio(7) = Iif(Empty(mwkNeoICardio.car_freccard),"","	Frecuencia Cardíaca: " + Proper(mwkNeoICardio.car_freccard) + Chr(13))
*!*		mCardio(6) = Iif(Empty(mwkNeoICardio.car_descriarritmia),"","	Arritmia (Descripción): " + Proper(mwkNeoICardio.car_descriarritmia) + Chr(13))
*!*		mCardio(5) = Iif(mwkNeoICardio.car_arritmia=1,"	Arritmia: Si + Chr(13)",Iif(mwkNeoICardio.car_arritmia=2,"Arritmia: No" + Chr(13),""))
*!*		mCardio(4) = Iif(Empty(mwkNeoICardio.car_capilar),"","	Relleno Capilar: " + Proper(mwkNeoICardio.car_capilar) + Chr(13))
*!*		mCardio(3) = Iif(Empty(mwkNeoICardio.car_pulperif),"","	Pulsos Periféricos: " + Proper(mwkNeoICardio.car_pulperif) + Chr(13))
*!*		mCardio(2) = Iif(Empty(mwkNeoICardio.car_ruidos),"","	Ruidos: " + Proper(mwkNeoICardio.car_ruidos) + Chr(13))
*!*		mCardio(1) = Iif(Empty(mwkNeoICardio.car_soplo),"","	Soplo: " + Proper(mwkNeoICardio.car_soplo) + Chr(13))

*!*		mAnamnesis = mAnamnesis + mLinea
*!*		mAnamnesis = mAnamnesis + "- Cardiovascular" + Chr(13) + Chr(13)

*!*		For nVar = 1 To 17
*!*			mAnamnesis = mAnamnesis + mCardio(nVar)
*!*		Endfor

*!*	* Cargo la medicación
*!*		If Used("mwkNeoIMedicaCardio")
*!*			If Reccount("mwkNeoIMedicaCardio")>0
*!*				mAnamnesis = mAnamnesis + Chr(13) + "Drogas Vasoactivas:" + Chr(13)
*!*				Select mwkNeoIMedicaCardio
*!*	*		Set Step On
*!*	*			mMax = 0
*!*	*			Scan all
*!*	*			mCardioMedica = "Droga: " + Alltrim(Upper(mwkNeoIMedicaCardio.var_medicamento))
*!*	*			If Len(mCardioMedica) > mMax
*!*	*			mMax = Len(mCardioMedica)
*!*	*			Endif
*!*	*			Endscan

*!*	*			Go Top In "mwkNeoIMedicaCardio"

*!*	*			mMax = 50

*!*				Scan All
*!*					mCardioMedica = "	Droga: " + Alltrim(Upper(mwkNeoIMedicaCardio.var_medicamento))
*!*					mLong = 50 - Len(mCardioMedica)
*!*					mCardioDosis = Replicate("-",mLong) + "-> Dosis: " + Alltrim(mwkNeoIMedicaCardio.var_dosis)
*!*					mAnamnesis = mAnamnesis + mCardioMedica + mCardioDosis + Chr(13)
*!*				Endscan
*!*			Endif
*!*		Endif



*!*	* Abdominal

*!*		Local mAbdomen(8)

*!*		mAbdomen(1) = Iif(mwkNeoIAbdomen.abd_sondagng=1,"SOG/SNG: Si" + Chr(13),Iif(mwkNeoIAbdomen.abd_sondagng=2,"SOG/SNG: No" + Chr(13),""))
*!*		mAbdomen(2) = Iif(mwkNeoIAbdomen.abd_ruidogas=1,"Residuo Gástrico: Si" + Chr(13),Iif(mwkNeoIAbdomen.abd_ruidogas=2,"Residuo Gástrico: No" + Chr(13),""))
*!*		mAbdomen(3) = Iif(Empty(mwkNeoIAbdomen.abd_tiporg),"","Tipo Residuo Gástrico: " + Proper(mwkNeoIAbdomen.abd_tiporg) + Chr(13))
*!*		mAbdomen(4) = Iif(Empty(mwkNeoIAbdomen.abd_cantrg),"","Cantidad de Residuo Gástrico: " + Proper(mwkNeoIAbdomen.abd_cantrg) + Chr(13))
*!*		mAbdomen(5) = Iif(Empty(mwkNeoIAbdomen.abd_examenabdo),"","Exámen Clínico Abdominal: " + Proper(mwkNeoIAbdomen.abd_examenabdo) + Chr(13))
*!*		mAbdomen(6) = Iif(Empty(mwkNeoIAbdomen.abd_estudiosabdo),"","Estudios Abdominales: " + Proper(mwkNeoIAbdomen.abd_estudiosabdo) + Chr(13))
*!*		mAbdomen(7) = Iif(Empty(mwkNeoIAbdomen.abd_medicaabdo),"","Medicación: " + Proper(mwkNeoIAbdomen.abd_medicaabdo) + Chr(13))
*!*		mAbdomen(8) = Iif(Empty(mwkNeoIAbdomen.abd_datosabdo),"","Datos Relevantes: " + Proper(mwkNeoIAbdomen.abd_datosabdo) + Chr(13))

*!*		mAnamnesis = mAnamnesis + mLinea
*!*		mAnamnesis = mAnamnesis + "- Abdominal" + Chr(13) + Chr(13)

*!*		For nVar = 1 To 8
*!*			mAnamnesis = mAnamnesis + mAbdomen(nVar)
*!*		Endfor


*!*	* Neuro
*!*		Local mNeuro(9)

*!*		If mwkNeoINeuro.neu_reflejos>0
*!*			mNeuro(7)= "Reflejos Arcáicos: " + Iif(mwkNeoINeuro.neu_reflejos=1,"Presentes"+Chr(13),Iif(mwkNeoINeuro.neu_reflejos=2,"Ausentes"+Chr(13),""))
*!*		Else
*!*			mNeuro(7) = ""
*!*		Endif

*!*		If mwkNeoINeuro.neu_sensorio>0
*!*			mNeuro(1)= "Sensorio: " + Iif(mwkNeoINeuro.neu_sensorio=1,"Normal"+Chr(13),Iif(mwkNeoINeuro.neu_sensorio=2,"Deprimido"+Chr(13),;
*!*				iif(mwkNeoINeuro.neu_sensorio=3,"Alternante"+Chr(13),Iif(mwkNeoINeuro.neu_sensorio=4,"Excitado"+Chr(13),""))))
*!*		Else
*!*			mNeuro(1) = ""
*!*		Endif

*!*		If mwkNeoINeuro.neu_tono>0
*!*			mNeuro(4)= "Tono: " + Iif(mwkNeoINeuro.neu_tono=1,"Normal"+Chr(13),Iif(mwkNeoINeuro.neu_tono=2,"Hipotónico"+Chr(13),;
*!*				iif(mwkNeoINeuro.neu_tono=3,"Hipertónico"+Chr(13),"")))
*!*		Else
*!*			mNeuro(4) = ""
*!*		Endif

*!*		If mwkNeoINeuro.neu_convulneuro>0
*!*			mNeuro(5)= "Convulsiones: " + Iif(mwkNeoINeuro.neu_convulneuro=1,"Si"+Chr(13),Iif(mwkNeoINeuro.neu_convulneuro=2,"No"+Chr(13),""))
*!*		Else
*!*			mNeuro(5) = ""
*!*		Endif

*!*		If mwkNeoINeuro.neu_apnea>0
*!*			mNeuro(6)= "Apnea: " + Iif(mwkNeoINeuro.neu_apnea=1,"Si"+Chr(13),Iif(mwkNeoINeuro.neu_apnea=2,"No"+Chr(13),""))
*!*		Else
*!*			mNeuro(6) = ""
*!*		Endif

*!*		mNeuro(2) = Iif(Empty(mwkNeoINeuro.neu_pupilas),"","	Pupilas: "+Proper(mwkNeoINeuro.neu_pupilas)+Chr(13))
*!*		mNeuro(3) =	Iif(Empty(mwkNeoINeuro.neu_fontanela),"","	Fontanela: "+Proper(mwkNeoINeuro.neu_fontanela)+Chr(13))
*!*		mNeuro(8) =	Iif(Empty(mwkNeoINeuro.neu_estucompneuro),"","	Estudios Complementarios: "+Proper(mwkNeoINeuro.neu_estucompneuro)+Chr(13))
*!*		mNeuro(9) =	Iif(Empty(mwkNeoINeuro.neu_datosneuro),"","	Datos Relevantes: "+Proper(mwkNeoINeuro.neu_datosneuro)+Chr(13))

*!*		mAnamnesis = mAnamnesis + mLinea
*!*		mAnamnesis = mAnamnesis + "- Neurológico" + Chr(13) + Chr(13)

*!*		For nVar = 1 To 9
*!*			mAnamnesis = mAnamnesis + mNeuro(nVar)
*!*		Endfor

*!*	* Cargo la medicación
*!*		If Used("mwkNeoIMedicaNeuro")
*!*			If Reccount("mwkNeoIMedicaNeuro")>0
*!*				mAnamnesis = mAnamnesis + Chr(13) + "Medicación:" + Chr(13)
*!*				Select mwkNeoIMedicaNeuro
*!*				Go Top
*!*				Scan All
*!*					mNeuroMedica = "Droga: " + Alltrim(Upper(mwkNeoIMedicaNeuro.var_medicamento))
*!*					mNeuroDosis =  " --> Dosis: " + Alltrim(mwkNeoIMedicaNeuro.var_dosis)
*!*					mAnamnesis = mAnamnesis + mNeuroMedica + mNeuroDosis + Chr(13)
*!*				Endscan
*!*			Endif
*!*		Endif



*!*	* Osteo
*!*		Local mOsteo(6)

*!*		mOsteo(1)=	Iif(mwkNeoIOseo.ose_clavicula=1,"	Fractura de Clavícula"+Chr(13),"")
*!*		mOsteo(2)=	Iif(mwkNeoIOseo.ose_parabraq=1,"	Parálisis Braquial: Si" + Chr(13),Iif(mwkNeoIOseo.ose_parabraq=2,"Parálisis Braquial: No" + Chr(13),""))
*!*		mOsteo(3)=	Iif(mwkNeoIOseo.ose_piebot=1,"	Pie Bot: Reductible"+Chr(13),Iif(mwkNeoIOseo.ose_piebot=2,"Pie Bot: No Reductible"+Chr(13),""))
*!*		mOsteo(4)=	Iif(mwkNeoIOseo.ose_barlow=1,"	Ortolani y Barlow: Positivo"+Chr(13),Iif(mwkNeoIOseo.ose_barlow=2,"Ortolani y Barlow: Negativo"+Chr(13),""))
*!*		mOsteo(5)=	Iif(mwkNeoIOseo.ose_clickcadera=1,"	Click de Cadera: Positivo"+Chr(13),Iif(mwkNeoIOseo.ose_clickcadera=2,"Click de Cadera: Negativo"+Chr(13),""))
*!*		mOsteo(6)=	Iif(Empty(mwkNeoIOseo.ose_datosoesto),"","	Datos Relevantes: " + Proper(mwkNeoIOseo.ose_datosoesto)+Chr(13))
*!*		mAnamnesis = mAnamnesis + mLinea
*!*		mAnamnesis = mAnamnesis + "- Osteo-Articular y Funcional" + Chr(13) + Chr(13)
*!*		For nVar = 1 To 6
*!*			mAnamnesis = mAnamnesis + mOsteo(nVar)
*!*		Endfor


*!*	* Infecto
*!*		Local mInfecto(2)

*!*		mInfecto(2) = Iif(Empty(mwkNeoIInfecto.inf_estcomple),"","	Estudios Complementarios: " + Proper(mwkNeoIInfecto.inf_estcomple)+Chr(13))
*!*		mInfecto(1) = Iif(Empty(mwkNeoIInfecto.inf_inginfecto),"","	Resumen de Ingreso: " + Proper(mwkNeoIInfecto.inf_inginfecto)+Chr(13))


*!*		mAnamnesis = mAnamnesis + Chr(13) + Chr(13) + "- Infectológico" + Chr(13)
*!*		For nVar = 1 To 2
*!*			mAnamnesis = mAnamnesis + mInfecto(nVar)
*!*		Endfor

*!*	* Cargo el cultivo
*!*		If Used("mwkNeoICultivo")
*!*			If Reccount("mwkNeoICultivo")>0
*!*				mAnamnesis = mAnamnesis + Chr(13) + "Cultivos:" + Chr(13)
*!*				Select mwkNeoICultivo
*!*				Go Top
*!*				mInfectoTitulo = "Material               Fecha             Resultado              Gérmen                Tratamiento"
*!*				mAnamnesis = mAnamnesis + mInfectoTitulo + Chr(13)
*!*				Scan All
*!*					mInfectoMaterial = Proper(mwkNeoICultivo.var_material)
*!*					mInfectoFecha = Dtoc(mwkNeoICultivo.var_fechahora)
*!*					mInfectoResultado = Iif(mwkNeoICultivo.var_optresulta=1,'Positivo',Iif(mwkNeoICultivo.var_optresulta=2,'Negativo','Sin Valor'))
*!*					mInfectoGermen = Proper(mwkNeoICultivo.var_germen)
*!*					mInfectoTto = Proper(mwkNeoICultivo.var_tratamiento)
*!*					mAnamnesis = mAnamnesis + Alltrim(mInfectoMaterial) + Alltrim(mInfectoFecha) + Alltrim(mInfectoResultado) + Alltrim(mInfectoGermen) + Alltrim(mInfectoTto) + Chr(13)
*!*				Endscan
*!*			Endif
*!*		Endif

*!*	* Cargo Accesos Centrales
*!*		If Used("mwkNeoIAcceso")
*!*			If Reccount("mwkNeoIAcceso")>0
*!*				mAnamnesis = mAnamnesis + Chr(13) + "Accesos Centrales:" + Chr(13)
*!*				Select mwkNeoIAcceso
*!*				Go Top
*!*				mInfectoTitulo = "Tipo               Localización                          Permanencia"
*!*				mAnamnesis = mAnamnesis + mInfectoTitulo + Chr(13)
*!*				Scan All
*!*					mInfectoTipo = mwkNeoIAcceso.Descrip
*!*					mInfectoLoca = mwkNeoIAcceso.var_localizacion
*!*					mInfectoPerma = Alltrim(Str(mwkNeoIAcceso.var_permanencia))
*!*					mAnamnesis = mAnamnesis + " " + mInfectoTipo + " " + mInfectoLoca + " " + mInfectoPerma + Chr(13)
*!*				Endscan
*!*			Endif
*!*		Endif


*!*	* Hemato

*!*		Local mHemato(11)

*!*		mHemato(11)= Iif(Empty(mwkNeoIHemato.hem_otroslabo),"","	Otros Laboratorios: " + Proper(mwkNeoIHemato.hem_otroslabo)+Chr(13))
*!*		mHemato(10)= Iif(Empty(mwkNeoIHemato.hem_pc),"","	PCD: " + Proper(mwkNeoIHemato.hem_pc)+Chr(13))
*!*		mHemato(9)= Iif(Empty(mwkNeoIHemato.hem_bit),"","	Bit: " + Proper(mwkNeoIHemato.hem_bit)+Chr(13))
*!*		mHemato(8)= Iif(Empty(mwkNeoIHemato.hem_bid),"","	Bid: " + Proper(mwkNeoIHemato.hem_bid)+Chr(13))
*!*		mHemato(7)= Iif(Empty(mwkNeoIHemato.hem_hto),"","	Hto: " + Proper(mwkNeoIHemato.hem_hto)+Chr(13))
*!*		mHemato(6)= Iif(Empty(mwkNeoIHemato.hem_lmt),"","	Días de LMT: " + Proper(mwkNeoIHemato.hem_lmt)+Chr(13))
*!*		mHemato(5)= Iif(mwkNeoIHemato.hem_transfusiones=1,"	Transfusiones: Si"+Chr(13),Iif(mwkNeoIHemato.hem_transfusiones=2,"Transfusiones: No"+Chr(13),""))
*!*		mHemato(3)= Iif(mwkNeoIHemato.hem_anemia=1,"	Anemia del PT: Si" + Chr(13),Iif(mwkNeoIHemato.hem_anemia=2,"Anemia del PT: No" + Chr(13),""))
*!*	*	mHemato(4)= Iif(Empty(mwkNeoIHemato.hem_ultimatransf),"","	Ultima Transfusión: " + Iif(mwkNeoIHemato.hem_ultimatransf='01/01/1900',"",Dtoc(mwkNeoIHemato.hem_ultimatransf))+Chr(13)
*!*		mHemato(2)= Iif(Empty(mwkNeoIHemato.hem_reticulo),"","	Reticulocitos: " + Proper(mwkNeoIHemato.hem_reticulo)+Chr(13))
*!*		mHemato(1)= Iif(Empty(mwkNeoIHemato.hem_grupoyfactor),"","	Grupo Y Factor: " + Proper(Alltrim(mwkNeoIHemato.hem_grupoyfactor)+Chr(13)))

*!*		mAnamnesis = mAnamnesis + mLinea
*!*		mAnamnesis = mAnamnesis + "- Hematológico" + Chr(13) + Chr(13)

*!*		For nVar = 1 To 11
*!*			mAnamnesis = mAnamnesis + mHemato(nVar)
*!*		Endfor


*!*	* Antropometria

*!*		Local mAntro(6)

*!*		mAntro(1)= Iif(mwkNeoIAntro.ant_peso=0,"","	Peso: " + Alltrim(Str(mwkNeoIAntro.ant_peso)) + " Grs.")
*!*		mAntro(2)= Iif(mwkNeoIAntro.ant_talla=0,""," - Talla: " + Alltrim(Str(mwkNeoIAntro.ant_talla)) + " Cms.")
*!*		mAntro(3)= Iif(mwkNeoIAntro.ant_pc=0,""," - PC (Perímetro Cefálico): " + Alltrim(Str(mwkNeoIAntro.ant_pc)) + " Cms.") + Chr(13)
*!*		mAntro(4)= Iif(mwkNeoIAntro.ant_pcper=0,"","		Percentilos:" + Chr(13) + "			Peso: " + Transform(mwkNeoIAntro.ant_pcper,'99.9'))
*!*		mAntro(5)= Iif(mwkNeoIAntro.ant_tallaper=0,""," - Talla: " + Transform(mwkNeoIAntro.ant_tallaper,'99.9'))
*!*		mAntro(6)= Iif(mwkNeoIAntro.ant_pesoper=0,""," - PC (Perímetro Cefálico): " + Transform(mwkNeoIAntro.ant_pesoper,'99.9')) + Chr(13)
*!*		mAnamnesis = mAnamnesis + mLinea
*!*		mAnamnesis = mAnamnesis + "- Antropometría" + Chr(13) + Chr(13)

*!*		For nVar = 1 To 6
*!*			mAnamnesis = mAnamnesis + mAntro(nVar)
*!*		Endfor



*!*	* Oftalmo

*!*		Local mOftalmo(4)

*!*		mOftalmo(1)=	Iif(Empty(mwkNeoIOftalmo.oft_datos),"","	Datos Relevantes: " + Proper(mwkNeoIOftalmo.oft_datos) + Chr(13))
*!*		mOftalmo(2)=	Iif(mwkNeoIOftalmo.oft_fondojo=1,"	Fondo de Ojo: Si" + Chr(13),Iif(mwkNeoIOftalmo.oft_fondojo=2,"Fondo de Ojo: No"+Chr(13),""))
*!*		mOftalmo(3)=	Iif(Empty(mwkNeoIOftalmo.oft_fechaproxctrl),"","	Fecha Próximo Control: " + mwkNeoIOftalmo.oft_fechaproxctrl + Chr(13))
*!*		mOftalmo(4)=	Iif(Empty(mwkNeoIOftalmo.oft_medicacion),"","	Medicación: " + Proper(mwkNeoIOftalmo.oft_medicacion) + Chr(13))
*!*		mAnamnesis = mAnamnesis + mLinea
*!*		mAnamnesis = mAnamnesis + "- Oftalmológico" + Chr(13) + Chr(13)

*!*		For nVar = 1 To 4
*!*			mAnamnesis = mAnamnesis + mOftalmo(nVar)
*!*		Endfor



*!*	* Metabolico


*!*		Local mMetabolico(16)

*!*		mMetabolico(1)= "Trastornos:" + Chr(13)
*!*		mMetabolico(2)= Iif(mwkNeoIMetabo.met_acimetabo=1,"Acidosis Metabólica: Si"+Chr(13),"")
*!*		mMetabolico(3)= Iif(mwkNeoIMetabo.met_acirespi=1,"Acidosis Respiratoria: Si"+Chr(13),"")
*!*		mMetabolico(4)= Iif(mwkNeoIMetabo.met_alcmetabo=1,"Alcalosis Metabólica: Si"+Chr(13),"")
*!*		mMetabolico(5)= Iif(mwkNeoIMetabo.met_alcarespi=1,"Alcalosis Respiratoria: Si"+Chr(13),"")
*!*		mMetabolico(6)= Iif(mwkNeoIMetabo.met_hipercalcemia=1,"Hipercalcemia: Si"+Chr(13),"")
*!*		mMetabolico(7)= Iif(mwkNeoIMetabo.met_hiperglu=1,"Hiperglucemia: Si"+Chr(13),"")
*!*		mMetabolico(8)= Iif(mwkNeoIMetabo.met_hipercalemia=1,"Hiperkalemia: Si"+Chr(13),"")
*!*		mMetabolico(9)= Iif(mwkNeoIMetabo.met_hipernatremia=1,"Hipernatremia: Si"+Chr(13),"")
*!*		mMetabolico(10)= Iif(mwkNeoIMetabo.met_hipocalcemia=1,"Hipocalcemia: Si"+Chr(13),"")
*!*		mMetabolico(11)= Iif(mwkNeoIMetabo.met_hipoglu=1,"Hipoglucemia: Si"+Chr(13),"")
*!*		mMetabolico(12)= Iif(mwkNeoIMetabo.met_hipocalemia=1,"Hipocalemia: Si"+Chr(13),"")
*!*		mMetabolico(13)= Iif(mwkNeoIMetabo.met_hiponatremia=1,"Hiponatremia: Si"+Chr(13),"")
*!*		mMetabolico(14)= Iif(mwkNeoIMetabo.met_osteopenia=1,"Osteopenia: Si"+Chr(13),"")
*!*		mMetabolico(15)= Iif(mwkNeoIMetabo.met_otros=1,"Otros Trastornos Metablólicos: Si"+Chr(13),"")
*!*		If mwkNeoIMetabo.met_otros=1
*!*			mMetabolico(16)= Iif(Empty(mwkNeoIMetabo.met_otrostrasto),"","Detalle: " + Proper(mwkNeoIMetabo.met_otrostrasto)+Chr(13))
*!*		Else
*!*			mMetabolico(16)=""
*!*		Endif

*!*		mAnamnesis = mAnamnesis + mLinea
*!*		mAnamnesis = mAnamnesis + "- Metabólico" + Chr(13) + Chr(13)

*!*		For nVar = 1 To 16
*!*			mAnamnesis = mAnamnesis + mMetabolico(nVar)
*!*		Endfor

*!*	* Cargo Pesquisas

*!*		If Used("mwkNeoIngPesq")
*!*			If Reccount("mwkNeoIngPesq")>0
*!*				mAnamnesis = mAnamnesis + Chr(13) + "Pesquisa Neonatal:" + Chr(13)
*!*				Select mwkNeoIngPesq
*!*				Go Top
*!*	*		mInfectoTitulo = "Nro Pesq. Fecha  Resultado  Nota"
*!*	*		mAnamnesis = mAnamnesis + mInfectoTitulo + Chr(13)
*!*				Scan All
*!*					mPesq = Alltrim(Str(mwkNeoIngPesq.var_nropesq))
*!*					mFecha = Dtoc(mwkNeoIngPesq.var_fechahora)
*!*					mResultado = Alltrim(mwkNeoIngPesq.var_resultado)
*!*					mNota = Alltrim(mwkNeoIngPesq.var_nota)
*!*					mAnamnesis = mAnamnesis + "Nro Pesq.: " + mPesq + " - Fecha: " + mFecha + " - Resultado: " + mResultado + " - Nota: " + mNota + Chr(13)
*!*				Endscan
*!*			Endif
*!*		Endif



*!*	* Nutricional

*!*		Local mNutri(13)

*!*		mNutDia	= Alltrim(Str(Year(mwkNeoINutri.nut_fechaViaoral)))
*!*		mNutMes	= Alltrim(Str(Month(mwkNeoINutri.nut_fechaViaoral)))
*!*		mNutAño = Alltrim(Str(Day(mwkNeoINutri.nut_fechaViaoral)))


*!*		mNutri(1)= "	Fecha de Inicio de Vía Oral: " + mNutDia + "/" + mNutMes + "/" + mNutAño + Chr(13)
*!*		mNutri(2)=	Iif(mwkNeoINutri.nut_ayuno=1,"	Ayuno: Si" + Chr(13),Iif(mwkNeoINutri.nut_ayuno=2,"Ayuno: No" + Chr(13),""))
*!*		mNutri(3)=	Iif(mwkNeoINutri.nut_npt=1,"	NPT: Si" + Chr(13),Iif(mwkNeoINutri.nut_npt=2,"NPT: No" + Chr(13),""))
*!*		mNutri(4)=	Iif(Empty(mwkNeoINutri.nut_composicion),"","	Composición: " + mwkNeoINutri.nut_composicion + Chr(13))
*!*		mNutri(5)=	Iif(Empty(mwkNeoINutri.nut_php),"","	PHP: " + mwkNeoINutri.nut_php + Chr(13))
*!*		mNutri(6)=	Iif(mwkNeoINutri.nut_viaenteral=1,"	Vía Enteral: Si" + Chr(13),Iif(mwkNeoINutri.nut_viaenteral=2,"Vía Enteral: No" + Chr(13),""))
*!*		mNutri(7)=	Iif(Empty(mwkNeoINutri.nut_aportecalprot),"","	Aporte Calórico/Proteico: " + mwkNeoINutri.nut_aportecalprot + Chr(13))
*!*		mNutri(8)=	Iif(Empty(mwkNeoINutri.nut_aporte),"","	Aporte: " + mwkNeoINutri.nut_aporte + Chr(13))
*!*		mNutri(9)=	Iif(Empty(mwkNeoINutri.nut_tcm),"","	TCM %: " + mwkNeoINutri.nut_tcm + Chr(13))
*!*		mNutri(10)=	Iif(Empty(mwkNeoINutri.nut_tipoleche),"","	Tipo de Leche: " + mwkNeoINutri.nut_tipoleche + Chr(13))
*!*		mNutri(11)=	Iif(Empty(mwkNeoINutri.nut_polime),"","	Polimerosa %: " + mwkNeoINutri.nut_polime + Chr(13))
*!*		mNutri(12)=	Iif(Empty(mwkNeoINutri.nut_incremento),"","	Incremento Semanal de Peso: " + mwkNeoINutri.nut_incremento + Chr(13))
*!*		mNutri(13)=	Iif(Empty(mwkNeoINutri.nut_formadmin),"","	Forma de Administración: " + mwkNeoINutri.nut_formadmin + Chr(13))

*!*		mAnamnesis = mAnamnesis + mLinea
*!*		mAnamnesis = mAnamnesis + "- Nutricional" + Chr(13) + Chr(13)

*!*		For nVar = 1 To 13
*!*			mAnamnesis = mAnamnesis + mNutri(nVar)
*!*		Endfor



*!*	* Malformaciones

*!*		mAnamnesis = mAnamnesis + mLinea
*!*		mAnamnesis = mAnamnesis + "- Malformaciones" + Chr(13) + Chr(13)


*!*	*mwkNeoMalforma

*!*	* Cargo Malformaciones

*!*		If Used("mwkNeoMalforma")
*!*			If Reccount("mwkNeoMalforma")>0
*!*				mAnamnesis = mAnamnesis + Chr(13) + "Malformaciones" + Chr(13)
*!*				Select mwkNeoMalforma
*!*				Go Top
*!*	*		mInfectoTitulo = "Nro Pesq. Fecha  Resultado  Nota"
*!*	*		mAnamnesis = mAnamnesis + mInfectoTitulo + Chr(13)
*!*				Scan All
*!*					mMalDesc = Alltrim(mwkNeoMalforma.Descrip)
*!*					mMalOtras = Alltrim(mwkNeoMalforma.mal_otrasdescrip)
*!*					mAnamnesis = mAnamnesis + "Malformación: " + mMalDesc + " - Detalle: " + mMalOtras + Chr(13)
*!*				Endscan
*!*			Endif
*!*		Endif


*!*	* Quirofano

*!*		mAnamnesis = mAnamnesis + mLinea
*!*		mQuiro = Iif(Empty(mwkNeoIQuiro.qui_quiro),"","	Datos Relevantes: " + Proper(mwkNeoIQuiro.qui_quiro)+Chr(13))
*!*		mAnamnesis = mAnamnesis + "- Quirúrgico" + Chr(13) + Chr(13)
*!*		mAnamnesis = mAnamnesis + mQuiro


Return mAnamnesis
*Do Form frmguardia36 With "mresplog","Ingreso al sector",


