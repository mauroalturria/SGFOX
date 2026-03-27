****
** Grabo evolucion pediatrica
****

parameters lgrabobien,mnroreg, mprot, mmedico,mopage,musua,morigen
dimension admfar(11),pract(13)

* mopage  = ThisForm.PgConsulta.pgAnam.Cntpedi_ingr1.pgHCE
******
if vartype(morigen)#"N"
	morigen = 0
	lmismomed = .f.
endif
midusuario = iif(used('mwkusuarios'),mwkusuarios.id ,mwkusuario.id)
lvaaarchivo = 0
lgrabobien = .t.
mfechahora  = sp_busco_fecha_serv("DT")
mfechadia = ttod(mfechahora )
mfecini = ctod("01/01/1900")
mfecfin = ctod("01/01/2100")
msoloevol = ''
midevol	= mopage.parent.parent.midevol
mlmodifevoln = mopage.parent.parent.lmodifevoln
mlcambiocsv  = mopage.parent.parent.lcambiocsv
mlcambiocsvm  = mopage.parent.parent.lcambiocsvm
mlcambioevol = mopage.parent.parent.lcambioevol
mlcambioepicris = mopage.parent.parent.lcambioepicris
mlcbioARM  = mopage.parent.parent.lcbioARM
mlcambioanam  = mopage.parent.parent.lcambioanam
mlcambioanamllave= mopage.parent.parent.lcambioanamllave
mlmodifatb = mopage.parent.parent.lmodifatb
mlmedcabe = (reccount('mwkanam')=0 or mlcambioanam )
mlcambiopic  = mopage.parent.parent.lcambiopic
mlcambioevp  = mopage.parent.parent.lcambioevp
mlcambioevc   = mopage.parent.parent.lcambioevc
mlcambiocart = mopage.parent.parent.lcambiocart
mlcambiocsg = mopage.parent.parent.lcambiocsg
mlcambiotot  = mopage.parent.parent.lcambiotot
mlcambiotraq  = mopage.parent.parent.lcambiotraq
mlcambiodp    = mopage.parent.parent.lcambiodp
mlcambiosng   = mopage.parent.parent.lcambiosng
mlcambiosves  = mopage.parent.parent.lcambiosves
mlcambiodia = mopage.parent.parent.lcambiodia
mlcanceloayuno = mopage.parent.parent.lcanceloayuno

mlmodifscorep1 = mopage.parent.parent.lmodifscorep1
mlmodifscorep2 = mopage.parent.parent.lmodifscorep2
mlmodifscorep3= mopage.parent.parent.lmodifscorep3
mlmodifscorep4= mopage.parent.parent.lmodifscorep4
mlmodifscorep5= mopage.parent.parent.lmodifscorep5
mlmodifscore = .f.
for tui = 1 to 16
	mc1 = 'mlmodifscorep'+alltrim(transform(tui,"99"))
	mc2 = 'mopage.parent.parent.lmodifscorep'+alltrim(transform(tui,"99"))
	&mc1 =&mc2
	if &mc2
		mlmodifscore = .t.
	endif
next
miprotquir = ''
mcodmedpq  = 0
mevolnursea = ''
mevolnursett = ''
mindictt = ''
calta 	 = ''
caltanur = ''
mintercons = ''
mfechaini  = ctot("01/01/1900")
*!*	if mlcambioanam
*!*		do sp_grabo_evol_int_anam with mopage5,midevol
*!*	endif

*!*	local loHtml as loHtml of c:\desaguemes\prg\prg_html.prg
*!*	loHtml = newobject("loHtml","c:\desaguemes\prg\prg_html.prg")

*!*	mIPA_codmed = mwkmedicoint.id

