Lparameters tbPruebaError

If tbPruebaError
	On error Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .t.
Endif 

If _Vfp.StartMode = 0 
	On error 
Else
	On error Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
Endif 
