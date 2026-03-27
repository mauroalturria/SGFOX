*
* Busqueda de Auditorias de Internacion
*
Lparameters mwhere

If vartype(mwhere) # "C"
	mwhere = ""
Endif

mret = sqlexec(mcon1,"select * from TabCiamAudInt where "+mwhere,"mwkaudint")

If mret < 0
	Messagebox("EN CONSULTA DE AUDITORIAS DE INTERNACION"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
