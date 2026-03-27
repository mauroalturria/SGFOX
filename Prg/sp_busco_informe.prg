****
**** Busco informes en un estado determinado  // && fechainforme = to_date('20/06/2006','dd/mm/yyyy') and
****
parameters mifiltro, mopcion

if vartype(mopcion)#"N"
	mopcion = 1
endif

mret = sqlexec(mcon1," select id as idprest,nombre from prestadores ", "mwkprestadores" )

mifechafiltro = ctod("05/05/2008")
*mifechafiltro = ctod("02/01/2007")
mifiltro = mifiltro + iif(at("estadoinforme = 3",mifiltro)>0,;
	" and fechaAprobacion >= ?mifechafiltro ","")

do case
	case mopcion = 1
		mret = sqlexec(mcon1," select val_codadmision,nroprotocolo,nrovale,fechainforme,pac_nombrepaciente,pre_descriprest, " + ;
			" val_prestador,informes.id,codservvale,VAL_tipopaciente,estadoinforme,val_fechasolicitud,Tabestados.Descrip    " + ;
			" FROM informes,prestacions,valesasist,pacientes,Tabestados " + ;
			" where pre_codprest = codprest and val_codpun = codpun  and " + ;
			" propietario = 10 and estado = estadoinforme and tipo = 1 and " + ;
			" pac_codadmision  = val_codadmision and "+ mifiltro ,"mwkInformes")

	case mopcion = 2 && coberturas - INTERNADOS
		mret = sqlexec(mcon1," select val_codadmision, nroprotocolo, nrovale, fechainforme, " + ;
			"pac_nombrepaciente, pre_descriprest, val_prestador, informes.id, codservvale, " + ;
			"VAL_tipopaciente, estadoinforme, val_fechasolicitud, Tabestados.Descrip, " + ;
			"Entidades.Ent_Codent, Entidades.ENT_descrient,ENT_nroprestadorexterno " + ;
			"FROM informes, prestacions, valesasist, pacientes, Tabestados " + ;
			"Inner join coberturas on cob_pacientes = pac_codadmision " + ;
			"Left join Entidades on COB_codentidad = Ent_CodEnt " + ;
			"where pre_codprest = codprest and val_codpun = codpun  and " + ;
			"propietario = 10 and estado = estadoinforme and tipo = 1 and " + ;
			"pac_codadmision  = val_codadmision and " + mifiltro ,"mwkInformes")

	case mopcion = 3 && AMBULATORIO Y GUARDIA 
		mret = sqlexec(mcon1," select val_codadmision, nroprotocolo, nrovale, fechainforme, " + ;
			"pac_nombrepaciente, pre_descriprest, val_prestador, informes.id, codservvale, " + ;
			"VAL_tipopaciente, estadoinforme, val_fechasolicitud, Tabestados.Descrip, " + ;
			"Entidades.Ent_Codent, Entidades.Ent_DescriEnt " + ;
			"FROM informes, prestacions, valesasist, pacientes, Tabestados " + ;
			"Left join histambgua on PAC_codhci = his_nroregistrac " + ;
			"Left join Entidades on Histambgua.HIS_codentidad = Ent_CodEnt " + ;
			"where pre_codprest = codprest and val_codpun = codpun  and " + ;
			"propietario = 10 and estado = estadoinforme and tipo = 1 and " + ;
			"pac_codadmision  = val_codadmision and " + mifiltro + "" + ;
			"group by informes.id ","mwkInformes")

