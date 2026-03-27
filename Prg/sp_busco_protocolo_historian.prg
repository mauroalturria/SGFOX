*****
** Busco Protocolo - Historia de Vales - Consumos
****

parameter mprotocolo

mret = sqlexec(mcon1, "select guardia.id, protocolo, REG_nombrepac, fechahoraing, fechahoraate, " + ;
	"nombre, diagnostico, codestado, pre_descriprest, codcie9, guardia.codmed, codmedcie9,REG_nroregistrac " + ;
	"from guardia, prestacions, registracio, prestadores " + ;
	"where guardia.protocolo = ?mprotocolo and " + ;
	"guardia.nroregistrac	= registracio.REG_nroregistrac and " + ;
	"guardia.codmed			= prestadores.id and " + ;
	"guardia.codprest		= prestacions.pre_codprest and " + ;
	"guardia.codestado 		<> 0 union " +;
	"select guardia.id, protocolo, REG_nombrepac, fechahoraing, fechahoraate, " + ;
	"nombre, diagnostico, codestado, pre_descriprest, codcie9, guardia.codmed, codmedcie9,REG_nroregistrac " + ;
	"from guardia, prestacions, registracio, TabMedExterno " + ;
	"where guardia.protocolo = ?mprotocolo and " + ;
	"guardia.nroregistrac	= registracio.REG_nroregistrac and " + ;
	"guardia.codmed			= TabMedExterno.id and " + ;
	"guardia.codprest		= prestacions.pre_codprest and " + ;
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
	"from guardiavale, servicios,valesasist " + ;
	" left join tabusuario on val_operadorcarga=codigovax "+;
	"where codserv  = ser_codserv and nrovale = VAL_codvaleasist and " + ;
	"protocolo 		= ?mprotocolo order by nrosec", "mwkvales")

if mret < 0
	=aerr(eros)
	messagebox(eros(3))
	DO sp_desconexion WITH "Err sp_busco_protocolo_historia"
	cancel
endif

mret = sqlexec(mcon1, "select nrovale, pia_codprest, pia_cantsolicitada,pre_descriprest "+;
	" from guardiavale, presinsuvas, prestacions " + ;
	" where nrovale = pia_valesasist and codserv	<> 5410 and pre_codprest = pia_codprest" + ;
	" and protocolo = ?mprotocolo ", "mwkvaldetp")
if mret < 0
	=aerr(eros)
	messagebox(eros(3))
	DO sp_desconexion WITH "Err sp_busco_protocolo_historia"
	cancel
endif
mret = sqlexec(mcon1, "select nrovale, pia_codprest, pia_cantsolicitada,INS_descriinsumo as pre_descriprest "+;
	" from guardiavale, presinsuvas, insumos " + ;
	" where nrovale = pia_valesasist and codserv	= 5410 and pia_codinsumo = insumos " + ;
	" and protocolo = ?mprotocolo "+;
	"order by nrosec", "mwkvaldeti")
if mret < 0
	=aerr(eros)
	messagebox(eros(3))
	DO sp_desconexion WITH "Err sp_busco_protocolo_historia"
	cancel
endif
select * from mwkvaldetp ;
	union select nrovale, pia_codprest, pia_cantsolicitada,;
	left(pre_descriprest,45) as pre_descriprest  from mwkvaldeti ;
	into cursor mwkvaledet
