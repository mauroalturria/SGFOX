*
* Busqueda de un Video tutorial
*
Lparameters midvideo

If used('mwkvideot')
	Use in mwkvideot
Endif

mret = sqlexec(mcon1,"select tema,subnivel from TabDocGral where id=?midvideo","mwkvideot")

If mret < 0
	Messagebox("EN BUSQUEDA DE UN VIDEO TUTORIAL"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
Endif
