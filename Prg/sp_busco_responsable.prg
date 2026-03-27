Lparameters mmotadmi,msector

Do sp_busco_estados With 7,' and tipo = 88 ','mwkrespsect'&&
lsigo = .F.
Select * From mwkrespsect Where subestado = 1 Into Cursor mwkrespmot
Select * From mwkrespsect Where subestado = 2 Into Cursor mwkrespsec
Select mwkrespmot

Do While !Eof() And !lsigo
	lsigo = (msector $ Alltrim(mwkrespmot.Descrip))
	If  lsigo
		Exit
	Else
		Skip
	Endif
Enddo
If lsigo
	Return mwkrespmot.estado
Else
	Select mwkrespsec
	Do While !Eof() And !lsigo
		lsigo = (msector $ Alltrim(mwkrespsec.Descrip))
		If  lsigo
			Exit
		Else
			Skip
		Endif
	Enddo
	If  lsigo
		Return mwkrespsec.estado
	Else
		Return 1690
	Endif
Endif
