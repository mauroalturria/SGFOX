Select controlconv
Scan
	lcodigopractica = ''
	lcimporteCobertura = ''
	lcimportePaciente =''
	lcpracticaSinCargo = ''
	lcpracticaConvenida = ''
	micod = controlconv.codigo
	mient = controlconv.ent
	WAIT windows TRANSFORM(RECNO()) nowait
	mresp = prg_preciosap(mient,micod,@lcimporteCobertura,@lcimportePaciente ,@lcpracticaSinCargo ,@lcpracticaConvenida )
	If  Empty(mresp ) Or At('mensaje',mresp)>0
		lcpracticaConvenida ='E'
	Endif

	Select controlconv
	Replace Conv With lcpracticaConvenida
Endscan
Select controlcon
Scan
	lcodigopractica = ''
	lcimporteCobertura = ''
	lcimportePaciente =''
	lcpracticaSinCargo = ''
	lcpracticaConvenida = ''
	micod = controlcon.codigo
	mient = controlcon.ent
	WAIT windows TRANSFORM(RECNO()) nowait
	mresp = prg_preciosap(mient,micod,@lcimporteCobertura,@lcimportePaciente ,@lcpracticaSinCargo ,@lcpracticaConvenida )
	If  Empty(mresp ) Or At('mensaje',mresp)>0
		lcpracticaConvenida ='E'
	Endif

	Select controlcon
	Replace Conv With lcpracticaConvenida
Endscan
