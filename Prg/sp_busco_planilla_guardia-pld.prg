****
** busca los protocolo de guardia para la grilla
****
Parameter mcual,mfecha1,mfecha2,mbuscog,mbuscov,mtodos,mesta

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

*!*	if vartype(mfecha2)#"T"
*!*		mfecha2 = ttod(mfechactr )
*!*	endif

If !inlist(type("mfecha2"),"T","D")
	mfecha2 = ttod(mfechactr)
Endif

mfechaobs = mfechactr - 14400  && 4 horas
mf1 = prg_dtoc(mfecha1)
mf2 = prg_dtoc(mfecha2+1)

mret = SQLExec(mcon1,"SELECT ID , nombre FROM TabMedExterno where gerenciadora = 0 ", "mwkMedicogua01" )
If mcual <> 6 and mcual <> 10  && si es salida profesional

	mitime = seconds()
	If mcual = 3  && si es desde hasta
		mret = SQLExec(mcon1, "select TGM_protocolo,TGM_Fechah , TGM_estado , TGM_mensaje , TGM_usuario  " + ;
			" from TabGuaMsg " + ;
			" where TGM_Fechah >= ?mf1 and TGM_Fechah< ?mf2 and TGM_estado <> 9 and TGM_codmed = 1 " + ;
			" ", "mwkprotomsg0")
	Else
		mret = SQLExec(mcon1, "select TGM_protocolo ,TGM_Fechah , TGM_estado , TGM_mensaje , TGM_usuario  " + ;
			" from TabGuaMsg " + ;
			" where TGM_Fechah >= ?mfecha and TGM_estado <> 9 and TGM_codmed = 1 " + ;
			" ", "mwkprotomsg0")
	Endif
	mitime2 = seconds()
*	messagebox(transfor(mitime2-mitime))
	Select * from mwkprotomsg0 order by TGM_protocolo,TGM_Fechah group by TGM_protocolo  into cursor mwkprotomsg
Endif
Do case

Case mcual = 1	&& planilla completa
	mret = SQLExec(mcon1, "select protocolo, fechahoraing, REG_nombrepac, nombre, codprest, ENT_descrient, " + ;
		"PRE_descriprest, PRE_especialidad, fechahoraate, codestado, guardia.id, prioridad, " + ;
		"REG_nrohclinica, REG_telefonos, REG_domicilio, AFI_nroafiliado, ESP_descripcion,"+;
		" guardia.codent, nroregistrac,guardia.codmed,guardia.ID, tipoest,puesto,descrip,codcie9  " + ;
		", tabtipoaltas.sector "+;
		"from prestacions, entidades, especialid, registracio, afiliacion," + ;
		"tabtipoaltas,guardia left outer join prestadores on guardia.codmed = prestadores.id " + ;
		"where guardia.nroregistrac = registracio.REG_nroregistrac and " + ;
		"guardia.nroregistrac = afiliacion.registracio and " + ;
		"guardia.codent = afiliacion.AFI_codentidad and " + ;
		"guardia.codprest = prestacions.PRE_codprest and " + ;
		"guardia.codestado 		= tabtipoaltas.id and " + ;
		"prestacions.PRE_especialidad = ESP_codesp and " + ;
		"guardia.codent	= entidades.ENT_codent and " + ;
		"guardia.fechahoraing >= ?mfecha and PRE_codservicio = 8000 " + ;
		"", "mwkguardia0")

	If used("mwkMedicogua01" )
		Select protocolo, fechahoraing, REG_nombrepac, ;
			iif(isnull(mwkguardia0.nombre) or (empty(mwkguardia0.nombre) and codmed>1),mwkMedicogua01.nombre,mwkguardia0.nombre) as nombre, ;
			codprest, ENT_descrient, ;
			PRE_descriprest, PRE_especialidad, fechahoraate, codestado, mwkguardia0.id, prioridad, ;
			REG_nrohclinica, REG_telefonos, REG_domicilio, AFI_nroafiliado, ESP_descripcion,;
			codent, nroregistrac,mwkguardia0.codmed,tpopac,tipoest,nvl(puesto,0) as puesto,descrip ;
			,codentexc,fecpasiva,tpopac,codcie9,descrabrev,mwkprotomsg.*,sector     ;
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


