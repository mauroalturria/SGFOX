mireg = 1
Select regishc
Go top
Do WHILE !EOF()
	On error =aerr(eros)
*	Update regishc set reg_provincia = "CAPITAL FEDERAL"   where  reg_localidad = "CAPITAL FEDERAL"  AND LEN(ALLTRIM(reg_provincia))=1 and registracio > mireg
	Update regishc set reg_provincia = "CAPITAL FEDERAL"   where   registracio > mireg
	If   registracio =   3777985
		Exit
	Else
		If eros(1)=1585
			Tablerevert(.t.)
			mireg = registracio
		Endif
	Endif
Enddo
