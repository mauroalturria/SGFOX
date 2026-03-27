lparameters mformori,mrutina,mbusco,lcontrol
thisform.cambios = 0

micode = ''
ldocerr = .f.   && si encuentra al afiliado por afiliado
lexiste = .t.
lsigue 	= .t.
mresp1 = 0
mcodenti = transf(mcodent)
with mformori
	vnrodoc = iif(vartype(.txtnrodoc)="O",".txtnrodoc.value",;
		iif(vartype(.txtnrodocu)="O",".txtnrodocu.value",'1'))
	if vartype(.olevism)#"O"
		mformuo = "thisform.olevism"
	else
		mformuo = ".olevism"
	endif
	do case
		case mrutina ="WS"
			do while lsigue
				if mwkusuario.idusuario = 'CFUNES'
	*			set step on
				endif
*!*			msql_reg = "select REG_nombrepac, " + ;
*!*				"REG_numdocumento, AFI_fechabaja, " + ;
*!*				"AFI_nroafiliado,
				with &mformuo
					.mserver 	= allt(mwktabcfg.oleserver)
					.namespace 	= allt(mwktabcfg.olespaces)
				endwith
				do case
					case inlist(mbusco, 1,3,4,5,7,8)
						mdoc =  iif(lcontrol,alltrim(transf(mwkbuspacie1.REG_numdocumento));
							,alltrim(transf(&vnrodoc)))
						mafi = ' '
					otherwise
						mdoc =  '-1'
						mafil =  iif(lcontrol,alltrim(transf(mwkafient1.AFI_nroafiliado));
							,alltrim(transf(.txtafiliado.value)))
						mafi = padl(strtran(alltrim(mafil)," -/",""),12,"0")
						mafi = left(mafi,7) + "-" + substr(mafi,8)
				endcase
				a= 1
				wait windows "Accediendo a Hominis Online... Aguarde" nowait
				with &mformuo
					.code = 'D CONSULTA^RTNPAD('+mdoc+',"'+ mafi + '")'
					.execflag = 1
					mresp = .P0					&& Codigo de error
				endwith
				mnroitem  = 1
				store '' to dat_ws
				do while len(mresp) > 4
					mnroitem  = mnroitem + 1
					mcontad  = atc("|", mresp)
					if mcontad>0
						dat_ws( mnroitem )= alltrim(left( mresp, mcontad - 1  ))
						mresp = substr( mresp, mcontad + 1 )
					else
						dat_ws( mnroitem )= alltrim(mresp)
						mresp= ''
					endif
				enddo
				wait clear
				create cursor mwkdatpadron (NroAfiliado n(20), ApeyNom c(50), ;
					abrevio c(20),Documento n(20), FecIngreso d(8), FecEgreso d(8), ;
					CUIL n(17,2), ent_descrient c(50), FecNac d(8), Codigo n(4), ;
					Domicilio c (50),Localidad c (50), Provincia c(50),Telefono c(50),;
					sexo c(1),plan c(50),tipodocumento n(1),entidad n(4),id n(5))
				if mnroitem  > 20
					if used('mwkafient1')
						do sp_grabo_WS with mbusco,iif(lcontrol,mwkafient1.AFI_nroafiliado,0);
							, mwkbuspacie1.REG_nombrepac, iif(lcontrol,mwkafient1.AFI_fechabaja,ctod("01/01/1900"));
							,mwkbuspacie1.REG_numdocumento,nvl(mwkbuspacie1.REG_distrito,'0')
					else
						do sp_grabo_WS with mbusco,0, .txtnombre.value , ctod("01/01/1900");
							, &vnrodoc,'0'
					endif
					if !empty(dat_ws(4))
						ltucuman = (alltrim(dat_ws(17))="INST PREV Y SEG SOCIAL DE LA PROV")

						select mwkdocent
						mtipodoc = alltrim(dat_ws(3))
						mtipoent = iif(ltucuman,701,100)
						locate for TDE_DescripEnt = mtipodoc and TDE_CodEnt = mtipoent
						ntipodoc = iif(found(),TDE_codigodoc,9)
						mtipodoc = iif(found(),abrevio,"OTRO")
						mapeynom = strtran(dat_ws(5),", ",",")
						mfechapas = iif(dat_ws(19)="B" or dat_ws(20)="B" ,date()-1,ctod("01/01/2100"))
						if dat_ws(19)="I" or dat_ws(20)="I"
							messagebox("Este afiliado no puede atenderse por Hominis. "+chr(13)+;
								"Concurrir a esta entidad a regularizar su situacion",48,"VALIDACION")
							mfechapas = date()-1
						else
							if dat_ws(19)="M" or dat_ws(20)="M"
								messagebox("Este afiliado solo puede estar como HOMINIS - PRE INGRESO " ,48,"VALIDACION")
								mfechapas = date()-1
							endif
						endif
						insert into mwkdatpadron values (val(strtran(dat_ws(6),"-","")), mapeynom, ;
							mtipodoc, val(dat_ws(4)), prg_ctod(dat_ws(9),"D"), mfechapas , ;
							val(strtran(dat_ws[2],"-","")), 'HOMINIS ONLINE', prg_ctod(dat_ws(8),"D"),val(dat_ws(14)),;
							dat_ws(11),dat_ws(12),iif(val(dat_ws(14))<1599,dat_ws(12),"BUENOS AIRES"),;
							dat_ws(13),dat_ws(10),dat_ws(7),ntipodoc,mtipoent,0 )
						lsigue = .f.
					else
