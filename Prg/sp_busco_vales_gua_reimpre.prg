****
** busca los protocolo de guardia para la grilla
****
parameter mfecha1,mfecha2

mfechactr = sp_busco_fecha_serv('DT')
mfecha = mfecha1
mfechaobs = mfechactr - 14400  && 4 horas
mf1 = prg_dtoc(mfecha1)
mf2 = prg_dtoc(mfecha2)

mret = SQLExec(mcon1,"SELECT ID , nombre FROM TabMedExterno where gerenciadora = 0 ", "mwkMedicogua01" )
mret = SQLExec(mcon1, "select TGM_protocolo ,TGM_Fechah , TGM_estado , TGM_mensaje , TGM_usuario  " + ;
	" from TabGuaMsg " + ;
	" where TGM_Fechah >= ?mfecha and TGM_estado <> 9 and TGM_codmed = 1 " + ;
	" ", "mwkprotomsg0")
	Do sp_busco_pac_internados_red With  ,"mwkpacact"
select * from mwkprotomsg0 order by TGM_protocolo,TGM_Fechah group by TGM_protocolo  into cursor mwkprotomsg

mserv = " pia_codprest = codprest and val_codservvale = 8000 and "
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
	"guardia.fechahoraing < ?mf2 "+;
	" order by fechahoraing desc", "mwkguardia01")


if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif
if used("mwkMedicogua01" )
	select protocolo, fechahoraing, REG_nombrepac, ;
		iif(isnull(mwkguardia01.nombre) or (empty(mwkguardia01.nombre) and codmed>1),mwkMedicogua01.nombre,mwkguardia01.nombre) as nombre, ;
		descrip,codprest, ENT_descrient, PRE_descriprest, PRE_especialidad, fechahoraate, codestado, mwkguardia01.id,;
		prioridad,nrovale, REG_nrohclinica, REG_telefonos, REG_domicilio, ;
		ESP_descripcion, codent,codserv, codmed,tipoest, val_operadorcarga,  ;
		nroregistrac,reg_numdocumento,descripcion,AFI_nroafiliado,fechamodif,mwkpacact.PAC_codadmision    ;
		from mwkguardia01 left join mwkMedicogua01 on codmed = mwkMedicogua01.id  ;
		left join mwkciap2e on mwkciap2e.id = codcie9 ;
		left join mwkpacact ON nroregistrac = mwkpacact.pac_codhci ;
		group by protocolo ;
		order by fechahoraing into cursor mwkguardia
else
	select * from mwkguardia01 ;
		group by protocolo;
		order by fechahoraing into cursor mwkguardia
endif

