*
* Cuidados Domiciliarios Preparar Evolución WEB / MySQL
*
Lparameters mlidsol, mlidpro

mlidsweb = 0
mlidpweb = 0
*			mlidsol  = mlidsol && mwkcuidom.lid
*			mlidpro  = mlidpro && mwkProAsig.lprofid

*----------- Busco Evolucion ----------------------------------------------------------------------------------*

Use In Select("mwkctrl1")
mret = SQLExec(mconM,"select id as lid from tbl_evolucion where idsolicitud = ?mlidsol","mwkctrl1")
If mret < 0
	MTABLA = "CUIDADOS DOMICILIARIOS EVOLUCION WEB"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA " + MTABLA + Chr(10) + "AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

If Used("mwkctrl1")
	If Reccount("mwkctrl1") > 0
		mlidsweb = mwkctrl1.lid  && ID solicitud
	Endif
Endif
Use In Select("mwkctrl1")

*------------ Busco Profesional -------------------------------------------------------------------------------*

Use In Select("mwkctrl2")
mret = SQLExec(mconM,"select id as lid from tbl_profesion where idprofe = ?mlidpro","mwkctrl2")
If mret < 0
	MTABLA = "CUIDADOS DOMICILIARIOS PROFESIONALES WEB"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA " + MTABLA + Chr(10) + "AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

If Used("mwkctrl2")
	If Reccount("mwkctrl2") > 0
		mlidpweb = mwkctrl2.lid && ID profesional
	Endif
Endif
Use In Select("mwkctrl2")

*--------------------------------------------------------------------------------------------------------------*

muser = mwkusuario.idusuario
mfhoy = Ttoc(sp_busco_fecha_serv('DT'))

*------------ Carga solicitud ---------------------------------------------------------------------------------*

If mlidsweb = 0 && Para hacer insert en solicitudes (nueva solicitud en )

	Dimension vdat[10]

	vdat[01] = mlidsol && mlidsweb
	vdat[02] = Alltrim(mwkcuidom.TCS_patologia)
	vdat[03] = Alltrim(mwkcuidom.TCS_resumenhc)
	vdat[04] = mwkcuidom.REG_nombrepac
	vdat[05] = mwkcuidom.TCS_direccion
	vdat[06] = mwkcuidom.TCS_localidad
	vdat[07] = mwkcuidom.TCS_telpar
	vdat[08] = 1
	vdat[09] = 'N'
	vdat[10] = 'Indicaciones, Prestaciones, Equipos'

	If !sp_busco_cuidom(,,,mlidsol)
		Return
	Endif

	msg1 = ""
	msg2 = ""

	Select mwkcuidomInd && TabCuiDomIndi
	Go Top
	Scan All
		msg2 = msg2 + mwkcuidomInd.TCI_indicacion + Chr(10) +;
			mwkcuidomInd.TCI_dosis + Chr(10) +;
			mwkcuidomInd.TCI_frecuencia + Chr(10) +;
			"Desde: "+Dtoc(mwkcuidomInd.TCI_desde)+" Hasta: "+Dtoc(mwkcuidomInd.TCI_hasta) +;
			Chr(10) + Chr(10)
	Endscan

	If !Empty(msg2)
		msg1 = "INDICACIONES"+Chr(10)+msg2
	Endif

	Use In Select("mwkcuidomInd")

	msg3 = ""
	msg4 = ""

