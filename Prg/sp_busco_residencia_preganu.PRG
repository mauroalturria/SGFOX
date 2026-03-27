*
* Busqueda de Preguntas anuladas
*

mret = sqlexec(mcon1,"select * from TabResAnu"+;
	" where TRA_tema=?mbusanu and TRA_anio=?mranio and TRA_evento=?mreven","mwkrespanu")

If mret < 0
	Messagebox("EN BUSQUEDA DE PREGUNTAS ANULADAS",16,"ERROR")
Endif
