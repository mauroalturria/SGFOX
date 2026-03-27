****
*** busca los servicios
****

mret = SQLExec(mcon1,'SELECT ser_codserv, ser_descripserv ' + ;
				   		'FROM servicios where ser_fechapasiva is null and ser_descripserv is not null ' + ;
				   		'order by ser_descripserv', 'mwkservicio' )

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	DO sp_desconexion WITH "error"
	CANCEL
endif	