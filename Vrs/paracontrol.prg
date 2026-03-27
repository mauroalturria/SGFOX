mfecha1  = date()-1
mfecha2  = date()-1
mtodos = 0
mbuscog = ''
* En sp_busco_planilla_guardia ( Case mcual = 3 && Planilla desde hasta fecha )

	mf1     = prg_dtoc( mfecha1 )
	mf2     = prg_dtoc( mfecha2 + 1 )
	
mserv = iif(mtodos=1," val_codservvale <> 5410 and ",;
	" pia_codprest = codprest and val_codservvale in ( 8000,2150,6500,9600 ) and " )
mitime = seconds()
	mret = SQLExec(mcon1, "select guardia.protocolo, fechahoraing, REG_nombrepac," + ;
		" nombre, codprest, ent_descrient, pre_descriprest, " + ;
		" pre_especialidad, fechahoraate, codestado, guardia.id," + ;
		" prioridad,guardiavale.nrovale, reg_nrohclinica,pia_codprest," + ;
		" reg_telefonos, reg_domicilio, afi_nroafiliado," + ;
		" esp_descripcion, guardia.codent,guardiavale.codserv, guardia.codmed, " + ;
		"nroregistrac, guardia.usuario,ptovta, tpocte,nrocte,letracte, fechacte,nroregistracio "+;
		" ,val_horasolicitud,val_fechasolicitud,val_codvaleasist,tipoest,descrip," + ;
		" val_prestador ,val_codservvale, val_bono,reg_numdocumento, pia_cantsolicitada,"+;
		"guardiavale.diagnostico,TabCiap2E.DescrAbrev as descie " + ;
		"from afiliacion,prestacions,valesasist,presinsuvas,tabtipoaltas,guardia "+;
		"left outer join entidades 		on guardia.codent				= entidades.ent_codent " + ;
		"left outer join especialid 	on prestacions.pre_especialidad = especialid.esp_codesp " + ;
		"left outer join registracio 	on guardia.nroregistrac 		= registracio.reg_nroregistrac " + ;
		"left outer join guardiavale 	on guardia.protocolo 			= guardiavale.protocolo " + ;
		"left outer join prestadores 	on guardia.codmed 				= prestadores.id " + ;
		"left outer join tabfacturas 	on tabfacturas.codpun 			= valesasist.val_codpun " +;
		"left outer join TabCiap2E      on TabCiap2E.Id                 = guardia.codcie9 "+;
		"where " + ;
		" guardiavale.nrovale = val_codvaleasist and "+;
		" presinsuvas.pia_valesasist = val_codpun and "+;
		" pia_codprest = prestacions.pre_codprest and "+;
		" guardia.codestado = tabtipoaltas.id and " + ;
		"guardia.nroregistrac = afiliacion.registracio and " + ;
		"guardia.codent = afiliacion.afi_codentidad and " + mserv +;
		"guardia.fechahoraing >= ?mf1 and " + ;
		"guardia.fechahoraing < ?mf2 " + mbuscog , "mwkguardia00")

mitimea = seconds()-mitime 
messagebox(transf(mitimea ))
*!* Probado en el 1.248	

	mserv = iif(mtodos=1," val_codservvale <> 5410 and ",;
	"  val_codservvale in ( 8000,2150,6500,9600 ) " )
mitime = seconds()
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
mitimea = seconds()-mitime 
messagebox(transf(mitimea ))
