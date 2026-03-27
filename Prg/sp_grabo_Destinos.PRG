*
**grabamos en tabla los destinos ingresados.
**El formulario debe tener la propiedad lOpcion, para indicar si viene haciendo nuevo o modificando.
*
Lparameters mFormulario

Local mEntidad, mNombre, mMail

** cmbentidad
** txtnombre
** txtmail
** TCD_destino, TCD_email, TCD_fechapasiva, TCD_identidad, TCD_idusuario

muser = mwkusuario.idusuario
mfHoy = sp_busco_fecha_serv('DD')

With mFormulario

	mEntidad = mwkentidad.ENT_codent
	mNombre  = .txtnombre.Value
	mMail    = .txtmail.Value

	Do Case

	Case .lOpcion == 1 && Alta

		mret = SQLExec(mcon1,"insert into TabCensosDestinos "+;
			" (TCD_destino, TCD_email, TCD_identidad, TCD_idusuario,TCD_fecmov) "+;
			" values(?mNombre, ?mMail, ?mEntidad, ?muser, ?mfHoy)" )

	Case .lOpcion == 2 && Modificación

		mlid = mwkcensosdestinos.lid

		mret = SQLExec(mcon1,"update TabCensosDestinos set "+;
			"TCD_destino    = ?mNombre,"+;
			"TCD_email      = ?mMail,"+;
			"TCD_identidad  = ?mEntidad,"+;
			"TCD_idusuario  = ?muser,"+;
			"TCD_fecmov     = ?mfHoy"+;
			" where id = ?mlid")

	Case .lOpcion = 3 Or .lOpcion = 4 && Pasivación / Recupera

		mlid   = mwkcensosdestinos.lid
		mfnull = Iif(.lOpcion = 3, mfHoy, Ctod("01/01/1900"))

		mret = SQLExec(mcon1,"update TabCensosDestinos set "+;
			"TCD_idusuario   = ?muser,"+;
			"TCD_fechapasiva = ?mfnull,"+;
			"TCD_fecmov      = ?mfHoy "+;
			" where id = ?mlid")

	Endcase

	If mret < 0
		MTABLA = "CENSOS DESTINOS"
		Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

Endwith

Return .T.

