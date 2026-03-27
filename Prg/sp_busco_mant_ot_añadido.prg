parameters mot

*********************************************************************************
** Busco ordenes que fueron adjuntadas
*********************************************************************************

mret = sqlexec(mcon1, "select  idot,fechahora,observaciones,fechasolucion from " +;
	" tabmantadd " +;
	" left join tabmantenimiento on tabmantenimiento.id = tabmantadd.idot " +;
	" where tabmantadd.otadd = ?mot ", "mwkOtadd" )


if mret < 0
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif
