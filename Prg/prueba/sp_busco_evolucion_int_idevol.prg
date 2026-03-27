****
** Armo evolucion del paciente
****
parameter idevol,xctipo,mevol,lorden,xncantreg,copciones,mtipousu

if vartype(xctipo)#"C"
	xctipo = ""
endif
if vartype(mtipousu)#"N"
	mtipousu = 0
endif
if vartype(copciones)#"C"
	copciones = '' &&&"EISsVMCN"    N nutricion 
endif
mret = 1
mevol  = ''
miorden = " "
if vartype(lorden)="N"
	miorden = " desc "
endif
MRET = 0
if vartype(xncantreg) = "N"
	xcantreg = " top "+transform(xncantreg)+" "
else
	xcantreg = ''
endif
if !used('mwkMedicointall')
	do sp_busco_med_pisos &&  with sp_busco_fecha_serv("DD")
	select  id, nombre,codesp,matricula as matriculas  from mwkmedicoint where 1=2 into cursor mwkMedicouno
	use in select("mwksinmed")
	use dbf('mwkMedicouno') in 0 again alias mwksinmed
	select mwksinmed
	insert into mwksinmed (id, nombre,codesp,matriculas  ) values (1,"MEDICO INTERNACION","",0)
	select  id, nombre,codesp,matricula as matriculas  from mwkmedicoint union all;
		select * from mwksinmed into cursor mwkMedicointall
	use in select("mwksinmed")
	use in select("mwkMedicouno")
endif
if !used('mwkusuariosall')
	do sp_busco_usuarios_all WITH "PISOS"
endif

