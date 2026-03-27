****
** actualizo datos del retiro de estudio
****

parameter  mopcion, mprotocolo, mvalor
local mfechamod, musuario, mregistra, mobserva, mestado ,mesta(10)
store '' to mesta
mesta(1) = "Ret.Normal "
mesta(2) = "S/I.Medico "
mesta(3) = "Sin Compr. "
mesta(4) = "S/Com+S/In "
mesta(5) = "E.NO Realiz"
mesta(6) = ""
mesta(7) = "Ret.DKV/MIK"
mfechamod = sp_busco_fecha_serv('DT')
musuario = mwkusuario.idusuario
mregistra = mwkbuspacie1.reg_nroregistrac
mret = SQLExec(mcon1, "select tpestado,tpfecharetiro,tpobserva,tpprotocolo,tpregistrac,tpusuario "+;
	" from TabProtocolo " + ;
	" where tpprotocolo = ?mprotocolo  and  (tpregistrac = 0 or tpregistrac is null or tpregistrac = ?mregistra )  ", "mwkxproto")

mobserva = nvl(mwkxproto.tpobserva,'')
mestado = mwkxproto.tpestado


mret= sqlexec(mcon1,"select ID,tpestado,tpfecharetiro,tpobserva,tpprotocolo"+;
	",tpregistrac,tpusuario FROM TabProtocolo " +;
	" where tpprotocolo = ?mprotocolo ","mwkauxiprot")


if mopcion = 3  && es lectura
	mret= sqlexec(mcon1,"select FechaLog, TipoLog, Informeslog.Usuario,NroProtocolo"+;
		",tabestados.descrip,idusuario, TabUsuario.nomape as nombre "+;
		"FROM Informeslog,Informes,tabestados,tabusuario " +;
		" where IdInforme = Informes.ID and NroProtocolo = ?mprotocolo " + ;
		" and Informes.EstadoInforme < 5 and TipoLog = tabestados.estado "+;
		" and propietario = 10 and codigovax = Informeslog.Usuario "+;
		"group by tipolog ","mwkauxiinfo")
else

	if reccount("mwkauxiprot")=0
		do case
			case  mopcion= 1
				msql = " INSERT INTO TabProtocolo ( tpestado,tpobserva,tpfecharetiro,tpprotocolo,tpregistrac,tpusuario ) " +;
					" values ( ?mvalor ,'', ?mfechamod  ,?mprotocolo ,?mregistra  ,?musuario ) "
			case  mopcion= 2
				mob = separo(mvalor)
				msql = " INSERT INTO TabProtocolo ( tpestado,tpobserva,tpfecharetiro,tpprotocolo,tpregistrac,tpusuario ) " +;
					" values ( 1,"+mob+", ?mfechamod  ,?mprotocolo ,?mregistra  ,?musuario ) "
		endcase
		mret = sqlexec(mcon1,msql)
		if mret < 0
			messagebox('NO SE GUARDARON LOS DATOS. REINTENTELO', 16, 'Validacion')
		endif
	else
		mobserva = iif(mopcion= 2,mvalor , ttoc(mwkauxiprot.tpfecharetiro)+" "+;
			mesta(mwkauxiprot.tpestado)+ alltrim(mwkauxiprot.tpusuario) + " "+;
			alltrim(nvl(mline(mwkauxiprot.tpobserva,1),'')))+ chr(13) 
		mnuml = memlines(mwkauxiprot.tpobserva)
		for gg = 3-mopcion to mnuml
			mobserva = mobserva + alltrim(nvl(mline(mwkauxiprot.tpobserva,gg),''))+chr(13)
		next
		mob = separo(mobserva)
		msql = "Update TabProtocolo set "+ iif(mopcion= 1,"tpestado = ?mvalor , ","") +;
			"tpfecharetiro = ?mfechamod  ,tpusuario =?musuario,tpobserva="+mob+;
			" where tpprotocolo= ?mprotocolo "
		mret= sqlexec(mcon1, msql )

		if mret < 0
			messagebox('NO SE GUARDARON LOS DATOS. REINTENTELO', 16, 'Validacion')
			mret = 0
		endif

	endif

endif
function separo(miobserv)
local mtexto, mtexdos
if len(alltrim(miobserv))>250
	mtexto = left(alltrim(miobserv),250)
	mtexdos = substr(alltrim(miobserv),251,250)
else
	mtexto = alltrim(miobserv)
	mtexdos = ""
endif	
RETURN "{fn CONCAT('"+ mtexto+"','"+ mtexdos +"' )}"