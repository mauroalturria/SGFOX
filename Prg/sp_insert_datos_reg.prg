***
*	agrega datos de registracio
***
Lparameters mnroreg,lnewTE,lnewDoc,ntipoTE,cnrotel,ntipoDoc,nnrodoc,rutaimagen,lbaja,mapelmat,;
	ctxttel,ctxtnrodoc,ccbodocu,lcmabiofoto,lquesexo,lqueapel,lquenom
If Vartype(lquesexo) <> "C"
	lquesexo = ''
Endif
If Vartype(lqueapel) <> "C"
	lqueapel = ''
Endif
If Vartype(lquenom) <> "C"
	lquenom = ''
Endif
If Vartype(lcmabiofoto) ="U"
	lcmabiofoto = .T.
Endif

If Vartype(lnoverimagen) # "N"
	lnoverimagen = 0
Endif
mfecpas = Ctod("01/01/1900")
If Val(ctxtnrodoc )=0
	ctxtnrodoc = Transform(nnrodoc)
Endif

mret    = SQLExec(mcon1, "select * from TabRegDocu "+;
	"where TRD_Registracio = ?mnroreg and TRD_NroDoc = ?ctxtnrodoc and TRD_fechapasiva = ?mfecpas", "mwkcontrol")
If nnrodoc > 0
	If Reccount("mwkcontrol") = 0
		If lnewDoc
			mret = SQLExec(mcon1, "insert into TabRegDocu(TRD_NroDoc,TRD_fechapasiva,TRD_Registracio,TRD_TipoDoc) " + ;
				"values(?ctxtnrodoc ,?mfecpas,?mnroreg,?ntipoDoc)")
		Else
			mret = SQLExec(mcon1, "select * from TabRegDocu "+;
				"where TRD_Registracio= ?mnroreg  and TRD_NroDoc = ?ctxtnrodoc", "mwkcontrol")

			If Reccount("mwkcontrol") > 0
				mid = mwkcontrol.Id
				mret = SQLExec(mcon1, "update TabRegDocu set TRD_TipoDoc = ?ntipoDoc ,TRD_NroDoc = ?nnrodoc, TRD_fechapasiva = ?mfecpas "+;
					" where id = ?mid ")
			Endif
		Endif
	Else &&& cambio esto si no pierdo la relacion anterior
*!*			mid  = mwkcontrol.id
*!*			mret = sqlexec(mcon1, "update TabRegDocu set TRD_NroDoc = ?nnrodoc, TRD_fechapasiva = ?mfecpas "+;
*!*				" where id = ?mid ")
	Endif
Endif

If lbaja
	mfecpas = Ttod(mwkfecserv.fechahora)
Endif



*!* Apellido Materno
If Vartype(mapelmat) = "C" And !Empty(mapelmat)
	mret = SQLExec(mcon1, "select id from TabRegdatos where TRDA_Registracio = ?mnroreg ","mwkregdctr")
	If Reccount("mwkregdctr") > 0
		mid = mwkregdctr.Id
		mret = SQLExec(mcon1, "update TabRegDatos set TRDA_ApelMat = ?mapelmat " + ;
			" where id = ?mid ")
	Else
		mret = SQLExec(mcon1, "insert into TabRegDatos( TRDA_Registracio, TRDA_ApelMat) " + ;
			"values( ?mnroreg, ?mapelmat)")
	Endif
Endif
*!* datos autopercibidos
*lquesexo,lqueapel,lquenom
If   !(Empty(lquesexo) And Empty(lqueapel) And Empty(lquenom))
	mret = SQLExec(mcon1, "select id from TabRegdatos where TRDA_Registracio = ?mnroreg ","mwkregdctr")
	If Reccount("mwkregdctr") > 0
		mid = mwkregdctr.Id
		mret = SQLExec(mcon1, "update TabRegDatos set  TRDA_ApellidoEleccion = ?lqueapel , TRDA_GeneroEleccion = ?lquesexo "+;
			" , TRDA_NombreEleccion = ?lquenom " + ;
			" where id = ?mid ")
	Else
		mapelmat=''
		mret = SQLExec(mcon1, "insert into TabRegDatos( TRDA_Registracio, TRDA_ApelMat, "+;
			" TRDA_ApellidoEleccion , TRDA_GeneroEleccion , TRDA_NombreEleccion  ) " + ;
			"values( ?mnroreg, ?mapelmat,?lqueapel,?lquesexo,?lquenom)")
	Endif
Endif

*!* Foto
If !Empty(rutaimagen) And lnoverimagen = 0 And lcmabiofoto
	mret = SQLExec(mcon1, "select id from TabRegFoto where TRF_Registracio = ?mnroreg ","mwkregfctr")
	If Used ('imagen')
		Use In IMAGEN
	Endif
	If Used ('__DATA')
		Use In __DATA
	Endif
	If File("C:\temp\imagenes\imagen.dbf")
		Erase ("C:\temp\imagenes\imagen.dbf")
	Endif
	If File("C:\temp\imagenes\imagen.fpt")
		Erase ("C:\temp\imagenes\imagen.fpt")
	Endif
	Select 0
	Create Table "C:\temp\imagenes\imagen.dbf" Free (foto M)

*  Toma el dato binario del archivo introducido en el memo
	Select IMAGEN
	Append Blank

	miimagen = ''
	Do prg_LoadBin With rutaimagen,miimagen
	If !Empty(miimagen )
		Replace foto With miimagen
		Use

*  Cambia el campo memo a un tipo general para introducir a sql server
		LL = Fopen("C:\temp\imagenes\imagen.dbf",12)
		Fseek(LL,43)
		Fwrite(LL,'G')
		Fclose(LL)

*  Escribe el dato en sql server
		Use C:\temp\imagenes\IMAGEN.Dbf Alias __DATA
	Else
		Create Cursor __DATA (foto M)
	Endif

	If Reccount('mwkregfctr')>0
		mid = mwkregfctr.Id
		mret = SQLExec(mcon1, "update TabRegFoto set TRF_Foto = ?__DATA.foto "+;
			" where TRF_Registracio = ?mnroreg ")
	Else
		mret = SQLExec(mcon1, "insert into TabRegFoto( TRF_Foto,TRF_Registracio) " + ;
			"values( ?__DATA.foto, ?mnroreg )")
	Endif

	If File(rutaimagen)
		Erase (rutaimagen)
	Endif

Endif