*		messagebox("",48,"No registra afiliacion")
						select mwkdocent
						mtipodoc = 'Doc. Nac. Ident'
						mtipoent = 100
						locate for TDE_DescripEnt = mtipodoc and TDE_CodEnt = mtipoent
						ntipodoc = iif(found(),TDE_codigodoc,9)
						mtipodoc = iif(found(),abrevio,"OTRO")
						mapeynom = ""
						mfechapas = date()-1
						insert into mwkdatpadron values (0, mapeynom, mtipodoc, 0, mfechapas, mfechapas;
							,0, 'HOMINIS ONLINE',  mfechapas ,0, '','',"BUENOS AIRES",'','','',ntipodoc,100,0 )
						if mbusco<10 and lcontrol
							mbusco = mbusco*10
							ldocerr = .t.
						else
							messagebox("ESTE PACIENTE NO REGISTRA AFILIACION EN HOMINIS ONLINE",48,"Validacion Hominis")
							lsigue = .f.
						endif
					endif
				else
					messagebox("NO HAY COMUNICACION CON PADRON HOMINIS ON LINE."+chr(13)+chr(13)+;
						"VERIFIQUE DATOS POR MODULO DE PADRONES",48,"Falla de Conexion On line")
					select mwkdocent
					mtipodoc = 'Doc. Nac. Ident'
					mtipoent = 100
					locate for TDE_DescripEnt = mtipodoc and TDE_CodEnt = mtipoent
					ntipodoc = iif(found(),TDE_codigodoc,9)
					mtipodoc = iif(found(),abrevio,"OTRO")
					mapeynom = ""
					mfechapas = date()-1
					lsigue = .f.
					if used('mwkafient1')
						do sp_grabo_WS with 999,iif(lcontrol,mwkafient1.AFI_nroafiliado,0);
							, mwkbuspacie1.REG_nombrepac, ;
							iif(lcontrol,nvl(mwkafient1.AFI_fechabaja,ctod("01/01/1900")),;
							ctod("01/01/1900"));
							,mwkbuspacie1.REG_numdocumento,nvl(mwkbuspacie1.REG_distrito,'0')
					else
						do sp_grabo_WS with mbusco,0, .txtnombre.value , ctod("01/01/1900");
							, &vnrodoc,'0'
					endif
					insert into mwkdatpadron values (0, mapeynom, mtipodoc, 0, mfechapas, mfechapas;
						,0, 'HOMINIS ONLINE',  mfechapas ,0, '','',"BUENOS AIRES",'','','',ntipodoc,100,0 )
				endif
				with &mformuo
					.mserver = ""
				endwith
			enddo


			if mwkdatpadron.NroAfiliado >0 and mwkdatpadron.fecegreso > ttod(mwkfecserv.fechahora)
				if ldocerr and mbusco>10
					messagebox("ESTE PACIENTE ES UN AFILIADO DE PADRON"+;
						chr(13)+ chr(13)+ "NO COINCIDE EL NUMERO DE DOCUMENTO"+;
						chr(13)+ chr(13)+ "REGISTRE LA DIFERENCIA PARA AUDITORIA",48,"Diferencia de datos")
				else
					wait windows "ESTE PACIENTE ES UN AFILIADO DE PADRON" nowait
				endif
			endif
		case mrutina ="CP"
			mnroant = iif(used('mwkbuspacie1'),mwkbuspacie1.REG_nroregistrac,0)
			mhce = iif(used('mwkbuspacie1'),iif(val(mwkbuspacie1.reg_nrohclinica)= 0,'',allt(mwkbuspacie1.reg_nrohclinica)),'')

			if mwkusuario.idusuario = 'CFUNES'
*				set step on
			endif
			select * from mwkdatpadron where FecEgreso > ttod(mwkfecserv.fechahora) into cursor mwkpadactivo
			select mwkdatpadron
			mafi  = iif(lcontrol,val(chrtran(mwkafient1.afi_nroafiliado," -/","")),mwkdatpadron.nroafiliado)
			mfecbaja = ctod("01/01/1900")
			locate for NroAfiliado = mafi
			mcodentpad = mwkfentid.Ent_CodAgrup
			if found() and mafi>0
				mfecbaja = FecEgreso
				mcodentpad = entidad
			endif
			mcodenti = iif(lcontrol,allt(str(mwkafient1.afi_codentidad)),allt(str(mwkdatpadron.entidad)))
			mfechabajaafil = iif(used('mwkafient1'),mwkafient1.AFI_fechabaja,ctod("01/01/1900"))
			if lcontrol
				mcodenti = allt(str(mwkafient1.afi_codentidad))
				if val(mcodenti) # mcodentpad
					select mwkafient1
					locate for afi_codentidad = mcodentpad
					lexiste = found()
				endif
				if mfecbaja > ttod(mwkfecserv.fechahora) and lexiste
					if !(isnull(mwkafient1.AFI_fechabaja) or mwkafient1.AFI_fechabaja = {  /  /  })
						mcodenti = allt(str(mwkafient1.afi_codentidad))
						mnroHC  = allt(mwkbuspacie1.reg_nrohclinica)
						with &mformuo
							.mserver   = allt(mwktabcfg.oleserver)
							.namespace = allt(mwktabcfg.olespaces)

							.P1			= ''
							.code		=  'D ACTIVAFI^RTN003("' + mnrohc + '","' + mcodenti + '")'
							.execflag	= 1

							mmsgerr = .errorname
							mok	= .P0
							micode = .code
						endwith
						if !empty(mmsgerr) or mok <> ''
							thisform.errores(mmsgerr,mok,micode)
						else
							do sp_busco_entidad_afiliado1 with mwkbuspacie1.reg_nroregistrac
							&msql1
							.cboosoc.setfocus()
							do sp_actua_nroreg_control_pad with mformori, "ACTIVA Afiliacion pasiva",;
								mafi, mfechabajaafil , val(mcodenti)
						endif

					endif
				else
