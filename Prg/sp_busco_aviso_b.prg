*
* Busco avisos de entidades
*
Parameter mbusca, lbaja

mfechapas = ctod("01/01/1900")

If type('lbaja') # "N"
	cbaja = ' av_fechapasiva = ?mfechapas and '
Else
	cbaja = ' '
Endif

mret = sqlexec(mcon1, "select *, prestacions.PRE_descriprest as lpresta from TabAvisosMarcelo "+;
	"left join prestacions on pre_codprest = AV_prestacion " +;
	"where &cbaja &mbusca ", "mwkTabAvisos")

If mret < 0
	Messagebox("EN BUSQUEDA DE AVISOS PARA ENTIDADES"+chr(10)+;
	"ERROR AL BUSCAR LOS DATOS", 48, "ERROR")
Endif

