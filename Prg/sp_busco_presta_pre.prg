*****
** Busca prestaciones
****
parameters mbuscar

msec = " and sectorefec = '"+iif(mwkexe.nomexe='PRESUPUESTOS','FAC','AMB')+"' "

mret = sqlexec(mcon1,"SELECT descserv,paciente,nroafiliado,ent_descrient,pre_descriprest,"+;
	"tabpestado.descripcion as estado,tabpresupuestos.id,estadoactual, TabPConce.concepto ,INS_descriinsumo "+;
	" FROM tabpresupuestos "+;
	" left join prestacions on tabpresupuestos.idPreOCon = prestacions.pre_codprest  "+;
	" left join TabPConce on tabpresupuestos.idPreOCon = TabPConce.id "+;
	" left join INSUMOS on tabpresupuestos.idPreOCon = INS_codinsumo "+;
	" left join tabpdetpresupuesto on tabpresupuestos.idDetp = tabpresupuestos.id "+;
	" left join entidades on entidades.ent_codent = tabpresupuestos.entidad "+;
	" left join  tabpestado  on tabpestado.id = tabpresupuestos . estadoactual "+;
	" where UPPER(descserv) like  '%" + mbuscar + "%'" + msec ,"mwkEstadoPres0")

if mret < 0
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif
select paciente,nroafiliado,ent_descrient,;
	padr(iif(tipopres = 2,nvl(pre_descriprest,''),;
	iif(tipopres = 3,nvl(INS_descriinsumo,''),nvl(concepto,''))),250) as descserv;
	,estado,id,estadoactual  ;
	from mwkEstadoPres0 into cursor mwkEstadoPres0
