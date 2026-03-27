Lparameters MFECHA, mtipo



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

Do sp_busco_estados With 22 , " and tipo <=2 order by descrip  ","mwkestcircx"
Do sp_busco_estados With 24 , " and tipo =1 order by descrip  ","mwkestcir"
Do sp_busco_estados With 24 , " and tipo =2 order by descrip  ","mwkesthemogf"
Do sp_busco_estados With 24 , " and tipo =3 order by descrip  ","mwkesthemodd"
Do sp_busco_estados With 24 , " and tipo = 5 order by descrip  ","mwkestgap"
Do sp_busco_estados With 24 , " and tipo = 7 order by descrip  ","mwkestcx"
Do sp_busco_estados With 23 ," ","mwkestadosmat"
Do sp_busco_estados With 28 ," ","mwkestadosac"

If Vartype(mtipo) <> "C"
	mtipo = ""  && PREAGENDA
Endif

Use In Select('mwkmedrpzt')
Do sp_busco_medrempzt_amb With Ctod("01/01/2017")
Select * From mwkMedrpzt  Into Cursor mpkMedrpzt

mUpdate = ""
Set Escape Off
mpacientequi = 1

If mwkusuario.idusuario="CARMENA"
*	Set Step On
Endif

ldFecNull = Ctod("01/01/1900")
mdiahoy = MFECHA
midia = prg_Dtoc(MFECHA)
Do sp_busco_estados With 24 , " and subestado = 2 ","mwkcancela"

TEXT To lcsql Textmerge Noshow Pretext 7

		select TabPQX.*,
		PQ_CodPrest->Pre_Descriprest,PQ_CodPrest->Pre_especialidad,
		TabPQX.PQ_servicio->Ser_DescripServ,
		Nvl(i.nombre,SPACE(40)) as Prof,reg_numdocumento,reg_nrohclinica,reg_telefonos,reg_fecnacimiento,
		REG_nombrepac,PQ_codent->ent_descrient,PQ_coddiag->DescrAbrev,Tabpqx.ID as ida
		,PQQ_quirofano,PQQ_hora
		from TabPQX
	    left join Registracio on Registracio.Reg_NroRegistrac = TabPQX.PQ_Registracio
		left join Prestadores i on TabPQX.PQ_CodMed = i.id
		left join tabestados t on TabPQX.PQ_estadoGAP = t.id
	    left join Tabpqquiro on PQQ_referencia = TabPQX.id
		where PQ_FecPasiva = ?ldFecNull and PQ_fechaProg = ?midia
		and t.subestado != 9 and TabPQX.PQ_estadoGAP>0 
		group by TabPQX.id

ENDTEXT

Use In Select("mwkPreagenda")
Use In Select("mwkPreagenda1")
&& and PQ_fechaQuiro = ?ldFecNull
If !Prg_EjecutoSql(lcSql,"mwkPreagenda1")
	Return .F.
Endif

Select * From mwkPreagenda1 WHERE  NVL(pq_deposito,0)<>3 AND  ;
	PQ_estado Not In (Select Id From mwkcancela) And ;
	PQ_estadoGAP Not In (Select Id From mwkcancela) ;
	into Cursor mwkPreagenda
SET STEP ON
If Reccount('mwkPreagenda')>0


	mfecha1  = sp_busco_fecha_serv("DT")
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
		mestmaterial  = 0
		mMatInstancia   = 0

		Select mwkestcx
		Locate For estado = mestadogap
		If  Found()
			mEstado = mwkestcx.subestado
		Else
			mEstado = 19
		Endif
		If Between(mestado,30,39)
			Select mwkestcircx
			Locate For id = mestado
			mMatInstancia   = mwkestcircx.subestado &&mwkestcircx.Id
			mestado = 20
		Endif
		Select mwkPreagenda
		mFechaQuirof   = PQ_fechaProg
		mNroregistrac  = PQ_registracio
		mOperacion     = Pre_Descriprest
		mPacNombre     = REG_nombrepac
		mDiagnostico   = DescrAbrev
		mtelefono      = reg_telefonos
		mFechaInternac =  Null
		mpacientequi   = 1
		mCodEsp 	   = Pre_especialidad
		mFechades = PQ_fechaProg
		mNroReg = mNroregistrac
*	do sp_busco_quirofano with "", mFechades
		mHoraEstDesp	= 1
		mNroQuirofano 	= Nvl(PQQ_quirofano,1)
		mhoraest		= PQ_horaEst
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
		mHoraIngreqx		= 0
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
		
		mAisInf = pq_aislainfecto
		midpreqx = Id
		midaut 	   = Id
		midprevias = Id
		mAlergiaLatex = (PQ_alergialatex = 1)

		Do sp_busco_tabpqobs With midaut ," order by PQO_origen,PQO_fechaobs desc ","mwkpqxobs"
		Select mwkpqxobs
		mobs = ''
		mori = 0
		Scan
			If !Empty(PQO_observa) Or PQO_estado>0
				If mori#PQO_origen
					mori = PQO_origen
					mobs = mobs + Chr(10)+Iif(mori>0,lcOrigen(mori)+ Chr(10),'')
				Endif
				mobs = mobs + Ttoc(PQO_fechaobs)+" - "+Alltrim(Iif(PQO_codmed=1,nomape ,nombre))+Chr(10)
				mesta = PQO_estado
				Do Case
				Case Inlist(PQO_origen ,1,7)
					Select mwkestcir
					Locate For Id = mesta
					mobs = mobs + Alltrim(Descrip)
				Case PQO_origen = 2
					Select mwkesthemogf
					Locate For Id = mesta
					mobs = mobs + Alltrim(Descrip)
				Case Inlist(PQO_origen,3,6)
					Select mwkestadosmat
					Locate For Id = mesta
					mobs = mobs + Alltrim(Descrip)

				Case PQO_origen = 4
					Select mwkestgap
					Locate For Id = mesta
					mobs = mobs + Alltrim(Descrip)
				Case PQO_origen = 5
					Select mwkestadosac
					Locate For Id = mesta
					mobs = mobs + Alltrim(Descrip)
				Endcase


				Select mwkpqxobs
				mobs = mobs + Iif(!Empty(PQO_observa),"   Observ.:  "+Alltrim(PQO_observa),'')+Chr(10)
			Endif
		Endscan
		mComentario = mobs

