*
* Busqueda de Productos Trazados
*
Lparameters mgtin, mserie, mtratip, mwhere

use in select("mwkgtintra")

mret = sqlexe(mcon1,"select * from TabTraMov"+;
		" where TTM_gtin = ?mgtin"+; 
		" and TTM_serie = ?mserie"+;
		" and TTM_tipomov = ?mtratip" + mwhere,"mwkgtintra")
		
If mret < 0
	Messagebox("Error al Localizar Movimiento",26,"Error")
	On error Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif

Return .T.