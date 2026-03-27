*********************************************************************************
* BUSCA PACIENTES                                            *
*********************************************************************************
Parameter mbusco1,mpg,lbloqueo
If Type('mpg')#"N"
	mpg = 2
Endif
If Vartype(lbloqueo)#"N"
	lbloqueo = 0
Endif
lret = .F.
*!*	use in select("mwkbuspacie")
*!*	use in select("mwkbuspacie1")
lsigo = .T.
If At("MCTEXTO",Upper(mbusco1))>0
	If Vartype(mctexto)="C" And Empty(mctexto)
		Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "VALIDACION")
		lsigo = .F.
	Endif
Endif
If lsigo

	mwhere = ' where !INLIST(nvl(TPV_Estado,0),1,3)  '
	If mpg = 1
		mret = SQLExec(mcon1,"select REG_nrohclinica, REG_nombrepac, REG_domicilio, entidades.ENT_descrient, " + ;
			"REG_numdocumento, REG_fecaltapadron, AFI_fechabaja, " + ;
			"REG_fecnacimiento, REG_fecbajapadron, ENT_fecpas, ENT_turnoshabilit, " + ;
			"entidades.ENT_codent, REG_nroregistrac, REG_cpostal, REG_provincia, ENT_capita, " + ;
			"AFI_nroafiliado, REG_tipodocumento, REG_localidad, REG_sexo, REG_telefonos, " + ;
			"blr_codigobloqueo, blr_descripcion, REG_bloq_comen, REG_distrito, TPV_Estado " + ;
			", TPV_Audit , TPV_Observa, ENT_codagrup,REG_email, REG_cuit,REG_fechaauditada "+;
			"FROM afiliacion, entidades, registracio "+;
			"left outer join bloqregist on registracio.REG_bloqueo = bloqregist.blr_codigobloqueo " + ;
			" left outer join TabPacVip on registracio.REG_nroregistrac = TabPacVip.TPV_NroReg " + ;
			"&mbusco1 and " + ;
			"registracio.REG_nroregistrac = afiliacion.registracio and " + ;
			"afiliacion.AFI_codentidad = entidades.ENT_codent " + ;
			"order by REG_nrohclinica,REG_nombrepac, AFI_fechabaja, ENT_turnoshabilit", "mwkbuspacie")

		If mret < 0
			Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
			Do sp_desconexion With "error"
			Cancel
		Else
			Select REG_nroregistrac From mwkbuspacie Where  Inlist(Nvl(TPV_Estado,0),1,3)  Into Cursor mwkpass
			If Reccount('mwkpass')>0 And lbloqueo = 0
				Do Form frmpass_sec  WITH mwkpass.REG_nroregistrac To lret
				mhc = Transf(mwkpass.REG_nroregistrac)
				Do sp_insert_tabCtrlErr With Iif(lret,"SI","NO") + mwkusuario.idusuario, mwkexe.nomexe+' nombre '+ miform + '-'+mhc, '',''

			Endif
			mwhere = Iif(!lret And lbloqueo = 0,' where !INLIST(nvl(TPV_Estado,0),1,3)  ',' ')

			msql_reg = 'select *, 0 as preacre from mwkbuspacie '+mwhere +;
				'into cursor mwkbuspacie1'
		Endif
	Else

		mret = SQLExec(mcon1,"select REG_nrohclinica, REG_nombrepac, entidades.ENT_descrient, " + ;
			"REG_numdocumento, AFI_fechabaja, REG_fecbajapadron, ENT_fecpas,abrevio,descrip , " + ;
			"entidades.ENT_codent, REG_nroregistrac, AFI_nroafiliado, REG_sexo, tabhcarchivo.*, TPV_Estado " + ;
			", TPV_Audit , TPV_Observa, ENT_codagrup,REG_email, REG_cuit,REG_fechaauditada "+;
			"from registracio  " + ;
			"left outer join afiliacion on registracio.REG_nroregistrac = afiliacion.registracio "+;
			"left outer join entidades on afiliacion.AFI_codentidad = entidades.ENT_codent " + ;
			" left outer join tabhcarchivo on registracio.REG_nroregistrac = tabhcarchivo.hca_registrac " + ;
			" left outer join TabHCUbica on TabHCUbica.codubi = tabhcarchivo.hca_motfalta " + ;
			" left outer join TabPacVip on registracio.REG_nroregistrac = TabPacVip.TPV_NroReg " + ;
			"&mbusco1 " + ;
			"order by REG_nrohclinica,REG_nombrepac, AFI_fechabaja", "mwkbuspacie")

		If mret < 0
			=Aerr(eros)
			Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
			Do sp_desconexion With "error"
			Cancel
		Else
			Select REG_nroregistrac From mwkbuspacie Where  Inlist(Nvl(TPV_Estado,0),1,3)  Into Cursor mwkpass
			If Reccount('mwkpass')>0 And lbloqueo = 0
				Do Form frmpass_sec With mwkpass.REG_nroregistrac To lret
				mhc = Transf(mwkpass.REG_nroregistrac)
				Do sp_insert_tabCtrlErr With Iif(lret,"SI","NO") + mwkusuario.idusuario, mwkexe.nomexe+' nombre '+ miform + '-'+mhc, '',''

			Endif

			mwhere = Iif(!lret,' where !INLIST(nvl(TPV_Estado,0),1,3)  ',' ')

			msql_reg = 'select REG_nrohclinica, REG_nombrepac, REG_numdocumento ' + ;
				', iif( isnull( hca_estado ), "s/codbarra" , iif( hca_estado = 0, "en archivo",' +;
				' iif( hca_estado = 1, "preparado",iif( hca_estado = 2, "en consultorio", "faltante" ) ) )) ' + ;
				' +" "+alltrim(nvl(abrevio,"")) '+;
				', ENT_descrient, ENT_codent, REG_nroregistrac, AFI_nroafiliado, REG_sexo ' + ;
				', hca_estado, hca_codbarra, hca_registrac, hca_reimprime, TPV_Estado, TPV_Audit , TPV_Observa,'+;
				' ENT_codagrup,REG_email, REG_cuit,REG_fechaauditada '+;
				' from mwkbuspacie '+ mwhere +'into cursor mwkbuspacie1 '
		Endif
	Endif
Endif
