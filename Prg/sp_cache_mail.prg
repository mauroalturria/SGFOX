Parameters tcMail, tcAsunto, tcCuerpo

Private lcResuRef
lcResuRef = ""

*!* --------------------------------------------------------------------------- 
*!*	EJEMPLOS
*!* --------------------------------------------------------------------------- 
*!*	mcon1 = Sqlconnect("172.16.1.225")
*!*	?sp_cache_mail("gfittipaldi","Asunto","Cuerpo")
*!*	?sp_cache_mail("gfi","Asunto2","Cuerpo")

mret = SQLEXEC(mcon1, "call Rutinas_ZMAIL ?tcMail, ?tcAsunto, ?tcCuerpo, ?@lcResuRef","c1") 

If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
 	Return .f.
Endif  

If Not (lcResuRef = "1")
	lcError = Strtran(lcResuRef + " - " + Message(),"?","")
	Do Log_errores With Error(),lcError, Message(1), Program(), Lineno()
	Return .f.
Endif 	

Return .t.
