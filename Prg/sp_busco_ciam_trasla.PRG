*
* Busqueda de Traslados para la Derivación
*
Lparameters mbuscar

mret = sqlexec(mcon1,"select *,id as lid from TabCiamTras where TCV_idpedido = ?mbuscar"+;
	" and TCV_fechapasiva is null","mwkciamevt0")

If mret < 0
	Messagebox("EN BUSQUEDA DE EVOLUCION, EN MAESTRO DE CIAM TRASLADOS",16,"ERROR")
Endif
