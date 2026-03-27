*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*******************************

* Armo la Conexion a la base

		mcon1= SQLCONNECT('Conec02','_system','sys')
		
	if mcon1 < 0 
   		MESSAGEBOX("ERROR DE CONECCION,AVISAR A SISTEMAS", 16, "Validación")
   		mcon1=0
   	endif
 	