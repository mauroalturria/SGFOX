****************************************************************************************************************************
**************************** Consulto la tabla Tabmltarealivia, que es el maestro de tareas livianas ***********************
****************************************************************************************************************************
mret = SQLEXEC(mcon1,"select * from Tabmltarealivia " ,"mwkTareaLiv")
if mret < 0
	=aerr(eros)
	messagebox(eros(3))
endif