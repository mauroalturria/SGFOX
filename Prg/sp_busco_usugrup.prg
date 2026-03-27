
lparameters midUsu


*********************************************************************************
* BUSCA Datos de grupos autoriazados a ver ciertos codumentos
*********************************************************************************
	mret = sqlexec(mcon1,"select * from TabGcusugrup"+;
						 " where idusuario = ?midUsu and fecactiva <>   to_date('01/01/1900','dd/mm/yyyy') ","mwkUsuGrup" )
if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	mret=0
	cancel
endif