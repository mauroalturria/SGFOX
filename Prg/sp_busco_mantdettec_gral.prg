*
* Busqueda de Ordenes x Tecnico/Gral y margen de Fechas
*
Lparameters mwhere

mfecnull = ctod("01/01/1900")

If used('mwkMantdetTecnico')
	Use in mwkMantdetTecnico
Endif

mret = sqlexec(mcon1,"select legajo,apellido,fechahoraAsig,FechaHoradesasig,comentario," +;
	"comentariodesasig,nombre,idtecnico,especialidad,TabMantdettecn.id,idOt,idespecialidad," +;
	" TabMantenimiento.ProbTec,TabMantenimiento.Sector,Tabmantenimiento.id as nroorden ,UsuFallaDetec "+;
	" from TabMantdettecn left join tabmanttecnico on tabmanttecnico.id = idtecnico" +;
	" and TabMantTecnico.FechaPasiva = ?mfecnull "+;
	" left join Tabmantenimiento on Tabmantenimiento.id = TabMantdettecn.idOt"+;
	" left join tabmantespecialidad on tabmantespecialidad.id = Idespecialidad " +;
	mwhere+" order by apellido,fechahoraAsig","mwkMantdetTecnico")


If mret < 0
	Messagebox("EN CONSULTA DE TAREAS x TECNICO"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Else
	Select * from mwkMantdetTecnico	where len(alltrim(nvl(apellido,'')))>0 into cursor mwkMantdetTecnico
Endif

