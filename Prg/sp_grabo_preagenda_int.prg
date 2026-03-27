Lparameters MFECHA, mhora,mquiro,mobs,miadmision

Dimension lcOrigen(10)
lcOrigen(1) = "Profesional Médico"
lcOrigen(2) = "Hemoterapia"
lcOrigen(3) = "Compras"
lcOrigen(4) = "Gestión GAP"
lcOrigen(5) = "Auditoria Médica"
lcOrigen(6) = "Farmacia"
lcOrigen(7) = "Quirófano"
lcOrigen(8) = "Guardia"
lcOrigen(9) = "Internados"
lcOrigen(10) = ""


mUpdate = ""
Set Escape Off
mpacientequi = 1

If myip='172.16.1.7'
	Set Step On
Endif

ldFecNull = Ctod("01/01/1900")
mdiahoy = MFECHA
midia = prg_Dtoc(MFECHA)




If Reccount('mwkPreagenda')>0

	musuario = mwkusuario.codigovax
	Select mwkPreagenda
	Go Top
	Scan All

		mpacverif = .T.

		mFechaInternac = Null
		mOperCod 	   = PQ_codPrest
		mcodmed 	   = PQ_codmed
		mCirujano 	   = Prof
		If mcodmed>9999
			Do sp_busco_medico_datos With mcodmed,"mwkmedex"
			If Reccount("mwkmedex")>0
				mimat = Transform(Int(mwkmedex.matricula))
				mCirujano = mwkmedex.nombre
				mcodmed = mwkmedex.gerenciadora
				Do sp_busco_medico_datos With 0 ,"mwkmedexreg",,," and matriculas ="+mimat
				If Reccount("mwkmedexreg")>0
					mcodmed = mwkmedexreg.Id
					mimat = Transform(mwkmedexreg.matriculas)
					mCirujano= mwkmedexreg.nombre
				Else
					Do sp_busco_medico_datos With mcodmed ,"mwkmedexreg"
					If Reccount("mwkmedexreg")>0
						mimat = Transform(mwkmedexreg.matriculas)
						mCirujano= mwkmedexreg.nombre
					Endif
				Endif
			Endif
		Endif
		Select mwkPreagenda
		mcodent 	   = PQ_codent
		mProgrOrigen   = 1
		mTipoPacte 	   = PQ_tipoPac
		mCamaSector    = PQ_camaSector
		mCamaSolic 	   = (PQ_camaSolic = 1)
		mServicio 	   = PQ_servicio
		mCirujanote    = ''
		mconsInfFirma 	= PQ_consInfFirma
		mfecnac 		= reg_fecnacimiento
		mestadogap 		= PQ_estadoGAP
		mEdad          	= prg_edad(mfecnac,,"N")
		mEstado = 22
		Select mwkPreagenda
		mFechaQuirof   = mfecha
		mNroregistrac  = PQ_registracio
		mOperacion     = Pre_Descriprest
		mPacNombre     = REG_nombrepac
		mDiagnostico   = NVL(DescrAbrev,'')
		mtelefono      = reg_telefonos
		mFechaInternac =  Null
		mpacientequi   = 1
		mCodEsp 	   = NVL(Pre_especialidad,'')
		mFechades = PQ_fechaProg
		mNroReg = mNroregistrac
*	do sp_busco_quirofano with "", mFechades
		mHoraEstDesp	= 1
		mNroQuirofano 	= mquiro
		mhoraest		= mhora
		manestesista	= 2
		manestesistacod	   = 0
		mAnesFecVerif = ldFecNull
		manestesiatipo	   = PQ_anestesiaTipo
		mAnesVerif = .F.
		minstrumentista    = ''
		minstrumentistacod = 0
		mBiopsiaIntraOp    = (PQ_biopsiaIntraOp=1)
		mBiopsioDiferida   = .F.
		mCardiologo        = .F.
		mDuracEst          = PQ_duracEst
		mHoraFin           = 0
		mHoraInic          = 0
		mHoraIngre 			= 0
		mHoraIngreQX		= 0
		mHoraIndAnes		= 0
		mHoraFinAnes 		= 0
		mHoraEgre			= .0
		mayudante          = 0
		mlaboratorio       = .F.
		mNroProtocolo      = 0
		mRayos             = (PQ_rayos = 1)
		mtorre             = (PQ_torre = 1)
		mHemoterapia       = (PQ_hemoterapia = 1)
		mMaterialq          = (PQ_material = 1)
		manestesistanom    = ''
		mMateOK            = PQ_mateOK
		mFecHorCita     = 0
		mCpasProvSG 	= 0
		mCpasMatAdq  	= 0
		mCpasFechaCpa  	= Ctod("01/01/1900")
		mCpasProveed  	= 0
		mCpasNroProv  	= 0
		mHemook = .T. &&(PQ_hemook = 1)
		mHemonopaso = .F.
		mHemoAcenest = .F.
		mMateProvee = 0
		mmatcondicional = .F.
		mMatInstancia   = 0
		mestmaterial  = 0
		mAisInf = pq_aislainfecto
		midpreqx = Id
		midaut 	   = Id
		midprevias = Id
		mAlergiaLatex = (PQ_alergialatex = 1)


		mComentario = mobs

