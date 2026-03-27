****
*** busca los servicios del profesional
****
lparameters mid

mret = SQLExec(mcon1,' SELECT ID , CodProf , CodServ,CodServ->ser_descripserv FROM TabServProf ' + ;
				   		'where CodProf = ?mid ' , 'mwkservprof' )

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	DO sp_desconexion WITH "error"
	CANCEL
endif	