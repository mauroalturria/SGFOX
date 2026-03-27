Parameters tnIdInf, tcWhere

If Vartype(tcWhere) # "C"
	tcWhere = ""
Endif 

lcSql = "Select TOP 1 * from InformesLog " + ;
		"Where IdInforme = ?tnIdInf " + tcWhere + ;
		"Order by Id Desc "
		
If !Prg_EjecutoSql(lcSql, "mwkInfoLog")		
	Messagebox("ERROR DE LECTURA INFORMES - LOG",48,"VALIDACION")
	Return .F.
Endif
	
