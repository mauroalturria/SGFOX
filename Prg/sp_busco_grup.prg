*********************************************************************************
* BUSCA Datos de grupos
*********************************************************************************

lparameters midGrup

mRet = sqlexec(mcon1,"select * from TabGcgrupo "+ iif(empty(midGrup),"","where IdGrupo = " + midGrup)+;
	" order by descr"  ,"mwkGrupo" )
	
If mRet<=0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Else
	Return .T.
Endif
	
*!*	if mret < 0
*!*		=aerr(eros)
*!*		messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
*!*		mret=0
*!*		cancel
*!*	endif
