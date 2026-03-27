*********************************************************************************
* BUSCA PACIENTES
*********************************************************************************
parameter mbusco1, mpg, mcnombre, mbusco2

if type ('mbusco2')#"C"
	mbusco2 = ''
endif
*!*	use in select("mwkbuspacie")
*!*	use in select("mwkbuspacie1")
lret = .f.
if mpg = 1

	mret = sqlexec(mcon1,"select REG_nrohclinica, REG_nombrepac, REG_domicilio, " + ;
		"entidades.ENT_descrient, REG_numdocumento, REG_fecaltapadron , " + ;
		"AFI_fechabaja, REG_fecnacimiento, REG_fecbajapadron, ENT_fecpas, ENT_turnoshabilit, " + ;
		"entidades.ENT_codent, REG_nroregistrac, REG_cpostal, REG_provincia, ENT_capita, ENT_tipo,ENT_nroprestadorexterno , " + ;
		"REG_telefonos, REG_tipodocumento, REG_localidad, AFI_nroafiliado, REG_sexo, " + ;
		"blr_codigobloqueo, blr_descripcion, REG_bloq_comen, REG_distrito, TPV_Estado " + ;
		", TPV_Audit , TPV_Observa, ENT_codagrup,REG_email, REG_cuit,REG_fechaauditada "+;
		"FROM afiliacion, entidades, registracio left outer join bloqregist on " + ;
		" registracio.REG_bloqueo = bloqregist.blr_codigobloqueo " + ;
		" left outer join TabPacVip on registracio.REG_nroregistrac = TabPacVip.TPV_NroReg " + ;
		"&mbusco1 " + mbusco2 +;
		"registracio.REG_nroregistrac = afiliacion.registracio and " + ;
		"afiliacion.AFI_codentidad = entidades.ENT_codent "+;
		"", "mwkbuspacie")

	if mret < 0

		do LOG_ERRORES with error(), message(), message(1), program(), lineno()
		messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
		do prg_cancelo

	else

		select REG_nroregistrac from mwkbuspacie where  INLIST(nvl(TPV_Estado,0),1,3)  into cursor mwkpass

		if reccount('mwkpass')>0
			do form frmpass_sec WITH mwkpass.REG_nroregistrac to lret
			mhc = transf(mwkpass.REG_nroregistrac)
			do sp_insert_tabCtrlErr with iif(lret,"SI","NO") + mwkusuario.idusuario, mwkexe.nomexe+' nombre '+ miform + '-'+mhc, '',''
		endif

		mwhere = iif(!lret,' where !INLIST(nvl(TPV_Estado,0),1,3)  ',' ')

		msql_reg = 'select *, 0 as preacre from mwkbuspacie ' + mwhere +;
			'ORDER BY REG_nombrepac, AFI_fechabaja, ENT_turnoshabilit '+;
			'into cursor mwkbuspacie1'
	endif

else

	DO CASE
	CASE upper(mbusco1) = upper("where REG_numdocumento = ?mctexto and ")
		mbusco1 = "where preregistra.nrodocumento = ?mctexto and "

	CASE upper(mbusco1) = upper("where afiliado = ?mctexto and ")
		&& ES CORRECTO PARA PREREGISTRACIO

	OTHERWISE

		mctexto = mcnombre
		mbusco1 = "where preregistra.nombre LIKE '&mctexto%' and "

	ENDCASE

	IF AT("where",LOWER(mbusco1))+AT("where",LOWER(mbusco2)) = 0
		mbusco1= " where "+mbusco1
	ENDIF
	
	mret = sqlexec(mcon1,"select  cast('0000000000' as char(10)) as REG_nrohclinica, nombre as REG_nombrepac, direccion as REG_domicilio, " + ;
		"entidades.ENT_descrient, nrodocumento as REG_numdocumento, " + ;
		"getdate() as REG_fecaltapadron, fechabaja as AFI_fechabaja, fechanac as REG_fecnacimiento, " + ;
		"fechabaja as REG_fecbajapadron, ENT_capita, ENT_tipo,ENT_nroprestadorexterno , " + ;
		"ENT_fecpas, ENT_turnoshabilit, entidades.ENT_codent, preregistra.id as REG_nroregistrac, " + ;
		"codpostal as REG_cpostal, Nvl(tabpcia.descrip,'') as REG_provincia, telefono as REG_telefonos, " + ;
		"coddocu as REG_tipodocumento, Nvl(tabloca.descrip,'') as REG_localidad, " + ;
		"afiliado as AFI_nroafiliado, sexo as REG_sexo, 0 as REG_distrito, cast(0 as integer) as TPV_Estado " + ;
		", 0 as TPV_Audit , space(300) as TPV_Observa, ENT_codagrup,email as REG_email,'' as  REG_cuit,null as REG_fechaauditada "+;
		"from preregistra " + ;
		"inner join entidades on preregistra.codent  = entidades.ENT_codent " + ;
		"left join tabpcia on preregistra.codpcia = tabpcia.id " + ;
		"left join tabloca on preregistra.codloca = tabloca.id " + ;
		"&mbusco1 " +mbusco2 + ;
		"preregistra.nroregistracio is null " + ;
		"", "mwkbuspacie")
	if mret < 0

		do LOG_ERRORES with error(), message(), message(1), program(), lineno()
		messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
		mret=0
		do prg_cancelo

	else

		msql_pre = 'select *, 1 as preacre from mwkbuspacie ORDER BY REG_nombrepac into cursor mwkbuspacie1'

	endif
endif


