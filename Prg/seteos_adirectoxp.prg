lparameters lcNombre, lcRuta, lcHoyKey, lcDirWork

_screen.visible = .f.
set escape off

if parameters() < 3
	lcHoyKey = ""
	lcDirWork = ""
endif

*!*	if parameters() <= 0
*!*		lcNombre = "mi ejemplo"
*!*		lcRuta   = "%windir%\\notepad.exe\"
*!*		lcHoyKey = "ALT+CTRL+F"
*!*		lcDirWork = ""
*!*	endif

if parameters() <= 0
	lcNombre = "Lanzador"
	lcRuta   = "c:\qepd1a1\Exe\launc_app.exe"
	lcHoyKey = ""
	lcDirWork = "c:\qepd1a1\Exe\"
endif
set safety off
wait windows "Borrando Ejecutables" nowait
	cfiles = "C:\Qepd1a1\Exe\*.exe"
	adir(mima,cfiles)
	ncantfiles = alen(mima,1)
	for i=1 to ncantfiles
		if lower(mima(i,1)) # "icono_launcher.exe"
			on error =aerr(eros)
			cfil = 'C:\Qepd1a1\Exe\'  + mima(i,1)
			wait windows cfil nowait
			delete file (cfil )
			on error 			&& devuelve el control del error al sistema
		endif
	endfor
messagebox( "Borró Ejecutables" )
wait windows "Borrando Nombres" nowait
	cfiles = "C:\Qepd1a1\Exe\Nombres\*.avi"
	adir(mima,cfiles)
	ncantfiles = alen(mima,1)
	for i=1 to ncantfiles
		on error =aerr(eros)
		cfil = 'C:\Qepd1a1\Exe\Nombres\'  + mima(i,1)
		wait windows cfil nowait
		delete file (cfil )
		on error 			&& devuelve el control del error al sistema
	endfor
messagebox( "Borró Nombres" )
wait windows "Borrando INI" nowait
	cfiles = "C:\Qepd1a1\Exe\Inicio\ini*.*"
	adir(mima,cfiles)
	ncantfiles = alen(mima,1)
	for i=1 to ncantfiles
		on error =aerr(eros)
		cfil = 'C:\Qepd1a1\Exe\Inicio\'  + mima(i,1)
			wait windows cfil nowait
		delete file (cfil )
		on error 			&& devuelve el control del error al sistema
	endfor
wait windows "Borrando INI" nowait
	cfiles = "C:\Qepd1a1\xlt\*.*"
	adir(mima,cfiles)
	ncantfiles = alen(mima,1)
	for i=1 to ncantfiles
		on error =aerr(eros)
		cfil = 'C:\Qepd1a1\xlt\'  + mima(i,1)
			wait windows cfil nowait
		delete file (cfil )
		on error 			&& devuelve el control del error al sistema
	endfor
messagebox( "Borró Plantillas" )
set safety on

wait wind "Generando icono ..." nowait

WshShell = createobject("WScript.shell")
strDesktop = wshShell.SpecialFolders(0)
oMyShortCut = WshShell.CreateShortcut(strDesktop+"\\" + lcNombre+ " .lnk")
oMyShortCut.WindowStyle = 3
*oMyShortCut.IconLocation = "c:\\fox.ico\"
oMyShortCut.WorkingDirectory = lcDirWork
oMyShortCut.TargetPath = lcRuta
oMyShortCut.hotkey = lcHoyKey
oMyShortCut.save

wait clear

