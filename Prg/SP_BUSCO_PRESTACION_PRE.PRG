******
** Busco Prestaciones
******
parameters mbusco,mfechad,mfechah,mbusca

if vartype(mbusca) # "C"
	mbusca = " and tabpestado.tipo < 2"
endif

if  INLIST(mwkexe.nomexe,'PISOS','PRESUPUESTOS','ADMISION')
	msec = " and sectorefec <> 'AMB' "
else
	msec = " and sectorefec = 'AMB' "
endif
mfecnull = CTOD("01/01/1900")
msec = msec+" and (tabpresupuestos.fecpasiva is null or tabpresupuestos.fecpasiva = ?mfecnull) "
msec= msec+" and (tabpdetpresupuesto.fecpasiva is null or tabpdetpresupuesto.fecpasiva = ?mfecnull) "

mfechad = iif(empty(mfechad), ctod('01/001/1900'),mfechad)
mfechah = iif(empty(mfechah ),ctod('01/01/2100'),mfechah)
mret = sqlexec(mcon1,"SELECT paciente,nroafiliado,ent_descrient,descserv,pre_descriprest,"+;
	"tabpestado.descripcion as estado,tabpresupuestos.id,estadoactual, TabPConce.concepto ,valorfechaprog,"+;
	"INS_descriinsumo,nroregistrac,fechasolic,Remitente,cpdetalle,observaciones,observa2,"+;
	"tabpresupuestos.estado as papel,tipopres, tabpestado.tipo,DescripExce,diasvto "+;
	" FROM tabpresupuestos "+;
	" join tabpestado on tabpestado.id = tabpresupuestos.estadoactual" + mbusca +;
	" left join tabpdetpresupuesto on tabpdetpresupuesto.idDetp = tabpresupuestos.id" + ;
	" left join tabpcpago on tabpcpago.id = tabpresupuestos.CondPago"+;
	" left join tabpMODULO on tabpMODULO.id = tabpresupuestos.IDMODULO" +;
	" left join prestacions on tabpdetpresupuesto.idPreOCon = pre_codprest"+;
	" left join TabPConce on tabpdetpresupuesto.idPreOCon = TabPConce.id "+;
	" left join INSUMOS on INSUMOS.INS_codPuntero = tabpdetpresupuesto.idPreOCon"+;
	" left join TabPExcedente on tabpdetpresupuesto .idPreOCon = TabPExcedente.id  "+;
	" left join entidades on entidades.ent_codent = tabpresupuestos.entidad"+;
	" where " + mbusco +;
	" and fechasolic>=?mfechad and fechasolic<=?mfechah " + msec ,"mwkEstadoPres")

if mret < 0
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif
