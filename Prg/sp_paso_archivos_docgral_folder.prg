*
* Pasaje de Archivos a un campo General en Tablas CACHE
*

Lparameters mtpmov,mlni,mpropietario,manio,msubnivel,mformulario,mopcion

If Vartype(mopcion) <> 'N' && si es 4 son firmas
	mopcion = 1
Endif
If Vartype(mtpmov) <> 'N' && Tipo de movimiento 1: Alta, 2: Modificación
	mtpmov = 1
Endif

If Vartype(mlni) <> 'N'   && En caso de Tipo de movimiento 2, ID del archivo a modificar
	mlni = 0
Endif

If mtpmov = 2 And mlni = 0
	Messagebox("NO ESPECIFICO ARCHIVO A MODIFICAR !!",48,"Validación")
	Return
Endif

If Vartype(mpropietario) <> 'N'
	mpropietario = 2
Endif

If Vartype(manio) <> 'N'
	manio = Year(sp_busco_fecha_serv('DD'))
Endif

If Vartype(msubnivel) <> 'N'
	msubnivel = 2
Endif

If Vartype(mformulario) <> 'C'
	mformulario = 'frmcalidad09'
Endif
If !Empty(mformulario )
	mbusform = 'and formulario = ?mformulario '
Else
	mbusform = ''
Endif
cfiles     = 'C:\documenta\*.*'
ruta       = 'C:\documenta\'
ncantfiles = Iif(mtpmov=1,Adir(mima,cfiles),1)
marchivo   = ''

If mtpmov = 2
	marchivo = Getfile("Adobe PDF:PDF","Archivo a modificar","Actualiza",0,;
	"Ubiquese en C:\DOCUMENTA y seleccione el archivo a actualizar")
	If Len(Alltrim(marchivo))=0
		Return
	Endif
Endif

*!* Public mcon1
*!* mcon1 = sqlconnect("conec01")   && String de Coneccion a DESARROLLO

If !Directory("C:\temp\informes")
	Mkdir "C:\temp\informes"
Endif

If mtpmov = 1
	mret = SQLExec(mcon1,"select  id,Anio, Descripcion, Propietario, Formulario, Tema,Subnivel, Tipo"+;
	" from tabdocgral"+;
	" where propietario=?mpropietario "+mbusform +;
	" and subnivel=?msubnivel", "mwkTabDocGral")
	ndocs = Reccount("mwkTabDocGral")
Else
	mret = SQLExec(mcon1,"select  id,Anio, Descripcion, Propietario, Formulario, Tema,Subnivel, Tipo"+;
	" from tabdocgral"+;
	" where id = ?mlni ", "mwkTabDocGral")
Endif

For i = 1 To ncantfiles

	ni = Iif(mlni=0, (i+ndocs), mlni)

	If mtpmov = 1
		mtema = Transform(ni,"@L 99")
		mtipo = Upper(Justext(mima(i,1)))
		mdescripcion = mima(i,1)
		rutaarchivo  = 'C:\documenta\'+Alltrim(mdescripcion)
		If Empty(mformulario )
			mformulario = Alltrim(Juststem(mdescripcion))
		Endif
		mdescripcion = mtema+' - '+Juststem(mdescripcion)
	Else
		rutaarchivo = marchivo
		mtipo = Upper(Right(marchivo,3))
	Endif
	If mopcion = 4
		manio = Val(mima(i,1))
	Endif
	If Inlist(mopcion , 5,6) &&firmas
		manio = Val(mima(i,1))
	Endif

*!* Buscar el registro que corresponda
	If !Inlist(mopcion, 5,6)
		If mtpmov = 1 && Alta
			mret = SQLExec(mcon1,"select Descripcion , id "+;
			" from tabdocgral "+;
			" where propietario = ?mpropietario "+mbusform +;
			" and tema = ?ni and subnivel = ?msubnivel  ", "mwkTabDocGral")
			mret = SQLExec(mcon1,"select codmed from medpresta "+;
			" where fecVigenH > fecVigend AND fecVigenH >= {fn curdate()} group by codmed ", "mwkmedfran")
		Else          && Modificación

			mret = SQLExec(mcon1,"select  id,Anio, Descripcion, Propietario, Formulario, Tema,Subnivel, Tipo"+;
			" from tabdocgral "+;
			" where id = ?ni", "mwkTabDocGral")
		Endif

		If Reccount("mwkTabDocGral") = 0

			mret = SQLExec(mcon1,"insert into TabDocGral "+;
			"(anio , descripcion , propietario , formulario , tema , subnivel , tipo )"+;
			" values (?manio , ?mdescripcion , ?mpropietario , ?mformulario , ?mtema , ?msubnivel , ?mtipo )")

			mret = SQLExec(mcon1,"select id "+;
			" from tabdocgral "+;
			" where propietario = ?mpropietario and formulario = ?mformulario  ", "mwkTabDocGral")
		Endif

		Select mwktabdocgral
		Go Bottom

		mid = mwktabdocgral.Id

