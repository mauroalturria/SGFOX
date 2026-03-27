parameters midOt
*********************************************************************************
* Busco tecnicos asigandados a las ordenes
*********************************************************************************

mfecnull = ctod("01/01/1900")

mret = sqlexec(mcon1,"select legajo ,apellido,fechahoraAsig,"+;
	"FechaHoradesasig,comentario,comentariodesasig,nombre,idtecnico,"+;
	"especialidad,TabMantdettecn.id,idOt,idespecialidad  "+;
	" from TabMantdettecn left join tabmanttecnico"+;
	" on tabmanttecnico.id = TabMantdettecn.idtecnico "+;
	" and TabMantTecnico.FechaPasiva = ?mfecnull "+;
	" left join tabmantespecialidad on tabmantespecialidad.id = tabmanttecnico.Idespecialidad " +;
	" Where idot=?midOt","mwkMantdetTecnico")
if mret < 1
	=aerr(eros)
	messagebox('ERROR EN EL INGRESO, REINTENTE O AVISE A SISTEMAS', 64,'Validacion')
endif

