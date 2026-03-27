*********************************************************************************
* BUSCA PRESTACIONES ASOCIADAS
*********************************************************************************
LPARAMETERS mbusco,mbusco1

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

lcSql = "select PRA_PRESTACIONS,PRA_codprestasocia, " + ;
	"PRE_codprest, PRE_descriprest,"+;
	" PRE_codservicio, PRE_especialidad " + ;
	" FROM PRESTASOCIA  " + ;
	" inner join PRESTACIONS on Prestacions.PRE_codprest = PRA_codprestasocia " + ;
	" where " + mbusco +;
		" Union " + ;
	"select PRA_PRESTACIONS,PRA_codprestasocia, " + ;
	"PRE_codprest, PRE_descriprest,"+;
	" PRE_codservicio, PRE_especialidad " + ;
	" FROM PRESTASOCIA  " + ;
	" inner join PRESTACIONS on Prestacions.PRE_codprest = PRA_codprestasocia " + ;
	" where " + mbusco1 
If !Prg_EjecutoSql(lcSql, "mwkprestasoc")
	Return .f.
Endif 
	
