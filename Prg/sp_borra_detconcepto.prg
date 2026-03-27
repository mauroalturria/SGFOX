lparameters mid
*mccodigo,mcodconce 			
mret = sqlexec(mcon1, " delete from tabprconce where id = ?mid ")
*ccodigo = ?mccodigo and codconce = ?mcodconce 

if mret < 0
	=aerr(eros)
	messagebox(eros(3))
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif