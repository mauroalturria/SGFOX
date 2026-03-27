*********
* Busca los puestos con o sin imagen
*********
Parameters miopcion, mid

miopcion = Iif(Vartype(miopcion)="N",miopcion,0)  &&& por default sin imagen

Do Case
	Case Vartype(mid) = "N"
		lcwhere = " where id = ?mid "
	Case Vartype(mid) = "C"
		lcwhere = mid
	Otherwise
		lcwhere =''
Endcase

Do Case
	Case miopcion = 0
		mret =	SQLExec(mcon1,"select Maquina,puesto,ubicacion,observaciones,tabstpuesto.id as lid,rack"+;
			",ppuesto,pachera,idsector,imagen,nombre,idmodelo,nroserie,solicencia,estado,moffice,ooffice,officelicencia,"+;
			"interno,sdep.descripcion as descrip,tabstpuesto.id, NroConsultorio, Nvl(IdStCaja,0) as IdStCaja "+;
			" from tabstpuesto " +;
			" left join sdep On sdep.ID = tabstpuesto.idsector "+;
			lcwhere + " order by  Maquina ","mwkPuesto")
			
	Case miopcion = 1
		mret =	SQLExec(mcon1,"select Maquina,puesto,ubicacion,observaciones,id,rack"+;
			",ppuesto,pachera,"+;
			"idsector,imagen,nombre,idmodelo,nroserie,imagen2,solicencia,interno,estado,moffice,ooffice,officelicencia, " + ;
			"NroConsultorio, Nvl(IdStCaja,0) as IdStCaja "+;
			"from tabstpuesto  " + lcwhere  +" order by  Maquina ","mwkPuesto")
			
	Case miopcion = 2   && consulta para el llamador
		mret =	SQLExec(mcon1,"select id,Maquina ,NroConsultorio,interno,nombre,puesto,ubicacion "+;
			"from tabstpuesto  " + lcwhere  +" order by  Maquina ","mwkPuesto")

Endcase

If mret<1
	=Aerr(eros)
	Messagebox(eros(3))
Endif
