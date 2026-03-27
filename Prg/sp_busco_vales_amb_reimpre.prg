****
** busca los protocolo de ambulatorio para la grilla
****
parameter mfecha1,mfecha2,mnvale
if vartype(mnvale)#"N"
	mnvale = 0
endif
mfechactr = sp_busco_fecha_serv('DT')
mfecha = mfecha1
mfechaobs = mfechactr - 14400  && 4 horas
mf1 = prg_dtoc(mfecha1)
mf2 = prg_dtoc(mfecha2)

if mnvale = 0
	mserv = " pia_codprest = codprest  and "  &&and val_codservvale = 2200
	mret = SQLExec(mcon1, "select tabambulatorio.protocolo, fechahoraing, REG_nombrepac," + ;
		" nombre, codprest, ent_descrient, pre_descriprest, " + ;
		" pre_especialidad, fechahoraate, codestado, tabambulatorio.id," + ;
		" tabambulatorio.nrovale, reg_nrohclinica," + ;
		" reg_telefonos, reg_domicilio,afi_nroafiliado,pia_codprest, " + ;
		" esp_descripcion, tabambulatorio.codent,val_codservvale, tabambulatorio.codmed, " + ;
		"tabambulatorio.nroregistrac,tabambulatorio.usuario  ,"+;
		" reg_numdocumento,descrip,codcie9,tipoest,val_operadorcarga,his_codcontrato " + ;
		"from afiliacion,valesasist,tabtipoaltas,presinsuvas,tabambulatorio,histambgua "+;
		"left outer join entidades 		on tabambulatorio.codent				= entidades.ent_codent " + ;
		"left outer join PRESTACIONS 	on prestacions.pre_codprest		= tabambulatorio.codprest " + ;
		"left outer join  especialid 	on prestacions.pre_especialidad = especialid.esp_codesp " + ;
		"left outer join  registracio 	on tabambulatorio.nroregistrac 		= registracio.reg_nroregistrac " + ;
		"left outer join prestadores 	on tabambulatorio.codmed 				= prestadores.id " + ;
		"where his_codadmision =  VAL_codadmision and " + ;
		" his_nroregistrac = tabambulatorio.nroregistrac and " + ;
		" tabambulatorio.nrovale = val_codvaleasist and "+;
		" pia_codprest = prestacions.pre_codprest and " +;
		"tabambulatorio.nroregistrac = afiliacion.registracio and " + ;
		" presinsuvas.pia_valesasist = val_codpun and "+;
		" pia_codprest = prestacions.pre_codprest and "+;
		"tabambulatorio.codent = afiliacion.afi_codentidad and " + ;
		"tabambulatorio.codestado 		= tabtipoaltas.id and " + ;
		"tabambulatorio.fechaate>= ?mf1 and " + ;
		"tabambulatorio.fechaate< ?mf2 "+;
		" order by fechahoraing desc", "mwkambula01")
else
	mserv = " pia_codprest = codprest  and "  &&and val_codservvale = 2200
	mret = SQLExec(mcon1, "select tabambulatorio.protocolo, fechahoraing, REG_nombrepac," + ;
		" nombre, codprest, ent_descrient, pre_descriprest, " + ;
		" pre_especialidad, fechahoraate, codestado, tabambulatorio.id," + ;
		" tabambulatorio.nrovale, reg_nrohclinica," + ;
		" reg_telefonos, reg_domicilio,afi_nroafiliado,pia_codprest, " + ;
		" esp_descripcion, tabambulatorio.codent,val_codservvale, tabambulatorio.codmed, " + ;
		"tabambulatorio.nroregistrac,tabambulatorio.usuario  ,"+;
		" reg_numdocumento,descrip,codcie9,tipoest,val_operadorcarga,his_codcontrato " + ;
		"from afiliacion,valesasist,tabtipoaltas,presinsuvas,tabambulatorio,histambgua "+;
		"left outer join entidades 		on tabambulatorio.codent				= entidades.ent_codent " + ;
		"left outer join PRESTACIONS 	on prestacions.pre_codprest		= tabambulatorio.codprest " + ;
		"left outer join  especialid 	on prestacions.pre_especialidad = especialid.esp_codesp " + ;
		"left outer join  registracio 	on tabambulatorio.nroregistrac 		= registracio.reg_nroregistrac " + ;
		"left outer join prestadores 	on tabambulatorio.codmed 				= prestadores.id " + ;
		"where his_codadmision =  VAL_codadmision and " + ;
		" his_nroregistrac = tabambulatorio.nroregistrac and " + ;
		" tabambulatorio.nrovale = val_codvaleasist and "+;
		" pia_codprest = prestacions.pre_codprest and "+ mserv +;
		"tabambulatorio.nroregistrac = afiliacion.registracio and " + ;
		" presinsuvas.pia_valesasist = val_codpun and "+;
		" pia_codprest = prestacions.pre_codprest and "+;
		"tabambulatorio.codent = afiliacion.afi_codentidad and " + ;
		"tabambulatorio.codestado 		= tabtipoaltas.id and " + ;
		"tabambulatorio.nrovale = ?mnvale "+;
		" order by fechahoraing desc", "mwkambula01")
endif

if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif
if used("mwkMedicogua01" )
	select protocolo, fechahoraing, REG_nombrepac, ;
		iif(isnull(mwkambula01.nombre) or (empty(mwkambula01.nombre) and codmed>1),mwkMedicogua01.nombre,mwkambula01.nombre) as nombre, ;
		descrip,codprest, ENT_descrient, PRE_descriprest, PRE_especialidad, fechahoraate, codestado, mwkambula01.id,;
		prioridad,nrovale, REG_nrohclinica, REG_telefonos, REG_domicilio, ;
		ESP_descripcion, codent,codserv, codmed,tipoest, val_operadorcarga,  ;
		nroregistrac,reg_numdocumento,descrabrev,AFI_nroafiliado;
		from mwkambula01 left join mwkMedicogua01 on codmed = mwkMedicogua01.id  ;
		left join mwkciap2e on mwkciap2e.id = codcie9 ;
		group by protocolo ;
		order by fechahoraing into cursor mwkambula
else
	select * from mwkambula01 ;
		group by protocolo;
		order by fechahoraing into cursor mwkambula
endif

