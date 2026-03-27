****
** busca los protocolo de ambula para la grilla
****
Parameter mcual,mfecha1,mfecha2,mbuscog,mbuscov,mtodos,mcursor


If Vartype (mcursor)#"C"
	mcursor= 'mwkambula'
Endif
If Vartype (mtodos)#"N"
	mtodos = 0
Endif

If Vartype (mbuscog)#"C"
	mbuscog = ''
Endif

If Type ('mbuscov')#"C"
	mbuscov = ''
Endif
mfechactr = sp_busco_fecha_serv('DT')

If Inlist(Type("mfecha1"),"T","D")
	mfecha = mfecha1
Else
	mfecha = Ttod(mfechactr)
Endif
If !Inlist(Type("mfecha2"),"T","D")
	mfecha2 = Ttod(mfechactr)
Endif
mfechaobs = mfechactr - 14400  && 4 horas

mccpoamb = ''
If mxambito >1
	mccpoamb = "  and Tabambulatorio.codambito = ?mxambito "
Else
	If mtodos = 0
		mccpoamb = "  and Tabambulatorio.centromedico= ?mxcentromedico "
	Endif
Endif
If mcual <> 6
*	mitime = seconds()
	If mcual <> 10 && si es salida profesional
		If mcual = 3  && si es desde hasta
			mret = SQLExec(mcon1, "select TAM_protocolo,TAM_Fechah , TAM_estado , TAM_mensaje , TAM_usuario  " + ;
				" from TabambMsg " + ;
				" where TAM_Fechah >= ?mfechaobs and TAM_estado <> 9 and TAM_codmed = 1 " + ;
				" ", "mwkprotomsg0")
		Else
			mret = SQLExec(mcon1, "select TAM_protocolo ,TAM_Fechah , TAM_estado , TAM_mensaje , TAM_usuario  " + ;
				" from TabAmbMsg " + ;
				" where TAM_Fechah >= ?mfecha and TAM_estado <> 9 and TAM_codmed = 1 " + ;
				" ", "mwkprotomsg0")
		Endif
	Else
		mret = SQLExec(mcon1, "select TAM_protocolo ,TAM_Fechah , TAM_estado , TAM_mensaje , TAM_usuario  " + ;
			" from TabAmbMsg " + ;
			" where TAM_protocolo = ?mbuscog and TAM_estado <> 9 and TAM_codmed = 1 " + ;
			" ", "mwkprotomsg0")
	Endif

	If mret <= 0
		Messagebox("ERROR DE LECTURA. EVOLUCION ",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Endif

*	mitime2 = seconds()
*	messagebox(transfor(mitime2-mitime))
	Select * From mwkprotomsg0 Order By TAM_protocolo,TAM_Fechah Group By TAM_protocolo  Into Cursor mwkprotomsg
Endif

Do Case

Case mcual = 1	&& planilla completa
	mf1 = prg_dtoc(mfecha1)
	mf2 = prg_dtoc(mfecha2+1)
	mret = SQLExec(mcon1, "select protocolo, fechahoraing,demanda, REG_nombrepac, nombre, codprest, ENT_descrient,ENT_nroprestadorexterno, " + ;
		"PRE_descriprest, PRE_especialidad, fechahoraate, codestado, TabAmbulatorio.id, prestacions.Pre_codservicio, " + ;
		"REG_nrohclinica, REG_telefonos, REG_domicilio,reg_email, AFI_nroafiliado, ESP_descripcion,"+;
		" TabAmbulatorio.codent, nroregistrac,TabAmbulatorio.codmed,TabAmbulatorio.ID, tipoest,descrip,codcie9,  " + ;
		"REG_fecnacimiento,TabAmbulatorio.archivado "+;
		"from prestacions, entidades, especialid, registracio, afiliacion," + ;
		"tabtipoaltas,TabAmbulatorio left outer join prestadores on TabAmbulatorio.codmed = prestadores.id " + ;
		"where TabAmbulatorio.nroregistrac = registracio.REG_nroregistrac and " + ;
		"TabAmbulatorio.nroregistrac = afiliacion.registracio and " + ;
		"TabAmbulatorio.codent = afiliacion.AFI_codentidad and " + ;
		"TabAmbulatorio.codprest = prestacions.PRE_codprest and " + ;
		"TabAmbulatorio.codestado 		= tabtipoaltas.id and " + ;
		"prestacions.PRE_especialidad = ESP_codesp and " + ;
		"TabAmbulatorio.codent	= entidades.ENT_codent and " + ;
		"TabAmbulatorio.fechahoraing >= ?mf1 and " + ;
		"TabAmbulatorio.fechahoraing < ?mf2  " + mbuscog + mccpoamb , "mwkambula0")

	Select protocolo, fechahoraing,demanda, REG_nombrepac, nombre, codprest, ENT_descrient, ;
		PRE_descriprest, PRE_especialidad, fechahoraate, codestado, mwkambula0.Id, 0 As prioridad, ;
		REG_nrohclinica, REG_telefonos, REG_domicilio,reg_email, AFI_nroafiliado, ESP_descripcion,;
		codent, nroregistrac,mwkambula0.codmed,tpopac,tipoest,0 As puesto,Descrip ;
		,codentexc,fecpasiva,tpopac,codcie9,descripcion,mwkprotomsg.* ;
		,Pre_codservicio As codserv,REG_fecnacimiento ,archivado,ENT_nroprestadorexterno   ;
		from mwkambula0 ;
		left Join mwkentexg On codent = codentexc ;
		left Join mwkprotomsg On protocolo = TAM_protocolo  ;
		left Join mwkciap2e On mwkciap2e.Id = codcie9 ;
		group By fechahoraing ,protocolo,codprest,mwkambula0.Id,AFI_nroafiliado ;
		order By fechahoraing Into Cursor &mcursor



Case mcual = 5		&& planilla enfermeria

	mf1 = prg_dtoc(mfecha1)

	mret  = SQLExec(mcon1, "select protocolo, fechahoraing, demanda, REG_nombrepac, nombre, " + ;
		" tabambulatorio.codprest, ENT_descrient,ENT_nroprestadorexterno, " + ;
		" PRE_descriprest, PRE_especialidad, fechahoraate, " + ;
		" prestacions.Pre_codservicio, "+;
		" codestado, TabAmbulatorio.id, 0 as prioridad, " + ;
		" REG_nrohclinica, REG_telefonos, "+;
		" REG_domicilio,reg_email, ESP_descripcion, " + ;
		" TabAmbulatorio.codent, nroregistrac, " + ;
		" TabAmbulatorio.codmed, tipoest, EA_indicNurse, 0 as EA_codmed, " + ;
		" EA_evolucion,EA_evolNurse, " + ;
		" 0 AS puesto, descrip, codcie9, EA_newindic, " + ;
		" PRE_codservicio, TabAmbulatorio.NroVale,TabAmbulatorio.fechaate, " + ;
		" TabAmbevol.Id as IdAmbEvol, especialid.ESP_codesp, archivado,val_codadmision  " + ;
		" from TabAmbulatorio " + ;
		" Inner join entidades on TabAmbulatorio.codent	= entidades.ENT_codent " + ;
		" left outer join prestadores on TabAmbulatorio.codmed = prestadores.id " + ;
		" left join TabAmbevol on TabAmbulatorio.protocolo = TabAmbevol.EA_protocolo " + ;
		" inner join PRESTACIONS on prestacions.pre_codprest = TabAmbulatorio.codprest " + ;
		" inner join tabtipoaltas on TabAmbulatorio.codestado = tabtipoaltas.id " + ;
		" inner join especialid on prestacions.PRE_especialidad = especialid.ESP_codesp " + ;
		" inner join registracio on TabAmbulatorio.nroregistrac = registracio.REG_nroregistrac " + ;
		" inner join valesasist on valesasist.val_codvaleasist = TabAmbulatorio.nrovale" + ;
		" where VAL_tipopaciente='AMB' and  " + ;
		" TabAmbulatorio.fechahoraing >= ?mf1 " + mbuscog + mccpoamb + ;
		"", "mwkambula0")



*!*			"Inner join TabAmbevol on TabAmbulatorio.protocolo = TabAmbevol.EA_protocolo " + ;

*!*	and "+;
*!*			" (PRE_codservicio in (1130) or PRE_especialidad = 'OBST') " + mbuscog + ;

&&		"TabAmbulatorio.fechahoraing >= ?mf1 and PRE_codservicio = 1130 " + mbuscog


	If mret <= 0
		Messagebox("ERROR DE LECTURA. EVOLUCION ",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Endif


	Select protocolo, fechahoraing,demanda, REG_nombrepac,mwkambula0.nombre, codprest, ENT_descrient, ;
		PRE_descriprest, PRE_especialidad, fechahoraate, codestado, mwkambula0.Id, prioridad, ;
		REG_nrohclinica, REG_telefonos, REG_domicilio,reg_email, ESP_descripcion,;
		codent, nroregistrac,mwkambula0.codmed,tpopac,!Empty(Nvl(EA_indicNurse,'')) As indic, ;
		!( (Empty(Nvl(EA_evolNurse,'')) Or Nvl(EA_newindic,0) = 1 ) Or ( Empty(Nvl(EA_evolNurse,'')) And ESP_codesp="ENFE"  ) ) As Atnur,;
		tipoest,puesto,Descrip, Pre_codservicio As codserv  ;
		,codentexc,fecpasiva ,codcie9,descripcion,mwkprotomsg.*,EA_indicNurse,EA_evolNurse  ;
		,EA_codmed,EA_evolucion, NroVale, fechaate, archivado,sp_busco_npac(val_codadmision,7) As Centromed,ENT_nroprestadorexterno   ;
		from mwkambula0;
		inner Join mwkmedicoamb On codmed = mwkmedicoamb.Id ;
		left Join mwkentexg On codent = codentexc ;
		left Join mwkciap2e On mwkciap2e.Id = codcie9 ;
		left Join mwkprotomsg On protocolo = TAM_protocolo  ;
		group By fechahoraing,protocolo,codprest,mwkambula0.Id;
		order By fechahoraing Into Cursor &mcursor
&&and codestado= 1
Case mcual = 10	&& planilla HCE Legales x protocolo

	Use In Select("mwkambula0")
	mret = SQLExec(mcon1, "select protocolo, fechahoraing,demanda, REG_nombrepac, nombre, codprest, ENT_descrient,ENT_nroprestadorexterno, " + ;
		"PRE_descriprest, PRE_especialidad, fechahoraate, codestado, TabAmbulatorio.id, prestacions.Pre_codservicio, " + ;
		"REG_nrohclinica, REG_telefonos, REG_domicilio,reg_email, AFI_nroafiliado, ESP_descripcion,"+;
		" TabAmbulatorio.codent, nroregistrac,TabAmbulatorio.codmed,TabAmbulatorio.ID, tipoest,descrip,codcie9,  " + ;
		"REG_fecnacimiento "+;
		"from prestacions, entidades, especialid, registracio, afiliacion," + ;
		"tabtipoaltas,TabAmbulatorio left outer join prestadores on TabAmbulatorio.codmed = prestadores.id " + ;
		"where TabAmbulatorio.nroregistrac = registracio.REG_nroregistrac and " + ;
		"TabAmbulatorio.nroregistrac = afiliacion.registracio and " + ;
		"TabAmbulatorio.codent = afiliacion.AFI_codentidad and " + ;
		"TabAmbulatorio.codprest = prestacions.PRE_codprest and " + ;
		"TabAmbulatorio.codestado 		= tabtipoaltas.id and " + ;
		"prestacions.PRE_especialidad = ESP_codesp and " + ;
		"TabAmbulatorio.codent	= entidades.ENT_codent and TabAmbulatorio.protocolo = ?mbuscog " + mccpoamb,"mwkambula01")

	mret = SQLExec(mcon1, "select protocolo, fechahoraing,demanda, REG_nombrepac, nombre, codprest, ENT_descrient,ENT_nroprestadorexterno, " + ;
		"PRE_descriprest, PRE_especialidad, fechahoraate, codestado, TabAmbulatorio.id, prestacions.Pre_codservicio, " + ;
		"REG_nrohclinica, REG_telefonos, REG_domicilio,reg_email, AFI_nroafiliado, ESP_descripcion,"+;
		" TabAmbulatorio.codent, nroregistrac,TabAmbulatorio.codmed,TabAmbulatorio.ID, tipoest,descrip,codcie9,  " + ;
		"REG_fecnacimiento "+;
		"from prestacions, entidades, especialid, registracio, afiliacion," + ;
		"tabtipoaltas,TabAmbulatoriohis as TabAmbulatorio "+;
		" left outer join prestadores on TabAmbulatorio.codmed = prestadores.id " + ;
		"where TabAmbulatorio.nroregistrac = registracio.REG_nroregistrac and " + ;
		"TabAmbulatorio.nroregistrac = afiliacion.registracio and " + ;
		"TabAmbulatorio.codent = afiliacion.AFI_codentidad and " + ;
		"TabAmbulatorio.codprest = prestacions.PRE_codprest and " + ;
		"TabAmbulatorio.codestado 		= tabtipoaltas.id and " + ;
		"prestacions.PRE_especialidad = ESP_codesp and " + ;
		"TabAmbulatorio.codent	= entidades.ENT_codent and TabAmbulatorio.protocolo = ?mbuscog " + mccpoamb,"mwkambula02")


	If Reccount( "mwkambula02")>0
		Select * From mwkambula01 Union All ;
			SELECT * From mwkambula02;
			INTO Cursor mwkambula0
	Else
		Select * From mwkambula01 Into Cursor mwkambula0
	Endif

	Select protocolo, fechahoraing,demanda, REG_nombrepac, nombre, codprest, ENT_descrient, ;
		PRE_descriprest, PRE_especialidad, fechahoraate, codestado, mwkambula0.Id, 0 As prioridad, ;
		REG_nrohclinica, REG_telefonos, REG_domicilio,reg_email, AFI_nroafiliado, ESP_descripcion,;
		codent, nroregistrac,mwkambula0.codmed,tpopac,tipoest,0 As puesto,Descrip ;
		,codentexc,fecpasiva,tpopac,codcie9,descripcion,mwkprotomsg.*, Pre_codservicio As codserv,REG_fecnacimiento,   ;
		descrabrev,ENT_nroprestadorexterno ;
		from mwkambula0 ;
		left Join mwkentexg On codent = codentexc ;
		left Join mwkprotomsg On protocolo = TAM_protocolo  ;
		left Join mwkciap2e On mwkciap2e.Id = codcie9 ;
		group By fechahoraing ,protocolo,codprest,mwkambula0.Id,AFI_nroafiliado ;
		order By fechahoraing Into Cursor &mcursor

Endcase
