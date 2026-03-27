
do sp_conexion

mret = SQLExec(mcon1,"select ser_codserv,ser_descripserv, scv_mnemonico, ser_ambulatorio, ser_internacion " + ;
				   		"from servicios, servcargval " + ;
				   		"where ser_fechapasiva is null and " + ;
				   		"ser_codserv = scv_codservicio and scv_mnemonico is not null " + ;
				   		"order by ser_descripserv", "mwkservicio1" )		
				   		
=sqldisconnect(mcon1)				   		