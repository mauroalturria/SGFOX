
mfecpas = Ctod('01-01-1900')
SET STEP ON
mcpathact = Allt(Sys(5))+Sys(2003)
Cd "C:\documenta"
Create Cursor medfirm (CODMED N(15),codarch c(20))
mnarch = Adir(midir,"*.jpg")
 
For i= 1 To mnarch
	mimed = Val(midir(i,1))
	Insert Into medfirm Values (mimed,midir(i,1))
Next
*Select * From  b_franja,medfirm  Where Id = codmed Into Cursor trabajo
SET STEP ON
SELECT * FROM b_prestadores,medfirm  Where id = codmed   Into Cursor trabajo
Select trabajo
Scan
	mdni = trabajo.dni
	mid = trabajo.id
	If mdni>0
		carchv = trabajo.codarch
		carchN = Alltrim(Transform(mid ))+"_firma_ms.jpg"
		copy file &carchv To &carchN

	Endif
Endscan
*!*	Scan
*!*		mdni = trabajo.dni
*!*		If mdni>0
*!*			carchv = trabajo.codarch
*!*			carchN = Alltrim(Transform(dni))+"m.tif"
*!*			copy  &carchv To &carchN

*!*		Endif
*!*	Endscan
CD &mcpathact 