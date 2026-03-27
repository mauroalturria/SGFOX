Parameters tnOpcion, tcWhere, tcCursor

If Vartype(tcWhere) # "C"
	tcWhere = ' '
Endif

If Vartype(tcCursor) # "C"
	tcCursor= 'mwksolprac'
Endif

Do Case
Case tnOpcion = 1
	lcSql = "select TabSolPract.*,pre_descriprest,pre_codservicio,ser_descripserv "+;
		",guardia.codcie9 ,tabambulatorio.codcie9,ciapamb.descrabrev,ciapgua.descrabrev,ciappqx.descrabrev "+;
		",INS_descriinsumo,tabambulatorio.centromedico,Tabpqx.PQ_coddiag     "+;
		" from TabSolPract  " + ;
		" left join prestacions on ASP_codprest = pre_codprest "+;
		" left join insumos on ASP_codprest = INS_codpuntero "+;
		" left join tabambulatorio on ASP_protocolo = tabambulatorio.protocolo "+;
		" left join tabciap2e ciapamb on tabambulatorio.codcie9 = ciapamb.id "+;
		" left join guardia on ASP_protocolo = guardia.protocolo "+;
		" left join tabpqx on ASP_protocolo = tabpqx.id "+;
		" left join tabciap2e ciapgua on guardia.codcie9 = ciapgua.id "+;
		" left join tabciap2e ciappqx on Tabpqx.PQ_coddiag = ciappqx.id "+;
		" left join servicios on pre_codservicio = ser_codserv "+;
		tcWhere
Otherwise
	lcSql =''
Endcase
If !Prg_EjecutoSql(lcSql,tcCursor,.F.)
	Return .F.
Endif
