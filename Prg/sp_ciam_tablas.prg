*
* Tabla entidades
*

Use in select("mwkentidad2")

mret = sqlexec(mcon1,"select ENT_codent, ENT_descrient,ENT_capita from entidades" + ;
	" where ENT_fecpas is null and (ENT_turnoshabilit is null or ENT_turnoshabilit <> 'S')" + ;
	" order by ENT_descrient", "mwkentidad2")

If mret < 0
	Messagebox("EN LA GENERACION - AUXILIAR ENTIDADES, AVISAR A SISTEMAS",16, "ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif

Return .T.