*!* Armado de Update 19/09/2013
		Dimension vdat(66)
		mUpdate = ""

		vdat[01] = Iif(.T., "BiopsiaIntraOp = ?mBiopsiaIntraOp", "")
		vdat[02] = Iif(.F., "BiopsioDiferida = ?mBiopsioDiferida", "")
		vdat[03] = Iif(.T., "Cardiologo = ?mCardiologo", "")
		mCirujanote = "PREAGENDA_INT"
		vdat[04] = Iif(.T., "CirujanoTE = ?mCirujanoTE", "")
		vdat[05] = Iif(.T., "DuracEst = ?mDuracEst", "")
		vdat[06] = Iif(.T., "Edad = ?mEdad", "")
		vdat[07] = Iif(.T., "Estado = ?mEstado", "")
		vdat[08] = Iif(.T., "FechaQuirof = ?mFechaQuirof", "")
		vdat[09] = Iif(.T., "Hemoterapia = ?mHemoterapia", "")
		vdat[10] = Iif(.T., "HoraEst = ?mHoraEst", "")
		vdat[11] = Iif(.T.,"HoraEstDesp = ?mHoraEstDesp","")
		vdat[12] = Iif(.T., "HoraFin = ?mHoraFin", "")
		vdat[13] = Iif(.T., "HoraIngre = ?mHoraIngre", "")
			vdat[66] = Iif(.T., "HoraIngquirof = ?mHoraIngreQX", "")
		vdat[14] = Iif(.T., "HoraIndAnes = ?mHoraIndAnes", "")
		vdat[15] = Iif(.T., "HoraFinAnes = ?mHoraFinAnes", "")
		vdat[16] = Iif(.T., "HoraEgre = ?mHoraEgre", "")
		vdat[17] = Iif(.T., "HoraInic = ?mHoraInic", "")
		vdat[18] = Iif(.F., "Instrumen = ?mInstrumen", "")
		vdat[19] = Iif(.T., "Material = ?mMaterialq", "")
		vdat[20] = Iif(.T., "NroProtocolo = ?mNroProtocolo", "")
		vdat[21] = Iif(.T., "NroQuirofano = ?mNroQuirofano", "")
		vdat[22] = Iif(.T., "Nroregistrac = ?mNroregistrac",'')
		vdat[23] = Iif(.T., "OperCod = ?mOperCod",'')
		vdat[24] = Iif(.T., "Operacion=?mOperacion", "")
		vdat[25] = Iif(.T., "PacNombre=?mPacNombre", "")
		vdat[26] = Iif(.T., "Rayos=?mRayos", "")
		vdat[27] = Iif(.T., "codmed=?mcodmed", "")
		vdat[28] = Iif(.T., "cirujano=?mcirujano", "")
		vdat[29] = Iif(.T., "Diagnostico=?mDiagnostico", "")
		vdat[30] = "fechaHora = ?mfechaHora"
		vdat[31] = "usuario = ?musuario"
		vdat[32] = Iif(.T., "laboratorio = ?mlab", "")
		vdat[33] = Iif(.F., "MatInstancia = ?mMatInstancia",'')
		vdat[34] = Iif(.F., "FechaInternac = ?mFechaInternac", "")
		vdat[35] = Iif(.F., "AnestesistaCod = ?mAnestesistaCod", "")
		vdat[36] = Iif(.T., "AnestesiaTipo = ?mAnestesiaTipo" , "")
		vdat[37] = Iif(.F., "AyudanteCod = ?mAyudanteCod", "")
		vdat[38] = Iif(.T., "codent = ?mcodent", "")
		vdat[39] = Iif(.T., "HemoOk = ?mHemoOk", "")
