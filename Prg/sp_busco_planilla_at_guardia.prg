****
** busca los protocolo de guardia para la grilla
****
parameter mcual,mfecha1,mfecha2,mbuscog,mbuscov,mtodos,mesta

if vartype (mtodos)#"N"
	mtodos = 0
endif
if vartype (mbuscog)#"C"
	mbuscog = ''
endif
if type ('mbuscov')#"C"
	mbuscov = ''
endif
mfechactr = sp_busco_fecha_serv('DT')
if type("mfecha1")="T"
	mfecha = mfecha1
else
	mfecha = mfechactr - 86400  && 57600 && 16hs   &&  86400  &&  24hs
endif

*!*	if vartype(mfecha2)#"T"
*!*		mfecha2 = ttod(mfechactr )
*!*	endif

if !inlist(type("mfecha2"),"T","D")
	mfecha2 = ttod(mfechactr)
endif

mfechaobs = mfechactr - 14400  && 4 horas
mf1 = prg_dtoc(mfecha1)
mf2 = prg_dtoc(mfecha2+1)

mret = SQLExec(mcon1,"SELECT ID , nombre FROM TabMedExterno where gerenciadora = 0 ", "mwkMedicogua01" )
	mitime = seconds()
	if mcual = 3  && si es desde hasta
		mret = SQLExec(mcon1, "select TGM_protocolo,TGM_Fechah , TGM_estado , TGM_mensaje , TGM_usuario  " + ;
			" from TabGuaMsg " + ;
			" where TGM_Fechah >= ?mf1 and TGM_Fechah< ?mf2 and TGM_estado <> 9 and TGM_codmed = 1 " + ;
			" ", "mwkprotomsg0")
	else
		mret = SQLExec(mcon1, "select TGM_protocolo ,TGM_Fechah , TGM_estado , TGM_mensaje , TGM_usuario  " + ;
			" from TabGuaMsg " + ;
			" where TGM_Fechah >= ?mfecha and TGM_estado <> 9 and TGM_codmed = 1 " + ;
			" ", "mwkprotomsg0")
	endif
	mitime2 = seconds()
*	messagebox(transfor(mitime2-mitime))
	select * from mwkprotomsg0 order by TGM_protocolo,TGM_Fechah group by TGM_protocolo  into cursor mwkprotomsg

horactr = val(left(ttoc(mfechactr,2),2))
mserv = iif(mtodos=1,' val_codservvale<> 5410 and ',"pia_codprest = codprest and val_codservvale in ( 8000,2150,6500,9600 ) and " )
mret = SQLExec(mcon1, "select guardia.protocolo, fechahoraing, REG_nombrepac," + ;
	" prestadores.nombre, codprest, ent_descrient, pre_descriprest, " + ;
	" pre_especialidad, fechahoraate, codestado, guardia.id," + ;
	" prioridad,guardiavale.nrovale, reg_nrohclinica,pia_codprest," + ;
	" reg_telefonos, reg_domicilio, afi_nroafiliado,afi_idplan,reg_fecnacimiento,reg_sexo,reg_email," + ;
	" esp_descripcion, guardia.codent,guardiavale.codserv, guardia.codmed, " + ;
	"nroregistrac, guardia.usuario,ptovta, tpocte,nrocte,letracte, fechacte,nroregistracio "+;
	" ,val_horasolicitud,val_fechasolicitud,val_codvaleasist,tipoest,sector,descrip," + ;
	" val_prestador ,val_codservvale, val_bono,reg_numdocumento, pia_cantsolicitada,"+;
	"guardiavale.diagnostico,guardia.diagnostico as codadmision,TabCiap2E.descripcion as descie,val_operadorcarga  " + ;
	",Tabguaevol.EG_horaCierre ,Tabguaevol.EG_parFreCard,Tabguaevol.EG_parotros,codmedcie9,prestadoresb.nombre as nombreb "+;
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

if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif
if used("mwkMedicogua01" )
	select protocolo, fechahoraing, REG_nombrepac, ;
		iif(isnull(mwkguardia01.nombre) or (empty(mwkguardia01.nombre) and codmed>1),mwkMedicogua01a.nombre,mwkguardia01.nombre) as nombre, ;
		iif(isnull(mwkguardia01.nombreb) or (empty(mwkguardia01.nombreb) and codmed>1),mwkMedicogua01b.nombre,mwkguardia01.nombreb) as nombreb, ;
		codprest, ENT_descrient, ;
		PRE_descriprest, PRE_especialidad, fechahoraate, codestado, mwkguardia01.id,;
		prioridad,nrovale, reg_telefonos, reg_domicilio, afi_nroafiliado,afi_idplan,reg_fecnacimiento,reg_sexo,reg_email,REG_numdocumento,;
		ESP_descripcion, codent,codserv, codmed, nroregistrac, usuario,pia_codprest,;
		ptovta, tpocte,nrocte,letracte, nroregistracio ,val_horasolicitud,val_fechasolicitud,val_codvaleasist, ;
		val_prestador ,val_codservvale, val_bono,tipoest,sector,descrip,;
		pia_cantsolicitada,diagnostico,codadmision,descie,fechacte,val_operadorcarga,EG_horaCierre ,EG_parFreCard ,EG_parotros,codmedcie9    ;
		,reg_nrohclinica,mwkprotomsg.* ;
		from mwkguardia01 left join mwkMedicogua01 mwkMedicogua01a on codmed = mwkMedicogua01a.id  ;
		left join mwkMedicogua01 mwkMedicogua01b on codmedcie9 = mwkMedicogua01b.id  ;
		left join mwkprotomsg on protocolo = TGM_protocolo  ;
		group by nrovale,pia_codprest;
		order by fechahoraing into cursor mwkguardia
else
	select * from mwkguardia01 ;
		group by nrovale,pia_codprest;
		order by fechahoraing into cursor mwkguardia
endif
