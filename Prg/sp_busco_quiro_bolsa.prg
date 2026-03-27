*********
* Busco Bolsas de Cirugia
*********
mfecnull = ctod("01/01/1900")

mret = sqlexec(mcon1,"SELECT CodBolsa, Descripcion"+;
	" FROM Cprecir where FechaPasiva is null" +;
	" order by Descripcion " ,"mwkbolsacir")
if mret < 1
	=aerr(eros)
	messagebox(eros(3)+'AVISE A SISTEMAS', 64,'Validacion')
endif

