*!*	 
*!*	Alta, Modificacion, Baja de Puestos
*!*	----------------------------------------------------------------------------------
LParameter mpuesto, mobser, mubic, mid, mabm, mmaquina, mrack, mppuesto, mpachera, midsector2, ;
	mimagen, mnombre, mmodelo, mnroserie, rutaimagen, msolicenc, minterno, lmaqorg, mConsult, mIdStCaja, mMsOffice, mOoffice, mLicOffi, mCboEstado

Local lnId
lnId = 0
Local mRet
mRet = 0
*!*	----------------------------------------------------------------------------
*!*	VALIDACIONES
*!*	----------------------------------------------------------------------------
If mabm = 1 Or (mabm = 2 And lmaqorg <> mmaquina) && Alta / Modifica

	mpasoa = .F.
	If Used('mwkctrlmaq')
		Use In mwkctrlmaq
	Endif

	If !Empty(mmaquina)

		mret =	SQLExec(mcon1,"select puesto from tabStPuesto"+;
			" where maquina =?mmaquina","mwkctrlmaq")
		
		If mret < 0
			Messagebox("AL CONTROLAR EXISTENCIA DE MAQUINA" + Chr(10) + "AVISE A SISTEMAS",16,"ERROR")
			mpasoa = .T.
		Endif

		If Used('mwkctrlmaq')
			If Reccount('mwkctrlmaq')>0
				Messagebox("IDENTIFICADOR DE MAQUINA [ID] SE ENCUENTRA REGISTRADO"+Chr(10)+;
					"INTENTE CON OTRO",48,"Validación")
				mpasoa = .T.
			Endif
			Use In mwkctrlmaq
		Endif
		
		If mpasoa
			valor = .F.
			Return
		Endif
	Else
		&& VACIO
	Endif 	
Endif

If Vartype(midsector2) = 'C'
	midsector = Val(midsector2)
Else
	midsector = midsector2
Endif

Dimension cf(100)
Store '' To cf
mfechatope = sp_busco_fecha_serv('DD')

*!*	----------------------------------------------------------------------------
*!*	IMAGEN
*!*	----------------------------------------------------------------------------

If !Empty(rutaimagen)

	If File("C:\temp\imagenes\imagen.dbf")
		Erase ("C:\temp\imagenes\imagen.dbf")
	Endif
	If File("C:\temp\imagenes\imagen.fpt")
		Erase ("C:\temp\imagenes\imagen.fpt")
	Endif

	Select 0
	Create Table "C:\temp\imagenes\imagen.dbf" Free (foto m)
	
	Select imagen
	Append Blank
	miimagen = ''
	
	Do prg_loadbin With rutaimagen, miimagen
	If !Empty(miimagen )

		Replace foto With miimagen
		Use
		ll = Fopen("C:\temp\imagenes\imagen.dbf",12)
		Fseek(ll,43)
		Fwrite(ll,'G')
		Fclose(ll)

		If Used('imagen')
			Use In imagen
		Endif

		If Used('__data')
			Use In __data
		Endif

		Use c:\temp\imagenes\imagen.Dbf Alias __data
	Else
		Create Cursor __data (foto m)
	Endif
Else
	Create Cursor __data (foto m)
Endif
*!*	------------------------------------------------------------------------------------------

Do Case
	Case mabm = 1

		If Used('mwkValidPuesto')
			Select mwkvalidpuesto
			Use
		Endif

		If Used('mwkValidPuesto2')
			Select mwkvalidpuesto2
			Use
		Endif
*!*	-------------------------------------------------
*!*	CONTROL
*!*	-------------------------------------------------
		If !Empty(mMaquina)
			If mpuesto <> "172.16.999.999" And mmaquina <> 'I'

				mret =	SQLExec(mcon1,"select puesto from tabStPuesto where puesto = ?mPuesto "+;
					"or maquina =?mmaquina","mwkValidPuesto")

				If Reccount('mwkValidPuesto') > 0
					Messagebox("MAQUINA/IP EXISTENTE",48,"Validación")
					valor = .F.
					Return
				Endif

			Endif
		Else
			mret =	SQLExec(mcon1,"select puesto from tabStPuesto where puesto = ?mPuesto ","mwkValidPuesto")

			If Reccount('mwkValidPuesto') > 0
				Messagebox("IP EXISTENTE",48,"Validación")
				valor = .F.
				Return
			Endif
		Endif 

