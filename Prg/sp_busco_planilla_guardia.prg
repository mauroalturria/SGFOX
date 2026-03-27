****
** busca los protocolo de guardia para la grilla
** modificado el 2020-02 para agregarle los campos de triage en la consulta de sala de espera.
****
Parameter mcual,mfecha1,mfecha2,mbuscog,mbuscov,mtodos,mesta,lpreadm

If Vartype (lpreadm)#"L"
	lpreadm = .F.
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
If Type("mfecha1")="T"
	mfecha = mfecha1
Else
	mfecha = mfechactr - 86400  && 57600 && 16hs   &&  86400  &&  24hs
Endif
If mwkusuario.codigovax = 54035
*	Set Step On
Endif
*!*	if vartype(mfecha2)#"T"
*!*		mfecha2 = ttod(mfechactr )
*!*	endif

If !Inlist(Type("mfecha2"),"T","D")
	mfecha2 = Ttod(mfechactr)
Endif

mfechaobs = mfechactr - 14400  && 4 horas
mf1 = prg_dtoc(mfecha1)
mf2 = prg_dtoc(mfecha2+1)

mret = SQLExec(mcon1,"SELECT ID , nombre FROM TabMedExterno where exists(select 1 from TabMedExterno where gerenciadora = 0 ) and gerenciadora = 0 ", "mwkMedicogua01" )
If mcual <> 6 And mcual <> 10  && si es salida profesional

	mitime = Seconds()
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
	mitime2 = Seconds()
*	messagebox(transfor(mitime2-mitime))
	Select * From mwkprotomsg0 Order By TGM_protocolo,TGM_Fechah Group By TGM_protocolo  Into Cursor mwkprotomsg
Endif


Do Case
Case mcual = 1	&& planilla completa
	mret = SQLExec(mcon1, "select nrotriage,valortriage,fechahoratriage,protocolo, fechahoraing, REG_nombrepac, nombre, codprest, ENT_descrient, " + ;
		"PRE_descriprest, PRE_especialidad, fechahoraate, codestado, guardia.id, prioridad, " + ;
		"REG_nrohclinica, REG_telefonos, REG_domicilio,reg_email, AFI_nroafiliado, ESP_descripcion,"+;
		" guardia.codent, nroregistrac,guardia.codmed,  tipoest,puesto,descrip,codcie9  " + ;
		", tabtipoaltas.sector,REG_sexo,REG_fecnacimiento,REG_localidad,reg_numdocumento,diagnostico,guardia.UserDbAdd,guardia.FecHorDbAdd  "+;
		"from prestacions, entidades, especialid, registracio, afiliacion," + ;
		"tabtipoaltas,guardia left outer join prestadores on guardia.codmed = prestadores.id " + ;
		"where guardia.nroregistrac = registracio.REG_nroregistrac and " + ;
		"guardia.nroregistrac = afiliacion.registracio and " + ;
		"guardia.codent = afiliacion.AFI_codentidad and " + ;
		"guardia.codprest = prestacions.PRE_codprest and " + ;
		"guardia.codestado 		= tabtipoaltas.id and " + ;
		"prestacions.PRE_especialidad = ESP_codesp and " + ;
		"guardia.codent	= entidades.ENT_codent and " + ;
		"guardia.fechahoraing >= ?mfecha and PRE_codservicio = 8000 " +mbuscog+ ;
		"", "mwkguardia0a")
	Do sp_busco_estados With 57,' and tipo = 29 ','mwkhabprea'&&
	If ( mwkhabprea.estado = 1 Or  myip='172.16.1.7' ) And lpreadm

		mret = SQLExec(mcon1,"update ZabGuardiaDom set codestado = 9 where fechahoraing<= ?mfechaobs and codestado in (1,8) ")
		mret = SQLExec(mcon1, "select  ZabGuardiaDom.protocolo, ZabGuardiaDom.fechahoraing, REG_nombrepac,nombre, ZabGuardiaDom.codprest, ENT_descrient, " + ;
			"PRE_descriprest, PRE_especialidad, ZabGuardiaDom.fechahoraate, ZabGuardiaDom.codestado,  ZabGuardiaDom.id, " + ;
			"REG_nrohclinica, REG_telefonos, REG_domicilio,reg_email,  ESP_descripcion,"+;
			"  ZabGuardiaDom.codent, ZabGuardiaDom.nroregistrac, CAST(0 as integer) as tipoest ,   " + ;
			" cast(CASE WHEN ZabGuardiaDom.codestado  = 1 THEN 'PRE ADMITIDO' "+;
			" ELSE CASE WHEN ZabGuardiaDom.codestado  = 2 THEN 'ADMITIDO' ELSE "+;
			" CASE WHEN ZabGuardiaDom.codestado  = 3 THEN 'ATENDIDO' ELSE CASE WHEN ZabGuardiaDom.codestado  = 7 THEN 'DESISTE' ELSE  "+;
			" CASE WHEN ZabGuardiaDom.codestado  = 8 THEN 'AUSENTE' ELSE 'FINALIZADO' END "+;
			" END END END  END As CHARACTER(100)) as DESCRIP,"+;
			"  CAST('0' as CHARACTER(1)) as sector,REG_sexo,REG_fecnacimiento,REG_localidad,reg_numdocumento,ZabGuardiaDom.diagnostico,guardia.UserDbAdd,guardia.FecHorDbAdd  "+;
			" from prestacions, entidades, especialid, registracio,ZabGuardiaDom,prestadores   " + ;
			" left join guardia on ZabGuardiaDom.protocolo = guardia.protocolo "+;
			" where ZabGuardiaDom.nroregistrac = registracio.REG_nroregistrac and " + ;
			" ZabGuardiaDom.codprest = prestacions.PRE_codprest and " + ;
			" prestacions.PRE_especialidad = ESP_codesp and " + ;
			" ZabGuardiaDom.codent	= entidades.ENT_codent and " + ;
			" ZabGuardiaDom.fechahoraing >= ?mfecha and PRE_codservicio = 8000 "+;
			" and prestadores.id = 1 and ZabGuardiaDom.codestado = 1 " , "mwkguardiadom")
		Select Nvl(nrotriage,0) As nrotriage,Nvl(valortriage,0) As valortriage,Nvl(fechahoratriage,Ctod("01/01/1900")) As fechahoratriage,protocolo, fechahoraing, REG_nombrepac, nombre, codprest, ENT_descrient,  ;
			PRE_descriprest, PRE_especialidad, fechahoraate, codestado, Id, prioridad,   ;
			REG_nrohclinica, REG_telefonos, REG_domicilio,reg_email,  AFI_nroafiliado, ESP_descripcion, ;
			codent, nroregistrac, codmed,  tipoest, puesto,Descrip, codcie9   ;
			, sector,REG_sexo,REG_fecnacimiento,REG_localidad,reg_numdocumento,Left(diagnostico,250) As diagnostico ,UserDbAdd,FecHorDbAdd;
			From mwkguardia0a;
			UNION All;
			Select 0 As nrotriage,0 As valortriage,Ctot("01/01/1900") As fechahoratriage,protocolo, fechahoraing, REG_nombrepac, nombre, codprest, ENT_descrient,  ;
			PRE_descriprest, PRE_especialidad, fechahoraate, codestado, Id,0 As prioridad,   ;
			REG_nrohclinica, REG_telefonos, REG_domicilio,reg_email, Space(20) As AFI_nroafiliado, ESP_descripcion, ;
			codent, nroregistrac,1 As codmed,  tipoest,0 As puesto,Descrip,0 As codcie9	, ;
			sector,REG_sexo,REG_fecnacimiento,REG_localidad,reg_numdocumento,diagnostico ,UserDbAdd,FecHorDbAdd;
			FROM mwkguardiadom Into Cursor mwkguardia0

	Else
		Select * From mwkguardia0a Into Cursor mwkguardia0
	Endif
	If Used("mwkMedicogua01" )
		Select nrotriage,valortriage,fechahoratriage,protocolo, fechahoraing, REG_nombrepac, ;
			iif(Isnull(mwkguardia0.nombre) Or (Empty(mwkguardia0.nombre) And codmed>1),mwkMedicogua01.nombre,mwkguardia0.nombre) As nombre, ;
			codprest, ENT_descrient, ;
			PRE_descriprest, PRE_especialidad, fechahoraate, codestado, mwkguardia0.Id, prioridad, ;
			REG_nrohclinica, REG_telefonos, REG_domicilio,reg_email, AFI_nroafiliado, ESP_descripcion,;
			codent, nroregistrac,mwkguardia0.codmed,tpopac,tipoest,Nvl(puesto,0) As puesto,Descrip ;
			,codentexc,fecpasiva,tpopac,codcie9,descripcion,mwkprotomsg.*,sector,reg_numdocumento,diagnostico ,UserDbAdd,FecHorDbAdd,;
			REG_sexo,REG_fecnacimiento,REG_localidad,Ttod(fechahoraate) As fechaaate ;
			,sp_busco_datos_regis_cond(mwkguardia0.nroregistrac," and RCE_tipoCondesp  = 13 And  RCE_fechahasta>= {fn curdate()} ",;
			"mwkpacvip",1) As lespacvip ;
			,sp_busco_datos_regis_cond(mwkguardia0.nroregistrac," and RCE_tipoCondesp  = 15 And  RCE_fechahasta>= {fn curdate()} ",;
			"mwkpacvip",1) As lespactras ;
			from mwkguardia0 Left Join mwkMedicogua01 On codmed = mwkMedicogua01.Id  ;
			left Join mwkentexg On codent = codentexc ;
			left Join mwkprotomsg On protocolo = TGM_protocolo  ;
			left Join mwkciap2e On mwkciap2e.Id = codcie9 ;
			group By fechahoraing ,protocolo,codprest,mwkguardia0.Id,AFI_nroafiliado ;
			order By fechahoraing Into Cursor mwkguardia
	Else
		Select *,Ttod(fechahoraate) As fechaaate,sp_busco_datos_regis_cond(mwkguardia0.nroregistrac,;
			" and RCE_tipoCondesp  = 13 And  RCE_fechahasta>= {fn curdate()} ","mwkpacvip",1) As lespacvip;
			,sp_busco_datos_regis_cond(mwkguardia0.nroregistrac," and RCE_tipoCondesp  = 15 And  RCE_fechahasta>= {fn curdate()} ",;
			"mwkpacvip",1) As lespactras ;
			From mwkguardia0 ;
			left Join mwkentexg On codent = codentexc ;
			left Join mwkciap2e On mwkciap2e.Id = codcie9 ;
			left Join mwkprotomsg On protocolo = TGM_protocolo  ;
			into Cursor mwkguardia
	Endif

