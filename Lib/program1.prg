Local gMot[6]
msag = Nvl(mwkinterna.IH_secagrup,'')
gMot[1] = ' Ausente: 1 '
gMot[2] = ' Extensión anómala: 2'
gMot[3] = ' Flexión anómala: 3 '
gMot[4] = ' Retira dolor: 4'
gMot[5] = ' Localiza dolor: 5'
gMot[6] = ' Obedece órdenes: 6 '
Local gver[5]
gver[1] = ' Ausente: 1 '
gver[2] = ' Sonidos incomprensibles: 2'
gver[3] = ' Palabras inapropiadas: 3 '
gver[4] = ' Confusa: 4'
gver[5] = ' Orientada: 5'
Local gocu[4]
gocu[1] = ' Ausente: 1 '
gocu[2] = ' Al dolor: 2'
gocu[3] = ' A la voz: 3 '
gocu[4] = ' Espontánea: 4'
Do sp_busco_solic_cama_serv With Alltrim(.mnroadm) ,Alltrim(mwkveoprotomed.reg_nrohclinica)
If  mwkhabserv.estado =1
	Select mwkservsec.* From mwkservsec,mwkSecagruprel  ;
	WHERE SC_secagrup= Sector And sectoragrup = msag;
	Into Cursor mwksugserv
Else
	Select mwkservsec.* From mwkservsec,mwkSecagruprel  ;
	WHERE SC_secagrup= Sector And 1=2;
	Into Cursor mwksugserv
Endif

With Thisform.PgConsulta.pgAnam
	Thisform.PgConsulta.pgEvolmed.PgEvol.pgevold.edtanamnesis.Value = 'Ingreso a '+Nvl(mwkinterna.IH_secagrup,'')+Chr(13)

	.optreingre.Value = Iif(Reccount('mwkreingre')>0 Or Nvl(mwkinterna.IH_reingre,.F.),1,2)
	Select mwkevolprot
	Go Top
	Select mwkCie9i
	Locate For Id = Nvl(mwkevolprot.IH_motIngreso ,41045)
	If Eof()
		Locate For Id =   41045
		If Eof()
			Go Bott
		Endif
	Endif
	.cboMotingreso.Refresh
	mhoraing = Nvl(mwkevolprot.IH_fechaHoraIng,mwkfecserv.fechahora)
	mimedico 			= mwkveoproto.IH_codmed
	Select mwkmedicoint
	mimedant = mwkmedicoint.Id
	Locate For Id = mimedico
	cnmed = mwkmedicoint.nombre
	cnmat = mwkmedicoint.matricula
	Locate For Id = mimedant
	Select mwkevolprot
	Go Top
	mSetReadOnly = .cboMotingreso.ReadOnly
	.cboMotingreso.ReadOnly = .F.
	.cboMotingreso.Refresh()
	.cboMotingreso.ReadOnly = mSetReadOnly
	Select mwkprocede
	Thisform.xestant = Nvl(mwkevolprot.IH_procedencia ,923)
	Locate For Id = Nvl(mwkevolprot.IH_procedencia ,923)
	If Eof()
		Go Top
	Endif

	mSetReadOnly = .cboProcede.ReadOnly
	.cboProcede.ReadOnly = .F.
	.cboProcede.Refresh()
	.cboProcede.ReadOnly = mSetReadOnly
*					.optreingre.Value	                     = mwkanam.IH_reingre
	With .pgAnDiagno
		.page1.txtEd_an_impDiag.Value =  ''
		.page1.txtprofresp.Value = ''
		.page2.txtEd_an_planT.Value   = ''
		With .page3
			If MYIP='172.16.1.7'
				Set Step On
			Endif
			msag = Nvl(mwkinterna.IH_secagrup,'')
			misec = mwkpacint1.SEC_CODSECTOR
			If  Inlist(misec , 'PQU','PRP','EME','CEG')
				Use In Select("mwkservres")
				Use In Select("mwkserviresb")
				Use In Select("mwkservicresb")
				midevol = Thisform.midevol
				mret = SQLExec(mcon1, "select IS_codmed , IS_fechaHD , IS_fechaHH , IS_idevol , IS_responsable , IS_secagrup , IS_servicio,TabIntServ .id  "+;
				" from TabIntServ  where IS_idevol = ?midevol "+;
				"  group by IS_fechaHD , IS_fechaHH ,IS_servicio,IS_responsable "  , "mwkservresp")
				Select mwkservresp.*,mwkservicioR.Descrip As mti_descripcion,descripcion From mwkservresp ;
				left Join mwksecagrupnew On IS_secagrup= sectoragrup ;
				inner Join mwkservicioR On IS_servicio   = mwkservicioR.estado ;
				group By mwkservresp.Id Into Cursor mwkservres
**** cambio el left por inner join en ambos
				Select Padr(Nvl(descripcion,'' )+Nvl(mti_descripcion,''),50) As descserv,  IS_fechaHD , IS_fechaHH, IS_servicio,Id From mwkservres ;
				where  IS_responsable= 1 Order By IS_fechaHD Desc Into Cursor mwkserviresb
				Use In Select('mwkservires')
				Use Dbf('mwkserviresb') In 0 Again Alias mwkservires
				.cmadds.Visible = .T.
				.grid1.RecordSource = "select * from mwkservires into cursor mwkserviresg"
				Select mwkserviresg
				Go Bottom
				Select Padr(Nvl(descripcion,'' )+Nvl(mti_descripcion,''),50) As descserv, IS_fechaHD , IS_fechaHH, IS_servicio,Id,IS_responsable  From mwkservres ;
				where  IS_responsable>1 Order By IS_fechaHD Desc Into Cursor mwkservicresb
				Use In Select('mwkservicres')
				Use Dbf('mwkservicresb') In 0 Again Alias mwkservicres
				.grid2.RecordSource = "select * from mwkservicres into cursor mwkservicresg"
			Else
				If Used('mwkservicioR')
					Use In Select("mwksres")
					Use In Select("mwkscores")
*					Use Dbf('mwkservicioR') In 0 Again Alias mwksres

* Agregado

					lcBuscoSector = Upper(Alltrim(Thisform.txtsec.Value))
					mValor = sp_busco_homologacion_serv(lcBuscoSector)

* --------
					.cboServ.ControlSource 	=  "mwksres.estado"
					.cboServ.RowSource		= "mwksres.descrip,estado"
*					Use In Select("mwkscores")
*					Use Dbf('mwkservicioR') In 0 Again Alias mwkscores
					.cbocoServ.ControlSource 	=  "mwkscores.estado"
					.cbocoServ.RowSource		= "mwkscores.descrip,estado"

					Use In Select("mwkservres")
					Use In Select("mwkserviresb")
					Use In Select("mwkservicresb")
					midevol = Thisform.midevol
					mret = SQLExec(mcon1, "select IS_codmed , IS_fechaHD , IS_fechaHH , IS_idevol , IS_responsable , IS_secagrup , IS_servicio,TabIntServ .id  "+;
					" from TabIntServ  "+;
					" where IS_idevol = ?midevol  group by IS_fechaHD , IS_fechaHH ,IS_servicio,IS_responsable "  , "mwkservresp")
					Select mwkservresp.*,mwkservicioR.Descrip As mti_descripcion,descripcion From mwkservresp ;
					left Join mwksecagrupnew On IS_secagrup= sectoragrup ;
					INNER Join mwkservicioR On IS_servicio   = mwkservicioR.estado ;
					group By mwkservresp.Id Into Cursor mwkservres
**** cambio el left por inner join en ambos

					Select Padr(Nvl(descripcion,'' )+Nvl(mti_descripcion,''),50) As descserv,  IS_fechaHD , IS_fechaHH, IS_servicio,Id From mwkservres ;
					where  IS_responsable= 1 Order By IS_fechaHD Desc Into Cursor mwkserviresb
					Use In Select('mwkservires')
					Use Dbf('mwkserviresb') In 0 Again Alias mwkservires
					misec = mwkpacint1.SEC_CODSECTOR
					miesp = sp_busco_umsap(misec,2)

					If (!Empty(miesp) And Reccount('mwkservires') = 0)
						Select mwksres
						Locate For estado = miesp
						.cboServ.Refresh()
						.cmadds.Click()
						.cmadds.Visible = .T.
