****
** armo la anamnesis
****
parameters miedit,lctabanam,lctabint,lctabveop
local gmot[15]
store '' to gmot
gmot[1] = ' Ausente: 1 '
gmot[2] = ' Extensión anómala: 2'
gmot[3] = ' Flexión anómala: 3 '
gmot[4] = ' Retira dolor: 4'
gmot[5] = ' Localiza dolor: 5'
gmot[6] = ' Obedece órdenes: 6 '
local gver[15]
store '' to gver
gver[1] = ' Ausente: 1 '
gver[2] = ' Sonidos incomprensibles: 2'
gver[3] = ' Palabras inapropiadas: 3 '
gver[4] = ' Confusa: 4'
gver[5] = ' Orientada: 5'
local gocu[14]
store '' to gocu
gocu[1] = ' Ausente: 1 '
gocu[2] = ' Al dolor: 2'
gocu[3] = ' A la voz: 3 '
gocu[4] = ' Espontánea: 4'
if vartype(lctabanam)#"C"
	lctabanam = 'mwkanam'
endif
if vartype(lctabint)#"C"
	lctabint= 'mwkinterna'
endif
if vartype(lctabveop)#"C"
	lctabveop= 'mwkevolprot'
endif
miedit= 'Ingreso a '+nvl(&lctabint..ih_secagrup,'')+chr(13)
mingreso = ''
select (lctabveop)
go top

mddescie = ''
if used('mwkCie9i')
	select mwkcie9i
	locate for id = nvl(&lctabveop..ih_motingreso ,1)
	if !found()
		select mwkcie9a
		locate for id = nvl(&lctabveop..ih_motingreso ,1)
	endif
	mddescie = descrip
endif
mhoraing = nvl(&lctabveop..ih_fechahoraing,mwkfecserv.fechahora)

mimedico = &lctabveop..ih_codmed
if used('mwkmedicoint')
	select mwkmedicoint
	mimedant = mwkmedicoint.id
	locate for id = mimedico
	cnmed = mwkmedicoint.nombre
	cnmlmat = mwkmedicoint.matricula
else

	select mwkmedicoant
	mimedant = mwkmedicoant.id
	locate for id = mimedico
	cnmed = mwkmedicoant.nombre
	cnmlmat = mwkmedicoant.matricula
endif
locate for id = mimedant
select (lctabveop)
go top
if !used('mwkprocede')
	do sp_busco_estados with 25,' and tipo = 2 order by estado ','mwkprocede'
endif

select mwkprocede
locate for id = nvl(&lctabveop..ih_procedencia ,1)
if eof()
	go top
endif


if reccount(lctabanam )>0
	select (lctabanam )
	mhoraing = nvl(ia_fechahora,mhoraing)

	miedit= miedit+transform(mhoraing )+ ' '+alltrim(cnmed)+" M.N.:"+ transform(cnmlmat)+chr(13)
	if used ('mwkreingre')
		miedit= miedit+'Procedencia: ' + alltrim(mwkprocede.descrip)+" Reingreso:"+ iif(reccount('mwkreingre')>0, "Si","No")+;
			" post cx:"+ iif(nvl(ia_postcx,0) = 1, "Si","No")+chr(13)
	else
		miedit= miedit+'Procedencia: ' + alltrim(mwkprocede.descrip)+;
			" post cx:"+ iif(nvl(ia_postcx,0) = 1, "Si","No")+chr(13)
	endif
	miedit= miedit+'Motivo de Ingreso: ' + alltrim(mddescie )+chr(13)+chr(13)


