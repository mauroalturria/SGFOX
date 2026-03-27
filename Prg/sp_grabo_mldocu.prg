** Debe llegar el cursor mwkmldocu
** Parametro mNroAtencion = es el nro. de atencion que se obtiene cuando se ingresa un nuevo registro en
** la tabla TabMlCita.

Lparameters mNroAtencion,mAbm

**id,md_codatenc as codatenc,md_fecha as fechalog,md_nombredocu as documentobase,md_tipoarch as tipoarch,;
**       Cast(Cast(MD_documento as W) as M) as MiImagen,md_observacion as informesolotexto, ' ' as sit ;
**	   From mwkmlDocu ;
**	   Into Cursor mwkmlDocu

mAtencion = mNroAtencion
mPasiva = "1900-01-01"

If mAbm = 1  &&nueva atencion

	Select mwkmldocu
	Scan All

&&grabamos todos
		mSit = sit

*!*			If mSit = "B"  &&borramos

*!*				mID = Id
*!*				mPasiva = sp_busco_fecha_serv('DD')
*!*				mret = SQLExec(mcon1,"update tabmldocu set md_fechapas with ?mPasiva where id = ?mId")

*!*			Else
		If mSit = "N"

			mFecha = fechalog
			mNombreDocu = Alltrim(documentobase)
			mTipoArch  = tipoarch
			**mImagen = MiImagen
			mObserva = Alltrim(informesolotexto)

			mret = SQLExec(mcon1,"insert into tabmldocu (md_codatenc,md_fecha,md_fechapas,md_nombredocu,md_tipoarch,md_documento,md_observacion) values (" + ;
				"?mAtencion,?mFecha,?mPasiva,?mNombreDocu,?mTipoArch,?mwkmldocu.MiImagen,?mObserva)" )
		Endif



		If mret<=0
			Messagebox("ERROR EN LA ESCRITURA TABLA TABMLDOCU",26,"ERROR")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Exit
		Endif

	Endscan

Else   &&edicion

	Select mwkmldocu
	Scan All


&&grabamos todos
		mPasiva = "1900-01-01"
		mFecha = fechalog
		mNombreDocu = Alltrim(documentobase)
		mTipoArch  = tipoarch
		mImagen = MiImagen
		mObserva = Alltrim(informesolotexto)

		Do Case
		Case mwkmldocu.sit = "N"  &&damos de alta

			mret = SQLExec(mcon1,"insert into tabmldocu (md_codatenc,md_fecha,md_fechapas,md_nombredocu,md_tipoarch,md_documento,md_observacion) values (" + ;
				"?mAtencion,?mFecha,?mPasiva,?mNombreDocu,?mTipoArch,?mwkmldocu.MiImagen,?mObserva)" )

			If mret<=0
				Messagebox("ERROR EN LA ESCRITURA TABLA TABMLDOCU",26,"ERROR")
				Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Exit
			Endif

		Case mwkmldocu.sit = "B"  &&borramos

			mID = mwkmldocu.Id

**mret = SQLExec(mcon1,"delete from tabmldocu where id = ?mId")

			mPasiva = sp_busco_fecha_serv('DD')
			mret = SQLExec(mcon1,"update tabmldocu set md_fechapas = ?mPasiva where id = ?mId")

			If mret<=0
				Messagebox("ERROR AL INTENTAR BORRAR REGISTRO TABLA TABMLDOCU",26,"ERROR")
				Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Exit
			Endif

		Case mwkmldocu.sit = "M"  &&modificacion

			mID = mwkmldocu.Id

			mret = SQLExec(mcon1,"update tabmldocu set " + ;
				"md_fecha = ?mFecha," + ;
				"md_nombredocu = ?mNombreDocu," + ;
				"md_documento = ?mImagen," + ;
				"md_observacion = ?mObserva " + ;
				"where id = ?mId")


			If mret<=0
				Messagebox("ERROR AL INTENTAR MODIFICAR REGISTRO TABLA TABMLDOCU",26,"ERROR")
				Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Exit
			Endif

		Endcase

	Endscan



Endif

