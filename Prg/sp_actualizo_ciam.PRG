*
* Ciam actualización
*
Lparameters mtipo,mform

If mtras = 0
	mtras = mform.ltraslado
Endif
mlideriv = mform.ldid

mnroregi = Nvl(mform.nroregistracion,0)

If mtipo = 'ALTA' And (mereg = 'N' Or mnroregi = 0) && Preregistra ALTA

	Use In Select("mwkctrlpre")
	mret = SQLExec(mCon1,"select * from preregistra where nrodocumento = ?mdocu","mwkctrlpre")
	If mret < 0
		MTABLA = "MAESTRO PREREGISTRADOS (CONSULTA x DOC)"
		Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif
	mnroregi = 0
	Select mwkctrlpre
	Go Top
	Scan All
		If Alltrim(mwkctrlpre.afiliado) = Alltrim(Str(mnafi)) And mwkctrlpre.nombre = mnomb
			mnroregi = mwkctrlpre.Id
			Exit
		Endif
	Endscan
	Use In Select("mwkctrlpre")

	If mnroregi = 0 && Insert en Preregistra

		mcoddocu = 4 && Dni
		mfecha   = sp_busco_fecha_serv('DD')
		mdatet   = sp_busco_fecha_serv('DT')

		mret = SQLExec(mCon1, "insert into preregistra"+;
			" (afiliado,coddocu,codent,codloca,codpcia,codpostal,"+;
			" direccion,fechaalta,fechahora,fechanac,nombre,nrodocumento,"+;
			" telefono,usuario,sexo)"+;
			" values (?mnafi,?mcoddocu,?mentc,1,1,0,'ND',?mfecha,?mdatet,"+;
			" ?mfecn,?mnomb,?mdocu, '', ?midus,?msexo)")

		If mret < 0
			MTABLA = "MAESTRO PREREGISTRADOS (REGISTRO)"
			Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
			Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
			Return .F.
		Endif

*!*		Ultimo ID // select LAST_IDENTITY() AS ULTIMO from .... p/2012

		mret = SQLExec(mCon1, "select id, fechahora from preregistra"+;
			" where afiliado = ?mnafi and nrodocumento = ?mdocu","mwkctrlpre")

		If mret < 0
			MTABLA = "MAESTRO PREREGISTRADOS (CONSULTA REGISTRO)"
			Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
			Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
			Return .F.
		Endif

		Select mwkctrlpre
		Go Top
		Scan All
			If mwkctrlpre.fechahora = mdatet
				mnroregi = mwkctrlpre.id
			Endif
		Endscan
		Use In Select("mwkctrlpre")
	Endif

Endif

