Lparameters tnidultimo
If Used('MWKESPEIC')
	Select MWKESPEIC
	Scan All
		lnumero    = MWKESPEIC.numero
		lncodprest = MWKESPEIC.pre_codprest
		Select MWKESPEIC1
		Go Top
		Scan All
			Locate For MWKESPEIC1.pre_codprest = lncodprest
			If Found()
				numid =	MWKESPEIC1.numidic
				If lnumero > 0
					mret      = SQLExec(mcon1,"update TabAuditDemoIC set tadi_Dias = ?lnumero,"+;
						" tadi_CodPrest = ?lncodprest "+;
						" where TabAuditDemoIC.id = ?numid")
					If mret<1
						Do Log_errores With Error(), Message(), Message(1)
						Return .F.
					Endif
				Else
					mret      = SQLExec(mcon1,"delete from  TabAuditDemoIC "+;
						" where TabAuditDemoIC.id = ?numid")
					If mret<1
						Do Log_errores With Error(), Message(), Message(1)
						Return .F.
					Endif
				Endif
			Else
				If lnumero > 0
					mret      = SQLExec(mcon1,"insert into TabAuditDemoIC (tadi_Dias,"+;
						" tadi_CodPrest,tadi_Idtabauditeval) "+;
						" values(?lnumero,?lncodprest,?tnidultimo)")
					If mret<1
						Do Log_errores With Error(), Message(), Message(1)
						Return .F.
					Endif
				Endif
			Endif
			Select MWKESPEIC1
			Continue
		Endscan
		Select MWKESPEIC
	Endscan
Endif
If Used('MWKESPEIC1')
	Use In MWKESPEIC1
Endif