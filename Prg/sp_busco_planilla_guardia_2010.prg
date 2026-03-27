****
** busca los protocolo de guardia para la grilla
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
If type("mfecha1")="T"
	mfecha = mfecha1
Else
	mfecha = mfechactr - 86400  && 57600 && 16hs   &&  86400  &&  24hs
Endif
mfechaobs = mfechactr - 14400  && 4 horas
mret = SQLExec(mcon1,"SELECT ID , nombre FROM TabMedExterno where gerenciadora = 0 ", "mwkMedicogua01" )
If mcual <> 6  && si es salida profesional
	mitime = seconds()
	If mcual = 3  && si es desde hasta
*!*			mret = SQLExec(mcon1, "select TGM_protocolo,TGM_Fechah , TGM_estado , TGM_mensaje , TGM_usuario  " + ;
*!*				" from guardia left outer join TabGuaMsg on guardia.protocolo = TabGuaMsg.TGM_protocolo " + ;
*!*				" where fechahoraing >= ?mfechaobs and TGM_estado <> 9 and TGM_codmed = 1 " + ;
*!*				" ", "mwkprotomsg0")
		mret = SQLExec(mcon1, "select TGM_protocolo,TGM_Fechah , TGM_estado , TGM_mensaje , TGM_usuario  " + ;
			" from TabGuaMsg " + ;
			" where TGM_Fechah >= ?mfechaobs and TGM_estado <> 9 and TGM_codmed = 1 " + ;
			" ", "mwkprotomsg0")
	Else
*!*			mret = SQLExec(mcon1, "select TGM_protocolo ,TGM_Fechah , TGM_estado , TGM_mensaje , TGM_usuario  " + ;
*!*				" from guardia left outer join TabGuaMsg on guardia.protocolo = TabGuaMsg.TGM_protocolo " + ;
*!*				" where fechahoraing >= ?mfecha and TGM_estado <> 9 and TGM_codmed = 1 " + ;
*!*				" ", "mwkprotomsg0")
		mret = SQLExec(mcon1, "select TGM_protocolo ,TGM_Fechah , TGM_estado , TGM_mensaje , TGM_usuario  " + ;
			" from TabGuaMsg " + ;
			" where TGM_Fechah >= ?mfecha and TGM_estado <> 9 and TGM_codmed = 1 " + ;
			" ", "mwkprotomsg0")
	Endif
	mitime2 = seconds()
*!*	messagebox(transfor(mitime2-mitime))
	Select * from mwkprotomsg0 order by TGM_protocolo,TGM_Fechah group by TGM_protocolo  into cursor mwkprotomsg
Endif

Do case

Case mcual = 1 && Planilla completa

*!*		mret = SQLExec(mcon1, "select protocolo, fechahoraing, REG_nombrepac, nombre, codprest, ENT_descrient, " + ;
*!*			"PRE_descriprest, PRE_especialidad, fechahoraate, codestado, guardia.id, prioridad, " + ;
*!*			"REG_nrohclinica, REG_telefonos, REG_domicilio, AFI_nroafiliado, ESP_descripcion,"+;
*!*			" guardia.codent, nroregistrac,guardia.codmed,guardia.ID, tipoest,puesto,descrip,codcie9  " + ;
*!*			"from prestacions, entidades, especialid, registracio, afiliacion," + ;
*!*			"tabtipoaltas,guardia left outer join prestadores on guardia.codmed = prestadores.id " + ;
*!*			"where guardia.nroregistrac = registracio.REG_nroregistrac and " + ;
*!*			"guardia.nroregistrac = afiliacion.registracio and " + ;
*!*			"guardia.codent = afiliacion.AFI_codentidad and " + ;
*!*			"guardia.codprest = prestacions.PRE_codprest and " + ;
*!*			"guardia.codestado 		= tabtipoaltas.id and " + ;
*!*			"prestacions.PRE_especialidad = ESP_codesp and " + ;
*!*			"guardia.codent	= entidades.ENT_codent and " + ;
*!*			"guardia.fechahoraing >= ?mfecha and PRE_codservicio = 8000 " + ;
*!*			"", "mwkguardia0")

	mret = SQLExec(mcon1,"select protocolo,fechahoraing,REG_nombrepac,nombre, codprest, ENT_descrient,"+;
		"PRE_descriprest,PRE_especialidad,fechahoraate,codestado,guardia.id,prioridad,REG_nrohclinica,"+;
		"REG_telefonos, REG_domicilio, AFI_nroafiliado, ESP_descripcion, guardia.codent, nroregistrac,"+;
		"guardia.codmed,guardia.ID, tipoest,puesto,descrip,codcie9"+;
		" from guardia"+;
		" join registracio on registracio.REG_nroregistrac = guardia.nroregistrac"+;
		" join afiliacion on afiliacion.registracio = guardia.nroregistrac"+;
		" and afiliacion.AFI_codentidad = guardia.codent"+;
		" join prestacions on prestacions.PRE_codprest = guardia.codprest and PRE_codservicio = 8000"+;
		" join tabtipoaltas on tabtipoaltas.id = guardia.codestado"+;
		" join especialid on ESP_codesp = prestacions.PRE_especialidad"+;
		" join entidades on entidades.ENT_codent = guardia.codent"+;
		" left outer join prestadores on guardia.codmed = prestadores.id"+;
		" where guardia.fechahoraing >= ?mfecha","mwkguardia0")

	If used("mwkMedicogua01" )
		Select protocolo, fechahoraing, REG_nombrepac, ;
			iif(isnull(mwkguardia0.nombre) or (empty(mwkguardia0.nombre) and codmed>1),mwkMedicogua01.nombre,mwkguardia0.nombre) as nombre, ;
			codprest, ENT_descrient, ;
			PRE_descriprest, PRE_especialidad, fechahoraate, codestado, mwkguardia0.id, prioridad, ;
			REG_nrohclinica, REG_telefonos, REG_domicilio, AFI_nroafiliado, ESP_descripcion,;
			codent, nroregistrac,mwkguardia0.codmed,tpopac,tipoest,nvl(puesto,0) as puesto,descrip ;
			,codentexc,fecpasiva,tpopac,codcie9,descrabrev,mwkprotomsg.*    ;
			from mwkguardia0 left join mwkMedicogua01 on codmed = mwkMedicogua01.id  ;
			left join mwkentexg on codent = codentexc ;
			left join mwkprotomsg on protocolo = TGM_protocolo  ;
			left join mwkciap2e on mwkciap2e.id = codcie9 ;
			group by fechahoraing ,protocolo,codprest,mwkguardia0.id,AFI_nroafiliado ;
			order by fechahoraing into cursor mwkguardia
	Else
		Select * from mwkguardia0 ;
			left join mwkentexg on codent = codentexc ;
			left join mwkciap2e on mwkciap2e.id = codcie9 ;
			left join mwkprotomsg on protocolo = TGM_protocolo  ;
			into cursor mwkguardia
	Endif


