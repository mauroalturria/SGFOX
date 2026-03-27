*!*	Gustavo Fittipaldi, 17/07/2012
*!*	V5 ULTIMA CONSULTA
*!*	-----------------------------------------------------------------------------------
*!*	Busco Protocolo - Historia de Vales - Consumos
*!*	-----------------------------------------------------------------------------------
Parameter mprotocolo,lhist
If Vartype(lhist)<>"N"
	lhist=0
Endif
lesguardia = .F.
mret = SQLExec(mcon1, "select tabambulatorio.*, REG_nombrepac, " + ;
	"nombre, pre_descriprest, pre_especialidad,pre_codservicio,"+;
	"REG_nroregistrac, tipoest,REG_nrohclinica,REG_tipodocumento,REG_numdocumento,"+;
	"reg_domicilio,reg_email,reg_telefonos,reg_fecnacimiento,reg_sexo,REG_cuit," + ;
	"reg_localidad,reg_provincia,TPV_Estado ,cast(1 as integer) as tipopac "+;
	"from tabambulatorio "+;
	"join registracio  on registracio.REG_nroregistrac=tabambulatorio.nroregistrac "+;
	"join prestacions  on prestacions.pre_codprest=tabambulatorio.codprest "+;
	"join prestadores  on prestadores.id=tabambulatorio.codmed "+;
	"join tabtipoaltas on tabtipoaltas.id=tabambulatorio.codestado "+;
	"left outer join TabPacVip on TabPacVip.TPV_NroReg = registracio.REG_nroregistrac "+;
	"where tabambulatorio.protocolo = ?mprotocolo and tabambulatorio.codestado<>0", "mwkveoproto")


If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16,"Validacion")
	Do sp_desconexion With "Err sp_busco_protocolo_historia"
	Cancel
	Return .F.
Endif
If  Reccount("mwkveoproto")=0 And lhist = 1
	mret = SQLExec(mcon1, "select tabambulatorio.*, REG_nombrepac, " + ;
		"nombre, pre_descriprest, pre_especialidad,pre_codservicio,"+;
		"REG_nroregistrac, tipoest,REG_nrohclinica,REG_tipodocumento,REG_numdocumento,"+;
		"reg_domicilio,reg_email,reg_telefonos,reg_fecnacimiento,reg_sexo,REG_cuit," + ;
		"reg_localidad,reg_provincia,TPV_Estado ,cast(1 as integer) as tipopac "+;
		"from tabambulatorioHIS AS tabambulatorio "+;
		"join registracio  on registracio.REG_nroregistrac=tabambulatorio.nroregistrac "+;
		"join prestacions  on prestacions.pre_codprest=tabambulatorio.codprest "+;
		"join prestadores  on prestadores.id=tabambulatorio.codmed "+;
		"join tabtipoaltas on tabtipoaltas.id=tabambulatorio.codestado "+;
		"left outer join TabPacVip on TabPacVip.TPV_NroReg = registracio.REG_nroregistrac "+;
		"where tabambulatorio.protocolo = ?mprotocolo and tabambulatorio.codestado<>0", "mwkveoproto")


	If mret <= 0
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16,"Validacion")
		Do sp_desconexion With "Err sp_busco_protocolo_historia"
		Cancel
		Return .F.
	Endif
Endif
If  Reccount("mwkveoproto")=0
	mret = SQLExec(mcon1, "select nrovale, ser_descripserv,val_operadorcarga,"+;
		"idusuario,val_fechasolicitud,val_horasolicitud,val_medicosolicit,val_codadmision,"+;
		"nombre,cob_codentidad as HIS_codentidad,pre_descriprest,val_codservvale  "+;
		" from tabambulatorio"+;
		" join valesasist on VAL_codvaleasist = tabambulatorio.nrovale"+;
		" join prestacions on PRE_codprest = tabambulatorio.codprest "+;
		" join coberturas on cob_pacientes= VAL_codadmision "+;
		" join servicios  on ser_codserv = PRE_codservicio"+;
		" left join prestadores on valesasist.val_medicosolicit = prestadores.id"+;
		" left join tabusuario on tabusuario.codigovax = valesasist.val_operadorcarga"+;
		" where protocolo = ?mprotocolo order by nrovale","mwkvales")
	If mret <= 0
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16,"Validacion")
		Do sp_desconexion With "Err sp_busco_protocolo_historia"
		Cancel
		Return .F.
	Endif

	If  Reccount("mwkvales")=0 And lhist = 1
		mret = SQLExec(mcon1, "select nrovale, ser_descripserv,val_operadorcarga,"+;
			"idusuario,val_fechasolicitud,val_horasolicitud,val_medicosolicit,val_codadmision,"+;
			"nombre,cob_codentidad as HIS_codentidad,pre_descriprest,val_codservvale  "+;
			" from tabambulatorioHIS AS tabambulatorio"+;
			" join valesasist on VAL_codvaleasist = tabambulatorio.nrovale"+;
			" join prestacions on PRE_codprest = tabambulatorio.codprest "+;
			" join coberturas on cob_pacientes= VAL_codadmision "+;
			" join servicios  on ser_codserv = PRE_codservicio"+;
			" left join prestadores on valesasist.val_medicosolicit = prestadores.id"+;
			" left join tabusuario on tabusuario.codigovax = valesasist.val_operadorcarga"+;
			" where protocolo = ?mprotocolo order by nrovale","mwkvales")
		If mret <= 0
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16,"Validacion")
			Do sp_desconexion With "Err sp_busco_protocolo_historia"
			Cancel
			Return .F.
		Endif
	Endif
