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
	lcparam  = "W95"
	lcDirWork = "c:\qepd1a1\Exe\"
endif
wait wind "Generando icono ..." nowait

WshShell = createobject("WScript.shell")
strDesktop = wshShell.SpecialFolders(0)
oMyShortCut = WshShell.CreateShortcut(strDesktop+"\\" + lcNombre+ " .lnk")
oMyShortCut.WindowStyle = 3
oMyShortCut.Arguments = lcparam 
oMyShortCut.WorkingDirectory = lcDirWork
oMyShortCut.TargetPath = lcRuta
oMyShortCut.hotkey = lcHoyKey
oMyShortCut.save

wait clear

