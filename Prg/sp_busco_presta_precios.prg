****
** busco prestaciones en tabprestaprecios
****

parameter mopcion,mctexto
IF mopcion = 1
	mret = sqlexec(mcon1, "select codigo, precio1, precio2, ID from tabprestaprecios " + ;
		"where codigo in (select pre_codprest from prestacions where pre_descriprest like '&mctexto')", "mwkpp")

ELSE
	mret = sqlexec(mcon1, "select codigo, precio1, precio2,pre_descriprest,pre_codservicio,FecHorDbUpd  from tabprestaprecios " + ;
		"INNER join prestacions on codigo=pre_codprest", "mwkpp")

ENDIF