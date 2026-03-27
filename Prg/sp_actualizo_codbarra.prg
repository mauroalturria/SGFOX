****
** actualizo codigo de barra
****

parameter  mabm, mnregistrac, mccodbarra, mestado,musu,mfecha,mubi
if type('mubi')#"N"
	miubica=0
	cubica  = ""
else
	miubica=mubi
	cubica = " ,hca_motfalta = ?mubi "
endif
if type('mfecha')#"T"
	mfechaini = ctot("01/01/1900")
else
	mfechaini = sp_busco_fecha_srv2('DT')
endif

mfechaU = sp_busco_fecha_srv2('DT')

do case

	case mabm = 1		&& Alta

		mret= sqlexec(mcon1," insert into TabHCArchivo (hca_registrac, hca_codbarra, hca_reimprime " + ;
			", hca_estado, hca_motfalta, hca_orden, hca_fechaInic, hca_usuario  ) values ( ?mnregistrac, ?mccodbarra " + ;
			", 1, 0, 0 ,9999,?mfechaini, ?musu  ) " )
		musu = iif (used('mwkusuarios'), mwkusuarios.idusuario,mwkusuario.idusuario)
		do sp_actualizo_HcUsu With 1, mnregistrac, musu, mfechaU, mestado


	case mabm = 2		&&& =2 actualiza por nro de registracion  para reimprimir

		mret= sqlexec(mcon1," Update TabHCArchivo set hca_codbarra = ?mccodbarra, hca_reimprime = 1 " + ;
			" where hca_registrac = ?mnregistrac")

	case mabm = 3		&&& =3 actualiza por nro de registracion

&& esto para los que no estan dados de alta
		if left(mccodbarra,1)# '*'
			mret = sqlexec(mcon1,"select REG_nrohclinica,hca_motfalta,hca_registrac FROM registracio " + ;
				" left outer join TabHCArchivo on registracio.REG_nroregistrac = TabHCArchivo.hca_registrac " + ;
				" where REG_nroregistrac = ?mnregistrac ", "mwkaux" )
			mccodbarra= '*' + padl( alltrim( strtran( strtran( mwkaux.REG_nrohclinica, '/', '' ), '-', '' )) , 8, '0' ) + '*'
			if isnull(mwkaux.hca_registrac)
				mret= sqlexec(mcon1," insert into TabHCArchivo (hca_registrac, hca_codbarra, hca_reimprime " + ;
					", hca_estado, hca_motfalta, hca_orden, hca_fechaInic,hca_usuario ) values ( ?mnregistrac, ?mccodbarra" + ;
					", 0, 0, ?miubica ,9999,?mfechaini,?musu  ) " )
			ELSE
				mret= sqlexec(mcon1," Update TabHCArchivo set hca_codbarra = ?mccodbarra" + ;
					", hca_reimprime = 1 "+ cubica  + ;
					" where hca_registrac = ?mnregistrac")
			endif
		endif
&& hasta aca
		if type('mfecha')#"T"
			mret= sqlexec(mcon1," Update TabHCArchivo set hca_codbarra = ?mccodbarra " + ;
				", hca_estado = ?mestado , hca_usuario = ?musu " + cubica  + ;
				" where hca_registrac = ?mnregistrac")
		else
			mret= sqlexec(mcon1," Update TabHCArchivo set hca_codbarra = ?mccodbarra " + cubica  + ;
				", hca_estado = ?mestado , hca_usuario = ?musu, hca_fechaInic = ?mfechaini  " + ;
				" where hca_registrac = ?mnregistrac")
		endif

		musu = iif (used('mwkusuarios'), mwkusuarios.idusuario,mwkusuario.idusuario)
		do sp_actualizo_HcUsu With 1, mnregistrac, musu, mfechaU, mestado

	case mabm = 4		&&& =4 actualiza por codbarra

		if type('mfecha')#"T"
			mret= sqlexec(mcon1," Update TabHCArchivo set hca_estado = ?mestado " + ;
				" where hca_codbarra = ?mccodbarra")
		else
			mret= sqlexec(mcon1," Update TabHCArchivo set hca_estado = ?mestado, hca_fechaInic = ?mfechaini " + ;
				" where hca_codbarra = ?mccodbarra")
		endif
		musu = iif (used('mwkusuarios'), mwkusuarios.idusuario,mwkusuario.idusuario)
		do sp_actualizo_HcUsu With 1, mnregistrac, musu, mfechaU, mestado

	case mabm = 5		&&& limpia fecha inicio por registracio trae la fecha en "mccodbarra"
		mfechaini = mccodbarra
	
		mret= sqlexec(mcon1," Update TabHCArchivo set hca_fechaInic = ?mfechaini " + ;
				" where hca_registrac = ?mnregistrac")

endcase

if mret < 0
	messagebox('NO SE ACTUALIZO.  REINTENTE', 16, 'Validacion')
	mret = 0
endif
