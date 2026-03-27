*
* Captura de error 1429, ( usuario aborta envio de mail x OutLook
*
=aerror(merror)
mlerror = merror(1)
If mlerror <> 1429
	msgerror = merror(3)
	Messagebox(msgerror,16,"ERROR")
Endif
Release merror
mret1 = 0
Return
