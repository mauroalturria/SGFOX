*!*	convierte la fecha 2009-01-31 a formato Datetime o Date 
Parameter lcfecha, lcType

	Local lResu
	
	If vartype(lcType)#"C"
		lcType = "D"
	Endif 	
	
	Set mark to '-'
	Set date to YMD

	lResu = ctot(lcfecha)
	
	If lcType = "D"
		lResu = ttod(lResu)
	EndIf
		
	Set date to french
	Set mark to

Return lResu