*		    mfecbaja <= ttod(mwkfecserv.fechahora)
					if reccount('mwkpadactivo') > 0
						select mwkpadactivo
						mccad = " and AFI_nroafiliado in ("
						scan
							mccad = mccad + transf(nroafiliado)+","
						endscan
						mccad = left(mccad,len(mccad)-1) +") and "
						mtipdocu = mwkdocu.codigovax
						mnrodocu = &vnrodoc
						mbusco1  = " ENT_codagrup = "+transf(mwkfentid.Ent_CodAgrup) + mccad
						do sp_busco_por_tipynro with mbusco1
						select int(val(chrtran(afi_nroafiliado," -/",""))) as afiliado,;
							REG_nrohclinica,ENT_codent,ENT_descrient ;
							from mwkbuscopa into cursor mwkbuscopa1
						lsigo = .t.
						if used('mwkafient1')
							select * from mwkbuscopa1 where transf(ent_codent,"9999")+transf(Afiliado);
								in (select transf(afi_codentidad,"9999")+transf(AFI_nroafiliado) from mwkafient1);
								into cursor mwkbuscopacestan
							lsigo = reccount('mwkbuscopacestan')=0
						endif
						if lsigo
							do form frmguardia61
						endif
						if mwkusuario.idusuario = 'CFUNES'
*							set step on
						endif
						if used('mwkpasopadron')
							if reccount('mwkpasopadron')>0		&&& cambio afiliado
								if lexiste
									messagebox ("CAMBIO DE NUMERO DE AFILIADO", 48, 'Validacion')
								else
									messagebox ("HABILITA ENTIDAD DE PADRON", 48, 'Validacion')
								endif
								maafi = mwkpasopadron.NroAfiliado
								select mwkpadactivo
								locate for NroAfiliado = maafi
								mhce = iif(val(mwkbuspacie1.reg_nrohclinica)= 0,'',allt(mwkbuspacie1.reg_nrohclinica))
								mnom	= iif(len(.txtnombre.value)<4,allt(nvl(ApeyNom,'')),allt(.txtnombre.value))
								mfec	= dtoc(iif(.txtfecnac.value = ctod("01/01/1900"), nvl(fecnac,ctod("01/01/1950")),.txtfecnac.value))
								msex	= iif(empty(.cbosexo.displayvalue),nvl(sexo,'M'),iif(.cbosexo.displayvalue = 'MASCULINO', 'M','F'))
								mtdo	= allt(str(round(.cbodocu.value, 0)))
								mdoc	= allt(str(&vnrodoc, 11))
								mdom	= alltrim(prg_saca_char(iif(empty(.txtdomici.value),nvl(mwkpasopadron.Domicilio,''),.txtdomici.value)))
								mloc	= allt(iif(empty(mwkloca.descrip),nvl(mwkpasopadron.Localidad,''),mwkloca.descrip))
								mpci	= allt(iif(empty(mwkpcia.descrip),nvl(mwkpasopadron.Provincia,'') ,mwkpcia.descrip))
								mcpo	= allt(str(iif(.txtcpostal.value = 0,val(transf(nvl(mwkpasopadron.Codigo,0))),.txtcpostal.value), 4))
								mtel	= allt(iif(empty(.txttel.value),nvl(mwkpasopadron.Telefono,'') ,.txttel.value))
								mopera	= allt(str(iif(mwkusuario.codigovax = 0, 99999, mwkusuario.codigovax), 5))
								mstrent = ''
								mgraba 	= '1'
								select mwkafient1
								go top
								do while !eof('mwkafient1')
									if (isnull(mwkafient1.ent_fecpas) or mwkafient1.ent_fecpas = {  /  /  })
										if mwkafient1.afi_codentidad = val(transf(mcodentpad))
											mstrent = mstrent + allt(str(mwkafient1.afi_codentidad,6,0)) + chr(9) + ;
												allt(transf(round(mwkpasopadron.nroafiliado,0))) + chr(1)
										else
											mstrent = mstrent + allt(str(mwkafient1.afi_codentidad,6,0)) + chr(9) + ;
												allt(mwkafient1.afi_nroafiliado) + chr(1)
										endif
									else
										if mwkafient1.afi_codentidad = val(transf(mcodentpad))
											mstrent = mstrent + allt(str(mwkafient1.afi_codentidad,6,0)) + chr(9) + ;
												allt(transf(round(mwkpasopadron.nroafiliado,0))) + chr(1)
										endif
									endif
									skip 1 in mwkafient1
								enddo
								if !lexiste
									mstrent = mstrent + allt(str(mcodentpad,6,0)) + chr(9) + ;
										allt(transf(round(mwkpasopadron.nroafiliado,0))) + chr(1)
								endif
								select mwkafient1
								go top
								locate for afi_codentidad = .cboosoc.value