If mtipo = 'ALTA'

	mtipoent = mform.tipoent

	mret = SQLExec(mCon1,"insert into TabCiamDeriva ("+;
		"TCD_fechapedido,TCD_entidad,TCD_nombrepac,TCD_documento,"+;
		"TCD_direccion,TCD_idcodpostal,TCD_idprovincia,"+;
		"TCD_idlocalidad,TCD_telef1,TCD_telef2,TCD_fecnac,TCD_txtedad,"+;
		"TCD_enpadron,TCD_enregistracio,TCD_origen,"+;
		"TCD_solicita,TCD_matricula,TCD_tipomat,TCD_diagnostico,"+;
		"TCD_denuncia,TCD_compcama,TCD_compmovil,"+;
		"TCD_internacion,TCD_traslado,TCD_estado,TCD_fechacierre,TCD_autoriza,"+;
		"TCD_idusuario,TCD_sexo,TCD_fechaid,"+;
		"TCD_observ,TCD_contacto,TCD_nroafi,TCD_fecestado,"+;
		"TCD_tipubi,TCD_ubicacion,TCD_pacobs,TCD_gesobs,TCD_solicdeta,TCD_tipoent,"+;
		"TCD_gesobst,TCD_telubi,TCD_detalle,TCD_solicdetid,TCD_nroregistrac,TCD_idtabderiva)"+;
		" values "+;
		"(?mfecp,?mentc,?mnomb,?mdocu,?mdire,?mcpos,?midpr,?midlo,?mtel1,?mtel2,"+;
		"?mfecn,?mtxte,?mepad,?mereg,?morig,?msoli,?mmatr,?mtipm,?mdiag,?mdenu,?mccam,"+;
		"?mcmov,?minte,?mtras,?mesta,?mfcie,?mauto,?midus,?msexo,?mfhid,?mobse,?mconta,"+;
		"?mnafi,?mfestado,?mtubi,?mubic,?mpacobs,?mobges,?msolidet,?mtipoent,"+;
		"?mobgest,?mtelu,?mdeta,?mdetapid,?mnroregi,?mlideriv)")

	If mret > 0

		If Used('mwkidped')
			Use In mwkidped
		Endif
		mret = SQLExec(mCon1,"select id as idpedido from TabCiamDeriva "+;
			"where TCD_fechaid=?mfhid and TCD_idusuario=?midus","mwkidped")
		Select mwkidped
		Go Top
		mpedido = mwkidped.idpedido
		Use In mwkidped
		Select mwkciamev
		Go Top
		Scan
			mhos = mwkciamev.CIA_codhospA
			mlug = mwkciamev.CIA_nomhosp
			mest = mwkciamev.CIA_acepta
			mmot = mwkciamev.CIA_motivo
			mres = mwkciamev.CIA_recibe
			mfec = mwkciamev.CIA_hora
			mret = SQLExec(mCon1,"insert into TabCiamEvol ("+;
				"TCV_idpedido,TCV_codhosp,TCV_luginterna,TCV_aceptacion,TCV_motivo,TCV_responsable,"+;
				"TCV_fechaevol,TCV_idusuario)"+;
				" values "+;
				"(?mpedido,?mhos,?mlug,?mest,?mmot,?mres,?mfec,?midus)")
		Endscan
		Select mwkciamevt
		Go Top
		Scan
			mhos = mwkciamevt.CIA_orden
			mlug = mwkciamevt.CIA_nomhosp
			mest = mwkciamevt.CIA_acepta
			mmot = mwkciamevt.CIA_motivo
			mres = mwkciamevt.CIA_recibe
			mfec = mwkciamevt.CIA_hora
			mret = SQLExec(mCon1,"insert into TabCiamTras ("+;
				"TCV_idpedido,TCV_codhosp,TCV_luginterna,TCV_aceptacion,TCV_motivo,TCV_responsable,"+;
				"TCV_fechaevol,TCV_idusuario)"+;
				" values "+;
				"(?mpedido,?mhos,?mlug,?mest,?mmot,?mres,?mfec,?midus)")
		Endscan
	Else
		Messagebox("ERROR EN INGRESO DE LA DERIVACION", 16, "Validacion")
		mform.psalva = .F.
		Return .F.
	Endif
	Do sp_actua_ciam_usofrec With mubic
	Do sp_actua_ciam_usofrec With mdetapid

