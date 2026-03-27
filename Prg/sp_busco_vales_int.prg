****
** busco consumo por paciente
****

Parameters madmision, msql_cons,mexcserv
If Vartype(mexcserv)<>"C"
	mexcserv = '1200,130,9400'
Endif
mret = SQLExec(mcon1, "select VAL_fechasolicitud, ser_codserv,VAL_codvaleasist,ser_descripserv " + ;
"from servicios, valesasist " + ;
"where VAL_codadmision = ?madmision and VAL_codservvale = ser_codserv and " + ;
"VAL_codservvale not in ("+Alltrim(mexcserv )+") and val_estado <> 3 " + ;
"  " , "mwkvalesint")
