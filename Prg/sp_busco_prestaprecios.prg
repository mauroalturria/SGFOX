****
** busco prestaciones en tabprestaprecios
****

parameter mctexto

mret = sqlexec(mcon1, "select codigo, precio1, precio2, ID from tabprestaprecios " + ;
	"where codigo in (select pre_codprest from prestacions where pre_descriprest like '&mctexto')", "mwkpp")

