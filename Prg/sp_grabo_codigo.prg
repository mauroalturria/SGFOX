****
** inserto datos de codigos
****
parameter mopcion, mlegajo,mapellido,mnombre,mcodigo
mfecha = ttod(mwkfecserv.fechahora)
mret = sqlexec(mcon3, "insert into codigos (codigo , legajo , fecha , "+;
		" apellido , nombre  )"+;
		" values(?mcodigo , ?mlegajo , ?mfecha , ?mapellido , ?mnombre  )")
if mret < 1
	=aerr(eros)
	messagebox('ERROR EN EL INGRESO, REINTENTE O AVISE A SISTEMAS', 64,'Validacion')
endif
