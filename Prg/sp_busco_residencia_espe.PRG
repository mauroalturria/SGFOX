*
* Busqueda de distintas especialidades
*

mret = sqlexec(mcon1,"select distinct(TRE_especialidad) as Nombre from "+mtabla+;
	" where TRE_anio=?mranio and TRE_evento=?mreven","mwkdistesp")

If mret < 0
	Messagebox("EN BUSQUEDA DE ESPECIALIDAD"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
