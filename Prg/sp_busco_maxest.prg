****
** Busco estado actual
****
parameters mid

*mret = sqlexec(mcon1, "select max(fecha),descripcion  from TabPPreDetEst  inner join tabpestado on tabpestado.id = idesta where idPres = ?mId " , "mwkEstActual")

mret = sqlexec(mcon1," select idEsta,descripcion,idpres "+;
	" from TabPPreDetEst "+;
	" inner join tabpEstado on tabpEstado.id = TabPPreDetEst.idEsta  "+;
	" where fecha = ( select max(fecha) from TabPPreDetEst) and idpres = ?mId",'mwkEstActual')
if reccount('mwkEstActual') = 0
	mret = sqlexec(mcon1," select idEsta,descripcion,idpres "+;
		"from TabPPreDetEst inner join tabpEstado "+;
		"on tabpEstado.id = TabPPreDetEst.idEsta  "+;
		"where  idpres = ?mId",'mwkEstActual')
endif


if mret < 0
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif


