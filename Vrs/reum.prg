****
** Listado estadistico para Morgulis primero disponible, cantidad ocupados, libres
****
mfecdes =ctod("01/12/2004")
mfechas =ctod("01/01/2005")

	mret = sqlexec(mcon1, "select fechatur, codmed, nombre,turnos.codesp, confirmado "+ ;
		"from turnoshis as turnos, prestadores " + ;
		"where turnos.codmed = prestadores.id and " + ;
		"fechatur >= ?mfecdes and fechatur < ?mfechas and " + ;
		"turnos.tipoturno < 9 " + ;
		"", "mwktodosb")

	if mret < 0
		=aerr(eros)
		messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
		cancel
	endif
select codmed,nombre,month(fechatur) as mes,count(confirmado) as pacientes ;
	from mwktodosb where codesp in ("REUM","REUI") and confirmado=1 ;
	group by codmed,codesp into cursor cursor12
	
	
	
	