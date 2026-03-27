*
* Verificar si se actualizaron movimientos
*
Lparameters mnroadm,mfechaIngr

If used('mwkbmova')
	Use in mwkbmova
Endif

mret = sqlexec(mcon1,"select * from TabHCIMovst"+;
	" where hcmnroadm=?mnroadm and hcmfechaIngr=?mfechaIngr ","mwkbmova")

If mret < 0
	Messagebox("EN BUSQUEDA DE MOVIMIENTOS ACTUALIZADOS"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
