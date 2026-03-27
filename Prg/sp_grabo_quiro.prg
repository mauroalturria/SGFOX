*!* ======================================================================
*!*	081128 solo esta en frmquirof03
*!*	081128 FechaInternac Campo Agregado
*!*	======================================================================

Parameters mabm,mid,mAnestesista , mAyudante , mBiopsiaIntraOp , mBiopsioDiferida , mCardiologo , ;
	mCirujanoTE , mComentario , mDuracEst , mEdad , mEstComen  , mEstado , mFechaQuirof , ;
	mHemoComen , mHemoterapia , mHoraEst , mHoraEstDesp  , mHoraFin, mHoraIngre , mHoraIndAnes ,  ;
	mHoraFinAnes , mHoraEgre ,	mHoraInic , mInstrumen ,  mMateComen , mMaterialq , mNroProtocolo, ;
	mNroQuirofano , mNroregistrac , mOperCod , mOperacion ,mPacNombre , mRayos,mcodmed,mcirujano, ;
	mDiagnostico,mpacientequi,mlab, mMatInstancia,mAnestesistaCod, mAnestesiaTipo, mAyudanteCod,  ;
	mcodent, mHemoOk, mMatCondicional, mmateok, mTelefono, mtorre,mmateprovee,mpacverif,mestmaterial, ;
	manestesistanom, mCamaSolic, mCamaSector, mProgrOrigen, mTipoPacte, mServicio, mCpasProvSG, ;
	mCpasMatAdq, mCpasFechaCpa, mCpasProveed, mCpasNroProv, mAnesComen,  mAnesFecVerif,  mAnesVerif,  ;
	mCpasComen, mCodEsp, mFechaInternac, mgrabolog, madmision, mUpdate, mFecHorCita, mAisInf,mAlergiaLatex,mHoraIngreQX

&& EN CASO DE NO ESTAR DEFINIDA
&& SOLO SE AGREGO PARA EL ALTA Y LA MODIFICACION
&& 20100914

*Set Step On

xx = 0

If mwkusuario.idusuario="CARMENA"
	Set Step On
Endif

If Vartype(madmision) # "C"
	madmision = ''
Endif
If Vartype(mCodEsp) # "C"
	mCodEsp = ''
Endif
If Vartype(mNroQuirofano)="N"
	If mNroQuirofano =0
		mNroQuirofano =1
	Endif
Else
	mNroQuirofano =1
Endif
mpacientequi = Iif(Empty(mpacientequi),1,mpacientequi)
mFechaQuirof = Iif(Empty(mFechaQuirof),Ctod('01/01/1900'),mFechaQuirof )
mfechaHora	 = sp_busco_fecha_serv('DT')
banderaEntro = .T.

Select mwkusuario

musuario   = codigovax

mgrabologb = .F.

Do Case

