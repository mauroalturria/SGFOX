Parameters mnreg,mbusco,tcCursor

If Vartype(mbusco)<>"C"
	mbusco= ''
ENDIF

If Vartype(tcCursor)<>"C"
	tcCursor = 'mwkregctg'
ENDIF

mfecnul = Ctod("01/01/1900")

lcSql = "select * from ZabRegContagio where RC_nroregistracio = ?mnreg and RC_fechaPasiva =?mfecnul "+mbusco+ " order by id "

If !Prg_EjecutoSql(lcSql,tcCursor,.F.)
	Return .F.
Endif