*!*	with .pgevolApa
*!*		with .Page1
*!*			mevolm  = ''
*!*			mIPA_NSconciencia = mwkANConciencia.id
*!*			mIPA_NSfocalizado = (.optfocal.value= 1)
*!*			mNSfocalizado = .optfocal.value
*!*			mIPA_NStipofocalizado = .txtfocal.value
*!*			mIPA_NSpupilas = mwkANPupilas.id
*!*			mevolma =  ''
*!*			mevolma = iif(!empty(mwkANConciencia.descrip), 'Conciencia:' + mwkANConciencia.descrip,'')
*!*			if mNSfocalizado >0
*!*				mevolma = mevolma + iif(mNSfocalizado  =1," Focalizado: Si ",iif(mNSfocalizado  = 2 ," Focalizado: No ",'' ));
*!*					+ alltrim(mIPA_NStipofocalizado )
*!*			endif
*!*			if 	!empty(mwkANPupilas.descrip)
*!*				mevolma = mevolma + iif(mIPA_NSpupilas # 0, 'Pupilas:' + mwkANPupilas.descrip,'')+ chr(10)
*!*			endif
*!*			mIPA_NSGmot = .txtgmot.value
*!*			mIPA_NSGocu = .txtgocu.value
*!*			mIPA_NSGver = .txtgver.value
*!*			mIPA_NSreflejoOC = (.optreflexoc.value = 1)
*!*			mNSreflejoOC = .optreflexoc.value
*!*			mIPA_NSsignosMen = (.optsgnmenin.value =1)
*!*			mNSsignosMen = .optsgnmenin.value
*!*			mevolma =  mevolma + iif(!empty(mevolma),chr(10),'')
*!*			mevolma2 =  iif(mNSreflejoOC   =1," R.Oculocefálicos: Si ",iif(mNSreflejoOC   = 2," R.Oculocefálicos: No ",'' ));
*!*				+iif(mNSsignosMen  =1," Signos Meníngeos: Si ",iif(mNSsignosMen  = 2," Signos Meníngeos: No ",'' ));
*!*				+iif(.txtglas1.value=0,'', chr(10)+' Glasgow:'+ transf(.txtglas1.value,'99')+ '/15';
*!*				+ " Verbal:"+transf(mIPA_NSGver ,'99') + " Ocular:"+transf(mIPA_NSGocu ,'99') + " Motor:"+transf(mIPA_NSGmot ,'99'))
*!*			mevolma =  mevolma+iif(!empty(mevolma2),chr(10)+mevolma2 + chr(10),'')

*!*			mIPA_NStrastornos = .txttrastornos.value
*!*			mevolma2 = iif(!empty(mIPA_NStrastornos), "Trastornos Psiquiátricos:"+ alltrim(mIPA_NStrastornos),'')
*!*			mevolma =  mevolma+iif(!empty(mevolma2),chr(10)+mevolma2 + chr(10),'')
*!*			mIPA_NSpic = (.optPIC.value=1)
*!*			mvalorpic = 0
*!*			mdiaspic = 0
*!*			mpic = .optPIC.value
*!*			if .optPIC.value = 1
*!*				mfecinipic = .txtpicfini.value
*!*				mvalorpic = .txtpic.value
*!*				mdiaspic = .txtdiaspic.value
*!*			endif
*!*			sipic = (.optPIC.value =1 and mvalorpic >0)
*!*			if mlcambiopic
*!*				mevolma =  mevolma +iif(.optPIC.value =1," PIC: Si ",iif(.optPIC.value = 2," PIC: No ",'' )) ;
*!*					+ iif(.optPIC.value =1, iif(mvalorpic <>0," Valor: "+transf(mvalorpic ,'999')+"mm hg",'' ) ;
*!*					+" Desde:"+dtoc(mfecinipic )+ "Días:"+transf(mdiaspic ,'999')+chr(10),'')
*!*			endif
*!*			mevolm = iif(!empty(mevolma),chr(10) + ' Neurológico' + chr(10) + mevolma,'')
*!*			if !empty(mevolma)
*!*				loHtml.AddHTMLInt(1, mevolma)
*!*			endif
*!*		endwith

*!*		with .Page2
*!*			mIPA_RtipoResp  = .txttiporesp.value
*!*			mevolma =  iif(!empty(mIPA_RtipoResp),'Tipo y Frec.Resp.:'+alltrim(mIPA_RtipoResp)+chr(10),'')
*!*			mIPA_Ralteraciones  = .txtaltera.value
*!*			mevolma =  mevolma +iif(!empty(mIPA_Ralteraciones),'Alteraciones semiológicas toracopulmonares:'+alltrim(mIPA_Ralteraciones  )+chr(10),'')
*!*			mIPA_Rmascarao2  = (.optmascO2.value = 1 )
*!*			mRmascarao2  = .optmascO2.value
*!*			mIPA_Rcanula  = (.OptCanula.value = 1 )
*!*			mevolma2 = iif(mRmascarao2 =1," Máscara O2: Si ",iif(mRmascarao2    = 2," Máscara O2: No ",'' ));
*!*				+iif(.OptCanula.value =1," Cánula: Si ",iif(.OptCanula.value = 2," Cánula: No ",'' ))
*!*			mevolma = mevolma + mevolma2
*!*			mtuboot = .opttuboot.value
*!*			mtotfini  = .txtfecinitubo.value
*!*			mtotdias  = .txtdiastubo.value
*!*			mevolma2 =  ''
*!*			if mlcambiotot
*!*				mevolma2 =  iif(mtuboot =1,chr(10)+ " Tubo Orotraqueal: Si ",iif(mtuboot = 2,chr(10)+ " Tubo Orotraqueal: No ",'' ));
*!*					+iif(mtuboot =1," Desde:"+dtoc(mtotfini)+ "Días:"+transf(mtotdias,'999'),'' )
*!*				mevolma = mevolma + mevolma2
*!*			endif
*!*			mtraq = .opttraq.value
*!*			mtraqfini = .txttraqfini.value
*!*			mtraqdias  = .txttraqdias.value
*!*			mevolma2 =  ''
*!*			if mlcambiotraq
*!*				mevolma2 =  iif(mtraq =1,chr(10)+ " Traqueostomía: Si ",iif(mtraq = 2,chr(10)+ " Traqueostomía: No ",'' ));
*!*					+iif(mtraq =1," Desde:"+dtoc(mtraqfini )+ "Días:"+transf(mtraqdias  ,'999'),'' )
*!*				mevolma = mevolma + mevolma2
*!*			endif
*!*			mIPA_RdrenPleu  = (.optdrenpleu.value = 1)
*!*			mRdrenPleu  = .optdrenpleu.value
*!*			mIPA_Rdrender  = .chkder.value
*!*			mIPA_Rdrenizq  = .chkizq.value
*!*			mIPA_Roscila  = (.optoscila.value =1 )
*!*			mRoscila  = .optoscila.value
*!*			mIPA_Rburbujea  = (.optburbuja.value = 1 )
*!*			mRburbujea  = .optburbuja.value
*!*			mIPA_Rdebito  = (.optdebito.value = 1)
*!*			mRdebito  = .optdebito.value
*!*			mIPA_RdebTipo  = .txttipodeb.value
*!*			mDPfini = .txtDPfini.value
*!*			mDPdias  = .txtDPdias.value
*!*			mevolma2 =  ''
*!*			if mlcambiodp
*!*				mevolma2 =  iif(mRdrenPleu  =1,chr(10)+ " Drenaje pleural: Si ",iif(mRdrenPleu  = 2,chr(10)+ " Drenaje pleural: No ",'' ));
*!*					+iif(mIPA_Rdrender=1 ," Derecho ",'')+ iif(mIPA_Rdrenizq=1 ," Izquierdo ",'' );
*!*					+iif(mRoscila  =1," Oscila: Si ",iif(mRoscila  = 2," Oscila: No ",'' ));
*!*					+iif(mRburbujea    =1," Burbujea: Si ",iif(mRburbujea    = 2," Burbujea: No ",'' ));
*!*					+iif(mRdebito    =1," Débito: Si ",iif(mRdebito    = 2," Débito: No ",'' ));
*!*					+iif(mRdebito    =1," Tipo Débito: "+alltrim(mIPA_RdebTipo),'' )
*!*				mevolma = mevolma + mevolma2
*!*			endif
*!*			mIPA_RfrecResp  = .txtfr.value
*!*			mIPA_Rpeep  = .txtARMpeep.value
*!*			mIPA_Rppico = .txtppico.value
*!*			mIPA_RsatO2  = .txtsato2.value
*!*			mIPA_Rvt  = .txtARMvt.value
*!*			marmmodo = mwkARMModo.id
*!*			marmcomp = mwkARMCompl.id
*!*			marmmot = mwkARMMot.id
*!*			marmfini = .txtARMfini.value
*!*			marmpeep = .optpeep.value
*!*			mARMdias  = .txtARMdias.value
*!*			mevolma2 =  ''
*!*			moptarm = .optARM.value
*!*			siarm = (.optARM.value=1 and !empty(mwkARMModo.descrip))
*!*			sivni = (.optARM.value=2 and !empty(mwkARMModo.descrip))
*!*			mIPA_RARM  = (siarm or sivni )
*!*			if mlcbioARM
*!*				mevolma2 =  iif(siarm,chr(10)+ " ARM: Si ",iif(sivni,chr(10)+ " VNI: Si " ,iif(.optARM.value= 2,chr(10)+ " ARM/VNI: No ",'' )));
*!*					+iif(siarm or sivni,"  Modo: "+mwkARMModo.descrip;
*!*					+" Desde:"+dtoc(marmfini )+ "Días:"+transf(mARMdias ,'999');
*!*					+ iif(mIPA_Rpeep>0, " PEEP:"+transform (mIPA_Rpeep  ,'9999')+"cm H2O",'' );
*!*					+" Motivo:" +mwkARMMot.descrip,'') +iif(!empty(mevolma),chr(10),'')
*!*				mevolma = mevolma + mevolma2
*!*				mevolma2 =  ''
*!*				mevolma2 =  iif(siarm or sivni,chr(10)+ iif(mIPA_Rvt  >0,"  VT: "+transform (mIPA_Rvt,'999')+"ml/Kg",'');
*!*					+iif(mIPA_RfrecResp>0,"  FR: "+transform (mIPA_RfrecResp,'999')+"P/min",'');
*!*					+iif(mIPA_RsatO2>0,"  Sat O2: "+transform (mIPA_RsatO2,'999')+"%",'');
*!*					+iif(mIPA_Rppico>0,"  P.Pico: "+transform (mIPA_Rppico,'999')+"cm H2O",'');
*!*					+iif(!empty(mwkARMCompl.descrip)," Complicaciones:" +mwkARMCompl.descrip,'') +chr(10),'')
*!*				mevolma = mevolma + mevolma2
*!*			endif
*!*			mevolm = mevolm +iif(!empty(mevolma),chr(10) + ' Aparato Respiratorio' + chr(10) + mevolma,'')
*!*			if !empty(mevolma)
*!*				loHtml.AddHTMLInt(2, mevolma)
*!*			endif

*!*		endwith

*!*		with .Page3
*!*			mIPA_CVtipoPulso = .txttipopulso.value
*!*			mIPA_CVPVC = .txtpvc.value
*!*			mIPA_CVtension = .TxtTaSist.value
*!*			mIPA_CVtensiond = .TxtTaDia.value
*!*			mevolma =  ''
*!*			mevolma =  iif(!empty(mIPA_CVtipoPulso ),'Frec. y caract. del pulso:'+alltrim(mIPA_CVtipoPulso )+" P/min",'');
*!*				+iif(mIPA_CVtension >0,"  TA "+transform (mIPA_CVtension ,'999')+"/"+;
*!*				transform (mIPA_CVtensiond ,'999')+" mm Hg ",'');
*!*				+iif(mIPA_CVPVC >0,"  PVC"+transform (mIPA_CVPVC ,'999')+" cm H2O",'')+iif(!empty(mevolma),chr(10),'')
*!*			mIPA_CValteraciones = .txtaltera.value
*!*			mevolma = mevolma + iif(!empty(mIPA_CValteraciones ),chr(10)+'Alteraciones semiológicas cardiovasculares:'+alltrim(mIPA_CValteraciones ) ,'')
*!*			mIPA_CVpulsosPer  = (.optpperif.value = 1)
*!*			mCVpulsosPer  = .optpperif.value
*!*			mIPA_CVedemas = (.optedemas.value = 1)
*!*			mCVedemas = .optedemas.value
*!*			mevolma2 =  ''
*!*			mevolma2 =  iif(mCVpulsosPer    =1," Pulsos periféricos: Iguales ",iif(mCVpulsosPer    = 2," Pulsos periféricos: Simétricos ",'' ));
*!*				+iif(mCVedemas  =1," Edemas: Si ",iif(mCVedemas  = 2," Edemas: No ",'' ))
*!*			mevolma = mevolma + iif(!empty(mevolma2),chr(10),'')+mevolma2


*!*			mvevp =.optvevp.value
*!*			mvevpfini = .txtvevpfini.value
*!*			mvevpffin = iif(empty(.txtvevpffin.value) or .txtvevpffin.value=ctod("  /  /  "),mfecfin,.txtvevpffin.value)
*!*			mvevdias =	.txtvevpdias.value
*!*			mvevpacc = mwkEVPModo.id
*!*			mvevpcomp = mwkEVPCompl.id

*!*			mevolma2 =  ''
*!*			sivevp = (mvevp = 1 and !empty(mwkEVPModo.descrip))
*!*			if mlcambioevp
*!*				do case
*!*					case sivevp
*!*						mevolma2 = chr(10)+' Vías EV Perifer. desde:'+transform(mvevpfini )+" Días:"+transf(mvevdias ,'999')+" Con acceso:"+mwkEVPModo.descrip+ ;
*!*							iif(!empty(mwkEVPCompl.descrip), " Complicaciones: "+mwkEVPCompl.descrip,'')
*!*					case mvevp = 2
*!*						mevolma2 = iif(empty(mwkEVPModo.descrip),chr(10)+' Vías EV Perifer. NO',' Vías EV Perifer. desde:'+;
*!*							transform(mvevpfini )+' hasta:'+transform(mvevpffin )+" Días:"+transf(mvevdias ,'999')+" Con acceso:"+mwkEVPModo.descrip+ ;
*!*							iif(!empty(mwkEVPCompl.descrip), " Complicaciones: "+mwkEVPCompl.descrip,'') )
*!*				endcase
*!*				mevolma = mevolma + mevolma2
*!*			endif
*!*			mvcacc = mwkEVCModo.id
*!*			mvccomp = mwkEVCCompl.id
*!*			mvcdias =	.txtvcdias.value
*!*			mvc = .optvia.value
*!*			mvcfini = .txtVCfini.value
*!*			mvcffin = iif(empty(.txtVCffin.value) or .txtVCffin.value=ctod("  /  /  "),mfecfin,.txtVCffin.value)
*!*			mevolma2 =  ''
*!*			sivc = (mvc = 1 and !empty(mwkEVCModo.descrip))
*!*			if mlcambioevc
*!*				do case
*!*					case sivc
*!*						mevolma2 = chr(10)+' Vías EV Central desde:'+transform(mvcfini )+" Días:"+transf(mvcdias ,'999')+" Con acceso:"+mwkEVCModo.descrip+ ;
*!*							iif(!empty(mwkEVCCompl.descrip), " Complicaciones: "+mwkEVCCompl.descrip,'')
*!*					case mvc = 2
*!*						mevolma2 = iif(empty(mwkEVCModo.descrip), chr(10)+' Vías EV Central NO ',' Vías EV Central desde:'+;
*!*							transform(mvcfini )+' hasta:'+transform(mvcffin )+" Días:"+transf(mvcdias ,'999')+" Con acceso:"+mwkEVCModo.descrip+ ;
*!*							iif(!empty(mwkEVCCompl.descrip), " Complicaciones: "+mwkEVCCompl.descrip,''))
*!*				endcase
*!*				mevolma = mevolma + mevolma2
*!*			endif
*!*			mcartacc = mwkCARTModo.id
*!*			mcartcom = mwkCARTCompl.id
*!*			mcart = .optcart.value
*!*			mcartfini = .txtcartfini.value
*!*			mcartdias =	.txtcartdias.value
*!*			mcartffin = iif(empty(.txtcartffin.value) or .txtcartffin.value=ctod("  /  /  "),mfecfin,.txtcartffin.value)
*!*			mevolma2 =  ''
*!*			sicart = (mcart = 1 and !empty(mwkCARTModo.descrip))
*!*			if mlcambiocart
*!*				do case
*!*					case sicart
*!*						mevolma2 = chr(10)+' Cat.Arterial desde:'+transform(mcartfini )+" Días:"+transf(mcartdias ,'999')+" Con acceso:"+mwkCARTModo.descrip+ ;
*!*							iif(!empty(mwkCARTCompl.descrip), " Complicaciones: "+mwkCARTCompl.descrip,'')
*!*					case mcart = 2
*!*						mevolma2 = iif(empty(mwkCARTModo.descrip), chr(10)+' Cat.Arterial NO ', ' Cat.Arterial desde:'+transform(mcartfini )+' hasta:'+transform(mcartffin )+;
*!*							" Días:"+transf(mcartdias ,'999')+" Con acceso:"+mwkCARTModo.descrip+ ;
*!*							iif(!empty(mwkCARTCompl.descrip), " Complicaciones: "+mwkCARTCompl.descrip,''))
*!*				endcase
*!*				mevolma = mevolma + mevolma2
*!*			endif
*!*			mcsg = .optcsg.value
*!*			mcsgfini = .txtcsgfini.value
*!*			mcsgdias =	.txtcsgdias.value
*!*			mcsgffin = iif(empty(.txtcsgffin.value) or .txtcsgffin.value=ctod("  /  /  "),mfecfin,.txtcsgffin.value)
*!*			mcsgacc = mwkCSGModo.id
*!*			mcsgcomp = mwkCSGCompl.id
*!*			mevolma2 =  ''
*!*			sicsg = (mcsg = 1 and !empty(mwkCSGModo.descrip))
*!*			if mlcambiocsg
*!*				do case
*!*					case sicsg
*!*						mevolma2 =  chr(10) +' Cateter S.Ganz desde:'+transform(mcsgfini )+" Días:"+transf(mcsgdias ,'999')+" Con acceso:"+mwkCSGModo.descrip+ ;
*!*							iif(!empty(mwkCSGCompl.descrip), " Complicaciones: "+mwkCSGCompl.descrip,'')
*!*					case mcsg = 2
*!*						mevolma2 = iif(empty(mwkCSGModo.descrip), chr(10) +' Cateter S.Ganz NO ',  ' Cateter S.Ganz desde:'+transform(mcsgfini )+' hasta:'+transform(mcsgffin )+;
*!*							" Días:"+transf(mcsgdias ,'999')+" Con acceso:"+mwkCSGModo.descrip+ ;
*!*							iif(!empty(mwkCSGCompl.descrip), " Complicaciones: "+mwkCSGCompl.descrip,'') )
*!*				endcase
*!*				mevolma = mevolma + mevolma2
*!*			endif
*!*			mevolm = mevolm +iif(!empty(mevolma),chr(10) +' Aparato Cardiovascular' + chr(10) + mevolma,'')

*!*			if !empty(mevolma)
*!*				loHtml.AddHTMLInt(3, mevolma)
*!*			endif



*!*		endwith


*!*		with .Page4

*!*			mIPA_GAalteraciones = .txtaltera.value
*!*			mevolma =  ''
*!*			mevolma = iif(!empty(mIPA_GAalteraciones), 'Alteraciones semiológicas abdominales:'+alltrim(mIPA_GAalteraciones),'')
*!*			mIPA_GARHA = (.optRha.value = 1)
*!*			mGARHA = .optRha.value
*!*			mIPA_GAvomito = (.optVom.value = 1)
*!*			mGAvomito = .optVom.value
*!*			mIPA_GAcatar = (.optcatar.value = 1)
*!*			mGAcatar = .optcatar.value
*!*			mIPA_GAdolor = (.optdolor.value = 1)
*!*			mGAdolor = .optdolor.value
*!*			mevolma2 =  ''
*!*			mevolma2 =  iif(mGARHA =1," RHA: (+) ",iif(mGARHA = 2," RHA: (-) ",'' ));
*!*				+iif(mGAvomito =1," Vómitos: Si ",iif(mGAvomito = 2," Vómitos: No ",'' ));
*!*				+iif(mGAcatar =1," Catarsis: (+) ",iif(mGAcatar = 2," Catarsis: (-) ",'' ));
*!*				+iif(mGAdolor =1," Dolor: Si ",iif(mGAdolor = 2," Dolor: No ",'' ))

*!*			mevolma = mevolma + iif(!empty(mevolma2),chr(10),'')+ mevolma2

*!*			mIPA_GAherCX = (.optherida.value = 1)
*!*			mGAherCX = .optherida.value
*!*			mIPA_GAdren = (.optdrenaje.value = 1 )
*!*			mGAdren  = .optdrenaje.value
*!*			mIPA_GAdrenDeb = .txtdren.value
*!*			mIPA_GAdrenTipo = .txtdrentipo.value
*!*			mevolma2 =  ''
*!*			mevolma2 =  iif(mGAdren  =1," Drenaje: Si ",iif(mGAdren  = 2," Drenaje: No ",'' ));
*!*				+iif(mGAdren  =1," Débito :"+transform(mIPA_GAdrenDeb ,'999.99')+ " Tipo:"+alltrim(mIPA_GAdrenTipo ),'' )
*!*			mevolma = mevolma + iif(!empty(mevolma2),chr(10),'')+mevolma2

*!*			mIPA_GAestadoCX =  .OptestHerida.value
*!*			mecx = mIPA_GAestadoCX
*!*			mIPA_GAcrepita = (.optcrepita.value = 1)
*!*			mGAcrepita = .optcrepita.value
*!*			mevolma2 =  ''
*!*			mevolma2 =  iif(mGAherCX  =1," Heridas quirúrgicas: Si ",iif(mGAherCX  = 2," Heridas quirúrgicas: No ",'' ))+;
*!*				iif(mecx =1," Limpia ",iif(mecx = 2," Supuración ",iif(mecx = 3," Flogosis ",iif(mecx = 4," Necrosis ",'' )) ));
*!*				+iif(.optcrepita.value =1," Con crepitación ",'' )
*!*			mevolma = mevolma + iif(!empty(mevolma2),chr(10),'')+ mevolma2

*!*			mIPA_GAotrasLes = .txtotrasles.value
*!*			mevolma = mevolma + iif(!empty(mIPA_GAotrasLes ),chr(10)+ 'Otras lesiones:'+alltrim(mIPA_GAotrasLes ),'')

*!*			mIPA_ALingreso = .txtingre.value
*!*			mIPA_ALdiuresis = .txtdiuresis.value
*!*			mIPA_ALbalance = .txtbalance.value
*!*			mevolma2 =  ''
*!*			mevolma2 =  iif(!empty(mIPA_ALingreso )," Ingreso fluídos 24 hs :"+ alltrim(transform(mIPA_ALingreso ))+ 'ml','' );
*!*				+iif(!empty(mIPA_ALdiuresis )," Diuresis 24 hs:"+alltrim(transform(mIPA_ALdiuresis ))+ 'ml','' );
*!*				+iif(!empty(mIPA_ALbalance )," Balance 24 hs:"+alltrim(transform(mIPA_ALbalance ))+ 'ml','' )

*!*			mevolma = mevolma +iif(!empty(mevolma2),chr(10),'')+mevolma2

*!*			mIPA_ALsonda = (.optsves.value = 1 )
*!*			msves = .optsves.value
*!*			msvesfini = .txtsvesfini.value
*!*			msvesdias =	.txtsvesdias.value
*!*			mSVESacc =	mwksvesmodo.id
*!*			mevolma2 =  ''
*!*			sisves = (msves = 1 and !empty(mwksvesmodo.descrip))
*!*			if mlcambiosves
*!*				do case
*!*					case sisves
*!*						mevolma2 = chr(10)+'  Sonda vesical desde:'+transform(msvesfini )+" Días:"+transf(msvesdias ,'999')+" Con acceso:"+mwksvesmodo.descrip
*!*					case msves = 2
*!*						mevolma2 = iif(empty(mwksvesmodo.descrip), chr(10)+' Sonda vesical NO ',  ' Sonda vesical desde:'+transform(msvesfini )+' hasta:'+transform(mfechadia)+;
*!*							" Días:"+transf(msvesdias ,'999')+" Con acceso:"+mwksvesmodo.descrip)
*!*				endcase
*!*				mevolma = mevolma + mevolma2
*!*			endif
*!*			mevolma2 = ''
*!*			mGAsng = .optsng.value
*!*			mIPA_GAsngDeb = .txtsngdeb.value
*!*			mIPA_GAsngTipo = .txtsngtipo.value
*!*			mSNG = .optSNG.value
*!*			mIPA_GAsng = (.optsng.value = 1)
*!*			mSNGfini = .txtSNGfini.value
*!*			mSNGdias =	.txtSNGdias.value
*!*			mSNGacc =	mwksngmodo.id
*!*			mevolma2 =  ''
*!*			sisng = (mSNG = 1 and !empty(mwksngmodo.descrip))
*!*			if mlcambiosng
*!*				do case
*!*					case sisng
*!*						mevolma2 = chr(10)+'  Sonda Nasogastrica desde:'+transform(mSNGfini )+" Días:"+transf(mSNGdias ,'999')+" Con acceso:"+;
*!*							mwksngmodo.descrip+iif(mIPA_GAsngDeb>0," Débito :"+transform(mIPA_GAsngDeb,'999.99'),'')+ ;
*!*							iif(!empty(mIPA_GAsngTipo )," Tipo:"+alltrim(mIPA_GAsngTipo ),'' )
*!*					case mSNG = 2
*!*						mevolma2 = iif(empty(mwksngmodo.descrip), chr(10)+' Sonda Nasogastrica NO ',  ' Sonda Nasogastrica desde:'+transform(mSNGfini )+' hasta:'+transform(mfechadia)+;
*!*							" Días:"+transf(mSNGdias ,'999')+" Con acceso:"+mwksngmodo.descrip)
*!*				endcase
*!*				mevolma = mevolma + iif(!empty(mevolma2),chr(10),'')+ mevolma2
*!*			endif
*!*			mIPA_ALdialisis = (.optdial.value = 1)
*!*			mALdialisis = .optdial.value
*!*			mIPA_ALdialPer = .txtdialper.value
*!*			mIPA_ALhemodia = .txthemodial.value
*!*			mIPA_GAtipoHD =  .opttipoHD.value
*!*			mIPA_ALsonda = (.optdial.value = 1 )
*!*			mdialtipo = mIPA_GAtipoHD
*!*			mdial = .optdial.value
*!*			mdialfini = .txtHDfini.value
*!*			mdialdias =	.txtHDdias.value
*!*			mdialffin = iif(empty(.txtHDffin.value) or .txtHDffin.value=ctod("  /  /  "),mfecfin,.txtHDffin.value)
*!*			mdialacc = mwkHDcModo.id
*!*			mdialcomp = mwkHDcCompl.id
*!*			mHDfini = .txtHDfini.value
*!*			mHDdias =	.txtHDdias.value
*!*			mevolma2 =  ''
*!*			if mlcambiodia
*!*				mevolma2 =  iif(mALdialisis =1," Diálisis: Si ",iif(mALdialisis = 2," Diálisis: No ",'' ));
*!*					+iif(!empty(mIPA_ALhemodia ), " Hemodiálisis: "+alltrim(mIPA_ALhemodia ),'') ;
*!*					+iif(!empty(mIPA_ALdialPer ), " Diálisis peritoneal: "+alltrim(mIPA_ALdialPer ),'')


*!*				mevolma = mevolma +iif(!empty(mevolma2),chr(10),'') + mevolma2
*!*			endif
*!*			mevolma2 =  ''
*!*			sihd = (mALdialisis = 1 and !empty(mwkHDcModo.descrip))
*!*			if mlcambiodia
*!*				do case
*!*					case sihd
*!*						mevolma2 = ' Dialisis Tipo :'+iif(mIPA_GAtipoHD =1,.opttipoHD.option1.caption, ;
*!*							iif(mIPA_GAtipoHD =2,.opttipoHD.option2.caption, ''))+;
*!*							" Desde: "+ transform(mHDfini )+" Días:"+transf(msvesdias ,'999')+" Con acceso:"+mwkHDcModo.descrip+ ;
*!*							iif(!empty(mwkHDcCompl.descrip), " Complicaciones: "+mwkHDcCompl.descrip,'')
*!*					case mALdialisis = 2
*!*						mevolma2 = iif(mIPA_GAtipoHD =0,' Dialisis  NO ', ' Dialisis Tipo :'+iif(mIPA_GAtipoHD =1,.opttipoHD.option1.caption, ;
*!*							iif(mIPA_GAtipoHD =2,.opttipoHD.option2.caption, ''))+;
*!*							' Desde:'+transform(mHDfini )+' hasta:'+transform(mfechadia)+" Días:"+transf(mHDdias ,'999'))+" Con acceso:"+mwkHDcModo.descrip+ ;
*!*							iif(!empty(mwkHDcCompl.descrip), " Complicaciones: "+mwkHDcCompl.descrip,'')
*!*				endcase
*!*				mevolma = mevolma+iif(!empty(mevolma2),chr(10),'') + mevolma2
*!*			endif
*!*			mevolm = mevolm +iif(!empty(mevolma),chr(10)+' Ap.Genito Urinario - Abdomen' + chr(10) + mevolma,'')

*!*			if !empty(mevolma)
*!*				loHtml.AddHTMLInt(4, mevolma)
*!*			endif

*!*		endwith
*!*		with .Page6
*!*			select * from mwkatbesquema into cursor mwkctresq
*!*			mIPA_CATB = (reccount('mwkctresq')>0)
*!*			mCATB = iif(reccount('mwkctresq')>0,1,2)
*!*			mIPA_Cdias = 0
*!*			mIPA_Ccultivo = .TxtEd_ed_cultivo.value
*!*			mIPA_Cesquema =''
*!*			mevolma =  ''
*!*			if mlmodifatb
*!*				select mwkatbesquema
*!*				miesquema = ''
*!*				scan
*!*					if id>40
*!*						midesq = id
*!*						if EATB_fechafin>=ttod(mwkfecserv.fechahora)-1  and EATB_fechafin<mfecfin   && dar de baja
*!*						else
*!*							miesquema  = miesquema +alltrim(EATB_esquema)+" D:"+dtoc(EATB_fechaini)+"/"
*!*						endif
*!*					else
*!*						if EATB_fechafin = mfecfin
*!*							miesquema  = miesquema +alltrim(EATB_esquema)+" D:"+dtoc(EATB_fechaini)+"/"

*!*						endif
*!*					endif
*!*				endscan
*!*				mIPA_Cesquema = miesquema
*!*				mevolma =  iif(mCATB =1," ATB: Si ",iif(mCATB = 2," ATB: No ",'' ))+;
*!*					iif(mCATB >0," Esquema ATB: "+alltrim(miesquema )+ chr(10) + " Cultivo:"+ alltrim(mIPA_Ccultivo )+chr(10),'')
*!*				mevolm = mevolm +iif(!empty(mevolma2),chr(10),'')+ mevolma
*!*			endif
*!*	* VER
*!*			mevolma2 = ''
*!*		endwith

*!*	endwith
*!*	mEI_scrapacheii = 0
*!*	mEI_scrsofa = 0
*!*	mEI_scrranson = 0
*!*	mEI_scrhyh	= 0
*!*	mEI_scrfisher = 0

*!*	if mlmodifscorep
*!*		with mopage4.pgcontrol.pgCSVMed
*!*			with .Scores_med1.Pgscore
*!*				mEI_scrapacheii = .PAGE1.txtpuntos.value
*!*				mEI_scrsofa = .PAGE2.txtpuntos.value
*!*				mEI_scrranson = .PAGE3.optdato.value
*!*				mEI_scrhyh	= .PAGE4.Opt1.value
*!*				mEI_scrfisher = .PAGE5.Opt1.value
*!*			endwith
*!*		endwith
*!*	endif


*!*	if mlmodifkine
*!*	*!*		with mopage.PgEvol.PgEvolKine.Cntkinesio
*!*	*!*			mevolm = mevolm + .TxteditEvol.value  + chr(10)
*!*	*!*			if !empty(.TxteditEvol.value)
*!*	*!*				loHtml.AddHTMLInt(1, .TxteditEvol.value)
*!*	*!*			endif
*!*	*!*		endwith
*!*	endif

*!*	mIPA_evol = iif(!empty(mIPA_evol),"Evolución:"+chr(10)+alltrim(mIPA_evol),'')+mevolm

*!*	lcAuxDat = iif(!empty(mevolma2),chr(10),'')+ mevolma
*!*	lcAuxDat = iif(!empty(mIPA_evolDia), mIPA_evolDia + chr(10) + chr(10) + lcAuxDat, lcAuxDat)

*!*	if !empty(lcAuxDat)
*!*		loHtml.AddHTMLInt(5, lcAuxDat)
*!*	endif
*!*	loHtml.HTMLInt_Merge()
*!*	*!* ---------------------------------------------------------------------------


*!*	with mopage7.pgindicaciones
*!*		mresumen = .Page4.TxteditResu.value

*!*		mIPA_indicacion = .Page6.Txteditindic.value
*!*		mindnurse = ""
*!*		with .Page1

*!*			mIPA_ALalimenta = (.opttiponut.value=1)
*!*			mALalimenta = .opttiponut.value
*!*			mIPA_ALtipoNut = mwkNuttipo.id
*!*			mevolma =  ''
*!*			mevolma =  iif(mALalimenta =1," Alimentación: Si ",iif(mALalimenta = 2," Alimentación: No ",'' ));
*!*				+iif(!empty(mwkNuttipo.descrip), " Tipo: "+mwkNuttipo.descrip,'')


*!*			mevolm = mevolm +iif(!empty(mevolma),chr(10),'')+ mevolma
*!*			mIPA_ALcalorias = .txtcalorias.value
*!*			mIPA_ALtolera = .txttolerancia.value
*!*			mhora = .txthora.value
*!*			mIPA_ALfecSusp = iif(empty(.txtNutffin.value) or .txtNutffin.value=ctod("  /  /  ") or .ChkSusp.value = 0,mfecfin,.txtNutffin.value)
*!*			mIPA_ALmotSusp = .txtmotivo.value
*!*			mevolma2 =  ''
*!*			mlayuno = (.ChkSusp.value = 1 and .txtNutffin.enabled)
*!*			mevolma2 = iif(mIPA_ALcalorias >0 ," Calorías :"+transform(mIPA_ALcalorias ),'')+ iif(!empty(mIPA_ALtolera )," Tolerancia:"+alltrim(mIPA_ALtolera ),'' );
*!*				+iif(.ChkSusp.value = 1,' Fecha de Suspensión.:'+ttoc(mIPA_ALfecSusp )+' Desde:'+transform(mhora)+ 'hs Motivo:' +alltrim(mIPA_ALmotSusp ),'')
*!*			mevolma = mevolma +iif(!empty(mevolma2),chr(10),'')+ mevolma2
*!*			mevolma2 =  ''
*!*			msngi = .optsng.value
*!*			msngfinii = .txtsngfini.value
*!*			msngdiasi =	.txtsngdias.value
*!*			msngffini = mfecfin
*!*			mIPA_GAsngi = (.optsng.value = 1)
*!*			mGAsngi = .optsng.value
*!*			mIPA_GAsngDebi = 0&&.txtsngdeb.value
*!*			mIPA_GAsngTipoi = ''&&.txtsngtipo.value
*!*			mevolma2 =  ''
*!*	*!*			do CASE && lo saco por ahora hay qeue agregar las señales para que refleje los cambios
*!*	*!*				case msngi = 1
*!*	*!*					mevolma2 = ' SNG desde:'+transform(msngfinii )+" Días:"+transf(msngdiasi ,'999')+;
*!*	*!*						" Con acceso:"+.cbosngacc.displayvalue+;
*!*	*!*						iif(mIPA_GAsngDebi>0," Débito :"+transform(mIPA_GAsngDebi,'999.99'),'')+ ;
*!*	*!*						iif(!empty(mIPA_GAsngTipoi )," Tipo:"+alltrim(mIPA_GAsngTipoi ),'' )
*!*	*!*				case msngi = 2
*!*	*!*					mevolma2 = iif(empty(.cbosngacc.displayvalue),'',' SNG desde:'+transform(msngfinii )+' hasta:'+transform(msngffini )+" Días:"+transf(msngdiasi ,'999')+;
*!*	*!*						" Con acceso:"+.cbosngacc.displayvalue )
*!*	*!*			endcase
*!*	*!*			mevolma = mevolma +iif(!empty(mevolma2),chr(10),'')+ mevolma2

*!*			mevolm = mevolm +iif(!empty(mevolma),chr(10)+' Nutrición ' + chr(10) + mevolma,'')

*!*		endwith

*!*		with .page2 &&&sueros
*!*		endwith
*!*		with .page3 &&&medicacion
*!*		endwith

*!*	*!*		with .page4&&&estudios
*!*	*!*		endwith
*!*		with .page5 &&&cuidados
*!*			mnurse = ''
*!*			mIPA_aislamiento = alltrim(.cntAisla.txtAislamiento.value)
*!*			mevolma = mevolma + iif(!empty(mIPA_aislamiento),"Aislamiento: "+mIPA_aislamiento+chr(10),'')
*!*			select mwknece.valorb ,mwknece.valorf,mwknece.valorc,mwknece.nnc_descrip as cuidado ,mwknece.nnc_padre,;
*!*				mwkfrecuencia.descrip,mwknecespacorig.nnc_descrip as necesidad ;
*!*				from mwknece left join mwkfrecuencia on estado = mwknece.valorf ;
*!*				INNER join mwknecespacorig on mwknecespacorig.id = mwknece.nnc_padre;
*!*				where mwknece.valorb <> mwknece.valorbOrig or mwknece.valorf <> mwknece.valorfOrig ;
*!*				or alltrim(mwknece.valorc) <> alltrim(mwknece.valorcOrig);
*!*				into cursor mwknecepac
*!*			select mwknecepac
*!*			mnurse = mnurse + iif(reccount('mwknecepac')>0 ,'NECESIDADES Y CUIDADOS ' + chr(10) ,'')
*!*			mpadre = 0
*!*			scan
*!*				if mpadre #nnc_padre
*!*					mnurse = mnurse + '---- ' + mwknecepac.necesidad + chr(10)
*!*					mpadre = mwknecepac.nnc_padre
*!*				endif
*!*				mnurse = mnurse +alltrim(cuidado )+" - "+ iif(valorb , "SI","NO")+ ;
*!*					iif(!empty(descrip)," Frecuencia: "+alltrim(descrip),'')+ iif(!empty(valorc)," Observ.: "+ alltrim(valorc),'')+chr(10)
*!*			endscan
*!*			mindnurse = mindnurse + mnurse + iif(reccount('mwknecepac')>0 ,'- - - - - ' + chr(10) ,'')
*!*		endwith
*!*		with .page6 &&&akr
*!*	*!*			with .Amoverlistas1.Lista2
*!*	*!*				mcadprest = 'inlist (id'
*!*	*!*				if .listcount>0
*!*	*!*					mindnurse = mindnurse + "Asistencia Kinesica y respiratoria:"+chr(10)
*!*	*!*					for ip = 1 to .listcount
*!*	*!*						mindnurse = mindnurse + alltrim(.list(ip,1))+chr(10)
*!*	*!*						mcadprest = mcadprest +","+.list(ip,2)
*!*	*!*					next ip
*!*	*!*					mcadprest =mcadprest +")"
*!*	*!*					select * from mwkindCCDisp where &mcadprest into cursor mwkindCCind
*!*	*!*	*					do sp_grabo_evol_int_nut  with midevol,alltrim(.TxtedIMAnt.value)
*!*	*!*				endif
*!*	*!*			endwith
*!*		endwith
*!*		mindnurse  = iif(!empty(alltrim(mindnurse )), ttoc(mfechahora ) + ' ' +;
*!*			iif(used('mwkusuarios'),alltrim(mwkusuarios.idusuario) ,transf(mmedico))+ '->', '') + ;
*!*			alltrim(mindnurse)  &&alltrim(.txteditevol.value) +

*!*	endwith


*!*	miedit = alltrim(mindnurse )
*!*	mevolnurse 	= ''


*!*	mret = sqlexec(mcon1, "SELECT * FROM TabIntEvol " + ;
*!*		" where  EI_idevol = ?midevol ", "mwkVerEvol")
*!*	if mret < 0
*!*		=aerr(eros)
*!*		messagebox(eros(3), 48, "Validacion")
*!*		lgrabobien = .f.
*!*	endif
*!*	mevolnurse = nvl(EI_evolnurse,'')
*!*	if reccount('mwkVerEvol')= 0
*!*		mret = sqlexec(mcon1, "insert into tabintevol " + ;
*!*			" ( EI_fechaHora,EI_idevol,EI_indicNurse,EI_scrapacheii,EI_scrfisher,EI_scrhyh "+;
*!*			",EI_scrranson,EI_scrsofa,EI_usuario)"+;
*!*			" values "+;
*!*			" (?mfechahora, ?midevol,?miedit, ?mEI_scrapacheii , ?mEI_scrfisher , ?mEI_scrhyh,"+;
*!*			" ?mEI_scrranson ,?mEI_scrsofa ,?midusuario )" )

*!*		if mret < 0
*!*			messagebox("ERROR EN EL INGRESO"+chr(10)+;
*!*				"AVISE A SISTEMAS",16, "ERROR")
*!*			do log_errores with error(), message(), message(1), program(), lineno()
*!*			lgrabobien = .f.

*!*		endif
*!*	else
*!*		mscore = ''
*!*		if mlmodifscorep1
*!*			mscore = ',EI_scrapacheii = ?mEI_scrapacheii '
*!*		endif
*!*		if mlmodifscorep2
*!*			mscore = ',EI_scrsofa= ?mEI_scrsofa '
*!*		endif
*!*		if mlmodifscorep3
*!*			mscore = ',EI_scrranson =?mEI_scrranson '
*!*		endif
*!*		if mlmodifscorep4
*!*			mscore = ',EI_scrhyh = ?mEI_scrhyh '
*!*		endif
*!*		if mlmodifscorep5
*!*			mscore = ',EI_scrfisher = ?mEI_scrfisher '
*!*		endif
*!*		midintevol = mwkVerEvol.id
*!*		mevolnursea = nvl(EI_evolnurse,'')
*!*		mevolnursett = nvl(EI_evolnurse,'') &&+ iif(empty(nvl(EI_evolnurse,'')),'',chr(10))+  alltrim(msoloevol)
*!*		mindictt = nvl(EI_indicNurse,'') + iif(empty(nvl(EI_indicNurse,'')),'',chr(10))+ alltrim(miedit)
*!*		mret = sqlexec(mcon1, "update tabintevol " + ;
*!*			" set  EI_evolnurse = ?mevolnursett ,EI_fechaHora = ?mfechahora,EI_indicNurse = ?mindictt "+;
*!*			mscore +;
*!*			",EI_usuario = ?midusuario  where id = ?midintevol " )
*!*		if mret < 0
*!*			messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
*!*				"AVISE A SISTEMAS",16, "ERROR")
*!*			do log_errores with error(), message(), message(1), program(), lineno()
*!*		endif

