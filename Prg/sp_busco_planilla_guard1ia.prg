****
** busca los protocolo de guardia para la grilla
****

parameter mcual,mfecha1,mfecha2,mbuscog,mbuscov
if type ('mbuscog')#"C"
	mbuscog = ''
endif
if type ('mbuscov')#"C"
	mbuscov = ''
endif
mfechactr = sp_busco_fecha_serv('DT')
if type("mfecha1")="T"
	mfecha = mfecha1
else
	mfecha = mfechactr - 172800  && 57600 && 16hs   &&  86400  &&  24hs
endif
mret = sqlexec(mcon1,"SELECT ID , nombre FROM TabMedExterno where gerenciadora = 0 ", "mwkMedicogua01" )
mret = sqlexec(mcon1, "select fecpasiva,codent as codentexc,tpopac  from entidexclu "+;
	"where tpopac = 'GUA' union select fecpasiva,codent as codentexc,tpopac  from entidexclu "+;
	"where tpopac = 'INT' and codent not in ( select codent from entidexclu "+;
	"where tpopac = 'GUA')","mwkentex")

if mcual = 1		&& planilla completa

	mret = sqlexec(mcon1, "select protocolo, fechahoraing, REG_nombrepac, nombre, codprest, ENT_descrient, " + ;
		"PRE_descriprest, PRE_especialidad, fechahoraate, codestado, guardia.id, prioridad, " + ;
		"REG_nrohclinica, REG_telefonos, REG_domicilio, AFI_nroafiliado, ESP_descripcion,"+;
		" guardia.codent, nroregistrac,guardia.codmed,guardia.ID, tipoest  " + ;
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

	if used("mwkMedicogua01" )
		select protocolo, fechahoraing, REG_nombrepac, ;
			iif(isnull(mwkguardia0.nombre),mwkMedicogua01.nombre,mwkguardia0.nombre) as nombre, ;
			codprest, ENT_descrient, ;
			PRE_descriprest, PRE_especialidad, fechahoraate, codestado, mwkguardia0.id, prioridad, ;
			REG_nrohclinica, REG_telefonos, REG_domicilio, AFI_nroafiliado, ESP_descripcion,;
			codent, nroregistrac,mwkguardia0.codmed,tpopac   ;
			from mwkguardia0 left join mwkMedicogua01 on codmed = mwkMedicogua01.id  ;
			left join mwkentex on codent = codentexc ;
			group by fechahoraing ,protocolo,codprest,mwkguardia0.id,AFI_nroafiliado ;
			order by fechahoraing into cursor mwkguardia
	else
		select * from mwkguardia0 left join mwkentex on codent = codentexc into cursor mwkguardia
	endif

endif

if mcual = 2		&& planilla para asignacion de profesional

	mret = sqlexec(mcon1, "select protocolo, fechahoraing, REG_nombrepac, codprest, ENT_descrient, " + ;
		"PRE_descriprest, PRE_especialidad, fechahoraate, codestado, guardia.id, prioridad, " + ;
		"REG_nrohclinica, REG_telefonos, REG_domicilio, AFI_nroafiliado, ESP_descripcion, "+;
		"guardia.codmed,guardia.codent, nroregistrac, tipoest  " + ;
		"from guardia, prestacions, registracio, entidades, afiliacion, especialid,tabtipoaltas " + ;
		"where guardia.nroregistrac = registracio.REG_nroregistrac and " + ;
		"guardia.nroregistrac = afiliacion.registracio and " + ;
		"guardia.codent = afiliacion.AFI_codentidad and " + ;
		"guardia.codestado 		= tabtipoaltas.id and " + ;
		"prestacions.PRE_especialidad = ESP_codesp and " + ;
		"guardia.codprest = prestacions.PRE_codprest and " + ;
		"guardia.codent = entidades.ENT_codent and " + ;
		"guardia.codmed = 1 and PRE_codservicio = 8000 and " + ;
		"guardia.fechahoraing >= ?mfecha " , "mwkguardia")
*!*						+ ;
*!*						"order by fechahoraing"
	select * from mwkguardia left join mwkentex on codent = codentexc into cursor mwkguardia
endif
if mcual = 4		&& planilla para asignacion de profesional interconsulta

	mret = sqlexec(mcon1, "select protocolo, fechahoraing, REG_nombrepac, codprest, ENT_descrient, " + ;
		"PRE_descriprest, PRE_especialidad, fechahoraate, codestado, guardia.id, prioridad, " + ;
		"REG_nrohclinica, REG_telefonos, REG_domicilio, AFI_nroafiliado, ESP_descripcion, "+;
		"guardia.codmed,guardia.codent, nroregistrac, tipoest  " + ;
		"from guardia, prestacions, registracio, entidades, afiliacion, especialid,tabtipoaltas " + ;
		"where guardia.nroregistrac = registracio.REG_nroregistrac and " + ;
		"guardia.nroregistrac = afiliacion.registracio and " + ;
		"guardia.codent = afiliacion.AFI_codentidad and " + ;
		"guardia.codestado 		= tabtipoaltas.id and " + ;
		"prestacions.PRE_especialidad = ESP_codesp and " + ;
		"guardia.codprest = prestacions.PRE_codprest and " + ;
		"guardia.codent = entidades.ENT_codent and " + ;
		"guardia.codmed > 1 and PRE_codservicio = 8000 and " + ;
		"guardia.fechahoraing >= ?mfecha " , "mwkguardia")
*!*						+ ;
*!*						"order by fechahoraing"
	select * from mwkguardia left join mwkentex on codent = codentexc into cursor mwkguardia

endif

if mcual = 5		&& planilla enfermeria

	mret = sqlexec(mcon1, "select protocolo, fechahoraing, REG_nombrepac, nombre, codprest, ENT_descrient, " + ;
		"PRE_descriprest, PRE_especialidad, fechahoraate, codestado, guardia.id, prioridad, " + ;
		"REG_nrohclinica, REG_telefonos, REG_domicilio, AFI_nroafiliado, ESP_descripcion,"+;
		" guardia.codent, nroregistrac,guardia.codmed,guardia.ID, tipoest  " + ;
		"from prestacions, entidades, especialid, registracio, afiliacion," + ;
		"tabtipoaltas,guardia left outer join prestadores on guardia.codmed = prestadores.id " + ;
		"where guardia.nroregistrac = registracio.REG_nroregistrac and " + ;
		"guardia.nroregistrac = afiliacion.registracio and " + ;
		"guardia.codent = afiliacion.AFI_codentidad and " + ;
		"guardia.codprest = prestacions.PRE_codprest and " + ;
		"guardia.codestado 		= tabtipoaltas.id and " + ;
		"prestacions.PRE_especialidad = ESP_codesp and " + ;
		"guardia.codent	= entidades.ENT_codent and " + ;
		"guardia.fechahoraing >= ?mfecha  " + ;
		"", "mwkguardia0")

	if used("mwkMedicogua01" )
		select protocolo, fechahoraing, REG_nombrepac, ;
			iif(isnull(mwkguardia0.nombre),mwkMedicogua01.nombre,mwkguardia0.nombre) as nombre, ;
			codprest, ENT_descrient, ;
			PRE_descriprest, PRE_especialidad, fechahoraate, codestado, mwkguardia0.id, prioridad, ;
			REG_nrohclinica, REG_telefonos, REG_domicilio, AFI_nroafiliado, ESP_descripcion,;
			codent, nroregistrac,mwkguardia0.codmed,tpopac   ;
			from mwkguardia0 left join mwkMedicogua01 on codmed = mwkMedicogua01.id  ;
			left join mwkentex on codent = codentexc ;
			group by fechahoraing ,protocolo,codprest,mwkguardia0.id,AFI_nroafiliado ;
			order by fechahoraing into cursor mwkguardia
	else
		select * from mwkguardia0 left join mwkentex on codent = codentexc into cursor mwkguardia
	endif
endif
if mcual = 3		&& planilla desde hasta fecha
	horactr = val(left(ttoc(mfechactr,2),2))
	if (mfecha2 - mfecha1) > 7 and horactr>10 and horactr<16  ;
			and alltrim(mwkusuario.sector) # "SISTEMAS" and empty(alltr(mbuscog)+alltr(mbuscov))
		do sp_insert_tabCtrlErr with "Desde:"+transf(mfecha1)+" hasta:"+ transf(mfecha2)+;
			" a las:"+ transf(mfechactr),"", mwkusuario.idusuario, "PlanillaGuardia"
		messagebox("ERROR EN LA GENERACION DEL CURSOR"+ chr(13) +"SELECCIONE UN RANGO MENOR", 16, "validacion")
	else
		mf1 = prg_dtoc(mfecha1)
		mf2 = prg_dtoc(mfecha2+1)

		do sp_insert_tabCtrlErr with "Desde:"+transf(mfecha1)+" hasta:"+ transf(mfecha2)+;
			" a las:"+ transf(mfechactr),"", mwkusuario.idusuario, "PlanillaGuardia"
		mret = sqlexec(mcon1, "select guardia.protocolo, fechahoraing, REG_nombrepac," + ;
			" nombre, codprest, ENT_descrient, PRE_descriprest, " + ;
			" PRE_especialidad, fechahoraate, codestado, guardia.id," + ;
			" prioridad,guardiavale.nrovale, REG_nrohclinica," + ;
			" REG_telefonos, REG_domicilio, AFI_nroafiliado," + ;
			" ESP_descripcion, guardia.codent,guardiavale.codserv, guardiavale.codmed, " + ;
			"nroregistrac, guardia.usuario,ptovta, tpocte,nrocte,letracte, nroregistracio "+;
			" ,VAL_fechasolicitud,VAL_codvaleasist," + ;
			" VAL_prestador ,VAL_codservvale, VAL_bono  " + ;
			"from afiliacion,prestacions,valesasist,presinsuvas,guardia "+;
			"left outer join entidades 		on guardia.codent				= entidades.ENT_codent " + ;
			"left outer join  especialid 	on prestacions.PRE_especialidad = especialid.ESP_codesp " + ;
			"left outer join  registracio 	on guardia.nroregistrac 		= registracio.REG_nroregistrac " + ;
			"left outer join guardiavale 	on guardia.protocolo 			= guardiavale.protocolo " + ;
			"left outer join prestadores 	on guardiavale.codmed 			= prestadores.id " + ;
			"left outer join tabfacturas 	on tabfacturas.codpun 			= valesasist.VAL_codpun " +;
			"where " + ;
			" guardiavale.nrovale = VAL_codvaleasist and "+;
			" presinsuvas.PIA_valesasist = VAL_codpun and "+;
			" pia_codprest = prestacions.PRE_codprest and "+;
			"guardia.nroregistrac = afiliacion.registracio and " + ;
			"guardia.codent = afiliacion.AFI_codentidad and " + ;
			"guardiavale.codserv in ( 8000,2150,5800,6500,9600) and " + ;
			"guardia.fechahoraing >= ?mf1 and " + ;
			"guardia.fechahoraing < ?mf2 "+mbuscog , "mwkguardia01")
		if mret<1
			=aerr(eros)
			messagebox(eros(3))
		endif
		if used("mwkMedicogua01" )
			select protocolo, fechahoraing, REG_nombrepac, ;
				iif(isnull(mwkguardia01.nombre),mwkMedicogua01.nombre,mwkguardia01.nombre) as nombre, codprest, ENT_descrient, ;
				PRE_descriprest, PRE_especialidad, fechahoraate, codestado, mwkguardia01.id,;
				prioridad,nrovale, REG_nrohclinica, REG_telefonos, REG_domicilio, AFI_nroafiliado, ;
				ESP_descripcion, codent,codserv, codmed, nroregistrac, usuario,;
				ptovta, tpocte,nrocte,letracte, nroregistracio ,VAL_fechasolicitud,VAL_codvaleasist, ;
				VAL_prestador ,VAL_codservvale, VAL_bono  ;
				from mwkguardia01 left join mwkMedicogua01 on codmed = mwkMedicogua01.id  ;
				group by fechahoraing ,protocolo,codserv,codprest,mwkguardia01.id,AFI_nroafiliado ;
				order by fechahoraing into cursor mwkguardia
		else
			select * from mwkguardia01 ;
				group by fechahoraing ,protocolo,codserv,codprest,mwkguardia01.id,AFI_nroafiliado ;
				order by fechahoraing into cursor mwkguardia
		endif
	endif
&&
endif
