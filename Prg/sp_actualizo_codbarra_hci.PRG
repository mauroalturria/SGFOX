****
** Actualizo codigo de barra
****
Parameter  mabm, mnregistrac, mcnroadm, mccodbarra, mestado, musu, morden, masigna2

If vartype(masigna2) # "N"
	masigna2 = 0
Endif

If vartype(morden) # "N"
	morden = 0
Endif

Do case

Case mabm = 1		&& Alta

	mfechaAlta = sp_busco_fecha_serv('DD')
	mret= sqlexec(mcon1,"SELECT hci_nroadm FROM TabHCIArchivo  where hci_nroadm = ?mcnroadm","MwkControl")
	If reccount('MwkControl')>0  && Controlo por si existe ese nro de admision
		mabm = 4
		Loop
	Endif
	mret= sqlexec(mcon1," insert into TabHCIArchivo (hca_registrac, hca_codbarra, "+;
		" hca_reimprime, hca_estado, hca_motfalta, hca_orden, " + ;
		" hca_usuario, hci_nroAdm,hca_FechaAlta ) " + ;
		" values ( ?mnregistrac, ?mccodbarra , 1, 0, 0 ,?morden, ?musu, ?mcnroadm,?mfechaAlta ) " )
	If mret < 0
		Messagebox('NO SE ACTUALIZO. LLAME A SISTEMAS', 16, 'Validacion')
		mret = 0
		Cancel
	Endif

Case mabm = 2		&&& = 2 actualiza por nro de registracion y codigo de Admision para reimprimir

	mret= sqlexec(mcon1," Update TabHCIArchivo set hca_codbarra = ?mccodbarra, "+;
		" hca_reimprime = 1 " + ;
		" where hca_registrac = ?mnregistrac and hci_nroAdm =?mcnroadm ")

Case mabm = 3		&&& = 3 actualiza por nro de registracion

&&  Esto para los que no estan dados de alta

	If left(mccodbarra,1) # '*'

*!*			mret = sqlexec(mcon1,"select reg_nrohclinica,hca_registrac,pac_codadmision,hci_nroAdm FROM registracio " + ;
*!*						" join pacientes on registracio.registracio  = pac_codhci  " + ;
*!*						" left outer join TabHCIArchivo on reg_nroregistrac = hca_registrac " + ;
*!*						" where reg_nroregistrac = ?mnregistrac and pac_codadmision =?mcnroadm ", "mwkaux" )

		If used('mwkaux')
			Use in mwkaux
		Endif

		mret = sqlexec(mcon1,"select reg_nrohclinica,hca_registrac,pac_codadmision,hci_nroAdm,hca_estado "+;
			" FROM registracio " + ;
			" join pacientes on registracio.registracio  = pacientes.pac_codhci  " + ;
			" left outer join TabHCIArchivo on pacientes.pac_codadmision  = TabHCIArchivo.hci_nroAdm " + ;
			" where reg_nroregistrac = ?mnregistrac and pac_codadmision=?mcnroadm ", "mwkaux" )

		If mret > 0
			If used('mwkaux')
				If reccount('mwkaux') = 0
					Do sp_busco_hciadm with mcnroadm
					If used('mwkpacadm')
						If reccount('mwkpacadm') > 0
							Create cursor mwknulo (hci_nroAdm c(9),hca_estado N(1))
							Select adm_nroadm as pac_codadmision,;
								mwknulo.hci_nroAdm,mwknulo.hca_estado,;
								mwkpacadm.* from mwkpacadm;
								left join mwknulo on mwknulo.hci_nroAdm = adm_nroadm;
								Into cursor mwkaux
						Endif
					Endif
				Endif
			Endif
		Endif

		mccodbarra= '*' + alltrim( strtran( mwkaux.pac_codadmision , '-', '' )) + '*'

*!*     Si no encuentra nada en TabHCIArchivo  agrega un registro sino lo actualiza

		If isnull(mwkaux.hci_nroAdm) or isnull(mwkaux.hca_estado)
			mret= sqlexec(mcon1,"SELECT hci_nroadm FROM TabHCIArchivo  where hci_nroadm = ?mcnroadm","MwkControl")

			If reccount('MwkControl')= 0  && Controlo por si existe ese nro de admision

				mfechaAlta  = sp_busco_fecha_serv('DD')

				mret= sqlexec(mcon1," insert into TabHCIArchivo (hca_registrac, hca_codbarra,"+;
					" hca_reimprime, hca_estado, hca_motfalta, " + ;
					" hca_orden, hca_usuario, hci_nroAdm,hca_FechaAlta,"+;
					" hca_depurab) values "+;
					"(?mnregistrac,?mccodbarra,0,0,0,?morden,?musu,?mcnroadm,?mfechaAlta,"+;
					" ?masigna2)" )

