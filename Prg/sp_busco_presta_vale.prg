***Function busco_presta(mcodpun,mnrovale)
LPARAMETERS mcodpun,mnrovale
Cpresta = SPACE(50)

If mcodpun>0
	mret = SQLExec(mcon1,"SELECT Prestacions.PRE_descriprest FROM  Valesasist,Presinsuvas "+;
		" INNER JOIN Prestacions ON PIA_codprest = PRE_codprest "+;
		" WHERE  PIA_VALESASIST = VALESASIST AND VAL_codpun = "+Transform(mcodpun)	,"mwkvalep")

Else
	If mnrovale>0
		mret = SQLExec(mcon1,"SELECT Prestacions.PRE_descriprest FROM  Valesasist,Presinsuvas "+;
			" INNER JOIN Prestacions ON PIA_codprest = PRE_codprest "+;
			" WHERE  PIA_VALESASIST = VALESASIST AND   VAL_codvaleasist = "+Transform(mnrovale)	,"mwkvalep")
	Endif
Endif
If Used("mwkvalep")
	Cpresta = mwkvalep.PRE_descriprest
Endif
Return Cpresta