*!* -----------------   Cargamos datos del page pgAnApa ------------------------------------------------------
*!* -----------------         primer Página -----------------------------------------------------------------

	if !used('mwkEVCModoa')
		do sp_busco_estados with 25,' and tipo = 14  order by estado','mwkEVCModoa'
	endif
	select mwkevcmodoa
	go top
	locate for estado = nvl(&lctabanam..ia_egevcacc,0)
	if !found()
		go top
	endif

	select (lctabanam)
	mingreso2 =  iif(ia_egimpgral>0,"Impresión General: "+iif(ia_egimpgral=1," Crónico ",iif(ia_egimpgral= 2," Agudo ",'' )),'');
		+iif(ia_gestable =1," Estable ",iif(ia_gestable = 2," Inestable ",'' ));
		+iif(ia_egimpnivel=1," Grave ",iif(ia_egimpnivel= 2," Moderado ",iif(ia_egimpnivel= 3," Leve ",'' )))+chr(10)
	mingreso =  mingreso2
	mingreso2 =  iif(ia_gdecubito>0," Decúbito ",'')+iif(ia_gdecubito= 1," Prono ",;
		iif(ia_gdecubito= 2," Supino ",iif(ia_gdecubito= 3," Lateral ",iif(ia_gdecubito= 1," Indiferente ",'' ))))+;
		iif(ia_egdecubitoop= 1," Obligado ",iif(ia_egdecubitoop= 2," Preferencial ",''))
	mingreso =  mingreso +iif(!empty(mingreso2), mingreso2+ chr(10),'')

	mingreso2 =  iif(!empty(ia_gfacies),'Facies: '+alltrim(ia_gfacies),'')

	mingreso2 =  mingreso2 + iif(ia_egtemaxl+ia_egtemrct+ia_egtembuc>0,' Temperatura ','')+ ;
		iif(ia_egtemaxl>0,' Axilar: '+transform(ia_egtemaxl),'')+iif(ia_egtemrct>0,' Rectal: '+transform(ia_egtemrct),'')+;
		iif(ia_egtembuc>0,' Bucal: '+transform(ia_egtembuc),'')

	mingreso2 =  mingreso2 + iif(ia_cvpresionart>0,' Presión arterial: '+transform(ia_cvpresionart)+"/"+transform(nvl(ia_cvpresionartd,0)),'')+;
		iif(val(ia_cvfreccar)>0,' Frec.Card: '+transform(ia_cvfreccar),'')
	mingreso =  mingreso +iif(!empty(mingreso2), mingreso2+ chr(10),'')

	mingreso2 =  iif(!empty(ia_rtiporesp),'Tipo Resp.: '+alltrim(ia_rtiporesp),'')

	mingreso2 =  mingreso2 + iif(ia_rfrecresp>0,' Frec.Resp.: '+transform(ia_rfrecresp),'')+;
		iif(ia_rsato2 >0,' Saturac.O2: '+transform(ia_rsato2 ),'')+;
		iif(ia_egfio2 >0,' FiO2: '+transform(ia_egfio2),'') + iif(ia_cvpvc >0,' PVC: '+transform(ia_cvpvc)+ " cm H2O",'')
	mingreso =  mingreso +iif(!empty(mingreso2), mingreso2+ chr(10),'')

	mingreso2 =  iif(!empty(nvl(ia_egperfper,'')),'Perfusión Periférica: '+alltrim(nvl(ia_egperfper,'')),'') ++iif(!empty(ia_egrellcap),'Relleno Capilar: '+alltrim(ia_egrellcap),'')
	mingreso =  mingreso +iif(!empty(mingreso2), mingreso2+ chr(10),'')
	if !used('mwkEVPModo')
		do sp_busco_estados with 25,' and tipo = 12 order by estado ','mwkEVPModo'
	endif
	select mwkevpmodo
	locate for estado = &lctabanam..ia_egevpacc
	if eof()
		go top
	endif
	select (lctabanam)
	mingreso2 = iif(nvl(ia_egevp,0)=1,' Vías EV Perifer.: SI Acceso: '+mwkevpmodo.descrip, ;
		iif(nvl(ia_egevp,0)=2,' Vías EV Perifer.: NO',''))
	if !used('mwkEVCModo')
		do sp_busco_estados with 25,' and tipo = 14  order by estado','mwkEVCModo'

	endif
	select mwkevcmodo
	locate for estado = &lctabanam..ia_egevcacc
	if eof()
		go top
	endif
	select (lctabanam)
	mingreso2 =mingreso2 + iif(nvl(ia_egevc,0)=1,' Vías EV Central: SI Acceso: '+mwkevcmodo.descrip, ;
		iif(nvl(ia_egevc,0)=2,' Vías EV Central: NO',''))
	mingreso =  mingreso +iif(!empty(mingreso2), mingreso2+ chr(10),'')


	miedit= miedit+ iif(!empty(mingreso),"."+chr(13)+'-- Evaluación General ' +chr(10)+ alltrim(mingreso)+chr(13)+chr(13),'')

