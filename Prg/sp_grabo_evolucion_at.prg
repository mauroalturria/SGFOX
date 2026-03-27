****
** Grabo evolucion del paciente con alta t4cnica
****
parameters mnroreg, mprot,mmot
fechor = sp_busco_fecha_serv("DT")
mMotC 	= ''
mAntec 	= ''
mEvol	= iif(mmot = 1, ' PACIENTE SE RETIRO ', iif(mmot = 2, ' ERROR DE CARGA ',''))
mEvolF	= ''
mEvolA	= ''
mfechaHora 	= ctot("01/01/1900")
mIndic		= ''
mNurse = ''
mNurse = ''
miedit = ''
mevolNurse 	= ''
mcodCIENanda  = 0

mret = sqlexec(mcon1, "SELECT * FROM TabGuaEvol " + ;
	" where EG_nroregistrac = ?mnroreg and EG_protocolo = ?mprot ", "mwkVerEvol")
if mret < 0
	=aerr(eros)
	messagebox(eros(3), 48, "Validacion")
endif
if reccount('mwkVerEvol')= 0
	mret = sqlexec(mcon1, "insert into TabGuaEvol " + ;
		" (EG_nroregistrac , EG_protocolo , EG_usuario , EG_fechaHora , "+;
		" EG_motConsulta , EG_anteceden , EG_exFisico , EG_evolHist , "+;
		" EG_indicNurse, EG_evolNurse,EG_codCIENanda  ) values "+;
		" (?mnroreg, ?mprot,0,?mfechaHora, ?mMotC, ?mAntec, ?mEvolF,"+;
		" '', ?mIndic,?mevolNurse,?mcodCIENanda  )" )
	if mret < 0
		mret=aerr(eros)
		messagebox(eros(3), 48, "Validacion")
	endif
	mret = sqlexec(mcon1, "insert into TabGuaEvolMed " + ;
			" (EGM_proto , EGM_codmed , EGM_fechaH , EGM_evol ) values "+;
			" (?mprot, 1, ?fechor, ?mEvol )" )
ELSE

	mpdiagnostico =ALLTRIM(myip)+"-"+ALLTRIM(SYS(0))+"- Evolucion con AT"
	mpfechaMod = sp_busco_fecha_serv('DT')
	mret = sqlexec(mcon1, "insert into TabGuardia ( codCIE9 , codestado , codmedcie9 , diagnostico , fechaMod , protocolo , usuario ) "+;
		"values( 0 , 0, 1, ?mpdiagnostico , ?mpfechaMod , ?mprot, 0 )")
endif
if mret < 0
	=aerr(eros)
	messagebox(eros(3), 48, "Validacion")
endif
