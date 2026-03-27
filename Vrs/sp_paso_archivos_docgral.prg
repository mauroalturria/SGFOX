*
* Pasaje de Archivos a un campo General en Tablas CACHE
*
public mcon1

mcon1 = sqlconnect("conec01")              && String de Coneccion a DESARROLLO

if !directory("C:\temp\informes")
	mkdir "C:\temp\informes"
endif

mFormulario  = 'key2'
rutaarchivo = 'C:\Qepd1a1\Exe\Nombres\key2.avi'
mtipo = 'AVI'		                       && Tipo de Archivo, Ej.: WMV, etc.
mpropietario  = 0
mAnio = 2009
mDescripcion = mFormulario
mTema 	=''
mSubnivel = 0

mret = sqlexec(mcon1,"select id "+;
	" from TabDocGral "+;
	" where propietario = ?mpropietario and Formulario = ?mFormulario  ", "mwkTabDocGral")
if reccount("mwkTabDocGral") = 0
	mret = sqlexec(mcon1,"insert into TabDocGral "+;
		"(Anio , Descripcion , Propietario , Formulario , Tema , Subnivel , Tipo )"+;
		" values (?mAnio , ?mDescripcion , ?mPropietario , ?mFormulario , ?mTema , ?mSubnivel , ?mTipo )")
	mret = sqlexec(mcon1,"select id "+;
		" from TabDocGral "+;
		" where propietario = ?mpropietario and Formulario = ?mFormulario  ", "mwkTabDocGral")
endif
mid = mwkTabDocGral.id

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


= SQLDisconnect(mcon1)

messagebox("INCORPORACION DE ARCHIVOS FINALIZADA",48,"Validación")

return




