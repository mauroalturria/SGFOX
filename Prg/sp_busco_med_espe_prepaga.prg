****
** Busco medicos dada una especialidad
****

parameter mcodesp
mfecnul = ctod("01/01/1900")
mfechas= sp_busco_fecha_serv('DD')+ 1
mret = sqlexec(mcon1," select idprestador, nombre "+;
	" from atenciones, prestaciones, especialid, prestadores    "+;
	" where (fecpasivap = ?mfecnul or fecpasivap > ?mfechas) and atenciones.idprestacion = prestaciones.id "+;
	" and idprestador=prestadores.id and idespecialidad =?mcodesp "+;
	" group by nombre " + ;
	" ORDER BY Nombre", "mwkmedicos")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",48,"Validacion")
	mret=0
	cancel
endif
