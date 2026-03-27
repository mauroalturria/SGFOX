****
** busco tabla documentos
****

if used('mwkdocu')
	select mwkdocu
	use
endif

mret = sqlexec(mcon1,"select abrevio, descrip, codigovax, id from tabdocumentos " + ;
	" where id<100000 order by id", "mwkdocu")

mret = sqlexec(mcon1," SELECT TDE_CodigoDoc , TDE_CodEnt , TDE_DescripEnt , "+;
	"TDE_IdTabDocumentos,abrevio,descrip FROM TabDocEnt,tabdocumentos "+;
	" where TDE_IdTabDocumentos = tabdocumentos.id ","mwkdocent")


