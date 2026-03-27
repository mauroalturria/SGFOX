*****************************************************************
*** Fabián                                                    ***
*** Copia Archivos de FoxyPreviewer - Ghostscript - GDI++     ***
*** para frmpisos23 (Abril 2018)                              ***
*** para frmBeepers (Junio 2018)                              ***
*** para frmDocumenta1 (Abril 2019)                           ***
*****************************************************************

Wait 'Actualizando Archivos...' Window Nowait

* Dado que por algún motivo no se pueden poner en el directorio exe
* Car dijo de ponerlos en bmp

* GHOSTSCRIPT
If !Directory("c:\Qepd1a1\Exe\Bin")
	Mkdir "c:\Qepd1a1\Exe\Bin"
* Determino si el OS es de 32/64 Bits
	If Directory("c:\windows\syswow64")
* 64 Bits
*		Copy File "x:\qepd1a1\Ultimos\Exe\gs922w64.exe" To "c:\Qepd1a1\Exe\Bin\gs922w64.exe"
		If File("x:\qepd1a1\Ultimos\bmp\gsdll64.dll")
			Copy File "x:\qepd1a1\Ultimos\bmp\gsdll64.dll" To "c:\Qepd1a1\Exe\Bin\gsdll64.dll"
		Endif
		If File("x:\qepd1a1\Ultimos\bmp\gsdll64.lib")
			Copy File "x:\qepd1a1\Ultimos\bmp\gsdll64.lib" To "c:\Qepd1a1\Exe\Bin\gsdll64.lib"
		Endif
		If File("x:\qepd1a1\Ultimos\bmp\gswin64.exe")
			Copy File "x:\qepd1a1\Ultimos\bmp\gswin64.exe" To "c:\Qepd1a1\Exe\Bin\gswin64.exe"
		Endif
		If File("x:\qepd1a1\Ultimos\bmp\gswin64c.exe")
			Copy File "x:\qepd1a1\Ultimos\bmp\gswin64c.exe" To "c:\Qepd1a1\Exe\Bin\gswin64c.exe"
		Endif
	Else
* 32 Bits
*	Copy File "x:\qepd1a1\Ultimos\Exe\gs922w32.exe" To "c:\Qepd1a1\Exe\Bin\gs922w32.exe"
		If File("x:\qepd1a1\Ultimos\bmp\gsdll32.dll")
			Copy File "x:\qepd1a1\Ultimos\bmp\gsdll32.dll" To "c:\Qepd1a1\Exe\Bin\gsdll32.dll"
		Endif
		If File("x:\qepd1a1\Ultimos\bmp\gsdll32.lib")
			Copy File "x:\qepd1a1\Ultimos\bmp\gsdll32.lib" To "c:\Qepd1a1\Exe\Bin\gsdll32.lib"
		Endif
		If File("x:\qepd1a1\Ultimos\bmp\gswin32.exe")
			Copy File "x:\qepd1a1\Ultimos\bmp\gswin32.exe" To "c:\Qepd1a1\Exe\Bin\gswin32.exe"
		Endif
		If File("x:\qepd1a1\Ultimos\bmp\gswin32c.exe")
			Copy File "x:\qepd1a1\Ultimos\bmp\gswin32c.exe" To "c:\Qepd1a1\Exe\Bin\gswin32c.exe"
		Endif
	Endif
Endif

* GHOSTSCRIPT VIEWJPEG
If !File("c:\Qepd1a1\Exe\Bin\viewjpeg.ps")
	If File("x:\qepd1a1\Ultimos\bmp\viewjpeg.ps")
		Copy File "x:\qepd1a1\Ultimos\bmp\viewjpeg.ps" To "c:\Qepd1a1\Exe\Bin\viewjpeg.ps"
	Endif
Endif

* SYSTEM.APP (GDI++)
If !File("c:\Qepd1a1\Exe\system.app")
	If File("x:\qepd1a1\Ultimos\BMP\system.app")
		Copy File "x:\qepd1a1\Ultimos\BMP\system.app" To "c:\Qepd1a1\Exe\system.app"
	Else
		Messagebox("No se puede copiar el archivo. LLamar a Sistemas",0,'System.app')
	Endif
Endif

* FOXYPREVIEWER
If !File("c:\Qepd1a1\Exe\FoxyPreviewer.app")
	If File("x:\qepd1a1\Ultimos\BMP\FoxyPreviewer.app")
		Copy File "x:\qepd1a1\Ultimos\BMP\FoxyPreviewer.app" To "c:\Qepd1a1\Exe\FoxyPreviewer.app"
	Else
		Messagebox("No se puede copiar el archivo. LLamar a Sistemas",0,'FoxyPreviewer')
	Endif
Endif

If !File("c:\Qepd1a1\Exe\FoxyPreviewer_settings.dbf")
	If File("x:\qepd1a1\Ultimos\BMP\FoxyPreviewer_settings.dbf")
		Copy File "x:\qepd1a1\Ultimos\BMP\FoxyPreviewer_settings.dbf" To "c:\Qepd1a1\Exe\FoxyPreviewer_settings.dbf"
	Else
		Messagebox("No se puede copiar el archivo. LLamar a Sistemas",0,'FoxyPreviewer')
	Endif
Endif

If !File("c:\Qepd1a1\Exe\libhpdf.dll")
	If File("x:\qepd1a1\Ultimos\BMP\libhpdf.dll")
		Copy File "x:\qepd1a1\Ultimos\BMP\libhpdf.dll" To "c:\Qepd1a1\Exe\libhpdf.dll"
	Else
		Messagebox("No se puede copiar el archivo. LLamar a Sistemas",0,'FoxyPreviewer')
	Endif
Endif