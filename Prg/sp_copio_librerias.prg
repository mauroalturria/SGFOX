*****************************************************************
*** Fabián   
*** Marcelo 13/11/2023                                                 ***
*** Copia Archivos de FoxyPreviewer - Ghostscript - GDI++     ***
*** para frmpisos23 (Abril 2018)                              ***
*** para frmBeepers (Junio 2018)                              ***
*** para frmDocumenta1 (Abril 2019)                           ***
*****************************************************************
LPARAMETERS mivol
Local oIn

Wait 'Actualizando Archivos...' Window Nowait

cDirExeX = mivol + "\qepd1a1\ultimos\exe\"
cDirExeC = "C:\qepd1a1\Exe\"

If File(cDirExeX+"librerias.dat")

* SET STEP ON

	cContenido = Filetostr(cDirExeX+"librerias.dat")

	Alines(aXrfxlibs,cContenido,",")

*!*	Dimension aXrfxlibs(4)
*!*	aXrfxlibs(1) = "hndlib.dll"
*!*	aXrfxlibs(2) = "xfrx.app"
*!*	aXrfxlibs(3) = "xfrxlib.fll"
*!*	aXrfxlibs(4) = "zlib.dll"


	For Each oIn In aXrfxlibs

        oIn = CHRTRAN(oIn,CHR(13),"")
        oIn = CHRTRAN(oIn,CHR(10),"")

		lcdirupdate = Alltrim(cDirExeX + ALLTRIM(oIn))
		lcdirlocal = Alltrim(cDirExeC + ALLTRIM(oIn))

		lncantupdate = Adir(ladatosupd,lcdirupdate )
		lncantlocal  = Adir(ladatosloc,lcdirlocal  )

		Do Case
		Case lncantupdate = 0  &&no se encuentra el archivo en la unidad X:

		Case lncantlocal = 0 .And. lncantupdate = 1
			Copy File ( lcdirupdate ) To (lcdirlocal )
		Case lncantlocal = 1 .And. lncantupdate = 1
			If Ctot(Dtoc(ladatosupd[1,3] )+ ' ' + ladatosupd[1,4]) ;
					> Ctot(Dtoc(ladatosloc[1,3] )+ ' ' + ladatosloc[1,4])
				Copy File ( lcdirupdate ) To (lcdirlocal )

			Endif
		Endcase

	Next

Endif

