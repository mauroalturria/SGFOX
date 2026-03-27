*********
* Busco Bolsas para la Cirugia
*********

lparameters codcir,codser
mfecnull = ctod("01/01/1900")
mret = sqlexec(mcon1,"SELECT ccb_CodigoBolsa,ID  "+;
	" FROM Tabcpcirbol where CCB_fechapasiva= ?mfecnull and CCB_cirugia = ?codcir " +;
	" and CCB_servicio = ?codser " ,"mwkbolsacirser")
if mret < 1
	=aerr(eros)
	messagebox(eros(3)+'AVISE A SISTEMAS', 64,'Validacion')
endif

