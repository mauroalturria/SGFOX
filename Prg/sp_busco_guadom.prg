Parameters tnRegistra, mbusca,mcursor
If Vartype(mcursor)<>"C"
	mcursor = "mwkguadom"
Endif
If Vartype(mbusca)<>"C"
	mbusca = ''
Endif
lcSql = "SELECT ID , CodAmbito , FecHorDbAdd , FecHorDbUpd , UserDbAdd , UserDbUpd ,"+;
	" codent , codestado , codprest , diagnostico , fechahoraate , fechahoraing ,"+;
	" nroregistrac , protocolo FROM  ZabGuardiaDom"+;
	" where nroregistrac = ?tnRegistra "+mbusca
If !prg_ejecutosql(lcSql, mcursor )
	Return .F.
Endif

