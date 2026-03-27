**
*
*

parameter mret, mwktabla

	if mret < 0
		messagebox('ERROR EN LA GENERACION DEL CURSOR, AVISE A SISTEMAS', 48,'Validacion')
		DO sp_desconexion WITH "Error"
		cancel
	endif