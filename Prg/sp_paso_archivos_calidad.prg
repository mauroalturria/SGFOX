*
* Pasaje de Archivos a un campo General en Tablas CACHE
*
Public mcon1

mcon1 = SQLCONNECT("conec02")              && String de Coneccion a DESARROLLO

If !directory("C:\temp\informes")
	Mkdir "C:\temp\informes"
Endif

Dimension vdat[7]

vdat[1] = 2008
vdat[5] = 21                               && Propietario = EXE ( ID de TabExe )
vdat[6] = 'frmcalidad09'			       && Formulario

For mi = 1 to 8

	Do case
	Case mi = 1
		vdat[2] = 'Ley 17132'
		rutaarchivo = 'C:\temp\informes\l17132.pdf'
		vdat[4] = 'PDF'		                       && Tipo de Archivo, Ej.: WMV, etc.
	Case mi = 2
		vdat[2] = 'Norma IRAM ISO 9001'
		rutaarchivo = 'C:\temp\informes\ISO9001-2000Norma.pdf'
		vdat[4] = 'PDF'		                       && Tipo de Archivo, Ej.: WMV, etc.
	Case mi = 3
		vdat[2] = 'Norma Iternacional ISO 9004'
		rutaarchivo = 'C:\temp\informes\ISO 9004-2000(ES).pdf'
		vdat[4] = 'PDF'		                       && Tipo de Archivo, Ej.: WMV, etc.
	Case mi = 4
		vdat[2] = 'ISO 9001 - 2000'
		rutaarchivo = 'C:\temp\informes\ISO 9001-2000.pdf'
		vdat[4] = 'PDF'		                       && Tipo de Archivo, Ej.: WMV, etc.
	Case mi = 5
		vdat[2] = 'Maual de Limpieza y Desinfección Hospitalaria'
		rutaarchivo = 'C:\temp\informes\GC-Limpieza2.pdf'
		vdat[4] = 'PDF'		                       && Tipo de Archivo, Ej.: WMV, etc.
	Case mi = 6
		vdat[2] = 'Comunicación Iterna - Ubicación de Sectores'
		rutaarchivo = 'C:\temp\informes\Comunicacion_interna.htm'
		vdat[4] = 'HTM'		                       && Tipo de Archivo, Ej.: WMV, etc.
	Case mi = 7
		vdat[2] = 'Calendario de Vacunación'
		rutaarchivo = 'C:\temp\informes\calendario de vacunacion.jpg'
		vdat[4] = 'JPG'		                       && Tipo de Archivo, Ej.: WMV, etc.
	Case mi = 8
		vdat[2] = 'Norma IRAM ISO 9000'
		rutaarchivo = 'C:\temp\informes\9000-iso.pdf'
		vdat[4] = 'PDF'		                       && Tipo de Archivo, Ej.: WMV, etc.
	Endcase
	
	vdat[3] = alltrim(str(mi))
	vdat[7] = 0
	

*!* Anio    ,descripcion  ,  propietario  ,  formulario ,  tema    ,  subnivel  ,   tipo    ,    documento
*!* vdat[1] ,  ?vdat[2]   ,    ?vdat[5]   ,   ?vdat6]   , ?vdat[3] ,   ?vdat[7] ,  ?vdat[4] ,  ?__DATA.archivo

	If used ('archivos')
		Use in archivOS
	Endif
	If used ('__DATA')
		Use in __DATA
	Endif
	If file("C:\temp\informes\archivos.dbf")
		Erase ("C:\temp\informes\archivos.dbf")
	Endif
	If file("C:\temp\informes\archivos.fpt")
		Erase ("C:\temp\informes\archivos.fpt")
	Endif
	Select 0
	Create table "C:\temp\informes\archivos.dbf" free (archivo M)

*!* Toma el dato binario del archivo introducido en el memo

	Select archivOS
	Append blank
	miarchivo = ''
	Do prg_LoadBin with rutaarchivo,miarchivo

	mpaso = .f.

	If !empty(miarchivo)
		Replace archivo with miarchivo
		Use
*!*     Cambia el campo memo a un tipo general para introducir a sql server
		LL = fopen("C:\temp\informes\archivos.dbf",12)
		Fseek(LL,43)
		Fwrite(LL,'G')
		Fclose(LL)
*!*     Escribe el dato en sql server
		Use C:\temp\informes\archivOS.dbf alias __DATA
		mpaso = .t.
	Else
		Create cursor __DATA (archivo M)
	Endif

	If mpaso
		mret = sqlexec(mcon1, "insert into TabDocGral (anio,descripcion,propietario,formulario,tema,subnivel,tipo,documento) "+;
			"values (?vdat[1],?vdat[2],?vdat[5],?vdat[6],?vdat[3],?vdat[7],?vdat[4],?__DATA.archivo)")
		If mret < 0
			Messagebox("EN INCORPORACION DE ARCHIVO"+CHR(10)+"AL MAESTRO DE DOCUMENTOS GENERALES",16,"ERROR")
*!*		Else
*!*			Messagebox("INCORPORACION DE ARCHIVO"+CHR(10)+"REALIZADA !!",48,"Validación")
		Endif
	Endif

	If used ('archivos')
		Use in archivOS
	Endif
	If used ('__DATA')
		Use in __DATA
	Endif
	
Endfor

Release vdat

= SQLDisconnect(mcon1)

Messagebox("INCORPORACION DE ARCHIVOS FINALIZADA",48,"Validación")

Return




