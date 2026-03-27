****
** Grabo evolucion del paciente
****
*!*		do sp_grabo_evolucion_INT with mnreg, thisform.txtprotocolo.value,thisform.medcabecera;
*!*			, thisform.PgConsulta.pgEvolmed,thisform.PgConsulta.pgIndNur,thisform.PgConsulta.pgCSV;
*!*			,iif(thisform.mformorigen=28, mwkusuarios.codigovax,0),;
*!*			thisform.lmodifresumen,thisform.lclose,iif(thisform.mformorigen=28 ,0,thisform.miorigen)

Parameters lgrabobien,mnroreg, mprot, mmedico,mopage2, mopage3,mopage4,mopage5,mopage6,mopage7,musua,morigen
Dimension admfar(11),pract(13)
Dime porcMC(5)
Do sp_busco_estados With 7, " and tipo = 77 ", "mwkhabimn"
* mopage2 = thisform.PgConsulta.pgEvolmed
* mopage3 = thisform.PgConsulta.pgIndNur
* mopage4 = thisform.PgConsulta.pgCSV;
* mopage5 = thisform.PgConsulta.pgAnam;
* mopage6 = thisform.PgConsulta.pgEpicris;
* mopage7 = thisform.PgConsulta.PgIndic
*****
* Campos reutilizados
*****
* tabintevol.EI_parotros -> ttoc(fecha-hora de pasaje a pisos)
* tabintevol.EI_parAdmF  -> ttoc(fecha-hora de pasaje a CEG )
* tabintevol.EI_codmed -> medico que realiza el protocolo quirurgico >0 (cero)
* tabintevol.EI_evolucion - > detalle del protocolo quirurgico
* tabintevol.EI_codCIENanda -> si va la historia de traumatologia a archivo
* tabintevol.EI_parAlerg -> = 1 hay indicaciones para enfermeria = 0 no
* tabintevol.EI_parFreCard-> tipo de Consulta Traumat, NO Traum, ART etc
* EI_fechaHora -> hora de atencion de emergencias
******
Do sp_busco_estados With 7,' and tipo = 43 ','mwkestHabepinew'&&
If Vartype(morigen)#"N"
	morigen = 0
	lmismomed = .F.
Endif
midusuario = Iif(Used('mwkusuarios'),mwkusuarios.Id ,mwkusuario.Id)
admfar(1)	= " IM  "
admfar(2)	= " EV  "
admfar(3)	= " ID  "
admfar(4)	= " SC  "
admfar(5)	= " INH "
admfar(6)	= " REC "
admfar(7)	= " ENT "
admfar(8)	= " VAG "
admfar(9)	= " ORA "
admfar(10)	= " OCU "
admfar(11)	= " NAS "
pract(1) 	= " Cat.Vesical "
pract(2) 	= " Sonda Nasogast. "
pract(3) 	= " Acc.Ven.Perif. "
pract(4) 	= " Curaciones "
pract(5) 	= " Lavado Oido "
pract(6) 	= " Enema "
pract(7) 	= " Lavado Vesical "
pract(8) 	= " ECG "
pract(9) 	= " Extración Sangre "
pract(10) 	= " Muestra Orina "
pract(11) 	= " Muestra Mat.Fecal "
pract(12) 	= " Monitoreo Cardíaco Continuo "
pract(13) 	= " Contención Física "

porcMC(1) = "    	  "
porcMC(2) = "<50%     "
porcMC(3) = "50 - 75% "
porcMC(4) = "75 - 100%"
porcMC(5) = ">100%    "

lvaaarchivo = 0
lgrabobien = .T.
mfechahora  = sp_busco_fecha_serv("DT")
mfechadia = Ttod(mfechahora )
mfecini = Ctod("01/01/1900")
mfecfin = Ctod("01/01/2100")
mcodcienanda = 0
msoloevol = ''

mltipalta = mopage2.Parent.Parent.ltipalta
mlcodesta = mopage2.Parent.Parent.lcodesta
mlmodifresumen = mopage2.Parent.Parent.lmodifresumen
mlmodifIC 	= mopage2.Parent.Parent.lmodifIC
mlcierreant = mopage2.Parent.Parent.lcierreant
midevol	= mopage2.Parent.Parent.midevol
mlmodifevoln = mopage2.Parent.Parent.lmodifevoln
mlcambiocsv  = mopage2.Parent.Parent.lcambiocsv
mlcambiocsvm  = mopage2.Parent.Parent.lcambiocsvm
mlcambioevol = mopage2.Parent.Parent.lcambioevol
mlcambioepicris = mopage2.Parent.Parent.lcambioepicris
mlfinepicris = mopage2.Parent.Parent.lfinepicris
mlcbioARM  = mopage2.Parent.Parent.lcbioARM
mlcambioanam  = mopage2.Parent.Parent.lcambioanam
mlcambioanamllave= mopage2.Parent.Parent.lcambioanamllave
mlmodifatb = mopage2.Parent.Parent.lmodifatb
mlmedcabe = (Reccount('mwkanam')=0 Or mlcambioanam )
mlcambiopic  = mopage2.Parent.Parent.lcambiopic
mlcambioevp  = mopage2.Parent.Parent.lcambioevp
mlcambioevc   = mopage2.Parent.Parent.lcambioevc
mlcambiocart = mopage2.Parent.Parent.lcambiocart
mlcambiocsg = mopage2.Parent.Parent.lcambiocsg
mlcambiotot  = mopage2.Parent.Parent.lcambiotot
mlcambiotraq  = mopage2.Parent.Parent.lcambiotraq
mlcambiodp    = mopage2.Parent.Parent.lcambiodp
mlcambiosng   = mopage2.Parent.Parent.lcambiosng
mlcambiosves  = mopage2.Parent.Parent.lcambiosves
mlcambiodia = mopage2.Parent.Parent.lcambiodia
mlcanceloayuno = mopage2.Parent.Parent.lcanceloayuno
mlcambiosngn =  mopage2.Parent.Parent.lcambiosngnut
mlmodifscore = (mopage2.Parent.Parent.lmodifscore1 Or mopage2.Parent.Parent.lmodifscore2 Or mopage2.Parent.Parent.lmodifscore3;
	or mopage2.Parent.Parent.lmodifscore4 Or mopage2.Parent.Parent.lmodifscore5)
mlmodifscore1 = mopage2.Parent.Parent.lmodifscore1
mlmodifscore2 = mopage2.Parent.Parent.lmodifscore2
mlmodifscore3= mopage2.Parent.Parent.lmodifscore3
mlmodifscore4= mopage2.Parent.Parent.lmodifscore4
mlmodifscore5= mopage2.Parent.Parent.lmodifscore5
mlmodifkine =  (mopage2.Parent.Parent.lmodifevolk Or mopage2.Parent.Parent.lcambioevolkr) && KINE
mlcambiometanut = mopage2.Parent.Parent.lcambiometanut
mlalertacovid = mopage2.Parent.Parent.lalertacovid

If mlmodifIC
	mICcodesp =   mopage2.Parent.Parent.mICcodesp
	mICcodpun =   mopage2.Parent.Parent.mICcodpun
Else
	mICcodesp =   ''
	mICcodpun =   0
Endif
* TxtEdtIndic  medico
* TxteditEvol ingresado ahora
* TxtEdtEvol  anterior

miprotquir = ''
mcodmedpq  = 0
mevolnursea = ''
mevolnursett = ''
mindictt = ''

calta 	 = '' &&iif(mwkveoproto.tipoest =0 or lcierreant,"Evolución Posterior al CIERRE del Protocolo ","")
caltanur = ''&&iif((mwkveoproto.tipoest =0 or lcierreant) and !empty(mopage3.txtedtindic.value),"Indicación Posterior al CIERRE del Protocolo ","")
*!*		mmotc 	 = mopage2.txteditmotc.value
*!*		mantec 	 = mopage2.txteditantec.value
*!*		mevolf	 = mopage2.txteditevolf.value
*!*		mevola	 = mopage2.edtevol.value
*!*		mevol	 = mopage2.txteditevol.value
*!*		mindic	 = mopage3.txtedtindic.value

mintercons = ''
With mopage2.PgEvol.pgEvolIC.Pgintercons1 &&(**)
	mesp = ''
	If .optopcion.Value >0
		If .optopcion.Value <3
			mesp =  Alltrim(.pageic.pgant.txtpresta.Value) +Chr(10)
		Else
			With .pageic.pgExt
				mesp =  Alltrim(.cboespe.DisplayValue) +Chr(10)+"Profesional:" + Alltrim(.txtnombre.Value)+;
					iif(Val(Transform(.txtmatricula.Value))>0," M.N.:"+Transform(.txtmatricula.Value),'')+Chr(10)
			Endwith
		Endif
	Endif
	mievolm = '' &&mopage2.PgEvol.PgEvolKine.Cntkinesio.TxteditEvol.value
	mintercons = mesp + Alltrim(.txteditEvol.Value )+ Iif(!Empty(mievolm),Chr(10)+"Evolución:"+ Chr(10)+mievolm + Chr(10),'')
Endwith
mfechaini  = Ctot("01/01/1900")
megparalerg	= .F. &&mopage3.chknewindic.value
If mlcambioanam
	Do sp_grabo_evol_int_anam With mopage5,midevol
Endif

With mopage5
	mIH_motIngreso = mwkcie9i.Id
	mIH_procedencia = mwkprocede.Id
	mIH_reingre = (.optreingre.Value =1)
Endwith
* TxtEdtIndic  medico
* TxteditEvol ingresado ahora
* TxtEdtEvol  anterior

Local loHtml As loHtml Of c:\desaguemes\prg\prg_html.prg
loHtml = Newobject("loHtml","c:\desaguemes\prg\prg_html.prg")

