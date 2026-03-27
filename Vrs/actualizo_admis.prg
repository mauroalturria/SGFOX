*********************************************************************************
* BUSCA PACIENTES                                            *
*********************************************************************************
mret = SQLExec(mcon1,"SELECT id, nombre,codesp,codespe,cast(matriculas as integer) as matricula  FROM prestadores  " + ;
" union  SELECT ID , nombre,'    ' as codesp,gerenciadora  as codespe,matricula  FROM TabMedExterno " + ;
" where gerenciadora = 0 " +;
"ORDER BY nombre", "mwkMedicogua" )

*!*	select * from gua8000 where protocolo in ;
*!*		(select protocolo from gua8000 where tipoest = 0 and sector = '1' ) ;
*!*		and tipoest>0 into cursor abiertos
Select * From gua8000 Where protocolo In ;
(Select protocolo From gua8000 Where tipoest > 0 ) ;
and tipoest=0  Into Cursor cerrados
Select gua8000.*,mwkMedicogua.nombre As profesional,ent_descrient,Space(40) As medcierre  From gua8000 Left Join  mwkMedicogua On mwkMedicogua.Id = codmed ;
left Join entexcl On codmed = ent_codent;
into Cursor abiertos

Select cerrados
Scan
	mproto = protocolo
	mfechaate = fechahoraate
	mcodmed = codmed
	mcodcie = codmedcie9
	mcie9 = codcie9
	mestado = codestado
	Select * From gua8000 Where mproto = protocolo And tipoest>0 Into Cursor ver

	Update gua8000 Set codmedcie9 = mcodcie,codcie9 = mcie9,codestado = mestado ;
	where protocolo = mproto And tipoest>0 And codmed>1

	Update gua8000 Set codmedcie9 = mcodcie,codcie9 = mcie9,codestado = mestado ;
	,fechahoraate = mfechaate ,codmed = mcodmed ;
	where protocolo = mproto And tipoest>0 And codmed=1

	Select cerrados
Endscan
Select abiertos
Use Dbf('abiertos') In 0 Again Alias prot_open
Select prot_open
Scan
	mproto = protocolo
	Select * From gua8000 Where mproto = protocolo And tipoest>0 Into Cursor ver
	mret = SQLExec(mcon1, "SELECT * FROM TabGuaEvol "+;
	"left join TabGuaEvolmed on TabGuaEvol.EG_protocolo = TabGuaEvolmed.EGM_proto " + ;
	" where EG_protocolo = ?mproto  "+;
	"", "mwkEvolReg01")

	Select mwkEvolReg01.*,nombre From mwkEvolReg01,mwkMedicogua ;
	where Nvl(EGM_codmed,1) = mwkMedicogua.Id ;
	order By EGM_fechah Into Cursor mwkEvolReg

	Use In mwkEvolReg01

	Select * From mwkEvolReg Where Alltrim(EGM_evol)#'No Responde' Into Cursor mwkEvolProt
	Select mwkEvolProt
	Go Bottom
	Select prot_open
	Replace medcierre  With mwkEvolProt.nombre
Endscan
Set Step On

Select proto
Scan
	mproto = protocolo
	mret = SQLExec(mcon1, "SELECT * FROM TabGuaEvol "+;
	"left join TabGuaEvolmed on TabGuaEvol.EG_protocolo = TabGuaEvolmed.EGM_proto " + ;
	" where EG_protocolo = ?mproto  "+;
	"", "mwkEvolReg01")

	Select mwkEvolReg01.* From mwkEvolReg01;
	order By EGM_fechah Into Cursor mwkEvolReg

	Use In mwkEvolReg01

	Select * From mwkEvolReg Where Alltrim(EGM_evol)#'No Responde' Into Cursor mwkEvolProt
	Select mwkEvolProt
	Go Bottom
	Select proto
	Replace fechahora With mwkEvolProt.EGM_fechah
Endscan
Set Step On
*!*	select prot_open
*!*	do sp_conexion
*!*	mret = SQLExec(mcon1,"SELECT id, nombre,codesp,codespe  FROM prestadores  " + ;
*!*		" union  SELECT ID , nombre,'    ' as codesp,gerenciadora  as codespe  FROM TabMedExterno " + ;
*!*		" where gerenciadora = 0 ", "mwkMedicogua" )
*!*	open database c:\desguemescar\presu
*!*	proto = ''
*!*	use guardia in 0
*!*	select gua8000
*!*	scan
*!*		if tipoest>0
*!*			mnroreg = gua8000.nroregistr
*!*			mfecha1 = ttod(gua8000.fechahoraing)
*!*			mfecha2 = ttod(gua8000.fechahoraing + 12*3600)
*!*		*	mihora = ttod(fechahorai + 12*3600)
*!*			mret = sqlexec(mcon1, "select PAC_fechaadmision, PAC_horaadmision, PAC_fechaalta, PAC_codhci, PAC_codadmision  "+;
*!*				" FROM pacientes "+ ;
*!*				" where  PAC_codhci = ?mnroreg and PAC_fechaadmision >=?mfecha1 " +;
*!*				" and PAC_fechaadmision <=?mfecha2 ","mwkbuspacie")
*!*			if mret < 0
*!*				=aerr(eros)
*!*				messagebox(eros(3))
*!*			endif
*!*			if reccount( "mwkbuspacie")>0
*!*				proto = gua8000.protocolo
*!*				requery ('guardia')
*!*				select * from guardia where tipoest = 0 into cursor controlo
*!*	*			browse last
*!*				if reccount('controlo') = 0
*!*					update guardia set codcie9 = 92,codestado = 3,codmedcie9 = codmed
*!*				else
*!*					if reccount('guardia')>1
*!*						select guardia
*!*						browse last
*!*					else
*!*						if reccount('controlo') # reccount('guardia')
*!*							set step on
*!*						endif
*!*					endif
*!*				endif
*!*			mhc  = PAC_codadmision
*!*			select prot_open
*!*			replace interna with mhc
*!*			endif
*!*		endif
*!*		select gua8000
*!*	endscan

mret = SQLExec(mcon1, "select VAL_OperadorCarga," + ;
" VAL_fechasolicitud,VAL_horasolicitud,val_codvaleasist,VAL_horacargasolic, VAL_fechacargasoli "+;
" from valesasist "+;
" where  VAL_codservvale=5410 and  VAL_fechasolicitud >= ?mfechades and VAL_codsector ='EME' and VAL_estado <> 3 " , "mwktodoinsa1")
If mret<0
	=Aerr(eros)
	Messagebox(eros(3))
Endif
Select proto
Scan
	mnroreg = admision
	mret = SQLExec(mcon1, "select PAC_codhci ,PAC_fechaadmision, PAC_horaadmision, PAC_fechaalta, PAC_codhci, PAC_codadmision  "+;
	",REG_domicilio, REG_telefonos,REG_tipodocumento, REG_numdocumento "+;
	" FROM pacientes,registracio "+ ;
	" where  PAC_codadmision  = ?mnroreg and PAC_codhci = REG_nroregistrac " +;
	" ","mwkbuspacie")
	If mret < 0
		=Aerr(eros)
		Messagebox(eros(3))
	Endif
	If Reccount( "mwkbuspacie")>0
		mdomi = Nvl(REG_domicilio,'')
		mtel  = Nvl(REG_telefonos,'')
		mdoc = Nvl(REG_numdocumento ,0)
		Select admision
		Replace domicilio With mdomi ,telefono With mtel  , documento With mdoc
	Endif
Endscan


Select  hclini
Scan
	mnrohclin = hclini.hclinica
	mret = SQLExec(mcon1, "select HIS_codentidad ,HIS_fechaadmision "+;
	" FROM Registracio,histambgua "+ ;
	" where  his_nroregistrac = REG_nroregistrac and "+;
	" REG_nrohclinica  = ?mnrohclin " ,"mwkbuspacie")
	If Reccount( "mwkbuspacie")>0
		Go Bott
		mcodent  = HIS_codentidad
		Select  hclini
		Replace codent With mcodent
	Endif
Endscan
Do sp_desconexion