*!* TabCuiDomPres

	Select mwkestpre.Descrip As lpres,TCP_otrapre, TCP_frecuencia, TCP_desde, TCP_hasta;
		FROM mwkcuidomPre ;
		JOIN mwkestpre On mwkestpre.subestado = mwkcuidomPre.TCP_idprest;
		INTO Cursor mwkcuidomPre

	Select mwkcuidomPre
	Go Top
	Scan All
		msg4 = msg4 + lpres + ' ' + TCP_otrapre + Chr(10)+;
			TCP_frecuencia + Chr(10) +;
			"Desde: "+Dtoc(TCP_desde) + " Hasta: "+Dtoc(TCP_hasta)+;
			Chr(10) + Chr(10)
	Endscan

	If !Empty(msg4)
		msg3 = "PRESTACIONES"+Chr(10)+msg4
	Endif

	Use In Select("mwkestpre")
	Use In Select("mwkcuidomPre")

	msg5 = ""
	msg6 = ""

	Select mwkesteqp.Descrip As lpres,TCE_otroeqp;
		FROM mwkcuidomEqp ;
		JOIN mwkesteqp On mwkesteqp.subestado = mwkcuidomEqp.TCE_ideqp;
		INTO Cursor mwkcuidomEqp

	Select mwkcuidomEqp && TabCuiDomEqui
	Go Top
	Scan All
		msg6 = msg6 + lpres + ' ' + TCE_otroeqp + ;
			Chr(10) + Chr(10)
	Endscan

	If !Empty(msg6)
		msg5 = "EQUIPOS"+Chr(10)+msg6
	Endif

	Use In Select("mwkesteqp")
	Use In Select("mwkcuidomEqp")

	vdat[10] = msg1 + msg3 + msg5

	mret = SQLExec(mconM,"insert into tbl_evolucion"+;
		"(idsolicitud,patologia,resumenhc,paciente,direccion,"+;
		"localidad,telefono,estado,actualizaweb,preindeqp,observa,"+;
		"user,fecmov)"+;
		" values "+;
		"(?vdat[1], ?vdat[2], ?vdat[3], ?vdat[4], ?vdat[5], ?vdat[6], ?vdat[7],"+;
		"?vdat[8], ?vdat[9], ?vdat[10], '', ?muser, ?mfhoy)")

	If mret < 0
		MTABLA = "CUIDADOS DOMICILIARIOS CARGA DE SOLICITUD WEB"
		Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA " + MTABLA + Chr(10) + "AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

	Release vdat

	Use In Select("mwkctrl3")
	mret = SQLExec(mconM,"select id as lid from tbl_evolucion"+;
		" where user = ?muser "+;
		" and fecmov = ?mfhoy","mwkctrl3") && Busco ID de la evolucion cargada

	If mret < 0
		MTABLA = "CUIDADOS DOMICILIARIOS EVOLUCION WEB"
		Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA " + MTABLA + Chr(10) + "AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

	If Used("mwkctrl3")
		If Reccount("mwkctrl3") > 0
			mlidevol = mwkctrl3.lid && ID de la evolucion cargada
		Endif
		Use In Select("mwkctrl3")
	Endif

Else
	mlidevol = mlidsweb
	Messagebox("LA SOLICITUD SE ENCUENTRA CARGADA CON ANTERIORIDAD",48,"ATENCION")
Endif

*--------------------------------------------------------------------------------------------------------------*

Use In Select("mwkctrl4")
mret = SQLExec(mconM,"select id as lid"+;
	" from tbl_reproevol"+;
	" where idprofesion = ?mlidpweb" +;
	" and idEvolucion = ?mlidevol","mwkctrl4")

If mret < 0
	MTABLA = "CUIDADOS DOMICILIARIOS RELACIONES WEB"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA " + MTABLA + Chr(10) + "AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

If Used("mwkctrl4")
	If Reccount("mwkctrl4") = 0

		mret = SQLExec(mconM,"insert into tbl_reproevol"+;
			" (idprofesion, idevolucion, user, fecmov)"+;
			" values "+;
			" (?mlidpweb, ?mlidevol, ?muser, ?mfhoy)")
	Else

		mlidrel = mwkctrl4.lid
		mret = SQLExec(mconM,"update tbl_reproevol"+;
			" set idprofesion = ?mlidpweb,"+;
			" idevolucion = ?mlidevol, "+;
			" user   = ?muser, "+;
			" fecmov = ?mfhoy "+;
			" where id = ?mlidrel ")
	Endif
	Use In Select("mwkctrl4")
	If mret < 0
		MTABLA = "CUIDADOS DOMICILIARIOS ACTUALIZACION RELACIONES WEB"
		Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA " + MTABLA + Chr(10) + "AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif
Endif

Return .T.
