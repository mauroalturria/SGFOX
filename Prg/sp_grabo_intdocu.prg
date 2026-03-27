** Debe llegar el cursor mwkmldocu
Lparameters midevol,mAbm

mPasiva = "1900-01-01"
mret = 1
If mAbm = 1  &&nueva idevol

	Select mwkmldocu
	Scan All

&&grabamos todos
		mSit = sit
		DO case
		CASE mSit = "B"  &&borramos

			mID = Id
			mPasiva = sp_busco_fecha_serv('DD')
			mret = SQLExec(mcon1,"update ZabIntadjunto set IDA_fechapas = ?mPasiva where id = ?mId")

*!*			Else
		CASE mSit = "N"

			mFecha = fechalog
			mNombreDocu = Alltrim(documentobase)
			mTipoArch  = tipoarch
	*		mImagen = MiImagen
			mObserva = Alltrim(informesolotexto)

			mret = SQLExec(mcon1,"insert into ZabIntadjunto (IDA_idevol,IDA_fecha,IDA_fechapas,IDA_nombredocu,IDA_tipoarch,IDA_documento,IDA_observacion) values (" + ;
				"?midevol,?mFecha,?mPasiva,?mNombreDocu,?mTipoArch,?mwkmldocu.MiImagen,?mObserva)" )
		Endcase



		If mret<=0
			Messagebox("ERROR EN LA ESCRITURA TABLA ZabIntadjunto",26,"ERROR")
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

			mret = SQLExec(mcon1,"insert into ZabIntadjunto (IDA_idevol,IDA_fecha,IDA_fechapas,IDA_nombredocu,IDA_tipoarch,IDA_documento,IDA_observacion) values (" + ;
				"?midevol,?mFecha,?mPasiva,?mNombreDocu,?mTipoArch,?mwkmldocu.MiImagen,?mObserva)" )

			If mret<=0
				Messagebox("ERROR EN LA ESCRITURA TABLA ZabIntadjunto",26,"ERROR")
				Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Exit
			Endif

		Case mwkmldocu.sit = "B"  &&borramos

			mID = mwkmldocu.Id

**mret = SQLExec(mcon1,"delete from ZabIntadjunto where id = ?mId")

			mPasiva = sp_busco_fecha_serv('DD')
			mret = SQLExec(mcon1,"update ZabIntadjunto set IDA_fechapas = ?mPasiva where id = ?mId")

			If mret<=0
				Messagebox("ERROR AL INTENTAR BORRAR REGISTRO TABLA ZabIntadjunto",26,"ERROR")
				Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Exit
			Endif

		Case mwkmldocu.sit = "M"  &&modificacion

			mID = mwkmldocu.Id
			mret = SQLExec(mcon1,"update ZabIntadjunto set " + ;
				"IDA_fecha = ?mFecha," + ;
				"IDA_nombredocu = ?mNombreDocu," + ;
				"IDA_documento = ?mImagen," + ;
				"IDA_observacion = ?mObserva " + ;
				"where id = ?mId")


			If mret<=0
				Messagebox("ERROR AL INTENTAR MODIFICAR REGISTRO TABLA ZabIntadjunto",26,"ERROR")
				Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Exit
			Endif

		Endcase

	Endscan



Endif

