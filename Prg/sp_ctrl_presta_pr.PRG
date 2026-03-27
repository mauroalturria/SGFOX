*
* Busqueda de profesionales preregistrados
*
Lparameters mmatriculas, mnombre

Use in select("mwkctrlprest")

mpos = at(" ",alltrim(mnombre))-1

mbus = left(alltrim(mnombre),mpos)

mret =  sqlexec(mcon1,"select * from TabPreregMed"+;
	" where matriculas = ?mmatriculas and nombre like '%"+mbus+"%'","mwkctrlpret")

If mret < 0
	Messagebox("EN CONSULTA MAESTRO PROFESIONALES PREREGISTRADOS"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif

Return .T.
