*
* Grabación Cuidados Domiciliarios
*
Lparameters mform

With mform

	Dimension vd[24]

	muser  = mwkusuario.idusuario
	mfhoy  = sp_busco_fecha_serv('DD')
	mfhoyT = sp_busco_fecha_serv('DT')
	mfnull = Ctod("01/01/1900")

	With .PAgeframe1

		With .Page1
			vd[01] = .txtfecarga.Value
			vd[02] = mform.lregistracio
			vd[03] = .txtsocio.Value
			vd[04] = .txtdireccion.Value
			vd[05] = .txtlocalidad.Value
			vd[06] = .txtprovincia.Value
			vd[07] = .txtfecnac.Value
			vd[08] = Alltrim(.txtsexo.Value)
			vd[09] = .txtfliar.Value
			vd[10] = mwkFamiliar.Id
			vd[11] = .txttelpar.Value
			vd[12] = .txttelcel.Value
			vd[13] = .txtinstitu.Value
			vd[14] = .txtinsdir.Value
			vd[15] = .txtinstel.Value
			vd[16] = .txtinsfax.Value
			vd[17] = .txtinsmail.Value
			vd[18] = .txtmedsol.Value
			vd[19] = MWKespecial.ESP_codesp
			vd[23] = .txttel.Value
			mpresumen = .chkpresumen.value
		ENDWITH
		
		With .Page2
			vd[20]  = mwkCiap2e.Id
			vd[21]  = .txtpatolog.Value
			vd[22]  = .edtresumen.Value
			mateper = .chkateper.value
		ENDWITH
		
		With .Page3
			mdescartable = .edtdescartable.value
		ENDWITH
		
		vd[24] = mform.lentidad

		If mform.ltipo = 'A'

			mret = SQLExec(mcon1,"insert into TabCuiDomSoli "+;
				"(TCS_fecarga,"+;
				"TCS_nroregistrac,"+;
				"TCS_nroafi,"+;
				"TCS_direccion,"+;
				"TCS_localidad,"+;
				"TCS_provincia,"+;
				"TCS_fecnac,"+;
				"TCS_sexo,"+;
				"TCS_fliarcargo,"+;
				"TCS_Parentesco,"+;
				"TCS_telpar,"+;
				"TCS_telcel,"+;
				"TCS_instituc,"+;
				"TCS_direinst,"+;
				"TCS_telinst,"+;
				"TCS_faxinst,"+;
				"TCS_mailinst,"+;
				"TCS_medsolic,"+;
				"TCS_medespec,"+;
				"TCS_diagnos,"+;
				"TCS_patologia,"+;
				"TCS_resumenhc,"+;
				"TCS_estado,"+;
				"TCS_fecmov,"+;
				"TCS_usuario,"+;
				"TCS_telefono,TCS_fecest,TCS_entidad,TCS_ateper,TCS_descartable,TCS_presumen)"+;
				" values "+;
				"(?vd[01],"+;
				"?vd[02],"+;
				"?vd[03],"+;
				"?vd[04],"+;
				"?vd[05],"+;
				"?vd[06],"+;
				"?vd[07],"+;
				"?vd[08],"+;
				"?vd[09],"+;
				"?vd[10],"+;
				"?vd[11],"+;
				"?vd[12],"+;
				"?vd[13],"+;
				"?vd[14],"+;
				"?vd[15],"+;
				"?vd[16],"+;
				"?vd[17],"+;
				"?vd[18],"+;
				"?vd[19],"+;
				"?vd[20],"+;
				"?vd[21],"+;
				"?vd[22],"+;
				"1,"+;
				"?mfhoyT,"+;
				"?muser,?vd[23],?mfhoy,?vd[24],?mateper,?mdescartable,?mpresumen)")

			If mret > 0
			
				Use In Select("mwklid")
				mret = SQLExec(mcon1,"select id as lid from TabCuiDomSoli"+;
					" where TCS_fecmov = ?mfhoyT and TCS_usuario = ?muser","mwklid")

				If mret > 0
					mlid = mwklid.lid
				Endif
				Use In Select("mwklid")
				
			Endif

		Else

			mlid = mwkcuidomD.Id
			mret = SQLExec(mcon1,"update TabCuiDomSoli set "+;
				"TCS_fecarga     = ?vd[01],"+;
				"TCS_nroafi      = ?vd[03],"+;
				"TCS_direccion   = ?vd[04],"+;
				"TCS_localidad   = ?vd[05],"+;
				"TCS_provincia   = ?vd[06],"+;
				"TCS_fecnac      = ?vd[07],"+;
				"TCS_sexo        = ?vd[08],"+;
				"TCS_fliarcargo  = ?vd[09],"+;
				"TCS_Parentesco  = ?vd[10],"+;
				"TCS_telpar      = ?vd[11],"+;
				"TCS_telcel      = ?vd[12],"+;
				"TCS_instituc    = ?vd[13],"+;
				"TCS_direinst    = ?vd[14],"+;
				"TCS_telinst     = ?vd[15],"+;
				"TCS_faxinst     = ?vd[16],"+;
				"TCS_mailinst    = ?vd[17],"+;
				"TCS_medsolic    = ?vd[18],"+;
				"TCS_medespec    = ?vd[19],"+;
				"TCS_diagnos     = ?vd[20],"+;
				"TCS_patologia   = ?vd[21],"+;
				"TCS_resumenhc   = ?vd[22],"+;
				"TCS_fecmov      = ?mfhoyT,"+;
				"TCS_usuario     = ?muser, "+;
				"TCS_entidad     = ?vd[24],"+;
				"TCS_telefono    = ?vd[23],"+;
				"TCS_ateper      = ?mateper,"+;
				"TCS_descartable = ?mdescartable,"+;
				"TCS_presumen    = ?mpresumen "+;
				" where id = ?mlid")

		Endif

		If mret < 0
			MTABLA = "CUIDADOS DOMICILIARIOS"
			Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
			Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
			Return .F.
		Endif

		Release vd
		mretorno = TBAnexas(mform.ltipo)

	Endwith