*!*	----------------------------------------------------------------------------
*!*	NUEVO 
*!*	----------------------------------------------------------------------------
		If mimagen <> '' 

			mret =	SQLExec(mcon1,"insert into tabStPuesto " + ;
				"(Puesto, Observaciones, Ubicacion, " + ;
				"maquina, rack, ppuesto, pachera, idsector, " + ;
				"imagen2, nombre, idmodelo, nroserie, " + ;
				"solicencia, interno, NroConsultorio, IdStCaja, Moffice, Ooffice, Officelicencia,Estado) " +;
				" values " + ;
				"(?mpuesto, ?mobser, ?mubic, " + ;
				"?mmaquina, ?mrack, ?mppuesto, ?mpachera, ?midsector, " + ;
				"?__data.foto, ?mnombre, ?mmodelo, ?mnroserie, " + ;
				"?msolicenc, ?minterno, ?mConsult, ?mIdStCaja, ?mMsOffice, ?mOoffice, ?mLicOffi, ?mCboEstado)")
		Else
			mret =	SQLExec(mcon1,"insert into tabStPuesto " + ;
				"(Puesto, Observaciones, Ubicacion, " + ;
				"maquina, rack, ppuesto, pachera, idsector, " + ;
				"nombre, idmodelo, nroserie, " + ;
				"solicencia, interno, NroConsultorio, IdStCaja, Moffice, Ooffice, Officelicencia, Estado) " +;
				" values " + ;
				"(?mpuesto, ?mobser, ?mubic, " + ;
				"?mmaquina, ?mrack, ?mppuesto, ?mpachera, ?midsector, " + ;
				"?mnombre, ?mmodelo, ?mnroserie, " + ;
				"?msolicenc, ?minterno, ?mConsult, ?mIdStCaja, ?mMsOffice, ?mOoffice, ?mLicOffi, ?mCboEstado)")
		Endif 
*!*		 
	
		If mRet <= 0
			Messagebox("ERROR AL INGRESAR UN PUESTO ",16,"ERROR")
			Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
			Return .F.
		Endif 	
*!*	----------------------------------------------------------------------------


		&& AGREGADOS PEDIDO POR MATIAS
		If Empty(mMaquina)	

			mret =	SQLExec(mcon1,"select Id from tabStPuesto where puesto = ?mPuesto Order by Id desc ","mwkValidPuesto")
		
			If mRet <= 0
				Messagebox("ERROR DE LECTURA ",16,"ERROR")
				Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
				Return .F.
			Endif 
			
			mMaquina = "Z" + Transform(mwkValidPuesto.Id)
			lnId = mwkValidPuesto.Id
			Use in Select("mwkValidPuesto")
	
			mret = SQLExec(mcon1,"update tabStPuesto set maquina = ?mMaquina where id = ?lnId ")			

			If mRet <= 0
				Messagebox("ERROR AL ACTUALIZAR MAQUINA ",16,"ERROR")
				Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
				Return .F.
			Endif 
		Endif 
*!*	------------------------------------------------------------------------------------------
	
	Case mabm = 2
		If Used('mwkValidPuesto')
			Select mwkvalidpuesto
			Use
		Endif

		If mpuesto <> "172.16.999.999"

			mret =	SQLExec(mcon1,"select puesto from tabStPuesto where puesto = ?mPuesto "+;
				"or maquina =?mmaquina","mwkValidPuesto")
			If Reccount('mwkValidPuesto') > 1
				Messagebox("MAQUINA/IP EXISTENTE",48,"Validación")
				valor = .F.
				Return .F.
			Endif

		Endif

		If Used('mwkValidPuesto2')
			Select mwkvalidpuesto2
			Use
		Endif

