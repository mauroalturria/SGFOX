Select * From mwksep_presta Into Cursor mwksep_prestatm
Select Distinc TipoMuestra From mwksep_presta Into Cursor mwktipom
Select mwktipom
Go Top
madmision = .txtcuenta.Value
Scan
	mstrprest	= ""
	mtipom = TipoMuestra
	Select * From mwksep_prestatm Where TipoMuestra = mtipom And lsel = 1 Into Cursor mwksep_prestag
	Select mwksep_prestag
	Go Top
	Select * From mwksep_prestag Group By codprest Into Cursor mwksep_presta
	Select mwksep_presta
	Go Top
	Do While !Eof('mwksep_presta')

		mstrprest = ''
		mcodprest = mwksep_presta.codprest
		mserv = Transform(mwksep_presta.codserv)
		mlsolopend = .T. && solo pendientes
		Do sp_busco_vale_Pac_ins With 2, Alltrim(madmision ),mcodprest ,sp_busco_fecha_serv("DD"),mlsolopend
		mespecia = mwksep_presta.espec
		lsigue = .T.
		If Reccount('mwktodopres')>0
			Select mwktodopres
			Scan
				mvalant = Transform(mwktodopres.VAL_codvaleasist)+" de Fecha: "+;
				Dtoc(mwktodopres.VAL_fechasolicitud)+" "+Transform(mwktodopres.VAL_horasolicitud)+;
				" Nro Protocolo :"+ Transform(mwktodopres.VAL_NroProtocolo)
				Messagebox("YA SE SOLICITÓ ESTA PRESTACION Y ESTA PENDIENTE EN VALE" + Chr(13)+;
				mvalant ,16,"Control de Ingreso")
			Endscan
			If Messagebox("INGRESA UN NUEVO VALE?",4+32,"Control de Ingreso")<>6
				lsigue = .F.
			Endif
		Endif
		If lsigue
			mstrprest	= mstrprest + Allt(Str(mwksep_presta.codprest,10)) + Chr(9) + ;
			allt(Str(mwksep_presta.CANTID, 2)) + Chr(1)
			mconta = mconta	 + 1
		Endif
		Skip 1 In mwksep_presta
	Enddo

	mcodsoli= Alltrim(Transform(.lncodmed))
	mvalida	= '1'
	moper	= Allt(Str(Iif(mwkusuario.codigovax = 0, 99999, mwkusuario.codigovax), 5))
	mok = 0
	mfecha 	= Dtoc(.txtfecha.Value)
	mhora   = .txthora.Value
	murg 	= '0'
	msolic 	= mcodsoli
	mcoment = Alltrim(.edit1.Value)
	mclasecober	= mkwcondicion_Impositiva.cEquiv_SAP
	mcoment = "("+Alltrim(mclasecober)+")"+ Alltrim(mcoment )
	mcontrolpend = '1'

	.olevism.Code = "D VALEINT^RTN030(" + mgraba +',"'+ madmision + '","'+ mfecha +;
	'","' + mhora+ '","' + mserv + '","' +  msolic + '",'+ mstrprest + ;
	',"'+ murg + '","'+ mcoment+ '","'	+ moper + '",'+ mcontrolpend +')'
	.olevism.execflag = 1
	mmsgerr = .olevism.errorname


	If !Empty(mmsgerr)
		Select mwkusuario
		Go Top
		midusua     = mwkusuario.idusuario
		Do sp_insert_tabCtrlErr With .olevism.Code,  mmsgerr , midusua, .Name
		Messagebox ("ERROR EN LA GRABACION. AVISAR A SISTEMAS", 48, 'Validacion')
		ltodok = .F.
	Endif

	mok	= .olevism.P0
	If .olevism.P0 <> ''
		mcoderr = Round(Val(.olevism.P0), 0)
		Do sp_busco_texto_error With mcoderr
		Messagebox(Alltrim(mwktaberror.textoerror), 48, 'Validacion')
		ltodok = .F.
	Endif

	If ltodok
		mresp	= .olevism.P1
		mrespv 	= mresp
		Do prg_separo_codvale With mresp
		mvale       = Transform(vec_vale(1,2))
		Select mwkusuario
		Go Top
		mcodvax		= Iif(mwkusuario.codigovax = 0, '99999', Str(mwkusuario.codigovax, 5))
		midiusu     = mwkusuario.idusuario
		i = 1
		mvale1 = 0

		Do While vec_vale(i,2) > 0

			Do While vec_vale(i,2) > mvale1

				Store '' To dat_vale
				Store '' To item_vale

				mvale1 = vec_vale(i,2)
				mvale  = Alltrim(Str(vec_vale(i,2)))
				dat_vale(1) = mvale
				.olevism.Code = "D DATVALE^SP001(" +  mvale + ")"
				.olevism.execflag = 1

				mmsgerr = .olevism.errorname

				If !Empty(mmsgerr)

					Select mwkusuario
					Go Top
					midusua     = mwkusuario.idusuario
					Do sp_insert_tabCtrlErr With .olevism.Code,  mmsgerr , midusua, .Name
					Messagebox ("No se pudo reuperar el vale. AVISAR A SISTEMAS", 48, 'Validacion')

					Loop
				Else

					mok		= .olevism.P0
					mresp1	= .olevism.P1
					mresp2	= .olevism.p2
					nroitem = 0
					Do prg_separo_datosvale With mresp1, mresp2,nroitem
					Messagebox ("SE GENERÓ EL VALE..."+Transform(dat_vale(1))+" Protocolo:"+Transform(dat_vale(16)), 64, 'Control de Vales')
					If Used('mwkusuarios')
						muser   = mwkusuarios.idusuario
						mcodigo = mwkusuarios.Codigovax
						moper		= Iif(mwkusuarios.Codigovax = 0, '99999', Str(mwkusuarios.Codigovax, 5))
					Else
						muser   = mwkusuario.idusuario
						mcodigo = mwkusuario.Codigovax
						moper		= Iif(mwkusuario.Codigovax = 0, '99999', Str(mwkusuario.Codigovax, 5))
					Endif
					mcodpun = Val(dat_vale(25))
					minicio = 0
					mICcodpun = mcodpun
					mfecmov = sp_busco_fecha_serv("DT")
					msubestado = 0
					mobserv = ''
					mevoluc = "Operador : "+muser+", "+Ttoc(mfecmov)+" - Estado, PENDIENTE , "+Alltrim(.edit1.Value)
					msubest = 0&& thisform.mwkpacintadorg
					mret = 0
					mimedasig = 306
					Do sp_grabo_monitor1_obsval2 With 1,mcodigo,mcodpun,mobserv,mfecmov,msubestado;
					,mevoluc, mimedasig,mfecmov
					If mret < 0
*						Return
					Endif
				Endif
				Select mwkusuario
				Go Top

				i = i + 1
			Enddo
			i = i + 1
		Enddo
	Endif
Endscan



