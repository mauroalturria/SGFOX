*
* Pasaje de Archivos a un campo General en Tablas CACHE
*
public mcon1

mcon1 = sqlconnect("conec01")              && String de Coneccion a DESARROLLO

if !directory("C:\temp\informes")
	mkdir "C:\temp\informes"
endif
cfiles = 'C:\documenta\*.*'
mformulario  = 'frmcalidad09'
ruta = 'C:\documenta\'

mpropietario  = 2
manio = 2009
msubnivel = 2
ncantfiles = adir(mima,cfiles)
mret = sqlexec(mcon1,"select Descripcion , id "+;
	" from tabdocgral "+;
	" where propietario = ?mpropietario and formulario = ?mformulario  "+;
	" and subnivel = ?msubnivel  ", "mwkTabDocGral")
ndocs = reccount ("mwkTabDocGral")
for i=1 to ncantfiles
	mdescripcion = mima(i,1)
	ni= i + ndocs 
	mtema 	= transform(ni,"@L 99")
	mtipo = upper(justext(mima(i,1)))
	rutaarchivo = 'C:\documenta\'+alltrim(mdescripcion)
	mdescripcion = JUSTSTEM(mdescripcion )
*buscar el registro que corresponda
	mret = sqlexec(mcon1,"select Descripcion , id "+;
		" from tabdocgral "+;
		" where propietario = ?mpropietario and formulario = ?mformulario  "+;
		" and tema = ?ni and subnivel = ?msubnivel  ", "mwkTabDocGral")
	set step on
	if reccount("mwkTabDocGral") = 0
		mret = sqlexec(mcon1,"insert into TabDocGral "+;
			"(anio , descripcion , propietario , formulario , tema , subnivel , tipo )"+;
			" values (?manio , ?mdescripcion , ?mpropietario , ?mformulario , ?mtema , ?msubnivel , ?mtipo )")
		mret = sqlexec(mcon1,"select id "+;
			" from tabdocgral "+;
			" where propietario = ?mpropietario and formulario = ?mformulario  ", "mwkTabDocGral")
		select mwktabdocgral
		go bott
	endif
	mid = mwktabdocgral.id

*!* Anio    ,descripcion  ,  propietario  ,  formulario ,  tema    ,  subnivel  ,   tipo    ,    documento
*!* vdat[1] ,  ?vdat[2]   ,    ?vdat[5]   ,   ?vdat6]   , ?vdat[3] ,   ?vdat[7] ,  ?vdat[4] ,  ?__DATA.archivo
	if mid>0
		if used ('archivos')
			use in archivos
		endif
		if used ('__DATA')
			use in __data
		endif
		if file("C:\temp\informes\archivos.dbf")
			erase ("C:\temp\informes\archivos.dbf")
		endif
		if file("C:\temp\informes\archivos.fpt")
			erase ("C:\temp\informes\archivos.fpt")
		endif
		select 0
		create table "C:\temp\informes\archivos.dbf" free (archivo m)

*!* Toma el dato binario del archivo introducido en el memo

		select archivos
		append blank
		miarchivo = ''
		do prg_loadbin with rutaarchivo,miarchivo

		mpaso = .f.

		if !empty(miarchivo)
			replace archivo with miarchivo
			use
*!*     Cambia el campo memo a un tipo general para introducir a sql server
			ll = fopen("C:\temp\informes\archivos.dbf",12)
			fseek(ll,43)
			fwrite(ll,'G')
			fclose(ll)
*!*     Escribe el dato en sql server
			use c:\temp\informes\archivos.dbf alias __data
			mpaso = .t.
		else
			create cursor __data (archivo m)
		endif

		if mpaso
			mret = sqlexec(mcon1, "update TabDocGral set documento = ?__DATA.archivo "+;
				", tipo = ?mtipo where id = ?mid ")
			if mret < 0
				messagebox("EN INCORPORACION DE ARCHIVO"+chr(10)+"AL MAESTRO DE DOCUMENTOS GENERALES",16,"ERROR")
*!*		Else
*!*			Messagebox("INCORPORACION DE ARCHIVO"+CHR(10)+"REALIZADA !!",48,"Validación")
			endif
		endif

		if used ('archivos')
			use in archivos
		endif
		if used ('__DATA')
			use in __data
		endif
	endif
endfor


= sqldisconnect(mcon1)

messagebox("INCORPORACION DE ARCHIVOS FINALIZADA",48,"Validación")

return