*!* -----------------         Primera Página          ------------------------------------------------------
	mingreso2 =  iif(!empty(nvl(ia_gconstitucion,'')),'TCS - Distribución: '+ia_gconstitucion,'')+iif(!empty(nvl(ia_gtcscant,'')),' Cantidad: '+ia_gtcscant,'')
	mingreso =  iif(!empty(mingreso2), mingreso2+ chr(10),'')

	mingreso2 =  iif(!empty(nvl(ia_gedtipo,'')),'Edemas - Tipo: '+ia_gedtipo,'')+iif(!empty(nvl(ia_gedcolor,'')),' Color: '+;
		ia_gedcolor,'')+iif(!empty(nvl(ia_gedloc,'')),' Localización: '+ia_gedloc,'')
	mingreso =  mingreso +iif(!empty(mingreso2), mingreso2+ chr(10),'')

	mingreso2 =  iif(!empty(nvl(ia_gpiel,'')),'Piel: '+ia_gpiel,'')+iif(!empty(nvl(ia_gpielcol,'')),' Color: '+ia_gpielcol,'')+;
		iif(ia_gulcera," Úlceras SI ",'')+iif(ia_gcicatriz ," Cicatrices SI",'')+;
		iif(!empty(ia_gfaneras),' Faneras: '+ia_gfaneras,'')

	mingreso =  mingreso +iif(!empty(mingreso2), mingreso2+ chr(10),'')
	mingreso =  mingreso +iif(ia_gadenopalp ,' Adenopatias Palpables: SI ','  ')+chr(10)+chr(10)

	miedit= miedit+iif(!empty(mingreso),'-- Piel - Faneras y TCS ' +chr(10)+ alltrim(mingreso)+chr(13)+chr(13),'')
*!* -----------------         Segunda Página -----------------------------------------------------------------
	if !used('mwkANPupilas')
		do sp_busco_estados with 25,' and tipo = 8 order by estado ','mwkanpupilas'
	endif
	select mwkanpupilas
	locate for estado = &lctabanam..ia_ccpupilas
	if eof()
		go top
	endif
	if !used('mwkANMucosa')
		do sp_busco_estados with 25,' and tipo = 9 order by estado ','mwkanmucosa'
	endif
	select mwkanmucosa
	locate for estado = &lctabanam..ia_ccmucosas
	if eof()
		go top
	endif
	select (lctabanam)

	nchkojo1   = val(substr(nvl(ia_ccojos,'00000'),1,1))
	nchkojo2   = val(substr(nvl(ia_ccojos,'00000'),2,1))
	nchkojo3   = val(substr(nvl(ia_ccojos,'00000'),3,1))
	nchkojo4   = val(substr(nvl(ia_ccojos,'00000'),4,1))
	nchkojo5   = val(substr(nvl(ia_ccojos,'00000'),5,1))
	noptro1   = val(substr(ia_ccreflejooc,1,1))
	noptro2   = val(substr(ia_ccreflejooc,2,1))
	nchkro3   = val(substr(ia_ccreflejooc,3,1))
	noptro4   = val(substr(ia_ccreflejooc,4,1))
	nchkro5   = val(substr(ia_ccreflejooc,5,1))
	nchkro6   = val(substr(ia_ccreflejooc,6,1))
	mingreso2 =  iif(!empty(ia_cctipo),'Tipo: '+ia_cctipo,'')+;
		iif(!empty(ia_cchendpalp),' Hend.palp.: '+ia_cchendpalp,'')+;
		iif(!empty(ia_ccconjuntivas),' Conjuntivas: '+ia_ccconjuntivas,'')+;
		iif(!empty(mwkanpupilas.descrip), " Pupilas: "+mwkanpupilas.descrip,'')

	mingreso =  iif(!empty(mingreso2), mingreso2+ chr(10),'')

	mingreso2 =  iif(ia_ccojos='00000','','Ojos: ')+iif(nchkojo1 = 1,' Exoftalmos ','')+;
		iif(nchkojo2 = 1,' Enoftalmos','') + iif(nchkojo3 = 1,' Desviación Conj.','')+;
		iif(nchkojo4 = 1,' Desviación Desconj.','')+iif(nchkojo5 = 1,' Nistagmos ','')
	mingreso =  mingreso +iif(!empty(mingreso2), mingreso2+ chr(10),'')

	mingreso2 =  iif(noptro1 = 1,' Fotomotor: SI ',iif(noptro1 = 2,' Fotomotor: NO ',''))+ ;
		iif(noptro2 = 1,' Consensual: SI ',iif(noptro2 = 2,' Consensual: NO ',''))+;
		iif(noptro4 = 1,' Corneano: SI ',iif(noptro4 = 2,' Corneano: NO ',''))+;
		iif(nchkro3 = 1,' Acomodador ','')+;
		iif(nchkro5 = 1,' Oculocefálicos ','')+iif(nchkro6 = 1,' Oculovestibular ','')

	mingreso =  mingreso +iif(!empty(mingreso2), 'Reflejos '+mingreso2+ chr(10),'')

	mingreso2 =  iif(!empty(ia_ccfdoojo),'Fondo de ojos: '+ia_ccfdoojo,'')+iif(!empty(ia_ccfosasnas),' Fosas nasales: '+ia_ccfosasnas,'')

	mingreso =  mingreso +iif(!empty(mingreso2), mingreso2+ chr(10),'')

	mingreso2 =  iif(!empty(ia_ccboca),'Boca: '+ia_ccboca,'')+iif(!empty(mwkanmucosa.descrip), " Mucosas: "+mwkanmucosa.descrip,'')+;
		iif(!empty(ia_ccoido),' Oído: '+ia_ccoido,'')

	mingreso =  mingreso +iif(!empty(mingreso2), mingreso2+ chr(10),'')

	mingreso2 =  iif(!empty(ia_ccingyug),'Ingurgit.Yugular: '+ia_ccingyug,'')+iif(!empty(ia_cclatven),' Latido venoso: '+ia_cclatven,'')+;
		iif(!empty(ia_cclatcar),' Latido carot.: '+ia_cclatcar,'')+ iif(!empty(ia_ccsoplo),' Soplo carot.: '+ia_ccsoplo,'')
	mingreso =  mingreso +iif(!empty(mingreso2), mingreso2+ chr(10),'')

	mingreso2 =  iif(!empty(ia_cctiroides),'Tiroides: '+ia_cctiroides,'')+iif(!empty(ia_ccotro),' Otro: '+ia_ccotro,'')
	mingreso =  mingreso +iif(!empty(mingreso2), mingreso2+ chr(10),'')


	select (lctabanam)
	miedit= miedit+ iif(!empty(mingreso),'-- Cabeza y Cuello ' +chr(10)+ alltrim(mingreso)+chr(13)+chr(13),'')