*!*	endif
*!*	mIPA_GAbuenest =  .f.
*!*	mIPA_GAflog = .f.
*!*	mIPA_GAnecrosis = .f.
*!*	mIPA_GAsupura = .f.
*!*	mIPA_Rtoraco = .f.
*!*	if  musua = 0
*!*		if mlcambioevol
*!*			mret = sqlexec(mcon1, "insert into tabintevolMed " + ;
*!*				"(IPA_ALalimenta,IPA_ALbalance,IPA_ALcalorias,IPA_ALdialisis,IPA_ALdialPer,IPA_ALdiuresis,IPA_ALfecSusp "+;
*!*				",IPA_ALhemodia,IPA_ALingreso,IPA_ALmotSusp,IPA_ALsonda,IPA_ALtipoNut,IPA_ALtolera,IPA_CATB "+;
*!*				",IPA_Ccultivo,IPA_Cdias,IPA_Cesquema,IPA_codmed,IPA_CValteraciones,IPA_CVedemas,IPA_CVpulsosPer "+;
*!*				",IPA_CVPVC,IPA_CVtension,IPA_CVtipoPulso,IPA_evol,IPA_fechaH,IPA_GARHA,IPA_GAbuenest,IPA_GAcatar "+;
*!*				",IPA_GAdren,IPA_GAdrenDeb,IPA_GAdrenTipo,IPA_GAalteraciones,IPA_GAcrepita "+;
*!*				",IPA_GAdolor,IPA_GAflog,IPA_GAherCX,IPA_GAnecrosis,IPA_GAotrasLes,IPA_GAsng,IPA_GAsngDeb "+;
*!*				",IPA_GAsngTipo,IPA_GAsupura,IPA_GAvomito,IPA_idevol,IPA_NSconciencia,IPA_NSfocalizado,IPA_NSGmot "+;
*!*				",IPA_NSGocu,IPA_NSGver,IPA_NSpic,IPA_NSpupilas,IPA_NSreflejoOC,IPA_NSsignosMen,IPA_NStipofocalizado "+;
*!*				",IPA_NStrastornos,IPA_Ralteraciones,IPA_RARM,IPA_Rburbujea,IPA_Rdebito,IPA_RdebTipo,IPA_Rdrender "+;
*!*				",IPA_Rdrenizq,IPA_RdrenPleu,IPA_RfrecResp,IPA_Rmascarao2,IPA_Roscila,IPA_Rpeep,IPA_Rppico "+;
*!*				",IPA_RsatO2,IPA_RtipoResp,IPA_Rtoraco,IPA_Rvt,IPA_CVtensiond ,IPA_Rcanula,IPA_GAtipoHD,IPA_aislamiento, IPA_indicacion   )"+;
*!*				" values "+;
*!*				" (?mIPA_ALalimenta, ?mIPA_ALbalance, ?mIPA_ALcalorias, ?mIPA_ALdialisis, ?mIPA_ALdialPer, ?mIPA_ALdiuresis, ?mIPA_ALfecSusp "+;
*!*				", ?mIPA_ALhemodia, ?mIPA_ALingreso, ?mIPA_ALmotSusp, ?mIPA_ALsonda, ?mIPA_ALtipoNut, ?mIPA_ALtolera, ?mIPA_CATB "+;
*!*				", ?mIPA_Ccultivo, ?mIPA_Cdias, ?mIPA_Cesquema, ?mIPA_codmed, ?mIPA_CValteraciones, ?mIPA_CVedemas, ?mIPA_CVpulsosPer "+;
*!*				", ?mIPA_CVPVC, ?mIPA_CVtension, ?mIPA_CVtipoPulso, ?mIPA_evol, ?mfechahora,?mIPA_GARHA,?mIPA_GAbuenest "+;
*!*				", ?mIPA_GAcatar, ?mIPA_GAdren, ?mIPA_GAdrenDeb, ?mIPA_GAdrenTipo,?mIPA_GAalteraciones, ?mIPA_GAcrepita "+;
*!*				", ?mIPA_GAdolor, ?mIPA_GAflog , ?mIPA_GAherCX, ?mIPA_GAnecrosis, ?mIPA_GAotrasLes, ?mIPA_GAsng, ?mIPA_GAsngDeb "+;
*!*				", ?mIPA_GAsngTipo, ?mIPA_GAsupura, ?mIPA_GAvomito, ?midevol,?mIPA_NSconciencia,?mIPA_NSfocalizado, ?mIPA_NSGmot "+;
*!*				", ?mIPA_NSGocu, ?mIPA_NSGver, ?mIPA_NSpic, ?mIPA_NSpupilas, ?mIPA_NSreflejoOC, ?mIPA_NSsignosMen, ?mIPA_NStipofocalizado "+;
*!*				", ?mIPA_NStrastornos, ?mIPA_Ralteraciones, ?mIPA_RARM, ?mIPA_Rburbujea, ?mIPA_Rdebito, ?mIPA_RdebTipo, ?mIPA_Rdrender "+;
*!*				", ?mIPA_Rdrenizq, ?mIPA_RdrenPleu, ?mIPA_RfrecResp, ?mIPA_Rmascarao2, ?mIPA_Roscila, ?mIPA_Rpeep, ?mIPA_Rppico "+;
*!*				", ?mIPA_RsatO2, ?mIPA_RtipoResp, ?mIPA_Rtoraco, ?mIPA_Rvt,?mIPA_CVtensiond ,?mIPA_Rcanula,?mIPA_GAtipoHD,?mIPA_aislamiento, ?mIPA_indicacion   )" )

