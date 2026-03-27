Parameters tnreg,tncodesp

 tnfec = sp_busco_fecha_serv("DD")-365
lcSql = " SELECT  id,SL_cantidad , SL_codesp , SL_codmedSol , SL_fechasol , SL_limite , SL_nroregistrac "+;
	" FROM ZabSolLimite where SL_nroregistrac = ?tnreg and SL_codesp =?tncodesp  and SL_limite>=SL_cantidad "+;
	" and SL_fechasol >= ?tnfec order by SL_fechasol  "
	 
If !Prg_EjecutoSql(lcSql,"Mwksollimite",.F.)
	Return 0
Endif
 