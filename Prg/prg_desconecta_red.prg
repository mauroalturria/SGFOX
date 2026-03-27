lparameters lcUndd,lDOS

if parameters() <= 0
	lcUndd   = "T:"
Endif
lcErrorAnt = ON("ERROR")
on error =aerr(eros)
if vartype(lDOS)="N"
*	messagebox('Desconecto X por DOS con '+"net use "+lcUndd+" /DELETE /Y" )  &&-*/-*/
	wait windows "Un momento... DOS se esta Desconectando a la unidad de red... " nowait
	micmd = "net use "+lcUndd+" /DELETE /Y"
	run /2 &micmd 
	wait clear
else
*	messagebox('Desconecto X por Wscript.Network '+lcUndd  )  &&-*/-*/
	objNetwork = createobject("Wscript.Network")
	objNetwork.RemoveNetworkDrive(lcUndd,.t.)
	release objNetwork
	objNetwork = .f.
endif
On Error &lcErrorAnt