*!* -----------------         Tercera Página -----------------------------------------------------------------
	if !used('mwkDPModo')
		do sp_busco_estados with 25,' and tipo = 26 order by estado ','mwkDPModo'

	endif
	select mwkdpmodo
	go top
	locate for estado = nvl(&lctabanam..ia_egdrenpacc,0)
	if !found()
		go top
	endif
	if !used('mwkEVPModoa')
		do sp_busco_estados with 25,' and tipo = 12 order by estado ','mwkEVPModoa'
	endif
	select mwkevpmodoa
	go top
	locate for estado = nvl(&lctabanam..ia_egevpacc,0)
	if !found()
		go top
	endif
	select (lctabanam)

	mingreso2 =  iif(!empty(ia_rtipotorax),'Tipo torax: '+ia_rtipotorax,'')+;
		iif(ia_egtorac,' Toracotomía SI','') + iif(ia_egtraq,' Traqueostomía: SI ','')
	mingreso =   iif(!empty(mingreso2), mingreso2+ chr(10),'')

	mingreso =  mingreso + iif(!empty(ia_rinspeccion),'Inspección: '+ia_rinspeccion+chr(10),'')

	mingreso2 =  iif(!empty(ia_rpalpacion),'Palpación: '+ia_rpalpacion,'')+iif(!empty(ia_rpercusion),'Percusión: '+ia_rpercusion,'')
	mingreso =  mingreso +iif(!empty(mingreso2), mingreso2+ chr(10),'')

	mingreso =  mingreso + iif(!empty(ia_rauscultacion),'Auscultación: '+ia_rauscultacion+chr(10),'')

	miedit= miedit+ iif(!empty(mingreso),'-- Aparato Respiratorio ' +chr(10)+ alltrim(mingreso)+chr(13)+chr(13),'')
