****
** Tablas Altas para Ambulatorio
****


mret = sqlexec(mcon1,"select descrip, id, sector,tipoest from tabtipoaltas " + ;
	"where (sector <3 or sector = 7 ) and id<100000 and ambito in (2,3) " + ;
	"order by descrip", "mwktaltas")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR", 48, "Validacion")
	cancel
endif