&& Grabo en Registracio
								with &mformuo
									.mserver   = allt(mwktabcfg.oleserver)
									.namespace = allt(mwktabcfg.olespaces)

									.P1			= ''
									.code = "D REGISHC^RTN003(" + mgraba + ',"'+ mhce + '","'+ ;
										mnom +'","' + mfec + '","' + msex + '",' + mtdo + ',' + ;
										mdoc + ',"' + mdom + '","' + mloc + '","' + mpci + '",' + ;
										mcpo + ',"' + mtel + '","' + mstrent + '",' + mopera + ')'

									.execflag = 1

									mmsgerr = .errorname

									mok		= .p0					&& Codigo de error
									mresp1	= round(val(.p1), 0)	&& Registracio
									mresp2	= .p2					&& H. Clinica
									micode = .code
								endwith
								if !empty(mmsgerr) or mok <> ''
									thisform.errores(mmsgerr,mok,micode)
								else
									if lexiste
										ment = val(transf(mcodenti))
										mobser = "CAMBIO numero de afiliado"
									else
										ment = mcodentpad
										mobser = "NUEVA AFILIACION "+transf(mcodentpad)
									endif
									thisform.cambios = ment
									mctexto = alltrim(mresp2)
									mbusco1 = "where registracio.reg_nrohclinica = ?mctexto "
									msql_reg = ''
									do sp_busco_nombre_paciente_3 with mbusco1, 1, ''
									&msql_reg
									do sp_busco_entidad_afiliado1 with mwkbuspacie1.reg_nroregistrac
									&msql1
									mcodos = .cboosoc.value
									select mwkafient1
									locate for ENT_codent = ment
									.txtafiliado.value = mwkafient1.AFI_nroafiliado
									select mwkentidad2
									locate for ent_codent = ment
									.cboosoc.refresh()
									do sp_actua_nroreg_control_pad with mformori, mobser ,;
										mafi, mfechabajaafil ,ment
								endif

							endif
						endif


					else  && dar de baja
						nentipad = 0
						do sp_control_msgini with 'PADRONES',mcodentpad
						if 	nentipad # val(transf(mcodentpad))
							if (isnull(mwkafient1.AFI_fechabaja) or mwkafient1.AFI_fechabaja = {  /  /  })
								if mwkdatpadron.NroAfiliado > 0
									messagebox ("VERIFIQUE PADRON. POSIBLE AFILIACION DADA DE BAJA", 48, 'Validacion')
									with &mformuo
										.mserver	= alltrim(mwktabcfg.oleserver)
										.namespace	= alltrim(mwktabcfg.olespaces)
									endwith
									mfecha  = sp_busco_fecha_serv('DD')
									mfec 	= dtoc(mfecha)
									mgraba	= '1'
									mhce 	= iif(val(mwkbuspacie1.reg_nrohclinica)= 0,'',allt(mwkbuspacie1.reg_nrohclinica))
									mopera	= allt(str(iif(mwkusuario.codigovax = 0, 99999, mwkusuario.codigovax), 5))
									mstrent = allt(str(mcodentpad,6,0))
									mpad  	= '1'
									with &mformuo
										.code = "D BAJENTHC^RTN003(" + mgraba + ',"'+ mhce + '",'+ ;
											mstrent +',"' + mfec + '",' + mpad + ',' + mopera + ')'

										.execflag = 1
										micod = .code
										mmsgerr = .errorname
										mok = .P0
									endwith
									if !empty(mmsgerr) or mok <> ''
										thisform.errores(mmsgerr,mok,micode)
									else
										do sp_busco_entidad_afiliado1 with mwkbuspacie1.reg_nroregistrac
										&msql1
										.cboosoc.setfocus()
										do sp_actua_nroreg_control_pad with mformori, "BAJA Afiliación Activa",;
											mafi, mfechabajaafil , val(mcodenti)
									endif

									with &mformuo
										.mserver = ""
									endwith
								endif
							else
								messagebox ("AFILIACION DADA DE BAJA EN PADRON", 48, 'Validacion')

							endif
						endif
					endif
				endif
			else  &&& no existe afiliacion
				if reccount('mwkpadactivo') > 0 and mwkpadactivo.nroafiliado > 0
					select mwkpadactivo
					mccad = " and AFI_nroafiliado in ("
					scan
						mccad = mccad + transf(nroafiliado)+","
					endscan
					mccad = left(mccad,len(mccad)-1) +") and "
					mtipdocu = mwkdocu.codigovax
					mnrodocu = &vnrodoc
					mbusco1  = " ENT_codagrup = "+transf(mwkfentid.Ent_CodAgrup) + mccad
					do sp_busco_por_tipynro with mbusco1
					select int(val(chrtran(afi_nroafiliado," -/",""))) as afiliado,;
						REG_nrohclinica,ENT_codent,ENT_descrient ;
						from mwkbuscopa into cursor mwkbuscopa1
					do form frmguardia61
					if mwkusuario.idusuario = 'CFUNES'
*						set step on
					endif
					if used('mwkpasopadron')
						if reccount('mwkpasopadron')>0		&&& cambio afiliado
							messagebox ("VERIFIQUE PADRON. POSIBLE CAMBIO DE NUMERO DE AFILIADO", 48, 'Validacion')
*					set step on
							maafi = mwkpasopadron.NroAfiliado
							select mwkpadactivo
							locate for NroAfiliado = maafi
							mhce = iif(val(mwkbuspacie1.reg_nrohclinica)= 0,'',allt(mwkbuspacie1.reg_nrohclinica))
							mnom	= iif(len(.txtnombre.value)<4,allt(nvl(ApeyNom,'')),allt(.txtnombre.value))
							mfec	= dtoc(iif(.txtfecnac.value = ctod("01/01/1900"), nvl(fecnac,ctod("01/01/1950")),.txtfecnac.value))
							msex	= iif(empty(.cbosexo.displayvalue),nvl(sexo,'M'),iif(.cbosexo.displayvalue = 'MASCULINO', 'M','F'))
							mtdo	= allt(str(round(.cbodocu.value, 0)))
							mdoc	= allt(str(&vnrodoc, 11))
							mdom	= alltrim(prg_saca_char(iif(empty(.txtdomici.value),nvl(mwkpasopadron.Domicilio,''),.txtdomici.value)))
							mloc	= allt(iif(empty(mwkloca.descrip),nvl(mwkpasopadron.Localidad,''),mwkloca.descrip))
							mpci	= allt(iif(empty(mwkpcia.descrip),nvl(mwkpasopadron.Provincia,'') ,mwkpcia.descrip))
							mcpo	= allt(str(iif(.txtcpostal.value = 0,val(transf(nvl(mwkpasopadron.Codigo,0))),.txtcpostal.value), 4))
							mtel	= allt(iif(empty(.txttel.value),nvl(mwkpadactivo.Telefono,'') ,.txttel.value))
							mopera	= allt(str(iif(mwkusuario.codigovax = 0, 99999, mwkusuario.codigovax), 5))
							mstrent = ''
							mgraba 	= '1'
							if used('mwkafient1')
								select mwkafient1
								go top
								do while !eof('mwkafient1')
									if (isnull(mwkafient1.ent_fecpas) or mwkafient1.ent_fecpas = {  /  /  })
										mstrent = mstrent + allt(str(mwkafient1.afi_codentidad,6,0)) + chr(9) + ;
											allt(mwkafient1.afi_nroafiliado) + chr(1)
									endif
									skip 1 in mwkafient1
								enddo
							endif
							mstrent = mstrent + allt(transf(mcodenti)) + chr(9) + ;
								allt(transf(round(mwkpasopadron.nroafiliado,0))) + chr(1)
