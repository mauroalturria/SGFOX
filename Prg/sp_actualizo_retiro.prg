****
** actualizo datos del retiro de estudio
****

parameter  mopcion, mprotocolo, mvalor, mlobserva,mxnroreg,mnrovale
&& opcion 5 retiro sin estudios desde vale
local mfechamod, musuario, mregistra, mobserva, mestado ,mesta(10)

store '' to mesta

*!* ---------------------AGREGADO POR SOLER 16/07/2013-----------------------------
*!*SI BUSCA POR VALE,HAY QUE OBTENER EL NÚMERO DE PROTOCOLO OBLIGATORIAMENTE

if  mopcion=0
	mnrovale = iif(vartype(mnrovale)#"N",mprotocolo,mnrovale )
	mret=SQLExec(mcon1,"select VAL_NROPROTOCOLO from valesasist where val_codvaleasist=?mnrovale ","mwkvaleas")
	mprotocolo=mwkvaleas.VAL_NROPROTOCOLO
	mopcion=3
	use in mwkvaleas
endif
mreg = 0
if vartype(mxnroreg)="N"
	mreg = mxnroreg
endif
mret = SQLExec(mcon1, "select * from TabProtocolo " + ;
	" where tpprotocolo = ?mprotocolo  and  (tpregistrac = 0 or tpregistrac is null or tpregistrac = ?mreg)  ", "mwkauxiprot")

*!*----------------CONTINÚA CÓDIGO ORIGINAL------------------------------------------

if vartype(mlobserva)#"C"
	mlobserva = ''
endif

mesta(1) = "Ret.Normal "
mesta(2) = "S/I.Medico "
mesta(3) = "Sin Compr. "
mesta(4) = "S/Com+S/In "
mesta(5) = "E.NO Realiz"
mesta(6) = ""
mesta(7) = "E.a Repetir"
mesta(8) = "Adj.Est.Ant"
mesta(9)  = "Recepcion  "
mesta(10) = "Post.Ret.In"

mfechamod = sp_busco_fecha_serv('DT')
musuario  = mwkusuario.idusuario

if vartype(mvalor)="N"
	if mvalor = 6
		if vartype(mxnroreg)="N"
			mregistra = mxnroreg
		else
			mregistra = mwkbuspacie1.reg_nroregistrac
		endif
		mobserva  = mlobserva
		mestado   = mvalor
	else
		if len(alltrim(mlobserva))>0
			if vartype(mxnroreg)="N"
				mregistra = mxnroreg
			else
				mregistra = mwkInformes02.PAC_codhci
			endif
		else
			if vartype(mxnroreg)="N"
				mregistra = mxnroreg
			else
				mregistra = mwkbuspacie1.reg_nroregistrac
			endif
			mobserva  = iif(mopcion=5,'',nvl(mwkauxiprot.tpobserva,''))
			mestado   = iif(mopcion=5,0,mwkauxiprot.tpestado)
		endif
	endif
else
	if len(alltrim(mlobserva))>0
		if used('mwkInformes02')
			if vartype(mxnroreg)="N"
				mregistra = mxnroreg
			else
				mregistra = mwkInformes02.PAC_codhci
			endif
		else
			if vartype(mxnroreg)="N"
				mregistra = mxnroreg
			else
				mregistra = mwkbuspacie1.reg_nroregistrac
			endif
		endif
	else
		mregistra = mwkbuspacie1.reg_nroregistrac
		mobserva  = iif(mopcion=5,'',nvl(mwkauxiprot.tpobserva,''))
		mestado   = iif(mopcion=5,0,mwkauxiprot.tpestado)
	endif
endif

if mopcion = 3  && es lectura con proto
	if mprotocolo >0
		mret= SQLExec(mcon1,"select Informeslog.FechaLog, Informeslog.TipoLog,Informeslog.Usuario,NroProtocolo,"+;
			" tabestados.descrip,idusuario,Informeslog.idinforme,Informes.tipoarch, Prestadores.Nombre "+;
			" FROM Informes,tabusuario,Informeslog " +;
			" Left join Prestadores on Informes.CodMedFirma = Prestadores.Id "+;
			" left join tabestados on TipoLog = tabestados.estado and propietario = 10 "+;
			" where IdInforme = Informes.ID and NroProtocolo = ?mprotocolo and Informes.nrovale = ?mnrovale  " + ;
			" and Informes.EstadoInforme < 5 and codigovax = Informeslog.Usuario and TipoLog < 6"+;
			" order by idinforme,FechaLog ","mwkauxiinfo")
		if mret<1
			return .f.
		endif
	endif
else
	if reccount("mwkauxiprot")=0
		do case
			case  inlist(mopcion,1,5)
				msql = " INSERT INTO TabProtocolo ( tpestado,tpobserva,tpfecharetiro,tpprotocolo,tpregistrac,tpusuario ) " +;
					" values ( ?mvalor , ?mlobserva, ?mfechamod  ,?mprotocolo ,?mregistra  ,?musuario ) "
			case  mopcion= 2
				mob = separo(mlobserva)
				msql = " INSERT INTO TabProtocolo ( tpestado,tpobserva,tpfecharetiro,tpprotocolo,tpregistrac,tpusuario ) " +;
					" values ( 1,"+mob+", ?mfechamod  ,?mprotocolo ,?mregistra  ,?musuario ) "
		endcase
		mret = SQLExec(mcon1,msql)
		if mret < 0
			messagebox('NO SE GUARDARON LOS DATOS. REINTENTELO', 16, 'Validacion')
		endif
	else
		do case
			case mopcion = 2
				mobserva = mlobserva

				mnuml = memlines(mwkauxiprot.tpobserva)
				for gg = 3-mopcion to mnuml
					mobserva = mobserva + alltrim(nvl(mline(mwkauxiprot.tpobserva,gg),''))+chr(13)
				next

			case mopcion = 4
				mobserva = mlobserva

			otherwise
				mobserva = ttoc(mwkauxiprot.tpfecharetiro)+" "+;
					mesta(mwkauxiprot.tpestado)+ " " + alltrim(mwkauxiprot.tpusuario) + " "+;
					alltrim(nvl(mline(mwkauxiprot.tpobserva,1),''))+ chr(13)

				mnuml = memlines(mwkauxiprot.tpobserva)
				for gg = 3-mopcion to mnuml
					mobserva = mobserva + alltrim(nvl(mline(mwkauxiprot.tpobserva,gg),''))+chr(13)
				next

		endcase

		mob = separo(mobserva)

		msql = "Update TabProtocolo set "+ iif(mopcion= 1,"tpestado = ?mvalor , ","") +;
			"tpfecharetiro = ?mfechamod  ,tpusuario =?musuario,tpobserva="+mob+;
			" where tpprotocolo= ?mprotocolo "

		mret= SQLExec(mcon1, msql )

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
	return "{fn CONCAT('"+ mtexto+"','"+ mtexdos +"' )}"