Do sp_conexion
Set Step On
Select  registra
Scan
	If registra.entidad = 0

		Wait Windows Transform(Recno()) Nowait
		mctexto = registraci
		mret = SQLExec(mcon1,"select REG_nrohclinica,REG_numdocumento , AFI_codentidad,AFI_nroafiliado ,REG_distrito" + ;
		" FROM afiliacion, registracio " + ;
		" where REG_nroregistrac = ?mctexto and AFI_fechabaja is null  "+;
		" and registracio.REG_nroregistrac = afiliacion.registracio  " , "mwkbuspacie")
		If Reccount( "mwkbuspacie")=1
			If Inlist(AFI_codentidad,100,101,945,948)
				midoc = REG_numdocumento
				mient = Iif(AFI_codentidad=101,100,Iif(AFI_codentidad=945,948,AFI_codentidad ) )
				mret = SQLExec(mcon1,"select  fecegreso ,plan " + ;
				" FROM padcabe  where padcabe.documento =?midoc and padcabe.entidad = ?mient " +;
				" order by fecegreso desc "	, "mwkbuspad")
				If Reccount("mwkbuspad")>0
					If mwkbuspad.fecegreso>Date()
						miplan = Iif(Nvl(plan,0)>0,plan,Val(Nvl(mwkbuspacie.REG_distrito,'')))
						Select  registra
						Replace afiliado With mwkbuspacie.AFI_nroafiliado, entidad With mwkbuspacie.AFI_codentidad,plan With miplan
					Endif
				Endif
			Endif
			If registra.entidad =0 Or Inlist(mwkbuspacie.AFI_codentidad,101,945 )
				Select  registra
				Replace afiliado With mwkbuspacie.AFI_nroafiliado, entidad With mwkbuspacie.AFI_codentidad,plan With Val(Nvl(mwkbuspacie.REG_distrito,''))
			Endif
		Else
			Select  mwkbuspacie
			Locate For AFI_codentidad=100
			If Found()
				midoc = REG_numdocumento
				mient = AFI_codentidad
				mret = SQLExec(mcon1,"select  fecegreso ,plan " + ;
				" FROM padcabe  where padcabe.documento =?midoc and padcabe.entidad = ?mient " +;
				" order by fecegreso desc "	, "mwkbuspad")
				If Reccount("mwkbuspad")>0
					If mwkbuspad.fecegreso>Date()
						miplan = Iif(Nvl(plan,0)>0,plan,Val(Nvl(mwkbuspacie.REG_distrito,'')))
						Select  registra
						Replace afiliado With mwkbuspacie.AFI_nroafiliado, entidad With mwkbuspacie.AFI_codentidad,plan With miplan
					Endif
				Endif
			Endif
			If registra.entidad =0
				Select  mwkbuspacie
				Locate For AFI_codentidad=948
				If Found()
					midoc = REG_numdocumento
					mient = AFI_codentidad
					mret = SQLExec(mcon1,"select  fecegreso ,plan " + ;
					" FROM padcabe  where padcabe.documento =?midoc and padcabe.entidad = ?mient " +;
					" order by fecegreso desc "	, "mwkbuspad")
					If Reccount("mwkbuspad")>0
						If mwkbuspad.fecegreso>Date()
							miplan = Iif(Nvl(plan,0)>0,plan,Val(Nvl(mwkbuspacie.REG_distrito,'')))
							Select  registra
							Replace afiliado With mwkbuspacie.AFI_nroafiliado, entidad With mwkbuspacie.AFI_codentidad,plan With miplan
						Endif
					Endif
				Endif
			Endif
			If registra.entidad =0
				Select  mwkbuspacie
				Locate For AFI_codentidad=101
				If Found()
					midoc = REG_numdocumento
					mient = 100
					mret = SQLExec(mcon1,"select  fecegreso ,plan " + ;
					" FROM padcabe  where padcabe.documento =?midoc and padcabe.entidad = ?mient " +;
					" order by fecegreso desc "	, "mwkbuspad")
					If Reccount("mwkbuspad")>0
						If mwkbuspad.fecegreso>Date()
							miplan = Iif(Nvl(plan,0)>0,plan,Val(Nvl(mwkbuspacie.REG_distrito,'')))
							Select  registra
							Replace afiliado With mwkbuspacie.AFI_nroafiliado, entidad With mient,plan With miplan
						Endif
					Else
						Select  registra
						Replace afiliado With mwkbuspacie.AFI_nroafiliado, entidad With mwkbuspacie.AFI_codentidad,plan With miplan
					Endif
				Endif
			Endif
			If registra.entidad =0
				Select  mwkbuspacie
				Locate For AFI_codentidad=945
				If Found()
					midoc = REG_numdocumento
					mient = AFI_codentidad
					mret = SQLExec(mcon1,"select  fecegreso ,plan " + ;
					" FROM padcabe  where padcabe.documento =?midoc and padcabe.entidad = ?mient " +;
					" order by fecegreso desc "	, "mwkbuspad")
					If Reccount("mwkbuspad")>0
						If mwkbuspad.fecegreso>Date()
							miplan = Iif(Nvl(plan,0)>0,plan,Val(Nvl(mwkbuspacie.REG_distrito,'')))
							Select  registra
							Replace afiliado With mwkbuspacie.AFI_nroafiliado, entidad With 948,plan With miplan
						Endif
					Else
						Select  registra
						Replace afiliado With mwkbuspacie.AFI_nroafiliado, entidad With mwkbuspacie.AFI_codentidad,plan With miplan
					Endif
				Endif
			Endif
			If registra.entidad =0
				Select  mwkbuspacie
				Locate For  AFI_codentidad = 149
				If Found()
					Select  registra
					Replace afiliado With mwkbuspacie.AFI_nroafiliado, entidad With mwkbuspacie.AFI_codentidad,plan With Val(Nvl(mwkbuspacie.REG_distrito,''))
				Else
					Locate For !Inlist(AFI_codentidad,2, 302, 898)
					If Found()
						Select  registra
						Replace afiliado With mwkbuspacie.AFI_nroafiliado, entidad With mwkbuspacie.AFI_codentidad,plan With Val(Nvl(mwkbuspacie.REG_distrito,''))
					Else
						Go Top
						Select  registra
						Replace afiliado With mwkbuspacie.AFI_nroafiliado, entidad With mwkbuspacie.AFI_codentidad,plan With Val(Nvl(mwkbuspacie.REG_distrito,''))
					Endif
				Endif

			Endif
		Endif
*!*			mret = SQLExec(mcon1,"select REG_nrohclinica, AFI_nroafiliado ,REG_nombrepac,AFI_fechabaja " + ;
*!*				" FROM afiliacion, registracio " + ;
*!*				" where REG_nrohclinica = ?mctexto "+;
*!*				" and registracio.REG_nroregistrac = afiliacion.registracio and  afiliacion.AFI_codentidad = 948 " , "mwkbuspacie")
*!*			If Reccount( "mwkbuspacie")>0
*!*				Select  hclin
*!*				Replace afiliado With mwkbuspacie.AFI_nroafiliado, entidad With 948,pasivo With Nvl(mwkbuspacie.AFI_fechabaja,Ctod("  /  /  "))
*!*			Else
*!*				mret = SQLExec(mcon1,"select REG_nrohclinica, AFI_nroafiliado ,REG_nombrepac,AFI_fechabaja " + ;
*!*					" FROM afiliacion, registracio " + ;
*!*					" where REG_nrohclinica = ?mctexto  "+;
*!*					" and registracio.REG_nroregistrac = afiliacion.registracio and afiliacion.AFI_codentidad = 945 " , "mwkbuspacie")
*!*				If Reccount( "mwkbuspacie")>0
*!*					Select  hclin
*!*					Replace afiliado With mwkbuspacie.AFI_nroafiliado, entidad With 945,pasivo With Nvl(mwkbuspacie.AFI_fechabaja,Ctod("  /  /  "))
*!*				Endif

	Endif
Endscan
Do sp_desconexion
Select admisiones
Scan
	mnrohclin = h_clinica
	mtfhoy = ingreso - 24 * 3600 * 1 &&(2 dias antes)
	mret = SQLExec(mcon1, "select REG_nroregistrac  "+;
	" FROM Registracio "+ ;
	" where  REG_nrohclinica  = ?mnrohclin " ,"mwkbuspacie")

	mbusca = " guardia.fechahoraing >= ?mtfhoy and guardia.nroregistrac = "+Alltrim(Str(mwkbuspacie.REG_nroregistrac))
	Do sp_busco_protocolo_paciente With mbusca,0,'','protocolo,codprest'
	Select mwkguardia
	Go Top
	If Reccount( "mwkguardia")>0
		cdiag = codcie9
		Select admisiones
		Replace codcie1 With cdiag
	Else
		mbusca = " guardia.fechahoraing >= ?mtfhoy and guardia.nroregistrac = "+Alltrim(Str(mwkbuspacie.REG_nroregistrac))
		Do sp_busco_protocolo_paciente With mbusca,0,1,'protocolo,codprest'
		Select mwkguardia
		Go Top
		If Reccount( "mwkguardia")>0
			cdiag = codcie9
			Select admisiones
			Replace codcie1 With cdiag
		Endif

	Endif