*!* -----------------         Cuarta Página -----------------------------------------------------------------


	mingreso2 =  iif(ia_cvlcvis or ia_cvlcpal,'Latido cardíaco: ','')+iif(ia_cvlcvis ,' Visible ','')+;
		iif(ia_cvlcpal,' Palpable ','') + iif(ia_cvsoplo,' Soplo SI '+iif(!empty(ia_cvsoploloc),' Localización: '+ia_cvsoploloc,'')+;
		" intensidad: "+transform(ia_cvsoploint)+"/6",'')
	mingreso =   iif(!empty(mingreso2), mingreso2+ chr(10),'')

	mingreso2 =  iif(!empty(ia_cvlatcarp),'Latido cardíaco se palpa: '+ia_cvlatcarp,'')+;
		iif(!empty(ia_cvpulsorad),' Pulso radial: '+ia_cvpulsorad,'') +iif(!empty(ia_cvcaract),' Características: '+ia_cvcaract,'')
	mingreso =  mingreso +iif(!empty(mingreso2), mingreso2+ chr(10),'')

	mingreso =  mingreso +iif(!empty(ia_cvpulsosperif),' Pulsos perif.: '+ia_cvpulsosperif+ chr(10),'')
	mcides1 = iif(ia_cvr1o=1,"Normal",iif(ia_cvr1o=2,"Aumentado",iif(ia_cvr1o=3,"Disminuído",iif(ia_cvr1o=4,"Desdoblado",''))))
	mcides2 = iif(ia_cvr2o=1,"Normal",iif(ia_cvr2o=2,"Aumentado",iif(ia_cvr2o=3,"Disminuído",iif(ia_cvr2o=4,"Desdoblado",''))))

	mingreso2 =  iif(ia_cvr1o>0,' R1 '+mcides1 ,'')+ " "+iif(ia_cvr2o>0,' R1 '+mcides2 ,'')+;
		iif(ia_cvr3o= 1,' R3: SI ',iif(ia_cvr3o= 2,' R3: NO ',''))+;
		iif(ia_cvr3g= 1,' Galope: SI ',iif(ia_cvr3g= 2,' Galope: NO ',''))+;
		iif(ia_cvr4o= 1,' R4: SI ',iif(ia_cvr4o= 2,' R4: NO ',''))

	mingreso =  mingreso +iif(!empty(mingreso2), mingreso2+ chr(10),'')
	mingreso2 =  iif(!empty(ia_cvsistole),'Sístole: '+ia_cvsistole,'')+iif(!empty(ia_cvdiastole),' Diástole: '+ia_cvdiastole,'');
		+iif(ia_cvfrem,' Frotes SI','') +iif(ia_cvfrem,' Frémitos SI ','')
	mingreso =  mingreso +iif(!empty(mingreso2), mingreso2+ chr(10),'')


	miedit= miedit+ iif(!empty(mingreso),'-- Ap. Cardiovascular ' +chr(10)+ alltrim(mingreso)+chr(13)+chr(13),'')
*!* -----------------         Quinta Página -----------------------------------------------------------------
	mcides1 = iif(ia_aginsp=1,"Globoso",iif(ia_aginsp=2,"Excavado",iif(ia_aginsp=3,"Asimétrico",'')))
	mingreso2 =  iif(ia_aginsp>0,' Inspección '+mcides1 ,'')+iif(!empty(ia_aginspeccion),' '+ia_aginspeccion,'')
	mingreso =   iif(!empty(mingreso2), mingreso2+ chr(10),'')

	mcides1 = iif(ia_agpalp=1,"Blando",iif(ia_agpalp=2,"Tenso",iif(ia_agpalp=3,"Masa Palpable",'')))
	mingreso2 =  iif(ia_agpalp>0,' Palpación '+mcides1 ,'')+iif(!empty(ia_agdrenaje),' Drenajes: '+ia_agdrenaje,'')
	mingreso =  mingreso +iif(!empty(mingreso2), mingreso2+ chr(10),'')

	mcides1 = iif(ia_agdolor=1,"Superficial",iif(ia_agdolor=2,"Profundo",iif(ia_agdolor=3,"A la descompresión",'')))

	mingreso2 =  iif(ia_agdolor>0,' Dolor '+mcides1 ,'')+iif(!empty(ia_aghigado),' Hígado: '+ia_aghigado,'')
	mingreso =  mingreso +iif(!empty(mingreso2), mingreso2+ chr(10),'')

	mingreso2 =  iif(ia_agptosu= 1,' Puntos Ureterales (+) ',iif(ia_agptosu= 2,' Puntos Ureterales (-) ',''))+;
		iif(ia_agasc,' Ascitis: SI ','')+iif(!empty(ia_agagtacto),' Tacto rectal: '+ia_agagtacto,'')

	mingreso =  mingreso +iif(!empty(mingreso2), mingreso2+ chr(10),'')

	mingreso2 =  iif(ia_agbazo = 1,' Bazo Palpable ',iif(ia_agbazo = 2,' Bazo No Palpable  ',''))+;
		iif(ia_agrha,' RHA (+) ',' ')+ iif(ia_agppl,' PPL (+) ',' ')+;
		iif(ia_egsng,' SNG SI','') +iif(ia_egsv,' SV SI ','')  &&RHA (-) ---  PPL (-)
	mingreso =  mingreso +iif(!empty(mingreso2), mingreso2+ chr(10),'')

	miedit= miedit+ iif(!empty(mingreso),'-- Ap.G.Urinario - Abdomen  ' +chr(10)+ alltrim(mingreso)+chr(13)+chr(13),'')