Case  mcual = 2 && Planilla para asignacion de profesional

*!*		mret = SQLExec(mcon1, "select protocolo, fechahoraing, REG_nombrepac, codprest, ENT_descrient, " + ;
*!*			"PRE_descriprest, PRE_especialidad, fechahoraate, codestado, guardia.id, prioridad, " + ;
*!*			"REG_nrohclinica, REG_telefonos, REG_domicilio, AFI_nroafiliado, ESP_descripcion, "+;
*!*			"guardia.codmed,guardia.codent, nroregistrac, tipoest, puesto,descrip " + ;
*!*			"from guardia, prestacions, registracio, entidades, afiliacion, especialid,tabtipoaltas " + ;
*!*			"where guardia.nroregistrac = registracio.REG_nroregistrac and " + ;
*!*			"guardia.nroregistrac = afiliacion.registracio and " + ;
*!*			"guardia.codent = afiliacion.AFI_codentidad and " + ;
*!*			"guardia.codestado 		= tabtipoaltas.id and " + ;
*!*			"prestacions.PRE_especialidad = ESP_codesp and " + ;
*!*			"guardia.codprest = prestacions.PRE_codprest and " + ;
*!*			"guardia.codent = entidades.ENT_codent and " + ;
*!*			"guardia.codmed = 1 and PRE_codservicio = 8000 and " + ;
*!*			"guardia.fechahoraing >= ?mfecha and tipoest in (4,2) " , "mwkguardia")

	mret = SQLExec(mcon1,"select protocolo, fechahoraing, REG_nombrepac, codprest, ENT_descrient,"+;
		"PRE_descriprest, PRE_especialidad, fechahoraate, codestado, guardia.id, prioridad,"+;
		"REG_nrohclinica, REG_telefonos, REG_domicilio, AFI_nroafiliado, ESP_descripcion,"+;
		"guardia.codmed, guardia.codent, nroregistrac, tipoest, puesto, descrip"+;
		" from guardia"+;
		" join registracio on registracio.REG_nroregistrac = guardia.nroregistrac"+;
		" join afiliacion on afiliacion.registracio = guardia.nroregistrac"+;
		" and afiliacion.AFI_codentidad = guardia.codent"+;
		" join prestacions on prestacions.PRE_codprest = guardia.codprest and PRE_codservicio = 8000"+;
		" join especialid on ESP_codesp = prestacions.PRE_especialidad"+;
		" join tabtipoaltas on tabtipoaltas.id = guardia.codestado and tipoest in (4,2)"+;
		" join entidades on entidades.ENT_codent = guardia.codent"+;
		" where guardia.fechahoraing >= ?mfecha and guardia.codmed = 1","mwkguardia")


*!*		mret = SQLExec(mcon1, "select protocolo, REG_nombrepac, codprest, codestado, guardia.id, " + ;
*!*			"guardia.codmed,guardia.codent, nroregistrac, tipoest,EGM_CODMED " + ;
*!*			"from guardia, prestacions, registracio, tabtipoaltas,TabGuaEvolmed   " + ;
*!*			"where guardia.nroregistrac = registracio.REG_nroregistrac and " + ;
*!*			"guardia.codestado = tabtipoaltas.id and EGM_proto = protocolo and " + ;
*!*			"guardia.codprest = PRE_codprest and tipoest = 2 and " + ;
*!*			"guardia.codmed > 1 and PRE_codservicio = 8000 and EGM_fechah < ?mfechaobs and " + ;
*!*			"guardia.fechahoraing >= ?mfecha order by EGM_fechah " , "mwkguardiaobs")


	mret = SQLExec(mcon1,"select protocolo, REG_nombrepac, codprest, codestado, guardia.id,"+;
		"guardia.codmed, guardia.codent, nroregistrac, tipoest, EGM_CODMED"+;
		" from guardia"+;
		" join registracio on registracio.REG_nroregistrac = guardia.nroregistrac"+;
		" join prestacions on PRE_codprest = guardia.codprest and PRE_codservicio = 8000"+;
		" join tabtipoaltas on tabtipoaltas.id = guardia.codestado and tipoest = 2"+;
		" join TabGuaEvolmed on EGM_proto = protocolo and EGM_fechah < ?mfechaobs"+;
		" where guardia.fechahoraing >= ?mfecha  and guardia.codmed > 1"+;
		" order by EGM_fechah","mwkguardiaobs")

	Select *,space(30) as nombre ;
		from mwkguardia left join mwkentexg on codent = codentexc ;
		left join mwkprotomsg on protocolo = TGM_protocolo  ;
		into cursor mwkguardia