*!*	HIS_nroregistrac = pac_codadmision

	case mopcion = 9

		mret = sqlexec(mcon1," select val_codadmision,nroprotocolo,nrovale,fechainforme,pac_nombrepaciente,pre_descriprest, " + ;
			" val_prestador,informes.id,codservvale,VAL_tipopaciente,estadoinforme,val_fechasolicitud,Tabestados.Descrip    " + ;
			",PAC_codhci,TabProtocolo.tpobserva,TabProtocolo.tpestado" + ;
			" FROM prestacions,valesasist,pacientes,Tabestados,informes " + ;
			" left join TabProtocolo on TabProtocolo.tpestado=?mopcion " + ;
			" and TabProtocolo.tpprotocolo = informes.nroprotocolo" + ;
			" where pre_codprest = codprest and val_codpun = codpun  and tipo = 1 and " + ;
			" propietario = 10 and estado = estadoinforme " + ;
			" and pac_codadmision  = val_codadmision and "+ mifiltro ,"mwkInformes")


	case mopcion = 10
		
		mret = sqlexec(mcon1, "Select top 1 informes.*, " + ;
			"prestacions.Pre_Descriprest, " + ;
			"nvl(Tabestados.Descrip,'') as Descrip, " + ;
			"servicios.SER_descripserv, " + ;
			"Prestadores.Nombre, " + ;
			"valesasist.val_fechasolicitud, "+ ;
			"valesasist.val_codservvale,valesasist.val_codmnemoserv,valesasist.val_codsector " + ;
			"from informes " + ;
			"Inner Join prestacions on Pre_CodPrest = informes.CodPrest " + ;
			"Left Join Prestadores on Prestadores.Id = informes.CodMedFirma " + ;
			"Inner Join servicios on ser_codserv = informes.CodServVale " + ;
			"left Join Tabestados On Tabestados.estado = estadoinforme and propietario = 10 " + ;
			"left join ValesAsist on informes.nrovale = val_codvaleasist " +;
			"where 1=1 " + mifiltro  ,"mwkInformes")


	case mopcion = 11 && CAMBIO DE ESTADO
		
		mret = sqlexec(mcon1, "Select TOP 1 informes.Id,informes.estadoinforme,informes.codmedfirma, informes.NroVale " + ;
			"from informes " + ;
			"where 1=1 " + mifiltro + "ORDER BY informes.Id DESC" ,"mwkInformes")


	case mopcion = 12 && HCE
		
		mret = sqlexec(mcon1, "Select informes.*, " + ;
			"nvl(Tabestados.Descrip,'') as Descrip, " + ;
			"servicios.SER_descripserv, " + ;
			"Prestadores.Nombre, " + ;
			"InformesLog.DocumentoBase, InformesLog.FechaLog " + ;
			"from informes " + ;
			"Left Join Prestadores on Prestadores.Id = informes.CodMedFirma " + ;
			"Inner Join servicios on ser_codserv = informes.CodServVale " + ;
			"left Join Tabestados On Tabestados.estado = estadoinforme and propietario = 10 " + ;
			"Inner Join InformesLog on Informes.Id = InformesLog.IdInforme and InformesLog.TipoLog = 13 " + ;
			"where 1=1 " + mifiltro  ,"mwkInformes")
			

	case mopcion = 13 && informes 27 
		
		mret = sqlexec(mcon1, "Select informes.*, " + ;
			"prestacions.Pre_Descriprest, " + ;
			"nvl(Tabestados.Descrip,'') as Descrip, " + ;
			"servicios.SER_descripserv, " + ;
			"Prestadores.Nombre, " + ;
			"valesasist.val_fechasolicitud, "+ ;
			"valesasist.val_codservvale,valesasist.val_codmnemoserv,valesasist.val_codsector " + ;
			"from informes " + ;
			"Inner Join prestacions on Pre_CodPrest = informes.CodPrest " + ;
			"Left Join Prestadores on Prestadores.Id = informes.CodMedFirma " + ;
			"Inner Join servicios on ser_codserv = informes.CodServVale " + ;
			"left Join Tabestados On Tabestados.estado = estadoinforme and propietario = 10 " + ;
			"left join ValesAsist on informes.nrovale = val_codvaleasist " +;
			"where 1=1 " + mifiltro  ,"mwkInformes")

Endcase

if mret<1
	=aerr(eros)
	messagebox(eros(3))
	Return .f.
endif

