****
**  Busco los datos anexos del paciente
****

Parameter mnroregistra, motivo, mbsolotel,lsinimagen
lcError = On("ERROR")

If Vartype(mbsolotel) = "U"
	mbsolotel = .F.
Endif
If Vartype(lsinimagen) # "N"
	lsinimagen = 0
Endif

If Vartype(lnoverimagen) # "N"
	lnoverimagen = 0
Endif
If Vartype(motivo) # "N"
	motivo = 1
Endif
If !Used("mwktipotel")
	mret = SQLExec(mcon1,"SELECT ID, TT_categoria, TT_descrTipo FROM Zabtipotel " + ;
		" where TT_fecpasiva ='1900-01-01' ", "mwktipotel")
Endif

If Used("mwkregtel0")
	Use In mwkregtel0
Endif
Use In Select('mwkregtel00')
Use In Select('mwkregtel01')

If !mbsolotel
	If Used("mwkregdoc0")
		Use In mwkregdoc0
	Endif
Endif

mfecpas = Ctod("01/01/1900")


If !mbsolotel
	mret = SQLExec(mcon1,"select *   " + ;
		" from TabRegDatos " + ;
		" where TRDA_Registracio  =?mnroregistra " , "mwkregdatos")

	mret = SQLExec(mcon1,"select REG_medicocabecera " + ;
		"from Registracio " + ;
		"where REG_nroregistrac = ?mnroregistra " , "mwkregmedcab")

Endif
mret = SQLExec(mcon1,"select reg_telefonos,reg_tipodocumento,reg_numdocumento from Registracio where Registracio = ?mnroregistra ","mwknewtel")
mitel = Nvl(mwknewtel.reg_telefonos,'')

midoc 	= mwknewtel.reg_numdocumento
mitd 	= Val(Transform(mwknewtel.reg_tipodocumento))

If !Used('mwkdocu') && TENDRIA QUE ESTAR
	mret = SQLExec(mcon1,"select abrevio, descrip, codigovax, id " + ;
		"from tabdocumentos where id<100000 order by id", "mwkdocu")

	If mret <= 0
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif
Endif

Select mwkdocu
Locate For codigovax = mitd
mabrev = abrevio

If mnroregistra > 0   &&Traemos los documentos para el nro. de registracion.
	mret = SQLExec(mcon1,"select TabRegDocu.id,cast(TRD_NroDoc as float) as TRD_NroDoc,TRD_FechaPasiva,TabDocumentos.abrevio,TRD_TipoDoc"  + ;
		" from TabRegDocu" + ;
		" join TabDocumentos on TabRegDocu.TRD_TipoDoc = TabDocumentos.codigovax"+;
		" where TRD_Registracio  =?mnroregistra and TRD_fechapasiva = ?mfecpas" , "mwkregdoc0")
Else   &&nro. de registracion en cero. traemos cursor en blanco.
	mret = SQLExec(mcon1,"select TabRegDocu.id,cast(TRD_NroDoc as float) as TRD_NroDoc,TRD_FechaPasiva,TabDocumentos.abrevio,TRD_TipoDoc"  + ;
		" from TabRegDocu" + ;
		" join TabDocumentos on TabRegDocu.TRD_TipoDoc = TabDocumentos.codigovax"+;
		" where 1=0" , "mwkregdoc0")
Endif

If mret < 0
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "VALIDACION")
Else
	If Eof("mwkregdoc0")