*			vdat[63] = iif(OptSangre and .OptSangre.value = 2, "Hemonopaso = ?mHemonopaso ", "")
*			vdat[64] = iif(OptSangre and .OptSangre.value = 2, "HemoAcenest = ?mHemoAcenest ", "")
		vdat[40] = "MatCondicional = ?mMatCondicional"
		vdat[41] = "aislaInfecto = ?mAisInf"
		vdat[41] = "mateok = ?mmateok"
		vdat[42] = Iif(.T., "Telefono = ?mTelefono", "")
		vdat[43] = Iif(.T., "torre = ?mtorre", "")
		vdat[44] = Iif(.F., "mateprovee = ?mmateprovee",'')
		vdat[45] = Iif(.T., "pacverif = ?mpacverif", "")
		vdat[46] = Iif(.F., "estmaterial = ?mestmaterial",'')
		vdat[47] = Iif(.F., "anestesistanom = ?manestesistanom", "")
		vdat[48] = Iif(.T., "CamaSolic = ?mCamaSolic", "")
		vdat[49] = Iif(.T., "CamaSector = ?mCamaSector", "")
		vdat[50] = Iif(.T., "ProgrOrigen = ?mProgrOrigen", "")
		vdat[51] = Iif(.T., "TipoPacte = ?mTipoPacte", "")
		vdat[52] = Iif(.T., "Servicio = ?mServicio", "")
		vdat[53] = Iif(.F., "CpasProvSG = ?mCpasProvSG", "")
		vdat[54] = Iif(.F., "CpasMatAdq = ?mCpasMatAdq", "")
		vdat[55] = Iif(.F., "CpasFechaCpa = ?mCpasFechaCpa", "")
		vdat[56] = Iif(.F., "CpasProveed = ?mCpasProveed", "")
		vdat[57] = Iif(.F., "CpasNroProv = ?mCpasNroProv", "")
		vdat[58] = Iif(.F., "AnesFecVerif = ?mAnesFecVerif",'')
		vdat[59] = Iif(.F., "AnesVerif = ?mAnesVerif",'')
		vdat[60] = Iif(.T., "CodEsp = ?mCodEsp", "")
		vdat[61] = Iif(.F., "Anestesista = ?mAnestesista", "")
		vdat[62] = Iif(.F., "TQC_FecHorCita = ?mFecHorCita", "")
***vdat[62] = Iif(.F., "TQC_FecHorCita = ?mFecHorCita", "")
		vdat[65] = Iif(.F., "AlergiaLatex = ?mAlergiaLatex", "")

		For mi = 1 To Alen(vdat)
			If !Empty(vdat[mi])
				If Len(Alltrim(mUpdate)) = 0
					mUpdate = mUpdate + vdat[mi]
				Else
					mUpdate = mUpdate + ", " + vdat[mi]
				Endif
			Endif
		Endfor

		Release vdat


***********************
***set step on
		Do sp_grabo_quiro With 14, 0, manestesista, minstrumentista, mBiopsiaIntraOp, mBiopsioDiferida, mCardiologo, mCirujanote,;
			mComentario , mDuracEst, mEdad, '', mEstado, mFechaQuirof, '', mHemoterapia, mhoraest, mHoraEstDesp, mHoraFin,;
			mHoraIngre , mHoraIndAnes ,	mHoraFinAnes , mHoraEgre , mHoraInic, mayudante, '', mMaterialq, mNroProtocolo, mNroQuirofano,;
			mNroregistrac, mOperCod, mOperacion, mPacNombre, mRayos, mcodmed, mCirujano, mDiagnostico, mpacientequi, mlaboratorio, mMatInstancia,;
			manestesistacod,manestesiatipo,minstrumentistacod,mcodent, mHemook, mmatcondicional, mMateOK, mtelefono,mtorre,mMateProvee,mpacverif,;
			mestmaterial,manestesistanom, mCamaSolic, mCamaSector, mProgrOrigen, mTipoPacte, mServicio,mCpasProvSG,mCpasMatAdq, mCpasFechaCpa,;
			mCpasProveed, mCpasNroProv, '', mAnesFecVerif, mAnesVerif, '', mCodEsp,mFechaInternac,.F.,;
			miadmision, mUpdate, mFecHorCita, mAisInf, mAlergiaLatex,mHoraIngreQX
 

*			estado 1367 progrmado en qurofano
*!*			miscampos = "  PQ_estado = 1564, PQ_fechaQuiro = '"+Alltrim(midia) +"' "
*!*			Do sp_actualizo_tabpqobs  With midpreqx,1, 1564,7,'Incorporado a quirófano' ,mwkusuario.codigovax
*!*			Do sp_actualizo_Tabpreqx With 4,midpreqx,miscampos
		If MFECHA =Ttod(mwkfecserv.fechahora) &&& agenda del dia
			Do sp_busco_cta_activa With mNroregistrac,MFECHA
			cadmision = ''
			If Reccount('mwkctainter')>0
				cadmision = mwkctainter.PAC_codadmision
			Endif
			If !Empty(cadmision)
				Do sp_grabo_prot_quir With 2,Alltrim(cadmision ),2,mOperacion;
					, 2,mcodmed ,Alltrim(mCirujano ),41045;
					, ' NO ESPECIFICA CODIGO',mconsInfFirma ,0
			Endif
		Endif
	Endscan
	Messagebox("SE GRABARON LOS DATOS CORRECTAMENTE",64,"INFORME")
	Set Escape On

Endif
