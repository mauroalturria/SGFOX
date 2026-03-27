Parameter mbusco,mcontec

*********************************************************************************
* Busco en mantenimiento las ordenes de trabajo con y sin tecnico (mcontec = .t.)
* La busqueda es por sector,tecnico,nroreclamo,fecha de ingreso,problema,estado
*********************************************************************************
mfecnull = Ctod("01/01/1900")

If mcontec
	mret =	SQLExec(mcon1,"  select sector,usuario,usufalladetec,"+;
		" TabMantEst.Descrip,FechaSolicUsu,FechaIngSolic, " +;
		" FechaTomado,fechaSolucion,Conforme,FechaPrevTecConf , TabMantenimiento.OtAdd ,  "+;
		" TabMantTecnico.apellido,TabMantTecnico.nombre,TabMantTecnico.legajo," +;
		" especialidad,ProbTec, "+;
		" Solucion, InternoTE, Prioridad,Estado, motivo,TabMantenimiento.id as idReclamo,"+;
		" UsuLog,idTiporepar,FechaSolucion  as FechaSolucion2,"+;
		" fechaprevtec,TipoDeTarea,TipoEspera,HorasEst,codigovax,"+;
		" TabMantTecnico.id as idtecnico, clasorden, fechaactivacion," +;
		" Tabmantadd.FechaHora, Tabmantadd.IdOt, Tabmantadd.Observaciones,"+;
		" NVL(TabEeAreasPlanta.nombre,'') as NombreArea,NVL(TabEeSubAreasPlanta.nombre,'') as NombreSubArea, NVL(TabEePlantasEdificio.nombre,'') as nombreplanta" + ;
		" from " +;
		" TabMantenimiento left join TabMantEst on TabMantenimiento.estado = TabMantEst.codest " +;
		" left join TabMantreparacion on TabMantreparacion.id = TabMantenimiento.idtiporepar " +;
		" left join TabMantdetTecn on TabMantdetTecn.idot = TabMantenimiento.id " +;
		" left join TabMantTecnico on TabMantTecnico.id = TabMantdetTecn.idTecnico "+;
		" and TabMantTecnico.FechaPasiva = ?mfecnull" +;
		" left join TabMantespecialidad on TabMantespecialidad.id = TabMantTecnico.id " +;
		" left join Tabmantadd on Tabmantadd.otadd = TabMantenimiento.id " +;
		" left join tabsectores on tabsectores.id = TabMantenimiento.codsector " +;
		" left join TabEeAreasPlanta on TabMantenimiento.idArea = TabEeAreasPlanta.id" + ;
		" left join TabEePlantasEdificio on TabEeAreasPlanta.IdPlanta = TabEePlantasEdificio.id" + ;
		" left join TabEeSubAreasPlanta on TabMantenimiento.idSubArea = TabEeSubAreasPlanta.id" + mbusco, "mwkMantenimiento")
Else
	mret =	SQLExec(mcon1,"  select sector,usuario,usufalladetec,"+;
		" TabMantEst.Descrip,FechaSolicUsu,FechaIngSolic, " +;
		" FechaTomado,fechaSolucion,"+;
		" ProbTec ,Solucion,InternoTE, Prioridad,Estado,"+;
		" motivo,TabMantenimiento.id as idReclamo,"+;
		" UsuLog,idTiporepar,FechaSolucion  as FechaSolucion2,"+;
		" fechaprevtec,TipoDeTarea,TipoEspera,HorasEst,codigovax,otadd,"+;
		" clasorden,fechaactivacion,Conforme,FechaPrevTecConf, " +;
		" Tabmantadd.FechaHora, Tabmantadd.IdOt, Tabmantadd.Observaciones, "+;
		" NVL(TabEeAreasPlanta.nombre,'') as NombreArea,NVL(TabEeSubAreasPlanta.nombre,'') as NombreSubArea, NVL(TabEePlantasEdificio.nombre,'') as nombreplanta" + ;
		" from " +;
		" TabMantenimiento left join TabMantEst on TabMantenimiento.estado = TabMantEst.codest " +;
		" left join TabMantreparacion on TabMantreparacion.id = TabMantenimiento.idtiporepar " +;
		" left join Tabmantadd on Tabmantadd.otadd = TabMantenimiento.id " +;
		" left join tabsectores on tabsectores.id = TabMantenimiento.codsector " + ;
		" left join TabEeAreasPlanta on TabMantenimiento.idArea = TabEeAreasPlanta.id" + ;
		" left join TabEePlantasEdificio on TabEeAreasPlanta.IdPlanta = TabEePlantasEdificio.id" + ;
		" left join TabEeSubAreasPlanta on TabMantenimiento.idSubArea = TabEeSubAreasPlanta.id" + mbusco, "mwkMantenimiento")
Endif



If mret<1
	=Aerr(eros)
	Messagebox(eros(2))
Endif
