
mfecpas = Ctod('01-01-1900')
 SET STEP ON
 
mcpathact = Allt(Sys(5))+Sys(2003)
Cd "C:\documenta\exenuevo"
Create Cursor medfirm (CODMED N(4))
mnarch = Adir(midir,"*.*")
*Cd Alltrim(mcpathact)
For i= 1 To mnarch
	apasar = "C:\documenta\"+LEFT(ALLTRIM(midir(i,1)),LEN(ALLTRIM(midir(i,1)))-1)
	desde = "C:\documenta\pasados\"+LEFT(ALLTRIM(midir(i,1)),LEN(ALLTRIM(midir(i,1)))-1)
	COPY FILE &desde  TO   &apasar 
Next
 