*!*			if mret < 0
*!*				messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
*!*					"AVISE A SISTEMAS",16, "ERROR")
*!*				do log_errores with error(), message(), message(1), program(), lineno()
*!*				lgrabobien = .f.
*!*			endif
*!*	**************************** html
*!*			if !prg_ejecutosql("Select top 1 Id From tabintevolMed Where IPA_IdEvol = ?midevol and IPA_CodMed = ?mIPA_codmed and IPA_FechaH = ?mfechahora Order by id Desc", "mwkEvolMedAux")
*!*				return .f.
*!*			endif

*!*			loHtml.htML = strtran(loHtml.htML, '??ID??' ,transform(mwkEvolMedAux.id))
*!*			lcHtmlBase = loHtml.htML

*!*			if !prg_ejecutosql("Update tabintevolMed set IPA_Html = ?lcHtmlBase Where ID = ?mwkEvolMedAux.Id")
*!*				return .f.
*!*			endif

*!*	****************************</ html
*!*	***** ayunos
*!*			if mlcanceloayuno
*!*				select mwkIntNutsusp
*!*				scan
*!*					mid = id
*!*					mobserva = alltrim(INA_observa)+" Susp.x: " +alltrim(mwkmedicoint.nombre)
*!*					mret = sqlexec(mcon1, "update TabIntAyuno set INA_fechaBaja = ?mfechahora ,INA_observa = ?mobserva,INA_usuariobaja = ?musua "+;
*!*						" where id= ?mid  ")
*!*				endscan
*!*			else
*!*				if mlayuno
*!*					mfechaayuno = ctot(dtoc(mIPA_ALfecSusp)+" " +transform(mhora,"@L 99")+":00")
*!*					mret = sqlexec(mcon1, "insert into TabIntAyuno " + ;
*!*						" ( INA_codmed , INA_fechaBaja , INA_fechaHoraIni , INA_idevol , INA_observa , INA_usuariobaja )"+;
*!*						" values "+;
*!*						" (?mIPA_codmed,?mfecfin, ?mfechaayuno  , ?midevol,?mIPA_ALmotSusp ,?midusuario )" )

