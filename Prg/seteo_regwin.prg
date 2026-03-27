Set Escape Off
_Screen.Visible = .f.

Wait wind "Registrando el inicio" NoWait

WshShell = CreateObject("WScript.shell") 
WshShell.RegWrite ("HKLM\Software\Microsoft\Windows\CurrentVersion\Run\sglauncher", "c:\qepd1a1\Exe\icono_launcher.exe")

Wait Clear