*
* Esquemas de Farmacia, Prestaciones Oncología
*

Use in select("mwkpre")
Use in select("mwkesq")

mret = sqlexec(mcon1,"select PRE_descriprest,PRE_codprest"+;
	" from PRESTACIONS where PRE_codservicio = 1130"+;
	" and PRE_codprest not in (select TFE_codprest from TabFarmEsq"+;
	" where TFE_fechapasiva is NULL)","mwkpre")

If mret < 0
	Messagebox("EN CONSULTA DE PRESTACIONES SERVICIO ONCOLOGIA",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif

mret = sqlexec(mcon1,"select TFE_esquema,TFE_codprest,TFE_formula,"+;
	" TFE_prequimio,id as lid from TabFarmEsq"+;
	" where TFE_codprest in (select PRE_codprest from PRESTACIONS"+;
	" where PRE_codservicio = 1130) and TFE_fechapasiva is NULL"+;
	" and TFE_formula > 0","mwkesq")

If mret < 0
	Messagebox("EN CONSULTA DE ESQUEMAS FARMACIA",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif

Return .T.
** Eof() **
