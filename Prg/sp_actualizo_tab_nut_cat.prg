****
** Actualizo Datos de Alimentacion
****
lparameters nopcion,mfecreal
mdatetime = sp_busco_fecha_serv('DT')
mhoract = hour(mdatetime)

select mwkactualiza
do while !eof('mwkactualiza')

	mcodvax	= mwkusuario.codigovax
	mcodadm		= mwkactualiza.PAC_codadmision
	if !empty(mwkactualiza.TNP_CodFact1) or !empty(mwkactualiza.TNP_Observaciones1)
		mobserva	= mwkactualiza.TNP_Observaciones1
		mcodfact	= mwkactualiza.TNP_CodFact1
		mtiposer	= nopcion
		mret =sqlexec(mcon1, "select * from TabNutPaciente "+;
			"where TNP_codadmision = ?mcodadm and TNP_Fecha = ?mfecreal "+;
			" and TNP_CodServ = ?mtiposer","mwkexistepac")
		if reccount("mwkexistepac")>0
			mid= mwkexistepac.id
			mcodfact = iif(empty(mcodfact),mwkexistepac.TNP_CodFact,mcodfact )
			mmodif = iif(((alltrim(TNP_Observaciones) # alltrim(mobserva) and !empty(TNP_Observaciones));
				or TNP_Modi=1 ) ,1,0)
			if mwkexistepac.TNP_CodFact # mcodfact or mwkexistepac.TNP_Observaciones # mobserva
				mret =sqlexec(mcon1, "insert into TabNutPachist  (TNP_codadmision"+;
					",TNP_Fecha,TNP_FecImp,TNP_CodServ,TNP_CodFact,TNP_Observaciones,TNP_Usuario, TNP_Modi )"+;
					" select TNP_codadmision"+;
					",TNP_Fecha,TNP_FecImp,TNP_CodServ,TNP_CodFact,TNP_Observaciones,TNP_Usuario, TNP_Modi from TabNutPaciente "+;
					" where id=?mid" )
			endif

			if mhoract<13
				mret =sqlexec(mcon1, "update TabNutPaciente set TNP_CodFact = ?mcodfact"+;
					",TNP_Observaciones = ?mobserva,TNP_Usuario = ?mcodvax, TNP_Modi = ?mmodif "+;
					",TNP_FecImp = ?mdatetime  where id=?mid" )
			else
				mret =sqlexec(mcon1, "update TabNutPaciente set TNP_Observaciones = ?mobserva"+;
					",TNP_Usuario = ?mcodvax , TNP_Modi = ?mmodif where id=?mid" )
			endif
		else
			mmodif = iif(!empty(mobserva) and mtiposer>0 , 1, 0 )

			if isnull(mwkactualiza.pac_fechaalta)
				if mhoract<13
					mret =sqlexec(mcon1, "insert into TabNutPaciente (TNP_codadmision"+;
						",TNP_Fecha,TNP_FecImp,TNP_CodServ,TNP_CodFact,TNP_Observaciones,TNP_Usuario, TNP_Modi )"+;
						" values (?mcodadm,?mfecreal,?mdatetime, ?mtiposer,?mcodfact,?mobserva,?mcodvax,?mmodif )")
				else
					mret =sqlexec(mcon1, "insert into TabNutPaciente (TNP_codadmision"+;
						",TNP_Fecha,TNP_FecImp,TNP_CodServ,TNP_CodFact,TNP_Observaciones,TNP_Usuario, TNP_Modi )"+;
						" values (?mcodadm,?mfecreal,?mdatetime,?mtiposer,'',?mobserva,?mcodvax, ?mmodif  )")
				endif
			endif
			if mret<1
				=aerr(eros)
				messagebox(eros(2))
			endif
		endif
	endif
	if !empty(mwkactualiza.TNP_CodFact2) or !empty(mwkactualiza.TNP_Observaciones2)
		mobserva	= mwkactualiza.TNP_Observaciones2
		mcodfact	= mwkactualiza.TNP_CodFact2
		mtiposer	= nopcion+1
		mret =sqlexec(mcon1, "select * from TabNutPaciente "+;
			"where TNP_codadmision = ?mcodadm and TNP_Fecha = ?mfecreal "+;
			" and TNP_CodServ = ?mtiposer","mwkexistepac")
		if reccount("mwkexistepac")>0
			mid= mwkexistepac.id
			if mwkexistepac.TNP_CodFact # mcodfact or mwkexistepac.TNP_Observaciones # mobserva
				mret =sqlexec(mcon1, "insert into TabNutPachist  (TNP_codadmision"+;
					",TNP_Fecha,TNP_FecImp,TNP_CodServ,TNP_CodFact,TNP_Observaciones,TNP_Usuario, TNP_Modi )"+;
					" select TNP_codadmision"+;
					",TNP_Fecha,TNP_FecImp,TNP_CodServ,TNP_CodFact,TNP_Observaciones,TNP_Usuario, TNP_Modi from TabNutPaciente "+;
					" where id=?mid" )
			endif

			mmodif = iif(((alltrim(TNP_Observaciones) # alltrim(mobserva) and !empty(TNP_Observaciones));
				or TNP_Modi=1 ) ,1,0)
			mret =sqlexec(mcon1, "update TabNutPaciente set TNP_CodFact = ?mcodfact "+;
				",TNP_Observaciones = ?mobserva,TNP_Usuario = ?mcodvax, TNP_Modi = ?mmodif  "+;
				",TNP_FecImp = ?mdatetime  where id=?mid" )

		else
			mmodif = iif(!empty(mobserva) and mtiposer>0 , 1, 0 )

			if isnull(mwkactualiza.pac_fechaalta)
				mret =sqlexec(mcon1, "insert into TabNutPaciente (TNP_codadmision"+;
					",TNP_Fecha,TNP_FecImp,TNP_CodServ,TNP_CodFact,TNP_Observaciones,TNP_Usuario, TNP_Modi )"+;
					" values (?mcodadm,?mfecreal,?mdatetime, ?mtiposer,?mcodfact,?mobserva,?mcodvax,?mmodif  )")
				if mret<1
					=aerr(eros)
					messagebox(eros(2))
				endif
			endif
		endif
	endif
	skip 1 in mwkactualiza
enddo
