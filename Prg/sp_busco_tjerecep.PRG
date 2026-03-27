PARAMETERS mvale 

lcSql = "select ID from TabJERecep where TJE_CodVale = ?mvale and tje_estado = 5"

If !Prg_EjecutoSql(lcSql,"mwkValeAnato","")
	Return .F.
ENDIF