****
** Busco del Maestro de  Detalle del Presupuesto
**
** mtipo = 0 Presup. Fact.
** mtipo = 1 Ambos ( Fact. & Amb. )
** mtipo = 2 Presup. Amb.
**
****
Lparameters mdesde, mhasta, mopcion, mbusca

If vartype(mbusca) # "C"
	mbusca = " and tabpestado.tipo < 2"
Endif

If vartype(mopcion)#"N"
	mopcion = 0
Endif

if  INLIST(mwkexe.nomexe,'PISOS','PRESUPUESTOS','ADMISION')
	msec = " and sectorefec <> 'AMB' "
else
	msec = " and sectorefec = 'AMB' "
endif

mfecnull = CTOD("01/01/1900")
msec = msec+" and (tabpresupuestos.fecpasiva is null or tabpresupuestos.fecpasiva = ?mfecnull) "
msec= msec+" and (tabpdetpresupuesto.fecpasiva is null or tabpdetpresupuesto.fecpasiva = ?mfecnull) "
Do case
Case mopcion = 1 && Prestaciones con deri
	mret = sqlexec(mcon1,"SELECT paciente,nroafiliado,ent_descrient,sectorsol,"+;
		"tabpModulo.descripcion as modulo,observaciones,observa2,cpdetalle,Tabpresupuestos.id,"+;
		"estadoActual,tabpestado.descripcion as estado,entidad,Fechasolic,nroregistrac,"+;
		"tabpresupuestos.estado as papel,fechasolic, Remitente,Tabpresupuestos.idmodulo,moneda,"+;
		"Tabpdetpresupuesto.descserv,Tabpdetpresupuesto.precio,valorfechaprog,tabpestado.tipo,diasvto "+;
		" FROM Tabpdetpresupuesto,Tabpresupuestos,TabPPrestDer"+;
		" join tabpestado on tabpestado.id=tabpresupuestos.estadoactual" + mbusca +;
		" left join entidades on entidades.ent_codent=Tabpresupuestos.entidad"+;
		" left join tabpcpago on tabpcpago.id=Tabpresupuestos.CondPago"+;
		" left join tabpMODULO on tabpMODULO.id=tabpresupuestos.IDMODULO"+;
		" where nroafiliado is not null"+;
		" and Tabpresupuestos.Id=TabPPrestDer.PDIdPresu" + ;
		" and Tabpresupuestos.Id=Tabpdetpresupuesto.iddetp"+;
		" and Tabpresupuestos.fechasolic >= ?mdesde and Tabpresupuestos.fechasolic <= ?mhasta"+;
		" and Tabpdetpresupuesto.tipopres=2 " + msec,"mwkEstadoPres")

Otherwise && Honorarios Prof. Adicionales
	mret = sqlexec(mcon1,"SELECT paciente,nroafiliado,ent_descrient,sectorsol,"+;
		"tabpModulo.descripcion as modulo,observaciones,observa2,cpdetalle,Tabpresupuestos.id,"+;
		"estadoActual,tabpestado.descripcion as estado,entidad,Fechasolic,nroregistrac,"+;
		"tabpresupuestos.estado as papel,fechasolic, Remitente,Tabpresupuestos.idmodulo,moneda,"+;
		"Tabpdetpresupuesto.descserv,Tabpdetpresupuesto.precio,valorfechaprog,tabpestado.tipo,diasvto"+;
		" FROM Tabpdetpresupuesto,Tabpresupuestos"+;
		" join tabpestado on tabpestado.id=tabpresupuestos.estadoactual " + mbusca +;
		" left join entidades on entidades.ent_codent=Tabpresupuestos.entidad "+;
		" left join tabpcpago on tabpcpago.id=Tabpresupuestos.CondPago"+;
		" left join tabpMODULO on tabpMODULO.id=Tabpresupuestos.IDMODULO"+;
		" where nroafiliado is not null"+;
		" and Tabpresupuestos.Id=Tabpdetpresupuesto.iddetp"+;
		" and Tabpresupuestos.fechasolic >= ?mdesde and Tabpresupuestos.fechasolic <= ?mhasta"+;
		" and Tabpdetpresupuesto.tipopres=4" + msec,"mwkEstadoPres")

Endcase

If mret < 0
	Messagebox("ERROR EN CONSULTA DE PRESUPUESTOS"+chr(10)+;
		"AVISE A SISTEMAS", 16, "Validación")
Endif


