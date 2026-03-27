mcon1 = SQLConnect("cata_vs")
Dimension vd[12]
Set Step On
mret = SQLExec(mcon1, "select  protocolo from tabambulatoriohis  ", "mwkambu")
Select mwkambu
i= 1
o= 1
mihora = Seconds()
Do WHILE !EOF()
	mproto  = mwkambu.protocolo
	i=i+1
	If !EMPTY(NVL(mwkambu.protocolo,''))

		mret = SQLExec(mcon1, "select  EA_antecedentes, EA_evolNurse, EA_evolucion,"+;
		" EA_exFisico, EA_horaCierre, EA_indicNurse, EA_motConsulta,"+;
		"EA_newIndic, EA_nroregistrac,  EA_protocolo "+;
		" FROM TabAmbEvol "+ ;
		" where  EA_protocolo  = ?mproto  " ,"mwkevol")
		Select mwkevol
		Select mwkevol
		Go Top
		Scan
			vd[1] = mwkevol.EA_antecedentes
			vd[2] = mwkevol.EA_evolNurse
			vd[3] = mwkevol.EA_evolucion
			vd[4] = mwkevol.EA_exFisico
			vd[5] = mwkevol.EA_horaCierre
			vd[6] = mwkevol.EA_indicNurse
			vd[7] = mwkevol.EA_motConsulta
			vd[8] = mwkevol.EA_newIndic
			vd[9] = mwkevol.EA_nroregistrac
			vd[10] = mwkevol.EA_protocolo
o=o+1

			mret = SQLExec(mcon1, "insert into TabAmbEvolhis "+;
			"(EA_antecedentes, EA_evolNurse, EA_evolucion,"+;
			" EA_exFisico, EA_horaCierre, EA_indicNurse, EA_motConsulta,"+;
			"EA_newIndic, EA_nroregistrac,  EA_protocolo)"+;
			" values "+;
			"(?vd[1],?vd[2],?vd[3],?vd[4],?vd[5],?vd[6],?vd[7],?vd[8],?vd[9],?vd[10])")

			If mret < 0
				Messagebox("AVISE A SISTEMAS", 16,"ERROR")
				mtodok = .F.
				Set Step On
			Endif


		Endscan
		mret = SQLExec(mcon1, "select EAM_codmed,EAM_evol, EAM_fechaH,EAM_proto "+;
		" FROM tabambevolmed "+ ;
		" where  EAM_proto = ?mproto  " ,"mwkevolmed")

		Go Top
		Scan
			vd[1] = mwkevolmed.EAM_codmed
			vd[2] = mwkevolmed.EAM_evol
			vd[3] = mwkevolmed.EAM_fechaH
			vd[4] = mwkevolmed.EAM_proto
			mret = SQLExec(mcon1, "insert into tabambevolmedhis "+;
			"( EAM_codmed,EAM_evol, EAM_fechaH,EAM_proto)"+;
			" values "+;
			"(?vd[1],?vd[2],?vd[3],?vd[4])")

			If mret < 0
				Messagebox("AVISE A SISTEMAS", 16,"ERROR")
				mtodok = .F.
				Set Step On
			Endif
		Endscan
	Endif
	Select mwkambu
	Skip
Enddo

mihora2 = Seconds()
mitiempo = mihora2 -mihora
Messagebox(TRANSFORM(o)+"-"+Transform(mitiempo))
Do sP_desconexion

