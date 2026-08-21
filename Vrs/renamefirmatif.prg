
mfecpas = Ctod('01-01-1900')

mcpathact = Allt(Sys(5))+Sys(2003)
Cd "C:\documenta/paraarreglar"
Create Cursor medfirm (CODMED N(4),codarch c(20))
mnarch = Adir(midir,"*firma_ms.tiff")

For i= 1 To mnarch
	mimed = Val(midir(i,1))
	Insert Into medfirm Values (mimed,midir(i,1))
Next
Select * From  b_prestadores,medfirm,b_franja Where Id = medfirm.codmed AND medfirm.codmed = b_franja.codmed  Into Cursor trabajo
Select trabajo
Scan
	mdni = trabajo.dni
	If mdni>0
		carchv = trabajo.codarch
		carchN = Alltrim(Transform(dni))+"m.tif"
		COPY FILE &carchv To &carchN

	Endif
Endscan
Cd Alltrim(mcpathact)