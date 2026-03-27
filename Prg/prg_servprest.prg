****
*** busca los servicios de la prestacion
****
Lparameters mnprest
If Val(Transform(mnprest ))=0
	Return 0
Else
	mret = SQLExec(mcon1,"select PRE_codservicio from prestacions where PRE_codprest = ?mnprest" , "mwkservprest" )
Endif
Return NVL(mwkservprest.PRE_codservicio,0)