Endscan
Select ostel
Scan
	mnroreg = reg_nroreg
	mret = SQLExec(mcon1, "select PAC_codadmision  "+;
	" FROM pacientes "+ ;
	" where  PAC_codhci = ?mnroreg " +;
	" ","mwkbuspacie")
	If mret < 0
		=Aerr(eros)
		Messagebox(eros(3))
	Endif
	If Reccount( "mwkbuspacie")>0
		mcuenta = PAC_codadmision
		Select ostel
		Replace cuenta With mcuenta
	Endif
Endscan

Set Step On
Select admisiones
Scan
	mnroreg = admis
	mret = SQLExec(mcon1, "select REG_email "+;
	" FROM Registracio "+ ;
	" where  REG_nrohclinica = ?mnroreg " +;
	" ","mwkbuspacie")
	If mret < 0
		=Aerr(eros)
		Messagebox(eros(3))
	Endif
	If Reccount( "mwkbuspacie")>0
		mcuenta =  Iif(Isnull(REG_email),"no pedido",REG_email)
		Select admisiones
		Replace Mail  With mcuenta
	Endif
Endscan
Do sp_conexion
Set Step On
Select  hclin
Scan
	Wait Windows Transform(Recno()) Nowait
	If documento = 0
		mctexto = Alltrim(hclin)
		mret = SQLExec(mcon1,"select REG_nrohclinica, AFI_nroafiliado ,REG_numdocumento,REG_nombrepac,AFI_fechabaja " + ;
		" FROM afiliacion, registracio " + ;
		" where REG_nrohclinica = ?mctexto "+;
		" and registracio.REG_nroregistrac = afiliacion.registracio and  afiliacion.AFI_codentidad = 948 " , "mwkbuspacie")
		If Reccount( "mwkbuspacie")>0
			Select  hclin
			Replace afiliado With mwkbuspacie.AFI_nroafiliado, entidad With 948;
			,pasivo With Nvl(mwkbuspacie.AFI_fechabaja,Ctod("  /  /  ")), documento With mwkbuspacie.REG_numdocumento
		Else
			mret = SQLExec(mcon1,"select REG_nrohclinica, AFI_nroafiliado ,REG_numdocumento,REG_nombrepac,AFI_fechabaja " + ;
			" FROM afiliacion, registracio " + ;
			" where REG_nrohclinica = ?mctexto "+;
			" and registracio.REG_nroregistrac = afiliacion.registracio and afiliacion.AFI_codentidad = 945 " , "mwkbuspacie")
			If Reccount( "mwkbuspacie")>0
				Select  hclin
				Replace afiliado With mwkbuspacie.AFI_nroafiliado, entidad With 945;
				,pasivo With Nvl(mwkbuspacie.AFI_fechabaja,Ctod("  /  /  ")), documento With mwkbuspacie.REG_numdocumento
			Else
				mret = SQLExec(mcon1,"select REG_nrohclinica, AFI_nroafiliado ,REG_numdocumento,REG_nombrepac,AFI_fechabaja " + ;
				" FROM afiliacion, registracio " + ;
				" where REG_nrohclinica = ?mctexto "+;
				" and registracio.REG_nroregistrac = afiliacion.registracio and afiliacion.AFI_codentidad = 484 " , "mwkbuspacie")
				If Reccount( "mwkbuspacie")>0
					Select  hclin
					Replace afiliado With mwkbuspacie.AFI_nroafiliado, entidad With 484;
					,pasivo With Nvl(mwkbuspacie.AFI_fechabaja,Ctod("  /  /  ")), documento With mwkbuspacie.REG_numdocumento
				Endif
			Endif
		Endif
	Endif

Endscan
Do sp_desconexion


