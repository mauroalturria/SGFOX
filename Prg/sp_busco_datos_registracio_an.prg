****
**  Busco los datos anexos del paciente
****

Parameter mnroregistra, motivo, mbsolotel

If vartype(mbsolotel) = "U"
	mbsolotel = .F.
Endif

If vartype(motivo) # "N"
	motivo = 1
Endif

If used("mwkregtel0")
	Use in mwkregtel0
Endif

If !mbsolotel
	If used("mwkregdoc0")
		Use in mwkregdoc0
	Endif
Endif

mfecpas = ctod("01/01/1900")

If !mbsolotel

	mret = sqlexec(mcon1,"select id,TRDA_ApelMat " + ;
		"from TabRegDatos " + ;
		"where TRDA_Registracio  =?mnroregistra " , "mwkregdatos")

Endif

If used('mwkbuspacie1')

	mitel 	= nvl(mwkbuspacie1.reg_telefonos,'')

	If !mbsolotel
		midoc 	= mwkbuspacie1.reg_numdocumento
		mitd 	= iif(type('mwkbuspacie1.reg_tipodocumento') = 'C', ;
			round(val(mwkbuspacie1.reg_tipodocumento), 0), ;
			round(mwkbuspacie1.reg_tipodocumento, 0))

		Select mwkdocu
		Locate for codigovax = mitd
		mabrev = abrevio

*!*		mret = sqlexec(mcon1,"select id,TRD_NroDoc , TRD_FechaPasiva , TRD_TipoDoc->abrevio ,TRD_TipoDoc " + ;
*!*			"from TabRegDocu " + ;
*!*			"where TRD_Registracio  =?mnroregistra " , "mwkregdoc0")

		mret = sqlexec(mcon1,"select TabRegDocu.id,TRD_NroDoc,TRD_FechaPasiva,TabDocumentos.abrevio,TRD_TipoDoc"  + ;
			" from TabRegDocu" + ;
			" join TabDocumentos on TabRegDocu.TRD_TipoDoc = TabDocumentos.codigovax"+;
			" where TRD_Registracio  =?mnroregistra and TRD_fechapasiva = ?mfecpas" , "mwkregdoc0")
		If mret < 0
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "VALIDACION")
		else
			If eof("mwkregdoc0")
				If midoc>0

					mret = sqlexec(mcon1,"Insert into TabRegDocu (TRD_Registracio, TRD_NroDoc , "+;
						" TRD_FechaPasiva , TRD_TipoDoc ) " + ;
						" values (?mnroregistra ,?midoc, ?mfecpas, ?mitd)")

					mret = sqlexec(mcon1,"select id,TRD_NroDoc , TRD_FechaPasiva , TRD_TipoDoc->abrevio ,TRD_TipoDoc " + ;
						"from TabRegDocu " + ;
						"where TRD_Registracio  =?mnroregistra and TRD_fechapasiva = ?mfecpas" , "mwkregdoc0")
				Endif
			Endif

			Select mwkregdoc0
			Locate for TRD_NroDoc = midoc

			If !found() and motivo = 1
				Insert into mwkregdoc0 (id,TRD_NroDoc , TRD_FechaPasiva , abrevio ,TRD_TipoDoc );
					values(99,midoc,mfecpas,mabrev,mitd )
			Endif

			Select mwkregdoc0
			Go top
			Skip
		endif
	Endif

	mret = sqlexec(mcon1,"select id,TRT_Numero , TRT_Pasiva  , TRT_tipo " + ;
		"from TabRegTel " + ;
		"where TRT_Registracio = ?mnroregistra and TRT_pasiva = ?mfecpas","mwkregtel0")
	If mret < 0
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "VALIDACION")
	else
		If reccount("mwkregtel0") = 0
			mret = sqlexec(mcon1,"Insert into TabRegTel (TRT_Registracio  ,TRT_Numero , TRT_Pasiva  , TRT_tipo) " + ;
				" values (?mnroregistra ,?mitel , ?mfecpas, 1)")

			mret = sqlexec(mcon1,"select id,TRT_Numero , TRT_Pasiva  , TRT_tipo " + ;
				"from TabRegTel " + ;
				"where TRT_Registracio  =?mnroregistra and TRT_pasiva = ?mfecpas" , "mwkregtel0")

		Endif

		Select mwkregtel0

		Locate for TRT_Numero = mitel

		If !found() and motivo = 1
			Insert into mwkregtel0 (id,TRT_Numero, TRT_Pasiva, TRT_tipo) values(99,mitel ,mfecpas,1)
		Endif

		Select mwkregtel0
		Go top
		Skip

		If !mbsolotel
			Select id,alltrim(abrevio)+"-"+transf(nvl(TRD_NroDoc,0),"99999999") as documento,;
				TRD_NroDoc, TRD_FechaPasiva,TRD_TipoDoc  ;
				from mwkregdoc0 group by TRD_NroDoc, TRD_TipoDoc  ;
				into cursor mwkregdoc
		Endif

		Select id,iif(TRT_tipo=1,"PART1",iif(TRT_tipo=2,"PART2",iif(TRT_tipo=3,;
			"LABORAL",iif(TRT_tipo=4,"CELULAR","MENSAJES" ) ) ) )+"-"+alltrim(TRT_Numero) as telefonos ,;
			TRT_Numero, TRT_Pasiva  ,TRT_tipo ;
			from mwkregtel0 group by TRT_Numero into cursor mwkregtel
	Endif
Endif

If !mbsolotel
	mret = sqlexec(mcon1,"select id,TRF_Foto " + ;
		"from TabRegFoto " + ;
		"where TRF_Registracio  =?mnroregistra " , "mwkregFoto")

	If mret < 0
		If mwkexe.nomexe = "LLAMADOR"
			Do prg_error_SQL("ERROR EN LA GENERACION DEL CURSOR")
		Else
			Messagebox('ERROR EN LA GENERACION DEL CURSOR, REINTENTE',16,'Validacion')
			Do prg_cancelo
		Endif
	Endif

	If used('ima')
		Use in ima
	Endif

	If used('__DATA')
		Use in __DATA
	Endif

	If used ('imagen')
		Use in imagen
	Endif

	Select TRF_Foto as foto from mwkregFoto into cursor ima
	If file("C:\temp\imagenes\imagen.dbf")
		Erase ("C:\temp\imagenes\imagen.dbf")
	Endif
	If file("C:\temp\imagenes\imagen.fpt")
		Erase ("C:\temp\imagenes\imagen.fpt")
	Endif
	Select ima
	Copy to "C:\temp\imagenes\imagen"
	Use in ima

* cambia el campo grneral de tipo memo
	LL = fopen("C:\temp\imagenes\imagen.dbf",12)
	Fseek(LL,43)
	Fwrite(LL,'M')
	Fclose(LL)

* graba los datos campo memo en un archivo
	Use "C:\temp\imagenes\imagen.dbf" alias ima
	miresp = ''
	Do prg_saveBin with foto,"C:\temp\imagenes\"+alltrim(str(mnroregistra,9,0)),miresp,'JPG'

	If used('__DATA')
		Use in __DATA
	Endif
	If used ('imagen')
		Use in imagen
	Endif
	If used('ima')
		Use in ima
	Endif

Endif
