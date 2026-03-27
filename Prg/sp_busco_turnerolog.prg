Parameters mTipo,tdFecha,tHFecha,lcIpSvr  

mTipo = Iif(Vartype(mTipo) <> "N",1,mTipo)
tdFecha = IIF(VARTYPE(tdFecha) <> "D",sp_busco_fecha_serv('DD'),tdFecha)
tHFecha = IIF(VARTYPE(tHFecha) <> "D",tdFecha,tHFecha) + 1

tdFecha = prg_dtoc(tdFecha)
tHFecha = prg_dtoc(tHFecha)

If Vartype(lcIpSvr)<> "C"
	lcSql = "select * from TabLlamaIp where LLA_Ippuesto = ?MyIp "
	if !prg_EjecutoSql(lcSql,"MwkIpLla")
	    return
	endif

	if reccount("MwkIpLla") = 0
	    messagebox("NO ESTA CONFIGURADO EL LLAMADOR",48,"VALIDACION")
	    return .f.
	endif

	select MwkIpLla
	go top
	lcIpSvr = MwkIpLla.Lla_ipserver
Endif 

If mTipo = 1   &&filtro para la primera solapa.
	lcSql = "SELECT TNL_Numerador, TABTURNEROLOG.Id, " + ;
		"TABTURNEROLOG.TNL_Tipo, TABTURNEROLOG.TNL_numdocumento, TABTURNEROLOG.TNL_FechaHoraIng, " + ;
		"TabLlamador.LLA_FechaSol, TabLlamador.LLA_FechaPant, " + ;
		"cast(TabLlamador.LLA_FechaPant as time) as p, " + ;
		"cast(TABTURNEROLOG.TNL_FechaHoraIng as time) as p1, " + ;
		"(cast(TabLlamador.LLA_FechaPant as time) - cast(TABTURNEROLOG.TNL_FechaHoraIng as time)) / 60 as dif, tABTURNEROLOG.Tnl_IdLlama " + ;
		"FROM TABTURNEROLOG " + ;
		"left join TabLlamador on TabLlamador.Id = TABTURNEROLOG.Tnl_IdLlama " + ;
		"Where TABTURNEROLOG.TNL_FechaHoraIng  >= ?tdFecha and TABTURNEROLOG.TNL_FechaHoraIng < ?tHFecha and (TABTURNEROLOG.Tnl_IdLlama is null) " + ;
		" AND TNL_IPSERVER = ?lcIpSvr " + ;
		"Order by TABTURNEROLOG.id desc "

	If!Prg_EjecutoSql(lcSql,"mwkTurnerolog",.F.)
		Return .F.
	Endif
Endif

If mTipo = 2   &&filtra para hacer estadistica (segunda solapa.)

*	Set Step On
	
	lcSql = "select tnl_fechahoraing,tnl_numerador,tnl_tipo,lla_fechasol,lla_ipmaquina,tnl_codigovax,tabusuario.idusuario,tabusuario.nomape " +;
		"from tabturnerolog " +;
		"inner join TabLlamador on TabLlamador.Id = TABTURNEROLOG.Tnl_IdLlama " + ;
		"left join tabusuario on tnl_codigovax = tabusuario.codigovax " + ;
		"where " + ;
 		"Exists(select 1 from tabturnerolog where tnl_fechahoraing >= ?tdFecha And tnl_fechahoraing < ?tHFecha " + ;
			" AND TNL_IPSERVER in ( " + lcIpSvr + ") )" + ;
 		" and tnl_fechahoraing >= ?tdFecha And tnl_fechahoraing < ?tHFecha " + ;
		" AND TNL_IPSERVER IN ( " + lcIpSvr  + ")" 

	If!Prg_EjecutoSql(lcSql,"mwkTurnerolog2",.F.)
		Return .F.
	Endif
Endif

If mTipo = 3   && como el 1 pero con turnum
	lcSql = "SELECT TNL_Numerador, TABTURNEROLOG.Id, " + ;
		"TABTURNEROLOG.TNL_Tipo, TABTURNEROLOG.TNL_numdocumento, TABTURNEROLOG.TNL_FechaHoraIng, " + ;
		"TabLlamador.LLA_FechaSol, TabLlamador.LLA_FechaPant, " + ;
		"cast(TabLlamador.LLA_FechaPant as time) as p, " + ;
		"cast(TABTURNEROLOG.TNL_FechaHoraIng as time) as p1, " + ;
		"(cast(TabLlamador.LLA_FechaPant as time) - cast(TABTURNEROLOG.TNL_FechaHoraIng as time)) / 60 as dif, tABTURNEROLOG.Tnl_IdLlama, " + ;
		" TabTurNum.Tun_Descrip " + ; 
		"FROM TABTURNEROLOG " + ;
		"left join TabLlamador on TabLlamador.Id = TABTURNEROLOG.Tnl_IdLlama " + ;
		"inner join (select * from TabTurNum where tun_fecpasiva = '1900-01-01') as TabTurNum  on Trim(tun_letra) = Trim(Tnl_Tipo) " + ;
		"Where TABTURNEROLOG.TNL_FechaHoraIng  >= ?tdFecha and TABTURNEROLOG.TNL_FechaHoraIng < ?tHFecha and (TABTURNEROLOG.Tnl_IdLlama is null) " + ;
		" AND TNL_IPSERVER in ( " + lcIpSvr + " )"  + ;
		"Order by TABTURNEROLOG.id desc "

	If!Prg_EjecutoSql(lcSql,"mwkTurnerolog",.F.)
		Return .F.
	Endif
Endif