PARAMETERS mcodigoproc,mdenominacion

   	mret = sqlexec(mcon1,"SELECT * FROM TabGcproc WHERE  codigoproc = ?mcodigoproc"+;
   						 " and denominacion = ?mdenominacion ","mwkMaxId")
if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	mret=0
	cancel
endif