Case  mcual = 2		&& planilla para asignacion de profesional

	mret = SQLExec(mcon1, "select protocolo, fechahoraing, REG_nombrepac, codprest, ENT_descrient, " + ;
		"PRE_descriprest, PRE_especialidad, fechahoraate, codestado, guardia.id, prioridad, " + ;
		"REG_nrohclinica, REG_telefonos, REG_domicilio, AFI_nroafiliado, ESP_descripcion, "+;
		"guardia.codmed,guardia.codent, nroregistrac, tipoest, puesto,descrip " + ;
		"from guardia, prestacions, registracio, entidades, afiliacion, especialid,tabtipoaltas " + ;
		"where guardia.nroregistrac = registracio.REG_nroregistrac and " + ;
		"guardia.nroregistrac = afiliacion.registracio and " + ;
		"guardia.codent = afiliacion.AFI_codentidad and " + ;
		"guardia.codestado 		= tabtipoaltas.id and " + ;
		"prestacions.PRE_especialidad = ESP_codesp and " + ;
		"guardia.codprest = prestacions.PRE_codprest and " + ;
		"guardia.codent = entidades.ENT_codent and " + ;
		"guardia.codmed = 1 and PRE_codservicio = 8000 and " + ;
		"guardia.fechahoraing >= ?mfecha and tipoest in (4,2) " , "mwkguardia")

	mret = SQLExec(mcon1, "select protocolo, REG_nombrepac, codprest, codestado, guardia.id, " + ;
		"guardia.codmed,guardia.codent, nroregistrac, tipoest,EGM_CODMED " + ;
		"from guardia, prestacions, registracio, tabtipoaltas,TabGuaEvolmed   " + ;
		"where guardia.nroregistrac = registracio.REG_nroregistrac and " + ;
		"guardia.codestado = tabtipoaltas.id and EGM_proto = protocolo and " + ;
		"guardia.codprest = PRE_codprest and tipoest = 2 and " + ;
		"guardia.codmed > 1 and PRE_codservicio = 8000 and EGM_fechah < ?mfechaobs and " + ;
		"guardia.fechahoraing >= ?mfecha order by EGM_fechah " , "mwkguardiaobs")

*!*						+ ;
*!*						"order by fechahoraing"
	Select *,space(30) as nombre ;
		from mwkguardia left join mwkentexg on codent = codentexc ;
		left join mwkprotomsg on protocolo = TGM_protocolo  ;
		into cursor mwkguardia

