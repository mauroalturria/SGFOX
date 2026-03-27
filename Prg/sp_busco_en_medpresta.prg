*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*******************************
************************************************************************************************
* Trae de medpresta el cant y porcentaje de sobre turno/oferta para modificar los parámetros
************************************************************************************************
mret=sqlexec(mcon1,"SELECT  Porcentaje, Cantidad,FechaUltAgenda " +;
				   "FROM Medpresta WHERE codmed=?mncodmed "+;
                   "GROUP BY codmed","MwkSobreT_O")

if mret < 0
	messagebox('ERROR DEL CURSOR, AVISAR A SISTEMAS',16,'Validación')
	mret=0

endif