**Grabar el telefono solo cuando nro. de registracion > 0
		If midoc > 0 .And. mnroregistra > 0

			mret = SQLExec(mcon1,"Insert into TabRegDocu (TRD_Registracio, TRD_NroDoc , "+;
				" TRD_FechaPasiva , TRD_TipoDoc ) " + ;
				" values (?mnroregistra ,?midoc, ?mfecpas, ?mitd)")

			mret = SQLExec(mcon1,"select id,cast(TRD_NroDoc as float) as TRD_NroDoc , TRD_FechaPasiva , TRD_TipoDoc->abrevio ,TRD_TipoDoc " + ;
				"from TabRegDocu " + ;
				"where TRD_Registracio  =?mnroregistra and trt_tipo<>9 and TRD_fechapasiva = ?mfecpas" , "mwkregdoc0")
		Endif
	Endif

	Select mwkregdoc0
	Locate For TRD_NroDoc = midoc

	If !Found() And motivo = 1
		Insert Into mwkregdoc0 (Id,TRD_NroDoc , TRD_FechaPasiva , abrevio ,TRD_TipoDoc );
			values(99,midoc,mfecpas,mabrev,mitd )
	Endif

	Select mwkregdoc0
	Go Top
	If !Eof()
		Skip
	Endif
Endif

If mnroregistra > 1
	mret = SQLExec(mcon1,"select id,TRT_Numero , TRT_Pasiva  , TRT_tipo, TRT_observacion " + ;
		"from TabRegTel " + ;
		"where TRT_Registracio = ?mnroregistra and TRT_pasiva = ?mfecpas","mwkregtel0")
Else  &&para traer el cursor vacio. Se dio el caso de haber registros con nro. de registracion = 0.
	mret = SQLExec(mcon1,"select id,TRT_Numero , TRT_Pasiva  , TRT_tipo, TRT_observacion " + ;
		"from TabRegTel " + ;
		"where id= 1 ","mwkregtel00")
	Select * From mwkregtel00 Where 1= 0 Into Cursor mwkregtel01
	Use Dbf('mwkregtel01') Again In 0 Alias mwkregtel0
	Use In Select('mwkregtel01')
Endif
If mret < 0
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "VALIDACION")
Else

	Select mwkregtel0

	Locate For TRT_Numero = mitel

	If !Found() And motivo = 1
		Insert Into mwkregtel0 (Id,TRT_Numero, TRT_Pasiva, TRT_tipo,TRT_observacion);
			values (-1,mitel ,mfecpas,Iif(Left(mitel,2) = "15",4,1),Space(50))
	Endif

	Select mwkregtel0
	Go Top
	If !Eof()
		Skip
	Endif


	If !mbsolotel
		Select Id,Alltrim(abrevio)+"-"+Transf(Nvl(TRD_NroDoc,0),"999999999999") As documento,;
			TRD_NroDoc, TRD_FechaPasiva,TRD_TipoDoc  ;
			from mwkregdoc0 Group By TRD_NroDoc, TRD_TipoDoc  ;
			into Cursor mwkregdoc
	Endif
	Select mwkregtel0.Id,Alltrim(TT_descrTipo)+"-"+Alltrim(TRT_Numero) As telefonos ,;
		TRT_Numero, TRT_Pasiva  ,TRT_tipo,Nvl(TRT_observacion,Space(50)) As TRT_observacion ;
		from mwkregtel0,mwktipotel Where mwktipotel.Id =TRT_tipo  Group By TRT_tipo,TRT_Numero Into Cursor mwkregtel
*** busco los pasivos
	mret = SQLExec(mcon1,"SELECT ID, TT_categoria, TT_descrTipo FROM Zabtipotel " + ;
		" where TT_fecpasiva >'1900-01-01' ", "mwktipotelpas")

	Select mwkregtel0.Id,Alltrim(TT_descrTipo)+"-"+Alltrim(TRT_Numero) As telefonos ,;
		TRT_Numero, TRT_Pasiva  ,TRT_tipo,Nvl(TRT_observacion,Space(50)) As TRT_observacion ;
		from mwkregtel0,mwktipotelpas Where mwktipotelpas.Id =TRT_tipo  Group By TRT_tipo,TRT_Numero Into Cursor mwkregtelpas
Endif


If !mbsolotel
	If lnoverimagen = 0 And lsinimagen = 0
		mret = SQLExec(mcon1,"select id,TRF_Foto " + ;
			"from TabRegFoto " + ;
			"where TRF_Registracio  =?mnroregistra " , "mwkregFoto")

		If mret < 0
			If mwkexe.nomexe = "LLAMADOR"
				Do prg_error_SQL("ERROR EN LA GENERACION DEL CURSOR")
			Else
				Messagebox('ERROR EN LA GENERACION DEL CURSOR, REINTENTE',16,'Validacion')