Case mcual = 3		&& planilla desde hasta fecha
	horactr = val(left(ttoc(mfechactr,2),2))
	mserv = iif(mtodos=1,' val_codservvale<> 5410 and ',"pia_codprest = codprest and val_codservvale in ( 8000,2150,6500,9600 ) and " )
	mret = SQLExec(mcon1, "select guardia.protocolo, fechahoraing, REG_nombrepac," + ;
		" prestadores.nombre, codprest, ent_descrient, pre_descriprest, " + ;
		" pre_especialidad, fechahoraate, codestado, guardia.id," + ;
		" prioridad,guardiavale.nrovale, reg_nrohclinica,pia_codprest," + ;
		" reg_telefonos, reg_domicilio, afi_nroafiliado,reg_fecnacimiento,reg_sexo," + ;
		" esp_descripcion, guardia.codent,guardiavale.codserv, guardia.codmed, " + ;
		"nroregistrac, guardia.usuario,ptovta, tpocte,nrocte,letracte, fechacte,nroregistracio "+;
		" ,val_horasolicitud,val_fechasolicitud,val_codvaleasist,tipoest,descrip," + ;
		" val_prestador ,val_codservvale, val_bono,reg_numdocumento, pia_cantsolicitada,"+;
		"guardiavale.diagnostico,guardia.diagnostico as codadmision,TabCiap2E.DescrAbrev as descie,val_operadorcarga  " + ;
		",Tabguaevol.EG_horaCierre ,Tabguaevol.EG_parotros,codmedcie9,prestadoresb.nombre as nombreb "+;
		"from afiliacion,prestacions,valesasist,presinsuvas,tabtipoaltas,guardia "+;
		"left outer join entidades 		on guardia.codent				= entidades.ent_codent " + ;
		"left outer join especialid 	on prestacions.pre_especialidad = especialid.esp_codesp " + ;
		"left outer join registracio 	on guardia.nroregistrac 		= registracio.reg_nroregistrac " + ;
		"left outer join guardiavale 	on guardia.protocolo 			= guardiavale.protocolo " + ;
		"left outer join prestadores 	on guardia.codmed 				= prestadores.id " + ;
		"left outer join tabfacturas 	on tabfacturas.codpun 			= valesasist.val_codpun " +;
		"left outer join prestadores prestadoresb on guardia.codmedcie9 = prestadoresb.id " + ;
		"left outer join TabCiap2E      on TabCiap2E.Id                 = guardia.codcie9 "+;
		"left outer join Tabguaevol     on guardia.protocolo 			= Tabguaevol.EG_protocolo " + ;
		"where " + ;
		" guardiavale.nrovale = val_codvaleasist and "+;
		" presinsuvas.pia_valesasist = val_codpun and "+;
		" pia_codprest = prestacions.pre_codprest and "+;
		" guardia.codestado = tabtipoaltas.id and " + ;
		"guardia.nroregistrac = afiliacion.registracio and " + ;
		"guardia.codent = afiliacion.afi_codentidad and " + mserv +;
		"guardia.fechahoraing >= ?mf1 and " + ;
		"guardia.fechahoraing < ?mf2 "+mbuscog , "mwkguardia01")

	If mret<1
		=aerr(eros)
		Messagebox(eros(3))
	Endif
	If used("mwkMedicogua01" )
		Select protocolo, fechahoraing, REG_nombrepac, ;
			iif(isnull(mwkguardia01.nombre) or (empty(mwkguardia01.nombre) and codmed>1),mwkMedicogua01a.nombre,mwkguardia01.nombre) as nombre, ;
			iif(isnull(mwkguardia01.nombreb) or (empty(mwkguardia01.nombreb) and codmed>1),mwkMedicogua01b.nombre,mwkguardia01.nombreb) as nombreb, ;
			codprest, ENT_descrient, ;
			PRE_descriprest, PRE_especialidad, fechahoraate, codestado, mwkguardia01.id,;
			prioridad,nrovale, REG_nrohclinica, REG_telefonos, REG_domicilio, AFI_nroafiliado, ;
			ESP_descripcion, codent,codserv, codmed, nroregistrac, usuario,pia_codprest,;
			ptovta, tpocte,nrocte,letracte, nroregistracio ,val_horasolicitud,val_fechasolicitud,val_codvaleasist, ;
			val_prestador ,val_codservvale, val_bono,reg_numdocumento,tipoest,descrip,;
			pia_cantsolicitada,diagnostico,codadmision,descie,fechacte,val_operadorcarga,EG_horaCierre ,EG_parotros,codmedcie9    ;
			,reg_fecnacimiento,reg_sexo,mwkprotomsg.* ;  
			from mwkguardia01 left join mwkMedicogua01 mwkMedicogua01a on codmed = mwkMedicogua01a.id  ;
			left join mwkMedicogua01 mwkMedicogua01b on codmedcie9 = mwkMedicogua01b.id  ;
			left join mwkprotomsg on protocolo = TGM_protocolo  ;
			group by nrovale,pia_codprest;
			order by fechahoraing into cursor mwkguardia
	Else
		Select * from mwkguardia01 ;
			group by nrovale,pia_codprest;
			order by fechahoraing into cursor mwkguardia
	Endif