*!* Armado de Update 19/09/2013
		Dimension vdat(66)
		mUpdate = ""

		vdat[01] = Iif(.T., "BiopsiaIntraOp = ?mBiopsiaIntraOp", "")
		vdat[02] = Iif(.F., "BiopsioDiferida = ?mBiopsioDiferida", "")
		vdat[03] = Iif(.T., "Cardiologo = ?mCardiologo", "")

		If mtipo = "PREAGENDA" && Para informar los provenientes de una importacion

			mCirujanote = "PREAGENDA"
			vdat[04] = Iif(.T., "CirujanoTE = ?mCirujanoTE", "")

		Else

			vdat[04] = Iif(.F., "CirujanoTE = ?mCirujanoTE", "")

		Endif

		vdat[05] = Iif(.T., "DuracEst = ?mDuracEst", "")
		vdat[06] = Iif(.T., "Edad = ?mEdad", "")
		vdat[07] = Iif(.T., "Estado = ?mEstado", "")
		vdat[08] = Iif(.T., "FechaQuirof = ?mFechaQuirof", "")
		vdat[09] = Iif(.T., "Hemoterapia = ?mHemoterapia", "")
		vdat[10] = Iif(.T., "HoraEst = ?mHoraEst", "")
		vdat[11] = Iif(.T.,"HoraEstDesp = ?mHoraEstDesp","")
		vdat[12] = Iif(.T., "HoraFin = ?mHoraFin", "")
		vdat[13] = Iif(.T., "HoraIngre = ?mHoraIngre", "")
		vdat[66] = Iif(.T., "HoraIngQuirof = ?mHoraIngreqx", "")
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
 *set step on
		Do sp_grabo_quiro With 9, 0, manestesista, minstrumentista, mBiopsiaIntraOp, mBiopsioDiferida, mCardiologo, mCirujanote,;
			mComentario , mDuracEst, mEdad, '', mEstado, mFechaQuirof, '', mHemoterapia, mhoraest, mHoraEstDesp, mHoraFin,;
			mHoraIngre , mHoraIndAnes ,	mHoraFinAnes , mHoraEgre , mHoraInic, mayudante, '', mMaterialq, mNroProtocolo, mNroQuirofano,;
			mNroregistrac, mOperCod, mOperacion, mPacNombre, mRayos, mcodmed, mCirujano, mDiagnostico, mpacientequi, mlaboratorio, mMatInstancia,;
			manestesistacod,manestesiatipo,minstrumentistacod,mcodent, mHemook, mmatcondicional, mMateOK, mtelefono,mtorre,mMateProvee,mpacverif,;
			mestmaterial,manestesistanom, mCamaSolic, mCamaSector, mProgrOrigen, mTipoPacte, mServicio,mCpasProvSG,mCpasMatAdq, mCpasFechaCpa,;
			mCpasProveed, mCpasNroProv, '', mAnesFecVerif, mAnesVerif, '', mCodEsp,mFechaInternac,.F.,;
			'', mUpdate, mFecHorCita, mAisInf, mAlergiaLatex,mHoraIngreqx


*			estado 1367 progrmado en qurofano
		miscampos = "  PQ_estado = 1564, PQ_fechaQuiro = '"+Alltrim(midia) +"' "
		Do sp_actualizo_tabpqobs  With midpreqx,1, 1564,7,'Incorporado a quirófano' ,mwkusuario.codigovax
		Do sp_actualizo_Tabpreqx With 4,midpreqx,miscampos
		If MFECHA =Ttod(mwkfecserv.fechahora) &&& agenda del dia
			Do sp_busco_cta_activa With mNroregistrac,MFECHA
			cadmision = ''
			If Reccount('mwkctainter')>0
				cadmision = mwkctainter.PAC_codadmision
			Else
				Select * From mwkctainteralta Where Nvl(PAC_motivoalta, 1 )<>7 Into Cursor mwkctaintnoAT
				If Reccount('mwkctaintnoAT')>0
					cadmision = mwkctaintnoAT.PAC_codadmision
				Else
					Select * From mwkctasamb Where Nvl(PAC_CentroMedico,1)=1 Into Cursor mwkctasambSG
					If Reccount('mwkctasambSG')>0
						cadmision = mwkctasambSG.PAC_codadmision
					Endif
				Endif
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
