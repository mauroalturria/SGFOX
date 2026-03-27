parameters mot

*********************************************************************************
* Busco ordenes adjuntadas que no esten solucionadas
* controlo que a la que añado este solucionda,
* no debo añadir si ya fue añadida y no tuvo solucion
*********************************************************************************
mret = sqlexec(mcon1, "select  tabmantadd.otadd," +;
	" idot,fechahora,fechasolucion from  " +;
	" tabmantadd " +;
	" left join tabmantenimiento   " +;
	" on tabmantenimiento.otadd  = tabmantadd.otadd " +;
	" where  tabmantadd.otadd = ?mot and " +;
	" fechasolucion = '1900-01-01 00:00:00' ", "mwkValidAñadido" )



if mret < 0
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif





