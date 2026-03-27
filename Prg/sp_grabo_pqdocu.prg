** Debe llegar el cursor mwkmldocu
** Parametro mNroAtencion = es el nro. de atencion que se obtiene cuando se ingresa un nuevo registro en
** la tabla TabMlCita.

Lparameters mNroAtencion,mAbm

**id,PQA_codatenc as codatenc,PQA_fecha as fechalog,PQA_nombredocu as documentobase,PQA_tipoarch as tipoarch,;
**       Cast(Cast(PQA_documento as W) as M) as MiImagen,PQA_observacion as informesolotexto, ' ' as sit ;
**	   From mwkmlDocu ;
**	   Into Cursor mwkmlDocu

mAtencion = mNroAtencion
mPasiva = "1900-01-01"
mret = 1
If mAbm = 1  &&nueva atencion

	Select mwkmldocu
	Scan All

&&grabamos todos
		mSit = sit
		DO case
		CASE mSit = "B"  &&borramos

			mID = Id
			mPasiva = sp_busco_fecha_serv('DD')
			mret = SQLExec(mcon1,"update TabPQadjunto set PQA_fechapas = ?mPasiva where id = ?mId")

*!*			Else
		CASE mSit = "N"

			mFecha = fechalog
			mNombreDocu = Alltrim(documentobase)
			mTipoArch  = tipoarch
	*		mImagen = MiImagen
			mObserva = Alltrim(informesolotexto)

			mret = SQLExec(mcon1,"insert into TabPQadjunto (PQA_referencia,PQA_fecha,PQA_fechapas,PQA_nombredocu,PQA_tipoarch,PQA_documento,PQA_observacion) values (" + ;
				"?mAtencion,?mFecha,?mPasiva,?mNombreDocu,?mTipoArch,?mwkmldocu.MiImagen,?mObserva)" )
		Endcase



		If mret<=0
			Messagebox("ERROR EN LA ESCRITURA TABLA TabPQadjunto",26,"ERROR")
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
*		mImagen = MiImagen
		mObserva = Alltrim(informesolotexto)

		Do Case
		Case mwkmldocu.sit = "N"  &&damos de alta

			mret = SQLExec(mcon1,"insert into TabPQadjunto (PQA_referencia,PQA_fecha,PQA_fechapas,PQA_nombredocu,PQA_tipoarch,PQA_documento,PQA_observacion) values (" + ;
				"?mAtencion,?mFecha,?mPasiva,?mNombreDocu,?mTipoArch,?mwkmldocu.MiImagen,?mObserva)" )

			If mret<=0
				Messagebox("ERROR EN LA ESCRITURA TABLA TabPQadjunto",26,"ERROR")
				Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Exit
			Endif

		Case mwkmldocu.sit = "B"  &&borramos

			mID = mwkmldocu.Id

**mret = SQLExec(mcon1,"delete from TabPQadjunto where id = ?mId")

			mPasiva = sp_busco_fecha_serv('DD')
			mret = SQLExec(mcon1,"update TabPQadjunto set PQA_fechapas = ?mPasiva where id = ?mId")

			If mret<=0
				Messagebox("ERROR AL INTENTAR BORRAR REGISTRO TABLA TabPQadjunto",26,"ERROR")
				Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Exit
			Endif

		Case mwkmldocu.sit = "M"  &&modificacion

			mID = mwkmldocu.Id
			mret = SQLExec(mcon1,"update TabPQadjunto set " + ;
				"PQA_fecha = ?mFecha," + ;
				"PQA_nombredocu = ?mNombreDocu," + ;
				"PQA_documento = ?mImagen," + ;
				"PQA_observacion = ?mObserva " + ;
				"where id = ?mId")


			If mret<=0
				Messagebox("ERROR AL INTENTAR MODIFICAR REGISTRO TABLA TabPQadjunto",26,"ERROR")
				Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Exit
			Endif

		Endcase

	Endscan



Endif

