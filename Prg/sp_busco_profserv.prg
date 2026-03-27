****
*** busca los servicios del profesional
****
lparameters mid

if mid > 0
	mret = SQLExec(mcon1,' SELECT ID , CodProf , CodServ,CodServ->ser_descripserv FROM TabProfServ ' + ;
				   		'where CodProf = ?mid ' , 'mwkprofserv' )
else
	mret = SQLExec(mcon1,' SELECT ID , CodProf , CodServ,CodServ->ser_descripserv FROM TabProfServ ' , 'mwkprofserv' )
endif
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
endif	