Endwith

Return mretorno

* Funciones

Function TBAnexas(mltipo)

*--------------------------------------------------------------------------------
* Prestaciones Solicitadas
* mwkpresta
* TabCuiDomPres
* ID Solicitud maestro
* TCP_idsolic
* ID Prestación Grid prestaciones
* TCP_idprest
* Pasivado
* TCP_pasivado
* mret = SQLEXEC(mcon1,"delete from TabCuiDomPres where TCP_idsolic = ?mlid")
*--------------------------------------------------------------------------------

If mltipo <> "A"
	mret = SQLExec(mcon1,"update TabCuiDomPres set"+;
		" TCP_pasivado = ?mfhoy,"+;
		" TCP_usuario  = ?muser "+;
		" where TCP_idsolic = ?mlid and TCP_pasivado = ?mfnull")

	If mret < 0
		MTABLA = "CUIDADOS DOMICILIARIOS PRESTACIONES - INICILIZACION"
		Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif
Endif

Dimension vd[7]
Select mwkpresta
Go Top
Scan All

	If mwkpresta.psel = 1

		vd[1] = mwkpresta.pid
		vd[2] = mwkpresta.potra
		vd[3] = mwkpresta.pfrecuen
		vd[4] = Iif(mwkpresta.pdesde={//}, mfhoy, mwkpresta.pdesde)
		vd[5] = Iif(mwkpresta.phasta={//}, mfhoy, mwkpresta.phasta)
		vd[6] = mwkpresta.pcan
		vd[7] = mwkpresta.pobs

		mlidpre = 0

		If mltipo <> "A"
			Use In Select("mwkpres")
			mret = SQLExec(mcon1,"select * from TabCuiDomPres "+;
				" where TCP_idsolic = ?mlid and TCP_idprest = ?vd[1] and TCP_pasivado = ?mfhoy","mwkpres")

			If mret < 0
				MTABLA = "CUIDADOS DOMICILIARIOS CONSULTA PRESTACIONES"
				Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
				Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
				Return .F.
			Endif

			If Used("mwkpres")
				If Reccount("mwkpres")>0
					mlidpre = mwkpres.Id
				Endif
			Endif
		Endif

		If mlidpre = 0

			mret = SQLExec(mcon1,"insert into TabCuiDomPres "+;
				"(TCP_idsolic, TCP_idprest, TCP_otrapre, TCP_frecuencia, TCP_desde, "+;
				"TCP_hasta,  TCP_pasivado, TCP_usuario, TCP_cantidad, TCP_observa) "+;
				" values "+;
				"(?mlid, ?vd[1], ?vd[2], ?vd[3], ?vd[4], ?vd[5], ?mfnull, ?muser, ?vd[6], ?vd[7])")

		Else

			mret = SQLExec(mcon1,"update TabCuiDomPres set"+;
				" TCP_pasivado = ?mfnull,"+;
				" TCP_usuario  = ?muser, "+;
				" TCP_otrapre  = ?vd[2], "+;
				" TCP_cantidad = ?vd[6], "+;
				" TCP_observa  = ?vd[7], "+;
				" TCP_desde    = ?vd[4], "+;
				" TCP_hasta    = ?vd[5], "+;
				" TCP_frecuencia = ?vd[3] "+;
				" where ID = ?mlidpre")

* 				TCP_idsolic = ?mlid")

		Endif

		If mret < 0
			MTABLA = "CUIDADOS DOMICILIARIOS PRESTACIONES - REGISTRO"
			Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
			Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
			Return .F.
		Endif

	Endif

Endscan
Release vd
Use In Select("mwkpres")

*--------------------------------------------------------------------------------
* Cuidados Domiciliarios Indicaciones
* mwkindica
* TabCuiDomIndi
* ID Solicitud maestro
* TCI_idsolic
* mwkindica (ides c(50), idos c(50), ifre c(50), idesde D, ihasta D,
* 			iid N(6), iestado N(1))
*--------------------------------------------------------------------------------

Dimension vd[9]
Select mwkindica
Go Top
Scan All

	vd[1] = mwkindica.ides
	vd[2] = mwkindica.idos
	vd[3] = mwkindica.ifre
	vd[4] = Iif(mwkindica.idesde={//}, mfhoy, mwkindica.idesde)
	vd[5] = Iif(mwkindica.ihasta={//}, mfhoy, mwkindica.ihasta)
	vd[6] = mwkindica.iid        && ID - TabCuiDomIndi
	vd[7] = mwkindica.iestado    && 0 o 1 (Activo o Pasivado)
	vd[8] = mwkindica.icodinsu
	vd[9] =	mwkindica.icantidad

	If vd[6] > 0 &&mlidindi > 0

		If vd[7] = 0  && Update Full * "TCI_idsolic = ?mlid,"+;

			msql = "TCI_indicacion  = ?vd[1],"+;
				"TCI_dosis       = ?vd[2],"+;
				"TCI_frecuencia  = ?vd[3],"+;
				"TCI_desde       = ?vd[4],"+;
				"TCI_hasta       = ?vd[5],"+;
				"TCI_pasivado    = ?mfnull,"+;
				"TCI_codinsumo   = ?vd[8],"+;
				"TCI_cantidad    = ?vd[9],"+;
				"TCI_usuario     = ?muser"

		Else          && Pasiva

			msql = "TCI_pasivado = ?mfhoy,"+;
				"TCI_usuario  = ?muser"

		Endif

		mret = SQLExec(mcon1,"update TabCuiDomIndi set "+;
			msql + " where ID = ?vd[6]")

	Else

		If vd[7] = 0

			mret = SQLExec(mcon1,"insert into TabCuiDomIndi "+;
				"(TCI_idsolic, TCI_indicacion, TCI_dosis, TCI_frecuencia,"+;
				"TCI_desde, TCI_hasta, TCI_pasivado, TCI_usuario, TCI_codinsumo, TCI_cantidad) "+;
				" values "+;
				" (?mlid, ?vd[1], ?vd[2], ?vd[3], ?vd[4], ?vd[5], ?mfnull, ?muser, ?vd[8], ?vd[9])")

		Endif

	Endif

	If mret < 0
		mltabla = "ACTUALIZACION DEL MAESTRO DE INSUMOS"
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

Endscan
Release vd
Use In Select("mwkpindi")

*--------------------------------------------------------------------------------
* Cuidados Domiciliarios Equipamiento
* mwkequip
* TabCuiDomEqui
* mwkequip (esel N(1), etipo c(30), eotra c(30), eid N(1)
* ID Solicitud maestro
* TCE_idsolic
* ID Equipo
* TCE_ideqp
*--------------------------------------------------------------------------------

If mltipo <> "A"

	mret = SQLExec(mcon1,"update TabCuiDomEqui set"+;
		" TCE_pasivado = ?mfhoy,"+;
		" TCE_usuario  = ?muser "+;
		" where TCE_idsolic = ?mlid and TCE_pasivado = ?mfnull")

	If mret < 0
		MTABLA = "CUIDADOS DOMICILIARIOS EQUIPAMIENTO - INICILIZACION"
		Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

Endif

Dimension vd[2]
Select mwkequip
Go Top
Scan All

	If mwkequip.esel = 1

		vd[1] = mwkequip.eid
		vd[2] = mwkequip.eotra
		mlidEQP = 0

		If mltipo <> "A"
			Use In Select("mwkpEQP")
			mret = SQLExec(mcon1,"select * from TabCuiDomEqui "+;
				" where TCE_idsolic = ?mlid and TCE_ideqp = ?vd[1] and TCE_pasivado = ?mfhoy","mwkpEQP")

			If mret < 0
				MTABLA = "CUIDADOS DOMICILIARIOS CONSULTA EQUIPOS"
				Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
				Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
				Return .F.
			Endif

			If Used("mwkpEQP")
				If Reccount("mwkpEQP")>0
					mlidEQP = mwkpEQP.Id
				Endif
			Endif
		Endif

		If mlidEQP = 0

			mret = SQLExec(mcon1,"insert into TabCuiDomEqui "+;
				"(TCE_idsolic,TCE_ideqp,TCE_otroeqp,TCE_pasivado,TCE_usuario)" +;
				" values " +;
				"(?mlid, ?vd[1], ?vd[2], ?mfnull, ?muser)")

		Else

			mret = SQLExec(mcon1,"update TabCuiDomEqui set"+;
				" TCE_pasivado = ?mfnull,"+;
				" TCE_usuario  = ?muser, "+;
				" TCE_otroeqp  = ?vd[2]"+;
				" where ID = ?mlidEQP")

		Endif

		If mret < 0
			MTABLA = "CUIDADOS DOMICILIARIOS EQUIPAMIENTO - REGISTRO"
			Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
			Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
			Return .F.
		Endif

	Endif

Endscan
Release vd
Use In Select("mwkpEQP")

Return .T.



*!*	mlidindi = 0
*!*		If vd[6] > 0
*!*			Use In Select("mwkpindi")
*!*			mret = SQLExec(mcon1,"select * from TabCuiDomIndi where ID = ?vd[6]","mwkpindi")
*!*			If mret < 0
*!*				MTABLA = "INCICACIONES"
*!*				Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
*!*				Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
*!*				Return .F.
*!*			Endif
*!*			If Used("mwkpindi")
*!*				If Reccount("mwkpindi") > 0
*!*					mlidindi = mwkpindi.Id
*!*				Endif
*!*			Endif
*!*		Endif


*"              where TCE_idsolic = ?mlid")


*!*						" and TCS_nroafi = ?TCS_nroafi"+;
*!*						" and TCS_nroregistrac = ?vd[02]"+;
*!*						" and TCS_estado = 1"
