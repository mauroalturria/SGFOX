Parameters tcUrl,Tbrun

Private loBrowser
loBrowser= ""
If PARAMETERS()<2
	Tbrun = .T.
Endif
If Tbrun
	oShell = Createobject("WScript.Shell")
	oShell.Run(tcUrl,1,.F.)
	oShell = .F.
Else
	If !prg_valido_explorer(@loBrowser)
		oShell = Createobject("WScript.Shell")
		oShell.Run(tcUrl,1,.F.)
		oShell = .F.
	Else
		loBrowser.Navigate(tcUrl)
		loBrowser.Visible=.T.
		Release loBrowser
	Endif
Endif
