parameters mbuscar

mret = sqlexec(mcon1,"SELECT paciente,nroafiliado,ent_descrient,pre_descriprest,descserv,"+;
	"tabpestado.descripcion as estado,tabpresupuestos.id,estadoactual, TabPConce.concepto ,INS_descriinsumo "+;
	" FROM tabpresupuestos "+;
	" left join tabpdetpresupuesto on tabpdetpresupuesto idDetp = tabpresupuestos.id "+;
	" left join prestacions on tabpresupuestos.idPreOCon = prestacions .pre_codprest  "+;
	" left join TabPConce on tabpresupuestos.idPreOCon = TabPConce.id "+;
	" left join INSUMOS on tabpresupuestos.idPreOCon = IINSUMOS .NS_codinsumo "+;
	" left join entidades on entidades .ent_codent = tabpresupuestos.entidad "+;
	" left join  tabpestado  on tabpestado.id = tabpresupuestos . estadoactual "+;
	" where UPPER(descserv) like  '%" + mbuscar + "%'" ,"mwkEstadoPres")


if mret < 0
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif