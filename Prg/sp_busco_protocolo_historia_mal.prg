*****
** Busco Protocolo - Historia de Vales - Consumos
****

parameter mprotocolo
			

mret = sqlexec(mcon1, "select guardia.id, protocolo, REG_nombrepac, fechahoraing, fechahoraate, " + ;
	"nombre, diagnostico, codestado, pre_descriprest, pre_especialidad,codcie9, "+;
	"guardia.codmed,  codmedcie9,guardia.codprest,REG_nroregistrac, tipoest,REG_nrohclinica,"+;
	"reg_domicilio,reg_telefonos,reg_fecnacimiento,TPV_Estado,pre_codservicio,reg_sexo  " + ;
	"from guardia, prestacions,  prestadores,tabtipoaltas,registracio "+ ;
	" left outer join TabPacVip on registracio.REG_nroregistrac = TabPacVip.TPV_NroReg " + ;
	"where guardia.protocolo = ?mprotocolo and " + ;
	"guardia.nroregistrac	= registracio.REG_nroregistrac and " + ;
	"guardia.codmed			= prestadores.id and " + ;
	"guardia.codprest		= prestacions.pre_codprest and " + ;
	"guardia.codestado 		= tabtipoaltas.id and " + ;
	"guardia.codestado 		<> 0 union " +;
	"select guardia.id, protocolo, REG_nombrepac, fechahoraing, fechahoraate, " + ;
	"nombre, diagnostico, codestado, pre_descriprest, pre_especialidad, codcie9, "+;
	"guardia.codmed, codmedcie9,guardia.codprest,REG_nroregistrac, tipoest,REG_nrohclinica," + ;
	"reg_domicilio,reg_telefonos,reg_fecnacimiento,TPV_Estado,pre_codservicio,reg_sexo      " + ;
	"from guardia, prestacions, TabMedExterno,tabtipoaltas,registracio " + ;
	" left outer join TabPacVip on registracio.REG_nroregistrac = TabPacVip.TPV_NroReg " + ;
	"where guardia.protocolo = ?mprotocolo and " + ;
	"guardia.nroregistrac	= registracio.REG_nroregistrac and " + ;
	"guardia.codmed			= TabMedExterno.id and " + ;
	"guardia.codprest		= prestacions.pre_codprest and " + ;
	"guardia.codestado 		= tabtipoaltas.id and " + ;
	"guardia.codestado 		<> 0 order by fechahoraing " , "mwkveoproto")
if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16,"Validacion")
	messagebox(eros(3))
	DO sp_desconexion WITH "Err sp_busco_protocolo_historia"
	cancel
endif

mnroreg = mwkveoproto.REG_nroregistrac
mret = sqlexec(mcon1, "select * from TabGuaEvol "+;
	" where EG_nroregistrac = ?mnroreg ", "mwkguaevol" )


mret = sqlexec(mcon1, "select nrovale, ser_descripserv,val_operadorcarga,idusuario "+;
	", val_fechasolicitud,val_horasolicitud,val_medicosolicit,nombre,HIS_codentidad "+;
	"from guardiavale, servicios,histambgua ,valesasist " + ;
	" left join prestadores on valesasist.val_medicosolicit= prestadores.id "+;
	" left join tabusuario on valesasist.val_operadorcarga= tabusuario.codigovax "+;
	"where codserv  = ser_codserv and nrovale = VAL_codvaleasist and " + ;
	" HIS_nroregistrac= ?mnroreg and HIS_codadmision = VAL_codadmision  and "+;
	"protocolo 		= ?mprotocolo order by nrosec", "mwkvales")

if mret < 0
	=aerr(eros)
	messagebox(eros(3))
	DO sp_desconexion WITH "Err sp_busco_protocolo_historia"
	cancel
endif

mret = sqlexec(mcon1, "select nrovale, pia_codprest, pia_cantsolicitada,pre_descriprest,codserv "+;
	" from valesasist, presinsuvas, guardiavale,prestacions  " + ;
	" where valesasist.VAL_codpun  = presinsuvas.pia_valesasist and " + ;
	" pre_codprest = pia_codprest and nrovale = VAL_codvaleasist and codserv <> 5410 and " + ;
	" protocolo = ?mprotocolo ", "mwkvaldetp")

if mret < 0
	=aerr(eros)
	messagebox(eros(3))
	DO sp_desconexion WITH "Err sp_busco_protocolo_historia"
	cancel
endif
mret = sqlexec(mcon1, "select nrovale, pia_codprest, pia_cantsolicitada,INS_descriinsumo as pre_descriprest ,codserv "+;
	" from guardiavale,valesasist, presinsuvas, insumos " + ;
	" where protocolo = ?mprotocolo and nrovale = VAL_codvaleasist and "+;
	" valesasist.VAL_codpun  = presinsuvas.pia_valesasist and " + ;
	" pia_codinsumo = insumos and codserv = 5410 "  + ;
	"order by nrosec", "mwkvaldeti")
if mret < 0
	=aerr(eros)
	messagebox(eros(3))
	DO sp_desconexion WITH "Err sp_busco_protocolo_historia"
	cancel
endif
select * from mwkvaldetp ;
	union select nrovale, pia_codprest, pia_cantsolicitada,;
	left(pre_descriprest,45) as pre_descriprest,codserv  from mwkvaldeti ;
	into cursor mwkvaledet
