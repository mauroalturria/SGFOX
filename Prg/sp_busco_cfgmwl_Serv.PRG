*!*	?sp_busco_cfgmwl_serv(7700)
Parameters tnCodServ, tcCursor

If Vartype(tcCursor)#"C"
	tcCursor = "mwkMWLCFG"
Endif 

lcSql = "Select SER_ModAgrupa, SER_Modalidad From Servicios Where Ser_CodServ = ?tnCodServ "

Return prg_ejecutosql(lcSql, tcCursor, .t.)