Case  mcual = 2		&& planilla para asignacion de profesional
	mret = SQLExec(mcon1, "select nrotriage,valortriage,fechahoratriage,protocolo, fechahoraing, REG_nombrepac, codprest, ENT_descrient, " + ;
		"PRE_descriprest, PRE_especialidad, fechahoraate, codestado, guardia.id, prioridad, " + ;
		"REG_nrohclinica, REG_telefonos, REG_domicilio,reg_email, AFI_nroafiliado, ESP_descripcion, "+;
		"guardia.codmed,guardia.codent, nroregistrac, tipoest, puesto,descrip, REG_sexo, REG_fecnacimiento,guardia.UserDbAdd,guardia.FecHorDbAdd  " + ;
		"from guardia, prestacions, registracio, entidades, afiliacion, especialid,tabtipoaltas " + ;
		"where guardia.nroregistrac = registracio.REG_nroregistrac and " + ;
		"guardia.nroregistrac = afiliacion.registracio and " + ;
		"guardia.codent = afiliacion.AFI_codentidad and " + ;
		"guardia.codestado 		= tabtipoaltas.id and " + ;
		"prestacions.PRE_especialidad = ESP_codesp and " + ;
		"guardia.codprest = prestacions.PRE_codprest and " + ;
		"guardia.codent = entidades.ENT_codent and " + ;
		"guardia.codmed = 1 and PRE_codservicio = 8000 and " + ;
		"guardia.fechahoraing >= ?mfecha and tipoest in (4,2) "+mbuscog , "mwkguardia")

	mret = SQLExec(mcon1, "select nrotriage,valortriage,fechahoratriage,protocolo, REG_nombrepac, codprest, codestado, guardia.id, " + ;
		"guardia.codmed,guardia.codent, nroregistrac, tipoest,EGM_CODMED " + ;
		"from guardia, prestacions, registracio, tabtipoaltas,TabGuaEvolmed   " + ;
		"where guardia.nroregistrac = registracio.REG_nroregistrac and " + ;
		"guardia.codestado = tabtipoaltas.id and EGM_proto = protocolo and " + ;
		"guardia.codprest = PRE_codprest and tipoest = 2 and " + ;
		"guardia.codmed*8 > 8 and PRE_codservicio = 8000 and EGM_fechah < ?mfechaobs and " + ;
		"guardia.fechahoraing >= ?mfecha "+mbuscog+" order by EGM_fechah " , "mwkguardiaobs")

