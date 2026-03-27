Lparameters xlncmed,xlcvar
mimed = xlncmed
lcSql = "select * from tabusuario where idcodmed = ?mimed "
tcCursor = 'mwkusumed'
If !Prg_EjecutoSql(lcSql,tcCursor,.F.)
	Return .F.
Endif
mivar = 'mwkusumed'+'.'+Alltrim(xlcvar)
Return &mivar
