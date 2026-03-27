*
* Busqueda de Especialidad y Dimension x Tema
*
Parameters mltema

If mltema = 'F' or mltema = '1'
	mwhere = " where TRE_t1preguntanro=?mi"
Else
	mwhere = " where TRE_t2preguntanro=?mi"
Endif

mret = sqlexec(mcon1,"select TRE_especialidad,TRE_dimension from " + mtabla + mwhere +;
		" and TRE_anio=?mranio and TRE_evento=?mreven","mwkveres")

If mret < 0
	Messagebox("EN CONSULTA DE ESPECIALIDAD y DIMENSION"+CHR(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