Case mcual = 3 && Planilla desde hasta fecha

	horactr = val(left(ttoc(mfechactr,2),2))
	mf1     = prg_dtoc( mfecha1 )
	mf2     = prg_dtoc( mfecha2 + 1 )

*!*	mserv = iif(mtodos=1," val_codservvale <> 5410 and ",;
*!*		" pia_codprest = codprest and val_codservvale in ( 8000,2150,6500,9600 ) and " )

*!*		mret = SQLExec(mcon1, "select guardia.protocolo, fechahoraing, REG_nombrepac," + ;
*!*			" nombre, codprest, ent_descrient, pre_descriprest, " + ;
*!*			" pre_especialidad, fechahoraate, codestado, guardia.id," + ;
*!*			" prioridad,guardiavale.nrovale, reg_nrohclinica,pia_codprest," + ;
*!*			" reg_telefonos, reg_domicilio, afi_nroafiliado," + ;
*!*			" esp_descripcion, guardia.codent,guardiavale.codserv, guardia.codmed, " + ;
*!*			"nroregistrac, guardia.usuario,ptovta, tpocte,nrocte,letracte, fechacte,nroregistracio "+;
*!*			" ,val_horasolicitud,val_fechasolicitud,val_codvaleasist,tipoest,descrip," + ;
*!*			" val_prestador ,val_codservvale, val_bono,reg_numdocumento, pia_cantsolicitada,"+;
*!*			"guardiavale.diagnostico,TabCiap2E.DescrAbrev as descie " + ;
*!*			"from afiliacion,prestacions,valesasist,presinsuvas,tabtipoaltas,guardia "+;
*!*			"left outer join entidades 		on guardia.codent				= entidades.ent_codent " + ;
*!*			"left outer join especialid 	on prestacions.pre_especialidad = especialid.esp_codesp " + ;
*!*			"left outer join registracio 	on guardia.nroregistrac 		= registracio.reg_nroregistrac " + ;
*!*			"left outer join guardiavale 	on guardia.protocolo 			= guardiavale.protocolo " + ;
*!*			"left outer join prestadores 	on guardia.codmed 				= prestadores.id " + ;
*!*			"left outer join tabfacturas 	on tabfacturas.codpun 			= valesasist.val_codpun " +;
*!*			"left outer join TabCiap2E      on TabCiap2E.Id                 = guardia.codcie9 "+;
*!*			"where " + ;
*!*			" guardiavale.nrovale = val_codvaleasist and "+;
*!*			" presinsuvas.pia_valesasist = val_codpun and "+;
*!*			" pia_codprest = prestacions.pre_codprest and "+;
*!*			" guardia.codestado = tabtipoaltas.id and " + ;
*!*			"guardia.nroregistrac = afiliacion.registracio and " + ;
*!*			"guardia.codent = afiliacion.afi_codentidad and " + mserv +;
*!*			"guardia.fechahoraing >= ?mf1 and " + ;
*!*			"guardia.fechahoraing < ?mf2 " + mbuscog , "mwkguardia01")

	mserv = iif(mtodos=1," val_codservvale <> 5410 and ",;
		"  val_codservvale in ( 8000,2150,6500,9600 ) " )

	mret = SQLExec(mcon1,"select guardia.protocolo,fechahoraing,REG_nombrepac, nombre, codprest, ent_descrient,"+;
		"pre_descriprest, pre_especialidad, fechahoraate, codestado, guardia.id, prioridad,guardiavale.nrovale,"+;
		"reg_nrohclinica, pia_codprest, reg_telefonos, reg_domicilio, afi_nroafiliado, esp_descripcion,"+;
		"guardia.codent,guardiavale.codserv, guardia.codmed,nroregistrac, guardia.usuario,ptovta,tpocte,nrocte,"+;
		"letracte, fechacte, nroregistracio ,val_horasolicitud, val_fechasolicitud, val_codvaleasist, tipoest, "+;
		"descrip, val_prestador , val_codservvale, val_bono,reg_numdocumento, pia_cantsolicitada,"+;
		"guardiavale.diagnostico,TabCiap2E.DescrAbrev as descie"+;
		" from guardia"+;
		" join tabtipoaltas on  tabtipoaltas.id = guardia.codestado"+;
		" join afiliacion on afiliacion.registracio = guardia.nroregistrac"+;
		" and afiliacion.afi_codentidad = guardia.codent"+;
		" join guardiavale on guardiavale.protocolo = guardia.protocolo"+;
		" join valesasist on val_codvaleasist = guardiavale.nrovale and "+ mserv +;
		" join presinsuvas on presinsuvas.pia_valesasist = val_codpun and "+;
		" presinsuvas.pia_codprest = guardia.codprest"+;
		" join prestacions on prestacions.pre_codprest = presinsuvas.pia_codprest"+;
		" left outer join entidades on entidades.ent_codent = guardia.codent"+;
		" left outer join especialid on especialid.esp_codesp = prestacions.pre_especialidad"+;
		" left outer join registracio on registracio.reg_nroregistrac = guardia.nroregistrac"+;
		" left outer join prestadores on prestadores.id = guardia.codmed"+;
		" left outer join tabfacturas on tabfacturas.codpun = valesasist.val_codpun"+;
		" left outer join TabCiap2E on TabCiap2E.Id = guardia.codcie9"+;
		" where guardia.fechahoraing >= ?mf1 and guardia.fechahoraing < ?mf2 "+ mbuscog , "mwkguardia01")

	If mret<1
		=aerr(eros)
		Messagebox(eros(3))
	Endif

	If used("mwkMedicogua01" )
		Select protocolo, fechahoraing, REG_nombrepac, ;
			iif(isnull(mwkguardia01.nombre) or (empty(mwkguardia01.nombre) and codmed>1),mwkMedicogua01.nombre,mwkguardia01.nombre) as nombre, ;
			codprest, ENT_descrient, ;
			PRE_descriprest, PRE_especialidad, fechahoraate, codestado, mwkguardia01.id,;
			prioridad,nrovale, REG_nrohclinica, REG_telefonos, REG_domicilio, AFI_nroafiliado, ;
			ESP_descripcion, codent,codserv, codmed, nroregistrac, usuario,pia_codprest,;
			ptovta, tpocte,nrocte,letracte, nroregistracio ,val_horasolicitud,val_fechasolicitud,val_codvaleasist, ;
			val_prestador ,val_codservvale, val_bono,reg_numdocumento,tipoest,descrip,;
			pia_cantsolicitada,diagnostico,descie,fechacte  ;
			from mwkguardia01 left join mwkMedicogua01 on codmed = mwkMedicogua01.id  ;
			group by nrovale,pia_codprest;
			order by fechahoraing into cursor mwkguardia
	Else
		Select * from mwkguardia01 ;
			group by nrovale,pia_codprest;
			order by fechahoraing into cursor mwkguardia
	Endif

