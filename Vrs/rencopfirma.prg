
mfecpas = Ctod('01-01-1900')

mcpathact = Allt(Sys(5))+Sys(2003)
Cd "C:\documenta\firmaweb"
Create Cursor medfirm (CODMED N(4),codarch c(20))
mnarch = Adir(midir,"*firma_ms.jpg")

For i= 1 To mnarch
	mimed = Val(midir(i,1))
	Insert Into medfirm Values (mimed,midir(i,1))
Next
Select * From  prestadores,medfirm  Where Id = codmed And Isnull(tpf_filtro) Into Cursor trabajo
Select trabajo
Scan
	mdni = trabajo.dni
	If mdni>0
		carchv = trabajo.codarch
		carchDNI = "C:\documenta\"+Alltrim(Transform(dni))+"m.jpg"
		carchID = "C:\documenta\"+carchv
		Copy File &carchv To &carchDNI
		Copy File &carchv To &carchID


	Endif
Endscan
Cd Alltrim(mcpathact)
