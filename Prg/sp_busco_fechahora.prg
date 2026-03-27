****
** busco fecha hora del ultimo listado de archivo
****

parameter mfecha

mret = sqlexec(mcon1, 'select fecha, hora from tabfechora where fecha = ?mfecha order by hora desc' , 'mwkfechora')

if mret < 0

	messagebox('ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS',16,'Validacion')
	cancel
endif