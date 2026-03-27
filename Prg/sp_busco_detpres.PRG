****
** Busco Detalle de lpresupuesto
****
Lparameters mbusfec,mbusca, mbusco,mpasivo

If Vartype(mbusca) # "C"
	mbusca = " and tabpestado.tipo < 2"
Endif
If Vartype(mpasivo)#"N"
	mpasivo = 0
Endif
If Vartype(mbusfec) <> 'C'
	mbusfec=''
Endif

If Vartype(mbusco) <> 'C'
	mbusco = ''
Endif
mfecnull = Ctod("01/01/1900")
mbusfec = mbusfec+" and (tabpresupuestos.fecpasiva is null or tabpresupuestos.fecpasiva = ?mfecnull) "
If mpasivo = 0
	mbusfec = mbusfec+" and (tabpdetpresupuesto.fecpasiva is null or tabpdetpresupuesto.fecpasiva = ?mfecnull) "
Endif

If  Inlist(mwkexe.nomexe,'PISOS','PRESUPUESTOS','ADMISION')
	msec = " and sectorefec <> 'AMB' "
Else
	msec = " and sectorefec = 'AMB' "
Endif

mret = SQLExec(mcon1,"SELECT paciente , nroafiliado , ent_descrient , sectorsol , "+;
	" tabpModulo.descripcion as modulo, observaciones,observa2 , cpdetalle , tabpresupuestos.id ,"+;
	" estadoActual  , tabpestado.descripcion as estado,entidad,Fechasolic,nroregistrac,"+;
	" tabpresupuestos.estado as papel,fechasolic, Remitente,tabpresupuestos.idmodulo,moneda,valorfechaprog"+;
	",diasvto,tabpdetpresupuesto.iddetp as idctrl,TabPConce.concepto,tabpestado.tipo,tabpdetpresupuesto.fecpasiva "+;
	" FROM tabpresupuestos "+;
	" join tabpestado on tabpestado.id = tabpresupuestos.estadoactual " + mbusca + ;
	" left join entidades on ent_codent = entidad "+;
	" left join tabpcpago on tabpcpago.id = CondPago "+;
	" left join tabpdetpresupuesto on tabpdetpresupuesto.iddetp = tabpresupuestos.id"+;
	" left join tabpMODULO on tabpMODULO.id = tabpresupuestos.IDMODULO "+;
	" left join TabPConce ON  tabpdetpresupuesto .idPreOCon = TabPConce.id    "+;
	" where nroafiliado is not null" + msec + mbusfec + mbusco ,"mwkEstadoPres")

If mret < 0
	Messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
Endif
