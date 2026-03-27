*
* Eliminacion de relacion web entre profesional y evolucion web
*
Lparameters mlid, mprofid, mltipo, mest

If Vartype(mltipo) <> "C"
	mltipo = "REL" && Relaciones entre Evolucion y Profesional // REL - EVL
Endif

If Vartype(mest) <> "N"
	mest = 1 && Estado Activo
Endif

If mltipo = "REL"
	mprofidb = 0
	mlidb    = 0
	Use In Select("mwkctrl5")
	mret = SQLExec(mconM,"select id as lid"+;
		" from tbl_evolucion"+;
		" where idsolicitud = ?mlid and estado = 1","mwkctrl5")
	If mret > 0
		If Used("mwkctrl5")
			If Reccount("mwkctrl5")>0
				mlidb = mwkctrl5.lid
			Endif
		Endif
	Endif
	Use In Select("mwkctrl5")
	If mret > 0
		If mlidb > 0
			mret = SQLExec(mconM,"select id as lid"+;
				" from tbl_profesion"+;
				" where idprofe = ?mprofid and estado = 'A'","mwkctrl5")
			If mret > 0
				If Used("mwkctrl5")
					If Reccount("mwkctrl5")>0
						mprofidb = mwkctrl5.lid
					Endif
				Endif
				If mprofidb > 0
					mret = SQLExec(mconM,"delete from tbl_reproevol"+;
						" where idprofesion = ?mprofidb and idevolucion = ?mlidb")
				Endif
			Endif
			Use In Select("mwkctrl5")
		Endif
	Endif
	If mret < 0
		MTABLA = "CUIDADOS DOMICILIARIOS BAJA DE RELACION PROFESIONAL Y PACIENTE WEB"
		Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Else
		Messagebox("SE ACTUALIZO EL ESTADO DE LA SOLICITUD WEB"+Chr(10)+;
			"Y PROFESIONALES ASIGNADOS",48,"ATENCION")
	Endif

Else && EVL

	muser   = mwkusuario.idusuario
	mfechoy = Ttoc(sp_busco_fecha_serv('DT'))

	mret = SQLExec(mconM,"update tbl_evolucion set "+;
		" estado = ?mest,"+;
		" user = ?muser,"+;
		" fecmov = ?mfechoy"+;
		" where idsolicitud = ?mlid")

	If mret < 0
		MTABLA = "CUIDADOS DOMICILIARIOS BAJA DE EVOLUCION PACIENTE WEB"
		Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Else
		Messagebox("SE ACTUALIZO EL ESTADO DE LA SOLICITUD WEB",48,"ATENCION")
	Endif

Endif

Return .T.
