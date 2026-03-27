PARAMETERS lnOpcion, tcUrl


*!*	tcUrl = "http://172.16.1.200/intranet/lanzador/Prog/wanato/entregas_anato.php?lhash=dmFsZT0zNjI5OTM2NQ"
*!*	lnOpcion = 2

LOCAL lbError, lnSalir, lnSalir
lnSalir = 0
lnOrig = lnOpcion 

LOCAL oShell as WScript.Shell

DO WHILE .t.
	
	lbError = .F.

		
	DO CASE
	CASE lnOpcion = 1
		lcProgram = "firefox.exe"
	CASE lnOpcion = 2
		lcProgram = "chrome.exe"
	CASE lnOpcion = 3
		lcProgram = "iexplore.exe"
	OTHERWISE
		lcProgram = ""
	ENDCASE

	TRY  
		oShell = Createobject("WScript.Shell")
		oShell.Run(lcProgram + " " + tcUrl,1,.F.)
		oShell = .F.
	CATCH TO oError
		lbError = .t.
	ENDTRY 

	IF lbError
		IF lnOpcion = lnOrig 
			lnSalir = lnSalir + 1 
			IF lnSalir = 2
				EXIT 
			ENDIF 
		ENDIF 

		lnOpcion = lnOpcion + 1
		IF lnOpcion > 4
			lnOpcion = 1
		ENDIF 
		
		LOOP
	ENDIF 
	
	EXIT 
ENDDO 