****
** actualizo codigo de barra
****

Parameter  mabm, mnregistrac, mcnroadm, mccodbarra, mestado, musu

Do case
Case mabm = 1		&& Alta
	mfechaAlta  = sp_busco_fecha_serv('DD')
	mret= sqlexec(mcon1," insert into TabHCIArchivo (hca_registrac, hca_codbarra, "+;
		" hca_reimprime, hca_estado, hca_motfalta, hca_orden, " + ;
		" hca_usuario, hci_nroAdm,hca_FechaAlta ) " + ;
		" values ( ?mnregistrac, ?mccodbarra , 1, 0, 0 ,0, ?musu, ?mcnroadm,?mfechaAlta ) " )
	If mret < 0
		Messagebox('NO SE ACTUALIZO. LLAME A SISTEMAS', 16, 'Validacion')
		mret = 0
		Cancel
	Endif

Case mabm = 2		&&& =2 actualiza por nro de registracion y codigo de Admision para reimprimir
	mret= sqlexec(mcon1," Update TabHCIArchivo set hca_codbarra = ?mccodbarra, "+;
		" hca_reimprime = 1 " + ;
		" where hca_registrac = ?mnregistrac and hci_nroAdm =?mcnroadm ")

Case mabm = 3		&&& =3 actualiza por nro de registracion
&& esto para los que no estan dados de alta

	If left(mccodbarra,1)# '*'
		If used('mwkaux')
			Use in mwkaux
		Endif
		mret = sqlexec(mcon1,"select reg_nrohclinica,hca_registrac,pac_codadmision,hci_nroAdm " + ;
			" FROM registracio join pacientes on registracio.registracio  = pacientes.pac_codhci  " + ;
			" left outer join TabHCIArchivo on pacientes.pac_codadmision  = TabHCIArchivo.hci_nroAdm " + ;
			" where reg_nroregistrac = ?mnregistrac and pac_codadmision=?mcnroadm ", "mwkaux" )
		mccodbarra= '*' + alltrim( strtran( mwkaux.pac_codadmision , '-', '' )) + '*'

		If isnull(mwkaux.hci_nroAdm) or empty(mwkaux.hci_nroAdm)
			mret= sqlexec(mcon1,"SELECT hci_nroadm FROM TabHCIArchivo  where hci_nroadm = ?mcnroadm","MwkControl")

			If reccount('MwkControl')= 0  && Controlo por si existe ese nro de admision
				mfechaAlta  = sp_busco_fecha_serv('DD')
				mret= sqlexec(mcon1," insert into TabHCIArchivo (hca_registrac, hca_codbarra,"+;
					" hca_reimprime, hca_estado, hca_motfalta, " + ;
					" hca_orden, hca_usuario, hci_nroAdm,hca_FechaAlta ) values "+;
					"( ?mnregistrac, ?mccodbarra" + ;
					", 0, 0, 0 ,0,?musu, ?mcnroadm,?mfechaAlta) " )
				If mret < 0
					Messagebox('NO SE ACTUALIZO. LLAME A SISTEMAS', 16, 'Validacion')
					mret = 0
					Cancel
				Endif
			Endif
		Else
			mret= sqlexec(mcon1," Update TabHCIArchivo set hca_codbarra = ?mccodbarra," + ;
				"hca_reimprime = 1," + ;
				"hca_estado = 0" + ;
				" where hca_registrac = ?mnregistrac and hci_nroAdm =?mcnroadm ")
		Endif

	Endif

&& hasta aca

&& Cambio fecha sólo si estados <> 0 y 5 ó Nulo

	If (mwkhist.hca_estado <> 0 and mwkhist.hca_estado <> 5) or	isnull(mwkhist.hca_estado)
			
		mfechaAlta = sp_busco_fecha_serv('DD')
		mactfec    = .T.
		
	Else
		mactfec    = .F.
	Endif

	mret= sqlexec(mcon1," Update TabHCIArchivo set hca_codbarra = ?mccodbarra " + ;
		", hca_estado = ?mestado , hca_usuario = ?musu " + ;
		iif(mactfec,",hca_FechaAlta = ?mfechaAlta","")+;
		" where hca_registrac = ?mnregistrac and hci_nroAdm =?mcnroadm " )


Case mabm = 4		&&& =4 actualiza por codbarra

	mret= sqlexec(mcon1," Update TabHCIArchivo set hca_estado = ?mestado " + ;
		" where hci_nroAdm =?mcnroadm ")


Endcase

If mret < 0
	Messagebox('NO SE ACTUALIZO.  REINTENTE', 16, 'Validacion')
	mret = 0
	Cancel
Endif