&& Grabo en Registracio
							with &mformuo
								.mserver   = allt(mwktabcfg.oleserver)
								.namespace = allt(mwktabcfg.olespaces)

								.P1			= ''
								.code = "D REGISHC^RTN003(" + mgraba + ',"'+ mhce + '","'+ ;
									mnom +'","' + mfec + '","' + msex + '",' + mtdo + ',' + ;
									mdoc + ',"' + mdom + '","' + mloc + '","' + mpci + '",' + ;
									mcpo + ',"' + mtel + '","' + mstrent + '",' + mopera + ')'

								.execflag = 1

								mmsgerr = .errorname

								mok		= .p0					&& Codigo de error
								mresp1	= round(val(.p1), 0)	&& Registracio
								mresp2	= .p2					&& H. Clinica
								micode = .code
							endwith

							if !empty(mmsgerr) or mok <> ''
								thisform.errores(mmsgerr,mok,micode)
							else
								mctexto = alltrim(mresp2)
								mbusco1 = "where registracio.reg_nrohclinica = ?mctexto "
								msql_reg = ''
								do sp_busco_nombre_paciente_3 with mbusco1, 1, ''
								&msql_reg
								do sp_busco_entidad_afiliado1 with mresp1
								&msql1
								mcodos = val(transf(mcodenti))
								select mwkafient1
								locate for ENT_codent = mcodos
								.txtafiliado.value = mwkafient1.AFI_nroafiliado
								select mwkentidad2
								locate for ent_codent = mcodos
								.cboosoc.refresh()
								thisform.cambios = mcodos
								do sp_actua_nroreg_control_pad with mformori, "NUEVA Afiliacion",;
									mafi, mfechabajaafil , val(mcodenti)

							endif

						endif
					endif
				else
					messagebox ("VERIFIQUE PADRON. NO HAY AFILIACIONES ACTIVAS", 48, 'Validacion')
				endif
			endif
			if used('mwkdatpadron')
				use in mwkdatpadron
			endif
			if used('mwkafient1')
				select mwkafient1
				go top
				locate for afi_codentidad = .cboosoc.value
			endif
			mtipo = iif(inlist(mwkexe.nomexe ,'TURNOS', 'AMBULATORIO'),"AMB", left(mwkexe.nomexe,3))
			if mwkusuario.idusuario = 'CFUNES'
*				set step on
			endif
			if val(mhce) = 0 and mresp1>0

				do sp_grabo_auditoria with 1,mresp1,mtipo + ' - INGRESO'
				if mnroant > 0	and mnroant # mresp1 and ;
						inlist(mwkexe.nomexe ,'TURNOS', 'AMBULATORIO')&& Pre registrado a Registrado actualizo turno
					do sp_actua_nroreg_turnos with mnroant, mresp1, mcodos
				endif
			endif

		case mrutina ="CPV"  && control padron desde vales
			if mwkusuario.idusuario = 'CFUNES'
*				set step on
			endif

			select * from mwkdatpadron where FecEgreso > ttod(mwkfecserv.fechahora) into cursor mwkpadactivo
			select mwkdatpadron
			mafi  = iif(lcontrol,val(chrtran(mwkafient1.afi_nroafiliado," -/","")),mwkdatpadron.nroafiliado)
			mfecbaja = ctod("01/01/1900")
			locate for NroAfiliado = mafi
			mcodentpad = mwkfentid.Ent_CodAgrup
			if found() and mafi>0
				mfecbaja = FecEgreso
				mcodentpad = entidad
			endif
			mcodenti = iif(lcontrol,allt(str(mwkafient1.afi_codentidad)),allt(str(mwkdatpadron.entidad)))
			mfechabajaafil = iif(used('mwkafient1'),mwkafient1.AFI_fechabaja,ctod("01/01/1900"))
			if lcontrol
				mcodenti = allt(str(mwkafient1.afi_codentidad))
				if val(mcodenti) # mcodentpad
					select mwkafient1
					locate for afi_codentidad = mcodentpad
				endif
				if mfecbaja > ttod(mwkfecserv.fechahora)
					if !(isnull(mwkafient1.AFI_fechabaja) or mwkafient1.AFI_fechabaja = {  /  /  })
						mcodenti = allt(str(mwkafient1.afi_codentidad))
						mnroHC  = allt(mwkbuspacie1.reg_nrohclinica)
						with &mformuo
							.mserver   = allt(mwktabcfg.oleserver)
							.namespace = allt(mwktabcfg.olespaces)

							.P1			= ''
							.code		=  'D ACTIVAFI^RTN003("' + mnrohc + '","' + mcodenti + '")'
							.execflag	= 1

							mmsgerr = .errorname
							mok	= .P0
							micode = .code
						endwith
						if !empty(mmsgerr) or mok <> ''
							thisform.errores(mmsgerr,mok,micode)
						else
							do sp_busco_entidad_afiliado1 with mwkbuspacie1.reg_nroregistrac
							&msql1
							.cboosoc.setfocus()
*!*								do sp_actua_nroreg_control_pad with mformori, "ACTIVA Afiliacion pasiva",;
*!*									mafi, mfechabajaafil , mcodent
						endif

					endif
				else
