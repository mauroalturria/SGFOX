lparameters lcUndd, lcOrigen
if parameters() <= 0
	lcOrigen = "\\172.16.1.1\NOVELL"
	lcUndd   = "H:"
Endif 
objNetwork = CreateObject("Wscript.Network")  
objNetwork.MapNetworkDrive(lcUndd, lcOrigen,0)

release objNetwork
objNetwork = .f.
