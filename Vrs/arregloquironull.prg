SELECT * FROM quirofanoahora WHERE DTOS(fechaquirof)+reg_nrohclinica in;
(SELECT DTOS(fechaquirof)+reg_nrohclinica FROM quirofanoahora WHERE ISNULL(codadmision)) ORDER BY fechaquirof,pacnombre,codadmision DESC INTO CURSOR dato

Select dato
Set Step On
Go Top
Do While !Eof()
	mihc = reg_nrohclinica
	miadm = codadmision
	mient = codent
	Do While !Eof() And mihc = reg_nrohclinica And mient = codent
		If !Isnull(codadmision)
			Skip
			Loop
		Endif
		mid = dato.Id
		Requery('protquir')
		Select protquir
		If Reccount('protquir')=1
			Append From Dbf('protquir')
			Requery('protquir')
			SELECT protquir
			Go Top
			Replace quirofano With mid
		Else
			If Reccount('protquir')=0
				Select dato
				Skip 1
				Loop
			Else
				Set Step On
				Use In Select('protquiruno')
				Select * From protquir Group By codadmision Into Cursor protquiruno Readwrite
				Update protquiruno Set quirofano  =mid
				Select protquir
				Append From Dbf('protquiruno')
			Endif
		Endif
		Select dato
		Skip 1
	Enddo
	mihc = reg_nrohclinica
	mient = codent
	miadm = codadmision
Enddo