*!*						+ ;
*!*						"order by fechahoraing"
	Select *,Space(30) As nombre ;
		,sp_busco_datos_regis_cond(mwkguardia.nroregistrac," and RCE_tipoCondesp  = 13 And  RCE_fechahasta>= {fn curdate()} ";
		,"mwkpacvip",1) As lespacvip  ;
		,sp_busco_datos_regis_cond(mwkguardia.nroregistrac," and RCE_tipoCondesp  = 15 And  RCE_fechahasta>= {fn curdate()} ",;
		"mwkpacvip",1) As lespactras ;
		from mwkguardia Left Join mwkentexg On codent = codentexc ;
		left Join mwkprotomsg On protocolo = TGM_protocolo  ;
		into Cursor mwkguardia

Case mcual = 3		&& planilla desde hasta fecha
	horactr = Val(Left(Ttoc(mfechactr,2),2))
	mserv = Iif(mtodos=1,' val_codservvale<> 5410 and ',"pia_codprest = codprest and val_codservvale in ( 8000,2150,6500,9600 ) and " )
	mret = SQLExec(mcon1, "select guardia.protocolo, fechahoraing, REG_nombrepac," + ;
		" prestadores.nombre, codprest, ent_descrient, pre_descriprest, " + ;
		" pre_especialidad, fechahoraate, codestado, guardia.id," + ;
		" prioridad,guardiavale.nrovale, reg_nrohclinica,pia_codprest," + ;
		" reg_telefonos, REG_domicilio,reg_email, afi_nroafiliado,reg_fecnacimiento,reg_sexo," + ;
		" esp_descripcion, guardia.codent,guardiavale.codserv, guardia.codmed, " + ;
		"nroregistrac, guardia.usuario,ptovta, tpocte,nrocte,letracte, fechacte,nroregistracio "+;
		" ,val_horasolicitud,val_fechasolicitud,val_codvaleasist,tipoest,descrip," + ;
		" val_prestador ,val_codservvale,VAL_codadmision , val_bono,reg_numdocumento, pia_cantsolicitada,"+;
		"guardiavale.diagnostico,guardia.diagnostico as codadmision,TabCiap2E.descripcion as descie,val_operadorcarga  " + ;
		",Tabguaevol.EG_horaCierre ,Tabguaevol.EG_parotros,codmedcie9,prestadoresb.nombre as nombreb,guardia.UserDbAdd,guardia.FecHorDbAdd  "+;
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
		Do Log_errores With Error(), Message(), Message(1)
		Return .F.
	Endif
	If Used("mwkMedicogua01" )
		Select protocolo, fechahoraing, REG_nombrepac, ;
			iif(Isnull(mwkguardia01.nombre) Or (Empty(mwkguardia01.nombre) And codmed>1),mwkMedicogua01a.nombre,mwkguardia01.nombre) As nombre, ;
			iif(Isnull(mwkguardia01.nombreb) Or (Empty(mwkguardia01.nombreb) And codmed>1),mwkMedicogua01b.nombre,mwkguardia01.nombreb) As nombreb, ;
			codprest, ENT_descrient, ;
			PRE_descriprest, PRE_especialidad, fechahoraate, codestado, mwkguardia01.Id,;
			prioridad,nrovale, REG_nrohclinica, REG_telefonos, REG_domicilio,reg_email, AFI_nroafiliado, ;
			ESP_descripcion, codent,codserv, codmed, nroregistrac, usuario,pia_codprest,;
			ptovta, tpocte,nrocte,letracte, nroregistracio ,val_horasolicitud,val_fechasolicitud,val_codvaleasist, ;
			val_prestador ,val_codservvale,VAL_codadmision , val_bono,reg_numdocumento,tipoest,Descrip,;
			pia_cantsolicitada,diagnostico,codadmision,descie,fechacte,val_operadorcarga,EG_horaCierre ,EG_parotros,codmedcie9    ;
			,REG_fecnacimiento,REG_sexo,mwkprotomsg.*  ,mwkguardia01.UserDbAdd,mwkguardia01.FecHorDbAdd;
			,sp_busco_datos_regis_cond(mwkguardia01.nroregistrac," and RCE_tipoCondesp  = 13 And  RCE_fechahasta>= {fn curdate()} ","mwkpacvip",1) As lespacvip  ;
			,sp_busco_datos_regis_cond(mwkguardia01.nroregistrac," and RCE_tipoCondesp  = 15 And  RCE_fechahasta>= {fn curdate()} ",;
			"mwkpacvip",1) As lespactras ;
			from mwkguardia01 Left Join mwkMedicogua01 mwkMedicogua01a On codmed = mwkMedicogua01a.Id  ;
			left Join mwkMedicogua01 mwkMedicogua01b On codmedcie9 = mwkMedicogua01b.Id  ;
			left Join mwkprotomsg On protocolo = TGM_protocolo  ;
			group By nrovale,pia_codprest;
			order By fechahoraing Into Cursor mwkguardia
	Else
		Select *,sp_busco_datos_regis_cond(nroregistrac," and RCE_tipoCondesp  = 13 And  RCE_fechahasta>= {fn curdate()} ","mwkpacvip",1) As lespacvip;
			,sp_busco_datos_regis_cond(nroregistrac," and RCE_tipoCondesp  = 15 And  RCE_fechahasta>= {fn curdate()} ",;
			"mwkpacvip",1) As lespactras ;
			From mwkguardia01;
			Group By nrovale,pia_codprest;
			order By fechahoraing Into Cursor mwkguardia
	Endif
Case  mcual = 4		&& planilla para asignacion de profesional interconsulta
	mret = SQLExec(mcon1, "select nrotriage,valortriage,fechahoratriage,protocolo, fechahoraing, REG_nombrepac, codprest, ENT_descrient, " + ;
		"PRE_descriprest, PRE_especialidad, fechahoraate, codestado, guardia.id, prioridad, " + ;
		"REG_nrohclinica, REG_telefonos, REG_domicilio,reg_email, AFI_nroafiliado, ESP_descripcion, "+;
		"guardia.codmed,guardia.codent, nroregistrac, tipoest, puesto,descrip,nombre,REG_sexo,REG_fecnacimiento,guardia.UserDbAdd,guardia.FecHorDbAdd  " + ;
		"from prestacions, registracio, entidades, afiliacion, especialid,tabtipoaltas,guardia " + ;
		"left outer join prestadores on guardia.codmed = prestadores.id " + ;
		"where guardia.nroregistrac = registracio.REG_nroregistrac and " + ;
		"guardia.nroregistrac = afiliacion.registracio and " + ;
		"guardia.codent = afiliacion.AFI_codentidad and " + ;
		"guardia.codestado 		= tabtipoaltas.id and " + ;
		"prestacions.PRE_especialidad = ESP_codesp and " + ;
		"guardia.codprest = prestacions.PRE_codprest and " + ;
		"guardia.codent = entidades.ENT_codent and " + ;
		"guardia.codmed*8 > 8 and PRE_codservicio = 8000 and " + ;
		"guardia.fechahoraing >= ?mfecha " , "mwkguardia0")
*!*						+ ;
*!*						"order by fechahoraing"
	If Used("mwkMedicogua01" )

		Select nrotriage,valortriage,fechahoratriage,protocolo, fechahoraing, REG_nombrepac, codprest, ENT_descrient,;
			PRE_descriprest, PRE_especialidad, fechahoraate, codestado, mwkguardia0.Id, prioridad,;
			REG_nrohclinica, REG_telefonos, REG_domicilio,reg_email, AFI_nroafiliado, ESP_descripcion,;
			codmed,codent, nroregistrac, tipoest, puesto,Descrip,;
			iif(Isnull(mwkguardia0.nombre) Or (Empty(mwkguardia0.nombre) And codmed>1),;
			mwkMedicogua01.nombre,mwkguardia0.nombre) As nombre, ;
			codentexc,fecpasiva,tpopac,mwkprotomsg.*,REG_sexo,REG_fecnacimiento  ,mwkguardia0.UserDbAdd,;
			mwkguardia0.FecHorDbAdd,sp_busco_datos_regis_cond(mwkguardia0.nroregistrac," and RCE_tipoCondesp  = 13 And  RCE_fechahasta>= {fn curdate()} ","mwkpacvip",1) As lespacvip  ;
			,sp_busco_datos_regis_cond(mwkguardia0.nroregistrac," and RCE_tipoCondesp  = 15 And  RCE_fechahasta>= {fn curdate()} ","mwkpacvip",1) As lespactras  ;
			from mwkguardia0 Left Join mwkMedicogua01 On codmed = mwkMedicogua01.Id  ;
			left Join mwkentexg On codent = codentexc ;
			left Join mwkprotomsg On protocolo = TGM_protocolo  ;
			group By fechahoraing ,protocolo,codprest,mwkguardia0.Id,AFI_nroafiliado ;
			order By fechahoraing Into Cursor mwkguardia

	Else
		Select *,sp_busco_datos_regis_cond(nroregistrac," and RCE_tipoCondesp  = 13 And  RCE_fechahasta>= {fn curdate()} ","mwkpacvip",1) As lespacvip ;
			,sp_busco_datos_regis_cond( nroregistrac," and RCE_tipoCondesp  = 15 And  RCE_fechahasta>= {fn curdate()} ",;
			"mwkpacvip",1) As lespactras ;
			From mwkguardia0 Left Join mwkentexg On codent = codentexc Into Cursor mwkguardia
	Endif

Case mcual = 5		&& planilla enfermeria
	If Vartype(mfecha2)="D"
*!*			mf1 = prg_dtoc(mfecha1)
*!*			mf2 = prg_dtoc(mfecha2)
		mbusfec = " guardia.fechahoraing >= ?mf1 and guardia.fechahoraing < ?mf2 "
	Else
		mbusfec = " guardia.fechahoraing >= ?mfecha  "
	Endif
	mret = SQLExec(mcon1, "select guardia.nrotriage,guardia.valortriage,guardia.fechahoratriage,protocolo, fechahoraing, REG_nombrepac, nombre,"+;
		" codprest,ENT_descrient, PRE_descriprest, PRE_especialidad, fechahoraate,"+;
		" codestado, guardia.id, prioridad, REG_nrohclinica, REG_telefonos, "+;
		" REG_domicilio,reg_email, AFI_nroafiliado, ESP_descripcion,guardia.codent, nroregistrac,"+;
		" guardia.codmed,tipoest,EG_indicNurse, eg_codmed,eg_evolucion,EG_evolNurse ,"+;
		" puesto,descrip,codcie9,EG_parAlerg, REG_sexo, REG_fecnacimiento ,guardia.UserDbAdd,guardia.FecHorDbAdd  " + ;
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

	If Used("mwkMedicogua01" )
		Select nrotriage,valortriage,fechahoratriage,protocolo, fechahoraing, REG_nombrepac, ;
			iif(Isnull(mwkguardia0.nombre) Or (Empty(mwkguardia0.nombre) And codmed>1),mwkMedicogua01.nombre,mwkguardia0.nombre) As nombre, ;
			codprest, ENT_descrient, ;
			PRE_descriprest, PRE_especialidad, fechahoraate, codestado, mwkguardia0.Id, prioridad, ;
			REG_nrohclinica, REG_telefonos, REG_domicilio,reg_email, AFI_nroafiliado, ESP_descripcion,;
			codent, nroregistrac,mwkguardia0.codmed,tpopac,!Empty(Nvl(EG_indicNurse,'')) As indic    ;
			,!(Empty(Nvl(EG_evolNurse,'')) Or Nvl(EG_parAlerg,0) = 1) As Atnur,tipoest,puesto,Descrip ;
			,codentexc,fecpasiva ,codcie9,descripcion,mwkprotomsg.*,EG_indicNurse,EG_evolNurse  ;
			,eg_codmed,eg_evolucion,REG_sexo,REG_fecnacimiento,"" As diagnostico ;
			,mwkguardia0.UserDbAdd,mwkguardia0.FecHorDbAdd,;
			sp_busco_datos_regis_cond(mwkguardia0.nroregistrac," and RCE_tipoCondesp  = 13 And  RCE_fechahasta>= {fn curdate()} ","mwkpacvip",1) As lespacvip  ;
			,sp_busco_datos_regis_cond(mwkguardia0.nroregistrac," and RCE_tipoCondesp  = 15 And  RCE_fechahasta>= {fn curdate()} ",;
			"mwkpacvip",1) As lespactras ;
			from mwkguardia0 Left Join mwkMedicogua01 On codmed = mwkMedicogua01.Id  ;
			left Join mwkentexg On codent = codentexc ;
			left Join mwkciap2e On mwkciap2e.Id = codcie9 ;
			left Join mwkprotomsg On protocolo = TGM_protocolo  ;
			group By fechahoraing ,protocolo,codprest,mwkguardia0.Id,AFI_nroafiliado ;
			order By fechahoraing Into Cursor mwkguardia
	Else
		Select *,"" As diagnostico,sp_busco_datos_regis_cond(nroregistrac," and RCE_tipoCondesp  = 13 And  RCE_fechahasta>= {fn curdate()} ","mwkpacvip",1) As lespacvip;
			,sp_busco_datos_regis_cond( nroregistrac," and RCE_tipoCondesp  = 15 And  RCE_fechahasta>= {fn curdate()} ",;
			"mwkpacvip",1) As lespactras ;
			From mwkguardia0 Left Join mwkentexg On codent = codentexc Into Cursor mwkguardia

	Endif

Case mcual = 6 && planilla  Habilitación de profesionales en guardia
	mpaso = .T.
	If Used('mwkguardiaf')
		Use In mwkguardiaf
	Endif
	If Used('mwkguardiaf1')
		Use In mwkguardiaf1
	Endif
	If Used('mwkguardiaf2')
		Use In mwkguardiaf2
	Endif
	If Used('mwkguaderiv')
		Use In mwkguaderiv
	Endif
	mret = SQLExec(mcon1, "select guardia.nrotriage,guardia.valortriage,guardia.fechahoratriage,protocolo,fechahoraing,REG_nombrepac,codprest,ENT_descrient," + ;
		"PRE_descriprest,PRE_especialidad,fechahoraate,codestado,guardia.id,prioridad," + ;
		"REG_nrohclinica,REG_telefonos,REG_domicilio,reg_email,ESP_descripcion,"+;
		"guardia.codmed,guardia.codent,nroregistrac,tipoest,puesto,descrip,REG_sexo,REG_fecnacimiento " + ;
		"from guardia,prestacions,registracio,entidades,especialid,tabtipoaltas " + ;
		"where guardia.nroregistrac = registracio.REG_nroregistrac and " + ;
		"guardia.codestado = tabtipoaltas.id and " + ;
		"prestacions.PRE_especialidad = ESP_codesp and " + ;
		"guardia.codprest = prestacions.PRE_codprest and " + ;
		"guardia.codent = entidades.ENT_codent and " + ;
		"PRE_codservicio = 8000 " + mbuscog +;
		"and guardia.fechahoraing >= ?mfecha and tipoest in (5,2)" , "mwkguardiaf1")

	If mret > 0

		mbus1 = Strtran(mbuscog, "and guardia.codmed","TGD_medDer")
		mret = SQLExec(mcon1,"select TGD_medDer , TGD_protocolo  from TabGuaDeriv "+;
			"where TGD_Estado = 1 and TGD_fechaDer >= ?mfecha1","mwkguaderiv")
		If mret > 0
			Select * From mwkguardiaf1 Where mwkguardiaf1.protocolo Not In ;
				(Select TGD_protocolo From mwkguaderiv) Into Cursor mwkguardiaf1

			Select TGD_protocolo From mwkguaderiv Where &mbus1 Into Cursor mwkctrlder
			If Reccount("mwkctrlder")>0

*!*             Pacientes en guardia que presentan una derivación del profesional original a otro

				mret = SQLExec(mcon1, "select guardia.nrotriage,guardia.valortriage,guardia.fechahoratriage,protocolo,fechahoraing,REG_nombrepac,codprest,ENT_descrient," + ;
					"PRE_descriprest,PRE_especialidad,fechahoraate,codestado,guardia.id,prioridad," + ;
					"REG_nrohclinica,REG_telefonos,REG_domicilio,reg_email,ESP_descripcion,"+;
					"guardia.codmed,guardia.codent,nroregistrac,tipoest,puesto,descrip,REG_sexo,REG_fecnacimiento " + ;
					"from guardia,prestacions,registracio,entidades,especialid,tabtipoaltas,TabGuaDeriv " + ; && la relacion de esta tabla:TabGuaDeriv esta en mbuscov
				"where guardia.nroregistrac = registracio.REG_nroregistrac and " + ;
					"guardia.codestado = tabtipoaltas.id and " + ;
					"prestacions.PRE_especialidad = ESP_codesp and " + ;
					"guardia.codprest = prestacions.PRE_codprest and " + ;
					"guardia.codent = entidades.ENT_codent and " + ;
					"PRE_codservicio = 8000 " + mbuscov +;
					"and guardia.fechahoraing >= ?mfecha and tipoest in (5,2) " , "mwkguardiaf2")

				If mret > 0
					Select * From mwkguardiaf1 Union Select * From mwkguardiaf2 Into Cursor mwkguardiaf
					If Used('mwkentexg')
						Select *,Space(30) As nombre From mwkguardiaf Left Join mwkentexg On codent = codentexc Into Cursor mwkguardiaf
					Endif
					mpaso = .F.
				Endif
			Else
				Select * From mwkguardiaf1 Into Cursor mwkguardiaf
				If Used('mwkentexg')
					Select *,Space(30) As nombre From mwkguardiaf Left Join mwkentexg On codent = codentexc Into Cursor mwkguardiaf
				Endif
				mpaso = .F.

			Endif
		Endif
	Endif
	If mpaso
		Do Log_errores With Error(), Message(), Message(1)
		Messagebox("EN LA CONSULTA DEL PROFESIONAL Y EVOLUCION, "+Chr(10)+"DERIVACION DE PACIENTES, AVISE A SISTEMAS",16,"ERROR")
	Endif

Case mcual = 7		&& planilla desde hasta fecha 2014-06-16
	mfnull = Ctot("01/01/1900")

	mserv  = Iif(mtodos=1," val_codservvale<> 5410 and "," pia_codprest = codprest and val_codservvale in ( 8000,2150,6500,9600) and " )

	mret = SQLExec(mcon1, "select guardia.nrotriage,guardia.valortriage,guardia.fechahoratriage,guardia.protocolo, fechahoraing, REG_nombrepac," + ;
		" nombre, codprest, ent_descrient, pre_descriprest, " + ;
		" pre_especialidad, fechahoraate, codestado, guardiavale.id," + ;
		" prioridad,guardiavale.nrovale, reg_nrohclinica," + ;
		" reg_telefonos, REG_domicilio,reg_email,afi_nroafiliado,pia_codprest, " + ;
		" esp_descripcion, guardia.codent,guardiavale.codserv, guardia.codmed, " + ;
		" guardia.nroregistrac,guardia.usuario ,fechamodif,"+;
		" reg_numdocumento,descrip,codcie9,tipoest,val_operadorcarga,REG_sexo,REG_fecnacimiento,"+;
		" REG_localidad,REG_provincia,VAL_fechasolicitud, VAL_horasolicitud,"+;
		" prestadores.id as lidprestador, TabArtSg.TAS_IdArt, TabTipoAltas.descrip as taltades, TabTipoAltas.tipoest as taltaest," + ;
		" valesasist.val_bono, REG_nroregistrac, TabArtReg.ID as IdArtReg, TAR_codart, TAR_proxate, TAR_siniestro,guardia.UserDbAdd,guardia.FecHorDbAdd "+;
		" from afiliacion,valesasist,tabtipoaltas,presinsuvas,guardia  "+;
		" left outer join entidades 	on guardia.codent				= entidades.ent_codent " + ;
		" left outer join PRESTACIONS 	on prestacions.pre_codprest		= guardia.codprest " + ;
		" left outer join especialid 	on prestacions.pre_especialidad = especialid.esp_codesp " + ;
		" left outer join registracio 	on guardia.nroregistrac 		= registracio.reg_nroregistrac " + ;
		" left outer join guardiavale 	on guardia.protocolo 			= guardiavale.protocolo " + ;
		" left outer join prestadores 	on guardia.codmed 				= prestadores.id " + ;
		" left outer join TabArtSg      on TabArtSg.TAS_IdSG            = prestadores.id "+;
		" left outer join TabArtReg     on TAR_registracio = registracio.REG_nroregistrac and TAR_entidad = guardia.codent and TAR_finpro = ?mfnull "+;
		" where " + ;
		" guardiavale.nrovale = val_codvaleasist and "+;
		" pia_codprest = prestacions.pre_codprest and "+ mserv +;
		" guardia.nroregistrac = afiliacion.registracio and " + ;
		" presinsuvas.pia_valesasist = val_codpun and "+;
		" pia_codprest = prestacions.pre_codprest and "+;
		" guardia.codent = afiliacion.afi_codentidad and " + ;
		" guardia.codestado 		= tabtipoaltas.id and " + ;
		" guardia.fechahoraing >= ?mf1 and " + ;
		" guardia.fechahoraing <= ?mf2 "+mbuscog , "mwkguardia01")

	If mret<1
		Do Log_errores With Error(), Message(), Message(1)
		Return .F.
	Endif

	If Used("mwkMedicogua01" )
		Select nrotriage,valortriage,fechahoratriage,protocolo, fechahoraing, REG_nombrepac, ;
			iif(Isnull(mwkguardia01.nombre) Or (Empty(mwkguardia01.nombre) And codmed>1),mwkMedicogua01.nombre,mwkguardia01.nombre) As nombre, ;
			descrip,codprest, ENT_descrient, PRE_descriprest, PRE_especialidad, fechahoraate, codestado, mwkguardia01.Id,;
			prioridad,nrovale, REG_nrohclinica, REG_telefonos, REG_domicilio,reg_email, ;
			ESP_descripcion, codent,codserv, codmed,tipoest, val_operadorcarga,  ;
			nroregistrac,reg_numdocumento,descripcion, descrabrev  ,AFI_nroafiliado,fechamodif,REG_sexo,REG_fecnacimiento,;
			REG_localidad,REG_provincia,val_fechasolicitud, val_horasolicitud, codcie9, Nvl(lidprestador,0000000) As lidprestador, Nvl(TAS_IdArt,0000000) As lIdArt,  ;
			taltades,taltaest, Iif(Nvl(TAR_siniestro,0) = 0, val_bono, Transform(TAR_siniestro)) As val_bono, IdArtReg, TAR_codart, TAR_proxate ;
			,mwkguardia01.UserDbAdd,mwkguardia01.FecHorDbAdd;
			from mwkguardia01 Left Join mwkMedicogua01 On codmed = mwkMedicogua01.Id  ;
			left Join mwkciap2e On mwkciap2e.Id = codcie9 ;
			group By protocolo,nrovale ;
			order By fechahoraing Into Cursor mwkguardia
	Else
		Select * From mwkguardia01 ;
			group By protocolo;
			order By fechahoraing Into Cursor mwkguardia
	Endif

Case mcual = 8		&& Para control de profesionales con derivaciones
	mret = SQLExec(mcon1, "select nrotriage,valortriage,fechahoratriage,protocolo,fechahoraing,REG_nombrepac as paciente,codprest,ENT_descrient," + ;
		"PRE_descriprest,PRE_especialidad,fechahoraate,codestado,guardia.id,prioridad," + ;
		"REG_nrohclinica,REG_telefonos,REG_domicilio,reg_email,AFI_nroafiliado,ESP_descripcion,"+;
		"guardia.codmed,guardia.codent,nroregistrac,tipoest,puesto,descrip,REG_sexo,REG_fecnacimiento " + ;
		" from guardia,prestacions,registracio,entidades,afiliacion,especialid,tabtipoaltas " + ;
		" where guardia.nroregistrac = registracio.REG_nroregistrac and " + ;
		" guardia.nroregistrac = afiliacion.registracio and " + ;
		" guardia.codent = afiliacion.AFI_codentidad and " + ;
		" guardia.codestado = tabtipoaltas.id and " + ;
		" prestacions.PRE_especialidad = ESP_codesp and " + ;
		" guardia.codprest = prestacions.PRE_codprest and " + ;
		" guardia.codent = entidades.ENT_codent and " + ;
		" PRE_codservicio = 8000" + mbuscog + ;
		" and protocolo not in (select TGD_protocolo from TabGuaDeriv where TGD_medcab=?mcodmed) "+;
		" and guardia.fechahoraing >= ?mfecha and tipoest in (5,2)" , "mwkguardia1")

	If mret < 0
		Do Log_errores With Error(), Message(), Message(1)
		Return .F.
	Else
		mret = SQLExec(mcon1, "select nrotriage,valortriage,fechahoratriage,protocolo,fechahoraing,REG_nombrepac,codprest,ENT_descrient," + ;
			"PRE_descriprest,PRE_especialidad,fechahoraate,codestado,guardia.id,prioridad," + ;
			"REG_nrohclinica,REG_telefonos,REG_domicilio,reg_email,AFI_nroafiliado,ESP_descripcion,"+;
			"guardia.codmed,guardia.codent,nroregistrac,tipoest,puesto,descrip,REG_sexo,REG_fecnacimiento " + ;
			" from guardia,prestacions,registracio,entidades,afiliacion,especialid,tabtipoaltas,TabGuaDeriv " + ;
			" where guardia.nroregistrac = registracio.REG_nroregistrac and " + ;
			" guardia.nroregistrac = afiliacion.registracio and " + ;
			" guardia.codent = afiliacion.AFI_codentidad and " + ;
			" guardia.codestado = tabtipoaltas.id and " + ;
			" prestacions.PRE_especialidad = ESP_codesp and " + ;
			" guardia.codprest = prestacions.PRE_codprest and " + ;
			" guardia.codent = entidades.ENT_codent and " + ;
			" PRE_codservicio = 8000" + mbuscov +;
			" and guardia.fechahoraing >= ?mfecha and tipoest in (5,2) " , "mwkguardia2")

		If mret < 0
			Do Log_errores With Error(), Message(), Message(1)
			Return .F.
		Else
			Select * From mwkguardia1 Union Select * From mwkguardia2 Into Cursor mwkguardia
		Endif
	Endif

*!*		if used('mwkguardia1')
*!*		  use in mwkguardia1
*!*		endif
*!*		if used('mwkguardia2')
*!*		  use in mwkguardia2
*!*		endif

Case mcual = 9		&& planilla desde hasta fecha CEG
	horactr = Val(Left(Ttoc(mfechactr,2),2))

*!*	mf1 = prg_dtoc(mfecha1)
*!*	mf2 = prg_dtoc(mfecha2+1)

	mserv = Iif(mtodos=1,' val_codservvale<> 5410 and ',"pia_codprest = codprest and val_codservvale in ( 8000,2150,6500,9600 ) " )
	mret = SQLExec(mcon1, "select guardia.nrotriage,guardia.valortriage,guardia.fechahoratriage,guardia.protocolo, fechahoraing, REG_nombrepac," + ;
		" nombre, codprest, ent_descrient, pre_descriprest, " + ;
		" pre_especialidad, fechahoraate, guardia.codestado, guardia.id," + ;
		" prioridad,guardiavale.nrovale, reg_nrohclinica,pia_codprest," + ;
		" reg_telefonos, REG_domicilio,reg_email, afi_nroafiliado," + ;
		" esp_descripcion, guardia.codent,guardiavale.codserv, guardia.codmed, " + ;
		" nroregistrac, guardia.usuario,ptovta, tpocte,nrocte,letracte, fechacte,nroregistracio "+;
		" ,val_horasolicitud,val_fechasolicitud,val_codvaleasist,tipoest,descrip," + ;
		" val_prestador ,val_codservvale,VAL_codadmision , val_bono,reg_numdocumento, pia_cantsolicitada,"+;
		" guardiavale.diagnostico,TabCiap2E.descripcion as descie,val_operadorcarga,REG_sexo,REG_fecnacimiento,guardia.UserDbAdd,guardia.FecHorDbAdd  " + ;
		" from afiliacion,prestacions,valesasist,presinsuvas,tabtipoaltas,guardia "+;
		" inner join tabguardia on (tabguardia.protocolo = guardia.protocolo  "+;
		" and tabguardia.codestado = ?mesta  )"+;
		" left outer join entidades on guardia.codent				= entidades.ent_codent " + ;
		" left outer join especialid 	on prestacions.pre_especialidad = especialid.esp_codesp " + ;
		" left outer join registracio 	on guardia.nroregistrac 		= registracio.reg_nroregistrac " + ;
		" left outer join guardiavale 	on guardia.protocolo 			= guardiavale.protocolo " + ;
		" left outer join prestadores 	on guardia.codmed 				= prestadores.id " + ;
		" left outer join tabfacturas 	on tabfacturas.codpun 			= valesasist.val_codpun " +;
		" left outer join TabCiap2E      on TabCiap2E.Id                 = guardia.codcie9 "+;
		" WHERE "+;
		" tabguardia.ID > 1263000 and "+;
		" tabguardia.fechaMod>= ?mf1 and tabguardia.fechaMod<= ?mf2 and "+;
		" guardiavale.nrovale = val_codvaleasist and "+;
		" presinsuvas.pia_valesasist = val_codpun and "+;
		" pia_codprest = prestacions.pre_codprest and "+;
		" guardia.codestado = tabtipoaltas.id and " + ;
		" guardia.nroregistrac = afiliacion.registracio and " + ;
		" guardia.codent = afiliacion.afi_codentidad and " + mserv + ;
		" group by guardia.protocolo" , "mwkguardia01")

&&& saque 5800

	If mret<1
		Do Log_errores With Error(), Message(), Message(1)
		Return .F.
	Endif

	If Used("mwkMedicogua01" )
		Select nrotriage,valortriage,fechahoratriage,protocolo, fechahoraing, REG_nombrepac, ;
			iif(Isnull(mwkguardia01.nombre) Or (Empty(mwkguardia01.nombre) And codmed>1),mwkMedicogua01.nombre,mwkguardia01.nombre) As nombre, ;
			codprest, ENT_descrient, ;
			PRE_descriprest, PRE_especialidad, fechahoraate, codestado, mwkguardia01.Id,;
			prioridad,nrovale, REG_nrohclinica, REG_telefonos, REG_domicilio,reg_email, AFI_nroafiliado, ;
			ESP_descripcion, codent,codserv, codmed, nroregistrac, usuario,pia_codprest,;
			ptovta, tpocte,nrocte,letracte, nroregistracio ,val_horasolicitud,val_fechasolicitud,val_codvaleasist, ;
			val_prestador ,val_codservvale,VAL_codadmision , val_bono,reg_numdocumento,tipoest,Descrip,;
			pia_cantsolicitada,diagnostico,descie,fechacte,val_operadorcarga,REG_sexo,REG_fecnacimiento   ;
			,mwkguardia01.UserDbAdd,mwkguardia01.FecHorDbAdd;
			from mwkguardia01 Left Join mwkMedicogua01 On codmed = mwkMedicogua01.Id  ;
			group By nrovale,pia_codprest;
			order By fechahoraing Into Cursor mwkguardia
	Else
		Select * From mwkguardia01 ;
			group By nrovale,pia_codprest;
			order By fechahoraing Into Cursor mwkguardia
	Endif

Case mcual = 10	&& planilla desde HCE Legales
	Use In Select("mwkguardia01")
	mret = SQLExec(mcon1, "select guardia.nrotriage,guardia.valortriage,guardia.fechahoratriage,guardia.protocolo, fechahoraing, REG_nombrepac," + ;
		" nombre, codprest, ent_descrient, pre_descriprest, " + ;
		" pre_especialidad, fechahoraate, codestado, guardiavale.id," + ;
		" prioridad,guardiavale.nrovale, reg_nrohclinica," + ;
		" reg_telefonos, REG_domicilio,reg_email,afi_nroafiliado,pia_codprest, " + ;
		" esp_descripcion, guardia.codent,guardiavale.codserv, guardia.codmed, " + ;
		" guardia.nroregistrac,guardia.usuario ,fechamodif,"+;
		" reg_numdocumento,descrip,codcie9,tipoest,val_operadorcarga,REG_sexo,REG_fecnacimiento " + ;
		" from afiliacion,valesasist,tabtipoaltas,presinsuvas,guardia  "+;
		" left outer join entidades 		on guardia.codent				= entidades.ent_codent " + ;
		" left outer join PRESTACIONS 	on prestacions.pre_codprest		= guardia.codprest " + ;
		" left outer join  especialid 	on prestacions.pre_especialidad = especialid.esp_codesp " + ;
		" left outer join  registracio 	on guardia.nroregistrac 		= registracio.reg_nroregistrac " + ;
		" left outer join guardiavale 	on guardia.protocolo 			= guardiavale.protocolo " + ;
		" left outer join prestadores 	on guardia.codmed 				= prestadores.id " + ;
		" where " + ;
		" guardiavale.nrovale = val_codvaleasist and "+;
		" pia_codprest = prestacions.pre_codprest and "+;
		" guardia.nroregistrac = afiliacion.registracio and " + ;
		" presinsuvas.pia_valesasist = val_codpun and "+;
		" pia_codprest = prestacions.pre_codprest and "+;
		" guardia.codent = afiliacion.afi_codentidad and " + ;
		" guardia.codestado = tabtipoaltas.id and guardia.protocolo = ?mbuscog","mwkguardia01")

	If mret<1
		Do Log_errores With Error(), Message(), Message(1)
		Return .F.
	Endif

	If Used("mwkMedicogua01" )

		Select nrotriage,valortriage,fechahoratriage,protocolo, fechahoraing, REG_nombrepac, ;
			iif(Isnull(mwkguardia01.nombre) Or (Empty(mwkguardia01.nombre) And codmed>1),mwkMedicogua01.nombre,;
			mwkguardia01.nombre) As nombre, ;
			descrip,codprest, ENT_descrient, PRE_descriprest, PRE_especialidad, fechahoraate,codestado,mwkguardia01.Id,;
			prioridad,nrovale, REG_nrohclinica, REG_telefonos, REG_domicilio,reg_email, ;
			ESP_descripcion, codent,codserv, codmed,tipoest, val_operadorcarga,  ;
			nroregistrac,reg_numdocumento,descripcion,AFI_nroafiliado,fechamodif,REG_sexo,REG_fecnacimiento,descrabrev ;
			from mwkguardia01 Left Join mwkMedicogua01 On codmed = mwkMedicogua01.Id  ;
			left Join mwkciap2e On mwkciap2e.Id = codcie9 ;
			group By protocolo,nrovale ;
			order By fechahoraing Into Cursor mwkguardia

	Else
		Select * From mwkguardia01 ;
			group By protocolo;
			order By fechahoraing Into Cursor mwkguardia
	Endif
Case mcual = 11	&& planilla preadmitidos
	Do sp_busco_estados With 57,' and tipo = 29 ','mwkhabprea'&&
	If ( mwkhabprea.estado = 1 Or  myip='172.16.1.7' ) And lpreadm
		mret = SQLExec(mcon1, "select  ZabGuardiaDom.protocolo, ZabGuardiaDom.fechahoraing, REG_nombrepac,nombre, ZabGuardiaDom.codprest, ENT_descrient, " + ;
			" PRE_descriprest, PRE_especialidad, ZabGuardiaDom.fechahoraate, ZabGuardiaDom.codestado,  ZabGuardiaDom.id, " + ;
			" REG_nrohclinica, REG_telefonos, REG_domicilio,reg_email,  ESP_descripcion,"+;
			"  ZabGuardiaDom.codent,ZabGuardiaDom.diagnostico,ZabGuardiaDom.nroregistrac, CAST(0 as integer) as tipoest ,   " + ;
			" cast(CASE WHEN ZabGuardiaDom.codestado  = 1 THEN 'PRE ADMITIDO' "+;
			" ELSE CASE WHEN ZabGuardiaDom.codestado  = 2 THEN 'ADMITIDO' ELSE "+;
			" CASE WHEN ZabGuardiaDom.codestado  = 3 THEN 'ATENDIDO' ELSE CASE WHEN ZabGuardiaDom.codestado  = 7 THEN 'DESISTE' ELSE  "+;
			" CASE WHEN ZabGuardiaDom.codestado  = 8 THEN 'AUSENTE' ELSE 'FINALIZADO' END "+;
			" END END END  END As CHARACTER(100)) as DESCRIP,"+;
			" CAST('0' as CHARACTER(1)) as  sector,REG_sexo,REG_fecnacimiento,REG_localidad,reg_numdocumento ,guardia.UserDbAdd,guardia.FecHorDbAdd "+;
			" from prestacions, entidades, especialid, registracio,ZabGuardiaDom,prestadores   " + ;
			" left join guardia on ZabGuardiaDom.protocolo = guardia.protocolo "+;
			" where ZabGuardiaDom.nroregistrac = registracio.REG_nroregistrac and " + ;
			" ZabGuardiaDom.codprest = prestacions.PRE_codprest and " + ;
			" prestacions.PRE_especialidad = ESP_codesp and " + ;
			" ZabGuardiaDom.codent	= entidades.ENT_codent and " + ;
			" ZabGuardiaDom.fechahoraing >= ?mfecha and PRE_codservicio = 8000 "+;
			" and prestadores.id = 1 " , "mwkguardiadom")

		Select 0 As nrotriage,0 As valortriage,Ctot("01/01/1900") As fechahoratriage,protocolo, fechahoraing, REG_nombrepac, nombre, codprest, ENT_descrient,  ;
			PRE_descriprest, PRE_especialidad, fechahoraate, codestado, Id,0 As prioridad,   ;
			REG_nrohclinica, REG_telefonos, REG_domicilio,reg_email, Space(20) As AFI_nroafiliado, ESP_descripcion, ;
			codent, nroregistrac,1 As codmed,  tipoest,0 As puesto,Descrip,0 As codcie9	, ;
			sector,REG_sexo,REG_fecnacimiento,REG_localidad,reg_numdocumento,diagnostico,mwkguardiadom.UserDbAdd,mwkguardiadom.FecHorDbAdd;
			FROM mwkguardiadom Into Cursor mwkguardia0

		If Used("mwkMedicogua01" )
			Select nrotriage,valortriage,fechahoratriage,protocolo, fechahoraing, REG_nombrepac, ;
				iif(Isnull(mwkguardia0.nombre) Or (Empty(mwkguardia0.nombre) And codmed>1),mwkMedicogua01.nombre,mwkguardia0.nombre) As nombre, ;
				codprest, ENT_descrient, ;
				PRE_descriprest, PRE_especialidad, fechahoraate, codestado, mwkguardia0.Id, prioridad, ;
				REG_nrohclinica, REG_telefonos, REG_domicilio,reg_email, AFI_nroafiliado, ESP_descripcion,;
				codent, nroregistrac,mwkguardia0.codmed,tpopac,tipoest,Nvl(puesto,0) As puesto,Descrip ;
				,codentexc,fecpasiva,tpopac,codcie9,descripcion,mwkprotomsg.*,sector,reg_numdocumento,diagnostico,     ;
				REG_sexo,REG_fecnacimiento,REG_localidad,Ttod(fechahoraate) As fechaaate,FecHorDbAdd,UserDbAdd;
				from mwkguardia0 Left Join mwkMedicogua01 On codmed = mwkMedicogua01.Id  ;
				left Join mwkentexg On codent = codentexc ;
				left Join mwkprotomsg On protocolo = TGM_protocolo  ;
				left Join mwkciap2e On mwkciap2e.Id = codcie9 ;
				group By fechahoraing ,protocolo,codprest,mwkguardia0.Id,AFI_nroafiliado ;
				order By fechahoraing Into Cursor mwkguardia
		Else
			Select *,Ttod(fechahoraate) As fechaaate  From mwkguardia0 ;
				left Join mwkentexg On codent = codentexc ;
				left Join mwkciap2e On mwkciap2e.Id = codcie9 ;
				left Join mwkprotomsg On protocolo = TGM_protocolo  ;
				into Cursor mwkguardia
		Endif
	Endif
Endcase
