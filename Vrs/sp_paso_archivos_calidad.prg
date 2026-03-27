*
* Pasaje de Archivos a un campo General en Tablas CACHE
*
public mcon1

mcon1 = sqlconnect("conec01")              && String de Coneccion a DESARROLLO

if !directory("C:\temp\informes")
	mkdir "C:\temp\informes"
endif

dimension vdat[7]

vdat[1] = 2009
vdat[5] = 0                             && Propietario = EXE ( ID de TabExe )
vdat[6] = 'key2'			       && Formulario


for mi = 9 to 9
	vdat[3] = alltrim(str(mi))
	vdat[7] = 0

	vdat[2] = 'key2'
	rutaarchivo = 'C:\Qepd1a1\Exe\Nombres\key2.avi'
	vdat[4] = 'AVI'		                       && Tipo de Archivo, Ej.: WMV, etc.
	vdat[3] = 0

	do case
		case mi = 1
			vdat[2] = 'Ley 17132'
			rutaarchivo = 'C:\temp\informes\l17132.pdf'
			vdat[4] = 'PDF'		                       && Tipo de Archivo, Ej.: WMV, etc.
		case mi = 2
			vdat[2] = 'Norma IRAM ISO 9001'
			rutaarchivo = 'C:\temp\informes\ISO9001-2000Norma.pdf'
			vdat[4] = 'PDF'		                       && Tipo de Archivo, Ej.: WMV, etc.
		case mi = 3
			vdat[2] = 'Norma Iternacional ISO 9004'
			rutaarchivo = 'C:\temp\informes\ISO 9004-2000(ES).pdf'
			vdat[4] = 'PDF'		                       && Tipo de Archivo, Ej.: WMV, etc.
		case mi = 4
			vdat[2] = 'ISO 9001 - 2000'
			rutaarchivo = 'C:\temp\informes\ISO 9001-2000.pdf'
			vdat[4] = 'PDF'		                       && Tipo de Archivo, Ej.: WMV, etc.
		case mi = 5
			vdat[2] = 'Maual de Limpieza y Desinfección Hospitalaria'
			rutaarchivo = 'C:\temp\informes\GC-Limpieza2.pdf'
			vdat[4] = 'PDF'		                       && Tipo de Archivo, Ej.: WMV, etc.
		case mi = 6
			vdat[2] = 'Comunicación Iterna - Ubicación de Sectores'
			rutaarchivo = 'C:\temp\informes\Comunicacion_interna.htm'
			vdat[4] = 'HTM'		                       && Tipo de Archivo, Ej.: WMV, etc.
		case mi = 7
			vdat[2] = 'Calendario de Vacunación'
			rutaarchivo = 'C:\temp\informes\calendario de vacunacion.jpg'
			vdat[4] = 'JPG'		                       && Tipo de Archivo, Ej.: WMV, etc.
		case mi = 8
			vdat[2] = 'Norma IRAM ISO 9000'
			rutaarchivo = 'C:\temp\informes\9000-iso.pdf'
			vdat[4] = 'PDF'		                       && Tipo de Archivo, Ej.: WMV, etc.
		case mi = 9
			vdat[2] = 'Listado de Estudios de Bristol'
			rutaarchivo = 'C:\temp\informes\Listado.htm'
			vdat[4] = 'PDF'		                       && Tipo de Archivo, Ej.: WMV, etc.
	endcase



*!* Anio    ,descripcion  ,  propietario  ,  formulario ,  tema    ,  subnivel  ,   tipo    ,    documento
*!* vdat[1] ,  ?vdat[2]   ,    ?vdat[5]   ,   ?vdat6]   , ?vdat[3] ,   ?vdat[7] ,  ?vdat[4] ,  ?__DATA.archivo

	if used ('archivos')
		use in archivOS
	endif
	if used ('__DATA')
		use in __DATA
	endif
	if file("C:\temp\informes\archivos.dbf")
		erase ("C:\temp\informes\archivos.dbf")
	endif
	if file("C:\temp\informes\archivos.fpt")
		erase ("C:\temp\informes\archivos.fpt")
	endif
	select 0
	create table "C:\temp\informes\archivos.dbf" free (archivo M)

*!* Toma el dato binario del archivo introducido en el memo

	select archivOS
	append blank
	miarchivo = ''
	do prg_LoadBin with rutaarchivo,miarchivo

	mpaso = .f.

	if !empty(miarchivo)
		replace archivo with miarchivo
		use
*!*     Cambia el campo memo a un tipo general para introducir a sql server
		LL = fopen("C:\temp\informes\archivos.dbf",12)
		fseek(LL,43)
		fwrite(LL,'G')
		fclose(LL)
*!*     Escribe el dato en sql server
		use C:\temp\informes\archivOS.dbf alias __DATA
		mpaso = .t.
	else
		create cursor __DATA (archivo M)
	endif

	if mpaso
		mid = 35 + mi
		mret = sqlexec(mcon1, "update TabDocGral set documento = ?__DATA.archivo where id = ?mid ")
		if mret < 0
			messagebox("EN INCORPORACION DE ARCHIVO"+chr(10)+"AL MAESTRO DE DOCUMENTOS GENERALES",16,"ERROR")
*!*		Else
*!*			Messagebox("INCORPORACION DE ARCHIVO"+CHR(10)+"REALIZADA !!",48,"Validación")
		endif
	endif

	if used ('archivos')
		use in archivOS
	endif
	if used ('__DATA')
		use in __DATA
	endif

endfor

release vdat

= SQLDisconnect(mcon1)

messagebox("INCORPORACION DE ARCHIVOS FINALIZADA",48,"Validación")

return




