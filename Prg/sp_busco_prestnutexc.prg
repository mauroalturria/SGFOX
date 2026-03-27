*********************************************************************************
* BUSCA PRESTACIONES DE NUTRICION PARA EXCLUIR
*********************************************************************************
mret = sqlexec(mcon1,"select TabNutPrest.*,PRX_codprestexcluy  " + ;
	" FROM TabNutPrest inner join Prestexcluy on PRX_PRESTACIONS = TNP_codPrest " + ;
	" inner join PRESTACIONS on Prestacions.PRE_codprest = TNP_codPrest " + ;
	" union all "+;
	"select TabNutPrest.*,PRX_codprestexcluy  " + ;
	" FROM TabNutPrest inner join Prestexcluy on PRX_codprestexcluy = TNP_codPrest " + ;
	" inner join PRESTACIONS on Prestacions.PRE_codprest = TNP_codPrest "+;
	" where TNP_dieta < 6 and Prestacions.PRE_fechapasiva IS NULL " , "mwkprestexc")
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
endif