Case  mcual = 4 && planilla para asignacion de profesional interconsulta

*!*		mret = SQLExec(mcon1, "select protocolo, fechahoraing, REG_nombrepac, codprest, ENT_descrient, " + ;
*!*			"PRE_descriprest, PRE_especialidad, fechahoraate, codestado, guardia.id, prioridad, " + ;
*!*			"REG_nrohclinica, REG_telefonos, REG_domicilio, AFI_nroafiliado, ESP_descripcion, "+;
*!*			"guardia.codmed,guardia.codent, nroregistrac, tipoest, puesto,descrip,nombre " + ;
*!*			"from prestacions, registracio, entidades, afiliacion, especialid,tabtipoaltas,guardia " + ;
*!*			"left outer join prestadores on guardia.codmed = prestadores.id " + ;
*!*			"where guardia.nroregistrac = registracio.REG_nroregistrac and " + ;
*!*			"guardia.nroregistrac = afiliacion.registracio and " + ;
*!*			"guardia.codent = afiliacion.AFI_codentidad and " + ;
*!*			"guardia.codestado = tabtipoaltas.id and " + ;
*!*			"prestacions.PRE_especialidad = ESP_codesp and " + ;
*!*			"guardia.codprest = prestacions.PRE_codprest and " + ;
*!*			"guardia.codent = entidades.ENT_codent and " + ;
*!*			"guardia.codmed > 1 and PRE_codservicio = 8000 and " + ;
*!*			"guardia.fechahoraing >= ?mfecha " , "mwkguardia0")

	mret = SQLExec(mcon1,  "select protocolo, fechahoraing, REG_nombrepac, codprest, ENT_descrient,"+;
		"PRE_descriprest, PRE_especialidad,fechahoraate,codestado,guardia.id,prioridad,REG_nrohclinica,"+;
		"REG_telefonos, REG_domicilio, AFI_nroafiliado, ESP_descripcion, guardia.codmed,guardia.codent,"+;
		"nroregistrac,tipoest,puesto,descrip,nombre"+;
		" from guardia"+;
		" join registracio on registracio.REG_nroregistrac = guardia.nroregistrac"+;
		" join afiliacion on afiliacion.registracio = guardia.nroregistrac" +;
		" and afiliacion.AFI_codentidad = guardia.codent"+;
		" join prestacions on prestacions.PRE_codprest = guardia.codprest"+;
		" and prestacions.PRE_codservicio = 8000"+;
		" join especialid on especialid.esp_codesp = prestacions.pre_especialidad"+;
		" join tabtipoaltas on tabtipoaltas.id = guardia.codestado"+;
		" join entidades on entidades.ENT_codent = guardia.codent"+;
		" left outer join prestadores on prestadores.id = guardia.codmed"+;
		" where guardia.fechahoraing >= ?mfecha and guardia.codmed > 1","mwkguardia0")

	If used("mwkMedicogua01" )

		Select protocolo, fechahoraing, REG_nombrepac, codprest, ENT_descrient,;
			PRE_descriprest, PRE_especialidad, fechahoraate, codestado, mwkguardia0.id, prioridad,;
			REG_nrohclinica, REG_telefonos, REG_domicilio, AFI_nroafiliado, ESP_descripcion,;
			codmed,codent, nroregistrac, tipoest, puesto,descrip,;
			iif(isnull(mwkguardia0.nombre) or (empty(mwkguardia0.nombre) and codmed>1),;
			mwkMedicogua01.nombre,mwkguardia0.nombre) as nombre, ;
			codentexc,fecpasiva,tpopac,mwkprotomsg.*  ;
			from mwkguardia0 left join mwkMedicogua01 on codmed = mwkMedicogua01.id  ;
			left join mwkentexg on codent = codentexc ;
			left join mwkprotomsg on protocolo = TGM_protocolo  ;
			group by fechahoraing ,protocolo,codprest,mwkguardia0.id,AFI_nroafiliado ;
			order by fechahoraing into cursor mwkguardia

	Else
		Select * from mwkguardia0 left join mwkentexg on codent = codentexc into cursor mwkguardia
	Endif