*!*			If mimagen <> ''
*!*				mret = SQLExec(mcon1,"update tabStPuesto set Puesto = ?mPuesto,Observaciones = ?mObser,"+;
*!*					"ubicacion = ?mubic, maquina = ?mmaquina, rack = ?mrack,ppuesto = ?mppuesto,"+;
*!*					"pachera  = ?mpachera,nombre = ?mnombre, idsector = ?midsector,imagen2 = ?__data.foto,"+;
*!*					"idmodelo = ?mmodelo,nroserie =?mnroserie, solicencia=?msolicenc, " + ;
*!*					"interno=?minterno, NroConsultorio = ?mConsult, IdStCaja = ?mIdStCaja where id = ?mid ")
*!*			Else
*!*				mret = SQLExec(mcon1,"update tabStPuesto set Puesto = ?mPuesto,Observaciones = ?mObser,"+;
*!*					"ubicacion = ?mubic, maquina = ?mmaquina, rack = ?mrack,ppuesto = ?mppuesto,"+;
*!*					"pachera  = ?mpachera,nombre = ?mnombre, idsector = ?midsector,"+;
*!*					"idmodelo = ?mmodelo,nroserie =?mnroserie, solicencia=?msolicenc, " + ;
*!*					"interno=?minterno, NroConsultorio = ?mConsult, IdStCaja = ?mIdStCaja where id = ?mid ")
*!*			Endif




		If mimagen <> ''
			mret = SQLExec(mcon1,"update tabStPuesto set Puesto = ?mPuesto,Observaciones = ?mObser,"+;
				"ubicacion = ?mubic, maquina = ?mmaquina, "+;
				"nombre = ?mnombre, idsector = ?midsector,imagen2 = ?__data.foto,"+;
				"idmodelo = ?mmodelo,nroserie =?mnroserie, solicencia=?msolicenc, " + ;
				"interno=?minterno, NroConsultorio = ?mConsult, IdStCaja = ?mIdStCaja, Moffice = ?mMsOffice, Ooffice =  ?mOoffice, Officelicencia =  ?mLicOffi, Estado = ?mCboEstado where id = ?mid ")
		Else
			mret = SQLExec(mcon1,"update tabStPuesto set Puesto = ?mPuesto,Observaciones = ?mObser,"+;
				"ubicacion = ?mubic, maquina = ?mmaquina, "+;
				"nombre = ?mnombre, idsector = ?midsector,"+;
				"idmodelo = ?mmodelo,nroserie =?mnroserie, solicencia=?msolicenc, " + ;
				"interno=?minterno, NroConsultorio = ?mConsult, IdStCaja = ?mIdStCaja, Moffice = ?mMsOffice, Ooffice =  ?mOoffice, Officelicencia =  ?mLicOffi, Estado = ?mCboEstado where id = ?mid ")
		Endif
*!*	------------------------------------------------------------------------------------------

	Case mabm = 3
		If Used('mwkValidDetPuesto')
			Select mwkvaliddetpuesto
			Use
		Endif
		mpaso = .T.
		mret = SQLExec(mcon1,"select * from tabStDetPuesto where idPuesto = ?mid","mwkValidDetPuesto")
		If mret > 0
			If Used('mwkValidDetPuesto')
				If Reccount('mwkValidDetPuesto') > 0
					meli = 0
					meli = Messagebox("HAY COMPONENTES ASOCIADOS AL PUESTO DE TRABAJO"+Chr(10)+;
						"elimina el puesto de todas formas ?",4+48,"VALIDACION")
					If meli = 7
						mpaso = .F.
						valor = .F.
						Return
					Endif
				Endif
			Endif
		Else
			Messagebox("EN LA BUSQUEDA DE COMPONENTES DEL PUESTO",16,"ERROR")
			mpaso = .F.
		Endif
		If mpaso
			mret = SQLExec(mcon1,"delete from tabStPuesto where id = ?mid ")
		Endif
Endcase

*!*	------------------------------------------------------------------------------------------

If mret<1
	=Aerr(eros)
	Messagebox(eros(2))
Endif

If Used('__DATA')
	Use In __data
Endif