Case mabm = 1   &&& ALTA

	mret = SQLExec(mcon1," select id,HoraEstDesp from TabQuirofano "+;
		"Where FechaQuirof = ?mFechaQuirof and  HoraEst = ?mHoraEst "+;
		"and NroQuirofano = ?mNroQuirofano ", "mwkValido")

	If mret < 0
		Messagebox("EN CONSULTA QUIROFANO",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

	maxdesp = Reccount("mwkValido")

	If mHoraEstDesp > maxdesp Or mHoraEstDesp = 0
		mHoraEstDesp = maxdesp +1
	Endif

	mdNull = Ctod("01/01/1900")

	mret = SQLExec(mcon1,"INSERT INTO TabQuirofano ( Anestesista ,Ayudante , BiopsiaIntraOp "+;
		", BiopsioDiferida , Cardiologo , CirujanoTE , Comentario , DuracEst , Edad , EstComen"+;
		", Estado , FechaQuirof , HemoComen , Hemoterapia , HoraEst , HoraEstDesp  , HoraFin,HoraIngre, HoraIngquirof ,HoraIndAnes ,HoraFinAnes ,HoraEgre"+;
		", HoraInic , Instrumen , MateComen , Material , NroProtocolo  , NroQuirofano , Nroregistrac "+;
		", OperCod , Operacion , PacNombre , Rayos,codmed,cirujano,Diagnostico,fechaHora,usuario"+;
		",laboratorio,MatInstancia, FechaInternac , AnestesistaCod, AnestesiaTipo, "+;
		" AyudanteCod, codent, HemoOk, MatCondicional, mateok, Telefono, "+;
		"torre, mateprovee,pacverif,estmaterial, anestesistanom, CamaSolic, CamaSector, ProgrOrigen, TipoPacte, Servicio"+;
		",CpasProvSG, CpasMatAdq, CpasFechaCpa, CpasProveed, CpasNroProv"+;
		", AnesComen,  AnesFecVerif,  AnesVerif , CpasObserva, CodEsp, FechaPasiva, TQC_FecHorCita, aislaInfecto, TQC_codadmision, AlergiaLatex )"+;
		" values" +;
		" (?mAnestesista , ?mAyudante , ?mBiopsiaIntraOp , ?mBiopsioDiferida "+;
		",?mCardiologo , ?mCirujanoTE , ?mComentario ,?mDuracEst , ?mEdad , ?mEstComen  "+;
		",?mEstado, ?mFechaQuirof, ?mHemoComen, ?mHemoterapia,?mHoraEst, ?mHoraEstDesp, ?mHoraFin, ?mHoraIngre,?mHoraIngreQX , ?mHoraIndAnes , ?mHoraFinAnes , ?mHoraEgre "+;
		",?mHoraInic, ?mInstrumen, ?mMateComen, ?mMaterialq, ?mNroProtocolo, ?mNroQuirofano,?mNroregistrac"+;
		",?mOperCod , ?mOperacion ,?mPacNombre , ?mRayos,?mcodmed,?mcirujano,?mDiagnostico,?mfechaHora,?musuario"+;
		",?mlab,?mMatInstancia, ?mFechaInternac   ,?mAnestesistaCod, ?mAnestesiaTipo, "+;
		"?mAyudanteCod, ?mcodent, ?mHemoOk, ?mMatCondicional, ?mmateok, ?mTelefono, "+;
		"?mtorre, ?mmateprovee,?mpacverif, ?mestmaterial, ?manestesistanom, ?mCamaSolic,"+;
		"?mCamaSector, ?mProgrOrigen, ?mTipoPacte, ?mServicio,"+;
		" ?mCpasProvSG, ?mCpasMatAdq, ?mCpasFechaCpa, ?mCpasProveed, ?mCpasNroProv,"+;
		" ?mAnesComen,  ?mAnesFecVerif,  ?mAnesVerif , ?mCpasComen, ?mCodEsp, ?mdNull, ?mFecHorCita, ?mAisInf, ?madmision, ?mAlergiaLatex )")

	If mret < 0
		Messagebox("EN ALTA DE REGISTRO QUIROFANO",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

	mret = SQLExec(mcon1," select id,usuario,fechaHora,PacNombre  from TabQuirofano "+;
		"Where FechaQuirof = ?mFechaQuirof and NroQuirofano = ?mNroQuirofano and OperCod = ?mOperCod  "+;
		"and PacNombre = ?mPacNombre ",  "mwkBuscoId")

	If mret < 0
		Messagebox("EN CONSULTA QUIROFANO",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

	Select Id From mwkBuscoId ;
		Where usuario = musuario And fechaHora = mfechaHora ;
		order By fechaHora Desc ;
		Into Cursor mwkBuscoIdM

	mid = mwkBuscoIdM.Id


* 	Desplazo las internaciones posteriores

	Select * ;
		From mwkValido ;
		Where HoraEstDesp >= mHoraEst ;
		Order By HoraEstDesp ;
		Into Cursor mwkquiro2aux2

	Select mwkquiro2aux2
	Go Top
	Scan All

		mHoraEstDesp = HoraEstDesp + 1
		midAux = Id
		mret = SQLExec(mcon1,"update Tabquirofano set horaestdesp = ?mhoraestdesp where id  = ?midAux ")

		Select mwkquiro2aux2
	Endscan

Case mabm = 2			&&& MODIFICACION

	mentro = .F.

	mret = SQLExec(mcon1," select id,NroQuirofano,FechaQuirof,horaEst,HoraEstDesp from TabQuirofano "+;
		"Where FechaQuirof = ?mFechaQuirof and " +;
		" HoraEst = ?mHoraEst and NroQuirofano = ?mNroQuirofano and not id = ?mid ", "mwkValido")

	If mret < 0
		Messagebox("EN CONSULTA QUIROFANO",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

	maxdesp = Reccount(	"mwkValido")

	If mHoraEstDesp = 0
		mHoraEstDesp = 1
	Endif

	mret = SQLExec(mcon1," select id,NroQuirofano,FechaQuirof,horaEst,HoraEstDesp from TabQuirofano " +;
		" Where id = ?mid", "mwkAuxOriginal")

	If mret < 0
		Messagebox("EN CONSULTA QUIROFANO",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

	Select mwkAuxOriginal

	mNroQuirofano2 = NroQuirofano
	mHoraEst2      = horaEst
	mHoraEstDesp2  = HoraEstDesp
	mFechaQuirof2  = FechaQuirof

	If mFechaQuirof2 # Ctod("  /  /  ")
		If  mNroQuirofano =  mNroQuirofano2  And   mHoraEst = mHoraEst2 And mFechaQuirof = mFechaQuirof2
			If mHoraEstDesp > maxdesp
				mHoraEstDesp = maxdesp
			Endif
		Else  &&cambio
			If mHoraEstDesp > maxdesp
				mHoraEstDesp = maxdesp + 1
			Endif
		Endif
	Endif

	mret = SQLExec(mcon1,"UPDATE TabQuirofano SET " + mUpdate + " where id = ?mid")

	If mret < 0
		Messagebox("EN ACTUALIZACION QUIROFANO",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		*return .F.
	Endif

	If  mNroQuirofano =  mNroQuirofano2  And   mHoraEst = mHoraEst2 And mFechaQuirof = mFechaQuirof2
*		Desplazo las internaciones posteriores
		Select * From mwkValido Where HoraEstDesp >= mHoraEst Order By HoraEstDesp Into Cursor mwkquiro2aux2

		Select mwkquiro2aux2
		Go Top
		Scan All

			mHoraEstDesp = HoraEstDesp +1
			midAux = Id
			mret = SQLExec(mcon1,"update Tabquirofano set horaestdesp = ?mhoraestdesp where id  = ?midAux ")

			Select mwkquiro2aux2
		Endscan

	Else
		If mFechaQuirof2 # Ctod("  /  /  ")

			mret = SQLExec(mcon1," select id,HoraEstDesp from TabQuirofano "+;
				" Where FechaQuirof = ?mFechaQuirof2  and " +;
				" HoraEst = ?mHoraEst2 and NroQuirofano = ?mNroQuirofano2 ", "mwkValido")

			If mret < 0
				Messagebox("EN CONSULTA QUIROFANO",16,"ERROR")
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Return .F.
			Endif

			Select * ;
				From mwkValido ;
				Order By HoraEstDesp ;
				Into Cursor mwkValido

			Select mwkValido
			Go Top
			mHoraEstDesp = 0
			Scan All

				mHoraEstDesp = mHoraEstDesp + 1
				midAux = Id
				mret = SQLExec(mcon1,"update Tabquirofano set horaestdesp = ?mhoraestdesp where id  = ?midAux ")

				Select mwkValido
			Endscan
		Endif
	Endif

	If !Empty(mComentario)

		mret = SQLExec(mcon1," select Comentario from TabQuirofano where id  = ?mid", "mwkComen")

		If mret < 0
			Messagebox("EN CONSULTA QUIROFANO",16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			*return .F.
		Endif

		Select mwkComen
		mComment = ''
		For i = 1 To Memlines(comentario)
			mComment = mComment + Mline(comentario,i)
		Endfor
		For i = 1 To Memlines(mComentario)
			mComment = mComment + Mline(mComentario,i)
		Endfor

		mret = SQLExec(mcon1," update TabQuirofano set Comentario = ?mComment where id  = ?mid" )

		If mret < 0
			Messagebox("EN ACTUALIZACION QUIROFANO",16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			*return .F.
		Endif

	Endif

	If !Empty(mEstComen)

		mret = SQLExec(mcon1," select EstComen from TabQuirofano where id  = ?mid", "mwkComen")
		If mret < 0
			Messagebox("EN CONSULTA QUIROFANO",16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

		Select mwkComen
		mComment = ''
		For i =1 To Memlines(EstComen )
			mComment = mComment + Mline(EstComen ,i)
		Endfor
		For i =1 To Memlines(mEstComen )
			mComment = mComment + Mline(mEstComen ,i)
		Endfor

		mret = SQLExec(mcon1," update TabQuirofano set EstComen = ?mComment where id  = ?mid" )

		If mret < 0
			Messagebox("EN ACTUALIZACION QUIROFANO",16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif
	Endif

	If !Empty(mHemoComen)

		mret = SQLExec(mcon1," select HemoComen from TabQuirofano where id  = ?mid", "mwkComen")
		If mret < 0
			Messagebox("EN CONSULTA QUIROFANO",16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

		Select mwkComen
		mComment = ''
		For i =1 To Memlines(HemoComen )
			mComment = mComment + Mline(HemoComen ,i)
		Endfor
		For i =1 To Memlines(mHemoComen )
			mComment = mComment + Mline(mHemoComen ,i)
		Endfor

		mret = SQLExec(mcon1," update TabQuirofano set HemoComen = ?mComment where id  = ?mid" )

		If mret < 0
			Messagebox("EN ACTUALIZACION QUIROFANO",16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

	Endif

	If !Empty(mMateComen)

		mret = SQLExec(mcon1," select MateComen from TabQuirofano where id  = ?mid", "mwkComen")
		If mret < 0
			Messagebox("EN CONSULTA QUIROFANO",16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

		Select mwkComen
		mComment = ''
		For i =1 To Memlines(MateComen )
			mComment = mComment + Mline(MateComen ,i)
		Endfor
		For i =1 To Memlines(mMateComen )
			mComment = mComment + Mline(mMateComen ,i)
		Endfor

		mret = SQLExec(mcon1," update TabQuirofano set MateComen = ?mComment where id  = ?mid" )

		If mret < 0
			Messagebox("EN ACTUALIZACION QUIROFANO",16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

	Endif

	If !Empty(mCpasComen)

		mret = SQLExec(mcon1," select CpasObserva from TabQuirofano where id  = ?mid", "mwkComen")

		If mret < 0
			Messagebox("EN CONSULTA QUIROFANO",16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

		Select mwkComen
		mComment = ''
		For i =1 To Memlines(CpasObserva )
			mComment = mComment + Mline(CpasObserva ,i)
		Endfor
		For i =1 To Memlines(mCpasComen )
			mComment = mComment + Mline(mCpasComen ,i)
		Endfor

		mret = SQLExec(mcon1," update TabQuirofano set CpasObserva = ?mComment where id  = ?mid" )

		If mret < 0
			Messagebox("EN ACTUALIZACION QUIROFANO",16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

	Endif

	If !Empty(mAnesComen)

		mret = SQLExec(mcon1," select AnesComen from TabQuirofano where id  = ?mid", "mwkComen")

		If mret < 0
			Messagebox("EN CONSULTA QUIROFANO",16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

		Select mwkComen
		mComment = ''
		For i =1 To Memlines(AnesComen )
			mComment = mComment + Mline(AnesComen ,i)
		Endfor
		For i =1 To Memlines(mAnesComen)
			mComment = mComment + Mline(mAnesComen,i)
		Endfor

		mret = SQLExec(mcon1," update TabQuirofano set AnesComen = ?mComment where id  = ?mid" )

		If mret < 0
			Messagebox("EN ACTUALIZACION QUIROFANO",16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

	Endif

Case mabm = 3		&& da de baja lo desplaza 20 años hacia atras

	mret = SQLExec(mcon1," select id,NroQuirofano,FechaQuirof,horaEst,HoraEstDesp from TabQuirofano " +;
		" Where id = ?mid", "mwkAuxOriginal")

	If mret < 0
		Messagebox("EN CONSULTA QUIROFANO",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

	Select mwkAuxOriginal

	mNroQuirofano2 = NroQuirofano
	mHoraEst2      = horaEst
	mHoraEstDesp2  = HoraEstDesp
	mifecha        = mwkAuxOriginal.FechaQuirof
	mFechaQuirof2  = FechaQuirof
	mfechabaja     = Ctod(Transform(Day(mifecha),"@L 99") +  "/" + Transform(Month(mifecha),"@L 99") +;
		"/" + Transform(Year(mifecha)-20,"@L 9999"))

*!*		mret = sqlexec(mcon1,"update Tabquirofano set FechaQuirof = ?mfechabaja where id = ?mid ")

	ldhoy = Ttod(mfechaHora)

	mret = SQLExec(mcon1,"update Tabquirofano set FechaPasiva = ?ldhoy where id = ?mid ")

	If mret < 0
		Messagebox("EN ACTUALIZACION QUIROFANO",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

	mret = SQLExec(mcon1,"update TabQuirofanoLog set FechaQuirof = ?mfechabaja where idQuirof = ?mid ")

	If mret < 0
		Messagebox("EN ACTUALIZACION QUIROFANO LOG",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		*Return .F.
	Endif

	mret = SQLExec(mcon1,"select id,HoraEstDesp from TabQuirofano "+;
		" Where FechaQuirof = ?mFechaQuirof2  and " +;
		" HoraEst = ?mHoraEst2 and NroQuirofano = ?mNroQuirofano2 "+;
		"order by HoraEstDesp ", "mwkValido")

	If mret < 0
		Messagebox("EN CONSULTA QUIROFANO",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	*	Return .F.
	Endif

	Select mwkValido
	Go Top
	mHoraEstDesp = 0
	Scan All

		mHoraEstDesp = mHoraEstDesp +1
		midAux = Id
		mret = SQLExec(mcon1,"update Tabquirofano set horaestdesp = ?mhoraestdesp where id  = ?midAux ")

		Select mwkValido
	Endscan

	If mret < 0
		Messagebox("EN ACTUALIZACION QUIROFANO",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	*	Return .F.
	Endif

	mgrabolog = .F.

Case mabm = 4		&& cierra el parte quirurgico

	mret = SQLExec(mcon1," select verificado,id from TabQuirofano " +;
		" Where id = ?mid", "mwkAuxOriginal")

	Select mwkAuxOriginal

	mret = SQLExec(mcon1,"update Tabquirofano set verificado = 1 where id = ?mid ")

	If mret < 0
		Messagebox("EN ACTUALIZACION QUIROFANO",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	*	Return .F.
	Endif

	mret = SQLExec(mcon1,"update TabQuirofanoLog set verificado = 1 where idQuirof = ?mid ")
	If mret < 0
		Messagebox("EN ACTUALIZACION QUIROFANO LOG",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
*		Return .F.
	Endif

	mpacientequi  = 0
	mNroregistrac = 0
	mgrabolog     = .F.

Case mabm = 5		&& VERIFICACION

	mret = SQLExec(mcon1,"Update Tabquirofano " + ;
		"set AnesFecVerif = ?mfechaHora,  AnesVerif = 1 where id = ?mid")

	If mret < 0
		Messagebox("EN ACTUALIZACION QUIROFANO",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	*	Return .F.
	Endif

	mret = SQLExec(mcon1,"Update TabQuirofanoLog " + ;
		"set AnesFecVerif = ?mfechaHora, AnesVerif = 1 where idQuirof = ?mid")

	If mret < 0
		Messagebox("EN ACTUALIZACION QUIROFANO LOG",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
*		Return .F.
	Endif

	mpacientequi  = 0
	mNroregistrac = 0
	mgrabolog     = .F.

*********************************************
Case mabm = 6			&&& MODIFICACION DATOS Hemo - material.etc

	mentro = .F.

	mret = SQLExec(mcon1," UPDATE TabQuirofano SET Anestesista = ?mAnestesista ,"+;
		" Hemoterapia = ?mHemoterapia , Material = ?mMaterialq, fechaHora = ?mfechaHora,"+;
		" usuario = ?musuario, MatInstancia = ?mMatInstancia, AnestesistaCod = ?mAnestesistaCod,"+;
		" AyudanteCod = ?mAyudanteCod, HemoOk = ?mHemoOk, MatCondicional = ?mMatCondicional, "+;
		" mateok = ?mmateok, mateprovee = ?mmateprovee, estmaterial = ?mestmaterial, "+;
		" anestesistanom = ?manestesistanom , CpasProvSG = ?mCpasProvSG, CpasMatAdq = ?mCpasMatAdq,"+;
		" CpasFechaCpa = ?mCpasFechaCpa, CpasProveed = ?mCpasProveed, CpasNroProv = ?mCpasNroProv,"+;
		" AnesFecVerif = ?mAnesFecVerif,  AnesVerif = ?mAnesVerif, AlergiaLatex = ?mAlergiaLatex "+;
		" where id = ?mid")

	If mret < 0
		Messagebox("EN ACTUALIZACION QUIROFANO",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

	mgrabologb = .T.


	If !Empty(mComentario)
		mret = SQLExec(mcon1," select Comentario from TabQuirofano where id  = ?mid", "mwkComen")
		If mret < 0
			Messagebox("EN CONSULTA QUIROFANO",16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		*	Return .F.
		Endif
		Select mwkComen
		mComment = ''
		For i =1 To Memlines(comentario)
			mComment = mComment + Mline(comentario,i)
		Endfor
		For i =1 To Memlines(mComentario)
			mComment = mComment + Mline(mComentario,i)
		Endfor
		mret = SQLExec(mcon1," update TabQuirofano set Comentario = ?mComment where id  = ?mid" )
		If mret < 0
			Messagebox("EN ACTUALIZACION QUIROFANO",16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	*		Return .F.
		Endif
	Endif

	If !Empty(mEstComen)
		mret = SQLExec(mcon1," select EstComen from TabQuirofano where id  = ?mid", "mwkComen")
		If mret < 0
			Messagebox("EN CONSULTA QUIROFANO",16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	*		Return .F.
		Endif
		Select mwkComen
		mComment = ''
		For i =1 To Memlines(EstComen )
			mComment = mComment + Mline(EstComen ,i)
		Endfor
		For i =1 To Memlines(mEstComen )
			mComment = mComment + Mline(mEstComen ,i)
		Endfor
		mret = SQLExec(mcon1," update TabQuirofano set EstComen = ?mComment where id  = ?mid" )
		If mret < 0
			Messagebox("EN ACTUALIZACION QUIROFANO",16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	*		Return .F.
		Endif
	Endif

	If !Empty(mHemoComen )
		mret = SQLExec(mcon1," select HemoComen from TabQuirofano where id  = ?mid", "mwkComen")
		If mret < 0
			Messagebox("EN CONSULTA QUIROFANO",16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			*return .F.
		Endif
		Select mwkComen
		mComment = ''
		For i =1 To Memlines(HemoComen )
			mComment = mComment + Mline(HemoComen ,i)
		Endfor
		For i =1 To Memlines(mHemoComen )
			mComment = mComment + Mline(mHemoComen ,i)
		Endfor
		mret = SQLExec(mcon1," update TabQuirofano set HemoComen = ?mComment where id  = ?mid" )
		If mret < 0
			Messagebox("EN ACTUALIZACION QUIROFANO",16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			*return .F.
		Endif
	Endif

	If !Empty(mMateComen )
		mret = SQLExec(mcon1," select MateComen from TabQuirofano where id  = ?mid", "mwkComen")
		If mret < 0
			Messagebox("EN CONSULTA QUIROFANO",16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			*return .F.
		Endif
		Select mwkComen
		mComment = ''
		For i =1 To Memlines(MateComen )
			mComment = mComment + Mline(MateComen ,i)
		Endfor
		For i =1 To Memlines(mMateComen )
			mComment = mComment + Mline(mMateComen ,i)
		Endfor
		mret = SQLExec(mcon1," update TabQuirofano set MateComen = ?mComment where id  = ?mid" )
		If mret < 0
			Messagebox("EN ACTUALIZACION QUIROFANO",16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			*return .F.
		Endif
	Endif

	If !Empty(mCpasComen )
		mret = SQLExec(mcon1," select CpasObserva from TabQuirofano where id  = ?mid", "mwkComen")
		If mret < 0
			Messagebox("EN CONSULTA QUIROFANO",16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			*return .F.
		Endif
		Select mwkComen
		mComment = ''
		For i =1 To Memlines(CpasObserva )
			mComment = mComment + Mline(CpasObserva ,i)
		Endfor
		For i =1 To Memlines(mCpasComen )
			mComment = mComment + Mline(mCpasComen ,i)
		Endfor
		mret = SQLExec(mcon1," update TabQuirofano set CpasObserva = ?mComment where id  = ?mid" )
		If mret < 0
			Messagebox("EN ACTUALIZACION QUIROFANO",16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			*return .F.
		Endif
	Endif

	If !Empty(mAnesComen)
		mret = SQLExec(mcon1," select AnesComen from TabQuirofano where id  = ?mid", "mwkComen")
		If mret < 0
			Messagebox("EN CONSULTA QUIROFANO",16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			*return .F.
		Endif
		Select mwkComen
		mComment = ''
		For i =1 To Memlines(AnesComen )
			mComment = mComment + Mline(AnesComen ,i)
		Endfor
		For i =1 To Memlines(mAnesComen)
			mComment = mComment + Mline(mAnesComen,i)
		Endfor
		mret = SQLExec(mcon1," update TabQuirofano set AnesComen = ?mComment where id  = ?mid" )
		If mret < 0
			Messagebox("EN ACTUALIZACION QUIROFANO",16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			*return .F.
		Endif
	Endif

	mgrabolog = .F.

Case mabm = 7 && CIRUJANOOK DIRECCION

	mret = SQLExec(mcon1,"Update Tabquirofano " + ;
		"set cirujanook = 1 where id = ?mid")

	If mret < 0
		Messagebox("EN ACTUALIZACION QUIROFANO",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		*return .F.
	Endif

	mret = SQLExec(mcon1,"Update TabquirofanoLog " + ;
		"set cirujanook = 1 where idQuirof = ?mid")

	If mret < 0
		Messagebox("EN ACTUALIZACION QUIROFANO LOG",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		*return .F.
	Endif

	mpacientequi  = 0
	mNroregistrac = 0
	mgrabolog     = .F.


Case mabm = 8		&& cierra el parte quirurgico

	mret = SQLExec(mcon1," select verificado,id from TabQuirofano " +;
		" Where id = ?mid", "mwkAuxOriginal")

	Select mwkAuxOriginal

	mret = SQLExec(mcon1,"update Tabquirofano set verificado = 0 where id = ?mid ")

	If mret < 0
		Messagebox("EN ACTUALIZACION QUIROFANO",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		*return .F.
	Endif

	mret = SQLExec(mcon1,"update TabQuirofanoLog set verificado = 0 where idQuirof = ?mid ")
	If mret < 0
		Messagebox("EN ACTUALIZACION QUIROFANO LOG",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		*return .F.
	Endif

	mpacientequi  = 0
	mNroregistrac = 0
	mgrabolog     = .F.


Case mabm = 9  && inserto desde preaggenda

	mret = SQLExec(mcon1," select id,DuracEst , Edad , HoraEst,Nroregistrac,PacNombre   ,HoraEstDesp,Diagnostico,CirujanoTE "+;
		" ,OperCod , Operacion ,Telefono,Servicio  from TabQuirofano "+;
		"Where FechaQuirof = ?mFechaQuirof and  Nroregistrac = ?mNroregistrac and Servicio  = ?mServicio and FechaPasiva = '1900-01-01' "+;
		" ", "mwkValido") &&

	If mret < 0
		Messagebox("EN CONSULTA QUIROFANO",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

	maxdesp = 0
	lsigo = .T.
	mdNull = Ctod("01/01/1900")

	If Reccount('mwkValido') = 0
		lsigo = .T.
	Else
		If Reccount('mwkValido') = 1  && mwkValido.CirujanoTE = "PREAGENDA" and
			mret = SQLExec(mcon1," select id,DuracEst , Edad , HoraEst,Nroregistrac,PacNombre   ,HoraEstDesp,Diagnostico,CirujanoTE "+;
				" ,OperCod , Operacion ,Telefono,Servicio  from TabQuirofano "+;
				"Where FechaQuirof = ?mFechaQuirof and  Nroregistrac = ?mNroregistrac and Servicio  = ?mServicio and FechaPasiva = '1900-01-01' "+;
				" and OperCod = ?mOperCod", "mwkValido") &&
			If mret < 0
				Messagebox("EN CONSULTA QUIROFANO",16,"ERROR")
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				*return .F.
			Endif
		Endif
		lsigo = (Reccount('mwkValido') = 0)
	Endif
	If lsigo
		mret = SQLExec(mcon1,"INSERT INTO TabQuirofano ( Anestesista ,Ayudante , BiopsiaIntraOp "+;
			", BiopsioDiferida , Cardiologo , CirujanoTE , Comentario , DuracEst , Edad , EstComen"+;
			", Estado , FechaQuirof , HemoComen , Hemoterapia , HoraEst , HoraEstDesp  , HoraFin,HoraIngre, HoraIngquirof ,"+;
			"HoraIndAnes ,HoraFinAnes ,HoraEgre"+;
			", HoraInic , Instrumen , MateComen , Material , NroProtocolo  , NroQuirofano , Nroregistrac "+;
			", OperCod , Operacion , PacNombre , Rayos,codmed,cirujano,Diagnostico,fechaHora,usuario"+;
			",laboratorio,MatInstancia, FechaInternac , AnestesistaCod, AnestesiaTipo, "+;
			" AyudanteCod, codent, HemoOk, MatCondicional, mateok, Telefono, "+;
			"torre, mateprovee,pacverif,estmaterial, anestesistanom, CamaSolic, CamaSector, ProgrOrigen, TipoPacte, Servicio"+;
			",CpasProvSG, CpasMatAdq, CpasFechaCpa, CpasProveed, CpasNroProv"+;
			", AnesComen,  AnesFecVerif,  AnesVerif , CpasObserva, CodEsp, FechaPasiva, TQC_FecHorCita, TQC_codadmision, AlergiaLatex  )"+;
			" values" +;
			" (?mAnestesista , ?mAyudante , ?mBiopsiaIntraOp , ?mBiopsioDiferida "+;
			",?mCardiologo , ?mCirujanoTE , ?mComentario ,?mDuracEst , ?mEdad , ?mEstComen  "+;
			",?mEstado, ?mFechaQuirof, ?mHemoComen, ?mHemoterapia,?mHoraEst, ?mHoraEstDesp, ?mHoraFin, ?mHoraIngre,?mHoraIngreQX , ?mHoraIndAnes , ?mHoraFinAnes , ?mHoraEgre "+;
			",?mHoraInic, ?mInstrumen, ?mMateComen, ?mMaterialq, ?mNroProtocolo, ?mNroQuirofano,?mNroregistrac"+;
			",?mOperCod , ?mOperacion ,?mPacNombre , ?mRayos,?mcodmed,?mcirujano,?mDiagnostico,?mfechaHora,?musuario"+;
			",?mlab,?mMatInstancia, ?mFechaInternac   ,?mAnestesistaCod, ?mAnestesiaTipo, "+;
			"?mAyudanteCod, ?mcodent, ?mHemoOk, ?mMatCondicional, ?mmateok, ?mTelefono, "+;
			"?mtorre, ?mmateprovee,?mpacverif, ?mestmaterial, ?manestesistanom, ?mCamaSolic,"+;
			"?mCamaSector, ?mProgrOrigen, ?mTipoPacte, ?mServicio,"+;
			" ?mCpasProvSG, ?mCpasMatAdq, ?mCpasFechaCpa, ?mCpasProveed, ?mCpasNroProv,"+;
			" ?mAnesComen,  ?mAnesFecVerif,  ?mAnesVerif , ?mCpasComen, ?mCodEsp, ?mdNull, ?mFecHorCita, ?madmision, ?mAlergiaLatex  )")
	Else

*			no hago nada

	Endif

	If mret < 0
		Messagebox("EN ALTA DE REGISTRO QUIROFANO",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		*return .F.
	Endif
Case mabm = 10 && ACTUALIZO  Hemo desde preagenda

	mret = SQLExec(mcon1," select id,HemoComen from TabQuirofano "+;
		"Where FechaQuirof = ?mFechaQuirof and  Nroregistrac = ?mNroregistrac and OperCod = ?mOperCod and FechaPasiva = '1900-01-01' "+;
		" ", "mwkValido") &&

	If mret < 0
		Messagebox("EN CONSULTA QUIROFANO",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

	maxdesp = 0

	mdNull = Ctod("01/01/1900")

	If Reccount('mwkValido') > 0
		mid = mwkValido.Id
		mfechaHora = sp_busco_fecha_serv('DT')

		If !Empty(mHemoComen)

			mret = SQLExec(mcon1," select HemoComen from TabQuirofano where id  = ?mid", "mwkComen")

			If mret < 0
				Messagebox("EN CONSULTA QUIROFANO",16,"ERROR")
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				*return .F.
			Endif

			Select mwkComen
			mComment = ''
			For i =1 To Memlines(HemoComen )
				mComment = mComment + Mline(HemoComen ,i)
			Endfor
			For i =1 To Memlines(mHemoComen )
				mComment = mComment + Chr(10)+Mline(mHemoComen ,i)
			Endfor

			mret = SQLExec(mcon1," update TabQuirofano set HemoComen = ?mComment where id  = ?mid" )

			If mret < 0
				Messagebox("EN ACTUALIZACION QUIROFANO",16,"ERROR")
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				*return .F.
			Endif
		Endif

		mret = SQLExec(mcon1,"INSERT INTO TabQuirofanoLog(idQuirof,Anestesista,Ayudante,BiopsiaIntraOp,"+;
			"BiopsioDiferida,Cardiologo,CirujanoTE,DuracEst,Edad,"+;
			"Estado,FechaQuirof,Hemoterapia,HoraEst,HoraEstDesp,HoraFin,"+;
			"HoraInic,Instrumen,Material,NroProtocolo,NroQuirofano,Nroregistrac,"+;
			"OperCod,Operacion,PacNombre,Rayos,codmed,cirujano,Diagnostico,fechaHora,usuario,"+;
			"laboratorio,MatInstancia, FechaInternac , AnestesistaCod, AnestesiaTipo, "+;
			"AyudanteCod,codent,HemoOk,MatCondicional,mateok,Telefono,"+;
			"torre,mateprovee,pacverif,estmaterial, anestesistanom,CamaSolic,CamaSector,ProgrOrigen,TipoPacte,Servicio,"+;
			"CpasProvSG,CpasMatAdq,CpasFechaCpa,CpasProveed,CpasNroProv,"+;
			"AnesFecVerif,AnesVerif,CodEsp, aislaInfecto, TQC_codadmision, AlergiaLatex)"+;
			" select id,Anestesista,Ayudante,BiopsiaIntraOp,"+;
			"BiopsioDiferida,Cardiologo,"+;
			"CirujanoTE,DuracEst,Edad,"+;
			"Estado,FechaQuirof,Hemoterapia,HoraEst,HoraEstDesp,HoraFin,"+;
			"HoraInic,Instrumen,Material,NroProtocolo,NroQuirofano,Nroregistrac,"+;
			"OperCod,Operacion,PacNombre,Rayos,codmed,cirujano,Diagnostico,fechaHora,usuario,"+;
			"laboratorio,MatInstancia, FechaInternac , AnestesistaCod, AnestesiaTipo, "+;
			"AyudanteCod,codent,HemoOk,MatCondicional,mateok,Telefono,"+;
			"torre,mateprovee,pacverif,estmaterial, anestesistanom,CamaSolic,CamaSector,ProgrOrigen,TipoPacte,Servicio,"+;
			"CpasProvSG,CpasMatAdq,CpasFechaCpa,CpasProveed,CpasNroProv,"+;
			"AnesFecVerif,AnesVerif,CodEsp, aislaInfecto, TQC_codadmision, AlergiaLatex from tabquirofano where id = ?mid" )
		mret = SQLExec(mcon1," UPDATE TabQuirofano set hemoterapia  = ?mhemoterapia  ,hemoOK = ?mhemoOK Where id = ?mid")
	Endif
Case mabm = 11 && ACTUALIZO  mate desde preagenda
	If mid = 0
		mret = SQLExec(mcon1," select id,MateComen from TabQuirofano "+;
			"Where FechaQuirof = ?mFechaQuirof and  Nroregistrac = ?mNroregistrac and OperCod = ?mOperCod and FechaPasiva = '1900-01-01' "+;
			" ", "mwkValido") &&
	Else
		mret = SQLExec(mcon1," select id,MateComen from TabQuirofano "+;
			"Where id = ?mid", "mwkValido") &&
	Endif
	If mret < 0
		Messagebox("EN CONSULTA QUIROFANO",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		*return .F.
	Endif


	maxdesp = 0

	mdNull = Ctod("01/01/1900")

	If Reccount('mwkValido') > 0
		mid = mwkValido.Id
		mfechaHora = sp_busco_fecha_serv('DT')


		If !Empty(mMateComen )
			mret = SQLExec(mcon1," select MateComen from TabQuirofano where id  = ?mid", "mwkComen")
			If mret < 0
				Messagebox("EN CONSULTA QUIROFANO",16,"ERROR")
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				*return .F.
			Endif
			Select mwkComen
			mComment = ''
			For i =1 To Memlines(MateComen )
				mComment = mComment + Mline(MateComen ,i)
			Endfor
			For i =1 To Memlines(mMateComen )
				mComment = mComment + Mline(mMateComen ,i)
			Endfor
			mret = SQLExec(mcon1," update TabQuirofano set MateComen = ?mComment where id  = ?mid" )
			If mret < 0
				Messagebox("EN ACTUALIZACION QUIROFANO",16,"ERROR")
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				*return .F.
			Endif
		Endif


		mret = SQLExec(mcon1,"INSERT INTO TabQuirofanoLog(idQuirof,Anestesista,Ayudante,BiopsiaIntraOp,"+;
			"BiopsioDiferida,Cardiologo,CirujanoTE,DuracEst,Edad,"+;
			"Estado,FechaQuirof,Hemoterapia,HoraEst,HoraEstDesp,HoraFin,"+;
			"HoraInic,Instrumen,Material,NroProtocolo,NroQuirofano,Nroregistrac,"+;
			"OperCod,Operacion,PacNombre,Rayos,codmed,cirujano,Diagnostico,fechaHora,usuario,"+;
			"laboratorio,MatInstancia, FechaInternac , AnestesistaCod, AnestesiaTipo, "+;
			"AyudanteCod,codent,HemoOk,MatCondicional,mateok,Telefono,"+;
			"torre,mateprovee,pacverif,estmaterial, anestesistanom,CamaSolic,CamaSector,ProgrOrigen,TipoPacte,Servicio,"+;
			"CpasProvSG,CpasMatAdq,CpasFechaCpa,CpasProveed,CpasNroProv,"+;
			"AnesFecVerif,AnesVerif,CodEsp, aislaInfecto, TQC_codadmision)"+;
			" select id,Anestesista,Ayudante,BiopsiaIntraOp,"+;
			"BiopsioDiferida,Cardiologo,"+;
			"CirujanoTE,DuracEst,Edad,"+;
			"Estado,FechaQuirof,Hemoterapia,HoraEst,HoraEstDesp,HoraFin,"+;
			"HoraInic,Instrumen,Material,NroProtocolo,NroQuirofano,Nroregistrac,"+;
			"OperCod,Operacion,PacNombre,Rayos,codmed,cirujano,Diagnostico,fechaHora,usuario,"+;
			"laboratorio,MatInstancia, FechaInternac , AnestesistaCod, AnestesiaTipo, "+;
			"AyudanteCod,codent,HemoOk,MatCondicional,mateok,Telefono,"+;
			"torre,mateprovee,pacverif,estmaterial, anestesistanom,CamaSolic,CamaSector,ProgrOrigen,TipoPacte,Servicio,"+;
			"CpasProvSG,CpasMatAdq,CpasFechaCpa,CpasProveed,CpasNroProv,"+;
			"AnesFecVerif,AnesVerif,CodEsp, aislaInfecto, TQC_codadmision from tabquirofano where id = ?mid" )

		mret = SQLExec(mcon1," UPDATE TabQuirofano set material  = ?mMaterialq ,mateOK = ?mmateok Where id = ?mid")
	Endif
Case mabm = 12 &&Cancelo/suspendo desde HCE Ambulatorio


	mret = SQLExec(mcon1,"INSERT INTO TabQuirofanoLog(idQuirof,Anestesista,Ayudante,BiopsiaIntraOp,"+;
		"BiopsioDiferida,Cardiologo,CirujanoTE,DuracEst,Edad,"+;
		"Estado,FechaQuirof,Hemoterapia,HoraEst,HoraEstDesp,HoraFin,"+;
		"HoraInic,Instrumen,Material,NroProtocolo,NroQuirofano,Nroregistrac,"+;
		"OperCod,Operacion,PacNombre,Rayos,codmed,cirujano,Diagnostico,fechaHora,usuario,"+;
		"laboratorio,MatInstancia, FechaInternac , AnestesistaCod, AnestesiaTipo, "+;
		"AyudanteCod,codent,HemoOk,MatCondicional,mateok,Telefono,"+;
		"torre,mateprovee,pacverif,estmaterial, anestesistanom,CamaSolic,CamaSector,ProgrOrigen,TipoPacte,Servicio,"+;
		"CpasProvSG,CpasMatAdq,CpasFechaCpa,CpasProveed,CpasNroProv,"+;
		"AnesFecVerif,AnesVerif,CodEsp, aislaInfecto, TQC_codadmision)"+;
		" select id,Anestesista,Ayudante,BiopsiaIntraOp,"+;
		"BiopsioDiferida,Cardiologo,"+;
		"CirujanoTE,DuracEst,Edad,"+;
		"Estado,FechaQuirof,Hemoterapia,HoraEst,HoraEstDesp,HoraFin,"+;
		"HoraInic,Instrumen,Material,NroProtocolo,NroQuirofano,Nroregistrac,"+;
		"OperCod,Operacion,PacNombre,Rayos,codmed,cirujano,Diagnostico,fechaHora,usuario,"+;
		"laboratorio,MatInstancia, FechaInternac , AnestesistaCod, AnestesiaTipo, "+;
		"AyudanteCod,codent,HemoOk,MatCondicional,mateok,Telefono,"+;
		"torre,mateprovee,pacverif,estmaterial, anestesistanom,CamaSolic,CamaSector,ProgrOrigen,TipoPacte,Servicio,"+;
		"CpasProvSG,CpasMatAdq,CpasFechaCpa,CpasProveed,CpasNroProv,"+;
		"AnesFecVerif,AnesVerif,CodEsp, aislaInfecto, TQC_codadmision from tabquirofano where id = ?mid" )

	mret = SQLExec(mcon1," UPDATE TabQuirofano set Estado = ?mEstado  Where id = ?mid")
Case mabm = 14  && inserto desde preaggenda_internados

	mret = SQLExec(mcon1," select id,DuracEst , Edad , HoraEst,Nroregistrac,PacNombre   ,HoraEstDesp,Diagnostico,CirujanoTE "+;
		" ,OperCod , Operacion ,Telefono,Servicio  from TabQuirofano "+;
		"Where FechaQuirof = ?mFechaQuirof and  Nroregistrac = ?mNroregistrac and Servicio  = ?mServicio and FechaPasiva = '1900-01-01' "+;
		" ", "mwkValido") &&

	If mret < 0
		Messagebox("EN CONSULTA QUIROFANO",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		*return .F.
	Endif

	maxdesp = 0
	lsigo = .T.
	mdNull = Ctod("01/01/1900")

	If Reccount('mwkValido') = 0
		lsigo = .T.
	Else
		If Reccount('mwkValido') = 1  && mwkValido.CirujanoTE = "PREAGENDA" and
			mret = SQLExec(mcon1," select id,DuracEst , Edad , HoraEst,Nroregistrac,PacNombre   ,HoraEstDesp,Diagnostico,CirujanoTE "+;
				" ,OperCod , Operacion ,Telefono,Servicio  from TabQuirofano "+;
				"Where FechaQuirof = ?mFechaQuirof and  Nroregistrac = ?mNroregistrac and Servicio  = ?mServicio and FechaPasiva = '1900-01-01' "+;
				" and OperCod = ?mOperCod", "mwkValido") &&
			If mret < 0
				Messagebox("EN CONSULTA QUIROFANO",16,"ERROR")
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				*return .F.
			Endif
		Endif
		lsigo = (Reccount('mwkValido') = 0)
	Endif
	If lsigo
		mret = SQLExec(mcon1,"INSERT INTO TabQuirofano ( Anestesista ,Ayudante , BiopsiaIntraOp "+;
			", BiopsioDiferida , Cardiologo , CirujanoTE , Comentario , DuracEst , Edad , EstComen"+;
			", Estado , FechaQuirof , HemoComen , Hemoterapia , HoraEst , HoraEstDesp  , HoraFin,HoraIngre, HoraIngquirof ,HoraIndAnes ,HoraFinAnes ,HoraEgre"+;
			", HoraInic , Instrumen , MateComen , Material , NroProtocolo  , NroQuirofano , Nroregistrac "+;
			", OperCod , Operacion , PacNombre , Rayos,codmed,cirujano,Diagnostico,fechaHora,usuario"+;
			",laboratorio,MatInstancia, FechaInternac , AnestesistaCod, AnestesiaTipo, "+;
			" AyudanteCod, codent, HemoOk, MatCondicional, mateok, Telefono, "+;
			"torre, mateprovee,pacverif,estmaterial, anestesistanom, CamaSolic, CamaSector, ProgrOrigen, TipoPacte, Servicio"+;
			",CpasProvSG, CpasMatAdq, CpasFechaCpa, CpasProveed, CpasNroProv"+;
			", AnesComen,  AnesFecVerif,  AnesVerif , CpasObserva, CodEsp, FechaPasiva, TQC_FecHorCita, aislaInfecto, TQC_codadmision, AlergiaLatex )"+;
			" values" +;
			" (?mAnestesista , ?mAyudante , ?mBiopsiaIntraOp , ?mBiopsioDiferida "+;
			",?mCardiologo , ?mCirujanoTE , ?mComentario ,?mDuracEst , ?mEdad , ?mEstComen  "+;
			",?mEstado, ?mFechaQuirof, ?mHemoComen, ?mHemoterapia,?mHoraEst, ?mHoraEstDesp, ?mHoraFin, ?mHoraIngre,?mHoraIngreQX , ?mHoraIndAnes , ?mHoraFinAnes , ?mHoraEgre "+;
			",?mHoraInic, ?mInstrumen, ?mMateComen, ?mMaterialq, ?mNroProtocolo, ?mNroQuirofano,?mNroregistrac"+;
			",?mOperCod , ?mOperacion ,?mPacNombre , ?mRayos,?mcodmed,?mcirujano,?mDiagnostico,?mfechaHora,?musuario"+;
			",?mlab,?mMatInstancia, ?mFechaInternac   ,?mAnestesistaCod, ?mAnestesiaTipo, "+;
			"?mAyudanteCod, ?mcodent, ?mHemoOk, ?mMatCondicional, ?mmateok, ?mTelefono, "+;
			"?mtorre, ?mmateprovee,?mpacverif, ?mestmaterial, ?manestesistanom, ?mCamaSolic,"+;
			"?mCamaSector, ?mProgrOrigen, ?mTipoPacte, ?mServicio,"+;
			" ?mCpasProvSG, ?mCpasMatAdq, ?mCpasFechaCpa, ?mCpasProveed, ?mCpasNroProv,"+;
			" ?mAnesComen,  ?mAnesFecVerif,  ?mAnesVerif , ?mCpasComen, ?mCodEsp, ?mdNull, ?mFecHorCita, ?mAisInf, ?madmision, ?mAlergiaLatex )")

	Else

*			no hago nada

	Endif

	If mret < 0
		Messagebox("EN ALTA DE REGISTRO QUIROFANO",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		*return .F.
	Endif
Endcase


If mabm < 9
	mbusco   = " and pac_codhci = ?mNroregistrac "
	mfechaqd = mFechaQuirof - 1
	mfechaqh = mFechaQuirof
	lactua   = .F.
	If Vartype(mNroregistrac )<>"N"
		mNroregistrac =Null
	Endif
	If  Nvl(mNroregistrac,0) <> 0 And mpacientequi <> 3 &&ESTO ES DE PACIENTES QUE YA PASARON X ADMISION(mpacientequi = 3) A QUIROFANO

		mret = SQLExec(mcon1,"select id,FechaHoraQuir from TabProtQuir where quirofano = ?mid ","mwkBuscoq")

		If Reccount("mwkBuscoq") = 0

			Do sp_busco_pac_internados With  mbusco && mwkpacint

			If Reccount('mwkpacint') > 0
				Select mwkpacint
				Go Bottom

				mCodAdm       = PAC_codadmision
				mpacmedicoadm = pac_medicoadmision
				mpaccodmedicoadm = PAC_codmedicoadm
				mNombrePaci   = pac_nombrepaciente

				If Vartype(pac_horaadmision)="T"
					mfechapqh =  Ctot(Dtoc(pac_fechaadmision)+" "+Ttoc(pac_horaadmision,2))
				Else
					mfechapqh =  Ctot(Dtoc(pac_fechaadmision)+" "+pac_horaadmision)
				Endif

				mret = SQLExec(mcon1,"select id,codadmision from TabProtQuir "+;
					"where codadmision = ?mCodAdm and FechaHoraQuir>=?mfechaqd and  ( quirofano is null) ","mwkBuscoPaci") &&quirofano <> ?mid or

				If mret < 0
					Messagebox("EN CONSULTA PROTOCOLO QUIRURGICO",16,"ERROR")
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
					*return .F.
				Endif

				If Reccount("mwkBuscoPaci")>0
					Select mwkBuscoPaci
					Go Bottom
					midProt = Id
					mret = SQLExec(mcon1,"update TabProtQuir set quirofano = ?mid where id  = ?midProt ")
					lactua = .T.
				Else
					Do sp_grabo_prot_quir With 1,mCodAdm , 1,'', 0,mpaccodmedicoadm ,mpacmedicoadm ,0,'',1,0,mfechapqh
					mret = SQLExec(mcon1,"select id,codadmision from TabProtQuir "+;
						"where codadmision = ?mCodAdm and  ( quirofano is null) ","mwkBuscoPaci") &&quirofano <> ?mid or
					Select mwkBuscoPaci
					Go Bottom
					midProt = Id
					If Reccount('mwkBuscoPaci') > 0
						lactua = .T.
						mret = SQLExec(mcon1,"update TabProtQuir set quirofano = ?mid where id  = ?midProt ")
					Endif
				Endif

				If mret < 0
					Messagebox("EN ACTUALIZACION PROTOCOLO QUIRURGICO",16,"ERROR")
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
					*return .F.
				Endif
			Else && reccount('mwkpacint') = 0
				Do sp_busco_cta_activa With mNroregistrac,mfechaqh

				Select pac_fechaadmision, PAC_codadmision,his_codentidad  From mwkctasamb ;
					where PAC_tipopaciente = "AMB" And pac_fechaadmision = mfechaqh And Nvl(PAC_CentroMedico, 1 )=  mxcentromedico ;
					AND his_codentidad = mcodent Into Cursor mwkcontrol   &&Busco coincidencia de entidad
				If Reccount('mwkcontrol')=0 And Reccount('mwkctasamb')>0
					Select pac_fechaadmision, PAC_codadmision,his_codentidad  From mwkctasamb ;
						where PAC_tipopaciente = "AMB" And pac_fechaadmision = mfechaqh And Nvl(PAC_CentroMedico, 1 )=  mxcentromedico ;
						 Into Cursor mwkcontrol && busco los que encuentre... :(
				Endif
				Select mwkcontrol
				Scan All
					mCodAdm	= PAC_codadmision
					If mcodent<>his_codentidad
						Messagebox("VERIFIQUE. NO COINCIDE LA ENTIDAD DEL PARTE QUIRURGICO CON LA DE LA ADMISION",48,"Control de Ingresos")
					Endif

					mret = SQLExec(mcon1,"select id,codadmision from TabProtQuir "+;
						"where codadmision = ?mCodAdm and  ( quirofano is null) ","mwkBuscoPaci") &&quirofano <> ?mid

					If mret < 0
						Messagebox("EN CONSULTA PROTOCOLO QUIRURGICO",16,"ERROR")
						Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
						*return .F.
					Endif

					Select mwkBuscoPaci
					If Reccount('mwkBuscoPaci') > 0
*Scan
						midProt = Id
						mret = SQLExec(mcon1,"update TabProtQuir set quirofano = ?mid where id  = ?midProt ")
						lactua = .T.
*Endscan
					Else
						Messagebox("ADMISION DEBE AGREGAR OTRO PROTOCOLO AMBULATORIO PARA ESTA PROGRAMACION",16,"Control de asignacion")
					Endif
					If mret < 0
						Messagebox("EN ACTUALIZACION PROTOCOLO QUIRURGICO",16,"ERROR")
						Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
						*return .F.
					Endif

					Select mwkcontrol
				Endscan
			Endif

			If !lactua && busco en pacientes de alta

				mret = SQLExec(mcon1, "select PAC_fechaadmision, PAC_horaadmision, PAC_fechaalta, PAC_codhci"+;
					", PAC_codadmision  ,PAC_codmedicoadm, PAC_operadm, PAC_medicoadmision"+;
					" FROM pacientes "+ ;
					" where  PAC_codhci = ?mNroregistrac and PAC_motivoalta<>7 and PAC_fechaadmision<=?mfechaqh and PAC_fechaalta >=?mfechaqh " +;
					" ","mwkctainter")


				If Reccount('mwkctainter') > 0
					Select mwkctainter
					Go Bottom
					mCodAdm       = PAC_codadmision
					mpacmedicoadm = pac_medicoadmision
					mpaccodmedicoadm = PAC_codmedicoadm
					If Vartype(pac_horaadmision)="T"
						mfechapqh	=  Ctot(Dtoc(pac_fechaadmision)+" "+Ttoc(pac_horaadmision,2))
					Else
						mfechapqh	=  Ctot(Dtoc(pac_fechaadmision)+" "+pac_horaadmision)
					Endif

					mret = SQLExec(mcon1,"select id,codadmision from TabProtQuir "+;
						"where codadmision = ?mCodAdm and FechaHoraQuir>=?mfechaqd and quirofano <> ?mid  ","mwkBuscoPaci")

					If mret < 0
						Messagebox("EN CONSULTA PROTOCOLO QUIRURGICO",16,"ERROR")
						Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
						*return .F.
					Endif

					If Reccount("mwkBuscoPaci")>0
						Select mwkBuscoPaci
						Go Bottom
						midProt = Id
						mret = SQLExec(mcon1,"update TabProtQuir set quirofano = ?mid where id  = ?midProt ")
						lactua = .T.
					Else
						Do sp_grabo_prot_quir With 1,mCodAdm , 1,'', 0,mpaccodmedicoadm ,mpacmedicoadm ,0,'',1,0,mfechapqh
						mret = SQLExec(mcon1,"select id,codadmision from TabProtQuir "+;
							"where codadmision = ?mCodAdm and quirofano <> ?mid ","mwkBuscoPaci")

						Select mwkBuscoPaci
						Go Bottom
						midProt = Id
						If Reccount('mwkBuscoPaci') > 0
							lactua = .T.
							mret = SQLExec(mcon1,"update TabProtQuir set quirofano = ?mid where id  = ?midProt ")
						Else
							mret = SQLExec(mcon1,"select id,codadmision from TabProtQuir "+;
								"where codadmision = ?mCodAdm  ","mwkBuscoPaci")
							If Reccount('mwkBuscoPaci') > 0
								Select mwkBuscoPaci
								Go Bottom
								midProt = Id

								mret = SQLExec(mcon1," insert into tabprotquir (CodMedicoAdm, Codadmision, FechaHoraQuir, FirmaConsentimiento, MedicoAdmision,"+;
									" Observa, Observado, Quirofano, TipoPac, Urgencia, codcie10diagn, descripdiagn )"+;
									" select  CodMedicoAdm, Codadmision, FechaHoraQuir, FirmaConsentimiento, MedicoAdmision,"+;
									" Observa, Observado, Quirofano, TipoPac, Urgencia, codcie10diagn, descripdiagn from TabProtQuir where id = ?midProt " )
								mret = SQLExec(mcon1," select * from TabProtQuir where quirofano <> ?mid and codadmision= ?mCodAdm ","mwkctrlpro")
								If Reccount('mwkctrlpro')>0
									midProt = mwkctrlpro.Id
									lactua = .T.
									mret = SQLExec(mcon1,"update TabProtQuir set quirofano = ?mid where id  = ?midProt ")
								Else
									Messagebox("ADMISION DEBE AGREGAR OTRO PROTOCOLO AMBULATORIO PARA ESTA PROGRAMACION",16,"Control de asignacion")
									return
								Endif
							Endif
							mret = SQLExec(mcon1," update TabProtQuir set quirofano = ?mquiro where id = ?miid")
						Endif
					Endif
				Else
					xx = 1
				Endif
			Else
				xx = 2
			Endif
		Else
			xx = 3


			If mid > 0 && ID de quirofano
				TEXT To lcsql Textmerge Noshow Pretext 7
					Select ID,CodAdmision  From TabProtQuir Where Quirofano = ?mid
				ENDTEXT

				If !Prg_EjecutoSql(lcSql,"mwkAuxQ")
					*return .F.
				Endif
				If !Empty(Left(madmision,4))

					Select mwkAuxQ && hago el SCAN porque hay mas de un registro
					Scan All

						TEXT To lcsql Textmerge Noshow Pretext 7
						update TabProtQuir set CodAdmision = ?madmision where id = ?mwkAuxQ.ID
						ENDTEXT

						If !Prg_EjecutoSql(lcSql,"mwkAux")
							*return .F.
						Endif

						Select mwkAuxQ
					Endscan
				Endif
				Use In Select("mwkAuxQ")

			Endif
		Endif
	Else
		xx = 4
	Endif

*	Wait Window xx
*!*	--------------------------------------------------------------------
	If mpacientequi = 3
		Select mwkpacint1
		mCodAdm       = PAC_codadmision
		mpacmedicoadm = Iif(Vartype(medicoadmision)="C",medicoadmision,"LIBRE ELECCION")
		mNombrePaci   = pac_nombrepaciente
		If Vartype(pac_horaadmision)="T"
			mfechapqh	=  Ctot(Dtoc(pac_fechaadmision)+" "+Ttoc(pac_horaadmision,2))
		Else
			mfechapqh	=  Ctot(Dtoc(pac_fechaadmision)+" "+pac_horaadmision)
		Endif

		mret = SQLExec(mcon1,"select id,codadmision  from TabProtQuir where codadmision = ?mCodAdm "+;
			"and FechaHoraQuir>=?mfechaqd ","mwkBuscoPaci")

		If mret < 0
			Messagebox("EN CONSULTA PROTOCOLO QUIRURGICO",16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			*return .F.
		Endif

		Select mwkBuscoPaci
		midProt = Id

		If Reccount('mwkBuscoPaci') > 0
			mret = SQLExec(mcon1,"update TabProtQuir set quirofano = ?mid where id  = ?midProt ")
			If mret < 0
				Messagebox("EN ACTUALIZACION PROTOCOLO QUIRURGICO",16,"ERROR")
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				*return .F.
			Endif
		Else
			Do sp_grabo_prot_quir With 1,mCodAdm , 1,'', 0, 1,mpacmedicoadm ,0,'',1,0,mfechapqh
			mret = SQLExec(mcon1,"select id,codadmision from TabProtQuir "+;
				"where codadmision = ?mCodAdm ","mwkBuscoPaci")
			Select mwkBuscoPaci
			Go Bottom
			midProt = Id
			If Reccount('mwkBuscoPaci') > 0
				mret = SQLExec(mcon1,"update TabProtQuir set quirofano = ?mid where id  = ?midProt ")
			Endif
		Endif
	Endif
*!*	--------------------------------------------------------------------

*!* Grabación User.TabQuirofanoLog
*!*	No se guardan
*!*	AnesComen
*!*	Comentario
*!*	EstComen
*!*	HemoComen
*!*	MateComen
*!*	CpasObserva
*!*	--------------------------------------------------------------------
	If mgrabolog Or mgrabologb && and mwkusuario.idusuario#"CFUNES"
*	set step on
		mfechaHora = sp_busco_fecha_serv('DT')

		mret = SQLExec(mcon1,"INSERT INTO TabQuirofanoLog(idQuirof,Anestesista,Ayudante,BiopsiaIntraOp,"+;
			"BiopsioDiferida,Cardiologo,CirujanoTE,DuracEst,Edad,"+;
			"Estado,FechaQuirof,Hemoterapia,HoraEst,HoraEstDesp,HoraFin,"+;
			"HoraInic,Instrumen,Material,NroProtocolo,NroQuirofano,Nroregistrac,"+;
			"OperCod,Operacion,PacNombre,Rayos,codmed,cirujano,Diagnostico,fechaHora,usuario,"+;
			"laboratorio,MatInstancia, FechaInternac , AnestesistaCod, AnestesiaTipo, "+;
			"AyudanteCod,codent,HemoOk,MatCondicional,mateok,Telefono,"+;
			"torre,mateprovee,pacverif,estmaterial, anestesistanom,CamaSolic,CamaSector,ProgrOrigen,TipoPacte,Servicio,"+;
			"CpasProvSG,CpasMatAdq,CpasFechaCpa,CpasProveed,CpasNroProv,"+;
			"AnesFecVerif,AnesVerif,CodEsp,aislaInfecto, TQC_codadmision,AlergiaLatex )"+;
			" values " +;
			"(?mid,?mAnestesista,?mAyudante,?mBiopsiaIntraOp,?mBiopsioDiferida,"+;
			"?mCardiologo,?mCirujanoTE,?mDuracEst,?mEdad,"+;
			"?mEstado,?mFechaQuirof,?mHemoterapia,?mHoraEst,?mHoraEstDesp, ?mHoraFin, "+;
			"?mHoraInic,?mInstrumen,?mMaterialq,?mNroProtocolo,?mNroQuirofano,?mNroregistrac,"+;
			"?mOperCod,?mOperacion,?mPacNombre,?mRayos,?mcodmed,?mcirujano,?mDiagnostico,?mfechaHora,?musuario,"+;
			"?mlab,?mMatInstancia,?mFechaInternac,?mAnestesistaCod,?mAnestesiaTipo,"+;
			"?mAyudanteCod,?mcodent,?mHemoOk,?mMatCondicional,?mmateok, ?mTelefono,"+;
			"?mtorre,?mmateprovee,?mpacverif,?mestmaterial,?manestesistanom, ?mCamaSolic,"+;
			"?mCamaSector,?mProgrOrigen,?mTipoPacte,?mServicio,"+;
			"?mCpasProvSG,?mCpasMatAdq,?mCpasFechaCpa,?mCpasProveed,?mCpasNroProv,"+;
			"?mAnesFecVerif,?mAnesVerif,?mCodEsp, ?mAisInf, ?madmision,?mAlergiaLatex )")

		If mret < 0
			Messagebox("EN REGISTRO LOG QUIROFANO",16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Endif
	Endif
*!*	--------------------------------------------------------------------

Endif















