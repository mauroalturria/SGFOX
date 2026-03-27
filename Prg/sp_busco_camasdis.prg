*
* Busqueda: Disponibilidad de camas
*
Parameters mfe1, mfe2, mhora

If used('mwkdiscam')
	Use in mwkdiscam
Endif

mret = sqlexec(mcon1,"select Tabhistocup.*,"+;
	"SEC_descripsec as lsector"+;
	" from Tabhistocup join sectores on SEC_codsector = sector"+;
	" where fecha >= ?mfe1 and fecha <= ?mfe2"+;
	iif(mhora=1," and hora < 1200",iif(mhora=2," and hora>1200","")),"mwkdiscam")

If mret < 0
	=aerror(merror)
	Messagebox("EN CONSULTA DISPONIBILIDAD DE CAMAS"+chr(10)+;
		alltrim(merror(3))+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