Else

	mbuscar = mform.npedido
	msql = "TCD_direccion=?mdire,"+;
		"TCD_idcodpostal=?mcpos,"+;
		"TCD_idprovincia=?midpr,"+;
		"TCD_idlocalidad=?midlo,"+;
		"TCD_telef1=?mtel1,"+;
		"TCD_telef2=?mtel2,"+;
		"TCD_fecnac=?mfecn,"+;
		"TCD_txtedad=?mtxte,"+;
		"TCD_origen=?morig,"+;
		"TCD_solicita=?msoli,"+;
		"TCD_matricula=?mmatr,"+;
		"TCD_tipomat=?mtipm,"+;
		"TCD_diagnostico=?mdiag,"+;
		"TCD_denuncia=?mdenu,"+;
		"TCD_compcama=?mccam,"+;
		"TCD_compmovil=?mcmov,"+;
		"TCD_internacion=?minte,"+;
		"TCD_traslado=?mtras,"+;
		"TCD_estado=?mesta,"+;
		"TCD_idusuario=?midus,"+;
		"TCD_sexo=?msexo,"+;
		"TCD_observ=?mobse,"+;
		"TCD_contacto=?mconta,"+;
		"TCD_nroafi=?mnafi,"+;
		"TCD_tipubi=?mtubi,"+;
		"TCD_ubicacion=?mubic,"+;
		"TCD_pacobs=?mpacobs,"+;
		"TCD_gesobs=?mobges,"+;
		"TCD_gesobst=?mobgest,"+;
		"TCD_solicdeta=?msolidet,"+;
		"TCD_telubi=?mtelu,"+;
		"TCD_detalle=?mdeta,"+;
		"TCD_solicdetid=?mdetapid,"+;
		"TCD_idtabderiva=?mlideriv,"+;
		"TCD_documento=?mdocu "

	If mwkTabEstados.tipo = 1
		msql = msql + ",TCD_fechacierre=?mfcie,TCD_autoriza=?mauto"
	Endif
	If mform.lestado <> mesta
		msql = msql + ",TCD_FecEstado=?mfestado"
	Endif
	mret = SQLExec(mCon1,"update TabCiamDeriva set " + msql + " where TabCiamDeriva.ID = ?mbuscar")
	If mret > 0
		Select mwkciamev
		Go Top
		mpedido = mbuscar
		Scan
			mhos=mwkciamev.CIA_codhospA    && mwkciamev.CIA_codhosp
			mlug=mwkciamev.CIA_nomhosp
			mest=mwkciamev.CIA_acepta
			mmot=mwkciamev.CIA_motivo
			mres=mwkciamev.CIA_recibe
			mfec=mwkciamev.CIA_hora
			mide=mwkciamev.CIA_codhospa2 && codid
			If mide > 0
				mret = SQLExec(mCon1,"update TabCiamEvol set "+;
					"TCV_codhosp=?mhos,"+;
					"TCV_luginterna=?mlug,"+;
					"TCV_aceptacion=?mest,"+;
					"TCV_motivo=?mmot,"+;
					"TCV_responsable=?mres,"+;
					"TCV_fechaevol=?mfec,"+;
					"TCV_idusuario=?midus "+;
					"where TabCiamEvol.ID=?mide")
			Else
				mret = SQLExec(mCon1,"insert into TabCiamEvol ("+;
					"TCV_idpedido,TCV_codhosp,TCV_luginterna,TCV_aceptacion,TCV_motivo,TCV_responsable,"+;
					"TCV_fechaevol,TCV_idusuario)"+;
					" values "+;
					"(?mpedido,?mhos,?mlug,?mest,?mmot,?mres,?mfec,?midus)")
			Endif
			If mret < 0
				Messagebox("EN ACTUALIZACION DEL MAESTRO DE EVOLUCIONES",16,"ERROR")
				mform.psalva = .F.
				Return
			Endif
		Endscan
		Select mwkciamevt
		Go Top
		mpedido = mbuscar
		Scan
			mhos = mwkciamevt.CIA_orden    && mwkciamev.CIA_codhosp
			mlug = mwkciamevt.CIA_nomhosp
			mest = mwkciamevt.CIA_acepta
			mmot = mwkciamevt.CIA_motivo
			mres = mwkciamevt.CIA_recibe
			mfec = mwkciamevt.CIA_hora
			mide = mwkciamevt.CIA_codhospA && codid
			If mide > 0
				mret = SQLExec(mCon1,"update TabCiamTras set "+;
					"TCV_codhosp=?mhos,"+;
					"TCV_luginterna=?mlug,"+;
					"TCV_aceptacion=?mest,"+;
					"TCV_motivo=?mmot,"+;
					"TCV_responsable=?mres,"+;
					"TCV_fechaevol=?mfec,"+;
					"TCV_idusuario=?midus "+;
					"where TabCiamTras.ID=?mide")
			Else
				mret = SQLExec(mCon1,"insert into TabCiamTras ("+;
					"TCV_idpedido,TCV_codhosp,TCV_luginterna,TCV_aceptacion,TCV_motivo,TCV_responsable,"+;
					"TCV_fechaevol,TCV_idusuario)"+;
					" values "+;
					"(?mpedido,?mhos,?mlug,?mest,?mmot,?mres,?mfec,?midus)")
			Endif
			If mret < 0
				Messagebox("EN ACTUALIZACION DEL MAESTRO DE TRASLADOS",16,"ERROR")
				mform.psalva = .F.
				Return
			Endif
		Endscan
	Else
		Messagebox("EN ACTUALIZACION DEL MAESTRO DE DERIVACIONES",16,"ERROR")
		mform.psalva = .F.
		Return .F.
	Endif
	If mform.ubilidorg <> mubic
		Do sp_actua_ciam_usofrec With mubic
	Endif
	If mform.pedilidorg <> mdetapid
		Do sp_actua_ciam_usofrec With mdetapid
	Endif
