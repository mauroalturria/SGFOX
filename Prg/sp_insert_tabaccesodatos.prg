****
** grabo un movimiento cuando Accede a Informacion sensible
****

parameter malgo,mquemed,mnroregis,msesion,mqueusu,mtipo,mproto,mnrovale

mtafecha 	= sp_busco_fecha_serv('DT')
mproto = iif(vartype(mproto)#"C",'',mproto)
mnrovale= iif(vartype(mnrovale)#"N",0,mnrovale)
mipc =  SYS(0)
mipc = left(left(mipc,at("#",mipc)-1)+STRTRAN(myip,'172.16.',''),20)
if mnroregis>0
	mret = sqlexec(mcon1, "insert into Tabaccesodatos( Codmed, FechaHora, IdUsuario, Registro, "+;
		"Sesion, TipoAcc, IpAcceso, protocolo,nrovale) "+;
		"values( ?mquemed, ?mtafecha , ?mqueusu, ?mnroregis, ?msesion, ?mtipo, ?mipc, ?mproto, ?mnrovale )")
	if mret<1
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		select mwkusuario
		go top
		midusua     = mwkusuario.idusuario
		merr1 = transf(malgo)+"+"+transf(mquemed)+"+"+transf(mnroregis)+"+"+transf(msesion)+"+"+transf(mqueusu)+"+"+transf(mtipo)+"+"+transf(mproto)
		do sp_insert_tabctrlerr with merr1, merr1 , midusua, mwkexe.nomexe
	*	set step on
	endif
endif