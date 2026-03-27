*!*	PUBLIC oadj 
*!*	oadj = NEWOBJECT("adjuntos")
*!*	?oadj.mcon1
*!*	?"-----------"
*!*	oadj.Subir(19, "c:\wamp64\www\intranet\lanzador\prog\wanato\files\cruz_roja.png" )

DEFINE CLASS adjuntos AS Session OLEPUBLIC

mcon1 = 0

PROCEDURE Init
	This.mcon1 = SQLCONNECT("Conec01")
ENDPROC

PROCEDURE Subir(tnId, tcFile)

CREATE CURSOR cfile ( c1 m)
APPEND BLANK
replace c1 WITH FILETOSTR(tcFile)

IF UPPER(RIGHT(tcFile,4)) = '.PDF'
	met = SQLEXEC(This.mcon1,"Update informes set informePDF = ?cfile.c1, informePDFGenerado = 1, FechaAprobacion = current_date where id = ?tnId")
ELSE
	met = SQLEXEC(This.mcon1,"Update informes set informe = ?cfile.c1, , FechaAprobacion = current_date where id = ?tnId")
ENDIF 	
	
	RETURN (met)
ENDPROC 


PROCEDURE Destroy
	SQLDISCONNECT(This.mcon1)
ENDPROC

PROCEDURE Error(nError, cMethod, nLine)
	?nError
	?cMethod
	?nLine
ENDPROC

ENDDEFINE