Case  mcual = 4		&& planilla para asignacion de profesional interconsulta


	mret = SQLExec(mcon1, "select protocolo, fechahoraing, REG_nombrepac, codprest, ENT_descrient, " + ;
		"PRE_descriprest, PRE_especialidad, fechahoraate, codestado, guardia.id, prioridad, " + ;
		"REG_nrohclinica, REG_telefonos, REG_domicilio, AFI_nroafiliado, ESP_descripcion, "+;
		"guardia.codmed,guardia.codent, nroregistrac, tipoest, puesto,descrip,nombre " + ;
		"from prestacions, registracio, entidades, afiliacion, especialid,tabtipoaltas,guardia " + ;
		"left outer join prestadores on guardia.codmed = prestadores.id " + ;
		"where guardia.nroregistrac = registracio.REG_nroregistrac and " + ;
		"guardia.nroregistrac = afiliacion.registracio and " + ;
		"guardia.codent = afiliacion.AFI_codentidad and " + ;
		"guardia.codestado 		= tabtipoaltas.id and " + ;
		"prestacions.PRE_especialidad = ESP_codesp and " + ;
		"guardia.codprest = prestacions.PRE_codprest and " + ;
		"guardia.codent = entidades.ENT_codent and " + ;
		"guardia.codmed > 1 and PRE_codservicio = 8000 and " + ;
		"guardia.fechahoraing >= ?mfecha " , "mwkguardia0")
*!*						+ ;
*!*						"order by fechahoraing"
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

Case mcual = 5		&& planilla enfermeria
	If vartype(mfecha2)="D"
*!*			mf1 = prg_dtoc(mfecha1)
*!*			mf2 = prg_dtoc(mfecha2)
		mbusfec = " guardia.fechahoraing >= ?mf1 and guardia.fechahoraing < ?mf2 "
	Else
		mbusfec = " guardia.fechahoraing >= ?mfecha  "
	Endif
	mret = SQLExec(mcon1, "select protocolo, fechahoraing, REG_nombrepac, nombre,"+;
		" codprest,ENT_descrient, PRE_descriprest, PRE_especialidad, fechahoraate,"+;
		" codestado, guardia.id, prioridad, REG_nrohclinica, REG_telefonos, "+;
		" REG_domicilio, AFI_nroafiliado, ESP_descripcion,guardia.codent, nroregistrac,"+;
		" guardia.codmed,tipoest,EG_indicNurse, eg_codmed,eg_evolucion,EG_evolNurse ,"+;
		" puesto,descrip,codcie9,EG_parAlerg " +;
		"from entidades, registracio, afiliacion,tabtipoaltas, guardia " + ;
		"left outer join prestadores on guardia.codmed = prestadores.id " + ;
		"left outer join tabguaevol on guardia.protocolo = tabguaevol.EG_protocolo " + ;
		"left outer join PRESTACIONS 	on prestacions.pre_codprest		= guardia.codprest " + ;
		"left outer join especialid on prestacions.PRE_especialidad = especialid.ESP_codesp " + ;
		"where guardia.nroregistrac = registracio.REG_nroregistrac and " + ;
		"guardia.nroregistrac = afiliacion.registracio and " + ;
		"guardia.codent = afiliacion.AFI_codentidad and " + ;
		"guardia.codprest = prestacions.PRE_codprest and " + ;
		"guardia.codestado = tabtipoaltas.id and " + ;
		"guardia.codent	= entidades.ENT_codent and " + ;
		mbusfec, "mwkguardia0")

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
	mret = SQLExec(mcon1, "select protocolo,fechahoraing,REG_nombrepac,codprest,ENT_descrient," + ;
		"PRE_descriprest,PRE_especialidad,fechahoraate,codestado,guardia.id,prioridad," + ;
		"REG_nrohclinica,REG_telefonos,REG_domicilio,ESP_descripcion,"+;
		"guardia.codmed,guardia.codent,nroregistrac,tipoest,puesto,descrip " + ;
		"from guardia,prestacions,registracio,entidades,especialid,tabtipoaltas " + ;
		"where guardia.nroregistrac = registracio.REG_nroregistrac and " + ;
		"guardia.codestado = tabtipoaltas.id and " + ;
		"prestacions.PRE_especialidad = ESP_codesp and " + ;
		"guardia.codprest = prestacions.PRE_codprest and " + ;
		"guardia.codent = entidades.ENT_codent and " + ;
		"PRE_codservicio = 8000 " + mbuscog +;
		"and guardia.fechahoraing >= ?mfecha and tipoest in (5,2)" , "mwkguardiaf1")

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

				mret = SQLExec(mcon1, "select protocolo,fechahoraing,REG_nombrepac,codprest,ENT_descrient," + ;
					"PRE_descriprest,PRE_especialidad,fechahoraate,codestado,guardia.id,prioridad," + ;
					"REG_nrohclinica,REG_telefonos,REG_domicilio,ESP_descripcion,"+;
					"guardia.codmed,guardia.codent,nroregistrac,tipoest,puesto,descrip " + ;
					"from guardia,prestacions,registracio,entidades,especialid,tabtipoaltas,TabGuaDeriv " + ;
					"where guardia.nroregistrac = registracio.REG_nroregistrac and " + ;
					"guardia.codestado = tabtipoaltas.id and " + ;
					"prestacions.PRE_especialidad = ESP_codesp and " + ;
					"guardia.codprest = prestacions.PRE_codprest and " + ;
					"guardia.codent = entidades.ENT_codent and " + ;
					"PRE_codservicio = 8000 " + mbuscov +;
					"and guardia.fechahoraing >= ?mfecha and tipoest in (5,2) " , "mwkguardiaf2")

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