Endif

*!* mesta = mwkTabEstados.subestado

If mesta = 3 && Cuando cambio a: Asignado / Transito consulto por Deriva a SG

	mfcbus = sp_busco_fecha_serv('DT') - (24*60*60)
	Use In Select("mwkctrlder")
	mret = SQLExec(mCon1,"select * from tabderivacion where fechahora > ?mfcbus","mwkctrlder")
	If mret < 0
		MTABLA = "MAESTRO DERIVACIONES (24 Hs.)"
		Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif
	mubica = .F.
	Select mwkctrlder
	Go Top
	Scan All
		If mwkctrlder.nroregistrac = mnroregi
			mubica = .T.
			Exit
		Endif
	Endscan
	Use In Select("mwkctrlder")

	If !mubica And Messagebox("INCORPORA ESTE PEDIDO EN LA PLANILLA DE DERIVACIONES ?",4+32+256,"ATENCION") = 6

*!*		1: A Gestionar - 2: Trae Paciente
		Do Case
		Case mdenu = 1 && No Requiere
			mdenupo = 0
		Case mdenu = 2 && Trajo
			mdenupo = 2
		Case mdenu = 3 && Requiere y no trajo
			mdenupo = 1
		Case mdenu = 4 && A gestionar
			mdenupo = 1
		Otherwise
			mdenupo = 0
		Endcase

		mderiva = Alltrim(mwkTabOrigen.Descrip)
		mbusca  = Alltrim(mtxte)
		medad   = Int(Val(Substr(mbusca,1,At(" ",mbusca)-1)))
		mestado	= 0 && Estado sin definir
		mfechor = mform.txtfecder.Value
		mfhingr = Ctot("01/01/1900")
		mnoti   = Alltrim(mform.PGconsulta.Page2.txtsolicitado.Value)
		mobserv = Alltrim(mform.PGconsulta.Page2.txtobser1.Value)
		mpadron = Iif(mform.PGconsulta.Page1.txtpadron.Value = 'S',1,2)
		mtrasla = Alltrim(mform.PGconsulta.Page1.txtdireccion.Value)

		mret = SQLExec(mCon1, "insert into tabderivacion (codent, codint, denpolicial, derivadopor, diagnostico, edad, estado, " +;
			" fechahora, fechahoraIngreso, notifica, nroafi, nroregistrac, observa, padron, sexo, traslado, usuario, habitacion,vaxbloqreg)" +;
			" values" + ;
			" (?mentc, ?minte, ?mdenupo, ?mderiva, ?mdiag, ?medad, ?mestado, ?mfechor, ?mfhingr, ?mnoti, ?mnafi, ?mnroregi," +;
			" ?mobserv, ?mpadron, ?msexo, ?mtrasla, ?midus, ' ', 0)")

		If mret < 0
			MTABLA = "DERIVACIONES ADMISION"
			Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
			Messagebox("EN LA TABLA " + MTABLA + Chr(10) + "AVISE A SISTEMAS",16,"ERROR")
			mform.psalva = .F.
			Return .F.
		Endif
	Endif

Endif

Return .T.
