****
** Listado estadistico para Morgulis primero disponible, cantidad ocupados, libres
****

parameter mfecha1, mfecha2

mret = sqlexec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	' where id<100000 order by fechacierre ','mwkctrlfecha')
go bottom in mwkctrlfecha
mfechalimite = mwkctrlfecha.fechacierre
use in mwkctrlfecha

mret = sqlexec(mcon1, "select fechatur, turnos.tipoturno, ESP_descripcion, pre_descriprest " + ;
	"from turnos, especialid, prestacions  " + ;
	"where trim(turnos.codesp) = trim(especialid.ESP_codesp) and " + ;
	"turnos.codprest = prestacions.pre_codprest and " + ;
	"afiliado > 0 and tipoturno < 9 and " + ;
	"fechatur >= ?mfecha1 and fechatur <= ?mfecha2", "mwktodosa")

if mfecha1 <= mfechalimite
	mret = sqlexec(mcon1, "select fechatur, turnos.tipoturno, ESP_descripcion, pre_descriprest " + ;
		"from turnoshis as turnos, especialid, prestacions  " + ;
		"where trim(turnos.codesp) = trim(especialid.ESP_codesp) and " + ;
		"turnos.codprest = prestacions.pre_codprest and " + ;
		"afiliado > 0 and tipoturno < 9 and " + ;
		"fechatur >= ?mfecha1 and fechatur <= ?mfecha2", "mwktodosb")
	if mret < 0
		messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
		cancel
	else
		select * from mwktodosa ;
			union all ;
			select * from mwktodosb ;
			into cursor mwktodos

		select ESP_descripcion, pre_descriprest, fechatur, tipoturno, ;
			count(tipoturno) as tomados ;
			from mwktodos ;
			group by ESP_descripcion, pre_descriprest, fechatur, tipoturno ;
			order by ESP_descripcion, pre_descriprest, fechatur, tipoturno ;
			into cursor mwklista
	endif
else
	if used('mwktodosa')
		select ESP_descripcion, pre_descriprest, fechatur, tipoturno, ;
			count(tipoturno) as tomados ;
			from mwktodosa ;
			group by ESP_descripcion, pre_descriprest, fechatur, tipoturno ;
			order by ESP_descripcion, pre_descriprest, fechatur, tipoturno ;
			into cursor mwklista
	endif
endif

