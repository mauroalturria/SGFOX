Select turnos_onco
Set Step On
Do While !Eof()
	CODRE=CODRESERVA
	miafi = afiliado
	mcodprest = codprest
	MID = Transform(Id)
	MID = Substr(MID,2)+Right(Alltrim(CODRESERVA),2)
	Do While !Eof() And CODRE=CODRESERVA and miafi = afiliado AND mcodprest = codprest
		If MID<>CODRESERVA
	 SET STEP ON
			Replace CODRESERVA With MID
		Endif
		Skip

	Enddo
*SET STEP ON
	CODRE=CODRESERVA
	miafi = afiliado
	mcodprest = codprest
	MID = Transform(Id)
	MID = Substr(MID,2)+Right(Alltrim(CODRESERVA),2)
Enddo