Case mcual = 5 && Planilla enfermeria

*!*		mret = SQLExec(mcon1, "select protocolo, fechahoraing, REG_nombrepac, nombre,"+;
*!*			" codprest,ENT_descrient, PRE_descriprest, PRE_especialidad, fechahoraate,"+;
*!*			" codestado, guardia.id, prioridad, REG_nrohclinica, REG_telefonos, "+;
*!*			" REG_domicilio, AFI_nroafiliado, ESP_descripcion,guardia.codent, nroregistrac,"+;
*!*			" guardia.codmed,tipoest,EG_indicNurse, eg_codmed,eg_evolucion,EG_evolNurse ,"+;
*!*			" puesto,descrip,codcie9,EG_parAlerg " +;
*!*			"from entidades, registracio, afiliacion,tabtipoaltas, guardia " + ;
*!*			"left outer join prestadores on guardia.codmed = prestadores.id " + ;
*!*			"left outer join tabguaevol on guardia.protocolo = tabguaevol.EG_protocolo " + ;
*!*			"left outer join PRESTACIONS 	on prestacions.pre_codprest		= guardia.codprest " + ;
*!*			"left outer join especialid on prestacions.PRE_especialidad = especialid.ESP_codesp " + ;
*!*			"where guardia.nroregistrac = registracio.REG_nroregistrac and " + ;
*!*			"guardia.nroregistrac = afiliacion.registracio and " + ;
*!*			"guardia.codent = afiliacion.AFI_codentidad and " + ;
*!*			"guardia.codprest = prestacions.PRE_codprest and " + ;
*!*			"guardia.codestado = tabtipoaltas.id and " + ;
*!*			"guardia.codent	= entidades.ENT_codent and " + ;
*!*			"guardia.fechahoraing >= ?mfecha  " + ;
*!*			"", "mwkguardia0")

	mret = SQLExec(mcon1,"select protocolo, fechahoraing, REG_nombrepac, nombre, codprest, ENT_descrient,"+;
		"PRE_descriprest,PRE_especialidad, fechahoraate,codestado, guardia.id, prioridad,REG_nrohclinica,"+;
		"REG_telefonos,REG_domicilio,AFI_nroafiliado,ESP_descripcion,guardia.codent,nroregistrac,guardia.codmed,"+;
		"tipoest,EG_indicNurse,eg_codmed,eg_evolucion,EG_evolNurse,puesto,descrip,codcie9,EG_parAlerg"+;
		" from guardia"+;
		" join registracio on registracio.REG_nroregistrac = guardia.nroregistrac"+;
		" join afiliacion on  afiliacion.registracio = guardia.nroregistrac"+;
		" and afiliacion.AFI_codentidad = guardia.codent"+;
		" join tabtipoaltas on tabtipoaltas.id = guardia.codestado"+;
		" join entidades on entidades.ENT_codent = guardia.codent" +;
		" join prestacions on prestacions.pre_codprest = guardia.codprest"+;
		" left outer join prestadores on guardia.codmed = prestadores.id" +;
		" left outer join tabguaevol on guardia.protocolo = tabguaevol.EG_protocolo"+;
		" left outer join especialid on especialid.ESP_codesp prestacions.PRE_especialidad "+;
		" where guardia.fechahoraing >= ?mfecha","mwkguardia0")

	If used("mwkMedicogua01" )
		Select protocolo, fechahoraing, REG_nombrepac, ;
			iif(isnull(mwkguardia0.nombre) or (empty(mwkguardia0.nombre) and codmed>1),mwkMedicogua01.nombre,mwkguardia0.nombre) as nombre, ;
			codprest, ENT_descrient, ;
			PRE_descriprest, PRE_especialidad, fechahoraate, codestado, mwkguardia0.id, prioridad, ;
			REG_nrohclinica, REG_telefonos, REG_domicilio, AFI_nroafiliado, ESP_descripcion,;
			codent, nroregistrac,mwkguardia0.codmed,tpopac,!empty(nvl(EG_indicNurse,'')) as indic    ;
			,!(empty(nvl(EG_evolNurse,'')) or nvl(EG_parAlerg,0) = 1) as Atnur,tipoest,puesto,descrip ;
			,codentexc,fecpasiva ,codcie9,descrabrev,mwkprotomsg.*,EG_indicNurse,EG_evolNurse  ;
			,eg_codmed,eg_evolucion;
			from mwkguardia0 left join mwkMedicogua01 on codmed = mwkMedicogua01.id  ;
			left join mwkentexg on codent = codentexc ;
			left join mwkciap2e on mwkciap2e.id = codcie9 ;
			left join mwkprotomsg on protocolo = TGM_protocolo  ;
			group by fechahoraing ,protocolo,codprest,mwkguardia0.id,AFI_nroafiliado ;
			order by fechahoraing into cursor mwkguardia
	Else
		Select * from mwkguardia0 left join mwkentexg on codent = codentexc into cursor mwkguardia
	Endif

