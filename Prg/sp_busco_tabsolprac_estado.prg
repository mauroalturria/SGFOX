Parameters tnreg,tnprot

lcSql = "select ASP_codestado from TabSolPract where ASP_nroregistrac = ?tnreg and ASP_protocolo=?tnprot "+;
	" group by ASP_protocolo,ASP_codestado order by ASP_codestado "

If !Prg_EjecutoSql(lcSql,"MwksolPest",.F.)
	Return 0
ELSE
	SELECT  MwksolPest 
	go top
	Return MwksolPest.ASP_codestado
Endif
