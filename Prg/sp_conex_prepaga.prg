****
*   Conexion a Cache namespace Prepaga
* 
*******************************

	mcon1= SQLCONNECT('Conec03','_system', 'sys')
	
	if mcon1 < 0 
   		MESSAGEBOX("ERROR DE CONECCION, AVISAR A SISTEMAS", 16, "Validación")
   		cancel
   	endif
 	