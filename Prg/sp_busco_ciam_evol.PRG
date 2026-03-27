*
* Busqueda de Evoluciones para una Derivacion - CIAM
*

Lparameters mbuscar

mret = sqlexec(mcon1,"select *,id as lid from TabCiamEvol where TCV_idpedido = ?mbuscar"+;
	" and TCV_fechapasiva is null","mwkciamev0")

If mret < 0
	Messagebox("EN BUSQUEDA DE EVOLUCION, EN MAESTRO DE CIAM EVOLUCIONES",16,"ERROR")
Endif
