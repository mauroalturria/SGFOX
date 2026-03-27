Parameters tnidquiro

lcSql = "SELECT PQQ_quirofano FROM Tabpqquiro WHERE  PQQ_referencia = ?tnidquiro "+;
	" group PQQ_referencia  "

If !Prg_EjecutoSql(lcSql,"Mwkpqquiro",.F.)
	Return 0
ELSE
	SELECT  Mwkpqquiro
	go top
	Return Mwkpqquiro.PQQ_quirofano 
Endif
