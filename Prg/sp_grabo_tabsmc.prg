Parameter msugerencias, mtipo, mcodmed 

mfechahora = sp_busco_fecha_serv('DT')
mret = SQLExec(mcon1,"insert into Tabsmc (codmed,fechahora,sugerencias,tipo) values(?mcodmed,?mfechahora,?msugerencias,?mtipo)")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	mret=0
else
	messagebox("SU SUGERENCIA HA QUEDADO REGISTRADA... GRACIAS POR SU COLABORACION.",64, "Mejora Continua")
endif