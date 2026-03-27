
mfecpas = Ctod('01-01-1900')

mcpathact = Allt(Sys(5))+Sys(2003)
Cd "C:\documenta\pasados"
Create Cursor medfirm (CODMED N(4),codarch c(20))
mnarch = Adir(midir,"*firma_ms.tif")

For i= 1 To mnarch
	mimed = Val(midir(i,1))
	Insert Into medfirm Values (mimed,midir(i,1))
Next
Select * From  faltanjpg,medfirm  Where Idmedico = codmed  Into Cursor trabajo
Select trabajo
Scan
	  
		carchv = trabajo.codarch
		carchN = "C:\documenta\"+Alltrim(Transform(dni))+"m.tif"
		COPY FILE &carchv To &carchN
		carchN = "C:\documenta\"+carchv 
		COPY FILE &carchv To &carchN

 
Endscan
Cd Alltrim(mcpathact)