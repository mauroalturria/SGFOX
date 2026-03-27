*********************************************************************************
* BUSCA PRESTACIONES ASOCIADAS
*********************************************************************************
LPARAMETERS mbusco

IF VARTYPE(mbusco) #'C'
	mbusco = " Prestacions.PRE_fechapasiva IS NULL " 
else
	mbusco  = mbusco + " and Prestacions.PRE_fechapasiva IS NULL " 
Endif

lcSql = "select PRA_PRESTACIONS,PRA_codprestasocia, " + ;
	"PRE_codprest, PRE_descriprest,"+;
	" PRE_codservicio, PRE_especialidad " + ;
	" FROM PRESTASOCIA  " + ;
	" inner join PRESTACIONS on Prestacions.PRE_codprest = PRA_codprestasocia " + ;
	" where " + mbusco
	
If !Prg_EjecutoSql(lcSql, "mwkprestasoc")
	Return .f.
Endif 
	
