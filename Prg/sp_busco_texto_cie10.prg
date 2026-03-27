****
** busco texto de diagnostico en Tabcie10
****

parameter mbusco1, msql_tex_cie10,mqbus,lsolocie10, tbSinXX 

if vartype(mbusco1)="C"
	if type('mqbus')#"N"
		mqbus = 1
	Endif
	
	lcBuscaSinXX = ''
	If tbSinXX
		lcBuscaSinXX = " and Trim(codcie10) not in ('XX1', 'XX2', 'XX3') "
	Endif 

	
	lbuscie = iif(vartype(lsolocie10)<>"N",''," and tipo = "+transf(lsolocie10))
	ccampo = iif(mqbus = 1," descrip "," codcie10 ")
	mret = sqlexec(mcon1, "select codcie10 ,descrip, id,tipo from tabcie10 " + ;
		"where (&ccampo like '&mbusco1' or codcie10 like 'XX%' ) "+;
		lbuscie + lcBuscaSinXX, "mwkbustexcie101")

	msql_tex_cie10 = "select * from mwkbustexcie101 order by descrip into cursor mwkbustexcie10"
else
	mret = sqlexec(mcon1, "select codcie10 ,descrip, id,tipo from tabcie10 "  , "mwkbuscie10")
endif