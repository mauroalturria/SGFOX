*********************************************************************************
* BUSCA PRESTACIONES EXCLUSIONES
*********************************************************************************
LPARAMETERS mbusco
IF VARTYPE(mbusco) #'C'
	mbusco = " Prestacions.PRE_fechapasiva IS NULL " 
else
	mbusco  = mbusco + " and Prestacions.PRE_fechapasiva IS NULL " 
ENDIF
mret = sqlexec(mcon1,"select PRX_PRESTACIONS,PRX_codprestexcluy ,PRE_codprest, PRE_descriprest,"+;
	" PRE_codservicio, PRE_especialidad " + ;
	" FROM Prestexcluy  " + ;
	" inner join PRESTACIONS on Prestacions.PRE_codprest = PRX_codprestexcluy" + ;
	" where "+mbusco , "mwkprestexc")
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
endif

