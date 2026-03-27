
mfecpas = Ctod('01-01-1900')

mcpathact = Allt(Sys(5))+Sys(2003)
Cd "C:\documenta"
Create Cursor medfirm (CODMED N(4),codarch c(20))
mnarch = Adir(midir,"*firma_ms.jpg")

For i= 1 To mnarch
	mimed = Val(midir(i,1))
	Insert Into medfirm Values (mimed,midir(i,1))
Next
Select * From  prestadores,medfirm  Where Id = codmed AND ISNULL(tpf_filtro) Into Cursor trabajo
Select trabajo
Scan
	mdni = trabajo.dni
	If mdni>0
		carchv = trabajo.codarch
		carchN = Alltrim(Transform(dni))+"m.jpg"
		COPY FILE &carchv To &carchN

	Endif
Endscan
Cd Alltrim(mcpathact)