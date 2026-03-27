PARAMETERS lcWhere, tcCurName

If Vartype(tcCurName) <> "C"
	tcCurName = "mwkPuesto"
Endif 

lcWhere = iif(empty(lcWhere),'',lcWhere)
mret =	sqlexec(mcon1,"select Maquina,puesto,ubicacion,observaciones,id,rack,ppuesto,pachera,"+;
					  " IdSector,imagen,nombre,idModelo,nroserie,imagen2 "+;
                      " from tabStPuesto  " + lcWhere  +" order by  Maquina ",tcCurName)

If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
 	Return .f.
Endif 