Endif
If  Reccount("mwkveoproto")=0
	If  Reccount("mwkvales")=0
		mret = SQLExec(mcon1, "select guardia.*, REG_nombrepac, " + ;
			"nombre, pre_descriprest, pre_especialidad,pre_codservicio,"+;
			"REG_nroregistrac, tipoest,REG_nrohclinica,REG_tipodocumento,REG_numdocumento,"+;
			"reg_domicilio,REG_email,reg_telefonos,reg_fecnacimiento,reg_sexo,REG_cuit," + ;
			"reg_localidad,reg_provincia,TPV_Estado,cast(0 as integer) as tipopac  "+;
			"from guardia "+;
			"join registracio  on registracio.REG_nroregistrac=guardia.nroregistrac "+;
			"join prestacions  on prestacions.pre_codprest=guardia.codprest "+;
			"join prestadores  on prestadores.id=guardia.codmed "+;
			"join tabtipoaltas on tabtipoaltas.id=guardia.codestado "+;
			"left outer join TabPacVip on TabPacVip.TPV_NroReg = registracio.REG_nroregistrac "+;
			"where guardia.protocolo = ?mprotocolo ", "mwkveoproto")
		lesguardia = .T.
		If mret <= 0
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16,"Validacion")
			Do sp_desconexion With "Err sp_busco_protocolo_historia"
			Cancel
			Return .F.
		Endif
		If  Reccount("mwkveoproto")=0
			mret = SQLExec(mcon1, "select guardia.*, REG_nombrepac, " + ;
				"nombre, pre_descriprest, pre_especialidad,pre_codservicio,"+;
				"REG_nroregistrac, tipoest,REG_nrohclinica,REG_tipodocumento,REG_numdocumento,"+;
				"reg_domicilio,REG_email,reg_telefonos,reg_fecnacimiento,reg_sexo,REG_cuit," + ;
				"reg_localidad,reg_provincia,TPV_Estado,cast(0 as integer) as tipopac  "+;
				"from guardia "+;
				"join registracio  on registracio.REG_nroregistrac=guardia.nroregistrac "+;
				"join prestacions  on prestacions.pre_codprest=guardia.codprest "+;
				"join tabmedexterno  on tabmedexterno.id=guardia.codmed "+;
				"join tabtipoaltas on tabtipoaltas.id=guardia.codestado "+;
				"left outer join TabPacVip on TabPacVip.TPV_NroReg = registracio.REG_nroregistrac "+;
				"where guardia.protocolo = ?mprotocolo ", "mwkveoproto")
			lesguardia = .T.
			If mret <= 0
				Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16,"Validacion")
				Do sp_desconexion With "Err sp_busco_protocolo_historia"
				Cancel
				Return .F.
			Endif
		Endif
	Endif
Endif
mnroreg = mwkveoproto.REG_nroregistrac

*!*	-----------------------------------------------------------------------------------
mret = SQLExec(mcon1, "select * from TabAmbEvol "+;
	" where EA_nroregistrac = ?mnroreg and ea_protocolo = ?mprotocolo ", "mwkambevol" )

If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16,"Validacion")
	Do sp_desconexion With "Err sp_busco_protocolo_historia"
	Cancel
	Return .F.
Endif


*!*	-----------------------------------------------------------------------------------
*!* 04/07/2011 Nuevo
If lesguardia
	mret = SQLExec(mcon1, "select nrovale, ser_descripserv,val_operadorcarga,"+;
		"idusuario,val_fechasolicitud,val_horasolicitud,val_medicosolicit,val_codadmision,"+;
		"nombre,HIS_codentidad,pre_descriprest,val_codservvale  "+;
		IIF(lesguardia,",cast(1 as integer) as tipopac ",",cast(0 as integer) as tipopac ")+;
		" from guardia  "+;
		" join GuardiaVale ON(GuardiaVale.protocolo = guardia.protocolo and GuardiaVale.codserv =8000) "+;
		" join valesasist on VAL_codvaleasist = GuardiaVale.nrovale"+;
		" join prestacions on PRE_codprest = guardia.codprest "+;
		" join histambgua on HIS_codadmision = VAL_codadmision and HIS_nroregistrac = ?mnroreg"+;
		" join servicios  on ser_codserv = PRE_codservicio"+;
		" left join prestadores on valesasist.val_medicosolicit = prestadores.id"+;
		" left join tabusuario on tabusuario.codigovax = valesasist.val_operadorcarga"+;
		" where guardia.protocolo = ?mprotocolo order by nrovale","mwkvales")

Else
	mret = SQLExec(mcon1, "select nrovale, ser_descripserv,val_operadorcarga,"+;
		"idusuario,val_fechasolicitud,val_horasolicitud,val_medicosolicit,val_codadmision,"+;
		"nombre,HIS_codentidad,pre_descriprest,val_codservvale  "+;
		IIF(lesguardia,",cast(1 as integer) as tipopac ",",cast(0 as integer) as tipopac ")+;
		" from tabambulatorio"+;
		" join valesasist on VAL_codvaleasist = tabambulatorio.nrovale"+;
		" join prestacions on PRE_codprest = tabambulatorio.codprest "+;
		" join histambgua on HIS_codadmision = VAL_codadmision and HIS_nroregistrac = tabambulatorio.nroregistrac "+;
		" join servicios  on ser_codserv = PRE_codservicio"+;
		" left join prestadores on valesasist.val_medicosolicit = prestadores.id"+;
		" left join tabusuario on tabusuario.codigovax = valesasist.val_operadorcarga"+;
		" where protocolo = ?mprotocolo order by nrovale","mwkvales")


Endif
If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16,"Validacion")
	Do sp_desconexion With "Err sp_busco_protocolo_historia"
	Cancel
	Return .F.
Endif
*!*	-----------------------------------------------------------------------------------

Select * ;
	From mwkvales Where 1 = 2 ;
	into Cursor mwkvaledet
