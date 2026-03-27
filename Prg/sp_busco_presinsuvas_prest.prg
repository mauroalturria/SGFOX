****
** busco prestaciones de un vale con descripcion
****
lparameters mcodpun

mret = sqlexec(mcon1, "SELECT presinsuvas.*, Pre_Descriprest  " + ;
			"FROM presinsuvas " + ;
			"Inner join Prestacions on Pre_CodPrest = Pia_CodPrest " + ;
			"where pia_valesasist = ?mcodpun " + ;
			" ", "mwkpresinpre")

if mret < 0
	=aerr(eros)
	messagebox(eros(3)) 
endif	
