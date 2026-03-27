Select valores
SET STEP ON
Scan
	midoc = Docu
	mient = codent
	miafi = nroafimal
	Select splistado1
	Locate For AFI_nroafiliado=miafi And AFI_codentidad=mient And REG_numdocumento =midoc

	If !Found()
		Set Step On
	Else
		mireg = REG_nroregistrac
		mihc =  REG_nrohclinica
		Select valores
		Replace registrac With mireg,hclin With mihc
	Endif
	Select valores
Endscan
