lparameters lcUndd, lcOrigen,lcrecon,lcuser,lcpass,mret

if parameters() <= 0
	lcOrigen = "\\172.16.5.46\H"
	lcUndd   = "T:"
Endif 
lcErrorAnt = ON("ERROR")
on error =aerr(eros)
objNetwork = CreateObject("Wscript.Network")  
*messagebox('Conecto Wscript.Network '+lcUndd  )  &&-*/-*/
if vartype(lcuser)="C"
	objNetwork.MapNetworkDrive(lcUndd, lcOrigen,lcrecon,lcuser,lcpass)
else
	objNetwork.MapNetworkDrive(lcUndd, lcOrigen,0)
endif
on error
if vartype(eros)="N"
	strtofile(eros(2)+chr(10)+eros(3),"C:\error.txt")
endif
release objNetwork
On Error &lcErrorAnt
objNetwork = .f.
