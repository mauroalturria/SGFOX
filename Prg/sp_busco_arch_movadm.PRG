*
* Busqueda de Movimientos de Historias según código de admisión
*
Lparameters mcadm

If used('mwkmovadm')
	Use in mwkmovadm
Endif

mret = sqlexec(mcon1,"SELECT * from TabHCImovst where hcmnroadm=?mcadm","mwkmovadm")

If mret < 0
	Messagebox("EN BUSQUEDA DE MOVIMIENTOS PARA EL CODIGO DE ADMISION"+chr(10)+;
	"AVISE A SISTEMAS",16,"ERROR")
Endif

