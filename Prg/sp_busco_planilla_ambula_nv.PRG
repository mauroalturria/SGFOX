****
** busca los protocolo de ambula para la grilla
****

Parameter mcual,mfecha1,mfecha2,mbuscog,mbuscov,mtodos

If vartype (mtodos)#"N"
	mtodos = 0
Endif

If vartype (mbuscog)#"C"
	mbuscog = ''
Endif

If type ('mbuscov')#"C"
	mbuscov = ''
Endif
mfechactr = sp_busco_fecha_serv('DT')

If inlist(type("mfecha1"),"T","D")
	mfecha = mfecha1
Else
	mfecha = ttod(mfechactr)
Endif
If !inlist(type("mfecha2"),"T","D")
	mfecha2 = ttod(mfechactr)
Endif
mfechaobs = mfechactr - 14400  && 4 horas

If mcual <> 6  && si es salida profesional

	mitime = seconds()
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
	mitime2 = seconds()
	
*	messagebox(transfor(mitime2-mitime))
	Select * from mwkprotomsg0 order by TAM_protocolo,TAM_Fechah group by TAM_protocolo  into cursor mwkprotomsg
Endif
Do case

Case mcual = 1	&& planilla completa
	mf1 = prg_dtoc(mfecha1)
	mf2 = prg_dtoc(mfecha2+1)
	mret = SQLExec(mcon1, "select protocolo, fechahoraing,demanda, REG_nombrepac, nombre, codprest, ENT_descrient, " + ;
		"PRE_descriprest, PRE_especialidad, fechahoraate, codestado, TabAmbulatorio.id, prestacions.Pre_codservicio, " + ;
		"REG_nrohclinica, REG_telefonos, REG_domicilio, AFI_nroafiliado, ESP_descripcion,"+;
		" TabAmbulatorio.codent, nroregistrac,TabAmbulatorio.codmed,TabAmbulatorio.ID, tipoest,descrip,codcie9  " + ;
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
		"TabAmbulatorio.fechahoraing < ?mf2  " + mbuscog , "mwkambula0")
		
	Select protocolo, fechahoraing,demanda, REG_nombrepac, nombre, codprest, ENT_descrient, ;
		PRE_descriprest, PRE_especialidad, fechahoraate, codestado, mwkambula0.id, 0 as prioridad, ;
		REG_nrohclinica, REG_telefonos, REG_domicilio, AFI_nroafiliado, ESP_descripcion,;
		codent, nroregistrac,mwkambula0.codmed,tpopac,tipoest,0 as puesto,descrip ;
		,codentexc,fecpasiva,tpopac,codcie9,descrabrev,mwkprotomsg.*, Pre_codservicio as codserv    ;
		from mwkambula0 ;
		left join mwkentexg on codent = codentexc ;
		left join mwkprotomsg on protocolo = TAM_protocolo  ;
		left join mwkciap2e on mwkciap2e.id = codcie9 ;
		group by fechahoraing ,protocolo,codprest,mwkambula0.id,AFI_nroafiliado ;
		order by fechahoraing into cursor mwkambula



Case mcual = 5		&& planilla enfermeria

	mf1 = prg_dtoc(mfecha1)
	
	mret = SQLExec(mcon1, "select protocolo, fechahoraing, demanda, REG_nombrepac, nombre, " + ;
		"tabambulatorio.codprest, ENT_descrient, " + ;
		"PRE_descriprest, PRE_especialidad, fechahoraate, " + ;
		"prestacions.Pre_codservicio, "+;
		"codestado, TabAmbulatorio.id, 0 as prioridad, " + ;
		"REG_nrohclinica, REG_telefonos, "+;
		"REG_domicilio, AFI_nroafiliado, ESP_descripcion, " + ;
		"TabAmbulatorio.codent, nroregistrac, " + ;
		"TabAmbulatorio.codmed, tipoest, EA_indicNurse, 0 as EA_codmed, " + ;
		"EA_evolucion,EA_evolNurse, " + ;
		"0 AS puesto, descrip, codcie9, EA_newindic, " + ;
		"PRE_codservicio, TabAmbulatorio.NroVale, " + ;
		"TabAmbevol.Id as IdAmbEvol, especialid.ESP_codesp  " + ;
		"from TabAmbulatorio " + ;
		"Inner join entidades on TabAmbulatorio.codent	= entidades.ENT_codent " + ;
		"left outer join prestadores on TabAmbulatorio.codmed = prestadores.id " + ;
		"left join TabAmbevol on TabAmbulatorio.protocolo = TabAmbevol.EA_protocolo " + ;
		"inner join PRESTACIONS on prestacions.pre_codprest = TabAmbulatorio.codprest " + ;
		"inner join tabtipoaltas on TabAmbulatorio.codestado = tabtipoaltas.id " + ;
		"inner join especialid on prestacions.PRE_especialidad = especialid.ESP_codesp " + ;
		"inner join registracio on TabAmbulatorio.nroregistrac = registracio.REG_nroregistrac " + ;
		"inner join afiliacion on " + ;
			"TabAmbulatorio.nroregistrac = afiliacion.registracio and " + ;
			"TabAmbulatorio.codent = afiliacion.AFI_codentidad " + ;
		"where " + ;
		"TabAmbulatorio.fechahoraing >= ?mf1 " + mbuscog + ;
		"", "mwkambula0")


*!*			"Inner join TabAmbevol on TabAmbulatorio.protocolo = TabAmbevol.EA_protocolo " + ;

*!*	and "+;
*!*			" (PRE_codservicio in (1130) or PRE_especialidad = 'OBST') " + mbuscog + ;

&&		"TabAmbulatorio.fechahoraing >= ?mf1 and PRE_codservicio = 1130 " + mbuscog   

	If mret < 0
		=aerror(merror)
		Messagebox(merror(3))
	Endif

	
	Select protocolo, fechahoraing,demanda, REG_nombrepac,nombre, codprest, ENT_descrient, ;
		PRE_descriprest, PRE_especialidad, fechahoraate, codestado, mwkambula0.id, prioridad, ;
		REG_nrohclinica, REG_telefonos, REG_domicilio, AFI_nroafiliado, ESP_descripcion,;
		codent, nroregistrac,mwkambula0.codmed,tpopac,!empty(nvl(EA_indicNurse,'')) as indic, ;
		!( empty(nvl(EA_evolNurse,'')) or nvl(EA_newindic,0) = 1 ) as Atnur,;
		tipoest,puesto,descrip, Pre_codservicio as codserv  ;
		,codentexc,fecpasiva ,codcie9,descrabrev,mwkprotomsg.*,EA_indicNurse,EA_evolNurse  ;
		,EA_codmed,EA_evolucion, NroVale ;
		from mwkambula0 ;
		left join mwkentexg on codent = codentexc ;
		left join mwkciap2e on mwkciap2e.id = codcie9 ;
		left join mwkprotomsg on protocolo = TAM_protocolo  ;
		group by fechahoraing,protocolo,codprest,mwkambula0.id,AFI_nroafiliado ;
		order by fechahoraing into cursor mwkambula


Endcase