*		    mfecbaja <= ttod(mwkfecserv.fechahora)
					if reccount('mwkpadactivo') > 0
						select mwkpadactivo
						mccad = " and AFI_nroafiliado in ("
						scan
							mccad = mccad + transf(nroafiliado)+","
						endscan
						mccad = left(mccad,len(mccad)-1) +") and "
						mtipdocu = mwkdocu.codigovax
						mnrodocu = &vnrodoc
						mbusco1  = " ENT_codagrup = "+transf(mwkfentid.Ent_CodAgrup) + mccad
						do sp_busco_por_tipynro with mbusco1
						select int(val(chrtran(afi_nroafiliado," -/",""))) as afiliado,;
							REG_nrohclinica,ENT_codent,ENT_descrient ;
							from mwkbuscopa into cursor mwkbuscopa1
						do form frmguardia61
						if mwkusuario.idusuario = 'CFUNES'
*							set step on
						endif
						if used('mwkpasopadron')
							if reccount('mwkpasopadron')>0		&&& cambio afiliado
								messagebox ("CAMBIO DE NUMERO DE AFILIADO", 48, 'Validacion')
*!*									maafi = mwkpasopadron.NroAfiliado
*!*									select mwkpadactivo
*!*									locate for NroAfiliado = maafi
*!*									mhce = allt(mwkbuspacie1.reg_nrohclinica)
*!*									mnom	= mwkbuspacie1.REG_nombrepac
*!*									mfec	= dtoc(mwkbuspacie1.REG_fecnacimiento)
*!*									msex	= mwkbuspacie1.REG_sexo
*!*									mtdo	= transf(mwkbuspacie1.REG_tipodocumento)
*!*									mdoc	= nvl(mwkbuspacie1.REG_domicilio, '')
*!*									mdom	= alltrim(prg_saca_char(nvl(mwkbuspacie1.reg_domicilio,'')))
*!*									mloc	= nvl(mwkbuspacie1.REG_localidad, 'CAPITAL FEDERAL')
*!*									mpci	= nvl(mwkbuspacie1.REG_provincia, 'BUENOS AIRES')
*!*									mcpo	= transf(nvl(mwkbuspacie1.REG_cpostal, 0))
*!*									mtel	= nvl(mwkbuspacie1.REG_telefonos, '')
*!*									mopera	= allt(str(iif(mwkusuario.codigovax = 0, 99999, mwkusuario.codigovax), 5))
*!*									mstrent = ''
*!*									mgraba 	= '1'
*!*									select mwkafient1
*!*									go top
*!*									do while !eof('mwkafient1')
*!*										if isnull(mwkafient1.ent_fecpas)
*!*											if mwkafient1.afi_codentidad = val(transf(mcodent))
*!*												mstrent = mstrent + allt(str(mwkafient1.afi_codentidad,6,0)) + chr(9) + ;
*!*													allt(transf(round(mwkpasopadron.nroafiliado,0))) + chr(1)
*!*											else
*!*												mstrent = mstrent + allt(str(mwkafient1.afi_codentidad,6,0)) + chr(9) + ;
*!*													allt(mwkafient1.afi_nroafiliado) + chr(1)
*!*											endif
*!*										else
*!*											if mwkafient1.afi_codentidad = val(transf(mcodent))
*!*												mstrent = mstrent + allt(str(mwkafient1.afi_codentidad,6,0)) + chr(9) + ;
*!*													allt(transf(round(mwkpasopadron.nroafiliado,0))) + chr(1)
*!*											endif
*!*										endif
*!*										skip 1 in mwkafient1
*!*									enddo
*!*									select mwkafient1
*!*									go top
*!*									locate for afi_codentidad = .cboosoc.value

*!*	&& Grabo en Registracio
*!*									with &mformuo
*!*										.mserver   = allt(mwktabcfg.oleserver)
*!*										.namespace = allt(mwktabcfg.olespaces)

*!*										.P1			= ''
*!*										.code = "D REGISHC^RTN003(" + mgraba + ',"'+ mhce + '","'+ ;
*!*											mnom +'","' + mfec + '","' + msex + '",' + mtdo + ',' + ;
*!*											mdoc + ',"' + mdom + '","' + mloc + '","' + mpci + '",' + ;
*!*											mcpo + ',"' + mtel + '","' + mstrent + '",' + mopera + ')'

*!*										.execflag = 1

*!*										mmsgerr = .errorname

*!*										mok		= .p0					&& Codigo de error
*!*										mresp1	= round(val(.p1), 0)	&& Registracio
*!*										mresp2	= .p2					&& H. Clinica
*!*										micode = .code
*!*									endwith

*!*									if mok <> ''
*!*									else
*!*										mctexto = alltrim(mresp2)
*!*										mbusco1 = "where registracio.reg_nrohclinica = ?mctexto "
*!*										msql_reg = ''
*!*										do sp_busco_nombre_paciente_3 with mbusco1, 1, ''
*!*										&msql_reg
*!*										do sp_busco_entidad_afiliado1 with mwkbuspacie1.reg_nroregistrac
*!*										&msql1
*!*										mcodos = .cboosoc.value
*!*										select mwkafient1
*!*										locate for ENT_codent = mcodos
*!*										.txtafiliado.value = mwkafient1.AFI_nroafiliado
*!*										select mwkentidad2
*!*										locate for ent_codent = mcodos
*!*										.cboosoc.refresh()
*!*	*!*										do sp_actua_nroreg_control_pad with mformori, "CAMBIO numero de afiliado",;
*!*	*!*											mafi, mfechabajaafil , mcodent