*!*					if mret < 0
*!*						do log_errores with error(), message(), message(1), program(), lineno()
*!*					endif
*!*				endif
*!*			endif
*!*	*********
*!*	****  actualiza ARM
*!*			select mwkARM
*!*			miavn = mwkARM.id
*!*			if moptarm  = 2 and reccount('mwkARM')>0   &&&& da por finalizada
*!*				mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
*!*					" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo=1 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia ")
*!*				if mret < 0
*!*					do log_errores with error(), message(), message(1), program(), lineno()
*!*				endif
*!*			else &&& actualiza o inserta
*!*				mret = sqlexec(mcon1, "SELECT id FROM TabIntAVN " + ;
*!*					" where  AVN_idevol = ?midevol and AVN_tipo=1 and AVN_fechafin = ?mfecfin ", "mwkVerAVN")

*!*				if mret < 0
*!*					do log_errores with error(), message(), message(1), program(), lineno()
*!*				endif

*!*				miavn = mwkVerAVN.id
*!*				if mIPA_RARM = .t. and mlcbioARM
*!*	*!*					if miavn = 0 &&&inserto
*!*					marmfini= iif(vartype(marmfini)#"D",ttod(mwkfecserv.fechahora),marmfini)

*!*					mret = sqlexec(mcon1, "insert into TabIntAVN " + ;
*!*						" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
*!*						" values "+;
*!*						" (?marmcomp  ,?mfecfin, ?mfechahora,?marmfini, ?midevol,?marmmodo, ?marmmot , 1,?midusuario  )" )
*!*					if mret < 0
*!*						do log_errores with error(), message(), message(1), program(), lineno()
*!*					endif
*!*				else
*!*	*!*					endif
*!*				endif
*!*			endif
*!*			if mlcbioARM
*!*				do sp_grabo_evol_int_arm	with ,moptarm  ,mIPA_codmed ,,mIPA_RfrecResp,midevol,,;
*!*					mIPA_Rpeep,,mIPA_Rppico,,mIPA_RsatO2 ,,,mIPA_Rvt,moptarm  ,marmmodo ,marmcomp,marmmot ,marmfini ,,,,;
*!*					.f.,.f.,.f.
*!*			endif
*!*	****  actualiza tubo OT
*!*			select mwkToT
*!*			mitot = mwkToT.id
*!*			if mtuboot = 2 and reccount('mwkToT')>0   &&&& da por finalizada
*!*				mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
*!*					" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo=4 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia ")
*!*				if mret < 0
*!*					do log_errores with error(), message(), message(1), program(), lineno()
*!*				endif
*!*			else &&& actualiza o inserta
*!*				if mtuboot = 1 and mlcambiotot
*!*					mret = sqlexec(mcon1, "SELECT id FROM TabIntAVN " + ;
*!*						" where  AVN_idevol = ?midevol and AVN_tipo = 4 and AVN_fechafin = ?mfecfin", "mwkVerAVN")
*!*					mitot = mwkVerAVN.id
*!*	*!*					if mitraq = 0 &&&inserto
*!*					mret = sqlexec(mcon1, "insert into TabIntAVN " + ;
*!*						" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
*!*						" values "+;
*!*						" (0,?mfecfin, ?mfechahora,?mtotfini, ?midevol,0,0 , 4,?midusuario  )" )
*!*					if mret < 0
*!*						do log_errores with error(), message(), message(1), program(), lineno()
*!*					endif
*!*	*!*					else
*!*	*!*	*					if mtraq = 1
*!*	*!*							mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   "+;
*!*	*!*								" ,AVN_modo = ?marmmodo ,AVN_motivo = ?marmmot , AVN_complica = ?marmcomp  where id = ?mitraq ")
*!*	*!*	*					endif
*!*	*!*					endif
*!*				endif
*!*			endif
*!*	****  actualiza traq
*!*			select mwkTraq
*!*			mitraq = mwkTraq.id
*!*			if mtraq = 2 and reccount('mwkTraq')>0   &&&& da por finalizada
*!*				mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
*!*					" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo=  5 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia ")
*!*				if mret < 0
*!*					do log_errores with error(), message(), message(1), program(), lineno()
*!*				endif
*!*			else &&& actualiza o inserta
*!*				if mtraq = 1 and mlcambiotraq
*!*					mret = sqlexec(mcon1, "SELECT id FROM TabIntAVN " + ;
*!*						" where  AVN_idevol = ?midevol and AVN_tipo = 5 and AVN_fechafin = ?mfecfin", "mwkVerAVN")
*!*					mitraq = mwkVerAVN.id
*!*	*!*					if mitraq = 0 &&&inserto
*!*					mtraqfini = iif(vartype(mtraqfini )#"D",ttod(mwkfecserv.fechahora),mtraqfini )

*!*					mret = sqlexec(mcon1, "insert into TabIntAVN " + ;
*!*						" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
*!*						" values "+;
*!*						" (0,?mfecfin, ?mfechahora,?mtraqfini , ?midevol,0,0 , 5,?midusuario  )" )
*!*					if mret < 0
*!*						do log_errores with error(), message(), message(1), program(), lineno()
*!*					endif
*!*				endif
*!*			endif
*!*	****  actualiza drenaje pleural
*!*			select mwkDP
*!*			miDP = mwkDP.id
*!*			mDPacc = 0
*!*			if mRdrenPleu  = 2 and reccount('mwkDP')>0   &&&& da por finalizada
*!*				mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
*!*					" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo= 26 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia  ")
*!*				if mret < 0
*!*					do log_errores with error(), message(), message(1), program(), lineno()
*!*				endif
*!*			else &&& actualiza o inserta
*!*				if  mRdrenPleu   = 1 and mlcambiodp
*!*					mret = sqlexec(mcon1, "SELECT id FROM TabIntAVN " + ;
*!*						" where  AVN_idevol = ?midevol and AVN_tipo = 26  and AVN_fechafin = ?mfecfin ", "mwkVerDP")
*!*					miDP = mwkVerDP.id
*!*	*!*					if miavn = 0 &&&inserto
*!*					mDPfini = iif(vartype(mDPfini )#"D",ttod(mwkfecserv.fechahora),mDPfini )

*!*					mret = sqlexec(mcon1, "insert into TabIntAVN " + ;
*!*						" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
*!*						" values "+;
*!*						" (0,?mfecfin, ?mfechahora,?mDPfini , ?midevol,?mDPacc , 0, 26,?midusuario  )" )
*!*					if mret < 0
*!*						do log_errores with error(), message(), message(1), program(), lineno()
*!*					endif
*!*				endif
*!*			endif
*!*	****  actualiza PIC
*!*			select mwkPIC
*!*			mipic = mwkPIC.id
*!*			if mpic = 2 and reccount('mwkPIC')>0   &&&& da por finalizada
*!*				mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
*!*					" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo=  9 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia ")
*!*				if mret < 0
*!*					do log_errores with error(), message(), message(1), program(), lineno()
*!*				endif
*!*			else &&& actualiza o inserta
*!*				if sipic and mlcambiopic
*!*					mret = sqlexec(mcon1, "SELECT id FROM TabIntAVN " + ;
*!*						" where  AVN_idevol = ?midevol and AVN_tipo = 9 and AVN_fechafin = ?mfecfin", "mwkVerAVN")
*!*					miPIC = mwkVerAVN.id
*!*	*				if miPIC = 0 &&&inserto
*!*					mfecinipic = iif(vartype(mfecinipic )#"D",ttod(mwkfecserv.fechahora),mfecinipic )

*!*					mret = sqlexec(mcon1, "insert into TabIntAVN " + ;
*!*						" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
*!*						" values "+;
*!*						" (0,?mfecfin, ?mfechahora,?mfecinipic , ?midevol,0,0 , 9,?midusuario  )" )
*!*					if mret < 0
*!*						do log_errores with error(), message(), message(1), program(), lineno()
*!*					endif
*!*				endif
*!*			endif

*!*	****  actualiza VEVP
*!*			select mwkEVP
*!*			mivevp = mwkEVP.id
*!*			if mvevp = 2 and reccount('mwkEVP')>0   &&&& da por finalizada
*!*				mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
*!*					" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo=  6 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia ")
*!*				if mret < 0
*!*					do log_errores with error(), message(), message(1), program(), lineno()
*!*				endif
*!*			else &&& actualiza o inserta
*!*				if sivevp and mlcambioevp
*!*					mret = sqlexec(mcon1, "SELECT id FROM TabIntAVN " + ;
*!*						" where  AVN_idevol = ?midevol and AVN_tipo=6 and AVN_fechafin = ?mfecfin ", "mwkVervevp")
*!*					mivevp = mwkVervevp.id
*!*	*!*					if miavn = 0 &&&inserto
*!*					mvevpfini = iif(vartype(mvevpfini )#"D",ttod(mwkfecserv.fechahora),mvevpfini )
*!*					mret = sqlexec(mcon1, "insert into TabIntAVN " + ;
*!*						" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
*!*						" values "+;
*!*						" (?mvevpcomp ,?mfecfin, ?mfechahora,?mvevpfini , ?midevol,?mvevpacc , 0, 6,?midusuario  )" )
*!*					if mret < 0
*!*						do log_errores with error(), message(), message(1), program(), lineno()
*!*					endif
*!*				endif
*!*			endif

*!*	****  actualiza VIAC
*!*			select mwkCVC
*!*			mivcac = mwkCVC.id
*!*			if mvc = 2 and reccount('mwkCVC')>0   &&&& da por finalizada
*!*				mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
*!*					" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo=  2 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia ")
*!*				if mret < 0
*!*					do log_errores with error(), message(), message(1), program(), lineno()
*!*				endif
*!*			else &&& actualiza o inserta
*!*				if sivc and mlcambioevc
*!*					mret = sqlexec(mcon1, "SELECT id FROM TabIntAVN " + ;
*!*						" where  AVN_idevol = ?midevol and AVN_tipo= 2 and AVN_fechafin = ?mfecfin ", "mwkVerVC")
*!*					mivc = mwkVerVC.id
*!*	*!*					if miavn = 0 &&&inserto
*!*					mvcfini = iif(vartype(mvcfini )#"D",ttod(mwkfecserv.fechahora),mvcfini )
*!*					mret = sqlexec(mcon1, "insert into TabIntAVN " + ;
*!*						" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
*!*						" values "+;
*!*						" (?mvccomp ,?mfecfin, ?mfechahora,?mvcfini , ?midevol,?mvcacc , 0, 2,?midusuario  )" )
*!*					if mret < 0
*!*						do log_errores with error(), message(), message(1), program(), lineno()
*!*					endif
*!*				endif
*!*			endif

*!*	****  actualiza CART
*!*			select mwkCART
*!*			micart = mwkCART.id
*!*			if mcart = 2 and reccount('mwkCART')>0   &&&& da por finalizada
*!*				mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
*!*					" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo=  7 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia ")
*!*				if mret < 0
*!*					do log_errores with error(), message(), message(1), program(), lineno()
*!*				endif
*!*			else &&& actualiza o inserta
*!*				if sicart and mlcambiocart
*!*					mret = sqlexec(mcon1, "SELECT id FROM TabIntAVN " + ;
*!*						" where  AVN_idevol = ?midevol and AVN_tipo= 7  and AVN_fechafin = ?mfecfin ", "mwkVercart")
*!*					micart = mwkVercart.id
*!*	*!*					if miavn = 0 &&&inserto
*!*					mcartfini = iif(vartype(mcartfini )#"D",ttod(mwkfecserv.fechahora),mcartfini )
*!*					mret = sqlexec(mcon1, "insert into TabIntAVN " + ;
*!*						" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
*!*						" values "+;
*!*						" (?mcartcom ,?mfecfin, ?mfechahora,?mcartfini , ?midevol,?mcartacc , 0, 7,?midusuario  )" )
*!*					if mret < 0
*!*						do log_errores with error(), message(), message(1), program(), lineno()
*!*					endif
*!*				endif
*!*			endif
*!*	****  actualiza CSG
*!*			select mwkCSG
*!*			micsg = mwkCSG.id
*!*			if mcsg = 2 and reccount('mwkCSG')>0   &&&& da por finalizada
*!*				mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia  "+;
*!*					" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo=  8 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia ")
*!*				if mret < 0
*!*					do log_errores with error(), message(), message(1), program(), lineno()
*!*				endif
*!*			else &&& actualiza o inserta
*!*				if sicsg and mlcambiocsg
*!*					mret = sqlexec(mcon1, "SELECT id FROM TabIntAVN " + ;
*!*						" where  AVN_idevol = ?midevol and AVN_tipo= 8  and AVN_fechafin = ?mfecfin ", "mwkVercSG")
*!*					micsg = mwkVercSG.id
*!*	*!*					if miavn = 0 &&&inserto
*!*					mcsgfini = iif(vartype(mcsgfini )#"D",ttod(mwkfecserv.fechahora),mcsgfini )
*!*					mret = sqlexec(mcon1, "insert into TabIntAVN " + ;
*!*						" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
*!*						" values "+;
*!*						" (?mcsgcomp ,?mfecfin, ?mfechahora,?mcsgfini , ?midevol,?mcsgacc , 0, 8,?midusuario  )" )
*!*					if mret < 0
*!*						do log_errores with error(), message(), message(1), program(), lineno()
*!*					endif
*!*				endif
*!*			endif
*!*	****  actualiza dialisis
*!*			select mwkHD
*!*			midial = mwkHD.id
*!*			if mdial = 2 and reccount('mwkHD')>0   &&&& da por finalizada
*!*				mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
*!*					" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo=  10 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia ")
*!*				if mret < 0
*!*					do log_errores with error(), message(), message(1), program(), lineno()
*!*				endif
*!*			else &&& actualiza o inserta
*!*				if sihd and mlcambiodia
*!*					mret = sqlexec(mcon1, "SELECT id FROM TabIntAVN " + ;
*!*						" where  AVN_idevol = ?midevol and AVN_tipo= 10 and AVN_fechafin = ?mfecfin ", "mwkVerVC")
*!*					mivc = mwkVerVC.id
*!*	*!*					if miavn = 0 &&&inserto
*!*					mdialfini = iif(vartype(mdialfini )#"D",ttod(mwkfecserv.fechahora),mdialfini )
*!*					mret = sqlexec(mcon1, "insert into TabIntAVN " + ;
*!*						" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
*!*						" values "+;
*!*						" (?mdialcomp ,?mfecfin, ?mfechahora,?mdialfini , ?midevol,?mdialacc , ?mdialtipo, 10,?midusuario  )" )
*!*					if mret < 0
*!*						do log_errores with error(), message(), message(1), program(), lineno()
*!*					endif
*!*				endif
*!*			endif
*!*	****  actualiza SNG
*!*			select mwkSNG
*!*			miSNG = mwkSNG.id
*!*			mSNGcomp = 0
*!*			if mSNG = 2 and reccount('mwkSNG')>0   &&&& da por finalizada
*!*				mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
*!*					" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo=  3 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia  ")
*!*				if mret < 0
*!*					do log_errores with error(), message(), message(1), program(), lineno()
*!*				endif
*!*			else &&& actualiza o inserta
*!*				if sisng and mlcambiosng
*!*					mret = sqlexec(mcon1, "SELECT id FROM TabIntAVN " + ;
*!*						" where  AVN_idevol = ?midevol and AVN_tipo= 3  and AVN_fechafin = ?mfecfin ", "mwkVerSNG")
*!*					miSNG = mwkVerSNG.id
*!*	*!*					if miavn = 0 &&&inserto
*!*					mSNGfini = iif(vartype(mSNGfini )#"D",ttod(mwkfecserv.fechahora),mSNGfini )
*!*					mret = sqlexec(mcon1, "insert into TabIntAVN " + ;
*!*						" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
*!*						" values "+;
*!*						" (?mSNGcomp ,?mfecfin, ?mfechahora,?mSNGfini , ?midevol,?mSNGacc , 0, 3,?midusuario  )" )
*!*					if mret < 0
*!*						do log_errores with error(), message(), message(1), program(), lineno()
*!*					endif
*!*				endif
*!*			endif
*!*	****  actualiza SVES
*!*			select mwkSVES
*!*			miSVES = mwkSVES.id
*!*			if mSVES = 2 and reccount('mwkSVES')>0   &&&& da por finalizada
*!*				mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
*!*					" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo= 11 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia  ")
*!*				if mret < 0
*!*					do log_errores with error(), message(), message(1), program(), lineno()
*!*				endif
*!*			else &&& actualiza o inserta
*!*				if siSVES and mlcambiosves
*!*					mret = sqlexec(mcon1, "SELECT id FROM TabIntAVN " + ;
*!*						" where  AVN_idevol = ?midevol and AVN_tipo = 11  and AVN_fechafin = ?mfecfin ", "mwkVerSVES")