do case
	case xctipo = "SM"
		copciones = iif(empty(copciones),"Ss",copciones)
		mtipousu = 1
		if empty(xcantreg)

			mret = sqlexec(mcon1, "select EIS_fechaH ,EIS_idevol ,EIS_observacion , EIS_tiposcore ,EIS_usuario "+;
				",EIS_valor ,EIS_usuario->nomape,EIS_usuario->idcodmed as ucodmed from TabIntScorNur"+;
				" where EIS_idevol = ?midevol and EIS_fechaH>=?mevol order by EIS_tiposcore ,id "+miorden  , "mwkevolScore")

		else
			mret = sqlexec(mcon1, "select EIS_fechaH ,EIS_idevol ,EIS_observacion , EIS_tiposcore ,EIS_usuario "+;
				",EIS_valor ,EIS_usuario->nomape,EIS_usuario->idcodmed as ucodmed from TabIntScorNur"+;
				" inner join TabintHCE on  tabintHCE.id = TabIntScorNur.EIS_idevol " + ;
				" where tabintHCE.IH_admision = ?idevol and EIS_tiposcore = ?xncantreg and EIS_fechaH>=?mevol "+;
				" group by TabIntScorNur.id order by TabIntScorNur.id "+	miorden , "mwkevolScore")
		endif

	case xctipo = "ICK"
		mtipousu = 1
		if empty(xcantreg)
			mret = sqlexec(mcon1, "select  TabIntevolIC.*,EIC_usuario->nomape,EIC_usuario->idcodmed as ucodmed "+;
				" FROM TabIntevolIC "+;
				" where TabIntevolIC.EIC_idevol = ?idevol group by TabIntevolIC.id order by TabIntevolIC.id "+	miorden  , "mwkhistIC")
			mret = sqlexec(mcon1, "SELECT  TabIntEvolKine.* "+;
				" FROM TabIntEvolKine"+;
				" where TabIntEvolKine.EIK_idevol = ?idevol "+;
				"order by TabIntEvolKine.id "+	miorden, "mwkEvolAK0")
		else
			mret = sqlexec(mcon1, "select &xcantreg TabIntevolIC.*,EIC_usuario->nomape,EIC_usuario->idcodmed as ucodmed "+;
				" FROM TabIntevolIC "+;
				" inner join TabintHCE on  tabintHCE.id = TabIntevolIC.EIC_idevol " + ;
				" where tabintHCE.IH_admision = ?idevol group by TabIntevolIC.id order by TabIntevolIC.id "+	miorden , "mwkhistIC")
			mret = sqlexec(mcon1, "SELECT  &xcantreg TabIntEvolKine.* "+;
				" FROM TabIntEvolKine"+;
				" inner join TabintHCE on  tabintHCE.id = TabIntEvolKine.EIK_idevol " + ;
				" where tabintHCE.IH_admision = ?idevol group by TabIntEvolKine.id  "+;
				"order by TabIntEvolKine.id "+	miorden, "mwkEvolAK0")
		endif
			SELECT  mwkEvolAK0.*,nomape ,idcodmed  as ucodmed ;
				 FROM mwkEvolAK0;
				inner join mwkusuariosall on mwkusuariosall.idcodmed = mwkEvolAK0.EIK_codmed ;
				 order by mwkEvolAK0.id &miorden INTO CURSOR mwkEvolAK



		if mret < 0
			=aerr(eros)
			messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16,"Validacion")
			messagebox(eros(3))
			do sp_desconexion with "Err sp_busco_protocolo_historia"
			cancel
		endif
		select mwkEvolAK.id,"KINE" as EIC_codesp,0 as EIC_codpun;
			,EIK_evoluc  as EIC_evolIC,EIK_fechaHora  as EIC_fechaHora ,eik_idevol as EIC_idevol;
			,EIK_codmed as EIC_usuario,PADR(LEFT(IIF(eik_tipo = 1,"AKM->",'AKR->')  +ALLTRIM(nomape),30),30) as nomape ,EIK_codmed as ucodmed, matriculas ;
			from mwkEvolAK ;
			left join mwkMedicointall on EIK_codmed = mwkMedicointall.id ;
			into cursor mwkEvolAKt			

		mevol = iif(reccount("mwkEvolAKt")+reccount("mwkhistIC")=0,"SIN INFORMACION","")
		select mwkhistIC.* ,matriculas from mwkhistIC left join mwkMedicointall on ucodmed = mwkMedicointall.id into cursor mwkhistICd
		select * from mwkhistICd union all select * from mwkEvolAKt INTO CURSOR mwkhistICa
		select * from mwkhistICa ORDER BY EIC_fechaHora &miorden into cursor mwkhistIC
		use in select("mwkhistICd" )
		use in select("mwkhistICa" )
		use in select("mwkEvolAKt" )
		use in select("mwkEvolAK" )
		select mwkhistIC
		scan
			if !empty(alltrim(nvl(EIC_evolIC ,'')))
				mevol = mevol +space(100)+ttoc(EIC_fechaHora ) +chr(10)+ "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - " +;
					chr(10) + alltrim(nomape)+ iif(nvl(matriculas,0)>0, " M.N.:"+transform(matriculas),"")+ chr(10) + alltrim(EIC_evolIC )+chr(10)
			endif
		endscan


	case xctipo = "IC"
		mtipousu = 1
		if empty(xcantreg)
			mret = sqlexec(mcon1, "select  TabIntevolIC.*,EIC_usuario->nomape,EIC_usuario->idcodmed as ucodmed "+;
				" FROM TabIntevolIC "+;
				" where TabIntevolIC.EIC_idevol = ?idevol group by TabIntevolIC.id order by TabIntevolIC.id "+	miorden  , "mwkhistIC")
		else
			mret = sqlexec(mcon1, "select &xcantreg TabIntevolIC.*,EIC_usuario->nomape,EIC_usuario->idcodmed as ucodmed "+;
				" FROM TabIntevolIC "+;
				" inner join TabintHCE on  tabintHCE.id = TabIntevolIC.EIC_idevol " + ;
				" where tabintHCE.IH_admision = ?idevol group by TabIntevolIC.id order by TabIntevolIC.id "+	miorden , "mwkhistIC")
		endif
		mevol = iif(reccount("mwkhistIC")=0,"SIN INFORMACION","")
		select mwkhistIC.* ,matriculas from mwkhistIC left join mwkMedicointall on ucodmed = mwkMedicointall.id into cursor mwkhistICd
		select * from mwkhistICd into cursor mwkhistIC
		use in select("mwkhistICd" )
		select mwkhistIC
		scan
			if !empty(alltrim(nvl(EIC_evolIC ,'')))
				mevol = mevol +space(100)+ttoc(EIC_fechaHora ) +chr(10)+ "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - " +;
					chr(10) + alltrim(nomape)+ iif(nvl(matriculas,0)>0, " M.N.:"+transform(matriculas),"")+ chr(10) + alltrim(EIC_evolIC )+chr(10)
			endif
		endscan

	case xctipo = "EM"
		copciones = iif(empty(copciones),"S",copciones)
		mtipousu = 1
		if empty(xcantreg)
			mret = sqlexec(mcon1, "SELECT tabintevolmed.* FROM tabintevolmed  "+;
				" where EIM_idevol = ?idevol group by tabintevolmed.id order by tabintevolmed.id "+	miorden , "mwkEvolmed0")

		else
			mret = sqlexec(mcon1, "SELECT &xcantreg tabintevolmed.*   "+;
				" FROM tabintevolmed "+;
				" inner join TabintHCE on  tabintHCE.id = tabintevolmed.EIM_idevol " + ;
				" where tabintHCE.IH_admision = ?idevol group by tabintevolmed.id order by tabintevolmed.id "+	miorden , "mwkEvolmed0")
		endif

			SELECT  mwkEvolmed0.*,nomape as nombre,idcodmed as ucodmed  ;
				 FROM mwkEvolmed0;
				inner join mwkusuariosall on mwkusuariosall.idcodmed = mwkEvolmed0.EIM_codmed ;
				 order by mwkEvolmed0.id &miorden INTO CURSOR mwkEvolmed

		mevol = iif(reccount("mwkEvolmed")=0,"SIN INFORMACION","")
		select mwkEvolmed.* ,matriculas from mwkEvolmed left join mwkMedicointall on ucodmed = mwkMedicointall.id into cursor mwkEvolmedd
		select * from mwkEvolmedd into cursor mwkEvolmed
		use in select("mwkEvolmedd" )
		select mwkEvolmed

		scan
			if !isnull(nvl(EIM_evol,''))
				mevol = mevol + space(100)+ ttoc(EIM_fechah)+chr(10)+ "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - " +;
					chr(10) + left(nombre,15)+ iif(nvl(matriculas,0)>0, " M.N.:"+transform(matriculas),"")+chr(10) + alltrim(EIM_evol)+ chr(10)
			endif
		endscan

	case xctipo = "II"
		mtipousu = 1
		if empty(xcantreg)

			mret = sqlexec(mcon1, "SELECT tabintevolmed.* FROM tabintevolmed  "+;
				" where EIM_idevol = ?idevol group by tabintevolmed.id order by tabintevolmed.id "+	miorden , "mwkEvolmed0")

		else
			mret = sqlexec(mcon1, "SELECT &xcantreg tabintevolmed.* "+;
				" FROM tabintevolmed "+;
				" inner join TabintHCE on  tabintHCE.id = tabintevolmed.EIM_idevol " + ;
				" where tabintHCE.IH_admision = ?idevol group by tabintevolmed.id order by tabintevolmed.id "+	miorden , "mwkEvolmed0")

		endif
			SELECT  mwkEvolmed0.*,nomape as nombre,idcodmed as ucodmed  ;
				 FROM mwkEvolmed0;
				inner join mwkusuariosall on mwkusuariosall.idcodmed = mwkEvolmed0.EIM_codmed ;
				 order by mwkEvolmed0.id &miorden INTO CURSOR mwkEvolmed

		mevol = iif(reccount("mwkEvolmed")=0,"SIN INFORMACION","")
		select mwkEvolmed.* ,matriculas from mwkEvolmed left join mwkMedicointall on ucodmed = mwkMedicointall.id into cursor mwkEvolmedd
		select * from mwkEvolmedd into cursor mwkEvolmed
		use in select("mwkEvolmedd" )
		select mwkEvolmed
		scan
			if !empty(nvl(EIM_indicacion,'')) and EIM_fechah>=ctod("01/09/2016")
				mevol = mevol + space(100)+ ttoc(EIM_fechah)+chr(10)+ "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - " +;
					chr(10) + left(nombre,15)+ iif(nvl(matriculas,0)>0, " M.N.:"+transform(matriculas),"")+chr(10) + alltrim(EIM_indicacion)+ chr(10)
			endif
		endscan

	case xctipo = "EN"
		copciones = iif(empty(copciones),"ECMVS",copciones)
		mtipousu = 2

		if empty(xcantreg)

			mret = sqlexec(mcon1, "select EIN_codCIENanda,EIN_evolNurse ,EIN_fechaH, EIN_parAdmF ,EIN_parAlerg "+;
				",EIN_parAlergQue ,EIN_parOtros ,EIN_idevol ,EIN_usuario->nomape,EIN_usuario->idcodmed as ucodmed  from TabIntEvolNurse"+;
				" where EIN_idevol = ?idevol order by TabIntEvolNurse.id "+	miorden , "mwkevolNur")

		else
			mret = sqlexec(mcon1, "select &xcantreg EIN_codCIENanda,EIN_evolNurse ,EIN_fechaH, EIN_parAdmF ,EIN_parAlerg "+;
				",EIN_parAlergQue ,EIN_parOtros ,EIN_idevol ,EIN_usuario->nomape, EIN_usuario->idcodmed as ucodmed  from TabIntEvolNurse"+;
				" inner join TabintHCE on  tabintHCE.id = TabIntEvolNurse.EIN_idevol " + ;
				" where tabintHCE.IH_admision = ?idevol group by TabIntEvolNurse.id order by TabIntEvolNurse.id "+	miorden , "mwkevolNur")

		endif

		mevol = iif(reccount("mwkevolNur")=0,"SIN INFORMACION","")
		select mwkevolNur
		scan
			if !empty(alltrim(nvl(EIN_evolNurse,'')))

				mevol = mevol + space(100)+ ttoc(EIN_fechaH )+chr(10)+ "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - " +;
					chr(10) + alltrim(nomape)+chr(10) + alltrim(EIN_evolNurse )+ chr(10)

			endif
		endscan
	case xctipo = "ES"
		copciones = iif(empty(copciones),"s",copciones)
		mtipousu = 0
		if !used('mwkescormed')
			do sp_busco_estados with 25,' and tipo = 33 order by estado ','mwkescormed'
		endif
		if empty(xcantreg)
			mret = sqlexec(mcon1, "select  Tabintscornur.*,EIS_usuario->nomape,EIS_usuario->idcodmed as ucodmed "+;
				" FROM Tabintscornur"+;
				" where Tabintscornur.EIS_idevol = ?idevol group by Tabintscornur.id order by Tabintscornur.id "+	miorden  , "mwkhistSCR")
		else
			mret = sqlexec(mcon1, "select &xcantreg Tabintscornur.*,EIS_usuario->nomape,EIS_usuario->idcodmed as ucodmed "+;
				" FROM Tabintscornur"+;
				" inner join TabintHCE on  tabintHCE.id = Tabintscornur.EIS_idevol " + ;
				" where tabintHCE.IH_admision = ?idevol group by Tabintscornur.id order by Tabintscornur.id "+	miorden , "mwkhistSCR")
		endif
		mevol = iif(reccount("mwkhistSCR")=0,"SIN INFORMACION","")
		select mwkhistSCR.*,mwkescormed.descrip,matriculas  from mwkhistSCR,mwkescormed ;
			left join mwkMedicointall on ucodmed = mwkMedicointall.id ;
			where mwkhistSCR.EIS_tiposcore=mwkescormed.estado ;
			order by descrip , mwkhistSCR.id into cursor mwkhistScore

		if reccount('mwkhistScore')>0
			go top
			mitipo = EIS_tiposcore
			mevol = descrip +chr(10)
			mevol = mevol +"  Fecha - Hora         Valor      Profesional     "  +chr(10)
			do while !eof()
				do while !eof() and mitipo = EIS_tiposcore
					if !inlist(MITIPO,9,10)
						mevol = mevol +ttoc(EIS_fechaH)+ transform( EIS_valor ,"99999") +;
							"  -  "+ alltrim(nomape)+iif(nvl(matriculas,0)>0, " M.N.:"+transform(matriculas),"")+iif(!empty(EIS_observacion)," Observaciones:"+alltrim(EIS_observacion ),'')+chr(10)+;
							iif(MITIPO#7,'',"             Riesgo:"  + ;
							iif(EIS_valor >16 ,"ALTO",iif(EIS_valor<11 ,"BAJO","MODERADO") )+chr(10))

					endif
					skip
				enddo
				mitipo = EIS_tiposcore
				if !eof()
					mevol = mevol +chr(10)+descrip +chr(10)
					mevol = mevol +"  Fecha - Hora         Valor      Profesional     "  +chr(10)
				endif
			enddo
		endif


	case xctipo = "AKM"
		if empty(xcantreg)

			mret = sqlexec(mcon1, "SELECT TabIntEvolKine.* FROM TabIntEvolKine"+;
				" where EIK_tipo  = 1 and EIK_idevol = ?idevol group by TabIntEvolKine.id order by TabIntEvolKine.id "+	miorden  , "mwkEvolAKM0")
		else
			mret = sqlexec(mcon1, "SELECT &xcantreg TabIntEvolKine.* "+;
				" FROM TabIntEvolKine"+;
				" inner join TabintHCE on  tabintHCE.id = TabIntEvolKine.EIK_idevol " + ;
				" where EIK_tipo  = 1 and tabintHCE.IH_admision = ?idevol group by TabIntEvolKine.id order by TabIntEvolKine.id "+	miorden, "mwkEvolAKM")

		endif
			SELECT  mwkEvolAKM0.*,nomape as nombre,idcodmed as ucodmed  ;
				 FROM mwkEvolAKM0;
				inner join mwkusuariosall on mwkusuariosall.idcodmed = mwkEvolAKM0.EIK_codmed ;
				 order by mwkEvolAKM0.id &miorden INTO CURSOR mwkEvolAKM

		mevol = iif(reccount("mwkEvolAKM")=0,"SIN INFORMACION","")
		select mwkEvolAKM.* ,matriculas from mwkEvolAKM left join mwkMedicointall on ucodmed = mwkMedicointall.id into cursor mwkEvolAKMd
		select * from mwkEvolAKMd into cursor mwkEvolAKM
		use in select("mwkEvolAKMd" )
		select mwkEvolAKM
		scan
			if !isnull(nvl(EIK_evoluc ,''))
				mevol = mevol + space(100)+ ttoc(EIK_fechaHora )+chr(10)+ "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - " +;
					chr(10) + left(nombre,15)+iif(nvl(matriculas,0)>0, " M.N.:"+transform(matriculas),"")+chr(10) + alltrim(EIK_evoluc )+ chr(10)
			endif
		endscan
	case xctipo = "AKR"
		if empty(xcantreg)

			mret = sqlexec(mcon1, "SELECT TabIntEvolKine.* FROM TabIntEvolKine "+;
				" where EIK_tipo  = 2 and EIK_idevol = ?idevol group by TabIntEvolKine.id order by TabIntEvolKine.id "+	miorden , "mwkEvolAKR0")
		else
			mret = sqlexec(mcon1, "SELECT &xcantreg TabIntEvolKine.* "+;
				" FROM TabIntEvolKine"+;
				" inner join TabintHCE on  tabintHCE.id = TabIntEvolKine.EIK_idevol " + ;
				" where EIK_tipo  = 2 and tabintHCE.IH_admision = ?idevol group by TabIntEvolKine.id order by TabIntEvolKine.id "+	miorden, "mwkEvolAKR0")

		ENDIF
			SELECT  mwkEvolAKR0.*,nomape as nombre,idcodmed as ucodmed  ;
				 FROM mwkEvolAKR0;
				inner join mwkusuariosall on mwkusuariosall.idcodmed = mwkEvolAKR.EIK_codmed ;
				 order by mwkEvolAKR0.id &miorden INTO CURSOR mwkEvolAKR

		mevol = iif(reccount("mwkEvolAKR")=0,"SIN INFORMACION","")
		select mwkEvolAKR.* ,matriculas from mwkEvolAKR left join mwkMedicointall on ucodmed = mwkMedicointall.id into cursor mwkEvolAKRd
		select * from mwkEvolAKRd into cursor mwkEvolAKR
		use in select("mwkEvolAKRd" )
		select mwkEvolAKR
		scan
			if !isnull(nvl(EIK_evoluc ,''))
				mevol = mevol + space(100)+ ttoc(EIK_fechaHora )+chr(10)+ "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - " +;
					chr(10) + left(nombre,15)+iif(nvl(matriculas,0)>0, " M.N.:"+transform(matriculas),"")+chr(10) + alltrim(EIK_evoluc )+ chr(10)
			endif
		endscan


	case xctipo = "RH"  && resumen de historia
		if empty(xcantreg)

			mret = sqlexec(mcon1, "SELECT TabIntResumenHC.*,RH_usuario->nomape,RH_usuario->idcodmed as ucodmed "+;
				"FROM TabIntResumenHC "+;
				" where RH_idevol = ?idevol group by TabIntResumenHC.id order by TabIntResumenHC.id "+	miorden , "mwkEvolmed")
		else
			mret = sqlexec(mcon1, "SELECT &xcantreg TabIntResumenHC.*,RH_usuario->nomape,RH_usuario->idcodmed as ucodmed "+;
				" FROM TabIntResumenHC "+;
				" inner join TabintHCE on  tabintHCE.id = TabIntResumenHC.RH_idevol" + ;
				" where tabintHCE.IH_admision = ?idevol group by TabIntResumenHC.id order by TabIntResumenHC.id "+	miorden , "mwkEvolmed")

		endif

		mevol = iif(reccount("mwkEvolmed")=0,"SIN INFORMACION","")
		select mwkEvolmed.* ,matriculas from mwkEvolmed left join mwkMedicointall on ucodmed = mwkMedicointall.id into cursor mwkEvolmedd
		select * from mwkEvolmedd into cursor mwkEvolmed
		use in select("mwkEvolmedd" )
		select mwkEvolmed
		scan
			if !empty(nvl(RH_resumen,'')) and RH_fechaHora>=ctod("01/09/2016")
				mevol = mevol + space(100)+ ttoc(RH_fechaHora)+chr(10)+ "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - " +;
					chr(10) + left(nombre,15)+ iif(nvl(matriculas,0)>0, " M.N.:"+transform(matriculas),"")+chr(10) + alltrim(RH_resumen)+ chr(10)
			endif
		endscan


