* Armo Cursores de Hemoterapia.
parameters mHisCli

tcHC = mHisCli

*** Grupo Sanguineo ***
USE IN SELECT('mwkhtgrupo')
lcsql = "Select *,  cast(htg_hora as char(8)) as htg_hora1  " + ;
	"From tabhtgrupo where tabhtgrupo.HTG_HC = ?tcHC Order By tabhtgrupo.HTG_Fecha desc, tabhtgrupo.HTG_hora desc "

If !Prg_EjecutoSql(lcsql,"mwkhtgrupo")
	Return .F.
Endif
