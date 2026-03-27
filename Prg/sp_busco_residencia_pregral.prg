*
* Busqueda de preguntas Residencias por especialidad y dimension
*

mpasa = .T.

Use in select("mwkgesp")

mret = sqlexec(mcon1,"select distinct(TRE_especialidad) as especialidad,count(*) as preguntas"+;
	" from TabResExa"+;
	" where TRE_anio=?mranio and TRE_evento=?mreven group by TRE_especialidad","mwkgesp")

If mret < 0
	mpasa = .F.
	Messagebox("CONSULTA DE PREGUNTAS POR ESPECIALIDAD"+chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
	Do log_errores with error(), message(), message(1), program(), lineno()
Endif

Use in select("mwkgdim")

mret = sqlexec(mcon1,"select distinct(TRE_dimension) as dimension,count(*) as preguntas"+;
	" from TabResExa" +;
	" where TRE_anio=?mranio and TRE_evento=?mreven group by TRE_dimension","mwkgdim")

If mret < 0
	mpasa = .F.
	Messagebox("CONSULTA DE PREGUNTAS POR DIMENSION"+chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
	Do log_errores with error(), message(), message(1), program(), lineno()
Endif

Return mpasa


