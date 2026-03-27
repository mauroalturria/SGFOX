*********************************************************************************
* BUSCA PRESTACIONES EXCLUSIONES
*********************************************************************************
*********************************************************************************
* BUSCA PRESTACIONES EXCLUSIONES
*********************************************************************************
LPARAMETERS mbusco, mbusco1
IF VARTYPE(mbusco) #'C'
	mbusco = " Prestacions.PRE_fechapasiva IS NULL " 
else
	mbusco  = mbusco + " and Prestacions.PRE_fechapasiva IS NULL " 
Endif

IF VARTYPE(mbusco1) #'C'
	mbusco1 = " Prestacions.PRE_fechapasiva IS NULL " 
else
	mbusco1  = mbusco1 + " and Prestacions.PRE_fechapasiva IS NULL " 
Endif

mret = sqlexec(mcon1,"select PRX_PRESTACIONS,PRX_codprestexcluy ,PRE_codprest, PRE_descriprest,"+;
	" PRE_codservicio, PRE_especialidad " + ;
	" FROM Prestexcluy  " + ;
	" inner join PRESTACIONS on Prestacions.PRE_codprest = PRX_codprestexcluy " + ;
	" where " + mbusco +  ;
	" Union " + ;
	"select PRX_PRESTACIONS,PRX_codprestexcluy ,PRE_codprest, PRE_descriprest, "+;
	" PRE_codservicio, PRE_especialidad " + ;
	" FROM Prestexcluy  " + ;
	" inner join PRESTACIONS on Prestacions.PRE_codprest = PRX_codprestexcluy " + ;
	" where " + mbusco1 + ;
	"", "mwkprestexc")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	Return .f.
endif


