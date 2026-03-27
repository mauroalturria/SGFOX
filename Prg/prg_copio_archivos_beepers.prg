*****************************************************************
* Fabián                                                    				
* Copia Archivos de FoxyPreviewer - GDI++ 
* para frmBeepers (Febrero 2020)                              		
*****************************************************************

Wait 'Actualizando Archivos para beepers...' Window Nowait

* Dado que por algún motivo no se pueden poner en el directorio exe
* Car dijo de ponerlos en bmp

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