Case mcual = 6 && planilla  Habilitación de profesionales en guardia

	Set STEP ON

	mpaso = .t.
	If used('mwkguardiaf')
		Use in mwkguardiaf
	Endif
	If used('mwkguardiaf1')
		Use in mwkguardiaf1
	Endif
	If used('mwkguardiaf2')
		Use in mwkguardiaf2
	Endif
	If used('mwkguaderiv')
		Use in mwkguaderiv
	Endif

*!*		mret = SQLExec(mcon1, "select protocolo,fechahoraing,REG_nombrepac,codprest,ENT_descrient," + ;
*!*			"PRE_descriprest,PRE_especialidad,fechahoraate,codestado,guardia.id,prioridad," + ;
*!*			"REG_nrohclinica,REG_telefonos,REG_domicilio,ESP_descripcion,"+;
*!*			"guardia.codmed,guardia.codent,nroregistrac,tipoest,puesto,descrip " + ;
*!*			"from guardia,prestacions,registracio,entidades,especialid,tabtipoaltas " + ;
*!*			"where guardia.nroregistrac = registracio.REG_nroregistrac and " + ;
*!*			"guardia.codestado = tabtipoaltas.id and " + ;
*!*			"prestacions.PRE_especialidad = ESP_codesp and " + ;
*!*			"guardia.codprest = prestacions.PRE_codprest and " + ;
*!*			"guardia.codent = entidades.ENT_codent and " + ;
*!*			"PRE_codservicio = 8000 " + mbuscog +;
*!*			"and guardia.fechahoraing >= ?mfecha and tipoest in (5,2)" , "mwkguardiaf1")


	mret = SQLExec(mcon1,"select protocolo,fechahoraing,REG_nombrepac,codprest,ENT_descrient,PRE_descriprest,"+;
		"PRE_especialidad,fechahoraate,codestado,guardia.id,prioridad,REG_nrohclinica,REG_telefonos,REG_domicilio,"+;
		"ESP_descripcion,guardia.codmed,guardia.codent,nroregistrac,tipoest,puesto,descrip"+;
		" from guardia"+;
		" join registracio on registracio.REG_nroregistrac = guardia.nroregistrac"+;
		" join prestacions on prestacions.PRE_codprest = guardia.codprest and PRE_codservicio = 8000"+;
		" join especialid on especialid.ESP_codesp = prestacions.PRE_especialidad "+;
		" join tabtipoaltas on tabtipoaltas.id = guardia.codestado and tipoest in (5,2)"+;
		" join entidades on entidades.ENT_codent = guardia.codent"+;
		" where guardia.fechahoraing >= ?mfecha" + mbuscog , "mwkguardiaf1")

	If mret > 0

		mbus1 = strtran(mbuscog, "and guardia.codmed","TGD_medDer")
		mret = SQLExec(mcon1,"select TGD_medDer , TGD_protocolo  from TabGuaDeriv "+;
			"where TGD_Estado = 1 and TGD_fechaDer >= ?mfecha1","mwkguaderiv")
		If mret > 0
			Select * from mwkguardiaf1 where mwkguardiaf1.protocolo not in ;
				(select TGD_protocolo from mwkguaderiv) into cursor mwkguardiaf1

			Select TGD_protocolo from mwkguaderiv where &mbus1 into cursor mwkctrlder
			If reccount("mwkctrlder")>0

*!*             Pacientes en guardia que presentan una derivación del profesional original a otro

*!*					mret = SQLExec(mcon1, "select protocolo,fechahoraing,REG_nombrepac,codprest,ENT_descrient," + ;
*!*						"PRE_descriprest,PRE_especialidad,fechahoraate,codestado,guardia.id,prioridad," + ;
*!*						"REG_nrohclinica,REG_telefonos,REG_domicilio,ESP_descripcion,"+;
*!*						"guardia.codmed,guardia.codent,nroregistrac,tipoest,puesto,descrip " + ;
*!*						"from guardia,prestacions,registracio,entidades,especialid,tabtipoaltas,TabGuaDeriv " + ;
*!*						"where guardia.nroregistrac = registracio.REG_nroregistrac and " + ;
*!*						"guardia.codestado = tabtipoaltas.id and " + ;
*!*						"prestacions.PRE_especialidad = ESP_codesp and " + ;
*!*						"guardia.codprest = prestacions.PRE_codprest and " + ;
*!*						"guardia.codent = entidades.ENT_codent and " + ;
*!*						"PRE_codservicio = 8000 " + mbuscov +;
*!*						"and guardia.fechahoraing >= ?mfecha and tipoest in (5,2) " , "mwkguardiaf2")

				If left(alltrim(mbuscov),3)='and'
					mbuscov2 = substr(alltrim(mbuscov),4)
					mbuscov  = mbuscov2
				Endif

				mret = SQLExec(mcon1,"select protocolo,fechahoraing,REG_nombrepac,codprest,ENT_descrient,"+;
					"PRE_descriprest,PRE_especialidad,fechahoraate,codestado,guardia.id,prioridad,"+;
					"REG_nrohclinica,REG_telefonos,REG_domicilio,ESP_descripcion,"+;
					"guardia.codmed,guardia.codent,nroregistrac,tipoest,puesto,descrip"+;
					" from guardia"+;
					" join prestacions on prestacions.PRE_codprest = guardia.codprest"+;
					" and PRE_codservicio = 8000"+;
					" join registracio on registracio.REG_nroregistrac = guardia.nroregistrac"+;
					" join entidades on entidades.ENT_codent = guardia.codent"+;
					" join especialid on ESP_codesp = prestacions.PRE_especialidad"+;
					" join tabtipoaltas on tabtipoaltas.id = guardia.codestado and tipoest in (5,2)"+;
					" join TabGuaDeriv on " + mbuscov +;
					" where guardia.fechahoraing >= ?mfecha ", "mwkguardiaf2")

				If mret > 0
					Select * from mwkguardiaf1 union select * from mwkguardiaf2 into cursor mwkguardiaf
					If used('mwkentexg')
						Select *,space(30) as nombre from mwkguardiaf left join mwkentexg on codent = codentexc into cursor mwkguardiaf
					Endif
					mpaso = .f.
				Endif

			Else
				Select * from mwkguardiaf1 into cursor mwkguardiaf
				If used('mwkentexg')
					Select *,space(30) as nombre from mwkguardiaf left join mwkentexg on codent = codentexc into cursor mwkguardiaf
				Endif
				mpaso = .f.

			Endif
		Endif
	Endif
	If mpaso
		Messagebox("EN LA CONSULTA DEL PROFESIONAL Y EVOLUCION, "+chr(10)+"DERIVACION DE PACIENTES, AVISE A SISTEMAS",16,"ERROR")
	Endif

