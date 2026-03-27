*****
** Busco Protocolo - Historia de Vales - Consumos
****

Parameter mprotocolo

mret = sqlexec(mcon1, "select tabambulatorio.*, REG_nombrepac, " + ;
	"nombre, pre_descriprest, pre_especialidad,pre_codservicio,"+;
	"REG_nroregistrac, tipoest,REG_nrohclinica,"+;
	"reg_domicilio,reg_telefonos,reg_fecnacimiento,reg_sexo," + ;
	"reg_localidad,reg_provincia,TPV_Estado "+;
	"from tabambulatorio "+;
	"join registracio  on registracio.REG_nroregistrac=tabambulatorio.nroregistrac "+;
	"join prestacions  on prestacions.pre_codprest=tabambulatorio.codprest "+;
	"join prestadores  on prestadores.id=tabambulatorio.codmed "+;
	"join tabtipoaltas on tabtipoaltas.id=tabambulatorio.codestado "+;
	"left outer join TabPacVip on TabPacVip.TPV_NroReg = registracio.REG_nroregistrac "+;
	"where tabambulatorio.protocolo = ?mprotocolo and tabambulatorio.codestado<>0", "mwkveoproto")

If mret < 0
	=aerr(eros)
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16,"Validacion")
	Messagebox(eros(3))
	Do sp_desconexion with "Err sp_busco_protocolo_historia"
	Cancel
Endif

mnroreg = mwkveoproto.REG_nroregistrac

mret = sqlexec(mcon1, "select * from TabAmbEvol "+;
	" where EA_nroregistrac = ?mnroreg ", "mwkambevol" )

If mret < 0
	=aerr(eros)
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16,"Validacion")
	Messagebox(eros(3))
	Do sp_desconexion with "Err sp_busco_protocolo_historia"
	Cancel
Endif

*!* 04/07/2011 Nuevo

mret = sqlexec(mcon1, "select nrovale, ser_descripserv,val_operadorcarga,"+;
	"idusuario,val_fechasolicitud,val_horasolicitud,val_medicosolicit,"+;
	"nombre,HIS_codentidad,pre_descriprest "+;
	" from tabambulatorio"+;
	" join valesasist on VAL_codvaleasist = tabambulatorio.nrovale"+;
	" join prestacions on PRE_codprest = tabambulatorio.codprest and PRE_codservicio=1130 "+;
	" join histambgua on HIS_codadmision = VAL_codadmision and HIS_nroregistrac = ?mnroreg"+;
	" join servicios  on ser_codserv = PRE_codservicio"+;
	" left join prestadores on valesasist.val_medicosolicit = prestadores.id"+;
	" left join tabusuario on tabusuario.codigovax = valesasist.val_operadorcarga"+;
	" where protocolo = ?mprotocolo order by nrovale","mwkvales")

If mret < 0
	=aerr(eros)
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16,"Validacion")
	Messagebox(eros(3))
	Do sp_desconexion with "Err sp_busco_protocolo_historia"
	Cancel
Endif

mret = sqlexec(mcon1, "select nrovale, pia_codprest, pia_cantsolicitada,"+;
	" INS_descriinsumo as pre_descriprest ,PRE_codservicio as codserv"+;
	" from tabambulatorio,valesasist, presinsuvas, insumos" + ;
	" join prestacions on PRE_codprest = tabambulatorio.codprest "+;
	" where protocolo = ?mprotocolo and nrovale = VAL_codvaleasist and"+;
	" valesasist.VAL_codpun  = presinsuvas.pia_valesasist and" + ;
	" pia_codinsumo = insumos"  + ;
	" order by nrovale", "mwkvaldetp")

*" join prestacions on PRE_codprest = tabambulatorio.codprest and PRE_codservicio = 1130"+;

If mret < 0
	=aerr(eros)
	Messagebox(eros(3))
	Do sp_desconexion with "Err sp_busco_protoamb_historia"
	Cancel
Endif

Select * from mwkvaldetp ;
	into cursor mwkvaledet
