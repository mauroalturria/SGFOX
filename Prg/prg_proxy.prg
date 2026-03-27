Local WshShell && as WScript.shell
WshShell = CreateObject("WScript.shell") 

subclave = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
clave = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ProxyOverride"

lnActivo = WshShell.regread(subclave + "\ProxyEnable")
If lnActivo = 1
	lcaCambiar = WshShell.regread(subclave + "\ProxyOverride")
	If Not "172.16.*" $ lcaCambiar
		lcaCambiar = "172.16.*;" + lcaCambiar
	Endif 
	WshShell.RegWrite(subclave + "\ProxyOverride",lcaCambiar,"REG_SZ" )
Endif 	

Release WshShell