Case mcual = 7 && Planilla desde hasta fecha

*!*		mserv = iif(mtodos=1," val_codservvale<> 5410 and ",;
*!*			" pia_codprest = codprest and val_codservvale in ( 8000,2150,6500,9600) and " )

*!*		mret = SQLExec(mcon1, "select guardia.protocolo, fechahoraing, REG_nombrepac," + ;
*!*			" nombre, codprest, ent_descrient, pre_descriprest, " + ;
*!*			" pre_especialidad, fechahoraate, codestado, guardiavale.id," + ;
*!*			" prioridad,guardiavale.nrovale, reg_nrohclinica," + ;
*!*			" reg_telefonos, reg_domicilio,afi_nroafiliado,pia_codprest, " + ;
*!*			" esp_descripcion, guardia.codent,guardiavale.codserv, guardia.codmed, " + ;
*!*			"guardia.nroregistrac,guardia.usuario ,fechamodif,"+;
*!*			" reg_numdocumento,descrip,codcie9,tipoest,val_operadorcarga " + ;
*!*			"from afiliacion,valesasist,tabtipoaltas,presinsuvas,guardia  "+;
*!*			"left outer join entidades 		on guardia.codent				= entidades.ent_codent " + ;
*!*			"left outer join PRESTACIONS 	on prestacions.pre_codprest		= guardia.codprest " + ;
*!*			"left outer join  especialid 	on prestacions.pre_especialidad = especialid.esp_codesp " + ;
*!*			"left outer join  registracio 	on guardia.nroregistrac 		= registracio.reg_nroregistrac " + ;
*!*			"left outer join guardiavale 	on guardia.protocolo 			= guardiavale.protocolo " + ;
*!*			"left outer join prestadores 	on guardia.codmed 				= prestadores.id " + ;
*!*			"where " + ;
*!*			" guardiavale.nrovale = val_codvaleasist and "+;
*!*			" pia_codprest = prestacions.pre_codprest and "+ mserv +;
*!*			"guardia.nroregistrac = afiliacion.registracio and " + ;
*!*			" presinsuvas.pia_valesasist = val_codpun and "+;
*!*			" pia_codprest = prestacions.pre_codprest and "+;
*!*			"guardia.codent = afiliacion.afi_codentidad and " + ;
*!*			"guardia.codestado 		= tabtipoaltas.id and " + ;
*!*			"guardia.fechahoraing >= ?mfecha1 and " + ;
*!*			"guardia.fechahoraing <= ?mfecha2 "+mbuscog , "mwkguardia01")

	If mtodos = 1
		mserv  = " and valesasist.val_codservvale <> 5410 "
	Else
		mserv  = " and valesasist.val_codservvale in ( 8000,2150,6500,9600) "
		mserv2 = " and presinsuvas.pia_codprest = guardia.codprest "
	Endif

	mret = SQLExec(mcon1,"select guardia.protocolo, fechahoraing, REG_nombrepac,"+ ;
		" nombre, codprest, ent_descrient, pre_descriprest," + ;
		" pre_especialidad, fechahoraate, codestado, guardiavale.id," + ;
		" prioridad,guardiavale.nrovale, reg_nrohclinica," + ;
		" reg_telefonos, reg_domicilio,afi_nroafiliado,pia_codprest,"+ ;
		" esp_descripcion, guardia.codent,guardiavale.codserv, guardia.codmed," + ;
		" guardia.nroregistrac,guardia.usuario ,fechamodif," + ;
		" reg_numdocumento,descrip,codcie9,tipoest,val_operadorcarga"  + ;
		" from guardia"   + ;
		" join PRESTACIONS on prestacions.pre_codprest = guardia.codprest" + ;
		" join guardiavale on guardiavale.protocolo = guardia.protocolo"+ ;
		" join afiliacion on afiliacion.registracio = guardia.nroregistrac" + ;
		" and afiliacion.afi_codentidad = guardia.codent" + ;
		" join valesasist on val_codvaleasist = guardiavale.nrovale " + mserv ;
		" join tabtipoaltas on tabtipoaltas.id = guardia.codestado"+ ;
		" join presinsuvas on pia_codprest = prestacions.pre_codprest " + mserv2 ;
		" and presinsuvas.pia_valesasist = val_codpun and pia_codprest = prestacions.pre_codprest"+ ;
		" left outer join entidades on entidades.ent_codent = guardia.codent"+ ;
		" left outer join especialid  on especialid.esp_codesp = prestacions.pre_especialidad"+ ;
		" left outer join registracio on registracio.reg_nroregistrac = guardia.nroregistrac"+ ;
		" left outer join prestadores on prestadores.id = guardia.codmed" + ;
		" where guardia.fechahoraing >= ?mfecha1 and guardia.fechahoraing <= ?mfecha2 " + mbuscog, "mwkguardia01")

