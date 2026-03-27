***
***  busqueda de motivos
***
mret = sqlexec(mcon1,"select id, descrip, sector from tabmotivos " + ;
	" where sector = 0 and id <100000 order by descrip", "mwkmotivos")

mret = sqlexec(mcon1,"select descrip, id, sector from tabmotivos " + ;
	" where sector = 1 and id <100000 order by descrip", "mwkmotCose")
if mret < 0

	messagebox("ERROR EN LA GENERACION DEL CURSOR", 48, "Validacion")
	cancel
endif	
