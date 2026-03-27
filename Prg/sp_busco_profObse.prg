****
*** busca la observacion del profesional
****
lparameters mid

mret = SQLExec(mcon1,' SELECT obser FROM prestadores where id = ?mid ' , 'mwkprofObserv' )

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
endif	