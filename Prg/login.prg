* Este programa deberá verificar la Paswords y devolverle 
* a la pantalla de logeo .T. o .F.
Parameters mUsuario,mPassword
*public SQLPasword
	* conectar a cache
	* mret3= sqlexec(mconEsp,SQLPasword,"mwkUser")
	* if mret3 > 0
		* ejecuto SQL para buscar la password
	 	*if !eof(mwkusuario)
	 	**************************
	 	**************************
	 	**************************
	 		*mEsUsurio = .T.
	 		do inicio
	 	*else
		 	*mEsUsurio = .F.
		*	messagebox("El Usuario o la Password no es Valida",0+64,"No Login"	 	
		 *endif	
	 *else
	*	messagebox("ERROR DE CONECCION AVISAR A SISTEMAS",0+64,"No Login"	 		 	

	*endif		

Function Cubre
*	Esta  será la función de encriptación de Datos
end function

Procedure ValidoPass
Parameters Campo1, Campo2, tabla1
*Armo SQLPasword, donde Palabra es parametro de Login.prg
usuario= Campo1
pasword= campo2
TBLogin= tabla1
SQLPasword="SELECT &usuario, &Pasword FROM &TBLogin WHERE &Pasword= " + Palabra + ";"   
