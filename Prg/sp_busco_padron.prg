*********************************************************************************
* BUSCA PACIENTES                                            *
*********************************************************************************
Parameter mbusco1, mcnombre,xncodent,xfechapas,xnroreg
If Used('mwkexe')
	miexe = mwkexe.nomexe
Else
	miexe = Iif(Type('miexe')#"C","Sistema",miexe)
Endif
lretactivo = .T.
If Vartype(xfechapas)="D"
	lpasivafi = (xfechapas<>Ctod(' /  /  '))
Else
	lpasivafi = .F.
Endif
If Vartype(xncodent)<>"N"
	xncodent=0
Endif
If Vartype(mbusco1)<>"C"  &&&& si o si debe buscar algo
	Return .F.
Endif
If Empty(mbusco1)   &&&& si o si debe buscar algo
	Return .F.
Endif
If Vartype(mcodent)<>"N"
	mcodent = xncodent
Endif
If Vartype(xnroreg)<>"N"
	xnroreg = 0
Endif


msel = Iif(mxambito = 1 ,mxcentromedico,mxambito )
Do sp_busco_estados With 57,' and tipo = 22 order by subestado','mwkhabpadmk'&&
mientmk = 0
If   xncodent>0  &&& busco xMK
	Select mwkhabpadmk
	Scan
		If  mwkhabpadmk.subestado = msel And mwkhabpadmk.estado>1
			mides = Alltrim(mwkhabpadmk.Descrip)
			If  Inlist(xncodent, &mides )
				mientmk = mwkhabpadmk.estado
			Endif
		Endif
	Endscan
Endif
nalerta = 0
lcStringConn = ''
*do buscoini with upper(miexe)
*messagebox(lcStringConn)
midiahoy = sp_busco_fecha_serv("DD")
mret = SQLExec(mcon1,"select ID , Apellido , grupofamiliar, ApeyNom , CUIL , Credencial , Documento  "+;
	", Entidad, FecEgreso , FecIngreso , FecNac , Nombre , NroAfiliado ,ENT_tipo,ENT_nroprestadorexterno "+;
	", NroAfiliadoAlternativo , Plan , PlanAlternativo , Sexo , TipoDocumento,ent_descrient,pmi,antecedentes,FecValidacion,AFTipoAfiliacion  "+;
	" FROM PadCabe left join entidades  on entidad = ent_codent " + mbusco1 +" order by FecEgreso " , "mwkbuspadron")

If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

msql_pad = 'select NroAfiliado,ApeyNom,abrevio,Documento,FecIngreso,'+;
	'iif(FecEgreso=ctod("01/01/2100"),space(10),dtoc(FecEgreso)) as FechaHasta ,'+;
	' CUIL, ent_descrient,FecNac, Plan  , Entidad, '+;
	" mwkdocu.ID , Apellido , grupofamiliar, Credencial , Nombre , NroAfiliadoAlternativo "+;
	", PlanAlternativo , Sexo , FecEgreso,TipoDocumento,mwkbuspadron.id as idpad,pmi,AFTipoAfiliacion,antecedentes,FecValidacion "+;
	' from mwkbuspadron,mwkdocu  '+;
	' where TipoDocumento = codigovax  '+;
	'ORDER BY ApeyNom into cursor mwkbuspadron1 '
Select mwkbuspadron
Go Bottom
If myip='172.16.1.7'
*	Set Step On
Endif
If 	lpasivafi
	mctrlfecha = ' xfechapas <= midiahoy '
Else
	mctrlfecha = " 1=1"
Endif
If mientmk >0 And ( Nvl(mwkbuspadron.FecValidacion ,Ctod("01/01/1900"))<midiahoy Or Evaluate(mctrlfecha ) )
	Use In Select('mwkjson')
	mkafi = mwkbuspadron.NroAfiliado
	mtipodocmk = TipoDocumento(Val(Transform( mwkbuspadron.TipoDocumento)))
	Do prg_mk_elegibilidad With mkafi ,mtipodocmk ,mwkbuspadron.Documento,mientmk
	If Used('mwkjson')
*	 (estado c(10),mensaje c(50),transaccion c(20),broker c(50),autoriza c(20),ntrans c(20))
		mhoy =sp_busco_fecha_serv("DD")
		If Used('mwkbuspadron')
			If Empty(Fields('id','mwkbuspadron'))
				mret = SQLExec(mcon1,"select ID , Apellido , grupofamiliar, ApeyNom , CUIL , Credencial , Documento  "+;
					", Entidad, FecEgreso , FecIngreso , FecNac , Nombre , NroAfiliado ,ENT_tipo,ENT_nroprestadorexterno "+;
					", NroAfiliadoAlternativo , Plan , PlanAlternativo , Sexo , TipoDocumento,ent_descrient,pmi,antecedentes,FecValidacion,AFTipoAfiliacion  "+;
					" FROM PadCabe left join entidades  on entidad = ent_codent " + mbusco1 +" order by FecEgreso " , "mwkbuspadron")

			Endif
			mid = mwkbuspadron.Id
			mret = SQLExec(mcon1,"update PadCabe set FecValidacion = ?midiahoy where id  =?mid")
		Endif
		Do Case
		Case Upper(mwkjson.estado)="ERROR"
			If !Used('mwkbuspadron')
				Messagebox("VERIFIQUE PADRON ON LINE. AFILIADO DADO DE BAJA",16,"Control de Afiliados")
			Else
				If mwkbuspadron.FecEgreso >= mhoy
					If Empty(Fields('id','mwkbuspadron'))
						mret = SQLExec(mcon1,"select ID , Apellido , grupofamiliar, ApeyNom , CUIL , Credencial , Documento  "+;
							", Entidad, FecEgreso , FecIngreso , FecNac , Nombre , NroAfiliado ,ENT_tipo,ENT_nroprestadorexterno "+;
							", NroAfiliadoAlternativo , Plan , PlanAlternativo , Sexo , TipoDocumento,ent_descrient,pmi,antecedentes,FecValidacion,AFTipoAfiliacion  "+;
							" FROM PadCabe left join entidades  on entidad = ent_codent " + mbusco1 +" order by FecEgreso " , "mwkbuspadron")

					Endif
					mid = mwkbuspadron.Id
*!*					mret = SQLExec(mcon1,"update PadCabe set FecEgreso = ?mhoy where id  =?mid")
*!*					mret = SQLExec(mcon1,"update Padvigencia set fechahasta = ?mhoy "+;
*!*					"where idpadcabe =?mid and fechahasta >=?mhoy")
					Messagebox("VERIFIQUE PADRON ON LINE. AFILIADO DADO DE BAJA",16,"Control de Afiliados")
					mret = SQLExec(mcon1,"select ID , Apellido , grupofamiliar, ApeyNom , CUIL , Credencial , Documento  "+;
						", Entidad, FecEgreso , FecIngreso , FecNac , Nombre , NroAfiliado ,ENT_tipo,ENT_nroprestadorexterno "+;
						", NroAfiliadoAlternativo , Plan , PlanAlternativo , Sexo , TipoDocumento,ent_descrient,pmi,AFTipoAfiliacion,antecedentes,FecValidacion  "+;
						" FROM PadCabe left join entidades  on entidad = ent_codent " + mbusco1 +" order by FecEgreso " , "mwkbuspadron")
				Endif
			Endif
		Case  Upper(mwkjson.estado)="OK"
			mtipoaf = mwkjson.tipoaf
			If Inlist(mtipoaf ,'MO','PS')
				elplan = 152
			Else
				elplan = 151
			Endif
			mid = mwkbuspadron.Id
			If mwkbuspadron.FecEgreso <= mhoy
				mret = SQLExec(mcon1,"update PadCabe set FecEgreso = '2100-01-01',plan = ?elplan ,AFTipoAfiliacion= ?mtipoaf where id  =?mid")
				mret = SQLExec(mcon1,"insert into Padvigencia (FechaDesde, FechaHasta,IdPadCabe) "+;
					" values ( ?mhoy,'2100-01-01',?mid) " )
				mret = SQLExec(mcon1,"select ID , Apellido , grupofamiliar, ApeyNom , CUIL , Credencial , Documento  "+;
					", Entidad, FecEgreso , FecIngreso , FecNac , Nombre , NroAfiliado ,ENT_tipo,ENT_nroprestadorexterno "+;
					", NroAfiliadoAlternativo , Plan , PlanAlternativo , Sexo , TipoDocumento,ent_descrient,pmi,AFTipoAfiliacion,antecedentes,FecValidacion  "+;
					" FROM PadCabe left join entidades  on entidad = ent_codent " + mbusco1 +" order by FecEgreso " , "mwkbuspadron")
			Else
				mret = SQLExec(mcon1,"update PadCabe set  plan = ?elplan ,AFTipoAfiliacion= ?mtipoaf where id  =?mid")
				mret = SQLExec(mcon1,"select ID , Apellido , grupofamiliar, ApeyNom , CUIL , Credencial , Documento  "+;
					", Entidad, FecEgreso , FecIngreso , FecNac , Nombre , NroAfiliado ,ENT_tipo,ENT_nroprestadorexterno "+;
					", NroAfiliadoAlternativo , Plan , PlanAlternativo , Sexo , TipoDocumento,ent_descrient,pmi,AFTipoAfiliacion,antecedentes,FecValidacion  "+;
					" FROM PadCabe left join entidades  on entidad = ent_codent " + mbusco1 +" order by FecEgreso " , "mwkbuspadron")
			Endif
			If 	lpasivafi
				nelplan =  Transform(elplan)
				mafi = mwkbuspadron.NroAfiliado
				mnroreg = xnroreg
				mcodenti = Transform(xncodent)
				mret = SQLExec(mcon1,"update Afiliacion set AFI_nroafiliado= ?mafi,AFI_fechabaja = NULL  , AFI_idplan = ?elplan "+;
					" WHERE  Afiliacion.REGISTRACIO = ?mnroreg "+;
					" AND  Afiliacion.AFI_codentidad = ?mcodenti " )
				lretactivo =  Nvl(mwkbuspadron.plan,0)
			Endif
		Endcase
	Endif
Endif
Return lretactivo

Function TipoDocumento(lnTipo)
Do Case
Case lnTipo = 1
	lcResu = 4 &&	Libreta de Enrolamiento
Case lnTipo = 2
	lcResu = 5 && 	Libreta cívica
Case lnTipo = 3
	lcResu = 3 &&	Cédula de identidad
Case lnTipo = 4
	lcResu = 1 && 	Documento Nacional de Identificación
Case lnTipo = 5
	lcResu =8 &&	Pasaporte
Case lnTipo = 6
	lcResu = 9 &&	Libreta de Matrimonio
Case lnTipo = 7
	lcResu = 9 &&	Libreta Familiar
Case Inlist(lnTipo ,8 ,9)
	lcResu = 9 &&	Otros
Otherwise
	lcResu = 9

Endcase
Return lcResu
