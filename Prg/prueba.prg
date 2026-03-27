rutaimagen = getfile()
if !empty(rutaimagen)

****** proceso de la imagen
* crea una tabla temporal
	if file("imagen.dbf")
		erase ("imagen.dbf")
	endif
	if file("imagen.fpt")
		erase ("imagen.fpt")
	endif
	select 0
	create table "imagen.dbf" free (MDATA M)
* toma el dato binario del archivo introducido en el memo
	select IMAGEN
	append blank
	miimagen = ''
	do LoadImg with rutaimagen,miimagen 
	if !empty(miimagen )
	replace MDATA with miimagen 
	use
* cambia el campo memo a un tipo general para introducir a sql server
	LL = fopen("imagen.dbf",12)
	fseek(LL,43)
	fwrite(LL,'G')
	fclose(LL)
* escribe el dato en sql server
	use IMAGEN.dbf alias __DATA
	LCSQL = 'update tabla set foto=?__DATA.mData where codigo=?conicion'
	A=SQLEXEC(m.HANDLE,m.LCSQL)
	use in __DATA

endif

****************************************************************************

********************************




***** recuperar imagen de sql server convirtiendo binarios a memo
SQLEXEC(handle,"select foto from tabla where codigo=?condicion","ima")
select ima
if file("imagen.dbf")
	erase ("imagen.dbf")
endif
if file("imagen.fpt")
	erase ("imagen.fpt")
endif
copy to "imagen"
use

* cambia el campo grneral de tipo memo
LL = fopen("imagen.dbf",12)
fseek(LL,43)
fwrite(LL,'M')
fclose(LL)

* graba los datos campo memo en un archivo
use "imagen.dbf" alias ima
do SAVEIMG with FOTO,"\carpetaimagenes\"+sys(3),miresp

MIIMAGEN = miresp
thisform.IMAGE1.picture=iif (FILESIZE(MIIMAGEN)=0,"",alltrim(MIIMAGEN))
use in ima
*****************