*!*					if mret < 0
*!*						do log_errores with error(), message(), message(1), program(), lineno()
*!*					endif

*!*					miSVES = mwkVerSVES.id
*!*					if miSVES = 0 &&&inserto
*!*						mSVESfini = iif(vartype(mSVESfini)#"D",ttod(mwkfecserv.fechahora),mSVESfini)
*!*						mret = sqlexec(mcon1, "insert into TabIntAVN " + ;
*!*							" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
*!*							" values "+;
*!*							" (0,?mfecfin, ?mfechahora,?mSVESfini , ?midevol,?mSVESacc , 0, 11,?midusuario  )" )
*!*					endif
*!*					if mret < 0
*!*						do log_errores with error(), message(), message(1), program(), lineno()
*!*					endif
*!*				endif
*!*			endif
*!*		endif
*!*	endif
*!*	****  actualiza esquemas
*!*	if mlmodifatb
*!*		mret = sqlexec(mcon1, "select ID, EATB_dias, EATB_esquema, EATB_fechafin, EATB_fechaini, EATB_idevol "+;
*!*			" from TabIntEsquemas "+;
*!*			"where EATB_idevol= ?midevol"  , "mwkatbesq")

*!*		select mwkatbesquema
*!*		scan
*!*			if id>40
*!*				midesq = id
*!*				if EATB_fechafin>=ttod(mwkfecserv.fechahora)-1  and EATB_fechafin<mfecfin   && dar de baja
*!*					mfec = EATB_fechafin
*!*					mret = sqlexec(mcon1, "update TabIntEsquemas set EATB_fechafin = ?mfec "+;
*!*						" where Id = ?midesq ")
*!*					if mret < 0
*!*						messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
*!*							"AVISE A SISTEMAS",16, "ERROR")
*!*						do log_errores with error(), message(), message(1), program(), lineno()
*!*					endif
*!*				endif
*!*			else
*!*				if EATB_fechafin = mfecfin
*!*					mEATB_dias = mwkatbesquema->EATB_dias
*!*					mEATB_esquema = mwkatbesquema->EATB_esquema
*!*					mEATB_fechafin = mwkatbesquema->EATB_fechafin
*!*					mEATB_fechaini = mwkatbesquema->EATB_fechaini
*!*					mret = sqlexec(mcon1, "insert into TabIntEsquemas " + ;
*!*						" ( EATB_dias, EATB_esquema, EATB_fechafin, EATB_fechaini, EATB_idevol)"+;
*!*						" values "+;
*!*						" (?mEATB_dias ,?mEATB_esquema , ?mEATB_fechafin ,?mEATB_fechaini ,?midevol )" )
*!*					if mret < 0
*!*						messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
*!*							"AVISE A SISTEMAS",16, "ERROR")
*!*						do log_errores with error(), message(), message(1), program(), lineno()
*!*					endif
*!*				endif
*!*			endif
*!*		endscan
*!*	endif