*!*						select mwksecagrupnew
*!*						locate for sectoragrup = msag
*!*						mides = mwksecagrupnew.descripcion
*!*						midia = ttod(mwkfecserv.fechahora)
*!*						mid = reccount('mwkservires')+1
*!*						insert into mwkservires (descserv,  IS_fechaHD , IS_fechaHH,is_servicio,id );
*!*							values (mides,midia,ctod("01/01/2100"),0,mid)
*!*						select mwkservires
					Endif


					.grid1.RecordSource = "select * from mwkservires into cursor mwkserviresg"
					Select mwkserviresg
					Go Top
					If (!(Inlist(msag,"UCI","PED","TEP","NEO") Or Inlist(misec ,"UCR","UC6","UCO"))) And Reccount('mwkserviresg') > 0 &&!thisform.lauditoria and
						Thisform.txtservicio.Value ="SERV.RESP.:"+Alltrim(mwkserviresg.descserv)
					Endif
					If (Inlist(msag,"UCI","PED","TEP","NEO")   Or Inlist(misec ,"UCR","UC6","UCO"))
						.cmadds.Visible = (Reccount('mwkserviresg')=0)
						.cmadds.Enabled =  (Reccount('mwkserviresg')=0)
					Else
						.cmadds.Visible = .T.
						.cmadds.Enabled = .T.
					Endif
				Endif
				Select Padr(Nvl(descripcion,'' )+Nvl(mti_descripcion,''),50) As descserv, IS_fechaHD , IS_fechaHH, IS_servicio,Id,IS_responsable  From mwkservres ;
				where  IS_responsable>1 Order By IS_fechaHD Desc Into Cursor mwkservicresb
				Use In Select('mwkservicres')
				Use Dbf('mwkservicresb') In 0 Again Alias mwkservicres
				.grid2.RecordSource = "select * from mwkservicres into cursor mwkservicresg"

				If !(Reccount('mwkservres')>0 And Reccount('mwkservicresg')>0)
					misec = mwkpacint1.SEC_CODSECTOR
					If !(mwkmedicoactual.codprof # 2 Or Thisform.lauditoria) And Reccount('mwksugserv')>0 ;
						AND  !Inlist(misec , 'PQU','PRP','EME','CEG')
						Do sp_busco_estados With 25,' and tipo = 34 and subestado = 1 order by descrip ','mwkservicioR'
						Select mwkservicioR
						Locate For estado = mwksugserv.sc_servicio
						mimensa = "Estimado profesional."+Chr(13)+"El diagnóstico consignado es:"+Alltrim(mwksugserv.Descrip)+Chr(13)+;
						"y la especialidad responsable:"+Alltrim(mwkservicioR.Descrip)+Chr(13)+"¿Confirma estos datos?"
						If Messagebox(mimensa,4+32+256,"Datos de la derivación")<>6
							Thisform.lestadosug = 9
***anulo la sugerencia
						Else
**cargo datos
							Thisform.lestadosug =  2
							If  mwkhabserv.estado =1
								Thisform.asignasugerencia()
							Endif
						Endif
					Endif
				Endif
				Use In Select('mwkservitemp')
			Endif

*!*				Select Padr(Nvl(descripcion,'' )+Nvl(mti_descripcion,''),50) As descserv, IS_fechaHD , IS_fechaHH, IS_servicio,Id,IS_responsable  From mwkservres ;
*!*				where  IS_responsable>1 Order By IS_fechaHD Desc Into Cursor mwkservicresb
*!*				Use In Select('mwkservicres')
*!*				Use Dbf('mwkservicresb') In 0 Again Alias mwkservicres
*!*				.grid2.RecordSource = "select * from mwkservicres into cursor mwkservicresg"
		Endwith
	Endwith

	If Reccount('mwkanam')>0

		Select mwkanam
		mhoraing = Nvl(mwkanam.IA_fechahora,mhoraing)
		.pgAnDiagno.page1.txtEd_an_impDiag.Value =  Alltrim(mwkanam.IA_impdiag)
		.pgAnDiagno.page1.txtprofresp.Value = Ttoc(mhoraing )+" " +Alltrim(cnmed)+" M.N.:"+ Transform(cnmat)
		.pgAnDiagno.page2.txtEd_an_planT.Value   = Alltrim(mwkanam.IA_Planterap)

		.optpostCX.Value = Nvl(mwkanam.IA_postcx,0)
		Thisform.PgConsulta.pgEvolmed.PgEvol.pgevold.edtanamnesis.Value = Thisform.PgConsulta.pgEvolmed.PgEvol.pgevold.edtanamnesis.Value +;
		transform(mhoraing )+ ' '+Alltrim(cnmed)+" M.N.:"+ Transform(cnmat)+Chr(13)

		Thisform.PgConsulta.pgEvolmed.PgEvol.pgevold.edtanamnesis.Value = Thisform.PgConsulta.pgEvolmed.PgEvol.pgevold.edtanamnesis.Value +;
		'Procedencia: ' + Alltrim(mwkprocede.Descrip)+" Reingreso:"+ Iif(Reccount('mwkreingre')>0, "Si","No")+;
		" Post CX:"+ Iif(Nvl(mwkanam.IA_postcx,0) = 1, "Si","No")+Chr(13)
		Thisform.PgConsulta.pgEvolmed.PgEvol.pgevold.edtanamnesis.Value = Thisform.PgConsulta.pgEvolmed.PgEvol.pgevold.edtanamnesis.Value +;
		'Motivo de Ingreso: ' + Alltrim(mwkCie9i.Descrip)+Chr(13)+Chr(13)

*!*			thisform.PgConsulta.pgEvolmed.PgEvol.pgevold.edtanamnesis.value = thisform.PgConsulta.pgEvolmed.PgEvol.pgevold.edtanamnesis.value +;
*!*				'Impresión diagnóstica: ' + alltrim(mwkanam.IA_impdiag)+chr(13)+chr(13)
		Select	mwkanam
		mingreso2 =  Iif(ia_egimpgral>0,"Impresión General: "+Iif(ia_egimpgral=1," Crónico ",Iif(ia_egimpgral= 2," Agudo ",'' )),'');
		+Iif(ia_gestable =1," Estable ",Iif(ia_gestable = 2," Inestable ",'' ));
		+Iif(ia_egimpnivel=1," Grave ",Iif(ia_egimpnivel= 2," Moderado ",Iif(ia_egimpnivel= 3," Leve ",'' )))+Chr(10)
		mingreso =  mingreso2
		mingreso2 =  Iif(ia_gdecubito>0," Decúbito ",'')+Iif(ia_gdecubito= 1," Prono ",;
		iif(ia_gdecubito= 2," Supino ",Iif(ia_gdecubito= 3," Lateral ",Iif(ia_gdecubito= 1," Indiferente ",'' ))))+;
		iif(ia_egdecubitoop= 1," Obligado ",Iif(ia_egdecubitoop= 2," Preferencial ",''))
		mingreso =  mingreso +Iif(!Empty(mingreso2), mingreso2+ Chr(10),'')

		mingreso2 =  Iif(!Empty(ia_gfacies),'Facies: '+Alltrim(ia_gfacies),'')

		mingreso2 =  mingreso2 + Iif(ia_egtemaxl+ia_egtemrct+ia_egtembuc>0,' Temperatura ','')+ ;
		iif(ia_egtemaxl>0,' Axilar: '+Transform(ia_egtemaxl),'')+Iif(ia_egtemrct>0,' Rectal: '+Transform(ia_egtemrct),'')+;
		iif(ia_egtembuc>0,' Bucal: '+Transform(ia_egtembuc),'')

		mingreso2 =  mingreso2 + Iif(ia_cvpresionart>0,' Presión arterial: '+Transform(ia_cvpresionart)+"/"+Transform(Nvl(ia_cvpresionartd,0)),'')+;
		iif(Val(ia_cvfreccar)>0,' Frec.Card: '+Transform(ia_cvfreccar),'')
		mingreso =  mingreso +Iif(!Empty(mingreso2), mingreso2+ Chr(10),'')

		mingreso2 =  Iif(!Empty(ia_rtiporesp),'Tipo Resp.: '+Alltrim(ia_rtiporesp),'')

		mingreso2 =  mingreso2 + Iif(ia_rfrecresp>0,' Frec.Resp.: '+Transform(ia_rfrecresp),'')+;
		iif(ia_rsato2 >0,' Saturac.O2: '+Transform(ia_rsato2 ),'')+;
		iif(ia_egfio2 >0,' FiO2: '+Transform(ia_egfio2),'') + Iif(ia_cvpvc >0,' PVC: '+Transform(ia_cvpvc)+ " cm H2O",'')
		mingreso =  mingreso +Iif(!Empty(mingreso2), mingreso2+ Chr(10),'')

		mingreso2 =  Iif(!Empty(Nvl(ia_egperfper,'')),'Perfusión Periférica: '+Alltrim(Nvl(ia_egperfper,'')),'') ++Iif(!Empty(ia_egrellcap),'Relleno Capilar: '+Alltrim(ia_egrellcap),'')
		mingreso =  mingreso +Iif(!Empty(mingreso2), mingreso2+ Chr(10),'')

		mingreso2 = Iif(Nvl(ia_egevp,0)=1,' Vías EV Perifer.: SI Acceso: '+mwkevpmodo.Descrip, ;
		iif(Nvl(ia_egevp,0)=2,' Vías EV Perifer.: NO',''))
		mingreso2 =mingreso2 + Iif(Nvl(ia_egevc,0)=1,' Vías EV Central: SI Acceso: '+mwkevcmodo.Descrip, ;
		iif(Nvl(ia_egevc,0)=2,' Vías EV Central: NO',''))
		mingreso =  mingreso +Iif(!Empty(mingreso2), mingreso2+ Chr(10),'')




		Thisform.PgConsulta.pgEvolmed.PgEvol.pgevold.edtanamnesis.Value = Thisform.PgConsulta.pgEvolmed.PgEvol.pgevold.edtanamnesis.Value ;
		+ Iif(!Empty(mingreso),'-- Evaluación General ' +Chr(10)+ Alltrim(mingreso)+Chr(13)+Chr(13),'')


*!* -----------------   Cargamos datos del page pgAnApa ------------------------------------------------------
		With .pgAnApa
*!* -----------------         Primera Página          ------------------------------------------------------
			With .page1
				.txtconst.Value   = Alltrim(Nvl(mwkanam.IA_Gconstitucion,''))
				.txtcant.Value   = Alltrim(Nvl(mwkanam.IA_GtcsCant,''))
				.txtedtipo.Value  = Alltrim(Nvl(mwkanam.IA_GedTipo,''))
				.txtedcolo.Value    = Alltrim(Nvl(mwkanam.IA_GedColor,''))
				.txtedloc.Value    = Alltrim(Nvl(mwkanam.IA_GedLoc,''))
				.txtpiel.Value    = Alltrim(Nvl(mwkanam.IA_Gpiel,''))
				.txtpielcol.Value    = Alltrim(Nvl(mwkanam.IA_GpielCol,''))
				.chkulcera.Value   = Iif(Isnull(mwkanam.IA_Gulcera),0,Iif(mwkanam.IA_Gulcera,1,0))
				.chkcicat.Value   = Iif(Isnull(mwkanam.IA_Gcicatriz),0,Iif(mwkanam.IA_Gcicatriz,1,0))
				.txtfaneras.Value = Alltrim(mwkanam.IA_Gfaneras)
				.opdadeno.Value   = Iif(mwkanam.IA_GadenoPalp ,1,2)
				Select mwkanam

				mingreso2 =  Iif(!Empty(Nvl(IA_Gconstitucion,'')),'TCS - Distribución: '+IA_Gconstitucion,'')+Iif(!Empty(Nvl(IA_GtcsCant,'')),' Cantidad: '+IA_GtcsCant,'')
				mingreso =  Iif(!Empty(mingreso2), mingreso2+ Chr(10),'')

				mingreso2 =  Iif(!Empty(Nvl(IA_GedTipo,'')),'Edemas - Tipo: '+IA_GedTipo,'')+Iif(!Empty(Nvl(IA_GedColor,'')),' Color: '+;
				IA_GedColor,'')+Iif(!Empty(Nvl(IA_GedLoc,'')),' Localización: '+IA_GedLoc,'')
				mingreso =  mingreso +Iif(!Empty(mingreso2), mingreso2+ Chr(10),'')

				mingreso2 =  Iif(!Empty(Nvl(IA_Gpiel,'')),'Piel: '+IA_Gpiel,'')+Iif(!Empty(Nvl(IA_GpielCol,'')),' Color: '+IA_GpielCol,'')+;
				iif(IA_Gulcera," Úlceras SI ",'')+Iif(IA_Gcicatriz ," Cicatrices SI",'')+;
				iif(!Empty(IA_Gfaneras),' Faneras: '+IA_Gfaneras,'')

				mingreso =  mingreso +Iif(!Empty(mingreso2), mingreso2+ Chr(10),'')
				mingreso =  mingreso +Iif(IA_GadenoPalp ,' Adenopatias Palpables: SI ','  ')+Chr(10)+Chr(10)

				Thisform.PgConsulta.pgEvolmed.PgEvol.pgevold.edtanamnesis.Value = Thisform.PgConsulta.pgEvolmed.PgEvol.pgevold.edtanamnesis.Value +;
				iif(!Empty(mingreso),'-- Piel - Faneras y TCS ' +Chr(10)+ Alltrim(mingreso)+Chr(13)+Chr(13),'')

*
			Endwith
*!* -----------------         Segunda Página -----------------------------------------------------------------
			With .page2
				Select mwkanam
				nchkojo1   = Val(Substr(Nvl(ia_ccojos,'00000'),1,1))
				nchkojo2   = Val(Substr(Nvl(ia_ccojos,'00000'),2,1))
				nchkojo3   = Val(Substr(Nvl(ia_ccojos,'00000'),3,1))
				nchkojo4   = Val(Substr(Nvl(ia_ccojos,'00000'),4,1))
				nchkojo5   = Val(Substr(Nvl(ia_ccojos,'00000'),5,1))
				noptro1   = Val(Substr(ia_ccreflejooc,1,1))
				noptro2   = Val(Substr(ia_ccreflejooc,2,1))
				nchkro3   = Val(Substr(ia_ccreflejooc,3,1))
				noptro4   = Val(Substr(ia_ccreflejooc,4,1))
				nchkro5   = Val(Substr(ia_ccreflejooc,5,1))
				nchkro6   = Val(Substr(ia_ccreflejooc,6,1))
				.txtconst.Value = Alltrim(mwkanam.IA_CCtipo)
				.txthp.Value    = Alltrim(mwkanam.IA_CChendpalp)
				.txtconj.Value  = Alltrim(mwkanam.IA_CCconjuntivas)
				.chkojo1.Value   = nchkojo1
				.chkojo2.Value   = nchkojo2
				.chkojo3.Value   = nchkojo3
				.chkojo4.Value   = nchkojo4
				.chkojo5.Value   = nchkojo5
				.optro1.Value   = noptro1
				.optro2.Value   = noptro2
				.chkro3.Value   = nchkro3
				.optro4.Value   = noptro4
				.chkro5.Value   = nchkro5
				.chkro6.Value   = nchkro6
				.txtfdo.Value   = mwkanam.IA_CCfdoojo
				.txtfosa.Value  = mwkanam.IA_CCfosasNas
				.txtboca.Value  = mwkanam.IA_CCboca
				.txtoido.Value  = mwkanam.IA_CCoido
				.txtiy.Value	  = mwkanam.IA_CCingYug
				.txtlv.Value	  = mwkanam.IA_CClatVen
				.txtlcar.Value  = mwkanam.IA_CClatCar
				.txtsoplo.Value = mwkanam.IA_CCsoplo
				.txttiroi.Value = mwkanam.IA_CCtiroides
				.txtotro.Value  = mwkanam.IA_CCotro
				Select mwkANPupilas
				Locate For estado = mwkanam.IA_CCpupilas
				If Eof()
					Go Top
				Endif
				.cbopupilas.Refresh()
				Select mwkANMucosa
				Locate For estado = mwkanam.IA_CCmucosas
				If Eof()
					Go Top
				Endif
				.cbomucosa.Refresh()
				Select mwkanam
				mingreso2 =  Iif(!Empty(IA_CCtipo),'Tipo: '+IA_CCtipo,'')+;
				iif(!Empty(IA_CChendpalp),' Hend.palp.: '+IA_CChendpalp,'')+;
				iif(!Empty(IA_CCconjuntivas),' Conjuntivas: '+IA_CCconjuntivas,'')+;
				iif(!Empty(mwkANPupilas.Descrip), " Pupilas: "+mwkANPupilas.Descrip,'')

				mingreso =  Iif(!Empty(mingreso2), mingreso2+ Chr(10),'')

				mingreso2 =  Iif(ia_ccojos='00000','','Ojos: ')+Iif(nchkojo1 = 1,' Exoftalmos ','')+;
				iif(nchkojo2 = 1,' Enoftalmos','') + Iif(nchkojo3 = 1,' Desviación Conj.','')+;
				iif(nchkojo4 = 1,' Desviación Desconj.','')+Iif(nchkojo5 = 1,' Nistagmos ','')
				mingreso =  mingreso +Iif(!Empty(mingreso2), mingreso2+ Chr(10),'')

				mingreso2 =  Iif(noptro1 = 1,' Fotomotor: SI ',Iif(noptro1 = 2,' Fotomotor: NO ',''))+ ;
				iif(noptro2 = 1,' Consensual: SI ',Iif(noptro2 = 2,' Consensual: NO ',''))+;
				iif(noptro4 = 1,' Corneano: SI ',Iif(noptro4 = 2,' Corneano: NO ',''))+;
				iif(nchkro3 = 1,' Acomodador ','')+;
				iif(nchkro5 = 1,' Oculocefálicos ','')+Iif(nchkro6 = 1,' Oculovestibular ','')

				mingreso =  mingreso +Iif(!Empty(mingreso2), 'Reflejos '+mingreso2+ Chr(10),'')

				mingreso2 =  Iif(!Empty(IA_CCfdoojo),'Fondo de ojos: '+IA_CCfdoojo,'')+Iif(!Empty(IA_CCfosasNas),' Fosas nasales: '+IA_CCfosasNas,'')

				mingreso =  mingreso +Iif(!Empty(mingreso2), mingreso2+ Chr(10),'')

				mingreso2 =  Iif(!Empty(IA_CCboca),'Boca: '+IA_CCboca,'')+Iif(!Empty(mwkANMucosa.Descrip), " Mucosas: "+mwkANMucosa.Descrip,'')+;
				iif(!Empty(IA_CCoido),' Oído: '+IA_CCoido,'')

				mingreso =  mingreso +Iif(!Empty(mingreso2), mingreso2+ Chr(10),'')

				mingreso2 =  Iif(!Empty(IA_CCingYug),'Ingurgit.Yugular: '+IA_CCingYug,'')+Iif(!Empty(IA_CClatVen),' Latido venoso: '+IA_CClatVen,'')+;
				iif(!Empty(IA_CClatCar),' Latido carot.: '+IA_CClatCar,'')+ Iif(!Empty(IA_CCsoplo),' Soplo carot.: '+IA_CCsoplo,'')
				mingreso =  mingreso +Iif(!Empty(mingreso2), mingreso2+ Chr(10),'')

				mingreso2 =  Iif(!Empty(IA_CCtiroides),'Tiroides: '+IA_CCtiroides,'')+Iif(!Empty(IA_CCotro),' Otro: '+IA_CCotro,'')
				mingreso =  mingreso +Iif(!Empty(mingreso2), mingreso2+ Chr(10),'')

				Select mwkanam
				Thisform.PgConsulta.pgEvolmed.PgEvol.pgevold.edtanamnesis.Value = Thisform.PgConsulta.pgEvolmed.PgEvol.pgevold.edtanamnesis.Value +;
				iif(!Empty(mingreso),'-- Cabeza y Cuello ' +Chr(10)+ Alltrim(mingreso)+Chr(13)+Chr(13),'')



			Endwith
			Select mwkanam
*!* -----------------         Tercera Página -----------------------------------------------------------------
			With .page3
				.txttorax.Value =  Alltrim(mwkanam.IA_RtipoTorax)
				.txtinsp.Value  =  Alltrim(mwkanam.IA_Rinspeccion)
				.txtpalp.Value  =  Alltrim(mwkanam.IA_Rpalpacion)
				.txtperc.Value  =  Alltrim(mwkanam.IA_Rpercusion)
				.txtausc.Value  =  Alltrim(mwkanam.IA_Rauscultacion)
				.optdrenpleu.Value    = Nvl(mwkanam.IA_EGdrenP,0)
				Select mwkDPModo
				Go Top
				Locate For estado = Nvl(mwkanam.IA_EGdrenPAcc,0)
				If !Found()
					Go Top
				Endif
				.cboDPacc.Refresh()
				Select mwkEVPModoa
				Go Top
				Locate For estado = Nvl(mwkanam.IA_EGevpAcc,0)
				If !Found()
					Go Top
				Endif
				Select mwkanam
				.chktora.Value =  Nvl(mwkanam.IA_EGtorac,0)
				.chkTraq.Value = Nvl(mwkanam.IA_EGtraq,0)
				mingreso2 =  Iif(!Empty(IA_RtipoTorax),'Tipo torax: '+IA_RtipoTorax,'')+;
				iif(IA_EGtorac,' Toracotomía SI','') + Iif(IA_EGtraq,' Traqueostomía: SI ','')
				mingreso =   Iif(!Empty(mingreso2), mingreso2+ Chr(10),'')

				mingreso =  mingreso + Iif(!Empty(IA_Rinspeccion),'Inspección: '+IA_Rinspeccion+Chr(10),'')

				mingreso2 =  Iif(!Empty(IA_Rpalpacion),'Palpación: '+IA_Rpalpacion,'')+Iif(!Empty(IA_Rpercusion),'Percusión: '+IA_Rpercusion,'')
				mingreso =  mingreso +Iif(!Empty(mingreso2), mingreso2+ Chr(10),'')

				mingreso =  mingreso + Iif(!Empty(IA_Rauscultacion),'Auscultación: '+IA_Rauscultacion+Chr(10),'')



				Thisform.PgConsulta.pgEvolmed.PgEvol.pgevold.edtanamnesis.Value = Thisform.PgConsulta.pgEvolmed.PgEvol.pgevold.edtanamnesis.Value +;
				iif(!Empty(mingreso),'-- Aparato Respiratorio ' +Chr(10)+ Alltrim(mingreso)+Chr(13)+Chr(13),'')

			Endwith
*!* -----------------         Cuarta Página -----------------------------------------------------------------
			With .page4
				.chklcvis.Value	=  Iif(Isnull(mwkanam.IA_CVlcVis),0,Iif(mwkanam.IA_CVlcVis,1,0))
				.chklcpal.Value	=  Iif(Isnull(mwkanam.IA_CVlcPal),0,Iif(mwkanam.IA_CVlcPal,1,0))
				.chkSoplo.Value	=  Iif(Isnull(mwkanam.IA_CVsoplo),0,Iif(mwkanam.IA_CVsoplo,1,0))
				.txtsoploLoc.Value   = Alltrim(Nvl(mwkanam.IA_CVsoploLoc,''))
				.txtsoploInt.Value   = Nvl(mwkanam.IA_CVsoploInt,0)
				.txtlcp.Value   = Alltrim(mwkanam.IA_CVlatcarp)
				.txtperc.Value  = Alltrim(mwkanam.IA_CVpulsoRad)
				.txtcaract.Value = Alltrim(mwkanam.IA_CVcaract)
				.txtpp.Value    = Alltrim(mwkanam.IA_CVpulsosPerif)
				.optr1.Value    = Nvl(mwkanam.IA_CVr1o,0)
				.optr2.Value    = Nvl(mwkanam.IA_CVr2o,0)
				.optr3.Value	= Nvl(mwkanam.IA_CVr3o,0)
				.optr3g.Value	= Nvl(mwkanam.IA_CVr3g,0)
				.optr4.Value	= Nvl(mwkanam.IA_CVr4o,0)
				.txtsis.Value    = Alltrim(mwkanam.IA_CVsistole)
				.txtdias.Value   = Alltrim(mwkanam.IA_CVdiastole)
				.chkfrotes.Value  = Nvl(mwkanam.IA_CVfrotes,0)
				.chkfrem.Value  = Nvl(mwkanam.IA_CVfrem,0)
				Select mwkanam
				mingreso2 =  Iif(IA_CVlcVis Or IA_CVlcPal,'Latido cardíaco: ','')+Iif(IA_CVlcVis ,' Visible ','')+;
				iif(IA_CVlcPal,' Palpable ','') + Iif(IA_CVsoplo,' Soplo SI '+Iif(!Empty(IA_CVsoploLoc),' Localización: '+IA_CVsoploLoc,'')+;
				" intensidad: "+Transform(IA_CVsoploInt)+"/6",'')
				mingreso =   Iif(!Empty(mingreso2), mingreso2+ Chr(10),'')

				mingreso2 =  Iif(!Empty(IA_CVlatcarp),'Latido cardíaco se palpa: '+IA_CVlatcarp,'')+;
				iif(!Empty(IA_CVpulsoRad),' Pulso radial: '+IA_CVpulsoRad,'') +Iif(!Empty(IA_CVcaract),' Características: '+IA_CVcaract,'')
				mingreso =  mingreso +Iif(!Empty(mingreso2), mingreso2+ Chr(10),'')

				mingreso =  mingreso +Iif(!Empty(IA_CVpulsosPerif),' Pulsos perif.: '+IA_CVpulsosPerif+ Chr(10),'')
				mcides1 = Iif(IA_CVr1o=1,"Normal",Iif(IA_CVr1o=2,"Aumentado",Iif(IA_CVr1o=3,"Disminuído",Iif(IA_CVr1o=4,"Desdoblado",''))))
				mcides2 = Iif(IA_CVr2o=1,"Normal",Iif(IA_CVr2o=2,"Aumentado",Iif(IA_CVr2o=3,"Disminuído",Iif(IA_CVr2o=4,"Desdoblado",''))))

				mingreso2 =  Iif(IA_CVr1o>0,' R1 '+mcides1 ,'')+ " "+Iif(IA_CVr2o>0,' R1 '+mcides2 ,'')+;
				iif(IA_CVr3o= 1,' R3: SI ',Iif(IA_CVr3o= 2,' R3: NO ',''))+;
				iif(IA_CVr3g= 1,' Galope: SI ',Iif(IA_CVr3g= 2,' Galope: NO ',''))+;
				iif(IA_CVr4o= 1,' R4: SI ',Iif(IA_CVr4o= 2,' R4: NO ',''))

				mingreso =  mingreso +Iif(!Empty(mingreso2), mingreso2+ Chr(10),'')
				mingreso2 =  Iif(!Empty(IA_CVsistole),'Sístole: '+IA_CVsistole,'')+Iif(!Empty(IA_CVdiastole),' Diástole: '+IA_CVdiastole,'');
				+Iif(IA_CVfrem,' Frotes SI','') +Iif(IA_CVfrem,' Frémitos SI ','')
				mingreso =  mingreso +Iif(!Empty(mingreso2), mingreso2+ Chr(10),'')



				Thisform.PgConsulta.pgEvolmed.PgEvol.pgevold.edtanamnesis.Value = Thisform.PgConsulta.pgEvolmed.PgEvol.pgevold.edtanamnesis.Value +;
				iif(!Empty(mingreso),'-- Ap. Cardiovascular ' +Chr(10)+ Alltrim(mingreso)+Chr(13)+Chr(13),'')

			Endwith
*!* -----------------         Quinta Página -----------------------------------------------------------------
			With .page5
				.txtinsp.Value = Alltrim(mwkanam.IA_AGinspeccion)
				.txtresp.Value = Alltrim(mwkanam.IA_AGdrenaje)
				.optinsp.Value = Nvl(mwkanam.IA_AGinsp,0)
				.optpalpa.Value = Nvl(mwkanam.IA_AGpalp,0)
				.optdolor.Value = Nvl(mwkanam.IA_AGdolor,0)
				.txthig.Value  = Alltrim(mwkanam.IA_AGhigado)
				.optPure.Value  = Nvl(mwkanam.IA_AGptosU,0)
				.txttr.Value   = Alltrim(mwkanam.IA_AGAGtacto)
				.chkAsc.Value = Nvl(mwkanam.IA_AGasc,0)
				.optBazo.Value = Nvl(mwkanam.IA_AGbazo,0)
				.optRha.Value  = Iif(Isnull(mwkanam.IA_AGRHA),0,Iif(mwkanam.IA_AGRHA,1,2))
				.optPPL.Value  = Iif(Isnull(mwkanam.IA_AGPPL),0,Iif(mwkanam.IA_AGPPL,1,1))
				.ChkSNG.Value = Nvl(mwkanam.IA_EGSNG,0)
				.chksv.Value = Nvl(mwkanam.IA_EGSV,0)
				Select mwkanam
				mcides1 = Iif(IA_AGpalp=1,"Blando",Iif(IA_AGpalp=2,"Tenso",Iif(IA_AGpalp=3,"Masa Palpable",'')))
				mingreso2 =  Iif(IA_AGpalp>0,' Palpación '+mcides1 ,'')+Iif(!Empty(IA_AGdrenaje),' Drenajes: '+IA_AGdrenaje,'')
				mingreso =  mingreso +Iif(!Empty(mingreso2), mingreso2+ Chr(10),'')

				mcides1 = Iif(IA_AGdolor=1,"Superficial",Iif(IA_AGdolor=2,"Profundo",Iif(IA_AGdolor=3,"A la descompresión",'')))

				mingreso2 =  Iif(IA_AGdolor>0,' Dolor '+mcides1 ,'')+Iif(!Empty(IA_AGhigado),' Hígado: '+IA_AGhigado,'')
				mingreso =  mingreso +Iif(!Empty(mingreso2), mingreso2+ Chr(10),'')

				mingreso2 =  Iif(IA_AGptosU= 1,' Puntos Ureterales (+) ',Iif(IA_AGptosU= 2,' Puntos Ureterales (-) ',''))+;
				iif(IA_AGasc,' Ascitis: SI ','')+Iif(!Empty(IA_AGAGtacto),' Tacto rectal: '+IA_AGAGtacto,'')

				mingreso =  mingreso +Iif(!Empty(mingreso2), mingreso2+ Chr(10),'')

				mingreso2 =  Iif(IA_AGbazo = 1,' Bazo Palpable ',Iif(IA_AGbazo = 2,' Bazo No Palpable  ',''))+;
				iif(IA_AGRHA,' RHA (+) ',' ')+ Iif(IA_AGPPL,' PPL (+) ',' ')+;
				iif(IA_EGSNG,' SNG SI','') +Iif(IA_EGSV,' SV SI ','')  &&RHA (-) ---  PPL (-)
				mingreso =  mingreso +Iif(!Empty(mingreso2), mingreso2+ Chr(10),'')

				Thisform.PgConsulta.pgEvolmed.PgEvol.pgevold.edtanamnesis.Value = Thisform.PgConsulta.pgEvolmed.PgEvol.pgevold.edtanamnesis.Value +;
				iif(!Empty(mingreso),'-- Ap.G.Urinario - Abdomen  ' +Chr(10)+ Alltrim(mingreso)+Chr(13)+Chr(13),'')

			Endwith
*!* -----------------         Sexta Página -----------------------------------------------------------------
			With .page6
				.txtEd_an_loc.Value = Alltrim(mwkanam.IA_locomotor)
				Select mwkanam
				mingreso =  Iif(!Empty(mwkanam.IA_locomotor),mwkanam.IA_locomotor+ Chr(10),'')
				Thisform.PgConsulta.pgEvolmed.PgEvol.pgevold.edtanamnesis.Value = Thisform.PgConsulta.pgEvolmed.PgEvol.pgevold.edtanamnesis.Value +;
				iif(!Empty(mingreso),'-- Aparato Locomotor ' +Chr(10)+ Alltrim(mingreso)+Chr(13)+Chr(13),'')

			Endwith
*!* -----------------         Séptima Página -----------------------------------------------------------------
			With .page7
				Select mwkANConciencia
				Locate For estado = mwkanam.IA_NSconciencia
				If Eof()
					Go Top
				Endif
				.cboconc.Refresh()
				Select mwkanam
				.txtpares.Value  = Alltrim(mwkanam.IA_NSparesCran)
				.txtgmot.Value   = mwkanam.IA_NSGmot
				.txtgver.Value   = mwkanam.IA_NSGver
				.txtgocu.Value   = mwkanam.IA_NSGocu
				.txtGlas1.Value  = .txtgmot.Value + .txtgver.Value    + .txtgocu.Value
				nchkmvsd   = Val(Substr(ia_nsmovvol,1,1))
				nchkmvsi   = Val(Substr(ia_nsmovvol,2,1))
				nchkmvid   = Val(Substr(ia_nsmovvol,3,1))
				nchkmvii   = Val(Substr(ia_nsmovvol,4,1))
				.chkmvsd.Value   = nchkmvsd
				.chkmvsi.Value   = nchkmvsi
				.chkmvid.Value   = nchkmvid
				.chkmvii.Value   = nchkmvii
				nchkrosd   = Val(Substr(ia_nsreflejoost,1,1))
				nchkrosi   = Val(Substr(ia_nsreflejoost,2,1))
				nchkroid   = Val(Substr(ia_nsreflejoost,3,1))
				nchkroii   = Val(Substr(ia_nsreflejoost,4,1))
				.chkrosd.Value   = nchkrosd
				.chkrosi.Value   = nchkrosi
				.chkroid.Value   = nchkroid
				.chkroii.Value   = nchkroii
				nchkssd    = Val(Substr(ia_nssensib,1,1))
				nchkssi    = Val(Substr(ia_nssensib,2,1))
				nchksid    = Val(Substr(ia_nssensib,3,1))
				nchksii    = Val(Substr(ia_nssensib,4,1))

				.chkssd.Value    = nchkssd
				.chkssi.Value    = nchkssi
				.chksid.Value    = nchksid
				.chksii.Value    = nchksii

				nchkmpsd   = Val(Substr(Nvl(ia_nsmovpas,'00000'),1,1))
				nchkmpsi   = Val(Substr(Nvl(ia_nsmovpas,'00000'),2,1))
				nchkmpid   = Val(Substr(Nvl(ia_nsmovpas,'00000'),3,1))
				nchkmpii   = Val(Substr(Nvl(ia_nsmovpas,'00000'),4,1))
				.chkmpsd.Value   = nchkmpsd
				.chkmpsi.Value   = nchkmpsi
				.chkmpid.Value   = nchkmpid
				.chkmpii.Value   = nchkmpii

				nchkcga   = Val(Substr(Nvl(ia_nscabgral,'00000000'),1,1))
				nchkcgp   = Val(Substr(Nvl(ia_nscabgral,'00000000'),2,1))
				nchkcgr   = Val(Substr(Nvl(ia_nscabgral,'00000000'),3,1))
				nchkcgrf   = Val(Substr(Nvl(ia_nscabgral,'00000000'),4,1))
				nchkcgs   = Val(Substr(Nvl(ia_nscabgral,'00000000'),5,1))
				nchkcgsf   = Val(Substr(Nvl(ia_nscabgral,'00000000'),6,1))
				nchkbabin   = Val(Substr(Nvl(ia_nscabgral,'00000000'),7,1))

				.chkcga.Value   = nchkcga
				.chkcgp.Value   = nchkcgp
				.chkcgr.Value   = nchkcgr
				.chkcgrf.Value   = nchkcgrf
				.chkcgs.Value   = nchkcgs
				.chkcgsf.Value   = nchkcgsf
				.txtNivsens.Value  = Alltrim(Nvl(mwkanam.IA_NSnivSens,''))

				.chkbabin.Value   = nchkbabin

				.chkce.Value   = Nvl(mwkanam.IA_NSctrlEsf,0)
				.chksep.Value   = Nvl(mwkanam.IA_NSsgExP,0)
				.chksm.Value   = Nvl(mwkanam.IA_NSsgMen,0)
				.txttaxia.Value   = Nvl(mwkanam.IA_NStaxia,'')
				.txtpraxia.Value   = Nvl(mwkanam.IA_NSpraxia,'')
				.chkTax.Value = Nvl(mwkanam.IA_NStaxiao,0)
				.chkprax.Value = Nvl(mwkanam.IA_NSpraxiao,0)
				.chkpros.Value = Nvl(mwkanam.IA_NSprosexia,0)
				.chkamn.Value = Nvl(mwkanam.IA_NSamnesia,0)
				.txtpsi.Value    = Alltrim(mwkanam.IA_NSpsiquis)
				.chkexc.Value   = Iif(mwkanam.IA_NSpsiq1,1,0)
				.chkdep.Value  = Iif(mwkanam.IA_NSpsiq2,1,0)
				.chkans.Value  = Iif(mwkanam.IA_NSpsiq3,1,0)
				.chkbrad.Value = Iif(mwkanam.IA_NSpsiq4,1,0)
				.chkabul.Value  = Iif(mwkanam.IA_NSpsiq5,1,0)

				Select mwkanam
				mingreso2 = Iif(!Empty(mwkANConciencia.Descrip),' Conciencia: '+mwkANConciencia.Descrip,'') +;
				iif(!Empty(IA_NSparesCran),'Pares craneanos: '+Alltrim(IA_NSparesCran),'')
				mingreso =  Iif(!Empty(mingreso2), mingreso2+ Chr(10),'')

				mingreso2 =  Iif(IA_NSGmot+IA_NSGver+IA_NSGocu>0,'Glasgow: '+Transform(IA_NSGmot+IA_NSGver+IA_NSGocu)+"/15 "+' Respuesta Motora '+gMot(IA_NSGmot)+;
				' respuesta verbal '+gver(IA_NSGver)+' Respuesta Ocular '+gocu(IA_NSGocu),'')
				mingreso =  mingreso +Iif(!Empty(mingreso2), mingreso2+ Chr(10),'')

				mingreso2 =  Iif(Left(ia_nsmovvol,4)='0000' And nchkcga=0,'','Motilidad activa: '+ Iif(nchkcga = 1,' General ','')+;
				iif(nchkmvsd = 1,' MSD ','')+Iif(nchkmvsi = 1,' MSI ','')+;
				iif(nchkmvid = 1,' MID ','')+Iif(nchkmvii = 1,' MII ',''))

				mingreso =  mingreso +Iif(!Empty(mingreso2), mingreso2+ Chr(10),'')

				mingreso2 =  Iif(Left(ia_nsmovpas,4)='0000' And nchkcgp=0,'','Motilidad pasiva: '+ Iif(nchkcgp = 1,' General ','')+;
				iif(nchkmpsd = 1,' MSD ','')+Iif(nchkmpsi = 1,' MSI ','')+;
				iif(nchkmpid = 1,' MID ','')+Iif(nchkmpii = 1,' MII ',''))

				mingreso =  mingreso +Iif(!Empty(mingreso2), mingreso2+ Chr(10),'')

				mingreso2 =  Iif(Left(ia_nsreflejoost,4)='0000' And nchkcgr=0 And nchkcgrf=0,'','Reflejos Profundos: '+ Iif(nchkcgr = 1,' General ','')+;
				iif(nchkrosd = 1,' MSD ','')+Iif(nchkrosi = 1,' MSI ','')+;
				iif(nchkroid = 1,' MID ','')+Iif(nchkroii = 1,' MII ','')+Iif(nchkcgrf = 1,' Flexor Plantar ',''))

				mingreso =  mingreso +Iif(!Empty(mingreso2), mingreso2+ Chr(10),'')

				mingreso2 =  Iif(Left(ia_nssensib,4)='0000' And nchkcgs=0 And nchkcgsf=0,'','Alterac.Sensibilidad: '+ Iif(nchkcgs = 1,' General ','')+;
				iif(nchkssd = 1,' MSD ','')+Iif(nchkssi = 1,' MSI ','')+;
				iif(nchksid = 1,' MID ','')+Iif(nchksii = 1,' MII ','')+Iif(nchkcgsf = 1,' Flexor Plantar ',''))

				mingreso =  mingreso +Iif(!Empty(mingreso2), mingreso2+ Chr(10),'')

				mingreso2 = Iif(!Empty(IA_NSnivSens),'Nivel Sensitivo: '+Alltrim(IA_NSnivSens),'')+ Iif(IA_NSctrlEsf,' Continencia Esfínteres SI','')+;
				iif(IA_NSsgExP,' Signos Estrapiramidales SI','')+Iif(IA_NSsgMen,' Signos Meníngeos SI','')+;
				iif(nchkbabin = 1,' Babinski SI','')
				mingreso =  mingreso +Iif(!Empty(mingreso2), mingreso2+ Chr(10),'')
				mingreso2 = Iif(!Empty(IA_NStaxia),'Taxia: '+Alltrim(IA_NStaxia),'')+  Iif(!Empty(IA_NSpraxia),' Praxia: '+Alltrim(IA_NSpraxia),'')
				mingreso =  mingreso +Iif(!Empty(mingreso2), mingreso2+ Chr(10),'')

				mingreso2 = 	Iif(IA_NStaxiao ,' Taxia SI','')+Iif(IA_NSpraxiao,' Praxia SI','')+;
				iif(IA_NSamnesia,' Amnesia SI','')+Iif(!Empty(IA_NSpsiquis),' Psiquismo: '+Alltrim(IA_NSpsiquis),'')+;
				iif(IA_NSpsiq1,' Excitación SI','')+Iif(IA_NSpsiq2,' Depresión SI','')+;
				iif(IA_NSpsiq3,' Ansiedad SI','')+Iif(IA_NSpsiq4,' Bradipsiquia SI','')+Iif(IA_NSpsiq5,' Abulia SI','')

				mingreso =  mingreso +Iif(!Empty(mingreso2), mingreso2+ Chr(10),'')

				miedit = Iif(!Empty(mingreso),'-- Neurológico ' + Chr(10)+Alltrim(mingreso)+Chr(13)+Chr(13),'')

				miedit= miedit+'Impresión diagnóstica: ' + Chr(13)+Alltrim(IA_impdiag)+Chr(13)+Chr(13)

				miedit= miedit+Iif(!Empty(IA_Planterap),'Plan Diagnóstico y Terapéutico: ' + Chr(13)+Alltrim(IA_Planterap)+Chr(13)+Chr(13),'')


				Thisform.PgConsulta.pgEvolmed.PgEvol.pgevold.edtanamnesis.Value = Thisform.PgConsulta.pgEvolmed.PgEvol.pgevold.edtanamnesis.Value +;
				miedit


			Endwith
*!* -----------------         primer Página -----------------------------------------------------------------
			With .page8
				.OptEstable.Value = Nvl(mwkanam.ia_gestable ,0)
				.OptPos.Value	= mwkanam.ia_gdecubito
				.optIG.Value    = Nvl(mwkanam.ia_egimpgral,0)
				.optnivel.Value = Nvl(mwkanam.ia_egimpnivel,0)
				.optposOB.Value = Nvl(mwkanam.ia_egdecubitoop,0)
				.txtfacies.Value	= Alltrim(mwkanam.ia_gfacies)
				.txthing.Value		= Nvl(mwkanam.ia_FechaHoraIng,Thisform.txthing.Value)
				.TxtTempAx.Value	=  Nvl(mwkanam.ia_egtemaxl,0)
				.TxtTempRt.Value	=  Nvl(mwkanam.ia_egtemrct,0)
				.TxtTempBc.Value	=  Nvl(mwkanam.ia_egtembuc,0)
				.lblingreso.Caption = 'Ingreso a ' + Nvl(mwkinterna.IH_secagrup,'')

				.txtPA.Value     = mwkanam.ia_cvpresionart
				.txtPAd.Value     = Nvl(mwkanam.ia_cvpresionartd,0)
				.txtfc.Value    = Nvl(mwkanam.ia_cvfreccar,'0')

				.txtresp.Value  =  Alltrim(mwkanam.ia_rtiporesp)
				.txtfr.Value	=  mwkanam.ia_rfrecresp
				.TxtSat.Value	=  Nvl(mwkanam.ia_rsato2 ,0)
				.txtfio2.Value	=  Nvl(mwkanam.ia_egfio2,0)
				.txtpvc.Value    = mwkanam.ia_cvpvc
				.txtpper.Value   = Alltrim(Nvl(mwkanam.ia_egperfper,''))
				.txtrcap.Value   = Alltrim(Nvl(mwkanam.ia_egrellcap,''))
				.cbovevpacc.Refresh()
				Select mwkEVCModoa
				Go Top
				Locate For estado = Nvl(mwkanam.IA_EGevCAcc,0)
				If !Found()
					Go Top
				Endif
				.cboVCacc.Refresh()
				Select mwkanam
				.optvevp.Value    = Nvl(mwkanam.ia_egevp,0)
				.optvia.Value    = Nvl(mwkanam.ia_egevc,0)


			Endwith
		Endwith
	Else

		If mwkinsden.estado = 1
			Thisform.lalertacovid= (Reccount('mwkservicres')=0)
*!*				mm= "En virtud de la Emergencia Sanitaria dictada con motivo de la pandemia "+;
*!*					"mundial por COVID 19, y conforme las pautas definidas por los "+;
*!*					"Ministerios de Salud de la Nación y de la Ciudad Autónoma de Buenos "+;
*!*					"Aires , y a fin de evitar la posibilidad de transmisión del virus a través del "+;
*!*					"papel utilizado en la atencion de los pacientes que ingresan con "+;
*!*					"sospecha de COVID, amparados además en leyes que penan todas "+;
*!*					"aquellas acciones que puedan poner en peligro la Salud Pública, la "+;
*!*					"Institución ha decidido que mientras dure la Emergencia Sanitaria todos "+;
*!*					"los consentimientos informados y cualquier otra manifestación de "+;
*!*					"voluntad de los pacientes internados serán otorgados de manera verbal. "+;
*!*					"El profesional deberá dejar registro de dicho acto en la HCE al momento "+;
*!*					"de ser expresada la voluntad del paciente ."
*!*				Messagebox(mm,64,"Normativa Vigente")
		Endif
*!* -----------------   Blanqueamos datos del page pgAnApa ------------------------------------------------------
		With .pgAnDiagno
			misec = mwkpacint1.SEC_CODSECTOR
*!*				If !(mwkmedicoactual.codprof # 2 Or Thisform.lauditoria) And Reccount('mwksugserv')>0 ;
*!*					AND  !Inlist(misec , 'PQU','PRP','EME','CEG')
*!*					Do sp_busco_estados With 25,' and tipo = 34 and subestado = 1 order by descrip ','mwkservicioR'
*!*					Select mwkservicioR
*!*					Locate For estado = mwksugserv.sc_servicio
*!*					mimensa = "Estimado profesional."+Chr(13)+"El diagnóstico consignado es:"+Alltrim(mwksugserv.Descrip)+Chr(13)+;
*!*					"y la especialidad responsable:"+Alltrim(mwkservicioR.Descrip)+Chr(13)+"¿Confirma estos datos?"
*!*					If Messagebox(mimensa,4+32+256,"Datos de la derivación")<>6
*!*						Thisform.lestadosug = 9
*!*	***anulo la sugerencia
*!*					Else
*!*	**cargo datos
*!*						Thisform.lestadosug =2
*!*						Thisform.asignasugerencia()
*!*					Endif
*!*				Endif
			.page1.txtEd_an_impDiag.Value =  ''
			.page1.txtprofresp.Value = ''
			.page2.txtEd_an_planT.Value   = ''
			With .page3
*!*					msag = nvl(mwkinterna.IH_secagrup,'')
*!*					if (!thisform.lauditoria and inlist(msag,"UCI","UCER","UCO","PED","NNT") )
*!*						select mwksecagrupnew
*!*						locate for sectoragrup = msag
*!*						mides = mwksecagrupnew.descripcion
*!*						.grid1.recordsource = ''
*!*						midia = ttod(mwkfecserv.fechahora)
*!*						mid = reccount('mwkservires')+1
*!*						insert into mwkservires (descserv,  IS_fechaHD , IS_fechaHH,is_servicio,id );
*!*							values (mides,midia,ctod("01/01/2100"),0,mid)
*!*						select mwkservires
*!*						go top
*!*						.grid1.recordsource = "select * from mwkservires into cursor mwkserviresg"
*!*					endif
			Endwith
		Endwith

		With .pgAnApa
*!* -----------------         Primera Página          ------------------------------------------------------
			With .page1
				.txtconst.Value   = ''
				.txtcant.Value   = ''
				.txtedtipo.Value  = ''
				.txtedcolo.Value    = ''
				.txtedloc.Value    = ''
				.txtpiel.Value    = ''
				.txtpielcol.Value    = ''
				.chkulcera.Value   = 0
				.chkcicat.Value   = 0
				.txtfaneras.Value = ''
				.opdadeno.Value   = 0
			Endwith
*!* -----------------         Segunda Página -----------------------------------------------------------------
			With .page2
				.txtconst.Value = ''
				.txthp.Value    = ''
				.txtconj.Value  = ''
				.chkojo1.Value   = 0
				.chkojo2.Value   = 0
				.chkojo3.Value   = 0
				.chkojo4.Value   = 0
				.chkojo5.Value   = 0
				.optro1.Value   = 0
				.optro2.Value   = 0
				.chkro3.Value   = 0
				.optro4.Value   = 0
				.chkro5.Value   = 0
				.chkro6.Value   = 0
				.txtfdo.Value   = ''
				.txtfosa.Value  = ''
				.txtboca.Value  = ''
				.txtoido.Value  = ''
				.txtiy.Value	  = ''
				.txtlv.Value	  = ''
				.txtlcar.Value  = ''
				.txtsoplo.Value = ''
				.txttiroi.Value = ''
				.txtotro.Value  = ''
				Select mwkANPupilas
				Go Top
				.cbopupilas.Refresh()
				Select mwkANMucosa
				Go Top
				.cbomucosa.Refresh()
			Endwith
*!* -----------------         Tercera Página -----------------------------------------------------------------
			With .page3
				.txttorax.Value =  ''
				.txtinsp.Value  =  ''
				.txtpalp.Value  =  ''
				.txtperc.Value  =  ''
				.txtausc.Value  =  ''
				.chkTraq.Value = 0
				.chktora.Value = 0

				.optdrenpleu.Value    = 0
				Select mwkDPModo
				Go Top
				.cboDPacc.Refresh()
			Endwith
*!* -----------------         Cuarta Página -----------------------------------------------------------------
			With .page4
				.chklcvis.Value	= 0
				.chklcpal.Value	= 0
				.chkSoplo.Value	= 0
				.txtsoploLoc.Value = ''
				.txtsoploInt.Value   = 0
				.txtlcp.Value   = ''
				.txtperc.Value  = ''
				.txtcaract.Value = ''
				.txtpp.Value    = ''
				.optr1.Value    = 0
				.optr2.Value    = 0
				.optr3.Value	= 0
				.optr3g.Value	= 0
				.optr4.Value	= 0
				.txtsis.Value    = ''
				.txtdias.Value   = ''
				.chkfrotes.Value  = 0
				.chkfrem.Value  = 0
			Endwith
*!* -----------------         Quinta Página -----------------------------------------------------------------
			With .page5
				.txtinsp.Value = ''
				.txtresp.Value = ''
				.optBazo.Value = 0
				.txthig.Value  = ''
				.optRha.Value  = 0
				.optPPL.Value  = 0
				.txttr.Value   = ''
				.ChkSNG.Value = 0
				.chksv.Value = 0

			Endwith
*!* -----------------         Sexta Página -----------------------------------------------------------------
			With .page6
				.txtEd_an_loc.Value = ''
			Endwith
*!* -----------------         Séptima Página -----------------------------------------------------------------
			With .page7
				Select mwkANConciencia
				Go Top
				.cboconc.Refresh()
				.txtpares.Value  = ''
				.txtgmot.Value   = 0
				.txtgver.Value   = 0
				.txtgocu.Value   = 0
				.txtGlas1.Value  = .txtgmot.Value + .txtgver.Value    + .txtgocu.Value
				.chkmvid.Value   = 0
				.chkmvii.Value   = 0
				.chkmvsd.Value   = 0
				.chkmvsi.Value   = 0
				.chkroid.Value   = 0
				.chkroii.Value   = 0
				.chkrosd.Value   = 0
				.chkrosi.Value   = 0
				.chksid.Value    = 0
				.chksii.Value    = 0
				.chkssd.Value    = 0
				.chkssi.Value    = 0
				.txtNivsens.Value   = ''
				.chkcga.Value   = 0
				.chkcgp.Value   = 0
				.chkcgr.Value   = 0
				.chkcgrf.Value   = 0
				.chkcgs.Value   = 0
				.chkcgsf.Value   = 0
				.chkbabin.Value   = 0

				.chkce.Value   = 0
				.chksep.Value   = 0
				.chksm.Value   = 0
				.txttaxia.Value   = ''
				.txtpraxia.Value   = ''
				.chkTax.Value = 0
				.chkprax.Value = 0
				.chkpros.Value = 0
				.chkamn.Value = 0
				.txtpsi.Value    = ''
				.chkexc.Value   = 0
				.chkdep.Value  = 0
				.chkans.Value  = 0
				.chkbrad.Value = 0
				.chkabul.Value  = 0
			Endwith
*!* -----------------         primer Página -----------------------------------------------------------------
			With .page8
				.OptPos.Value	= 0
				.optIG.Value    = 0
				.optnivel.Value = 0
				.optposOB.Value = 0
				.txtfacies.Value	= ''
				.TxtTempAx.Value	= 0
				.TxtTempRt.Value	= 0
				.lblingreso.Caption = 'Ingreso a ' + Nvl(mwkinterna.IH_secagrup,'')
				.txthing.Value		= Thisform.txthing.Value
				.TxtTempBc.Value	= 0
				.txtPA.Value     = 0
				.txtPAd.Value     = 0
				.txtfc.Value    = 0
				.txtresp.Value  =  ''
				.txtfr.Value	=  0
				.TxtSat.Value	=  0
				.txtfio2.Value	=  0
				.txtpvc.Value    = 0
				.txtpper.Value   = ''
				.txtrcap.Value   = ''
				.optvia.Value    = 0
				Select mwkEVCModoa
				Go Top
				.cboVCacc.Refresh()
				.optvevp.Value    = 0
				Select mwkEVPModoa
				Go Top
				.cbovevpacc.Refresh()
			Endwith
		Endwith
	Endif
Endwith
	Do sp_busco_estados With 57," and tipo = 21","mwkhabserv" &&& habilita el servicio sugerido