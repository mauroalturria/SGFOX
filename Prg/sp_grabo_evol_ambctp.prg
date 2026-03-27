****
** Ambulatorio grabo evolución del paciente con Cierre Técnico de Protocolo
****
Lparameters mnroreg, mprot, mmot, mcodmed

mfechahora  = sp_busco_fecha_serv("DT")

mEvol		= iif(vartype(mmot)="C", mmot,;
	iif(mmot = 1, ' PACIENTE NO ADMITIDO AL MOMENTO DEL CIERRE DE CONSULTORIO', ;
	iif(mmot = 2, ' ERROR DE CARGA ',iif(mmot = 3, ' ANULACION DE VALE ',iif(mmot = 4, ' PACIENTE SE RETIRA ','')))))
mMotC 		= ''
mEvolF		= ''
mIndic		= ''
mevolNurse 	= ''

mret = sqlexec(mcon1, "SELECT id FROM TabAmbEvol " + ;
	" where EA_nroregistrac = ?mnroreg and EA_protocolo = ?mprot ", "mwkVerEvol")

If mret < 0
	=aerr(eros)
	Messagebox(eros(3), 48, "Validación")
	Return
Endif

If reccount('mwkVerEvol') = 0

	mret = sqlexec(mcon1, "insert into TabAmbEvol " + ;
		" (EA_nroregistrac,EA_protocolo,EA_motConsulta,EA_exFisico,"+;
		"EA_evolucion,EA_indicNurse,EA_evolNurse) values "+;
		" (?mnroreg,?mprot,?mMotC,?mEvolF,?mevol,?mIndic,?mevolNurse)" )

	If mret < 0
		mret=aerr(eros)
		Messagebox(eros(3), 48, "Validacion")
	Endif

	mret = sqlexec(mcon1, "insert into TabAmbEvolMed" + ;
		" (EAM_proto , EAM_codmed , EAM_fechaH , EAM_evol ) values"+;
		" (?mprot, ?mcodmed, ?mfechahora, ?mEvol )" )
else
	mid = mwkVerEvol.id
*!*		mret = sqlexec(mcon1, "update TabAmbEvol " + ;
*!*			" set EA_evolucion = ?mevol where id = ?mid " )

	If mret < 0
		mret=aerr(eros)
		Messagebox(eros(3), 48, "Validacion")
	Endif
Endif

If mret < 0
	=aerr(eros)
	Messagebox(eros(3), 48, "Validación")
Endif
