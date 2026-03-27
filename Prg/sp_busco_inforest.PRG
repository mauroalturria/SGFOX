*
* Busqueda del Estado acorde a tipo Entraga = 1, Recibe = 2
*
Lparameters mopcion

If used("mwkestado")
	Use in mwkestado
Endif

mret = sqlexec(mcon1,"select id as lid from TabEstados where propietario = 11"+;
	" and subestado=?mopcion","mwkestado")
If mret < 0
	Messagebox("EN BUSQUEDA DE ESTADOS"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
Endif