Case mcual = 7		&& planilla desde hasta fecha
	mserv = iif(mtodos=1," val_codservvale<> 5410 and "," pia_codprest = codprest and val_codservvale in ( 8000,2150,6500,9600) and " )

	mret = SQLExec(mcon1, "select guardia.protocolo, fechahoraing, REG_nombrepac," + ;
		" nombre, codprest, ent_descrient, pre_descriprest, " + ;
		" pre_especialidad, fechahoraate, codestado, guardiavale.id," + ;
		" prioridad,guardiavale.nrovale, reg_nrohclinica," + ;
		" reg_telefonos, reg_domicilio,afi_nroafiliado,pia_codprest, " + ;
		" esp_descripcion, guardia.codent,guardiavale.codserv, guardia.codmed, " + ;
		"guardia.nroregistrac,guardia.usuario ,fechamodif,"+;
		" reg_numdocumento,descrip,codcie9,tipoest,val_operadorcarga " + ;
		"from afiliacion,valesasist,tabtipoaltas,presinsuvas,guardia  "+;
		"left outer join entidades 		on guardia.codent				= entidades.ent_codent " + ;
		"left outer join PRESTACIONS 	on prestacions.pre_codprest		= guardia.codprest " + ;
		"left outer join  especialid 	on prestacions.pre_especialidad = especialid.esp_codesp " + ;
		"left outer join  registracio 	on guardia.nroregistrac 		= registracio.reg_nroregistrac " + ;
		"left outer join guardiavale 	on guardia.protocolo 			= guardiavale.protocolo " + ;
		"left outer join prestadores 	on guardia.codmed 				= prestadores.id " + ;
		"where " + ;
		" guardiavale.nrovale = val_codvaleasist and "+;
		" pia_codprest = prestacions.pre_codprest and "+ mserv +;
		"guardia.nroregistrac = afiliacion.registracio and " + ;
		" presinsuvas.pia_valesasist = val_codpun and "+;
		" pia_codprest = prestacions.pre_codprest and "+;
		"guardia.codent = afiliacion.afi_codentidad and " + ;
		"guardia.codestado 		= tabtipoaltas.id and " + ;
		"guardia.fechahoraing >= ?mf1 and " + ;
		"guardia.fechahoraing <= ?mf2 "+mbuscog , "mwkguardia01")


	If mret<1
		=aerr(eros)
		Messagebox(eros(3))
	Endif
	If used("mwkMedicogua01" )
		Select protocolo, fechahoraing, REG_nombrepac, ;
			iif(isnull(mwkguardia01.nombre) or (empty(mwkguardia01.nombre) and codmed>1),mwkMedicogua01.nombre,mwkguardia01.nombre) as nombre, ;
			descrip,codprest, ENT_descrient, PRE_descriprest, PRE_especialidad, fechahoraate, codestado, mwkguardia01.id,;
			prioridad,nrovale, REG_nrohclinica, REG_telefonos, REG_domicilio, ;
			ESP_descripcion, codent,codserv, codmed,tipoest, val_operadorcarga,  ;
			nroregistrac,reg_numdocumento,descrabrev,AFI_nroafiliado,fechamodif    ;
			from mwkguardia01 left join mwkMedicogua01 on codmed = mwkMedicogua01.id  ;
			left join mwkciap2e on mwkciap2e.id = codcie9 ;
			group by protocolo,nrovale ;
			order by fechahoraing into cursor mwkguardia
	Else
		Select * from mwkguardia01 ;
			group by protocolo;
			order by fechahoraing into cursor mwkguardia
	Endif
