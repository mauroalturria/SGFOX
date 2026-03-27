
Define Class report2pdf As Custom

	Protected cError
	Protected cFile
	Protected cReporte
	Protected lcDir

*-------------------------------------------------------
	Protected Procedure Init

		This.ClearErrors()
		This.cError = ""
		This.cFile = ""
		This.cReporte = ""
		This.lcDir = ""

		Endproc

*-------------------------------------------------------
	Procedure SetNombrePDF(cPDF)

	cPDF = Alltrim(Upper(cPDF))

	This.cFile = "c:\Temp\" + cPDF

	Endproc

*-------------------------------------------------------
	Procedure SetNombreRep(cREP)

	This.cReporte = cREP

	Endproc

*-------------------------------------------------------
	Function GetNombrePDF()

	Return This.cFile


*-------------------------------------------------------
	Function Imprime()

	Local blResultado

	blResultado = .T.
	mintento = 1
	mpaso = .T.

	Do While .T.
		lconerror = On("error")
		On Error *
		mloSession = xfrx("XFRX#INIT")
		On Error &lconerror
		If Vartype(mloSession) = "O"
*=Fput(mgf,"creo mlosession, intento "+Alltrim(Str(mintento)))
			Exit
		Else
*=Fput(mgf,"No creo mlosession, intento "+Alltrim(Str(mintento)))
			=Aerror(mlerror)
			Do log_errores With Error(), mlerror(3), Message(1), Program(), Lineno()
			If  Messagebox("NO PUEDE CREARSE EL OBJETO xrfx PARA GENERAR EL ARCHIVO PDF."+Chr(10)+;
					"RECUERDE AVISAR A SISTEMAS, INTENTA DE NUEVO ?",4+48,"ATENCION") = 7
				mpaso = .F.
				Exit
			Endif
		Endif
		mintento = mintento + 1
	Enddo

	If mpaso

		mlnRetval  = mloSession.SetParams(This.cFile,,.T.,,,,"PDF")
*=Fput(mgf,"asigno mloSession.SetParams valor, intento "+Alltrim(Str(mintento)) + ", valor de retorno "+Alltrim(Str(mlnRetval)))

		If mlnRetval = 0
			blResultado = mloSession.ProcessReport(This.cReporte)

			If blResultado
				mtlPrintDocument  = .F.
				mtlModifyDocument = .F.
				mtlCopyTextAndGraphics    = .F.
				mtlAddOrModifyAnnotations = .F.
				mloSession.setPermissions(mtlPrintDocument,;
					mtlModifyDocument,;
					mtlCopyTextAndGraphics,;
					mtlAddOrModifyAnnotations)
**mloSession.finalize()

				loXFF = mloSession.finalize()

				If !loXFF .Or. sp_devuelve_sizefile(Alltrim(This.cFile)) <= 10000
					mlnRetval = -1
					This.cError = This.cError + "EL ARCHIVO NO TIENE EL TAMAÑO REQUERIDO." + Chr(10)
				Else

				Endif
			Else
				Messagebox("Hubo errores, no se pudo generar el archivo PDF." + Chr(10)+ "Verifique que exista el reporte : " + Chr(10) + This.cReporte,16,"ATENCION")
			Endif


		Else
			This.cError = This.cError + "No pudo crearse el Archivo : " + This.cFile
		Endif

	Endif

	Release mloSession

	Return Empty(This.cError)

	Endfunc


* -----------------------------------------------------------
	Function SolicitaDir(cDir)

	Local lcDir

	cDir = Iif(Empty(cDir),"C:\Temp\",cDir)

	lcDir = Getdir(cDir,"Seleccione donde guardar","Archivo PDF")
	If Empty(lcDir)
		Return .F.
	Endif

	This.lcDir = lcDir

	Return .T.

	Endproc

* -----------------------------------------------------------
	Procedure Ejecuta()

	Local oObj

	oObj = Createobject("Shell.Application")
	oObj.ShellExecute("C:\Program Files (x86)\Google\Chrome\Application\chrome.exe", This.cFile, "", "open", 1)

	Endproc

* -----------------------------------------------------------
	Procedure ClearErrors()}

	This.cError = ""

	Endproc


* -----------------------------------------------------------
	Function Tiff2bmp(mcImagenTif)

** Marcelo Torres, 20/04/2017
** La libreria para exportar a PDF no muestra las firmas en Tiff. Por eso las convierto a BMP.

*Lparameters mcImagenTif

	Local cDestino

	cDestino = ""

	If File(mcImagenTif)

		cDestino = Substr(mcImagenTif,1,Len(mcImagenTif)-4)

		oImg = Newobject("GpImage","_gdiplus.vcx")


		With oImg
			.CreateFromFile(mcImagenTif)
			.SaveToFile(cDestino +".bmp","image/bmp")
		Endwith

		cDestino = cDestino + ".bmp"

	Endif

	Return cDestino

	Endfunc


Enddefine