Do sp_conexion
Do sp_busco_plan
Select coseguro
Scan
	mnrohclin = hclin
	mret = SQLExec(mcon1, "select reg_distrito "+;
	" FROM Registracio "+ ;
	" where  REG_nrohclinica  = ?mnrohclin " ,"mwkbuspacie")
	celplan = "NO DEFINIDO"
	Select 	mwkTplan
	micampo = "mwkTplan.descripent"
	Locate For Val(abreviatura) = Val(Nvl(mwkbuspacie.REG_distrito,'0'))
	If Found()
		celplan = &micampo
	Endif
	lotroplan = (Val(abreviatura) # Val(Nvl(mwkbuspacie.REG_distrito,'0')) Or !Found() Or Val(Nvl(mwkbuspacie.REG_distrito,'0'))= 0)
*!*			if vartype(dat_ws(7))="C" and  !empty(dat_ws(7))
*!*				planHOL = alltrim(dat_ws(7))
*!*				if !found() or (found() and alltrim(&micampo) # planHOL)
*!*					if between(val(planHOL),100,999)
*!*						planHOL = left(planHOL,1)+"00"
*!*					endif
*!*					locate for &micampo = planHOL  and CodEntAg = micodent
*!*					if found()
*!*						if val(abreviatura) # val(nvl(mwkbuspacie.REG_distrito,'0'))
*!*							mplan = alltrim(abreviatura)
*!*							do sp_actualizo_plan100 with mwkbuspacie.reg_nroregistrac,mplan
*!*							lotroplan = .f.
*!*						endif
*!*					else
*!*						mibus = alltrim( left( planHOL ,at(" ",planHOL )) )
*!*						milen = len(mibus)
*!*						if milen > 0

*!*							locate for left(&micampo,milen) = mibus and CodEntAg = micodent
*!*							if found()
*!*								if val(abreviatura) # val(nvl(mwkbuspacie.REG_distrito,'0'))
*!*									mplan = alltrim(abreviatura)
*!*									do sp_actualizo_plan100 with mwkbuspacie.reg_nroregistrac,mplan
*!*								endif
*!*								select mwkTplan
*!*	*!*									messagebox("ESTE PACIENTE TIENE PLAN:" + planHOL   ;
*!*	*!*										+ chr(13)+" SE LE ASIGNA "+ alltrim(&micampo),64,"Alerta de Cambios")
*!*							endif
*!*						endif
*!*					endif
*!*				endif
*!*			else
*!*				lotroplan = .f.
*!*			endif
	Select  coseguro
	Replace plan With Val(Nvl(mwkbuspacie.REG_distrito,'0')) , descriplan  With celplan
Endscan
Do sp_desconexion
*!*	append from dbf('tabesthci')
*!*	do clearall
*!*	use c:\desaguemes\hclin.dbf in 0 exclusive
*!*	select 1
*!*	browse last
*!*	resume
*!*	select * from hclin where empty(afiliado)
*!*	go top
*!*	locate for empty(afiliado)
*!*	use c:\desaguemes\cosa.dbf in 0 exclusive
*!*	select 5
*!*	browse last
*!*	zap
*!*	pack
*!*	append from c:\desaguemes\hclini.txt delimited with tab
*!*	select * from cosa,hclin where hclin=hc into cursor otro
*!*	browse last
*!*	go bott
*!*	go top
*!*	copy to AFLIAD1 type xl5
*!*	copy to AFLIAD2 type xl5 next 35000
*!*	copy to AFLIAD3 type xl5 next 35000
*!*	copy to AFLIAD4 type xl5 next 35000
*!*	copy to AFLIAD5 type xl5 next 35000
*!*	copy to AFLIAD6 type xl5 next 35000
*!*	copy to AFLIAD7 type xl5 next 35000

*!*	select vales
*!*	scan
*!*	mivale = vales.vale
*!*	requery('vales_ic')
*!*	select vales_ic
*!*	wait windows transform(recno()) nowait
*!*	mfec = VAL_fechaconforme
*!*	mhora = ttoc(VAL_horaconforme,2)
*!*	if vales_ic.VAL_estado>0
*!*		select vales
*!*		replace estado with vales_ic.VAL_estado
*!*	endif
*!*	if !isnull(vales_ic.VAL_fechaconforme)
*!*		select vales
*!*		replace fechaconforme with mfec,horaconf with mhora
*!*	endif

*!*	endscan
*!*	select proto
*!*	scan
*!*	proto = proto.protoc
*!*	requery ('guardia')
*!*	mnroreg = alltrim(guardia.diagnostico)
*!*	mret = sqlexec(mcon1, "select PAC_codhci ,PAC_fechaadmision, PAC_horaadmision, PAC_fechaalta, PAC_codhci, PAC_codadmision,PAC_sectorinternac,"+;
*!*		" PAC_motivoalta  "+;
*!*		" FROM pacientes "+ ;
*!*		" where  PAC_codadmision  = ?mnroreg " +;
*!*		" ","mwkbuspacie")
*!*	if mret < 0
*!*		=aerr(eros)
*!*		messagebox(eros(3))
*!*	endif
*!*	if reccount( "mwkbuspacie")>0
*!*		mfec= mwkbuspacie.PAC_fechaadmision
*!*		mnroreg = mwkbuspacie.PAC_codhci
*!*		requery ('protquirint')
*!*		select proto
*!*		if !isnull(mwkbuspacie->PAC_fechaalta)
*!*			replace sector with mwkbuspacie->PAC_sectorinternac,motivo with mwkbuspacie->PAC_motivoalta  ,fechaalta with mwkbuspacie->PAC_fechaalta
*!*		else
*!*			replace sector with mwkbuspacie->PAC_sectorinternac
*!*		endif
*!*		if reccount( "protquirint")>0
*!*			replace fechaquiro  with protquirint->PAC_FechaQuirof
*!*		endif

*!*	endif
*!*	endscan
*!*	do sp_conexion
*!*	set step on
*!*	select  hclin
*!*	scan
*!*	if hclin.entidad = 0 or hclin.entidad = 945 or hclin.pasivo>ctod("01/01/2000")

*!*		wait windows transform(recno()) nowait
*!*		mctexto = alltrim(hclin)
*!*		mret = sqlexec(mcon1,"select REG_nrohclinica, nroafiliado ,fechahasta ,REG_nombrepac" + ;
*!*			" FROM registracio,padcabe,padvigencia " + ;
*!*			" where REG_nrohclinica = ?mctexto and idpadcabe = padcabe.id "+;
*!*			" and registracio.REG_numdocumento = padcabe.documento and padcabe.entidad = 948 " +;
*!*			" order by fechahasta desc "	, "mwkbuspacie")
*!*		if reccount( "mwkbuspacie")>0
*!*			select  hclin
*!*			replace afiliado with transform(round(mwkbuspacie.nroafiliado,0)), entidad with 948, pasivo with mwkbuspacie.fechahasta
*!*		endif
*!*	endif
*!*	endscan
*!*	do sp_desconexion


*!*	do sp_conexion
*!*	set step on
*!*	select  agrego
*!*	scan
*!*		mcodCIE9 = codCIE9
*!*		mcodent =  codent
*!*		mcodestado = codestado
*!*		mcodmed =  codmed
*!*		mcodmedcie9 = codmedcie9
*!*		mcodprest = codprest
*!*		mdiagnostico =  diagnostico
*!*		mfechahoraate =  fechahoraate
*!*		mfechahoraing = fechahoraing
*!*		mnroregistrac =  nroregistrac
*!*		mprioridad =  prioridad
*!*		mprotocolo = protocolo
*!*		mpuesto =  puesto
*!*		musuario =  usuario
*!*		mret = sqlexec(mcon1," insert into guardia (codCIE9, codent, codestado, codmed, codmedcie9, codprest,"+;
*!*			" diagnostico, fechahoraate, fechahoraing, nroregistrac, prioridad, protocolo, puesto, usuario) "+;
*!*			" values (?mcodCIE9, ?mcodent, ?mcodestado, ?mcodmed, ?mcodmedcie9, ?mcodprest,"+;
*!*			" ?mdiagnostico, ?mfechahoraate, ?mfechahoraing, ?mnroregistrac, ?mprioridad, ?mprotocolo, ?mpuesto, ?musuario) ")
*!*	endscan
*!*	do sp_desconexion

Do sp_conexion
Set Step On
Select  sinoni
Scan
	mdiagnostico =  sino
	mid = nid
	mret = SQLExec(mcon1," update Tabciap2e set Sinonimos = ?mdiagnostico where id = ?mid")
Endscan
Do sp_desconexion


Create Cursor datosRM(vale N(10),fecha d,admision c(8), edad N(5),codciei N(5),codciee N(5))
Do sp_conexion
Set Step On
Select mwkrm
Scan
	mvale = mwkrm.nrovale
	mret = SQLExec(mcon1, "select VAL_fechasolicitud,PAC_codhci ,PAC_fechaadmision, PAC_horaadmision, PAC_fechaalta, PAC_codadmision,pac_edad  "+;
	",PAC_codcie10diagegr, Pacientes.PAC_codcie10diagn,val_codvaleasist  "+;
	" from valesasist "+;
	" , pacientes "+ ;
	" where val_codvaleasist = ?mvale and VAL_codadmision = PAC_codadmision  " +;
	" " , "mwkdatos")
	If mret<0
		=Aerr(eros)
		Messagebox(eros(3))
	Endif
	If Reccount("mwkdatos")>0
		Insert Into datosRM(vale,fecha ,admision, edad ,codciei ,codciee) Values ( mvale,mwkdatos->VAL_fechasolicitud,;
		mwkdatos->PAC_codadmision,mwkdatos->PAC_edad  ,Nvl(mwkdatos->PAC_codcie10diagn,1),Nvl(mwkdatos->PAC_codcie10diagegr,1))

	Endif
Endscan

Create Cursor datosTC(vale N(10),fecha d,admision c(8), edad N(5),codciei N(5),codciee N(5))
Select mwkTC
Scan
	mvale = mwkTC.nrovale
	mret = SQLExec(mcon1, "select VAL_fechasolicitud,PAC_codhci ,PAC_fechaadmision, PAC_horaadmision, PAC_fechaalta, PAC_codadmision,pac_edad  "+;
	",PAC_codcie10diagegr, Pacientes.PAC_codcie10diagn,val_codvaleasist  "+;
	" from valesasist "+;
	" , pacientes "+ ;
	" where val_codvaleasist = ?mvale and VAL_codadmision = PAC_codadmision  " +;
	" " , "mwkdatos")
	If mret<0
		=Aerr(eros)
		Messagebox(eros(3))
	Endif
	If Reccount("mwkdatos")>0
		Insert Into datosTC(vale,fecha ,admision, edad ,codciei ,codciee) Values ( mvale,mwkdatos->VAL_fechasolicitud,;
		mwkdatos->PAC_codadmision,mwkdatos->PAC_edad  ,Nvl(mwkdatos->PAC_codcie10diagn,1),Nvl(mwkdatos->PAC_codcie10diagegr,1))

	Endif
Endscan
Do sp_desconexion

**********
Do sp_conexion
Set Step On
Select valestc
Scan
	mvale = valestc.vale
	mret = SQLExec(mcon1, " select PRE_codprest, PRE_descriprest  FROM Valesasist,"+;
	" Presinsuvas, Prestacions WHERE PIA_VALESASIST = VALESASIST " +;
	"  AND PRE_codprest = PIA_codprest "+ ;
	" and val_codvaleasist = ?mvale " +;
	" " , "mwkdatos")
	If mret<0
		=Aerr(eros)
		Messagebox(eros(3))
	Endif
	Select valestc
	If Reccount("mwkdatos")>0
		Replace codprest With mwkdatos->PRE_codprest,Descrip With mwkdatos->PRE_descriprest
	Endif
Endscan
Do sp_desconexion


Do sp_conexion
Set Step On
Select valesrm
Scan
	mvale = valesrm.vale
	mret = SQLExec(mcon1, " select PRE_codprest, PRE_descriprest  FROM Valesasist,"+;
	" Presinsuvas, Prestacions WHERE PIA_VALESASIST = VALESASIST " +;
	"  AND PRE_codprest = PIA_codprest "+ ;
	" and val_codvaleasist = ?mvale " +;
	" " , "mwkdatos")
	If mret<0
		=Aerr(eros)
		Messagebox(eros(3))
	Endif
	Select valesrm
	If Reccount("mwkdatos")>0
		Replace codprest With mwkdatos->PRE_codprest,Descrip With mwkdatos->PRE_descriprest
	Endif
Endscan
Do sp_desconexion

Set Step On

Create Cursor sondas (dia d,admision c(10),sector c (3),tipo N(2),cant N(3))
Select diasmarzo
Scan
	admi = NRO_ADMISI
	Requery('lugarinterna')
	Select * From lugarinterna ;
	where LUG_fechaingreso <Ctod("01/04/2017") And Nvl(LUG_fechaegreso,Ctod("01/01/2100"))>=Ctod("01/03/2017") ;
	into Cursor ucis
	Select ucis
*!*		if dias.f_alta = ctod("  /  /  ")
*!*			set step on
*!*		endif
	Scan
		misec = lug_codsector
		mfech = Nvl(LUG_fechaegreso,Ctod("01/01/2100"))
		mifecha = Ctot(Dtoc(LUG_fechaingreso)+" "+Ttoc(lug_horaingreso,2))
		Requery('vias')
		mfechi = Ttod(mifecha )
		If Reccount('vias')>0
			Select vias
			Scan
				desde = avn_fechaini
				hasta = avn_fechafin
				mtipo = avn_tipo
				If desde <= mfech And hasta >= mfechi
					If desde <= mfechi
						desde = mfechi
					Endif
					If hasta > mfech
						hasta = mfech
					Endif
					dias = hasta-desde
					For i = 0 To dias
						mfec = desde+i
						Insert Into sondas (dia,admision ,sector,tipo,cant) Values (mfec,admi ,misec,mtipo,1)
					Next
				Endif
			Endscan
		Endif
		Select ucis
	Endscan
	Select diasmarzo
Endscan
Select datos_tc
Scan
	admision = datos_tc.admision
	Requery('pacientes')
	Insert Into todo_rm (PAC_nombrepaciente, PAC_motivoalta,;
	PAC_descripdiagn, PAC_diagegreso,;
	PAC_codcie10diagalt, PAC_descripdiagegr,;
	PAC_edad, PAC_sexo, PAC_codhce,;
	PAC_fechaalta, MTE_Descripcion,;
	MTE_CodMotivo, PAC_nacionalidad,;
	PAC_estadocivil, PAC_domicilio,;
	PAC_ocupacion, PAC_nombrerespons,;
	PAC_domicresponsab, PAC_telefresponsab,;
	PAC_fechaadmision, PAC_horaadmision,;
	PAC_horaalta, PAC_motivoadmision,;
	PAC_medicoadmision, PAC_medicoalta,;
	PAC_servrespons, PAC_codquirprincip,;
	PAC_servquirurg, PAC_fecnacimiento,;
	PAC_documento, PAC_tipopaciente,;
	PAC_areainternac, PAC_codcie10diagegr,;
	PAC_codcie10diagn, PAC_codmedicoadm,;
	PAC_observaciones, PAC_observalta,;
	PAC_ordeninternac, PAC_protocorigen,;
	PAC_codadmision) Values(pacientes.PAC_nombrepaciente, pacientes.PAC_motivoalta,;
	pacientes.PAC_descripdiagn, pacientes.PAC_diagegreso,;
	pacientes.PAC_codcie10diagalt, pacientes.PAC_descripdiagegr,;
	pacientes.PAC_edad, pacientes.PAC_sexo, pacientes.PAC_codhce,;
	pacientes.PAC_fechaalta, pacientes.MTE_Descripcion,;
	pacientes.MTE_CodMotivo, pacientes.PAC_nacionalidad,;
	pacientes.PAC_estadocivil, pacientes.PAC_domicilio,;
	pacientes.PAC_ocupacion, pacientes.PAC_nombrerespons,;
	pacientes.PAC_domicresponsab, pacientes.PAC_telefresponsab,;
	pacientes.PAC_fechaadmision, pacientes.PAC_horaadmision,;
	pacientes.PAC_horaalta, pacientes.PAC_motivoadmision,;
	pacientes.PAC_medicoadmision, pacientes.PAC_medicoalta,;
	pacientes.PAC_servrespons, pacientes.PAC_codquirprincip,;
	pacientes.PAC_servquirurg, pacientes.PAC_fecnacimiento,;
	pacientes.PAC_documento, pacientes.PAC_tipopaciente,;
	pacientes.PAC_areainternac, pacientes.PAC_codcie10diagegr,;
	pacientes.PAC_codcie10diagn, pacientes.PAC_codmedicoadm,;
	pacientes.PAC_observaciones, pacientes.PAC_observalta,;
	pacientes.PAC_ordeninternac, pacientes.PAC_protocorigen,;
	pacientes.PAC_codadmision )
Endscan

Select arreglo
Scan
	micod = codigovax_a
	mimed = idcodmed_a
	Update tabusuario Set idcodmed = mimed Where codigovax=micod
	Select arreglo

Endscan

Do sp_conexion
Set Step On
Select  webxls
Scan
	Wait Windows Transform(Recno()) Nowait
	mctexto = documento
	mret = SQLExec(mcon1,"select REG_nrohclinica, REG_email,REG_nombrepac " + ;
	" FROM registracio " + ;
	" where REG_numdocumento = ?mctexto ", "mwkbuspacie")
	If Reccount( "mwkbuspacie")=1
		mimail = Nvl(REG_email,'no pedido')
		Select  webxls
		Replace mailant With mimail, nomape With mwkbuspacie.REG_nombrepac
	Else
		If Reccount( "mwkbuspacie")>1
			mimail = "*** "+ Nvl(REG_email,'no pedido')
			Select  webxls
			Replace mailant With mimail, nomape With mwkbuspacie.REG_nombrepac
		Endif
	Endif
Endscan
Do sp_desconexion

Do sp_conexion
Set Step On
Select  webxls
Scan
	Wait Windows Transform(Recno()) Nowait
	If Empty(mailant) Or Left(mailant,3)="***" Or Upper(mailant)=Upper(email)
	Else
		mctexto = documento
		mret = SQLExec(mcon1,"update registracio " + ;
		" set REG_email, = ?email where REG_numdocumento = ?mctexto ")
	Endif
Endscan
Do sp_desconexion


Do sp_conexion
Set Step On
Select  mrsa
Scan
	mctexto = Alltrim(HC)
	mret = SQLExec(mcon1,"select registracio,REG_sexo,REG_fecnacimiento " + ;
	" FROM registracio " + ;
	" where REG_nrohclinica  = ?mctexto ", "mwkbuspacie")
	If Reccount( "mwkbuspacie")=1
		misex  = REG_sexo
		minac = REG_fecnacimiento
		Select  mrsa
		miedad = (fecmov-minac)/365

		Replace sexo With misex, edad  With miedad
	Else
	Endif
Endscan
Do sp_desconexion

Do sp_conexion
Set Step On
*!*	If !sp_busco_antecedentes_gral1esp('', " and Trim(TA_tipo) = 'P'" , "mwkAntec",)
*!*		Set Step On
*!*	Endif

Select  PORTA
Set Filter To egreso = 0
Scan
	mctexto = Alltrim(PORTA.HC)
*!*		mret = SQLExec(mcon1,"select registracio,REG_sexo,REG_fecnacimiento " + ;
*!*			" FROM registracio " + ;
*!*			" where REG_nrohclinica  = ?mctexto ", "mwkbuspacie")
*!*		mireg = mwkbuspacie.registracio
*!*		misex  = mwkbuspacie.REG_sexo
*!*		minac = mwkbuspacie.REG_fecnacimiento
*!*		Select  PORTA
*!*		miedad = (PORTA.fecmov-minac)/365

*!*		Replace sexo With misex, edad  With miedad

*!*		If !sp_busco_valores_antec(mireg, " and trim(TA_tipo) = 'P' ") && mwkAntecPac
*!*			Set Step On
*!*		Endif

*!*		Select mwkAntec
*!*		Index On Id Tag Id
*!*		Index On ta_padre Tag ta_padre
*!*		Select Padr(Transform(mwkAntec.ta_padre)  + Space(200),100) As Ubicacion, ;
*!*			nvl(AT_Valor,.F.) As valorb, ;
*!*			nvl(AT_opcion,0) As opcionb, ;
*!*			nvl(AT_Valor,.F.) As valorbOrig, ;
*!*			nvl(AT_opcion,0) As opcionbOrig, ;
*!*			nvl(AT_Obs,'') As valorc, ;
*!*			nvl(AT_Obs,'') As valorcOrig, ;
*!*			nvl(mwkAntecPac.Id,0) As IdAntPac, ;
*!*			mwkAntecPac.AT_Valor, ;
*!*			mwkAntecPac.AT_Obs, ;
*!*			nvl(mwkAntecPac.at_alert1,.F.) As at_alert1, ;
*!*			nvl(mwkAntecPac.at_alert1,.F.) As ValorAlertOrig1, ;
*!*			mwkAntecPac.at_alert As ValorAlertOrig, ;
*!*			mwkAntecPac.nombre, mwkAntecPac.At_FecAlta, mwkAntecPac.At_CodMed, AT_FPASIVA, ;
*!*			mwkAntec.* ;
*!*				from mwkAntecPac ;
*!*			left Join mwkAntec  On mwkAntecPac.AT_IdAnt = mwkAntec.Id Where AT_Valor =.T. Or !Empty(AT_Obs);
*!*			order By mwkAntec.TA_tipo, mwkAntec.ta_padre Asc, mwkAntec.TA_orden, mwkAntec.TA_descrip ;
*!*			into Cursor 'Mwkant'

*!*		Select mwkAntecPac
*!*		Use In Select('mwkAntecPac')
*!*		miant = ''
*!*		If Reccount('Mwkant')>0

*!*			Select Mwkant

*!*			Scan
*!*				miant = miant +Dtoc(At_FecAlta)+"->"+Left(NVL(nombre,''),20)+": "+Alltrim(NVL(TA_descrip,''))+;
*!*					" Obs:"+Alltrim(Left(NVL(AT_Obs,''),250))+Chr(13)
*!*			Endscan
*!*			Select PORTA
*!*			Replace antec With NVL(miant,"error")
*!*		Endif
	mvale = PORTA.vale
	micod = ''
	midiag = ''
	Requery('valediagno')
	Select valediagno
	If Reccount('valediagno')>0
*!*			Scan
*!*				If valediagno.ih_codcie >0
*!*					micod= valediagno.codcie10
*!*					midiag = valediagno.Descrip
*!*					Exit
*!*				Endif
*!*			Endscan
	Else
		Requery('valesdiagno')
		Select * From valesdiagno Into Cursor valediagno
	Endif
	If Empty(midiag)
		midiag = Nvl(valediagno.PAC_descripdiagegr,'')
	Endif
	Select  PORTA
	Replace  diagnos  With midiag
	Replace egreso With Nvl(valediagno.PAC_motivoalta,0),fecalta With Nvl(valediagno.PAC_fechaalta,Ctod("01/01/1900"));
	,fecingr With valediagno.PAC_fechaadmision

Endscan
Do sp_desconexion
Select *,Padr(Left(antec,200),200) As antec1,Padr(Substr(antec,201,200) ,200) As antec2,;
padr(Substr(antec,401,200) ,200) As antec3,Padr(Substr(antec,601,200) ,200) As antec4,Padr(Substr(antec,801,200) ,200) As antec5;
,Padr(Substr(antec,1001,200) ,200) As antec6 From PORTA Into Cursor portatot


Create Cursor admision (cuenta c(8),Docu N (15))
Select admin
Scan
	mnroreg = cuenta
	mret = SQLExec(mcon1, "select REG_tipodocumento, REG_numdocumento "+;
	" FROM pacientes,registracio "+ ;
	" where  PAC_codadmision  = ?mnroreg and PAC_codhci = REG_nroregistrac " +;
	" ","mwkbuspacie")
	If mret < 0
		=Aerr(eros)
		Messagebox(eros(3))
	Endif
	If Reccount( "mwkbuspacie")>0
		mdoc = Nvl(REG_numdocumento ,0)
		Select admision
		Replace Docu With mdoc
	Endif
Endscan

mcon1 = SQLConnect("conec01")
Select admin
Scan
	mnroreg = cuenta
	mret = SQLExec(mcon1, "select * "+;
	" FROM pacientes,registracio "+ ;
	" where  PAC_codadmision  = ?mnroreg and PAC_codhci = REG_nroregistrac " +;
	" ","mwkbuspacie")
	If mret < 0
		=Aerr(eros)
		Messagebox(eros(3))
	Endif
	If !Used('datos')
		Select * From mwkbuspacie Into Cursor datos
	Else
		Select * From mwkbuspacie Union All Select * From datos Into Cursor datos2
		Select * From datos2 Into Cursor datos

	Endif
Endscan

Do sp_desconexion

Do sp_conexion

Use c:\desaguemes\drogas.Dbf In 0 Exclusive
Dimension med(1)
Select drogas
Go Top
Dimension med[reccount()]
ii= 0
Scan
	ii = ii+1
	med(ii) = Alltrim(droga)
Endscan
Set Step On
Select endoc
Scan
	Wait Windows Transform(Recno()) Nowait
	mproto = protocolo
	mret = SQLExec(mcon1, "SELECT EAM_evol, EA_antecedentes,EA_exFisico, EA_motConsulta FROM TabAmbEvol "+;
	"left join TabAmbEvolMed on Tabambevol.EA_protocolo = Tabambevolmed.EAM_proto " + ;
	" where EA_protocolo = ?mproto  "+;
	"", "mwkEvolReg01")
	If Reccount('mwkEvolReg01')>0
		For RT = 1 To ii
			If At(med(RT),Upper(mwkEvolReg01.EAM_evol))>0 ;
				or At(med(RT),Upper(mwkEvolReg01.EA_antecedentes))>0 ;
				or At(med(RT),Upper(mwkEvolReg01.EA_exFisico))>0  ;
				or At(med(RT),Upper(mwkEvolReg01.EA_motConsulta ))>0
				Select endoc
				MICAMP = "med"+Transform(RT)
				Replace &MICAMP With 1
			Endif
		Next RT
	Endif
Endscan
Set Step On

Select *,Sum(med1) As JARDIANCE  ,Sum(med2) As JARDIANCEDUO  ,Sum(med3) As GALVUS   ,Sum(med4) As GALVUSMET   ,Sum(med5) As TRAJENTA;
,Sum(med6) As TRAYENTA,Sum(med7) As JANUVIA      ,Sum(med8) As JANUMET      ,Sum(med9) As INVOKANA     ,Sum(med10) As VOKANAMET    ;
,Sum(med11) As METFORMINA   ,Sum(med12) As DEGLUDEC     ,Sum(med13) As TRESIBA      ,Sum(med14) As LANTUS       ,Sum(med15) As TOUJEO       ;
,Sum(med16) As GLARGINA     ,Sum(med17) As NPH          ,Sum(med18) As INSULINANPH ,Sum(med19) As ASPARTICA ,Sum(med20)  As NOVORAPID       ;
from endoc Group By reg_nrohcl Into Cursor porpac

Select Int((Date()- reg_fecnac)/365) As edad,*,Sum(med1) As JARDIANCE  ,Sum(med2) As JARDIANCEDUO  ,Sum(med3) As GALVUS   ,Sum(med4) As GALVUSMET   ,Sum(med5) As TRAJENTA;
,Sum(med6) As TRAYENTA,Sum(med7) As JANUVIA      ,Sum(med8) As JANUMET      ,Sum(med9) As INVOKANA     ,Sum(med10) As VOKANAMET    ;
,Sum(med11) As METFORMINA   ,Sum(med12) As DEGLUDEC     ,Sum(med13) As TRESIBA      ,Sum(med14) As LANTUS       ,Sum(med15) As TOUJEO       ;
,Sum(med16) As GLARGINA     ,Sum(med17) As NPH          ,Sum(med18) As INSULINANPH ,Sum(med19) As ASPARTICA ,Sum(med20)  As NOVORAPID       ;
from endoc Group By edad Into Cursor poredad



Create Cursor Control (usuarioant c(50),usuarionue  c(50),fecha d,tipob N(2),bonoh N(10),bonod N(10),valor N(12),cantidad N(10))
Set Step On
Select * From tabdetallefact Group By BonoSerie,TipoBono Into Cursor TipoBono
Select tabdetallefact
Do While !Eof()
	mb = BonoSerie
	mt = TipoBono
	bd = BonoDesde
	bh =BonoHasta
	miusu = nomape
	mifac = nrocte
	valoru = ValorUni
	mife = fechacte
	Skip
	Do While !Eof() And  mb = BonoSerie And  mt = TipoBono
		If BonoDesde  = bh+1
		Else
			Requery('tabbonodet')
			If Between(Reccount('tabbonodet'),0,100)
				Insert Into Control Values (miusu,tabdetallefact.nomape,mife,mt,bh,tabdetallefact.BonoDesde,tabdetallefact.ValorUni,Reccount('tabbonodet'))
			Endif
		Endif
		mb = BonoSerie
		mt = TipoBono
		bd = BonoDesde
		bh =BonoHasta
		miusu = nomape
		mifac = nrocte
		valoru = ValorUni
		mife = fechacte
		Skip
	Enddo
Enddo



Do sp_conexion
Select  hclini
Scan
	mnrohclin = hclini.hclinica
	mret = SQLExec(mcon1, "select HIS_codentidad ,HIS_fechaadmision "+;
	" FROM Registracio,histambgua "+ ;
	" where  his_nroregistrac = REG_nroregistrac and "+;
	" REG_nrohclinica  = ?mnrohclin " ,"mwkbuspacie")
	If Reccount( "mwkbuspacie")>0
		Go Bott
		mcodent  = HIS_codentidad
		Select  hclini
		Replace codent With mcodent
	Endif
Endscan
Do sp_desconexion

Do sp_conexion
Set Step On
Select unif
Scan

	mctexto = hclin
	mret = SQLExec(mcon1,"select REG_nrohclinica, REG_nombrepac" + ;
	" FROM registracio " + ;
	" where REG_nrohclinica = ?mctexto ", "mwkbuspacie")
	Select  unif
	If Reccount( "mwkbuspacie")>0
		Replace corregir With 1
	Endif
Endscan

Do sp_desconexion


Select pac19
Scan
	npac =  Alltrim(pac19.pac)
	Requery('regisll')
	Select regisll
	If Reccount('regisll')>0
		If Val(Nvl(regisll.REG_cuit,''))<10
			micuit = prg_calculo_cuit(regisll.REG_sexo,regisll.REG_numdocumento)
		Else
			micuit = Nvl(regisll.REG_cuit,'')

		Endif
		mihc = regisll.REG_nrohclinica
		Select pac19
		Replace cuit With micuit,hclin With mihc
	Endif
	Select pac19

Endscan

Select tipom
Scan
	miprest = codigo
	mitipo = tipo_actua
	Update prestacion Set PRE_TipoMuestra = mitipo Where PRE_codprest = miprest
Endscan
Select arre
Scan
	miprest = PRE_codprest
	mitipo = Nvl(PRE_TipoMuestra ,1)
	Update prestacion Set PRE_TipoMuestra = mitipo Where PRE_codprest = miprest
Endscan



Select servi
Scan
	micta = episodio
	Requery('tabintserv')
	Select tabintserv
	If Reccount('tabintserv')>0
		miserv = tabintserv.codesp
	Else
		miserv  = 'XXX'

	Endif
	Select servi
	Replace servi  With miserv

	Select servi

Endscan

Select anulados
Scan
	mvale =  ep_usuario
	If mvale>0
		Requery('vale_proto')
		Select vale_proto
		If Reccount('vale_proto')>0
			mestado = vale_proto.VAL_estado
			mfecsol = vale_proto.VAL_fechasolicitud
			mhorasol = vale_proto.VAL_horasolicitud
			mfecconf =   vale_proto.VAL_fechaconforme
			mhoraconf = vale_proto.VAL_horaconforme
			msec = vale_proto.VAL_codsector
			Select anulados
			Replace VAL_estado With mestado ,VAL_fechas With mfecsol ,VAL_horaso With mhorasol ;
			VAL_fechac With mfecconf ,VAL_horaco With mhoraconf ,VAL_codsec With msec
		Endif
	Endif
	Select anulados

Endscan
Select anulados.*,PRE_descriprest,SER_descripserv From anulados,prestacion Where ep_codpres = PRE_codprest

Select altas
Scan
	mepi = episodio
	Requery('pacbristolalta')
	If Reccount('pacbristolalta')>0
		miest =pacbristolalta.MTE_Descripcion
		mifec = pacbristolalta.PAC_fechaalta
		mihora = Ttoc(pacbristolalta.PAC_horaalta,2)
		Select altas
		Replace fecha With mifec,hora With mihora,estado With miest
	Endif
Endscan

Do sp_conexion
mfechahoy  = Ctod("01/06/2020")
Select  hotelbys
Set Step On
Scan
	mnro = hotelbys.dni

	mnroreg =hotelbys.nreg
	Requery('regishc')
	If Reccount('regishc')= 0 Or Reccount('regishc')>1
		Set Step On
	Endif
	Select regishc
	mnroreg = REG_nroregistrac
	minom =  REG_nombrepac
	mihc =  REG_nrohclinica
	msex =  REG_sexo
	mfecnac = REG_fecnacimiento
	mint = !Empty(hotelbys.hcli)
	mcodent  = hotelbys.entidad
	madm = Alltrim(hotelbys.admision)

	If mint
		mret = SQLExec(mcon1, "select PAC_fechaadmision, PAC_horaadmision, PAC_fechaalta, PAC_codhci, PAC_codadmision,pac_motivoalta "+;
		" FROM pacientes "+ ;
		" where  PAC_codadmision= ?madm  " +;
		" order by PAC_fechaadmision desc","mwkctainteralta")
		If Reccount("mwkctainteralta")>0
			mnroadm = mwkctainteralta.PAC_codadmision
			mret = SQLExec(mcon1,"SELECT Coberturas.*, Pacientes.* "+;
			"FROM Coberturas  "+;
			" INNER JOIN Pacientes ON  COB_PACIENTES = PAC_codadmision  "+;
			" WHERE  PAC_codadmision  = ?mnroadm order by cob_fechacomcob desc ","mwkcober")
			mcodent  = COB_codentidad
			mcondiva = COB_CondicImpositiva
			mnroadm = PAC_codadmision
		Else
			Set Step On
		Endif
	Else
		miproto = madm
		Requery('guardia_vales')
		mnroreg =guardia_vales.nroregistrac
		mnroadm =guardia_vales.VAL_codadmision

		mret = SQLExec(mcon1, "select PAC_fechaadmision, PAC_horaadmision, PAC_fechaalta, PAC_codhci, PAC_codadmision "+;
		", HIS_codentidad, HIS_codcontrato, PAC_tipopaciente,HIS_fechaadmision,Entidcontr2.TIPO,HIS_CondicImpositiva  "+;
		" FROM histambgua join pacientes on pacientes.pacientes =  histambgua.HIS_codadmision "+ ;
		" inner join Entidcontr2 on Entidcontr2.CONTRATO = histambgua.HIS_codcontrato "+;
		" where  HIS_nroregistrac= ?mnroreg   " +;
		"  and HIS_codadmision = ?mnroadm  "+;
		" order by PAC_fechaadmision desc ","mwkctasamb")

		Select mwkctasamb
		mcodent  = HIS_codentidad
		mcondiva = HIS_CondicImpositiva
		mnroadm = PAC_codadmision
	Endif

	Select  hotelbys
	Replace entidad With mcodent,fecnac With mfecnac ,condiva With mcondiva ,admision With mnroadm ;
	nombre With minom

Endscan
Do sp_desconexion


Do sp_conexion
Set Step On
mfechahoy  = Ctod("01/06/2020")
Select  admis
Scan
	mnro = admis.hclin
	mnroadm = admis.admision

	Requery('regishc')

	Select regishc
	mnroreg = REG_nroregistrac
	Requery('cober')
	If Reccount('cober')>0
		Select admis
		Replace condiva With cober.COB_CondicImpositiva
	Endif

Endscan

Do sp_desconexion

Set SEPLIN="<br/>"_$Char(10)_$Char(13)

Set ASUNTO="Sanatorio Güemes - Hospedaje de Paciente: "_NOM
//** Cuerpo del Mensaje:
Set Cuerpo="Hospedaje de Paciente de Sanatorio Güemes:"_SEPLIN_SEPLIN
Set Cuerpo=CUERPO_"Nombre: "_NOM_SEPLIN
Set Cuerpo=CUERPO_"D.N.I: "_NRODOC_SEPLIN
Set Cuerpo=CUERPO_"Género: "_$S(sexo="M":"MASCULINO",sexo="F":"FEMENINO",1:"")_SEPLIN
Set Cuerpo=CUERPO_"Fec.Nacim.: "_$ZD(FECNACIM,4)_"  (Edad: "_EDAD_")"_SEPLIN
Set Cuerpo=CUERPO_"Domicilio: "_DOMIC_SEPLIN
Set Cuerpo=CUERPO_"Obra Social/Prepaga: "_DESCRIENT_SEPLIN
Set Cuerpo=CUERPO_"Nro.afiliado: "_AFI_SEPLIN
Set Cuerpo=CUERPO_"Condicion impositiva: "_CONDIMPO_" - "_DCONDIMPO_SEPLIN
Set Cuerpo=CUERPO_"Historia Clinica: "_HCE_SEPLIN
Set Cuerpo=CUERPO_"Nro.Admisión S.G.: "_NROADM_SEPLIN_SEPLIN
Set Cuerpo=CUERPO_"Coordinación Administrativa"_SEPLIN
Set Cuerpo=CUERPO_"Sanatorio Güemes"_SEPLIN
Set Cuerpo=CUERPO_"(Mensaje generado automáticamente)"_SEPLIN_SEPLIN_SEPLIN
Select seguim
Scan
	mireg = nroregistrac
	Update hotelbys Set fecnac= Ttod(seguim.fechahoraing) Where nreg = mireg
Endscan


Do sp_conexion
mfechahoy  = Ctod("01/06/2020")
Select  hotelbys
Set Step On
Scan
	mnroreg = hotelbys.nreg
	mcodent = hotelbys.entidad
	Requery('afiliados')

	miafi = afiliados.AFI_nroafiliado

	Select  hotelbys
	Replace nroafi With miafi
Endscan



Select  hotelbys
Set Step On
Scan
	mnro = hotelbys.dni

	Requery('regishc')
	If Reccount('regishc')= 0 Or Reccount('regishc')>1
		Set Step On
	Endif
	Select regishc
	mnroreg = REG_nroregistrac
	minom =  REG_nombrepac
	mihc =  REG_nrohclinica
	msex =  REG_sexo
	mfecnac = REG_fecnacimiento
	Select  hotelbys
	Replace nreg With mnroreg ,hcli With mihc
Endscan


Select  docus
Set Step On
Scan
	mnro = docus.documento

	Requery('regishc')
	If Reccount('regishc')= 0 Or Reccount('regishc')>1

	Endif
	Select regishc

	mihc =  Nvl(REG_nrohclinica,'')

	Select  docus
	Replace  hclin With mihc
Endscan


Do sp_conexion
Select admision
Scan
	mnroadm = admision.protocolo
	mret = SQLExec(mcon1,"SELECT Coberturas.*, Pacientes.* "+;
	"FROM Coberturas  "+;
	" INNER JOIN Pacientes ON  COB_PACIENTES = PAC_codadmision  "+;
	" WHERE  PAC_codadmision  = ?mnroadm order by cob_fechacomcob desc ","mwkcober")
	mcodent  = COB_codentidad
	mestado = pac_motivoalta
	mdiagno = PAC_codcie10diagegr
	malta = pac_fechaalta
	Select admision
*replace entidad WITH mcodent,diagno WITH NVL(mdiagno,0),estado WITH NVL(mestado,0),alta WITH malta
	Replace nombre With mwkcober.pac_nombrepaciente hclin With mwkcober.pac_codhce
Endscan
Do sp_desconexion

Browse Last
Select prestadores.*,idusuario,nomape,codigovax From prestadores Left Join tabusuario On prestadores.Id = idcodmed Where prestadores.Id>1Into Cursor prestausu
Select prestadores.*,idusuario,nomape,codigovax From prestadores;
LEFT Join tabusuario On prestadores.Id = idcodmed Where prestadores.Id>1 Into Cursor prestausu
Browse Last
Select * From prestadores Group By Id Having Count(Id)>1
Select * From  ficha_covid,prestausu Where NomApeNotifica= nombre And prestausu.Id>1 Group By ficha_covid.Id Into Cursor alcoyana
Browse Last

Select alcoyana
Scan

	mid = id_a
	usuario = idusuario
	Update ficha_covid Set cov_usuario = usuario Where Id = mid

Endscan
Select ficha_covid
Update ficha_covid Set cov_usuario ='SVINUEZA' Where NomApeNotifica='VINUEZA BUITRON STEPHANIE CAROLINA'
Locate For NomApeNotifica='VINUEZA BUITRON STEPHANIE CAROLINA '


Do sp_conexion
mfechahoy  = Ctod("01/06/2020")
Select  Docu
Set Step On
Scan
	mnroreg = Docu.Docu
	Requery('afiliados')

	miafi = afiliados.AFI_nroafiliado

	Select  Docu
	Replace nroafi With miafi,enti With afiliados.afi_codentidad
Endscan

Select  sinalta
Scan

	mnroadm = sinalta.episodio

	Requery('pacientes')


	If Reccount('pacientes')>0
		Select sinalta
		Replace fechaalta With pacientes.PAC_fechaalta , horaalta With Ttoc(pacientes.PAC_horaalta,2), motivo With pacientes.MTE_Descripcion
	Endif
Endscan

Do sp_conexion
Set Step On
Select historias
Go Top
*GO bottom
Do While !Eof()

	mnroreg = Alltrim(hclin)
	mret = SQLExec(mcon1, "select PAC_codhci ,PAC_fechaadmision, PAC_horaadmision, PAC_fechaalta, PAC_codhci, PAC_codadmision  "+;
	" FROM pacientes,registracio "+ ;
	" where  REG_nrohclinica = ?mnroreg and PAC_codhci = REG_nroregistrac and PAC_Tipopac <=1 " +;
	" ","mwkbuspacie")
	If mret < 0
		=Aerr(eros)
		Messagebox(eros(3))
	Endif
	Select historias
	If Reccount( "mwkbuspacie")>0
		Select mwkbuspacie
		Go Bott
		Select historias
		Replace interna  With mwkbuspacie.PAC_codadmision  ,fecadm ;
		With Nvl(mwkbuspacie.PAC_fechaadmision,Date()),fecalta With Nvl(mwkbuspacie.PAC_fechaalta,Date())
	Endif
	Skip
Enddo

Do sp_desconexion
Do sp_conexion
mfecnul = Ctod("01/01/1900")
Set Step On
Select  condicion
Scan
	mnrohclin = condicion.REG_nroregistrac
	mret = SQLExec(mcon1, "select RCE_fechadesde,RCE_fechahasta,RCE_nroCertificado,RCE_tipoCondesp "+;
	" FROM Zabregcondesp  "+ ;
	" where   RCE_registracio= ?mnrohclin and RCE_tipoCondesp = 3 and RCE_fechahasta>{fn curdate()} " ,"mwkbuspacie")
	Select condicion
	If Reccount( "mwkbuspacie")>0

		Replace reg_fecregistra With mwkbuspacie.RCE_fechadesde,reg_fechaalta With mwkbuspacie.RCE_fechahasta
	Else
		Replace reg_fecregistra With mfecnul ,reg_fechaalta With mfecnul
	Endif
Endscan
Do sp_desconexion


Select  partos
Scan
	If nregbb=0
		dni = partos.dnibb

		Requery('regishc')
		regbb =regishc.REG_nroregistrac
		dni = partos.dnimm

		Requery('regishc')
		regmm =regishc.REG_nroregistrac
		mireg = regmm
		Requery('pacientes')
		If Reccount('pacientes')>0
			Select partos
			Replace nregbb  With  regbb  , nregmm With regmm
		Else
			Set Step On
		Endif
	Endif
Endscan


Select  partos
Scan
	Requery('pacientes2')
	regbb =pacientes2.PAC_nombrepaciente

	Select partos
	Replace madre  With  regbb

Endscan


Select unifica
Set Step On
Scan

	hclin = ALLTRIM(unifica.zdp_hclinica)

	Requery('view130')

	Requery('ctrlunif')
	If Reccount('ctrlunif')>0
		hclinn= ALLTRIM(ctrlunif.REG_nrohclinicaO)
		Select view130
		Replace zdp_hclinica With hclinn
		Select unifica
	Else
		Select unifica
		Replace verif With 0
	Endif
Endscan


SELECT pacsap
SCAN
REQUERY ('view46')
replace hclin WITH view46->pac_codhce, ndoc WITH view46->reg_numdocumento

ENDSCAN




Select valor
Scan

	Requery ('view1')
	If Reccount('view1')=1
		Replace   nhc With view1->REG_nrohclinica
	Else
	*	Set Step On
		Select view1
		Go Top
		Select valor
		Replace   nhc With view1->REG_nrohclinica
		Select * From dobles Union All  Select * From view1 Into Cursor dobles

	Endif
Endscan


Do sp_conexion

Set Step On
Select  pacintreg_qas 
Scan
	mnrohclin = pacintreg_qas .REG_nroregistrac
	mret = SQLExec(mcon1, "UPDATE  REGISTRACIO SET REG_telefonos ='1144704384' "+ ;
	" where   REG_nroregistrac = ?mnrohclin  "  )
 
Endscan
Do sp_desconexion