*!*									endif

							endif
						endif


					else  && dar de baja
						nentipad = 0
						do sp_control_msgini with 'PADRONES',mcodentpad
						if 	nentipad # val(transf(mcodentpad))
							if (isnull(mwkafient1.AFI_fechabaja) or mwkafient1.AFI_fechabaja = {  /  /  })
								if mwkdatpadron.NroAfiliado > 0
									messagebox ("VERIFIQUE PADRON. POSIBLE AFILIACION DADA DE BAJA", 48, 'Validacion')
									with &mformuo
										.mserver	= alltrim(mwktabcfg.oleserver)
										.namespace	= alltrim(mwktabcfg.olespaces)
									endwith
									mfecha  = sp_busco_fecha_serv('DD')
									mfec 	= dtoc(mfecha)
									mgraba	= '1'
									mhce 	= iif(val(mwkbuspacie1.reg_nrohclinica)= 0,'',allt(mwkbuspacie1.reg_nrohclinica))
									mopera	= allt(str(iif(mwkusuario.codigovax = 0, 99999, mwkusuario.codigovax), 5))
									mstrent = allt(str(mcodentpad,6,0))
									mpad  	= '1'
									with &mformuo
										.code = "D BAJENTHC^RTN003(" + mgraba + ',"'+ mhce + '",'+ ;
											mstrent +',"' + mfec + '",' + mpad + ',' + mopera + ')'

										.execflag = 1
										micod = .code
										mmsgerr = .errorname
										mok = .P0
									endwith
									if !empty(mmsgerr)

										select mwkusuario
										go top
										midusua     = mwkusuario.idusuario

										do sp_insert_tabCtrlErr with micode, mmsgerr , midusua, .name
										messagebox ("NO SE PUDO PASIVAR LA AFILIACION... REINTENTE", 48, 'Validacion')

									endif
									if mok <> ''
										mcoderr = round(val(mok), 0)
										do sp_busco_texto_error with mcoderr
										messagebox(alltrim(mwktaberror.textoerror), 48, 'Validacion')

									else
										do sp_busco_entidad_afiliado1 with mwkbuspacie1.reg_nroregistrac
										&msql1
										.cboosoc.setfocus()
										do sp_actua_nroreg_control_pad with mformori, "BAJA Afiliación Activa",;
											mafi, mfechabajaafil , val(mcodenti)
									endif

									with &mformuo
										.mserver = ""
									endwith
								endif
							else
								messagebox ("AFILIACION DADA DE BAJA EN PADRON", 48, 'Validacion')

							endif
						endif
					endif
				endif
			else  &&& no existe afiliacion
				if reccount('mwkpadactivo') > 0 and mwkpadactivo.nroafiliado > 0
					select mwkpadactivo
					mccad = " and AFI_nroafiliado in ("
					scan
						mccad = mccad + transf(nroafiliado)+","
					endscan
					mccad = left(mccad,len(mccad)-1) +") and "
					mtipdocu = mwkdocu.codigovax
					mnrodocu = &vnrodoc
					mbusco1  = " ENT_codagrup = "+transf(mwkfentid.Ent_CodAgrup) + mccad
					do sp_busco_por_tipynro with mbusco1
					select int(val(chrtran(afi_nroafiliado," -/",""))) as afiliado,;
						REG_nrohclinica,ENT_codent,ENT_descrient ;
						from mwkbuscopa into cursor mwkbuscopa1
					do form frmguardia61
					if mwkusuario.idusuario = 'CFUNES'
*						set step on
					endif
					if used('mwkpasopadron')
						if reccount('mwkpasopadron')>0		&&& cambio afiliado
							messagebox ("VERIFIQUE PADRON. POSIBLE CAMBIO DE NUMERO DE AFILIADO", 48, 'Validacion')
*					set step on
*!*								maafi = mwkpasopadron.NroAfiliado
*!*								select mwkpadactivo
*!*								locate for NroAfiliado = maafi
*!*								mhce = allt(mwkbuspacie1.reg_nrohclinica)
*!*									mnom	= mwkbuspacie1.REG_nombrepac
*!*									mfec	= dtoc(mwkbuspacie1.REG_fecnacimiento)
*!*									msex	= mwkbuspacie1.REG_sexo
*!*									mtdo	= transf(mwkbuspacie1.REG_tipodocumento)
*!*									mdoc	= nvl(mwkbuspacie1.REG_domicilio), '')
*!*									mdom	= alltrim(prg_saca_char(iif(empty(.txtdomici.value),Domicilio,.txtdomici.value)))
*!*									mloc	= nvl(mwkbuspacie1.REG_localidad), 'CAPITAL FEDERAL')
*!*									mpci	= nvl(mwkbuspacie1.REG_provincia), 'BUENOS AIRES')
*!*									mcpo	= transf(nvl(mwkbuspacie1.REG_cpostal), 0))
*!*									mtel	= nvl(mwkbuspacie1.REG_telefonos), '')
*!*								mnom	= iif(len(.txtnombre.value)<4,allt(ApeyNom),allt(.txtnombre.value))
*!*								mfec	= dtoc(iif(.txtfecnac.value = ctod("01/01/1900"), fecnac,.txtfecnac.value))
*!*								msex	= iif(empty(.cbosexo.displayvalue),sexo,iif(.cbosexo.displayvalue = 'MASCULINO', 'M','F'))
*!*								mtdo	= allt(str(round(.cbodocu.value, 0)))
*!*								mdoc	= allt(str(&vnrodoc, 11))
*!*								mdom	= alltrim(prg_saca_char(iif(empty(.txtdomici.value),Domicilio,.txtdomici.value)))
*!*								mloc	= allt(iif(empty(mwkloca.descrip),Localidad,mwkloca.descrip))
*!*								mpci	= allt(iif(empty(mwkpcia.descrip),Provincia ,mwkpcia.descrip))
*!*								mcpo	= allt(str(iif(.txtcpostal.value = 0,val(transf(Codigo)),.txtcpostal.value), 4))
*!*								mtel	= allt(iif(empty(.txttel.value),Telefono ,.txttel.value))
*!*								mopera	= allt(str(iif(mwkusuario.codigovax = 0, 99999, mwkusuario.codigovax), 5))
*!*								mstrent = ''
*!*								mgraba 	= '1'
*!*								if used('mwkafient1')
*!*									select mwkafient1
*!*									go top
*!*									do while !eof('mwkafient1')
*!*										if isnull(mwkafient1.ent_fecpas)
*!*											mstrent = mstrent + allt(str(mwkafient1.afi_codentidad,6,0)) + chr(9) + ;
*!*												allt(mwkafient1.afi_nroafiliado) + chr(1)
*!*										endif
*!*										skip 1 in mwkafient1
*!*									enddo
*!*								endif
*!*								mstrent = mstrent + allt(transf(mcodent)) + chr(9) + ;
*!*									allt(transf(round(mwkpasopadron.nroafiliado,0))) + chr(1)
*!*	&& Grabo en Registracio
*!*								with &mformuo
*!*									.mserver   = allt(mwktabcfg.oleserver)
*!*									.namespace = allt(mwktabcfg.olespaces)

