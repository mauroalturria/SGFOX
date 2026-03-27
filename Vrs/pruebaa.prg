local lnError 
lnError = 0
erase eros
on error =aerr(eros)
do sp_conexion
on error 
if type("eros")#"U"
	do errhand(error(), message(), message(1), program(), lineno() )
	return
endif

erase eros
on error =aerr(eros)
cSource= SQLGETPROP(mcon1, "ConnectTimeOut")
on error 
if type("eros")#"U"
	do errhand(error(), message(), message(1), program(), lineno() )
	return
endif

MESSAGEBOX("Time out actual = "+str(cSource),0,"Resultados de la conexión")
set step on

procedure errhand(nERROR, cMESSAGE, cMESSAGE1, cPROGRAM, nLINENO)
	messagebox(;
		'Número de error:		' + alltrim(str(nERROR)) + chr(13) + ;
		'Mensaje de error:		' + cMESSAGE + chr(13) + ;
		'Línea de código con error:	' + cMESSAGE1 + chr(13) + ;
		'Número de línea del error:	' + alltrim(str(nLINENO)) + chr(13) + ;
		'Programa con error:		' + cPROGRAM,48,"Error")
	resume
endproc		