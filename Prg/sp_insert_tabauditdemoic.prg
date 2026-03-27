Lparameters tnidultimo
If Used('MWKESPEIC')
	Select MWKESPEIC
	Scan All For numero > 0
		lnumero    = MWKESPEIC.numero
		lncodprest = MWKESPEIC.pre_codprest

		mret      = SQLExec(mcon1,"insert into TabAuditDemoIC (tadi_Idtabauditeval,"+;
			" tadi_Dias,tadi_CodPrest)"+;
			" values (?tnidultimo,?lnumero,?lncodprest)")

		If mret<1
			Do Log_errores With Error(), Message(), Message(1)
			Return .F.
		Endif
	Endscan
Endif
