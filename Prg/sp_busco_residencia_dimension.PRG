*
* Busqueda de dimensiones
*

mret = sqlexec(mcon1,"select distinct(TRE_dimension) as Nombre from "+mtabla+;
	" where TRE_anio=?mranio and TRE_evento=?mreven","mwkdistdim")

If mret < 0
	Messagebox("EN BUSQUEDA DE DIMENSIONES"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