*!*	if mlmodifevoln and musua > 0
*!*		mret = sqlexec(mcon1, "insert into tabintevolNurse " + ;
*!*			" (EIn_codcienanda , EIn_evolnurse , EIn_fechah , EIn_paradmf , EIn_paralerg , " + ;
*!*			"EIn_paralergque , EIn_parotros , EIN_idevol , EIn_usuario ) values "+;
*!*			" (1, ?msoloevol,?mfechahora ,?mparadmf , ?mparalerg , "+;
*!*			" ?mparalergque , ?mparotros  , ?midevol ,?midusuario   )" )
*!*		if mret < 0
*!*			messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
*!*				"AVISE A SISTEMAS",16, "ERROR")
*!*			do log_errores with error(), message(), message(1), program(), lineno()
*!*		endif

*!*	endif
*!*	if mlmodifresumen
*!*		mret = sqlexec(mcon1, "insert into TabIntResumenHC	 " + ;
*!*			"(RH_fechaHora,RH_idevol,RH_resumen,RH_usuario)  values"+;
*!*			"(?mfechahora ,?midevol,?mresumen,?midusuario  )")
*!*		if mret < 0
*!*			messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
*!*				"AVISE A SISTEMAS",16, "ERROR")
*!*			do log_errores with error(), message(), message(1), program(), lineno()
*!*		endif
*!*	endif
*!*	if mlmodifIC
*!*		mret = sqlexec(mcon1, "insert into TabIntevolIC 	 " + ;
*!*			"(EIC_fechaHora ,EIC_idevol ,EIC_evolIC ,EIC_usuario,EIC_codesp, EIC_codpun )  values"+;
*!*			"(?mfechahora ,?midevol,?mintercons,?midusuario,?mICcodesp, ?mICcodpun  )")