*	Do prg_cancelo
			Endif
		Endif

		If Used('ima')
			Use In ima
		Endif

		If Used('__DATA')
			Use In __DATA
		Endif

		If Used ('imagen')
			Use In imagen
		Endif

		Select TRF_Foto As foto From mwkregFoto Into Cursor ima

		_Screen.AddProperty("cFotoPacName",Alltrim(Str(mnroregistra,9,0)))
*	_Screen.AddProperty("cFotoPacName",'ima' + Alltrim(Str(mnroregistra,9,0)) + Strtran(Time(),":",""))

		lbError = .F.
		On Error Do Foto2

		If File("C:\temp\imagenes\imagen.dbf")
			Erase ("C:\temp\imagenes\imagen.dbf")
		Endif

		On Error &lcError
		If lbError
			Return
		Endif

		If File("C:\temp\imagenes\imagen.fpt")
			Erase ("C:\temp\imagenes\imagen.fpt")
		Endif
		Select ima
		Copy To "C:\temp\imagenes\imagen"
		Use In ima

* cambia el campo grneral de tipo memo
		LL = Fopen("C:\temp\imagenes\imagen.dbf",12)
		Fseek(LL,43)
		Fwrite(LL,'M')
		Fclose(LL)

* graba los datos campo memo en un archivo
		Use "C:\temp\imagenes\imagen.dbf" Alias ima
		miresp = ''
		Do prg_saveBin With foto,"C:\temp\imagenes\"+Alltrim(Str(mnroregistra,9,0)),miresp,'JPG'

		If Used('__DATA')
			Use In __DATA
		Endif
		If Used ('imagen')
			Use In imagen
		Endif
		If Used('ima')
			Use In ima
		Endif
	Else

	Endif
Endif
On Error &lcError

Return

*!* ---------------------------------------------------------------------------
Procedure Foto2
*!* ---------------------------------------------------------------------------
lbError = .T.
On Error *

Select TRF_Foto As foto ;
	from mwkregFoto ;
	into Cursor ima

*_Screen.AddProperty("cFotoPacName",'ima' + Alltrim(Str(mnroregistra,9,0)) + Strtran(Time(),":",""))
*!*	_Screen.AddProperty("cFotoPacName",alltrim(str(mnroregistra,9,0)))

lcArcImg = _Screen.cFotoPacName

*!*

If File("C:\temp\imagenes\" + lcArcImg + ".dbf")
	Erase ("C:\temp\imagenes\" + lcArcImg + ".dbf")
Endif

If File("C:\temp\imagenes\" + lcArcImg + ".fpt")
	Erase ("C:\temp\imagenes\" + lcArcImg + ".fpt")
Endif

Select ima
Copy To ("C:\temp\imagenes\" + lcArcImg )
Use In ima

* cambia el campo grneral de tipo memo
LL = Fopen("C:\temp\imagenes\" + lcArcImg + ".dbf",12)
Fseek(LL,43)
Fwrite(LL,'M')
Fclose(LL)

* graba los datos campo memo en un archivo
Use "C:\temp\imagenes\" + lcArcImg + ".dbf" Alias ima
miresp = ''
Do prg_saveBin With foto,"C:\temp\imagenes\" + lcArcImg ,miresp,'JPG'

If Used('__DATA')
	Use In __DATA
Endif
If Used ('imagen')
	Use In imagen
Endif
If Used('ima')
	Use In ima
Endif

If File("C:\temp\imagenes\" + lcArcImg + ".dbf")
	Erase ("C:\temp\imagenes\" + lcArcImg + ".dbf")
Endif

If File("C:\temp\imagenes\" + lcArcImg + ".fpt")
	Erase ("C:\temp\imagenes\" + lcArcImg + ".fpt")
Endif




