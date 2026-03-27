****
** Busco todos los cambios de camas del pacientes internados desde una fecha determinada
****

parameter mfecha 


mret = sqlexec(mcon1, "select *, {fn hour(lug_horaingreso)}  as horaingreso "+;
	" from pacinternad,lugarintern " + ;
	"where pacinternad.pin_codadmision = lugarintern.lug_pacientes " + ;
	" and lug_fechaingreso>= ?mfecha and LUG_fechaegreso is not null ", "mwkcamas")
msql_hab = "select lug_fechaingreso, left(ttoc(lug_horaingreso, 2), 5) as hora, "+;
	" lug_categoria, lug_codsector, lug_habitacion, lug_cama,lug_pacientes "+;
	",lug_habitacion+' -'+ lug_cama as cama "+;
	" from mwkcamas order by lug_pacientes,lug_fechaingreso,lug_horaingreso "+;
	" into cursor mwkcamas1"
&msql_hab
