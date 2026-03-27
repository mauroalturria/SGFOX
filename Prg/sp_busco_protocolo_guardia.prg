****
** busco protocolo de guardia
****

Parameter mproto, mcual,nserv
If Vartype(nserv)<>"C"
	nserv = '8000'
Endif
mcual = Iif(Vartype(mcual) # "N", 3, mcual)   && mcual = 3 busca evolucion
mret = SQLExec(mcon1, "select * from guardia,tabtipoaltas,GuardiaPrestacion     "+;
	"where protocolo = ?mproto and Guardiaprestacion.codprest = Guardia.codprest and "+;
	" guardia.codestado = tabtipoaltas.id and GuardiaPrestacion.codserv in (&nserv)", "mwkveoproto")
If mret<0
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
Endif
If !Eof('mwkveoproto')
	mregistracio = Round(mwkveoproto.nroregistrac, 0)
	miprot = mwkveoproto.protocolo
	If mcual<=2
		mbusco1 = "where REG_nroregistrac = ?mregistracio and "
		Do sp_busco_nombre_paciente_1 With mbusco1, 1, ''
		If mcual = 1
			frmguardia01.grid1.RecordSource = msql_reg
		Else
			&msql_reg
		Endif
	Else
		If ! Used('mwkbuspacie1')
			mbusco1 = "where REG_nroregistrac = ?mregistracio and "
			Do sp_busco_nombre_paciente_1 With mbusco1, 1, ''
			If mcual = 1
				frmguardia01.grid1.RecordSource = msql_reg
			Else
				&msql_reg
			Endif
		Endif
		If mwkbuspacie1.REG_nroregistrac<>mregistracio
			mbusco1 = "where REG_nroregistrac = ?mregistracio and "
			Do sp_busco_nombre_paciente_1 With mbusco1, 1, ''
			If mcual = 1
				frmguardia01.grid1.RecordSource = msql_reg
			Else
				&msql_reg
			Endif
		Endif
		mret = SQLExec(mcon1, "SELECT * FROM TabGuaEvol,TabGuaEvolmed  " + ;
			" where EG_protocolo = ?miprot and EG_nroregistrac = ?mregistracio "+;
			" and EG_protocolo = EGM_proto", "mwkEvol0")
		If mret < 0
			Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
			Messagebox("ERROR de LECTURA , AVISAR A SISTEMAS", 48, "Validacion")
		Endif
	Endif
Endif
