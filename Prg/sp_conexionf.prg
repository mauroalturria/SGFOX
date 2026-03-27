*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*******************************

* Armo la Conexion a la base
	if messagebox('CONEXION 1 (Real)?',292,'CONEXION')=6
		mcon1= sqlconnect('Conec01','_system','sys')
	else
		mcon1= sqlconnect('Conec5','_system','sys')
	endif
	
	if mcon1 < 0
		messagebox("ERROR DE CONEXION,AVISAR A SISTEMAS", 16, "Validación")
		mcon1=0
	endif