Case mcual = 8		&& Para control de profesionales con derivaciones

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

Case mcual = 9		&& planilla desde hasta fecha CEG
	horactr = val(left(ttoc(mfechactr,2),2))
*!*		mf1 = prg_dtoc(mfecha1)
*!*		mf2 = prg_dtoc(mfecha2+1)
	mserv = iif(mtodos=1,' val_codservvale<> 5410 and ',"pia_codprest = codprest and val_codservvale in ( 8000,2150,6500,9600 ) " )
	mret = SQLExec(mcon1, "select guardia.protocolo, fechahoraing, REG_nombrepac," + ;
		" nombre, codprest, ent_descrient, pre_descriprest, " + ;
		" pre_especialidad, fechahoraate, guardia.codestado, guardia.id," + ;
		" prioridad,guardiavale.nrovale, reg_nrohclinica,pia_codprest," + ;
		" reg_telefonos, reg_domicilio, afi_nroafiliado," + ;
		" esp_descripcion, guardia.codent,guardiavale.codserv, guardia.codmed, " + ;
		"nroregistrac, guardia.usuario,ptovta, tpocte,nrocte,letracte, fechacte,nroregistracio "+;
		" ,val_horasolicitud,val_fechasolicitud,val_codvaleasist,tipoest,descrip," + ;
		" val_prestador ,val_codservvale, val_bono,reg_numdocumento, pia_cantsolicitada,"+;
		"guardiavale.diagnostico,TabCiap2E.DescrAbrev as descie,val_operadorcarga  " + ;
		"from afiliacion,prestacions,valesasist,presinsuvas,tabtipoaltas,guardia "+;
		"inner join tabguardia on (tabguardia.protocolo = guardia.protocolo  "+;
		" and tabguardia.codestado = ?mesta  )"+;
		"left outer join entidades on guardia.codent				= entidades.ent_codent " + ;
		"left outer join especialid 	on prestacions.pre_especialidad = especialid.esp_codesp " + ;
		"left outer join registracio 	on guardia.nroregistrac 		= registracio.reg_nroregistrac " + ;
		"left outer join guardiavale 	on guardia.protocolo 			= guardiavale.protocolo " + ;
		"left outer join prestadores 	on guardia.codmed 				= prestadores.id " + ;
		"left outer join tabfacturas 	on tabfacturas.codpun 			= valesasist.val_codpun " +;
		"left outer join TabCiap2E      on TabCiap2E.Id                 = guardia.codcie9 "+;
		" WHERE "+;
		" tabguardia.ID > 1263000 and "+;
		" tabguardia.fechaMod>= ?mf1 and tabguardia.fechaMod<= ?mf2 and "+;
		" guardiavale.nrovale = val_codvaleasist and "+;
		" presinsuvas.pia_valesasist = val_codpun and "+;
		" pia_codprest = prestacions.pre_codprest and "+;
		" guardia.codestado = tabtipoaltas.id and " + ;
		"guardia.nroregistrac = afiliacion.registracio and " + ;
		" guardia.codent = afiliacion.afi_codentidad and " + mserv + ;
		"group by guardia.protocolo" , "mwkguardia01")

