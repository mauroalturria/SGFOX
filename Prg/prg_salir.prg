If Messagebox("¿ DESEA SALIR DEL SISTEMA ? ", 4 + 32 +256,"PREGUNTA") = 7
	Return .f.
Endif 

If !sp_logoff()
	Return .f.
Endif 

On Shutdown

Clear Events