*!*		if mret < 0
*!*			messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
*!*				"AVISE A SISTEMAS",16, "ERROR")
*!*			do log_errores with error(), message(), message(1), program(), lineno()
*!*			lgrabobien = .f.
*!*		endif
*!*	endif


*!*	if musua = 0		&&&& datos medicos
*!*		if mlcambioepicris
*!*			if mwktaltasint.tipoest=0
*!*				miestado = mwktaltasint.id
*!*				mcodcie10 = mwkcie9.id
*!*				mIH_resumen = mopage6.txteditresumen.value

*!*				mret = sqlexec(mcon1, "update TabIntHCE set IH_horaCierre = ?mfechahora , IH_codestado = ?miestado "+;
*!*					",IH_codmedcie = ?mmedico,IH_codcie = ?mcodcie10,IH_resumen = ?mIH_resumen  "+;
*!*					" where Id = ?midevol ")
*!*				if mret < 0
*!*					messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
*!*						"AVISE A SISTEMAS",16, "ERROR")
*!*					do log_errores with error(), message(), message(1), program(), lineno()
*!*				endif
*!*			else
*!*				mIH_resumen = alltrim(mopage6.txteditresumen.value)
*!*				if !empty(mIH_resumen)
*!*					mret = sqlexec(mcon1, "update TabIntHCE set IH_resumen = ?mIH_resumen  "+;
*!*						" where Id = ?midevol ")
*!*					if mret < 0
*!*						messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
*!*							"AVISE A SISTEMAS",16, "ERROR")
*!*						do log_errores with error(), message(), message(1), program(), lineno()
*!*					endif
*!*				endif
*!*			endif
*!*			with mopage6
*!*				select mwkciesec
*!*				scan
*!*					if id>0
*!*						midepi = id
*!*						if IE_fechaHBaja>=ttod(mwkfecserv.fechahora)-1  and IE_fechaHBaja<mfecfin   && dar de baja
*!*							mfec = IE_fechaHBaja
*!*							mret = sqlexec(mcon1, "update TabIntEpi set IE_fechaHBaja = ?mfec "+;
*!*								" where Id = ?midepi and IE_tipo=0 ")
*!*							if mret < 0
*!*								messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
*!*									"AVISE A SISTEMAS",16, "ERROR")
*!*								do log_errores with error(), message(), message(1), program(), lineno()
*!*							endif
*!*						endif
*!*					else
*!*						midcie10 = idcie10
*!*	&&,IE_patologia
*!*						mret = sqlexec(mcon1, "insert into TabIntEpi " + ;
*!*							" ( IE_codcie ,IE_codmed ,IE_fechaHora,IE_fechaHBaja, IE_idevol ,IE_tipo)"+;
*!*							" values "+;
*!*							" (?midcie10 ,?mmedico, ?mfechahora,?mfecfin ,?midevol,0 )" )
*!*						if mret < 0
*!*							messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
*!*								"AVISE A SISTEMAS",16, "ERROR")
*!*							do log_errores with error(), message(), message(1), program(), lineno()
*!*						endif
*!*					endif
*!*				endscan

*!*	**codcie10 ,descrip,idcie10,IE_codcie ,IE_codmed ,IE_patologia,IE_fechaHora,IE_fechaHBaja, IE_idevol ,IE_tipo
*!*				if .chkfinepi.value = 1
*!*					mpatologia =''
*!*					mret = sqlexec(mcon1, "select id from TabIntEpi " + ;
*!*						" where  IE_idevol = ?midevol and IE_tipo=99 AND IE_fechaHBaja = ?mfecfin  " ,"mwkctrepi")
*!*					if reccount("mwkctrepi")>0
*!*						MIDEP = mwkctrepi.id
*!*						mret = sqlexec(mcon1, "UPDATE TabIntEpi " + ;
*!*							" SET  IE_codmed = ?mmedico,IE_fechaHora=?mfechahora  where  ID = ?midep ")
*!*					else
*!*						mret = sqlexec(mcon1, "insert into TabIntEpi " + ;
*!*							" ( IE_codcie ,IE_codmed ,IE_fechaHora,IE_fechaHBaja,IE_patologia, IE_idevol ,IE_tipo)"+;
*!*							" values "+;
*!*							" (0 ,?mmedico, ?mfechahora,?mfecfin ,?mpatologia ,?midevol,99 )" )
*!*					endif
*!*					if mret < 0
*!*						messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
*!*							"AVISE A SISTEMAS",16, "ERROR")
*!*						do log_errores with error(), message(), message(1), program(), lineno()
*!*					endif
*!*				endif
*!*				with .CntAntProc.Pageframe1
*!*					for hh = 1 to .pagecount
*!*						cmpage = ".Page"+alltrim(transform(hh))
*!*						with &cmpage
*!*							mpatologia = alltrim(.Txtedit1.value)
*!*							mret = sqlexec(mcon1, "insert into TabIntEpi " + ;
*!*								" ( IE_codcie ,IE_codmed ,IE_fechaHora,IE_fechaHBaja,IE_patologia, IE_idevol ,IE_tipo)"+;
*!*								" values "+;
*!*								" (0 ,?mmedico, ?mfechahora,?mfecfin ,?mpatologia ,?midevol,?hh )" )
*!*							if mret < 0
*!*								messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
*!*									"AVISE A SISTEMAS",16, "ERROR")
*!*								do log_errores with error(), message(), message(1), program(), lineno()
*!*							endif
*!*						endwith
*!*					next hh
*!*				endwith
*!*			endwith
*!*		endif
*!*		if mlmedcabe and mlcambioanam
*!*			mret = sqlexec(mcon1, "update TabIntHCE set IH_motIngreso = ?mIH_motIngreso , IH_procedencia = ?mIH_procedencia "+;
*!*				",ih_codmed = ?mmedico where Id = ?midevol ")
*!*		else
*!*			if mlcambioanam && mlcambioanamllave
*!*				mret = sqlexec(mcon1, "update TabIntHCE set IH_motIngreso = ?mIH_motIngreso , IH_procedencia = ?mIH_procedencia "+;
*!*					" where Id = ?midevol ")
*!*			endif
*!*		endif
*!*		if mlcambioepicris
*!*			if mwktaltasint.tipoest=0
*!*				miestado = mwktaltasint.id
*!*				mcodcie10 = mwkcie9.id
*!*				mIH_resumen = mopage6.txteditresumen.value

*!*				mret = sqlexec(mcon1, "update TabIntHCE set IH_horaCierre = ?mfechahora , IH_codestado = ?miestado "+;
*!*					",IH_codmedcie = ?mmedico,IH_codcie = ?mcodcie10,IH_resumen = ?mIH_resumen  "+;
*!*					" where Id = ?midevol ")
*!*				if mret < 0
*!*					messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
*!*						"AVISE A SISTEMAS",16, "ERROR")
*!*					do log_errores with error(), message(), message(1), program(), lineno()
*!*				endif
*!*			else
*!*				mIH_resumen = alltrim(mopage6.txteditresumen.value)
*!*				if !empty(mIH_resumen)
*!*					mret = sqlexec(mcon1, "update TabIntHCE set IH_resumen = ?mIH_resumen  "+;
*!*						" where Id = ?midevol ")
*!*					if mret < 0
*!*						messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
*!*							"AVISE A SISTEMAS",16, "ERROR")
*!*						do log_errores with error(), message(), message(1), program(), lineno()
*!*					endif
*!*				endif
*!*			endif

*!*		endif
*!*		if mret < 0
*!*			messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
*!*				"AVISE A SISTEMAS",16, "ERROR")
*!*			do log_errores with error(), message(), message(1), program(), lineno()
*!*		endif
*!*	endif
*!*	if 	lgrabobien

*!*		use in select('mwkVerEvol')
*!*		use in select('mwkatbesq')
*!*		use in select('mwkciesec')
*!*		use in select('mwkVerSVES')
*!*		use in select('mwkVerSNG')
*!*		use in select('mwkVerVC')
*!*		use in select('mwkVercSG')
*!*		use in select('mwkVercart')
*!*		use in select('mwkVerVC')
*!*		use in select('mwkVervevp')
*!*		use in select('mwkVerAVN')
*!*		use in select('mwkVerDP')
*!*		use in select('mwkEvolMedAux')
*!*		use in select('mwkindCCind')
*!*		use in select('mwkindCCDind')
*!*		use in select('mwkctresq')

*!*	endif
