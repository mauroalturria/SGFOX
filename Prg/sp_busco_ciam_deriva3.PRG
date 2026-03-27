*
* Busqueda de derivacion CIAM / CUD, x Nro. Derivación (ID)
*

Lparameters mbuscar

mret = sqlexec(mcon1,"select TabCiamDeriva.ID as Nropedido,*"+;
	" from TabCiamDeriva where TabCiamDeriva.ID = ?mbuscar","mwkbderiva")

*!*	" and TCD_fechapasiva is null","mwkbderiva")


If mret < 0
	Messagebox("EN BUSQUEDA DE REGISTRO, EN MAESTRO DE DERIVACIONES",16,"ERROR")
Endif
