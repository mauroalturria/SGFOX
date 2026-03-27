parameters mFecdes, mfechas, mbuscog

*!*	mf1 = ctod("01/01/2010")
*!*	mf2 = date()+1
*!*	mbuscog = ' and Reg_NroRegistrac = 3316113'
IF inlist(VARTYPE(mFecdes),"D","T")

	mret = sqlexec(mcon1, "select fechahoraing, REG_nombrepac, " + ;
		"ent_descrient, reg_nrohclinica, reg_numdocumento, " + ;
		"reg_telefonos, reg_domicilio,REG_localidad,REG_provincia,reg_email, afi_nroafiliado, " + ;
		"ent_codent, reg_nroregistrac, TPV_Observa, tpv_estado, " + ;
		"STRING(NVL(Prestadores.NOMBRE,''), NVL(TabMedExterno.nombre,' ')) AS NOMBRE, " + ;
		"Pre_Especialidad, Pre_CodServicio, Pre_descriprest, " + ;
		"Guardia.Protocolo, Guardia.Id, Guardia.CodMed " + ;
		"from guardia "+;
		"Inner join afiliacion on afiliacion.registracio = guardia.nroregistrac and " + ;
			"afiliacion.afi_codentidad = guardia.codent " + ;
		"Inner join Prestacions on pre_codprest = Guardia.codprest " +;
		"left outer join entidades on guardia.codent = entidades.ent_codent " + ;
		"left outer join registracio on guardia.nroregistrac = registracio.reg_nroregistrac " + ;
		"left outer join tabpacvip on guardia.nroregistrac = tabpacvip.tpv_nroreg " + ;
		"Left join Prestadores on Prestadores.Id = Guardia.CodMed " + ;
		"Left join TabMedExterno on TabMedExterno.ID = Guardia.CodMed  " + ;
		"where guardia.fechahoraing >= ?mFecDes and " + ;
		"guardia.fechahoraing < ?mFecHas " + mbuscog , "mwkguardia1")
else
	mret = sqlexec(mcon1, "select fechahoraing, REG_nombrepac as paciente, " + ;
		"ent_descrient, reg_nrohclinica, reg_numdocumento , " + ;
		"reg_telefonos, reg_domicilio,REG_localidad,REG_provincia,reg_email, afi_nroafiliado, " + ;
		"ent_codent,codent, reg_nroregistrac,nroregistrac , TPV_Observa, tpv_estado, " + ;
		"STRING(NVL(Prestadores.NOMBRE,''), NVL(TabMedExterno.nombre,' ')) AS NOMBRE, " + ;
		"Pre_Especialidad, Pre_CodServicio, Pre_descriprest, " + ;
		"Guardia.Protocolo, Guardia.Id, Guardia.CodMed " + ;
		"from guardia "+;
		"Inner join afiliacion on afiliacion.registracio = guardia.nroregistrac and " + ;
			"afiliacion.afi_codentidad = guardia.codent " + ;
		"Inner join Prestacions on pre_codprest = Guardia.codprest " +;
		"left outer join entidades on guardia.codent = entidades.ent_codent " + ;
		"left outer join registracio on guardia.nroregistrac = registracio.reg_nroregistrac " + ;
		"left outer join tabpacvip on guardia.nroregistrac = tabpacvip.tpv_nroreg " + ;
		"Left join Prestadores on Prestadores.Id = Guardia.CodMed " + ;
		"Left join TabMedExterno on TabMedExterno.ID = Guardia.CodMed  " + ;
		"where " + mbuscog , "mwkguardia1")
endif

if mret<1
	aerror(eros)
	messagebox("ERROR DE LECTURA" + chr(13) + eros(3), 48, "VALIDACION")
	Return .f. 
endif