*!* -----------------         Sexta Página -----------------------------------------------------------------
	mingreso =  iif(!empty(ia_locomotor),ia_locomotor+ chr(10),'')
	miedit= miedit+ iif(!empty(mingreso),'-- Aparato Locomotor ' +chr(10)+ alltrim(mingreso)+chr(13)+chr(13),'')
*!* -----------------         Séptima Página -----------------------------------------------------------------
	if !used('mwkANConciencia')
		do sp_busco_estados with 25,' and tipo = 10 order by estado ','mwkanconciencia'

	endif
	select mwkanconciencia
	locate for estado = &lctabanam..ia_nsconciencia
	if eof()
		go top
	endif
	select (lctabanam)
	nchkmvsd   = val(substr(ia_nsmovvol,1,1))
	nchkmvsi   = val(substr(ia_nsmovvol,2,1))
	nchkmvid   = val(substr(ia_nsmovvol,3,1))
	nchkmvii   = val(substr(ia_nsmovvol,4,1))
	nchkrosd   = val(substr(ia_nsreflejoost,1,1))
	nchkrosi   = val(substr(ia_nsreflejoost,2,1))
	nchkroid   = val(substr(ia_nsreflejoost,3,1))
	nchkroii   = val(substr(ia_nsreflejoost,4,1))
	nchkssd    = val(substr(ia_nssensib,1,1))
	nchkssi    = val(substr(ia_nssensib,2,1))
	nchksid    = val(substr(ia_nssensib,3,1))
	nchksii    = val(substr(ia_nssensib,4,1))
	nchkmpsd   = val(substr(nvl(ia_nsmovpas,'00000'),1,1))
	nchkmpsi   = val(substr(nvl(ia_nsmovpas,'00000'),2,1))
	nchkmpid   = val(substr(nvl(ia_nsmovpas,'00000'),3,1))
	nchkmpii   = val(substr(nvl(ia_nsmovpas,'00000'),4,1))

	nchkcga   = val(substr(nvl(ia_nscabgral,'00000000'),1,1))
	nchkcgp   = val(substr(nvl(ia_nscabgral,'00000000'),2,1))
	nchkcgr   = val(substr(nvl(ia_nscabgral,'00000000'),3,1))
	nchkcgrf   = val(substr(nvl(ia_nscabgral,'00000000'),4,1))
	nchkcgs   = val(substr(nvl(ia_nscabgral,'00000000'),5,1))
	nchkcgsf   = val(substr(nvl(ia_nscabgral,'00000000'),6,1))
	nchkbabin   = val(substr(nvl(ia_nscabgral,'00000000'),7,1))


	mingreso2 = iif(!empty(mwkanconciencia.descrip),' Conciencia: '+mwkanconciencia.descrip,'') +;
		iif(!empty(ia_nsparescran),'Pares craneanos: '+alltrim(ia_nsparescran),'')
	mingreso =  iif(!empty(mingreso2), mingreso2+ chr(10),'')

	mingreso2 =  iif(ia_nsgmot>0 and ia_nsgver>0 and ia_nsgocu>0,'Glasgow: '+transform(ia_nsgmot+ia_nsgver+ia_nsgocu)+"/15 "+' Respuesta Motora '+gmot(ia_nsgmot)+;
		' respuesta verbal '+gver(ia_nsgver)+' Respuesta Ocular '+gocu(ia_nsgocu),'')
	mingreso =  mingreso +iif(!empty(mingreso2), mingreso2+ chr(10),'')

	mingreso2 =  iif(left(ia_nsmovvol,4)='0000' and nchkcga=0,'','Motilidad activa: '+ iif(nchkcga = 1,' General ','')+;
		iif(nchkmvsd = 1,' MSD ','')+iif(nchkmvsi = 1,' MSI ','')+;
		iif(nchkmvid = 1,' MID ','')+iif(nchkmvii = 1,' MII ',''))

	mingreso =  mingreso +iif(!empty(mingreso2), mingreso2+ chr(10),'')

	mingreso2 =  iif(left(ia_nsmovpas,4)='0000' and nchkcgp=0,'','Motilidad pasiva: '+ iif(nchkcgp = 1,' General ','')+;
		iif(nchkmpsd = 1,' MSD ','')+iif(nchkmpsi = 1,' MSI ','')+;
		iif(nchkmpid = 1,' MID ','')+iif(nchkmpii = 1,' MII ',''))

	mingreso =  mingreso +iif(!empty(mingreso2), mingreso2+ chr(10),'')

	mingreso2 =  iif(left(ia_nsreflejoost,4)='0000' and nchkcgr=0 and nchkcgrf=0,'','Reflejos Profundos: '+ iif(nchkcgr = 1,' General ','')+;
		iif(nchkrosd = 1,' MSD ','')+iif(nchkrosi = 1,' MSI ','')+;
		iif(nchkroid = 1,' MID ','')+iif(nchkroii = 1,' MII ','')+iif(nchkcgrf = 1,' Flexor Plantar ',''))

	mingreso =  mingreso +iif(!empty(mingreso2), mingreso2+ chr(10),'')

	mingreso2 =  iif(left(ia_nssensib,4)='0000' and nchkcgs=0 and nchkcgsf=0,'','Alterac.Sensibilidad: '+ iif(nchkcgs = 1,' General ','')+;
		iif(nchkssd = 1,' MSD ','')+iif(nchkssi = 1,' MSI ','')+;
		iif(nchksid = 1,' MID ','')+iif(nchksii = 1,' MII ','')+iif(nchkcgsf = 1,' Flexor Plantar ',''))

	mingreso =  mingreso +iif(!empty(mingreso2), mingreso2+ chr(10),'')

	mingreso2 = iif(!empty(ia_nsnivsens),'Nivel Sensitivo: '+alltrim(ia_nsnivsens),'')+ iif(ia_nsctrlesf,' Continencia Esfínteres SI','')+;
		iif(ia_nssgexp,' Signos Estrapiramidales SI','')+iif(ia_nssgmen,' Signos Meníngeos SI','')+;
		iif(nchkbabin = 1,' Babinski SI','')
	mingreso =  mingreso +iif(!empty(mingreso2), mingreso2+ chr(10),'')
	mingreso2 = iif(!empty(ia_nstaxia),'Taxia: '+alltrim(ia_nstaxia),'')+  iif(!empty(ia_nspraxia),' Praxia: '+alltrim(ia_nspraxia),'')
	mingreso =  mingreso +iif(!empty(mingreso2), mingreso2+ chr(10),'')

	mingreso2 = 	iif(ia_nstaxiao ,' Taxia SI','')+iif(ia_nspraxiao,' Praxia SI','')+;
		iif(ia_nsamnesia,' Amnesia SI','')+iif(!empty(ia_nspsiquis),' Psiquismo: '+alltrim(ia_nspsiquis),'')+;
		iif(ia_nspsiq1,' Excitación SI','')+iif(ia_nspsiq2,' Depresión SI','')+;
		iif(ia_nspsiq3,' Ansiedad SI','')+iif(ia_nspsiq4,' Bradipsiquia SI','')+iif(ia_nspsiq5,' Abulia SI','')

	mingreso =  mingreso +iif(!empty(mingreso2), mingreso2+ chr(10),'')

	miedit= miedit+ iif(!empty(mingreso),'-- Neurológico ' + chr(10)+alltrim(mingreso)+chr(13)+chr(13),'')

	miedit= miedit+"."+chr(13)+'Impresión diagnóstica: ' + chr(13)+alltrim(ia_impdiag)+chr(13)+chr(13)

	miedit= miedit+iif(!empty(ia_planterap),'Plan Diagnóstico y Terapéutico: ' + chr(13)+alltrim(ia_planterap)+chr(13)+chr(13),'')
endif