endcase
mevolr = ''
if mret < 0
	=aerr(eros)
	messagebox("ERROR de LECTURA , AVISAR A SISTEMAS", 48, "Validacion")
else
	mbususu = ''
	if mtipousu<9
		mbususu = ' and  EIP_tipoUsuario  = ?mtipousu '
	endif
	if empty(xcantreg)

		mret = sqlexec(mcon1, "select TabIntEvolParcial.* ,EIP_usuario->nomape,EIP_usuario->idcodmed as ucodmed     "+;
			" from TabIntEvolParcial "+;
			" where EIP_idevol =  ?idevol &mbususu  order by EIP_fechaH " + miorden + ',TabIntEvolParcial.id desc '  , "mwkevolparcial")

	else
		mret = sqlexec(mcon1, "select &xcantreg TabIntEvolParcial.* ,EIP_usuario->nomape,EIP_usuario->idcodmed as ucodmed    "+;
			" from TabIntEvolParcial "+;
			" inner join TabintHCE on EIP_idevol = TabintHCE.id "+;
			" where IH_admision = ?idevol  "+mbususu +;
			" group by TabIntEvolParcial.id order by EIP_fechaH " + miorden + ',TabIntEvolParcial.id desc '  , "mwkevolparcial")

	endif
	if used('mwkevolparcial')
		select mwkevolparcial.* ,matriculas from mwkevolparcial left join mwkMedicointall on ucodmed = mwkMedicointall.id into cursor mwkevolparciald
		select * from mwkevolparciald into cursor mwkevolparcial
		use in select("mwkevolparciald" )
		select mwkevolparcial
		if reccount()>0
			do while !eof()
				miusu = EIP_usuario
				midia = EIP_fechaH
				lcabe = .t.
				do while midia = EIP_fechaH  and miusu = EIP_usuario and !eof()
					do case
						case EIP_tipoEvol = "E" and ("E" $ copciones)
							mevolr = mevolr + iif(lcabe, chr(10)+ttoc(EIP_fechaH ) + " - " + allt(nomape )+ iif(nvl(matriculas,0)>0, " M.N.:"+transform(matriculas),"")+ " - "+chr(10),'' )+;
								"Evolución: "+chr(10)+alltrim(EIP_evol )
							lcabe = .f.
						case EIP_tipoEvol = "V" and ("V" $ copciones)
							mevolr = mevolr + iif(lcabe, chr(10)+ttoc(EIP_fechaH ) + " - " + allt(nomape )+iif(nvl(matriculas,0)>0, " M.N.:"+transform(matriculas),"")+ " - ",'' )+;
								chr(10)+alltrim(EIP_evol )
							lcabe = .f.
						case EIP_tipoEvol = "M" and ("M" $ copciones)
							mevolr = mevolr + iif(lcabe, chr(10)+ttoc(EIP_fechaH ) + " - " + allt(nomape )+ iif(nvl(matriculas,0)>0, " M.N.:"+transform(matriculas),"")+ " - ",'' )+;
								chr(10)+alltrim(EIP_evol )
							lcabe = .f.
						case EIP_tipoEvol = "C" and ("C" $ copciones)
							mevolr = mevolr + iif(lcabe, chr(10)+ttoc(EIP_fechaH ) + " - " + allt(nomape )+iif(nvl(matriculas,0)>0, " M.N.:"+transform(matriculas),"")+ " - ",'' )+;
								"Cuidados realizados" +chr(10)+alltrim(EIP_evol )
							lcabe = .f.
						case EIP_tipoEvol = "S" and ("S" $ copciones)
							mevolr = mevolr + iif(lcabe, chr(10)+ttoc(EIP_fechaH ) + " - " + allt(nomape )+ iif(nvl(matriculas,0)>0, " M.N.:"+transform(matriculas),"")+ " - ",'' )+ ;
								"Escores" +chr(10)+alltrim(EIP_evol )
							lcabe = .f.
						case EIP_tipoEvol = "s" and ("s" $ copciones)
							mevolr = mevolr + iif(lcabe, chr(10)+ttoc(EIP_fechaH ) + " - " + allt(nomape )+ iif(nvl(matriculas,0)>0, " M.N.:"+transform(matriculas),"")+ " - ",'' )+ ;
								"Escores" +chr(10)+alltrim(EIP_evol )
							lcabe = .f.
						case EIP_tipoEvol = "N" and ("N" $ copciones)
							mevolr = mevolr + iif(lcabe, chr(10)+ttoc(EIP_fechaH ) + " - " + allt(nomape )+ iif(nvl(matriculas,0)>0, " M.N.:"+transform(matriculas),"")+ " - "+chr(10),'' )+;
								"Valoración Objetiva: "+chr(10)+alltrim(EIP_evol )
							lcabe = .f.
						case EIP_tipoEvol = "M" and ("M" $ copciones)
							mevolr = mevolr + iif(lcabe, chr(10)+ttoc(EIP_fechaH ) + " - " + allt(nomape )+ iif(nvl(matriculas,0)>0, " M.N.:"+transform(matriculas),"")+ " - "+chr(10),'' )+;
								"Valoración Subjetiva: "+chr(10)+alltrim(EIP_evol )
							lcabe = .f.

					endcase
					select mwkevolparcial
					skip 1
				enddo
			enddo
		endif
	endif

	if empty(miorden)
		mevol  = mevol  + mevolr
	else && desc
		mevol  = mevolr  + mevol
	endif
endif
