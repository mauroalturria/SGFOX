*
* Pasaje de Archivos a un campo General en Tablas CACHE
*

Lparameters mtpmov,mlni,mpropietario,manio,msubnivel,mformulario

If vartype(mtpmov) <> 'N' && Tipo de movimiento 1: Alta, 2: Modificación
	mtpmov = 1
Endif

If vartype(mlni) <> 'N'   && En caso de Tipo de movimiento 2, ID del archivo a modificar
	mlni = 0
Endif

If mtpmov = 2 and mlni = 0
	Messagebox("NO ESPECIFICO ARCHIVO A MODIFICAR !!",48,"Validación")
	Return
Endif

If vartype(mpropietario) <> 'N'
	mpropietario = 2
Endif

If vartype(manio) <> 'N'
	manio = year(sp_busco_fecha_serv('DD'))
Endif

If vartype(msubnivel) <> 'N'
	msubnivel = 2
Endif

If vartype(mformulario) <> 'C'
	mformulario = 'frmcalidad09'
Endif

cfiles     = 'C:\documenta\*.*'
ruta       = 'C:\documenta\'
ncantfiles = iif(mtpmov=1,adir(mima,cfiles),1)
marchivo   = ''

If mtpmov = 2
	marchivo = GETFILE("Adobe AVI:AVI","Archivo a modificar","Actualiza",0,;
		"Ubiquese en C:\DOCUMENTA y seleccione el PDF a actualizar")
	If len(alltrim(marchivo))=0
		Return
	Endif
Endif

*!* Public mcon1
*!* mcon1 = sqlconnect("conec01")   && String de Coneccion a DESARROLLO

If !directory("C:\temp\informes")
	Mkdir "C:\temp\informes"
Endif

If mtpmov = 1
	mret = sqlexec(mcon1,"select Descripcion,id"+;
		" from tabdocgral"+;
		" where propietario=?mpropietario and formulario=?mformulario"+;
		" and subnivel=?msubnivel", "mwkTabDocGral")
	ndocs = reccount("mwkTabDocGral")
Endif

For i = 1 to ncantfiles

	ni = iif(mlni=0, (i+ndocs), mlni)

	If mtpmov = 1
		mtema = transform(ni,"@L 99")
		mtipo = upper(justext(mima(i,1)))
		mdescripcion = mima(i,1)
		rutaarchivo  = 'C:\documenta\'+alltrim(mdescripcion)
		mdescripcion = mtema+' - '+JUSTSTEM(mdescripcion)
	Else
		rutaarchivo = marchivo
		mtipo = upper(right(marchivo,3))
	Endif

*!* Buscar el registro que corresponda

	If mtpmov = 1 && Alta
		mret = sqlexec(mcon1,"select Descripcion , id "+;
			" from tabdocgral "+;
			" where propietario = ?mpropietario and formulario = ?mformulario  "+;
			" and tema = ?ni and subnivel = ?msubnivel  ", "mwkTabDocGral")

	Else          && Modificación

		mret = sqlexec(mcon1,"select Descripcion , id "+;
			" from tabdocgral "+;
			" where propietario = ?mpropietario and formulario = ?mformulario  "+;
			" and id = ?ni", "mwkTabDocGral")
	Endif

	If reccount("mwkTabDocGral") = 0
	
		mret = sqlexec(mcon1,"insert into TabDocGral "+;
			"(anio , descripcion , propietario , formulario , tema , subnivel , tipo )"+;
			" values (?manio , ?mdescripcion , ?mpropietario , ?mformulario , ?mtema , ?msubnivel , ?mtipo )")

		mret = sqlexec(mcon1,"select id "+;
				" from tabdocgral "+;
				" where propietario = ?mpropietario and formulario = ?mformulario  ", "mwkTabDocGral")
	Endif
	
	Select mwktabdocgral
	Go bottom

	mid = mwktabdocgral.id

*!* Anio    ,descripcion  ,  propietario  ,  formulario ,  tema    ,  subnivel  ,   tipo    ,    documento
*!* vdat[1] ,  ?vdat[2]   ,    ?vdat[5]   ,   ?vdat6]   , ?vdat[3] ,   ?vdat[7] ,  ?vdat[4] ,  ?__DATA.archivo

	If mid > 0
		If used ('archivos')
			Use in archivos
		Endif
		If used ('__DATA')
			Use in __data
		Endif
		If file("C:\temp\informes\archivos.dbf")
			Erase ("C:\temp\informes\archivos.dbf")
		Endif
		If file("C:\temp\informes\archivos.fpt")
			Erase ("C:\temp\informes\archivos.fpt")
		Endif
		Select 0
		Create table "C:\temp\informes\archivos.dbf" free (archivo m)

*!*     Toma el dato binario del archivo introducido en el memo

		Select archivos
		Append blank
		miarchivo = ''
		Do prg_loadbin with rutaarchivo,miarchivo

		mpaso = .f.

		If !empty(miarchivo)
			Replace archivo with miarchivo
			Use

*!*         Cambia el campo memo a un tipo general para introducir a sql server

			ll = fopen("C:\temp\informes\archivos.dbf",12)
			Fseek(ll,43)
			Fwrite(ll,'G')
			Fclose(ll)

*!*         Escribe el dato en sql server

			Use c:\temp\informes\archivos.dbf alias __data
			mpaso = .t.

		Else
			Create cursor __data (archivo m)
		Endif

		If mpaso
			mret = sqlexec(mcon1, "update TabDocGral set documento = ?__DATA.archivo "+;
				", tipo = ?mtipo where id = ?mid ")
			If mret < 0
				Messagebox("EN INCORPORACION DE ARCHIVO"+chr(10)+;
					"AL MAESTRO DE DOCUMENTOS GENERALES",16,"ERROR")
			Endif
		Endif

		If used ('archivos')
			Use in archivos
		Endif

		If used ('__DATA')
			Use in __data
		Endif

	Endif
Endfor

*!* *!* = sqldisconnect(mcon1)
*!* Messagebox("INCORPORACION DE ARCHIVOS FINALIZADA",48,"Validación")

Return