*!* Anio    ,descripcion  ,  propietario  ,  formulario ,  tema    ,  subnivel  ,   tipo    ,    documento
*!* vdat[1] ,  ?vdat[2]   ,    ?vdat[5]   ,   ?vdat6]   , ?vdat[3] ,   ?vdat[7] ,  ?vdat[4] ,  ?__DATA.archivo

		If mid > 0
			If Used ('archivos')
				Use In archivos
			Endif
			If Used ('__DATA')
				Use In __data
			Endif
			If File("C:\temp\informes\archivos.dbf")
				Erase ("C:\temp\informes\archivos.dbf")
			Endif
			If File("C:\temp\informes\archivos.fpt")
				Erase ("C:\temp\informes\archivos.fpt")
			Endif
			Select 0
			Create Table "C:\temp\informes\archivos.dbf" Free (archivo m)

*!*     Toma el dato binario del archivo introducido en el memo

			Select archivos
			Append Blank
			miarchivo = ''
			Do prg_loadbin With rutaarchivo,miarchivo

			mpaso = .F.

			If !Empty(miarchivo)
				Replace archivo With miarchivo
				Use

*!*         Cambia el campo memo a un tipo general para introducir a sql server

				ll = Fopen("C:\temp\informes\archivos.dbf",12)
				Fseek(ll,43)
				Fwrite(ll,'G')
				Fclose(ll)

*!*         Escribe el dato en sql server

				Use c:\temp\informes\archivos.Dbf Alias __data
				mpaso = .T.

			Else
				Create Cursor __data (archivo m)
			Endif

			If mpaso
				mret = SQLExec(mcon1, "update TabDocGral set documento = ?__DATA.archivo "+;
				", tipo = ?mtipo where id = ?mid ")
				If mret < 0
					Messagebox("EN INCORPORACION DE ARCHIVO"+Chr(10)+;
					"AL MAESTRO DE DOCUMENTOS GENERALES",16,"ERROR")
				Endif
			Endif
		Endif
	Else
		mtipo = Iif(mopcion =5,3,4)
		mfecpas = Ctod("01/01/1900")
		mfechoy = Ttod(mwkfecserv.fechahora)
		mret = SQLExec(mcon1,"select * FROM TabMedFoto where  FechaBaja = ?mfecpas and tipo = ?mtipo and idmedico = ?manio  order by id desc ","mprofFotList")
		If Reccount()=0
			mret = SQLExec(mcon1,"insert into TabMedFoto (FechaBaja, FechaToma, IdMedico,Tipo ) "+;
			" values ( ?mfecpas  ,?mfechoy   , ?manio ,?mtipo )")

			mret = SQLExec(mcon1,"select * FROM TabMedFoto where  FechaBaja = ?mfecpas and tipo = ?mtipo and idmedico = ?manio  order by id desc ","mprofFotList")

		Endif

		mid = mprofFotList.Id

*!* Anio    ,descripcion  ,  propietario  ,  formulario ,  tema    ,  subnivel  ,   tipo    ,    documento
*!* vdat[1] ,  ?vdat[2]   ,    ?vdat[5]   ,   ?vdat6]   , ?vdat[3] ,   ?vdat[7] ,  ?vdat[4] ,  ?__DATA.archivo

		If mid > 0
			If Used ('archivos')
				Use In archivos
			Endif
			If Used ('__DATA')
				Use In __data
			Endif
			If File("C:\temp\informes\archivos.dbf")
				Erase ("C:\temp\informes\archivos.dbf")
			Endif
			If File("C:\temp\informes\archivos.fpt")
				Erase ("C:\temp\informes\archivos.fpt")
			Endif
			Select 0
			Create Table "C:\temp\informes\archivos.dbf" Free (archivo m)

*!*     Toma el dato binario del archivo introducido en el memo

			Select archivos
			Append Blank
			miarchivo = ''
			Do prg_loadbin With rutaarchivo,miarchivo

			mpaso = .F.

			If !Empty(miarchivo)
				Replace archivo With miarchivo
				Use

*!*         Cambia el campo memo a un tipo general para introducir a sql server

				ll = Fopen("C:\temp\informes\archivos.dbf",12)
				Fseek(ll,43)
				Fwrite(ll,'G')
				Fclose(ll)

*!*         Escribe el dato en sql server

				Use c:\temp\informes\archivos.Dbf Alias __data
				mpaso = .T.

			Else
				Create Cursor __data (archivo m)
			Endif

			If mpaso
				mret = SQLExec(mcon1, "update TabMedFoto set IMAGEN = ?__DATA.archivo "+;
				" where id = ?mid ")
				If mret < 0
					Messagebox("EN INCORPORACION DE ARCHIVO"+Chr(10)+;
					"AL MAESTRO DE DOCUMENTOS GENERALES",16,"ERROR")
				Endif
			Endif

		Endif
		If Used ('archivos')
			Use In archivos
		Endif

		If Used ('__DATA')
			Use In __data
		Endif
		cfile 	= sp_getshortpath(rutaarchivo)
		nuevonom = Strtran( "C:\documenta\pasados\"+Juststem(rutaarchivo)+'.'+Justext(rutaarchivo),' ','_')
		cc = cfile +" to " +nuevonom
		Copy File &cc
*				run /2 &cc
		Wait Windows cfile Nowait
		On Error =Aerr(eros)
		If File(rutaarchivo)
			Erase &rutaarchivo
		Endif
		On Error

	Endif
Endfor

*!* *!* = sqldisconnect(mcon1)
*!* Messagebox("INCORPORACION DE ARCHIVOS FINALIZADA",48,"Validación")

Return