&&& saque 5800

	If mret<1
		=aerr(eros)
		Messagebox(eros(3))
	Endif
	If used("mwkMedicogua01" )
		Select protocolo, fechahoraing, REG_nombrepac, ;
			iif(isnull(mwkguardia01.nombre) or (empty(mwkguardia01.nombre) and codmed>1),mwkMedicogua01.nombre,mwkguardia01.nombre) as nombre, ;
			codprest, ENT_descrient, PRE_descriprest, PRE_especialidad, fechahoraate, codestado, mwkguardia01.id,;
			prioridad,nrovale, REG_nrohclinica, REG_telefonos, REG_domicilio, ;
			ESP_descripcion, codent,codserv, codmed,tipoest, val_operadorcarga,  ;
			nroregistrac,reg_numdocumento,descrabrev,AFI_nroafiliado,descrip,fechamodif    ;
			from mwkguardia01 left join mwkMedicogua01 on codmed = mwkMedicogua01.id  ;
			left join mwkciap2e on mwkciap2e.id = codcie9 ;
			group by protocolo,nrovale ;
			order by fechahoraing into cursor mwkguardia
	Else
		Select * from mwkguardia01 ;
			group by protocolo;
			order by fechahoraing into cursor mwkguardia
	Endif

Case mcual = 8	&& Para control de profesionales con derivaciones

	mret = SQLExec(mcon1, "select protocolo,fechahoraing,REG_nombrepac as paciente,codprest,ENT_descrient," + ;
		"PRE_descriprest,PRE_especialidad,fechahoraate,codestado,guardia.id,prioridad," + ;
		"REG_nrohclinica,REG_telefonos,REG_domicilio,AFI_nroafiliado,ESP_descripcion,"+;
		"guardia.codmed,guardia.codent,nroregistrac,tipoest,puesto,descrip " + ;
		"from guardia,prestacions,registracio,entidades,afiliacion,especialid,tabtipoaltas " + ;
		"where guardia.nroregistrac = registracio.REG_nroregistrac and " + ;
		"guardia.nroregistrac = afiliacion.registracio and " + ;
		"guardia.codent = afiliacion.AFI_codentidad and " + ;
		"guardia.codestado = tabtipoaltas.id and " + ;
		"prestacions.PRE_especialidad = ESP_codesp and " + ;
		"guardia.codprest = prestacions.PRE_codprest and " + ;
		"guardia.codent = entidades.ENT_codent and " + ;
		"PRE_codservicio = 8000" + mbuscog + ;
		"and protocolo not in (select TGD_protocolo from TabGuaDeriv where TGD_medcab=?mcodmed) "+;
		"and guardia.fechahoraing >= ?mfecha and tipoest in (5,2)" , "mwkguardia1")

	If mret < 0
		Messagebox("EN ARMADO DE PLANILLA DE GUARDIA,"+chr(10)+;
			"PROFESIONALES",16,"ERROR")
	Else
		mret = SQLExec(mcon1, "select protocolo,fechahoraing,REG_nombrepac,codprest,ENT_descrient," + ;
			"PRE_descriprest,PRE_especialidad,fechahoraate,codestado,guardia.id,prioridad," + ;
			"REG_nrohclinica,REG_telefonos,REG_domicilio,AFI_nroafiliado,ESP_descripcion,"+;
			"guardia.codmed,guardia.codent,nroregistrac,tipoest,puesto,descrip " + ;
			"from guardia,prestacions,registracio,entidades,afiliacion,especialid,tabtipoaltas,TabGuaDeriv " + ;
			"where guardia.nroregistrac = registracio.REG_nroregistrac and " + ;
			"guardia.nroregistrac = afiliacion.registracio and " + ;
			"guardia.codent = afiliacion.AFI_codentidad and " + ;
			"guardia.codestado = tabtipoaltas.id and " + ;
			"prestacions.PRE_especialidad = ESP_codesp and " + ;
			"guardia.codprest = prestacions.PRE_codprest and " + ;
			"guardia.codent = entidades.ENT_codent and " + ;
			"PRE_codservicio = 8000" + mbuscov +;
			"and guardia.fechahoraing >= ?mfecha and tipoest in (5,2) " , "mwkguardia2")

		If mret < 0
			Messagebox("EN ARMADO DE PLANILLA DE GUARDIA,"+chr(10)+;
				"PROFESIONALES DERIVACIONES",16,"ERROR")
		Else
			Select * from mwkguardia1 union select * from mwkguardia2 into cursor mwkguardia
		Endif
	Endif

*!*		if used('mwkguardia1')
*!*		  use in mwkguardia1
*!*		endif
*!*		if used('mwkguardia2')
*!*		  use in mwkguardia2
*!*		endif


Endcase