*!*					mret= sqlexec(mcon1," insert into TabHCIArchivo (hca_registrac, hca_codbarra,"+;
*!*						" hca_reimprime, hca_estado, hca_motfalta, " + ;
*!*						" hca_orden, hca_usuario, hci_nroAdm,hca_FechaAlta) values "+;
*!*						"(?mnregistrac,?mccodbarra,0,0,0,?morden,?musu,?mcnroadm,?mfechaAlta)" )
*!*
				If mret < 0
					Messagebox('NO SE ACTUALIZO. LLAME A SISTEMAS', 16, 'Validacion')
					mret = 0
					Cancel
				Endif
			Endif

		Else

			mret= sqlexec(mcon1," Update TabHCIArchivo set hca_codbarra=?mccodbarra,"+;
				"hca_reimprime=1, hca_depurab=?masigna2"+;
				" where hca_registrac=?mnregistrac and hci_nroAdm=?mcnroadm")

		Endif

	Endif

&& Por si llega a venir por el lado de form cajas
&& Cambio fecha sólo si estados <> 0 y 5 ó Nulo

	mactfec    = .F.
	If used("mwkhist4") && Ingreso
		If (mwkhist4.hca_estado <> 0 and mwkhist4.hca_estado <> 5) or;
				(mwkhist4.hca_estado = 0 and 'NO INGRESADA' $ alltrim(mwkhist4.HCA_estado2))
			mfechaAlta = sp_busco_fecha_serv('DD')
			mactfec    = .T.
		Endif
	Else                && Egreso / Asig. cajas
		If used("mwkhist2")
			If (mwkhist2.hca_estado <> 0 and mwkhist2.hca_estado <> 5) or;
					(mwkhist2.hca_estado = 0 and 'NO INGRESADA' $ alltrim(mwkhist2.HCA_estado2))
				mfechaAlta = sp_busco_fecha_serv('DD')
				mactfec    = .T.
			Endif
		Endif
	Endif

*!*	mret = sqlexec(mcon1,"Update TabHCIArchivo set hca_codbarra=?mccodbarra," + ;
*!*			"hca_estado=?mestado, hca_usuario=?musu, hca_orden=?morden, hca_depurab=?masigna2"+;
*!*			iif(mactfec,",hca_FechaAlta = ?mfechaAlta","")+;
*!*			" where hca_registrac=?mnregistrac and hci_nroAdm=?mcnroadm " )

*!* Control ante diferentes números de Registración

	Use in select("mwkctrlhci")

	mret = sqlexec(mcon1,"select * from TabHCIArchivo"+;
		" where hca_registrac = ?mnregistrac and hci_nroAdm = ?mcnroadm","mwkctrlhci")

	If mret > 0
		If used("mwkctrlhci")
			If reccount("mwkctrlhci") = 0
				mret = sqlexec(mcon1,"Update TabHCIArchivo set hca_codbarra=?mccodbarra," + ;
					"hca_estado=?mestado, "+;
					"hca_usuario=?musu, "+;
					"hca_orden=?morden, "+;
					"hca_depurab=?masigna2, "+;
					"hca_registrac=?mnregistrac "+;
					iif(mactfec,",hca_FechaAlta = ?mfechaAlta","")+;
					" where hci_nroAdm = ?mcnroadm" )
			Else
				mret = sqlexec(mcon1,"Update TabHCIArchivo set hca_codbarra=?mccodbarra," + ;
					"hca_estado=?mestado, hca_usuario=?musu, hca_orden=?morden, hca_depurab=?masigna2"+;
					iif(mactfec,",hca_FechaAlta = ?mfechaAlta","")+;
					" where hca_registrac = ?mnregistrac and hci_nroAdm = ?mcnroadm" )
			Endif
		Endif
	Endif
	Use in select("mwkctrlhci")


Case mabm = 4		&&& = 4 actualiza por codbarra

	mret= sqlexec(mcon1," Update TabHCIArchivo set hca_estado = ?mestado " + ;
		" where hci_nroAdm =?mcnroadm  ")


Case mabm = 5		&&& Combio de Estado && Revertir // 18

	mret = sqlexec(mcon1,"Select hca_estado from TabHCIArchivo where hca_codbarra = ?mccodbarra","mwkaux")

	If mret < 0
		Messagebox('NO SE ACTUALIZO.  REINTENTE', 16, 'Validacion')
		mret = 0
		Cancel
	Endif

	Select mwkaux
	If reccount()> 0
		mret= sqlexec(mcon1," Update TabHCIArchivo set hca_estado = ?mestado " + ;
			" where hci_nroAdm =?mcnroadm ")

	Else
		mfechaAlta  = sp_busco_fecha_serv('DD')
		mret= sqlexec(mcon1," insert into TabHCIArchivo (hca_registrac, hca_codbarra,"+;
			" hca_reimprime, hca_estado, hca_motfalta, " + ;
			" hca_orden, hca_usuario, hci_nroAdm, hca_FechaAlta) values "+;
			"( ?mnregistrac, ?mccodbarra" + ;
			", 0, ?mestado, 0 ,?morden, ?musu, ?mcnroadm, ?mfechaAlta  ) " )
	Endif
	Use in mwkaux



Endcase

If mret < 0
	Messagebox('NO SE ACTUALIZO.  REINTENTE', 16, 'Validacion')
	mret = 0
	Cancel
Endif
