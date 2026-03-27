*
* Busqueda de Planes de atención
*

mret = sqlexec(mcon1, "select * from planes  ", "mwkplanpre")

If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "ERROR")
	Do sp_desconexion with "error"
	Cancel
Endif