&&& saque 5800
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
			pia_cantsolicitada,diagnostico,descie,fechacte,val_operadorcarga   ;
			from mwkguardia01 left join mwkMedicogua01 on codmed = mwkMedicogua01.id  ;
			group by nrovale,pia_codprest;
			order by fechahoraing into cursor mwkguardia
	Else
		Select * from mwkguardia01 ;
			group by nrovale,pia_codprest;
			order by fechahoraing into cursor mwkguardia
	Endif

Case mcual = 10	&& planilla desde HCE Legales

	Use in select("mwkguardia01")
	mret = SQLExec(mcon1, "select guardia.protocolo, fechahoraing, REG_nombrepac," + ;
		" nombre, codprest, ent_descrient, pre_descriprest, " + ;
		" pre_especialidad, fechahoraate, codestado, guardiavale.id," + ;
		" prioridad,guardiavale.nrovale, reg_nrohclinica," + ;
		" reg_telefonos, reg_domicilio,afi_nroafiliado,pia_codprest, " + ;
		" esp_descripcion, guardia.codent,guardiavale.codserv, guardia.codmed, " + ;
		"guardia.nroregistrac,guardia.usuario ,fechamodif,"+;
		" reg_numdocumento,descrip,codcie9,tipoest,val_operadorcarga " + ;
		"from afiliacion,valesasist,tabtipoaltas,presinsuvas,guardia  "+;
		"left outer join entidades 		on guardia.codent				= entidades.ent_codent " + ;
		"left outer join PRESTACIONS 	on prestacions.pre_codprest		= guardia.codprest " + ;
		"left outer join  especialid 	on prestacions.pre_especialidad = especialid.esp_codesp " + ;
		"left outer join  registracio 	on guardia.nroregistrac 		= registracio.reg_nroregistrac " + ;
		"left outer join guardiavale 	on guardia.protocolo 			= guardiavale.protocolo " + ;
		"left outer join prestadores 	on guardia.codmed 				= prestadores.id " + ;
		"where " + ;
		" guardiavale.nrovale = val_codvaleasist and "+;
		" pia_codprest = prestacions.pre_codprest and "+;
		"guardia.nroregistrac = afiliacion.registracio and " + ;
		" presinsuvas.pia_valesasist = val_codpun and "+;
		" pia_codprest = prestacions.pre_codprest and "+;
		"guardia.codent = afiliacion.afi_codentidad and " + ;
		"guardia.codestado = tabtipoaltas.id and guardia.protocolo = ?mbuscog","mwkguardia01")

	If mret<1
		=aerr(eros)
		Messagebox(eros(3))
	Endif

	If used("mwkMedicogua01" )
		Select protocolo, fechahoraing, REG_nombrepac, ;
			iif(isnull(mwkguardia01.nombre) or (empty(mwkguardia01.nombre) and codmed>1),mwkMedicogua01.nombre,mwkguardia01.nombre) as nombre, ;
			descrip,codprest, ENT_descrient, PRE_descriprest, PRE_especialidad, fechahoraate,codestado,mwkguardia01.id,;
			prioridad,nrovale, REG_nrohclinica, REG_telefonos, REG_domicilio, ;
			ESP_descripcion, codent,codserv, codmed,tipoest, val_operadorcarga,  ;
			nroregistrac,reg_numdocumento,descrabrev,AFI_nroafiliado,fechamodif    ;
			from mwkguardia01 left join mwkMedicogua01 on codmed = mwkMedicogua01.id  ;
			left join mwkciap2e on mwkciap2e.id = codcie9 ;
			group by protocolo,nrovale ;
			order by fechahoraing into cursor mwkguardia
	Else
		Select * from mwkguardia01 ;
			group by protocolo;
			order by fechahoraing into cursor mwkguardia
	Endif

Endcase