With mopage2.PgEvol.pgevold
	mEIM_codmed = mwkmedicoint.Id
	mEIM_evol =.txteditEvol.Value
	If Len(Alltrim(mEIM_evol))>4
		mEIM_evol = Iif(mwkpacint1.pac_categoria="A"," - PACIENTE CON AISLAMIENTO - ","")+mEIM_evol
	Endif
	mEIM_evolDia = Alltrim(mEIM_evol)

	If mlalertacovid
		mm= "NORMATIVA VIGENTE"+Chr(13)+"En virtud de la Emergencia Sanitaria dictada con motivo de la pandemia "+;
			"mundial por COVID 19, y conforme las pautas definidas por los "+;
			"Ministerios de Salud de la Nación y de la Ciudad Autónoma de Buenos "+;
			"Aires , y a fin de evitar la posibilidad de transmisión del virus a través del "+;
			"papel utilizado en la atencion de los pacientes que ingresan con "+;
			"sospecha de COVID, amparados además en leyes que penan todas "+;
			"aquellas acciones que puedan poner en peligro la Salud Pública, la "+;
			"Institución ha decidido que mientras dure la Emergencia Sanitaria todos "+;
			"los consentimientos informados y cualquier otra manifestación de "+;
			"voluntad de los pacientes internados serán otorgados de manera verbal. El profesional deberá dejar "+;
			"registro de dicho acto en la HCE al momento de ser expresada la "+;
			"voluntad del paciente ."
		mret = SQLExec(mcon1, "insert into tabintevolMed " + ;
			"(EIM_codmed,EIM_evol,EIM_fechaH,EIM_idevol)"+;
			" values "+;
			" (?mEIM_codmed, ?mm, ?mfechahora,?midevol  )" )

		If mret < 0
			Messagebox("ERROR EN LA ACTUALIZACION"+Chr(10)+;
				"AVISE A SISTEMAS",16, "ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			lgrabobien = .F.
		Endif
	Endif
	mopc= .Optingreso.Value
	If mopc>0
		mmcaption = ".Optingreso.option"+Transform(mopc,"9")+".Caption"
		mm = &mmcaption
		mret = SQLExec(mcon1, "insert into tabintevolMed " + ;
			"(EIM_codmed,EIM_evol,EIM_fechaH,EIM_idevol)"+;
			" values "+;
			" (?mEIM_codmed, ?mm, ?mfechahora,?midevol  )" )

		If mret < 0
			Messagebox("ERROR EN LA ACTUALIZACION"+Chr(10)+;
				"AVISE A SISTEMAS",16, "ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			lgrabobien = .F.
		Endif
	Endif
	With .pgevolApa
		With .Page1
			mevolm  = ''
			mEIM_NSconciencia = mwkEDConciencia.Id
			mEIM_NSfocalizado = (.optfocal.Value= 1)
			mNSfocalizado = .optfocal.Value
			mEIM_NStipofocalizado = .txtfocal.Value
			mEIM_NSpupilas = mwkANPupilas.Id
			mevolma =  ''
			mevolma = Iif(!Empty(mwkEDConciencia.Descrip), 'Conciencia:' + mwkEDConciencia.Descrip,'')
			If mNSfocalizado >0
				mevolma = mevolma + Iif(mNSfocalizado  =1," Focalizado: Si ",Iif(mNSfocalizado  = 2 ," Focalizado: No ",'' ));
					+ Alltrim(mEIM_NStipofocalizado )
			Endif
			If 	!Empty(mwkEDPupilas.Descrip)
				mevolma = mevolma + Iif(mEIM_NSpupilas # 0, 'Pupilas:' + mwkEDPupilas.Descrip,'')+ Chr(10)
			Endif
			mEIM_NSGmot = .txtgmot.Value
			mEIM_NSGocu = .txtgocu.Value
			mEIM_NSGver = .txtgver.Value
			mEIM_NSreflejoOC = (.optreflexoc.Value = 1)
			mNSreflejoOC = .optreflexoc.Value
			mEIM_NSsignosMen = (.optsgnmenin.Value =1)
			mNSsignosMen = .optsgnmenin.Value
			mevolma =  mevolma + Iif(!Empty(mevolma),Chr(10),'')
			mevolma2 =  Iif(mNSreflejoOC   =1," R.Oculocefálicos: Si ",Iif(mNSreflejoOC   = 2," R.Oculocefálicos: No ",'' ));
				+Iif(mNSsignosMen  =1," Signos Meníngeos: Si ",Iif(mNSsignosMen  = 2," Signos Meníngeos: No ",'' ));
				+Iif(.txtglas1.Value=0,'', Chr(10)+' Glasgow:'+ Transf(.txtglas1.Value,'99')+ '/15';
				+ " Verbal:"+Transf(mEIM_NSGver ,'99') + " Ocular:"+Transf(mEIM_NSGocu ,'99') + " Motor:"+Transf(mEIM_NSGmot ,'99'))
			mevolma =  mevolma+Iif(!Empty(mevolma2),Chr(10)+mevolma2 + Chr(10),'')

			mEIM_NStrastornos = .txttrastornos.Value
			mevolma2 = Iif(!Empty(mEIM_NStrastornos), "Trastornos Psiquiátricos:"+ Alltrim(mEIM_NStrastornos),'')
			mevolma =  mevolma+Iif(!Empty(mevolma2),Chr(10)+mevolma2 + Chr(10),'')
			mEIM_NSpic = (.optPIC.Value=1)
			mvalorpic = 0
			mdiaspic = 0
			mpic = .optPIC.Value
			If .optPIC.Value = 1
				mfecinipic = .txtpicfini.Value
				mvalorpic = .txtpic.Value
				mdiaspic = .txtdiaspic.Value
			Endif
			sipic = (.optPIC.Value =1 And mvalorpic >0)
			If mlcambiopic
				mevolma =  mevolma +Iif(.optPIC.Value =1," PIC: Si ",Iif(.optPIC.Value = 2," PIC: No ",'' )) ;
					+ Iif(.optPIC.Value =1, Iif(mvalorpic <>0," Valor: "+Transf(mvalorpic ,'999')+"mm hg",'' ) ;
					+" Desde:"+Dtoc(mfecinipic )+ "Días:"+Transf(mdiaspic ,'999')+Chr(10),'')
			Endif
			mevolm = Iif(!Empty(mevolma),Chr(10) + ' Neurológico' + Chr(10) + mevolma,'')
			If !Empty(mevolma)
				loHtml.AddHTMLInt(1, mevolma)
			Endif
		Endwith

		With .Page2
			mEIM_RtipoResp  = .txttiporesp.Value
			mevolma =  Iif(!Empty(mEIM_RtipoResp),'Tipo y Frec.Resp.:'+Alltrim(mEIM_RtipoResp)+Chr(10),'')
			mEIM_Ralteraciones  = .txtaltera.Value
			mevolma =  mevolma +Iif(!Empty(mEIM_Ralteraciones),'Alteraciones semiológicas toracopulmonares:'+Alltrim(mEIM_Ralteraciones  )+Chr(10),'')
			mEIM_Rmascarao2  = (.optmascO2.Value = 1 )
			mRmascarao2  = .optmascO2.Value
			mEIM_Rcanula  = (.OptCanula.Value = 1 )
			mevolma2 = Iif(mRmascarao2 =1," Máscara O2: Si ",Iif(mRmascarao2    = 2," Máscara O2: No ",'' ));
				+Iif(.OptCanula.Value =1," Cánula: Si ",Iif(.OptCanula.Value = 2," Cánula: No ",'' ))
			mevolma = mevolma + mevolma2
			mtuboot = .opttuboot.Value
			mtotfini  = .txtfecinitubo.Value
			mtotdias  = .txtdiastubo.Value
			mevolma2 =  ''
			If mlcambiotot
				mevolma2 =  Iif(mtuboot =1,Chr(10)+ " Tubo Orotraqueal: Si ",Iif(mtuboot = 2,Chr(10)+ " Tubo Orotraqueal: No ",'' ));
					+Iif(mtuboot =1," Desde:"+Dtoc(mtotfini)+ "Días:"+Transf(mtotdias,'999'),'' )
				mevolma = mevolma + mevolma2
			Endif
			mtraq = .opttraq.Value
			mtraqfini = .txttraqfini.Value
			mtraqdias  = .txttraqdias.Value
			mevolma2 =  ''
			If mlcambiotraq
				mevolma2 =  Iif(mtraq =1,Chr(10)+ " Traqueostomía: Si ",Iif(mtraq = 2,Chr(10)+ " Traqueostomía: No ",'' ));
					+Iif(mtraq =1," Desde:"+Dtoc(mtraqfini )+ "Días:"+Transf(mtraqdias  ,'999'),'' )
				mevolma = mevolma + mevolma2
			Endif
			mEIM_RdrenPleu  = (.optdrenpleu.Value = 1)
			mRdrenPleu  = .optdrenpleu.Value
			mEIM_Rdrender  = .chkder.Value
			mEIM_Rdrenizq  = .chkizq.Value
			mEIM_Roscila  = (.optoscila.Value =1 )
			mRoscila  = .optoscila.Value
			mEIM_Rburbujea  = (.optburbuja.Value = 1 )
			mRburbujea  = .optburbuja.Value
			mEIM_Rdebito  = (.optdebito.Value = 1)
			mRdebito  = .optdebito.Value
			mEIM_RdebTipo  = .txttipodeb.Value
			mDPfini = .txtDPfini.Value
			mDPdias  = .txtDPdias.Value
			mevolma2 =  ''
			If mlcambiodp
				mevolma2 =  Iif(mRdrenPleu  =1,Chr(10)+ " Drenaje pleural: Si ",Iif(mRdrenPleu  = 2,Chr(10)+ " Drenaje pleural: No ",'' ));
					+Iif(mEIM_Rdrender=1 ," Derecho ",'')+ Iif(mEIM_Rdrenizq=1 ," Izquierdo ",'' );
					+Iif(mRoscila  =1," Oscila: Si ",Iif(mRoscila  = 2," Oscila: No ",'' ));
					+Iif(mRburbujea    =1," Burbujea: Si ",Iif(mRburbujea    = 2," Burbujea: No ",'' ));
					+Iif(mRdebito    =1," Débito: Si ",Iif(mRdebito    = 2," Débito: No ",'' ));
					+Iif(mRdebito    =1," Tipo Débito: "+Alltrim(mEIM_RdebTipo),'' )
				mevolma = mevolma + mevolma2
			Endif
			mEIM_RfrecResp  = .txtfr.Value
			mEIM_Rpeep  = .txtARMpeep.Value
			mEIM_Rppico = .txtppico.Value
			mEIM_RsatO2  = .txtsato2.Value
			mEIM_Rvt  = .txtARMvt.Value
			marmmodo = mwkARMModo.Id
			marmcomp = mwkARMCompl.Id
			marmmot = mwkARMMot.Id
			marmfini = .txtARMfini.Value
			marmpeep = .optpeep.Value
			mARMdias  = .txtARMdias.Value
			mevolma2 =  ''
			moptarm = .optARM.Value
			siarm = (.optARM.Value=1 And !Empty(mwkARMModo.Descrip))
			sivni = (.optARM.Value=2 And !Empty(mwkARMModo.Descrip))
			mEIM_RARM  = (siarm Or sivni )
			If mlcbioARM
				mevolma2 =  Iif(siarm,Chr(10)+ " ARM: Si ",Iif(sivni,Chr(10)+ " VNI: Si " ,Iif(.optARM.Value= 2,Chr(10)+ " ARM/VNI: No ",'' )));
					+Iif(siarm Or sivni,"  Modo: "+mwkARMModo.Descrip;
					+" Desde:"+Dtoc(marmfini )+ "Días:"+Transf(mARMdias ,'999');
					+ Iif(mEIM_Rpeep>0, " PEEP:"+Transform (mEIM_Rpeep  ,'9999')+"cm H2O",'' );
					+" Motivo:" +mwkARMMot.Descrip,'') +Iif(!Empty(mevolma),Chr(10),'')
				mevolma = mevolma + mevolma2
				mevolma2 =  ''
				mevolma2 =  Iif(siarm Or sivni,Chr(10)+ Iif(mEIM_Rvt  >0,"  VT: "+Transform (mEIM_Rvt,'999')+"ml/Kg",'');
					+Iif(mEIM_RfrecResp>0,"  FR: "+Transform (mEIM_RfrecResp,'999')+"P/min",'');
					+Iif(mEIM_RsatO2>0,"  Sat O2: "+Transform (mEIM_RsatO2,'999')+"%",'');
					+Iif(mEIM_Rppico>0,"  P.Pico: "+Transform (mEIM_Rppico,'999')+"cm H2O",'');
					+Iif(!Empty(mwkARMCompl.Descrip)," Complicaciones:" +mwkARMCompl.Descrip,'') +Chr(10),'')
				mevolma = mevolma + mevolma2
			Endif
			mevolm = mevolm +Iif(!Empty(mevolma),Chr(10) + ' Aparato Respiratorio' + Chr(10) + mevolma,'')
			If !Empty(mevolma)
				loHtml.AddHTMLInt(2, mevolma)
			Endif

		Endwith

		With .Page3
			mEIM_CVtipoPulso = .txttipopulso.Value
			mEIM_CVPVC = .txtpvc.Value
			mEIM_CVtension = .TxtTaSist.Value
			mEIM_CVtensiond = .TxtTaDia.Value
			mevolma =  ''
			mevolma =  Iif(!Empty(mEIM_CVtipoPulso ),'Frec. y caract. del pulso:'+Alltrim(mEIM_CVtipoPulso )+" P/min",'');
				+Iif(mEIM_CVtension >0,"  TA "+Transform (mEIM_CVtension ,'999')+"/"+;
				transform (mEIM_CVtensiond ,'999')+" mm Hg ",'');
				+Iif(mEIM_CVPVC >0,"  PVC"+Transform (mEIM_CVPVC ,'999')+" cm H2O",'')+Iif(!Empty(mevolma),Chr(10),'')
			mEIM_CValteraciones = .txtaltera.Value
			mevolma = mevolma + Iif(!Empty(mEIM_CValteraciones ),Chr(10)+'Alteraciones semiológicas cardiovasculares:'+Alltrim(mEIM_CValteraciones ) ,'')
			mEIM_CVpulsosPer  = (.optpperif.Value = 1)
			mCVpulsosPer  = .optpperif.Value
			mEIM_CVedemas = (.optedemas.Value = 1)
			mCVedemas = .optedemas.Value
			mevolma2 =  ''
			mevolma2 =  Iif(mCVpulsosPer    =1," Pulsos periféricos: Iguales ",Iif(mCVpulsosPer    = 2," Pulsos periféricos: Simétricos ",'' ));
				+Iif(mCVedemas  =1," Edemas: Si ",Iif(mCVedemas  = 2," Edemas: No ",'' ))
			mevolma = mevolma + Iif(!Empty(mevolma2),Chr(10),'')+mevolma2


			mvevp =.optvevp.Value
			mvevpfini = .txtvevpfini.Value
			mvevpffin = Iif(Empty(.txtvevpffin.Value) Or .txtvevpffin.Value=Ctod("  /  /  "),mfecfin,.txtvevpffin.Value)
			mvevdias =	.txtvevpdias.Value
			mvevpacc = mwkEVPModo.Id
			mvevpcomp = mwkEVPCompl.Id

			mevolma2 =  ''
			sivevp = (mvevp = 1 And !Empty(mwkEVPModo.Descrip))
			If mlcambioevp
				Do Case
					Case sivevp
						mevolma2 = Chr(10)+' Vías EV Perifer. desde:'+Transform(mvevpfini )+" Días:"+Transf(mvevdias ,'999')+" Con acceso:"+mwkEVPModo.Descrip+ ;
							iif(!Empty(mwkEVPCompl.Descrip), " Complicaciones: "+mwkEVPCompl.Descrip,'')
					Case mvevp = 2
						mevolma2 = Iif(Empty(mwkEVPModo.Descrip),Chr(10)+' Vías EV Perifer. NO',' Vías EV Perifer. desde:'+;
							transform(mvevpfini )+' hasta:'+Transform(mvevpffin )+" Días:"+Transf(mvevdias ,'999')+" Con acceso:"+mwkEVPModo.Descrip+ ;
							iif(!Empty(mwkEVPCompl.Descrip), " Complicaciones: "+mwkEVPCompl.Descrip,'') )
				Endcase
				mevolma = mevolma + mevolma2
			Endif
			mvcacc = mwkEVCModo.Id
			mvccomp = mwkEVCCompl.Id
			mvcdias =	.txtvcdias.Value
			mvc = .optvia.Value
			mvcfini = .txtVCfini.Value
			mvcffin = Iif(Empty(.txtVCffin.Value) Or .txtVCffin.Value=Ctod("  /  /  "),mfecfin,.txtVCffin.Value)
			mevolma2 =  ''
			sivc = (mvc = 1 And !Empty(mwkEVCModo.Descrip))
			If mlcambioevc
				Do Case
					Case sivc
						mevolma2 = Chr(10)+' Vías EV Central desde:'+Transform(mvcfini )+" Días:"+Transf(mvcdias ,'999')+" Con acceso:"+mwkEVCModo.Descrip+ ;
							iif(!Empty(mwkEVCCompl.Descrip), " Complicaciones: "+mwkEVCCompl.Descrip,'')
					Case mvc = 2
						mevolma2 = Iif(Empty(mwkEVCModo.Descrip), Chr(10)+' Vías EV Central NO ',' Vías EV Central desde:'+;
							transform(mvcfini )+' hasta:'+Transform(mvcffin )+" Días:"+Transf(mvcdias ,'999')+" Con acceso:"+mwkEVCModo.Descrip+ ;
							iif(!Empty(mwkEVCCompl.Descrip), " Complicaciones: "+mwkEVCCompl.Descrip,''))
				Endcase
				mevolma = mevolma + mevolma2
			Endif
			mcartacc = mwkCARTModo.Id
			mcartcom = mwkCARTCompl.Id
			mcart = .optcart.Value
			mcartfini = .txtcartfini.Value
			mcartdias =	.txtcartdias.Value
			mcartffin = Iif(Empty(.txtcartffin.Value) Or .txtcartffin.Value=Ctod("  /  /  "),mfecfin,.txtcartffin.Value)
			mevolma2 =  ''
			sicart = (mcart = 1 And !Empty(mwkCARTModo.Descrip))
			If mlcambiocart
				Do Case
					Case sicart
						mevolma2 = Chr(10)+' Cat.Arterial desde:'+Transform(mcartfini )+" Días:"+Transf(mcartdias ,'999')+" Con acceso:"+mwkCARTModo.Descrip+ ;
							iif(!Empty(mwkCARTCompl.Descrip), " Complicaciones: "+mwkCARTCompl.Descrip,'')
					Case mcart = 2
						mevolma2 = Iif(Empty(mwkCARTModo.Descrip), Chr(10)+' Cat.Arterial NO ', ' Cat.Arterial desde:'+Transform(mcartfini )+' hasta:'+Transform(mcartffin )+;
							" Días:"+Transf(mcartdias ,'999')+" Con acceso:"+mwkCARTModo.Descrip+ ;
							iif(!Empty(mwkCARTCompl.Descrip), " Complicaciones: "+mwkCARTCompl.Descrip,''))
				Endcase
				mevolma = mevolma + mevolma2
			Endif
			mcsg = .optcsg.Value
			mcsgfini = .txtcsgfini.Value
			mcsgdias =	.txtcsgdias.Value
			mcsgffin = Iif(Empty(.txtcsgffin.Value) Or .txtcsgffin.Value=Ctod("  /  /  "),mfecfin,.txtcsgffin.Value)
			mcsgacc = mwkCSGModo.Id
			mcsgcomp = mwkCSGCompl.Id
			mevolma2 =  ''
			sicsg = (mcsg = 1 And !Empty(mwkCSGModo.Descrip))
			If mlcambiocsg
				Do Case
					Case sicsg
						mevolma2 =  Chr(10) +' Cateter S.Ganz desde:'+Transform(mcsgfini )+" Días:"+Transf(mcsgdias ,'999')+" Con acceso:"+mwkCSGModo.Descrip+ ;
							iif(!Empty(mwkCSGCompl.Descrip), " Complicaciones: "+mwkCSGCompl.Descrip,'')
					Case mcsg = 2
						mevolma2 = Iif(Empty(mwkCSGModo.Descrip), Chr(10) +' Cateter S.Ganz NO ',  ' Cateter S.Ganz desde:'+Transform(mcsgfini )+' hasta:'+Transform(mcsgffin )+;
							" Días:"+Transf(mcsgdias ,'999')+" Con acceso:"+mwkCSGModo.Descrip+ ;
							iif(!Empty(mwkCSGCompl.Descrip), " Complicaciones: "+mwkCSGCompl.Descrip,'') )
				Endcase
				mevolma = mevolma + mevolma2
			Endif
			mevolm = mevolm +Iif(!Empty(mevolma),Chr(10) +' Aparato Cardiovascular' + Chr(10) + mevolma,'')

			If !Empty(mevolma)
				loHtml.AddHTMLInt(3, mevolma)
			Endif



		Endwith


		With .Page4

			mEIM_GAalteraciones = .txtaltera.Value
			mevolma =  ''
			mevolma = Iif(!Empty(mEIM_GAalteraciones), 'Alteraciones semiológicas abdominales:'+Alltrim(mEIM_GAalteraciones),'')
			mEIM_GARHA = (.optRha.Value = 1)
			mGARHA = .optRha.Value
			mEIM_GAvomito = (.optVom.Value = 1)
			mGAvomito = .optVom.Value
			mEIM_GAcatar = (.optcatar.Value = 1)
			mGAcatar = .optcatar.Value
			mEIM_GAdolor = (.optdolor.Value = 1)
			mGAdolor = .optdolor.Value
			mevolma2 =  ''
			mevolma2 =  Iif(mGARHA =1," RHA: (+) ",Iif(mGARHA = 2," RHA: (-) ",'' ));
				+Iif(mGAvomito =1," Vómitos: Si ",Iif(mGAvomito = 2," Vómitos: No ",'' ));
				+Iif(mGAcatar =1," Catarsis: (+) ",Iif(mGAcatar = 2," Catarsis: (-) ",'' ));
				+Iif(mGAdolor =1," Dolor: Si ",Iif(mGAdolor = 2," Dolor: No ",'' ))

			mevolma = mevolma + Iif(!Empty(mevolma2),Chr(10),'')+ mevolma2

			mEIM_GAherCX = (.optherida.Value = 1)
			mGAherCX = .optherida.Value
			mEIM_GAdren = (.optdrenaje.Value = 1 )
			mGAdren  = .optdrenaje.Value
			mEIM_GAdrenDeb = .txtdren.Value
			mEIM_GAdrenTipo = .txtdrentipo.Value
			mevolma2 =  ''
			mevolma2 =  Iif(mGAdren  =1," Drenaje: Si ",Iif(mGAdren  = 2," Drenaje: No ",'' ));
				+Iif(mGAdren  =1," Débito :"+Transform(mEIM_GAdrenDeb ,'999.99')+ " Tipo:"+Alltrim(mEIM_GAdrenTipo ),'' )
			mevolma = mevolma + Iif(!Empty(mevolma2),Chr(10),'')+mevolma2

			mEIM_GAestadoCX =  .OptestHerida.Value
			mecx = mEIM_GAestadoCX
			mEIM_GAcrepita = (.optcrepita.Value = 1)
			mGAcrepita = .optcrepita.Value
			mevolma2 =  ''
			mevolma2 =  Iif(mGAherCX  =1," Heridas quirúrgicas: Si ",Iif(mGAherCX  = 2," Heridas quirúrgicas: No ",'' ))+;
				iif(mecx =1," Limpia ",Iif(mecx = 2," Supuración ",Iif(mecx = 3," Flogosis ",Iif(mecx = 4," Necrosis ",'' )) ));
				+Iif(.optcrepita.Value =1," Con crepitación ",'' )
			mevolma = mevolma + Iif(!Empty(mevolma2),Chr(10),'')+ mevolma2

			mEIM_GAotrasLes = .txtotrasles.Value
			mevolma = mevolma + Iif(!Empty(mEIM_GAotrasLes ),Chr(10)+ 'Otras lesiones:'+Alltrim(mEIM_GAotrasLes ),'')

			mEIM_ALingreso = .txtingre.Value
			mEIM_ALdiuresis = .txtdiuresis.Value
			mEIM_ALbalance = .txtbalance.Value
			mevolma2 =  ''
			mevolma2 =  Iif(!Empty(mEIM_ALingreso )," Ingreso fluídos 24 hs :"+ Alltrim(Transform(mEIM_ALingreso ))+ 'ml','' );
				+Iif(!Empty(mEIM_ALdiuresis )," Diuresis 24 hs:"+Alltrim(Transform(mEIM_ALdiuresis ))+ 'ml','' );
				+Iif(!Empty(mEIM_ALbalance )," Balance 24 hs:"+Alltrim(Transform(mEIM_ALbalance ))+ 'ml','' )

			mevolma = mevolma +Iif(!Empty(mevolma2),Chr(10),'')+mevolma2

			mEIM_ALsonda = (.optsves.Value = 1 )
			msves = .optsves.Value
			msvesfini = .txtsvesfini.Value
			msvesdias =	.txtsvesdias.Value
			mSVESacc =	mwksvesmodo.Id
			mevolma2 =  ''
			sisves = (msves = 1 And !Empty(mwksvesmodo.Descrip))
			If mlcambiosves
				Do Case
					Case sisves
						mevolma2 = Chr(10)+'  Sonda vesical desde:'+Transform(msvesfini )+" Días:"+Transf(msvesdias ,'999')+" Con acceso:"+mwksvesmodo.Descrip
					Case msves = 2
						mevolma2 = Iif(Empty(mwksvesmodo.Descrip), Chr(10)+' Sonda vesical NO ',  ' Sonda vesical desde:'+Transform(msvesfini )+' hasta:'+Transform(mfechadia)+;
							" Días:"+Transf(msvesdias ,'999')+" Con acceso:"+mwksvesmodo.Descrip)
				Endcase
				mevolma = mevolma + mevolma2
			Endif
			mevolma2 = ''
			mGAsng = .optsng.Value
			mEIM_GAsngDeb = .txtsngdeb.Value
			mEIM_GAsngTipo = .txtsngtipo.Value
			mSNG = .optsng.Value
			mEIM_GAsng = (.optsng.Value = 1)
			mSNGfini = .txtSNGfini.Value
			mSNGdias =	.txtSNGdias.Value
			mSNGacc =	mwksngmodo.Id
			mevolma2 =  ''
			sisng = (mSNG = 1 And !Empty(mwksngmodo.Descrip))
			If mlcambiosng
				Do Case
					Case sisng
						mevolma2 = Chr(10)+'  Sonda Nasogastrica desde:'+Transform(mSNGfini )+" Días:"+Transf(mSNGdias ,'999')+" Con acceso:"+;
							mwksngmodo.Descrip+Iif(mEIM_GAsngDeb>0," Débito :"+Transform(mEIM_GAsngDeb,'999.99'),'')+ ;
							iif(!Empty(mEIM_GAsngTipo )," Tipo:"+Alltrim(mEIM_GAsngTipo ),'' )
					Case mSNG = 2
						mevolma2 = Iif(Empty(mwksngmodo.Descrip), Chr(10)+' Sonda Nasogastrica NO ',  ' Sonda Nasogastrica desde:'+Transform(mSNGfini )+' hasta:'+Transform(mfechadia)+;
							" Días:"+Transf(mSNGdias ,'999')+" Con acceso:"+mwksngmodo.Descrip)
				Endcase
				mevolma = mevolma + Iif(!Empty(mevolma2),Chr(10),'')+ mevolma2
			Endif
			mEIM_ALdialisis = (.optdial.Value = 1)
			mALdialisis = .optdial.Value
			mEIM_ALdialPer = .txtdialper.Value
			mEIM_ALhemodia = .txthemodial.Value
			mEIM_GAtipoHD =  .opttipoHD.Value
			mEIM_ALsonda = (.optdial.Value = 1 )
			mdialtipo = mEIM_GAtipoHD
			mdial = .optdial.Value
			mdialfini = .txtHDfini.Value
			mdialdias =	.txtHDdias.Value
			mdialffin = Iif(Empty(.txtHDffin.Value) Or .txtHDffin.Value=Ctod("  /  /  "),mfecfin,.txtHDffin.Value)
			mdialacc = mwkHDcModo.Id
			mdialcomp = mwkHDcCompl.Id
			mHDfini = .txtHDfini.Value
			mHDdias =	.txtHDdias.Value
			mevolma2 =  ''
			If mlcambiodia
				mevolma2 =  Iif(mALdialisis =1," Diálisis: Si ",Iif(mALdialisis = 2," Diálisis: No ",'' ));
					+Iif(!Empty(mEIM_ALhemodia ), " Hemodiálisis: "+Alltrim(mEIM_ALhemodia ),'') ;
					+Iif(!Empty(mEIM_ALdialPer ), " Diálisis peritoneal: "+Alltrim(mEIM_ALdialPer ),'')


				mevolma = mevolma +Iif(!Empty(mevolma2),Chr(10),'') + mevolma2
			Endif
			mevolma2 =  ''
			sihd = (mALdialisis = 1 And !Empty(mwkHDcModo.Descrip))
			If mlcambiodia
				Do Case
					Case sihd
						mevolma2 = ' Dialisis Tipo :'+Iif(mEIM_GAtipoHD =1,.opttipoHD.option1.Caption, ;
							iif(mEIM_GAtipoHD =2,.opttipoHD.option2.Caption, ''))+;
							" Desde: "+ Transform(mHDfini )+" Días:"+Transf(msvesdias ,'999')+" Con acceso:"+mwkHDcModo.Descrip+ ;
							iif(!Empty(mwkHDcCompl.Descrip), " Complicaciones: "+mwkHDcCompl.Descrip,'')
					Case mALdialisis = 2
						mevolma2 = Iif(mEIM_GAtipoHD =0,' Dialisis  NO ', ' Dialisis Tipo :'+Iif(mEIM_GAtipoHD =1,.opttipoHD.option1.Caption, ;
							iif(mEIM_GAtipoHD =2,.opttipoHD.option2.Caption, ''))+;
							' Desde:'+Transform(mHDfini )+' hasta:'+Transform(mfechadia)+" Días:"+Transf(mHDdias ,'999'))+" Con acceso:"+mwkHDcModo.Descrip+ ;
							iif(!Empty(mwkHDcCompl.Descrip), " Complicaciones: "+mwkHDcCompl.Descrip,'')
				Endcase
				mevolma = mevolma+Iif(!Empty(mevolma2),Chr(10),'') + mevolma2
			Endif
			mevolm = mevolm +Iif(!Empty(mevolma),Chr(10)+' Ap.Genito Urinario - Abdomen' + Chr(10) + mevolma,'')

			If !Empty(mevolma)
				loHtml.AddHTMLInt(4, mevolma)
			Endif

		Endwith
		With .Page6
			Select * From mwkatbesquema Into Cursor mwkctresq
			mEIM_CATB = (Reccount('mwkctresq')>0)
			mCATB = Iif(Reccount('mwkctresq')>0,1,2)
			mEIM_Cdias = 0
			mEIM_Ccultivo = .TxtEd_ed_cultivo.Value
			mEIM_Cesquema =''
			mevolma =  ''
			If mlmodifatb
				Select mwkatbesquema
				miesquema = ''
				Scan
					If Id>40
						midesq = Id
						If EATB_fechafin>=Ttod(mwkfecserv.fechahora)-1  And EATB_fechafin<mfecfin   && dar de baja
						Else
							miesquema  = miesquema +Alltrim(EATB_esquema)+" D:"+Dtoc(EATB_fechaini)+"/"
						Endif
					Else
						If EATB_fechafin = mfecfin
							miesquema  = miesquema +Alltrim(EATB_esquema)+" D:"+Dtoc(EATB_fechaini)+"/"

						Endif
					Endif
				Endscan
				mEIM_Cesquema = miesquema
				mevolma =  Iif(mCATB =1," ATB: Si ",Iif(mCATB = 2," ATB: No ",'' ))+;
					iif(mCATB >0," Esquema ATB: "+Alltrim(miesquema )+ Chr(10) + " Cultivo:"+ Alltrim(mEIM_Ccultivo )+Chr(10),'')
				mevolm = mevolm +Iif(!Empty(mevolma2),Chr(10),'')+ mevolma
			Endif
* VER
			mevolma2 = ''
		Endwith
	Endwith
Endwith
mEI_scrapacheii = 0
mEI_scrsofa = 0
mEI_scrranson = 0
mEI_scrhyh	= 0
mEI_scrfisher = 0

If mlmodifscore
	With mopage4.pgcontrol.pgCSVMed
		With .Scores_med1.Pgscore
			mEI_scrapacheii = .Page1.txtpuntos.Value
			mEI_scrsofa = .Page2.txtpuntos.Value
			mEI_scrranson = .Page3.optdato.Value
			mEI_scrhyh	= .Page4.Opt1.Value
			mEI_scrfisher = .PAGE5.Opt1.Value
		Endwith
	Endwith
Endif


If mlmodifkine
*!*		with mopage2.PgEvol.PgEvolKine.Cntkinesio
*!*			mevolm = mevolm + .TxteditEvol.value  + chr(10)
*!*			if !empty(.TxteditEvol.value)
*!*				loHtml.AddHTMLInt(1, .TxteditEvol.value)
*!*			endif
*!*		endwith
Endif

mEIM_evol = Iif(!Empty(mEIM_evol),"Evolución:"+Chr(10)+Alltrim(mEIM_evol),'')+mevolm

lcAuxDat = Iif(!Empty(mevolma2),Chr(10),'')+ mevolma
lcAuxDat = Iif(!Empty(mEIM_evolDia), mEIM_evolDia + Chr(10) + Chr(10) + lcAuxDat, lcAuxDat)

If !Empty(lcAuxDat)
	loHtml.AddHTMLInt(5, lcAuxDat)
Endif
loHtml.HTMLInt_Merge()
*!* ---------------------------------------------------------------------------


With mopage7.pgindicaciones
	mresumen = .Page4.TxteditResu.Value

	mEIM_indicacion = .Page6.Txteditindic.Value
	mindnurse = ""
	With .Page1

		mEIM_ALalimenta = (.opttiponut.Value=1)
		mALalimenta = .opttiponut.Value
		mEIM_ALtipoNut = mwkNuttipo.Id
		mevolma =  ''
		mevolma =  Iif(mALalimenta =1," Alimentación: Si ",Iif(mALalimenta = 2," Alimentación: No ",'' ));
			+Iif(!Empty(mwkNuttipo.Descrip), " Tipo: "+mwkNuttipo.Descrip,'')

		mEIM_ALcalorias = .txtcalorias.Value
		mEIM_ALtolera = .txttolerancia.Value
		mhora = .txthora.Value
		mEIM_ALfecSusp = Iif(Empty(.txtNutffin.Value) Or .txtNutffin.Value=Ctod("  /  /  ") Or .ChkSusp.Value = 0,mfecfin,.txtNutffin.Value)
		mEIM_ALmotSusp = .txtmotivo.Value
		mevolma2 =  ''
		mlayuno = (.ChkSusp.Value = 1 And .txtNutffin.Enabled)
		mevolma2 = Iif(mEIM_ALcalorias >0 ," Calorías :"+Transform(mEIM_ALcalorias ),'')+ Iif(!Empty(mEIM_ALtolera )," Tolerancia:"+Alltrim(mEIM_ALtolera ),'' );
			+Iif(.ChkSusp.Value = 1,' Fecha de Suspensión.:'+Ttoc(mEIM_ALfecSusp )+' Desde:'+Transform(mhora)+ 'hs Motivo:' +Alltrim(mEIM_ALmotSusp ),'')
		mevolma = mevolma +Iif(!Empty(mevolma2),Chr(10),'')+ mevolma2
		mevolma2 =  ''
		msngi = .optsng.Value
		msngfinii = .txtSNGfini.Value
		msngdiasi =	.txtSNGdias.Value
		msngffini = mfecfin
		mEIM_GAsngi = (.optsng.Value = 1)
		mGAsngi = .optsng.Value
*!*			mEIM_GAsngDebi = 0&&.txtsngdeb.value
*!*			mEIM_GAsngTipoi = ''&&.txtsngtipo.value
		mevolma2 =  ''
		mGAsng = .optsng.Value
		mSNG = .optsng.Value
		mEIM_GAsng = (.optsng.Value = 1)
		mSNGfini = .txtSNGfini.Value
		mSNGdias =	.txtSNGdias.Value
		mSNGacc =	mwkSNGModoNut.Id
		mevolma2 =  ''

		sisngn = (mSNG = 1 And !Empty(mwkSNGModoNut.Descrip))


		If mlcambiosngn
			Do Case
				Case sisngn
					mevolma2 = Chr(10)+'  Sonda Nasogastrica desde:'+Transform(mSNGfini )+" Días:"+Transf(mSNGdias ,'999')+" Con acceso:"+;
						mwkSNGModoNut.Descrip+Iif(mEIM_GAsngDeb>0," Débito :"+Transform(mEIM_GAsngDeb,'999.99'),'')+ ;
						iif(!Empty(mEIM_GAsngTipo )," Tipo:"+Alltrim(mEIM_GAsngTipo ),'' )
				Case mSNG = 2
					mevolma2 = Iif(Empty(mwkSNGModoNut.Descrip), Chr(10)+' Sonda Nasogastrica NO ',  ' Sonda Nasogastrica desde:'+Transform(mSNGfini )+' hasta:'+Transform(mfechadia)+;
						" Días:"+Transf(mSNGdias ,'999')+" Con acceso:"+mwkSNGModoNut.Descrip)
			Endcase

		Endif
		mevolma = mevolma +Iif(!Empty(mevolma2),Chr(10),'')+ mevolma2
		If mlcambiometanut
			mevolma2 =  ''
			With .Cntnutrimeta1
				mmetac = .txtcalorias.Value
				mmetap = .txtProteinas.Value
				mporcmc = .optporcmc.Value
				mporcmp = .optporcmp.Value
				tipomc = .opttipodieta.Value
				If tipomc >0
					mevolma2 = mevolma2 +"Meta Nutricional de "+Iif(tipomc =1,'Mantenimiento','Recuperación ')  +Chr(10)
				Endif
				If mmetac >0
					mevolma2 = mevolma2 +"Meta Calórica:"+Transform(mmetac )+Chr(10)
				Endif
				If mmetap >0
					mevolma2 = mevolma2 +"Meta Proteica:"+Transform(mmetap)+Chr(10)
				Endif
			Endwith
			If mporcmc >0
				mevolma2 = mevolma2 +"Porcentaje alcanzado de la meta calórica:"+porcMC(mporcmc  +1)+Chr(10)
			Endif
			If mporcmp >0
				mevolma2 = mevolma2 +"Porcentaje alcanzado de la meta proteica:"+porcMC(mporcmp +1)+Chr(10)
			Endif
			mevolma = mevolma +Iif(!Empty(mevolma2),Chr(10),'')+ mevolma2
		Endif

		mevolm = mevolm +Iif(!Empty(mevolma),Chr(10)+' Nutrición ' + Chr(10) + mevolma,'')
	Endwith

	With .Page2 &&&sueros
	Endwith
	With .Page3 &&&medicacion
	Endwith

*!*		with .page4&&&estudios
*!*		endwith
	With .PAGE5 &&&cuidados
		mnurse = ''
		mEIM_aislamiento = Alltrim(.cntAisla.txtAislamiento.Value)
		mevolma = mevolma + Iif(!Empty(mEIM_aislamiento),"Aislamiento: "+mEIM_aislamiento+Chr(10),'')
		Select mwknece.valorb ,mwknece.valorf,mwknece.valorc,mwknece.nnc_descrip As cuidado ,mwknece.nnc_padre,;
			mwkfrecuencia.Descrip,mwknecespacorig.nnc_descrip As necesidad ;
			from mwknece Left Join mwkfrecuencia On estado = mwknece.valorf ;
			INNER Join mwknecespacorig On mwknecespacorig.Id = mwknece.nnc_padre;
			where mwknece.valorb <> mwknece.valorbOrig Or mwknece.valorf <> mwknece.valorfOrig ;
			or Alltrim(mwknece.valorc) <> Alltrim(mwknece.valorcOrig);
			into Cursor mwknecepac
		Select mwknecepac
		mnurse = mnurse + Iif(Reccount('mwknecepac')>0 ,'NECESIDADES Y CUIDADOS ' + Chr(10) ,'')
		mpadre = 0
		Scan
			If mpadre #nnc_padre
				mnurse = mnurse + '---- ' + mwknecepac.necesidad + Chr(10)
				mpadre = mwknecepac.nnc_padre
			Endif
			mnurse = mnurse +Alltrim(cuidado )+" - "+ Iif(valorb , "SI","NO")+ ;
				iif(!Empty(Descrip)," Frecuencia: "+Alltrim(Descrip),'')+ Iif(!Empty(valorc)," Observ.: "+ Alltrim(valorc),'')+Chr(10)
		Endscan
		mindnurse = mindnurse + mnurse + Iif(Reccount('mwknecepac')>0 ,'- - - - - ' + Chr(10) ,'')
	Endwith
	With .Page6 &&&akr
*!*			with .Amoverlistas1.Lista2
*!*				mcadprest = 'inlist (id'
*!*				if .listcount>0
*!*					mindnurse = mindnurse + "Asistencia Kinesica y respiratoria:"+chr(10)
*!*					for ip = 1 to .listcount
*!*						mindnurse = mindnurse + alltrim(.list(ip,1))+chr(10)
*!*						mcadprest = mcadprest +","+.list(ip,2)
*!*					next ip
*!*					mcadprest =mcadprest +")"
*!*					select * from mwkindCCDisp where &mcadprest into cursor mwkindCCind
*!*	*					do sp_grabo_evol_int_nut  with midevol,alltrim(.TxtedIMAnt.value)
*!*				endif
*!*			endwith
	Endwith
	mindnurse  = Iif(!Empty(Alltrim(mindnurse )), Ttoc(mfechahora ) + ' ' +;
		iif(Used('mwkusuarios'),Alltrim(mwkusuarios.idusuario) ,Transf(mmedico))+ '->', '') + ;
		alltrim(mindnurse)  &&alltrim(.txteditevol.value) +

Endwith


miedit = Alltrim(mindnurse )
mevolnurse 	= ''


mret = SQLExec(mcon1, "SELECT * FROM TabIntEvol " + ;
	" where  EI_idevol = ?midevol ", "mwkVerEvol")
If mret < 0
	=Aerr(eros)
	Messagebox(eros(3), 48, "Validacion")
	lgrabobien = .F.
Endif
mevolnurse = Nvl(EI_evolnurse,'')
If Reccount('mwkVerEvol')= 0
	mret = SQLExec(mcon1, "insert into tabintevol " + ;
		" ( EI_fechaHora,EI_idevol,EI_indicNurse,EI_scrapacheii,EI_scrfisher,EI_scrhyh "+;
		",EI_scrranson,EI_scrsofa,EI_usuario)"+;
		" values "+;
		" (?mfechahora, ?midevol,?miedit, ?mEI_scrapacheii , ?mEI_scrfisher , ?mEI_scrhyh,"+;
		" ?mEI_scrranson ,?mEI_scrsofa ,?midusuario )" )

	If mret < 0
		Messagebox("ERROR EN EL INGRESO"+Chr(10)+;
			"AVISE A SISTEMAS",16, "ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		lgrabobien = .F.

	Endif
Else
	mscore = ''
	If mlmodifscore1
		mscore = ',EI_scrapacheii = ?mEI_scrapacheii '
	Endif
	If mlmodifscore2
		mscore = ',EI_scrsofa= ?mEI_scrsofa '
	Endif
	If mlmodifscore3
		mscore = ',EI_scrranson =?mEI_scrranson '
	Endif
	If mlmodifscore4
		mscore = ',EI_scrhyh = ?mEI_scrhyh '
	Endif
	If mlmodifscore5
		mscore = ',EI_scrfisher = ?mEI_scrfisher '
	Endif
	midintevol = mwkVerEvol.Id
	mevolnursea = Nvl(EI_evolnurse,'')
	mevolnursett = Nvl(EI_evolnurse,'') &&+ iif(empty(nvl(EI_evolnurse,'')),'',chr(10))+  alltrim(msoloevol)
	mindictt = Nvl(EI_indicNurse,'') + Iif(Empty(Nvl(EI_indicNurse,'')),'',Chr(10))+ Alltrim(miedit)
	mret = SQLExec(mcon1, "update tabintevol " + ;
		" set  EI_evolnurse = ?mevolnursett ,EI_fechaHora = ?mfechahora,EI_indicNurse = ?mindictt "+;
		mscore +;
		",EI_usuario = ?midusuario  where id = ?midintevol " )
	If mret < 0
		Messagebox("ERROR EN LA ACTUALIZACION"+Chr(10)+;
			"AVISE A SISTEMAS",16, "ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Endif

Endif
mEIM_GAbuenest =  .F.
mEIM_GAflog = .F.
mEIM_GAnecrosis = .F.
mEIM_GAsupura = .F.
mEIM_Rtoraco = .F.
If  musua = 0
	If mlcambioevol
		If !Empty(mEIM_indicacion)
			sp_grabo_obsenf(midevol, 4, Alltrim(mEIM_indicacion))
		Endif
		If mwkhabimn.estado = 1
			mEIM_indicacion = ''
		Endif
		mret = SQLExec(mcon1, "insert into tabintevolMed " + ;
			"(EIM_ALalimenta,EIM_ALbalance,EIM_ALcalorias,EIM_ALdialisis,EIM_ALdialPer,EIM_ALdiuresis,EIM_ALfecSusp "+;
			",EIM_ALhemodia,EIM_ALingreso,EIM_ALmotSusp,EIM_ALsonda,EIM_ALtipoNut,EIM_ALtolera,EIM_CATB "+;
			",EIM_Ccultivo,EIM_Cdias,EIM_Cesquema,EIM_codmed,EIM_CValteraciones,EIM_CVedemas,EIM_CVpulsosPer "+;
			",EIM_CVPVC,EIM_CVtension,EIM_CVtipoPulso,EIM_evol,EIM_fechaH,EIM_GARHA,EIM_GAbuenest,EIM_GAcatar "+;
			",EIM_GAdren,EIM_GAdrenDeb,EIM_GAdrenTipo,EIM_GAalteraciones,EIM_GAcrepita "+;
			",EIM_GAdolor,EIM_GAflog,EIM_GAherCX,EIM_GAnecrosis,EIM_GAotrasLes,EIM_GAsng,EIM_GAsngDeb "+;
			",EIM_GAsngTipo,EIM_GAsupura,EIM_GAvomito,EIM_idevol,EIM_NSconciencia,EIM_NSfocalizado,EIM_NSGmot "+;
			",EIM_NSGocu,EIM_NSGver,EIM_NSpic,EIM_NSpupilas,EIM_NSreflejoOC,EIM_NSsignosMen,EIM_NStipofocalizado "+;
			",EIM_NStrastornos,EIM_Ralteraciones,EIM_RARM,EIM_Rburbujea,EIM_Rdebito,EIM_RdebTipo,EIM_Rdrender "+;
			",EIM_Rdrenizq,EIM_RdrenPleu,EIM_RfrecResp,EIM_Rmascarao2,EIM_Roscila,EIM_Rpeep,EIM_Rppico "+;
			",EIM_RsatO2,EIM_RtipoResp,EIM_Rtoraco,EIM_Rvt,EIM_CVtensiond ,EIM_Rcanula,EIM_GAtipoHD,EIM_aislamiento, EIM_indicacion   )"+;
			" values "+;
			" (?mEIM_ALalimenta, ?mEIM_ALbalance, ?mEIM_ALcalorias, ?mEIM_ALdialisis, ?mEIM_ALdialPer, ?mEIM_ALdiuresis, ?mEIM_ALfecSusp "+;
			", ?mEIM_ALhemodia, ?mEIM_ALingreso, ?mEIM_ALmotSusp, ?mEIM_ALsonda, ?mEIM_ALtipoNut, ?mEIM_ALtolera, ?mEIM_CATB "+;
			", ?mEIM_Ccultivo, ?mEIM_Cdias, ?mEIM_Cesquema, ?mEIM_codmed, ?mEIM_CValteraciones, ?mEIM_CVedemas, ?mEIM_CVpulsosPer "+;
			", ?mEIM_CVPVC, ?mEIM_CVtension, ?mEIM_CVtipoPulso, ?mEIM_evol, ?mfechahora,?mEIM_GARHA,?mEIM_GAbuenest "+;
			", ?mEIM_GAcatar, ?mEIM_GAdren, ?mEIM_GAdrenDeb, ?mEIM_GAdrenTipo,?mEIM_GAalteraciones, ?mEIM_GAcrepita "+;
			", ?mEIM_GAdolor, ?mEIM_GAflog , ?mEIM_GAherCX, ?mEIM_GAnecrosis, ?mEIM_GAotrasLes, ?mEIM_GAsng, ?mEIM_GAsngDeb "+;
			", ?mEIM_GAsngTipo, ?mEIM_GAsupura, ?mEIM_GAvomito, ?midevol,?mEIM_NSconciencia,?mEIM_NSfocalizado, ?mEIM_NSGmot "+;
			", ?mEIM_NSGocu, ?mEIM_NSGver, ?mEIM_NSpic, ?mEIM_NSpupilas, ?mEIM_NSreflejoOC, ?mEIM_NSsignosMen, ?mEIM_NStipofocalizado "+;
			", ?mEIM_NStrastornos, ?mEIM_Ralteraciones, ?mEIM_RARM, ?mEIM_Rburbujea, ?mEIM_Rdebito, ?mEIM_RdebTipo, ?mEIM_Rdrender "+;
			", ?mEIM_Rdrenizq, ?mEIM_RdrenPleu, ?mEIM_RfrecResp, ?mEIM_Rmascarao2, ?mEIM_Roscila, ?mEIM_Rpeep, ?mEIM_Rppico "+;
			", ?mEIM_RsatO2, ?mEIM_RtipoResp, ?mEIM_Rtoraco, ?mEIM_Rvt,?mEIM_CVtensiond ,?mEIM_Rcanula,?mEIM_GAtipoHD,?mEIM_aislamiento, ?mEIM_indicacion   )" )

		If mret < 0
			Messagebox("ERROR EN LA ACTUALIZACION"+Chr(10)+;
				"AVISE A SISTEMAS",16, "ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			lgrabobien = .F.
		Endif
**************************** html
		If !prg_ejecutosql("Select top 1 Id From tabintevolMed Where EIM_IdEvol = ?midevol and EIM_CodMed = ?mEIM_codmed and EIM_FechaH = ?mfechahora Order by id Desc", "mwkEvolMedAux")
			Return .F.
		Endif

		loHtml.htML = Strtran(loHtml.htML, '??ID??' ,Transform(mwkEvolMedAux.Id))
		lcHtmlBase = loHtml.htML

		If !prg_ejecutosql("Update tabintevolMed set EIM_Html = ?lcHtmlBase Where ID = ?mwkEvolMedAux.Id")
			Return .F.
		Endif

****************************</ html
***  Meta nutricional
		If mlcambiometanut
			mret = SQLExec(mcon1, "insert into ZabIntPedNut " + ;
				" (IPN_fechaH, IPN_idevol, IPN_metaCalorica, IPN_metaProteica, IPN_metaTipo, IPN_porcMetaCal, IPN_porcMetaProt, IPN_usuario )"+;
				" values (?mfechahora,?midevol, ?mmetac ,?mmetap, ?tipomc, ?mporcmc,?mporcmp,?midusuario)" )

			If mret < 0
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Endif

		Endif
***** ayunos
		If mlcanceloayuno
			Select mwkIntNutsusp
			Scan
				mid = Id
				mobserva = Alltrim(INA_observa)+" Susp.x: " +Alltrim(mwkmedicoint.nombre)
				mret = SQLExec(mcon1, "update TabIntAyuno set INA_fechaBaja = ?mfechahora ,INA_observa = ?mobserva,INA_usuariobaja = ?musua "+;
					" where id= ?mid  ")
			Endscan
		Else
			If mlayuno
				mfechaayuno = Ctot(Dtoc(mEIM_ALfecSusp)+" " +Transform(mhora,"@L 99")+":00")
				mret = SQLExec(mcon1, "insert into TabIntAyuno " + ;
					" ( INA_codmed , INA_fechaBaja , INA_fechaHoraIni , INA_idevol , INA_observa , INA_usuariobaja )"+;
					" values "+;
					" (?mEIM_codmed,?mfecfin, ?mfechaayuno  , ?midevol,?mEIM_ALmotSusp ,?midusuario )" )

				If mret < 0
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Endif
			Endif
		Endif
*********
****  actualiza ARM
		Select mwkARM
		miavn = mwkARM.Id
		If moptarm  = 2 And Reccount('mwkARM')>0   &&&& da por finalizada
			mret = SQLExec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
				" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo=1 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia ")
			If mret < 0
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Endif
		Else &&& actualiza o inserta
			mret = SQLExec(mcon1, "SELECT id FROM TabIntAVN " + ;
				" where  AVN_idevol = ?midevol and AVN_tipo=1 and AVN_fechafin = ?mfecfin ", "mwkVerAVN")

			If mret < 0
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Endif

			miavn = mwkVerAVN.Id
			If mEIM_RARM = .T. And mlcbioARM
*!*					if miavn = 0 &&&inserto
				marmfini= Iif(Vartype(marmfini)#"D",Ttod(mwkfecserv.fechahora),marmfini)

				mret = SQLExec(mcon1, "insert into TabIntAVN " + ;
					" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
					" values "+;
					" (?marmcomp  ,?mfecfin, ?mfechahora,?marmfini, ?midevol,?marmmodo, ?marmmot , 1,?midusuario  )" )
				If mret < 0
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Endif
			Else
*!*					endif
			Endif
		Endif
		If mlcbioARM
			Do sp_grabo_evol_int_arm	With ,moptarm  ,mEIM_codmed ,,mEIM_RfrecResp,midevol,,;
				mEIM_Rpeep,,mEIM_Rppico,,mEIM_RsatO2 ,,,mEIM_Rvt,moptarm  ,marmmodo ,marmcomp,marmmot ,marmfini ,,,,;
				.F.,.F.,.F.
		Endif
****  actualiza tubo OT
		Select mwkToT
		mitot = mwkToT.Id
		If mtuboot = 2 And Reccount('mwkToT')>0   &&&& da por finalizada
			mret = SQLExec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
				" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo=4 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia ")
			If mret < 0
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Endif
		Else &&& actualiza o inserta
			If mtuboot = 1 And mlcambiotot
				mret = SQLExec(mcon1, "SELECT id FROM TabIntAVN " + ;
					" where  AVN_idevol = ?midevol and AVN_tipo = 4 and AVN_fechafin = ?mfecfin", "mwkVerAVN")
				mitot = mwkVerAVN.Id
*!*					if mitraq = 0 &&&inserto
				mret = SQLExec(mcon1, "insert into TabIntAVN " + ;
					" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
					" values "+;
					" (0,?mfecfin, ?mfechahora,?mtotfini, ?midevol,0,0 , 4,?midusuario  )" )
				If mret < 0
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Endif
*!*					else
*!*	*					if mtraq = 1
*!*							mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   "+;
*!*								" ,AVN_modo = ?marmmodo ,AVN_motivo = ?marmmot , AVN_complica = ?marmcomp  where id = ?mitraq ")
*!*	*					endif
*!*					endif
			Endif
		Endif
****  actualiza traq
		Select mwkTraq
		mitraq = mwkTraq.Id
		If mtraq = 2 And Reccount('mwkTraq')>0   &&&& da por finalizada
			mret = SQLExec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
				" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo=  5 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia ")
			If mret < 0
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Endif
		Else &&& actualiza o inserta
			If mtraq = 1 And mlcambiotraq
				mret = SQLExec(mcon1, "SELECT id FROM TabIntAVN " + ;
					" where  AVN_idevol = ?midevol and AVN_tipo = 5 and AVN_fechafin = ?mfecfin", "mwkVerAVN")
				mitraq = mwkVerAVN.Id
*!*					if mitraq = 0 &&&inserto
				mtraqfini = Iif(Vartype(mtraqfini )#"D",Ttod(mwkfecserv.fechahora),mtraqfini )

				mret = SQLExec(mcon1, "insert into TabIntAVN " + ;
					" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
					" values "+;
					" (0,?mfecfin, ?mfechahora,?mtraqfini , ?midevol,0,0 , 5,?midusuario  )" )
				If mret < 0
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Endif
			Endif
		Endif
****  actualiza drenaje pleural
		Select mwkDP
		miDP = mwkDP.Id
		mDPacc = 0
		If mRdrenPleu  = 2 And Reccount('mwkDP')>0   &&&& da por finalizada
			mret = SQLExec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
				" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo= 26 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia  ")
			If mret < 0
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Endif
		Else &&& actualiza o inserta
			If  mRdrenPleu   = 1 And mlcambiodp
				mret = SQLExec(mcon1, "SELECT id FROM TabIntAVN " + ;
					" where  AVN_idevol = ?midevol and AVN_tipo = 26  and AVN_fechafin = ?mfecfin ", "mwkVerDP")
				miDP = mwkVerDP.Id
*!*					if miavn = 0 &&&inserto
				mDPfini = Iif(Vartype(mDPfini )#"D",Ttod(mwkfecserv.fechahora),mDPfini )

				mret = SQLExec(mcon1, "insert into TabIntAVN " + ;
					" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
					" values "+;
					" (0,?mfecfin, ?mfechahora,?mDPfini , ?midevol,?mDPacc , 0, 26,?midusuario  )" )
				If mret < 0
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Endif
			Endif
		Endif
****  actualiza PIC
		Select mwkPIC
		mipic = mwkPIC.Id
		If mpic = 2 And Reccount('mwkPIC')>0   &&&& da por finalizada
			mret = SQLExec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
				" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo=  9 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia ")
			If mret < 0
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Endif
		Else &&& actualiza o inserta
			If sipic And mlcambiopic
				mret = SQLExec(mcon1, "SELECT id FROM TabIntAVN " + ;
					" where  AVN_idevol = ?midevol and AVN_tipo = 9 and AVN_fechafin = ?mfecfin", "mwkVerAVN")
				mipic = mwkVerAVN.Id
*				if miPIC = 0 &&&inserto
				mfecinipic = Iif(Vartype(mfecinipic )#"D",Ttod(mwkfecserv.fechahora),mfecinipic )

				mret = SQLExec(mcon1, "insert into TabIntAVN " + ;
					" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
					" values "+;
					" (0,?mfecfin, ?mfechahora,?mfecinipic , ?midevol,0,0 , 9,?midusuario  )" )
				If mret < 0
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Endif
			Endif
		Endif

****  actualiza VEVP
		Select mwkEVP
		mivevp = mwkEVP.Id
		If mvevp = 2 And Reccount('mwkEVP')>0   &&&& da por finalizada
			mret = SQLExec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
				" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo=  6 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia ")
			If mret < 0
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Endif
		Else &&& actualiza o inserta
			If sivevp And mlcambioevp
				mret = SQLExec(mcon1, "SELECT id FROM TabIntAVN " + ;
					" where  AVN_idevol = ?midevol and AVN_tipo=6 and AVN_fechafin = ?mfecfin ", "mwkVervevp")
				mivevp = mwkVervevp.Id
*!*					if miavn = 0 &&&inserto
				mvevpfini = Iif(Vartype(mvevpfini )#"D",Ttod(mwkfecserv.fechahora),mvevpfini )
				mret = SQLExec(mcon1, "insert into TabIntAVN " + ;
					" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
					" values "+;
					" (?mvevpcomp ,?mfecfin, ?mfechahora,?mvevpfini , ?midevol,?mvevpacc , 0, 6,?midusuario  )" )
				If mret < 0
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Endif
			Endif
		Endif

****  actualiza VIAC
		Select mwkCVC
		mivcac = mwkCVC.Id
		If mvc = 2 And Reccount('mwkCVC')>0   &&&& da por finalizada
			mret = SQLExec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
				" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo=  2 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia ")
			If mret < 0
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Endif
		Else &&& actualiza o inserta
			If sivc And mlcambioevc
				mret = SQLExec(mcon1, "SELECT id FROM TabIntAVN " + ;
					" where  AVN_idevol = ?midevol and AVN_tipo= 2 and AVN_fechafin = ?mfecfin ", "mwkVerVC")
				mivc = mwkVerVC.Id
*!*					if miavn = 0 &&&inserto
				mvcfini = Iif(Vartype(mvcfini )#"D",Ttod(mwkfecserv.fechahora),mvcfini )
				mret = SQLExec(mcon1, "insert into TabIntAVN " + ;
					" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
					" values "+;
					" (?mvccomp ,?mfecfin, ?mfechahora,?mvcfini , ?midevol,?mvcacc , 0, 2,?midusuario  )" )
				If mret < 0
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Endif
			Endif
		Endif

****  actualiza CART
		Select mwkCART
		micart = mwkCART.Id
		If mcart = 2 And Reccount('mwkCART')>0   &&&& da por finalizada
			mret = SQLExec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
				" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo=  7 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia ")
			If mret < 0
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Endif
		Else &&& actualiza o inserta
			If sicart And mlcambiocart
				mret = SQLExec(mcon1, "SELECT id FROM TabIntAVN " + ;
					" where  AVN_idevol = ?midevol and AVN_tipo= 7  and AVN_fechafin = ?mfecfin ", "mwkVercart")
				micart = mwkVercart.Id
*!*					if miavn = 0 &&&inserto
				mcartfini = Iif(Vartype(mcartfini )#"D",Ttod(mwkfecserv.fechahora),mcartfini )
				mret = SQLExec(mcon1, "insert into TabIntAVN " + ;
					" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
					" values "+;
					" (?mcartcom ,?mfecfin, ?mfechahora,?mcartfini , ?midevol,?mcartacc , 0, 7,?midusuario  )" )
				If mret < 0
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Endif
			Endif
		Endif
****  actualiza CSG
		Select mwkCSG
		micsg = mwkCSG.Id
		If mcsg = 2 And Reccount('mwkCSG')>0   &&&& da por finalizada
			mret = SQLExec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia  "+;
				" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo=  8 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia ")
			If mret < 0
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Endif
		Else &&& actualiza o inserta
			If sicsg And mlcambiocsg
				mret = SQLExec(mcon1, "SELECT id FROM TabIntAVN " + ;
					" where  AVN_idevol = ?midevol and AVN_tipo= 8  and AVN_fechafin = ?mfecfin ", "mwkVercSG")
				micsg = mwkVercSG.Id
*!*					if miavn = 0 &&&inserto
				mcsgfini = Iif(Vartype(mcsgfini )#"D",Ttod(mwkfecserv.fechahora),mcsgfini )
				mret = SQLExec(mcon1, "insert into TabIntAVN " + ;
					" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
					" values "+;
					" (?mcsgcomp ,?mfecfin, ?mfechahora,?mcsgfini , ?midevol,?mcsgacc , 0, 8,?midusuario  )" )
				If mret < 0
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Endif
			Endif
		Endif
****  actualiza dialisis
		Select mwkHD
		midial = mwkHD.Id
		If mdial = 2 And Reccount('mwkHD')>0   &&&& da por finalizada
			mret = SQLExec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
				" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo=  10 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia ")
			If mret < 0
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Endif
		Else &&& actualiza o inserta
			If sihd And mlcambiodia
				mret = SQLExec(mcon1, "SELECT id FROM TabIntAVN " + ;
					" where  AVN_idevol = ?midevol and AVN_tipo= 10 and AVN_fechafin = ?mfecfin ", "mwkVerVC")
				mivc = mwkVerVC.Id
*!*					if miavn = 0 &&&inserto
				mdialfini = Iif(Vartype(mdialfini )#"D",Ttod(mwkfecserv.fechahora),mdialfini )
				mret = SQLExec(mcon1, "insert into TabIntAVN " + ;
					" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
					" values "+;
					" (?mdialcomp ,?mfecfin, ?mfechahora,?mdialfini , ?midevol,?mdialacc , ?mdialtipo, 10,?midusuario  )" )
				If mret < 0
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Endif
			Endif
		Endif
****  actualiza SNG
		Select mwkSNG
		miSNG = mwkSNG.Id
		mSNGcomp = 0
		If mSNG = 2 And Reccount('mwkSNG')>0   &&&& da por finalizada
			mret = SQLExec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
				" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo=  3 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia  ")
			If mret < 0
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Endif
		Else &&& actualiza o inserta
			If (sisng Or sisngn) And mlcambiosng
				mret = SQLExec(mcon1, "SELECT id FROM TabIntAVN " + ;
					" where  AVN_idevol = ?midevol and AVN_tipo= 3  and AVN_fechafin = ?mfecfin ", "mwkVerSNG")
				miSNG = mwkVerSNG.Id
*!*					if miavn = 0 &&&inserto
				mSNGfini = Iif(Vartype(mSNGfini )#"D",Ttod(mwkfecserv.fechahora),mSNGfini )
				mret = SQLExec(mcon1, "insert into TabIntAVN " + ;
					" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
					" values "+;
					" (?mSNGcomp ,?mfecfin, ?mfechahora,?mSNGfini , ?midevol,?mSNGacc , 0, 3,?midusuario  )" )
				If mret < 0
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Endif
			Endif
		Endif
****  actualiza SVES
		Select mwkSVES
		miSVES = mwkSVES.Id
		If msves = 2 And Reccount('mwkSVES')>0   &&&& da por finalizada
			mret = SQLExec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
				" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo= 11 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia  ")
			If mret < 0
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Endif
		Else &&& actualiza o inserta
			If sisves And mlcambiosves
				mret = SQLExec(mcon1, "SELECT id FROM TabIntAVN " + ;
					" where  AVN_idevol = ?midevol and AVN_tipo = 11  and AVN_fechafin = ?mfecfin ", "mwkVerSVES")

				If mret < 0
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Endif

				miSVES = mwkVerSVES.Id
				If miSVES = 0 &&&inserto
					msvesfini = Iif(Vartype(msvesfini)#"D",Ttod(mwkfecserv.fechahora),msvesfini)
					mret = SQLExec(mcon1, "insert into TabIntAVN " + ;
						" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
						" values "+;
						" (0,?mfecfin, ?mfechahora,?mSVESfini , ?midevol,?mSVESacc , 0, 11,?midusuario  )" )
				Endif
				If mret < 0
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Endif
			Endif
		Endif
	Endif
Endif
****  actualiza esquemas
If mlmodifatb
	mret = SQLExec(mcon1, "select ID, EATB_dias, EATB_esquema, EATB_fechafin, EATB_fechaini, EATB_idevol "+;
		" from TabIntEsquemas "+;
		"where EATB_idevol= ?midevol"  , "mwkatbesq")

	Select mwkatbesquema
	Scan
		If Id>40
			midesq = Id
			If EATB_fechafin>=Ttod(mwkfecserv.fechahora)-1  And EATB_fechafin<mfecfin   && dar de baja
				mfec = EATB_fechafin
				mret = SQLExec(mcon1, "update TabIntEsquemas set EATB_fechafin = ?mfec "+;
					" where Id = ?midesq ")
				If mret < 0
					Messagebox("ERROR EN LA ACTUALIZACION"+Chr(10)+;
						"AVISE A SISTEMAS",16, "ERROR")
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Endif
			Endif
		Else
			If EATB_fechafin = mfecfin
				mEATB_dias = mwkatbesquema->EATB_dias
				mEATB_esquema = mwkatbesquema->EATB_esquema
				mEATB_fechafin = mwkatbesquema->EATB_fechafin
				mEATB_fechaini = mwkatbesquema->EATB_fechaini
				mret = SQLExec(mcon1, "insert into TabIntEsquemas " + ;
					" ( EATB_dias, EATB_esquema, EATB_fechafin, EATB_fechaini, EATB_idevol)"+;
					" values "+;
					" (?mEATB_dias ,?mEATB_esquema , ?mEATB_fechafin ,?mEATB_fechaini ,?midevol )" )
				If mret < 0
					Messagebox("ERROR EN LA ACTUALIZACION"+Chr(10)+;
						"AVISE A SISTEMAS",16, "ERROR")
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Endif
			Endif
		Endif
	Endscan
Endif


If mlmodifevoln And musua > 0
	mret = SQLExec(mcon1, "insert into tabintevolNurse " + ;
		" (EIn_codcienanda , EIn_evolnurse , EIn_fechah , EIn_paradmf , EIn_paralerg , " + ;
		"EIn_paralergque , EIn_parotros , EIN_idevol , EIn_usuario ) values "+;
		" (1, ?msoloevol,?mfechahora ,?mparadmf , ?mparalerg , "+;
		" ?mparalergque , ?mparotros  , ?midevol ,?midusuario   )" )
	If mret < 0
		Messagebox("ERROR EN LA ACTUALIZACION"+Chr(10)+;
			"AVISE A SISTEMAS",16, "ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Endif

Endif
If mlmodifresumen
	mret = SQLExec(mcon1, "insert into TabIntResumenHC	 " + ;
		"(RH_fechaHora,RH_idevol,RH_resumen,RH_usuario)  values"+;
		"(?mfechahora ,?midevol,?mresumen,?midusuario  )")
	If mret < 0
		Messagebox("ERROR EN LA ACTUALIZACION"+Chr(10)+;
			"AVISE A SISTEMAS",16, "ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Endif
Endif
If mlmodifIC
	mret = SQLExec(mcon1, "insert into TabIntevolIC 	 " + ;
		"(EIC_fechaHora ,EIC_idevol ,EIC_evolIC ,EIC_usuario,EIC_codesp, EIC_codpun )  values"+;
		"(?mfechahora ,?midevol,?mintercons,?midusuario,?mICcodesp, ?mICcodpun  )")

	If mret < 0
		Messagebox("ERROR EN LA ACTUALIZACION"+Chr(10)+;
			"AVISE A SISTEMAS",16, "ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		lgrabobien = .F.
	Endif
Endif


If musua = 0		&&&& datos medicos
	If mlcambioepicris Or mlfinepicris
		If mwktaltasint.tipoest<9
			miestado = mwktaltasint.Id
			mcodcie10 = mwkcie9.Id
			mIH_resumen = mopage6.txteditresumen.Value
			If ! mlcambioepicris
				mret = SQLExec(mcon1, "update TabIntHCE set IH_horaCierre = ?mfechahora , IH_codestado = ?miestado "+;
					",IH_codcie = ?mcodcie10,IH_resumen = ?mIH_resumen  "+;
					" where Id = ?midevol ")
			Else
				mret = SQLExec(mcon1, "update TabIntHCE set IH_horaCierre = ?mfechahora , IH_codestado = ?miestado "+;
					",IH_codmedcie = ?mmedico,IH_codcie = ?mcodcie10,IH_resumen = ?mIH_resumen  "+;
					" where Id = ?midevol ")
			Endif
			If mret < 0
				Messagebox("ERROR EN LA ACTUALIZACION"+Chr(10)+;
					"AVISE A SISTEMAS",16, "ERROR")
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Endif
		Else
			mIH_resumen = Alltrim(mopage6.txteditresumen.Value)
			If !Empty(mIH_resumen)
				mret = SQLExec(mcon1, "update TabIntHCE set IH_resumen = ?mIH_resumen  "+;
					" where Id = ?midevol ")
				If mret < 0
					Messagebox("ERROR EN LA ACTUALIZACION"+Chr(10)+;
						"AVISE A SISTEMAS",16, "ERROR")
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Endif
			Endif
		Endif
		With mopage6
			Select mwkciesec
			Scan
				If Id>0
					midepi = Id
					If IE_fechaHBaja>=Ttod(mwkfecserv.fechahora)-1  And IE_fechaHBaja<mfecfin   && dar de baja
						mfec = IE_fechaHBaja
						mret = SQLExec(mcon1, "update TabIntEpi set IE_fechaHBaja = ?mfec "+;
							" where Id = ?midepi and IE_tipo=0 ")
						If mret < 0
							Messagebox("ERROR EN LA ACTUALIZACION"+Chr(10)+;
								"AVISE A SISTEMAS",16, "ERROR")
							Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
						Endif
					Endif
				Else
					midcie10 = idcie10
&&,IE_patologia
					mret = SQLExec(mcon1, "insert into TabIntEpi " + ;
						" ( IE_codcie ,IE_codmed ,IE_fechaHora,IE_fechaHBaja, IE_idevol ,IE_tipo)"+;
						" values "+;
						" (?midcie10 ,?mmedico, ?mfechahora,?mfecfin ,?midevol,0 )" )
					If mret < 0
						Messagebox("ERROR EN LA ACTUALIZACION"+Chr(10)+;
							"AVISE A SISTEMAS",16, "ERROR")
						Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
					Endif
				Endif
			Endscan

**codcie10 ,descrip,idcie10,IE_codcie ,IE_codmed ,IE_patologia,IE_fechaHora,IE_fechaHBaja, IE_idevol ,IE_tipo

			mpatologia =''
			mret = SQLExec(mcon1, "select id from TabIntEpi " + ;
				" where  IE_idevol = ?midevol and IE_tipo=99 AND IE_fechaHBaja = ?mfecfin  " ,"mwkctrepi")
			If Reccount("mwkctrepi")>0
				MIDEP = mwkctrepi.Id
				mret = SQLExec(mcon1, "UPDATE TabIntEpi " + ;
					" SET  IE_fechaHBaja = ?mfechahora  where  ID = ?midep ")
			Endif
			If .chkfinepi.Value = 1
				mret = SQLExec(mcon1, "insert into TabIntEpi " + ;
					" ( IE_codcie ,IE_codmed ,IE_fechaHora,IE_fechaHBaja,IE_patologia, IE_idevol ,IE_tipo)"+;
					" values "+;
					" (0 ,?mmedico, ?mfechahora,?mfecfin ,?mpatologia ,?midevol,99 )" )
				If mret < 0
					Messagebox("ERROR EN LA ACTUALIZACION"+Chr(10)+;
						"AVISE A SISTEMAS",16, "ERROR")
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Endif
			Endif
			With .CntAntProc.Pageframe1
				For hh = 1 To .PageCount
					cmpage = ".Page"+Alltrim(Transform(hh))
					With &cmpage
						mpatologia = Alltrim(.Txtedit1.Value)
						If mwkestHabepinew.estado = 1
							mret = SQLExec(mcon1, "select id from TabIntEpi " + ;
								" where  IE_idevol = ?midevol and IE_tipo=?hh AND IE_fechaHBaja = ?mfecfin  " ,"mwkctrepi")
							If Reccount("mwkctrepi")>0
								Select mwkctrepi
								Scan
									MIDEP = mwkctrepi.Id
									mret = SQLExec(mcon1, "UPDATE TabIntEpi " + ;
										" SET  IE_fechaHBaja = ?mfechahora  where  ID = ?midep ")
								Endscan
							Endif

						Endif
						mret = SQLExec(mcon1, "insert into TabIntEpi " + ;
							" ( IE_codcie ,IE_codmed ,IE_fechaHora,IE_fechaHBaja,IE_patologia, IE_idevol ,IE_tipo)"+;
							" values "+;
							" (0 ,?mmedico, ?mfechahora,?mfecfin ,?mpatologia ,?midevol,?hh )" )
						If mret < 0
							Messagebox("ERROR EN LA ACTUALIZACION"+Chr(10)+;
								"AVISE A SISTEMAS",16, "ERROR")
							Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
						Endif
					Endwith
				Next hh
			Endwith
		Endwith
	Endif
	If mlmedcabe And mlcambioanam
		mret = SQLExec(mcon1, "update TabIntHCE set IH_motIngreso = ?mIH_motIngreso , IH_procedencia = ?mIH_procedencia "+;
			",ih_codmed = ?mmedico,IH_reingre = ?mIH_reingre where Id = ?midevol and ih_codmed = 1 ")
		mret = SQLExec(mcon1, "update TabIntHCE set IH_motIngreso = ?mIH_motIngreso , IH_procedencia = ?mIH_procedencia "+;
			",IH_reingre = ?mIH_reingre where Id = ?midevol ")
	Else
		If mlcambioanam && mlcambioanamllave
			mret = SQLExec(mcon1, "update TabIntHCE set IH_motIngreso = ?mIH_motIngreso , IH_procedencia = ?mIH_procedencia "+;
				" ,IH_reingre = ?mIH_reingre where Id = ?midevol ")
		Endif
	Endif
	If mlcambioepicris Or mlfinepicris
		miestado = mwktaltasint.Id
		mcampoest = "IH_horaCierre = '1900-01-01' ,IH_codestado = ?miestado,IH_codmedcie = 1 "
		If miestado <=9
			mcampoest = "IH_horaCierre = ?mfechahora , IH_codestado = ?miestado"+Iif(!mlcambioepicris ,'',",IH_codmedcie = ?mmedico ")
		Endif
		mcodcie10 = mwkcie9.Id
		mIH_resumen = mopage6.txteditresumen.Value

		mret = SQLExec(mcon1, "update TabIntHCE set "+mcampoest +;
			",IH_codcie = ?mcodcie10,IH_resumen = ?mIH_resumen  "+;
			" where Id = ?midevol ")
		If mret < 0
			Messagebox("ERROR EN LA ACTUALIZACION"+Chr(10)+;
				"AVISE A SISTEMAS",16, "ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Endif

	Endif
	If mret < 0
		Messagebox("ERROR EN LA ACTUALIZACION"+Chr(10)+;
			"AVISE A SISTEMAS",16, "ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Endif
Endif
If 	lgrabobien

	Use In Select('mwkVerEvol')
	Use In Select('mwkatbesq')
	Use In Select('mwkciesec')
	Use In Select('mwkVerSVES')
	Use In Select('mwkVerSNG')
	Use In Select('mwkVerVC')
	Use In Select('mwkVercSG')
	Use In Select('mwkVercart')
	Use In Select('mwkVerVC')
	Use In Select('mwkVervevp')
	Use In Select('mwkVerAVN')
	Use In Select('mwkVerDP')
	Use In Select('mwkEvolMedAux')
	Use In Select('mwkindCCind')
	Use In Select('mwkindCCDind')
	Use In Select('mwkctresq')
	Use In Select("mwkctrepi")
Endif
