***BUSCA LAS FORMAS DE PAGO
*!*
lcSql = ''
ldNullDate = Ctod("")

*Text To lcSql Noshow Textmerge Pretext 7
lcSql = "Select * from ZabFormaPago "
*Endtext

If !prg_ejecutosql(lcSql, "mwkformapago")
	Return .F.
Endif