*!*									.P1			= ''
*!*									.code = "D REGISHC^RTN003(" + mgraba + ',"'+ mhce + '","'+ ;
*!*										mnom +'","' + mfec + '","' + msex + '",' + mtdo + ',' + ;
*!*										mdoc + ',"' + mdom + '","' + mloc + '","' + mpci + '",' + ;
*!*										mcpo + ',"' + mtel + '","' + mstrent + '",' + mopera + ')'

*!*									.execflag = 1

*!*									mmsgerr = .errorname

*!*									mok		= .p0					&& Codigo de error
*!*									mresp1	= round(val(.p1), 0)	&& Registracio
*!*									mresp2	= .p2					&& H. Clinica
*!*									micode = .code
*!*								endwith

*!*								if mok <> ''
*!*								else
*!*									mctexto = alltrim(mresp2)
*!*									mbusco1 = "where registracio.reg_nrohclinica = ?mctexto "
*!*									msql_reg = ''
*!*									do sp_busco_nombre_paciente_3 with mbusco1, 1, ''
*!*									&msql_reg
*!*									do sp_busco_entidad_afiliado1 with mresp1
*!*									&msql1
*!*									mcodos = val(transf(mcodent))
*!*									select mwkafient1
*!*									locate for ENT_codent = mcodos
*!*									.txtafiliado.value = mwkafient1.AFI_nroafiliado
*!*									select mwkentidad2
*!*									locate for ent_codent = mcodos
*!*									.cboosoc.refresh()
*!*									do sp_actua_nroreg_control_pad with mformori, "NUEVA Afiliacion",;
*!*										mafi, mfechabajaafil , mcodent

*!*								endif

						endif
					endif
				else
					messagebox ("VERIFIQUE PADRON. NO HAY AFILIACIONES ACTIVAS", 48, 'Validacion')
				endif
			endif
			if used('mwkdatpadron')
				use in mwkdatpadron
			endif
			if used('mwkafient1')
				select mwkafient1
				go top
				locate for afi_codentidad = .cboosoc.value
			endif
		case mrutina ="CPP"  && control padron desde preregistracion
			if mwkusuario.idusuario = 'CFUNES'
*				set step on
			endif

			select * from mwkdatpadron where FecEgreso > ttod(mwkfecserv.fechahora) into cursor mwkpadactivo
			select mwkdatpadron
			mafi  = mwkdatpadron.nroafiliado
			mfecbaja = ctod("01/01/1900")
			locate for NroAfiliado = mafi
			mcodentpad = mwkfentid.Ent_CodAgrup
			if found() and mafi>0
				mfecbaja = FecEgreso
				mcodentpad = entidad
			endif
			mcodenti = iif(lcontrol,allt(str(mwkafient1.afi_codentidad)),allt(str(mwkdatpadron.entidad)))
			mfechabajaafil = iif(used('mwkafient1'),mwkafient1.AFI_fechabaja,ctod("01/01/1900"))
			if lcontrol
				mcodenti = allt(str(mwkafient1.afi_codentidad))
				if val(mcodenti) # mcodentpad
					select mwkafient1
					locate for afi_codentidad = mcodentpad
				endif
				if mfecbaja > ttod(mwkfecserv.fechahora)

				else
*		    mfecbaja <= ttod(mwkfecserv.fechahora)
					if reccount('mwkpadactivo') > 0
						select mwkpadactivo
						mccad = " and AFI_nroafiliado in ("
						scan
							mccad = mccad + transf(nroafiliado)+","
						endscan
						mccad = left(mccad,len(mccad)-1) +") and "
						mtipdocu = mwkdocu.codigovax
						mnrodocu = &vnrodoc
						mbusco1  = " ENT_codagrup = "+transf(mwkfentid.Ent_CodAgrup) + mccad
						do sp_busco_por_tipynro with mbusco1
						select int(val(chrtran(afi_nroafiliado," -/",""))) as afiliado,;
							REG_nrohclinica,ENT_codent,ENT_descrient ;
							from mwkbuscopa into cursor mwkbuscopa1
						do form frmguardia61
						if mwkusuario.idusuario = 'CFUNES'
*							set step on
						endif
						if used('mwkpasopadron')
							if reccount('mwkpasopadron')>0		&&& cambio afiliado
								messagebox ("CAMBIO DE NUMERO DE AFILIADO", 48, 'Validacion')
							endif
						endif


					else  && dar de baja
*				set step on
						messagebox ("VERIFIQUE PADRON. POSIBLE AFILIACION DADA DE BAJA", 48, 'Validacion')
					endif
				endif
			else  &&& no existe afiliacion
				if reccount('mwkpadactivo') > 0 and mwkpadactivo.nroafiliado > 0
				else
					messagebox ("VERIFIQUE PADRON. NO HAY AFILIACIONES ACTIVAS", 48, 'Validacion')
				endif
			endif
			if used('mwkdatpadron')
				use in mwkdatpadron
			endif

	endcase
endwith
