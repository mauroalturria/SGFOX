****
** Grabo evolucion del paciente
****
*!*		do sp_grabo_evolucion_INT with mnreg, thisform.txtprotocolo.value,thisform.medcabecera;
*!*			, thisform.PgConsulta.pgEvolmed,thisform.PgConsulta.pgIndNur,thisform.PgConsulta.pgCSV;
*!*			,iif(thisform.mformorigen=28, mwkusuarios.codigovax,0),;
*!*			thisform.lmodifresumen,thisform.lclose,iif(thisform.mformorigen=28 ,0,thisform.miorigen)

parameters mnroreg, mprot, mmedico,mopage2, mopage3,mopage4,mopage5,mopage6,mopage7,musua,morigen
dimension admfar(11),pract(13)
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
if vartype(morigen)#"N"
	morigen = 0
	lmismomed = .f.
endif
midusuario = iif(used('mwkusuarios'),mwkusuarios.id ,mwkusuario.id)
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

lvaaarchivo = 0

mfechahora  = sp_busco_fecha_serv("DT")
mfechadia = ttod(mfechahora )
mfecini = ctod("01/01/1900")
mfecfin = ctod("01/01/2100")
mcodcienanda = 0
msoloevol = ''
if type('mopage2')='O'

	mltipalta = mopage2.parent.parent.ltipalta
	mlcodesta = mopage2.parent.parent.lcodesta
	mlmodifresumen = mopage2.parent.parent.lmodifresumen
	mlmodifIC 	= mopage2.parent.parent.lmodifIC
	mlcierreant = mopage2.parent.parent.lcierreant
	midevol	= mopage2.parent.parent.midevol
	mlmodifevoln = mopage2.parent.parent.lmodifevoln
	mlcambiocsv  = mopage2.parent.parent.lcambiocsv
	mlcambiocsvm  = mopage2.parent.parent.lcambiocsvm
	mlcambioevol = mopage2.parent.parent.lcambioevol
	mlcambioepicris = mopage2.parent.parent.lcambioepicris
	mlcbioARM  = mopage2.parent.parent.lcbioARM
	mlcambioanam  = mopage2.parent.parent.lcambioanam
	mlmodifatb = mopage2.parent.parent.lmodifatb
	mlmedcabe = (reccount('mwkanam')=0)
* TxtEdtIndic  medico
* TxteditEvol ingresado ahora
* TxtEdtEvol  anterior

	miprotquir = ''
	mcodmedpq  = 0

	calta 	 = '' &&iif(mwkveoproto.tipoest =0 or lcierreant,"Evolución Posterior al CIERRE del Protocolo ","")
	caltanur = ''&&iif((mwkveoproto.tipoest =0 or lcierreant) and !empty(mopage3.txtedtindic.value),"Indicación Posterior al CIERRE del Protocolo ","")
*!*		mmotc 	 = mopage2.txteditmotc.value
*!*		mantec 	 = mopage2.txteditantec.value
*!*		mevolf	 = mopage2.txteditevolf.value
*!*		mevola	 = mopage2.edtevol.value
*!*		mevol	 = mopage2.txteditevol.value
*!*		mindic	 = mopage3.txtedtindic.value

*	mresumen = mopage2.PgEvol.pgResumen.TxteditResHist.value
	mresumen = ''
	mintercons = mopage2.PgEvol.pgEvolIC.TxteditEvol.value

	mfechaini  = ctot("01/01/1900")
	megparalerg	= mopage3.chknewindic.value
	if mlcambioanam
		do sp_grabo_evol_int_anam with mopage5,midevol
	endif
	with mopage5
		mIH_motIngreso = mwkCie9i.id
		mIH_procedencia = mwkprocede.id
	endwith
* TxtEdtIndic  medico
* TxteditEvol ingresado ahora
* TxtEdtEvol  anterior
	with mopage2.PgEvol.pgevold
		mEIM_codmed =mwkmedicoint.id
		mEIM_evol =.TxteditEvol.value
		with .pgevolApa
			with .Page1
				mevolm  = ''
				mEIM_NSconciencia = .cboconc.value
				mEIM_NSfocalizado = (.optfocal.value= 1)
				mNSfocalizado = .optfocal.value
				mEIM_NStipofocalizado = .txtfocal.value
				mEIM_NSpupilas = .cbopupilas.value
				mevolma =  ''
				if mNSfocalizado >0
					mevolma = iif(mEIM_NSconciencia# 0, 'Conciencia:' + .cboconc.displayvalue,'');
						+ iif(mNSfocalizado  =1," Focalizado: Si ",iif(mNSfocalizado  = 2 ," Focalizado: No ",'' ));
						+ alltrim(mEIM_NStipofocalizado )
				endif
				if 	!empty(.cbopupilas.displayvalue)
					mevolma = mevolma + iif(mEIM_NSpupilas # 0, 'Pupilas:' + .cbopupilas.displayvalue,'')
				endif
				mEIM_NSGmot = .txtgmot.value
				mEIM_NSGocu = .txtgocu.value
				mEIM_NSGver = .txtgver.value
				mEIM_NSreflejoOC = (.optreflexoc.value = 1)
				mNSreflejoOC = .optreflexoc.value
				mEIM_NSsignosMen = (.optsgnmenin.value =1)
				mNSsignosMen = .optsgnmenin.value
				mevolma =  mevolma + iif(!empty(mevolma),chr(10),'')
				mevolma2 =  iif(mNSreflejoOC   =1," R.Oculocefálicos: Si ",iif(mNSreflejoOC   = 2," R.Oculocefálicos: No ",'' ));
					+iif(mNSsignosMen  =1," Signos Meníngeos: Si ",iif(mNSsignosMen  = 2," Signos Meníngeos: No ",'' ));
					+iif(.txtglas1.value=0,'',' Glasgow:'+ transf(.txtglas1.value,'99')+ '/15';
					+ " Verbal:"+transf(mEIM_NSGver ,'99') + " Ocular:"+transf(mEIM_NSGocu ,'99') + " Motor:"+transf(mEIM_NSGmot ,'99'))
				mevolma2 =  mevolma+iif(!empty(mevolma2),chr(10)+mevolma2 + chr(10),'')

				mEIM_NStrastornos = .txttrastornos.value
				mevolma = iif(!empty(mEIM_NStrastornos), "Trastornos Psiquiátricos:"+ alltrim(mEIM_NStrastornos)+chr(10),'')
				mEIM_NSpic = (.optPIC.value=1)
				if .optPIC.value = 1
					mfecinipic = .txtpicfini.value
					mvalorpic = .txtpic.value
					mdiaspic = .txtdiaspic.value
				endif
				mevolma =  mevolma +iif(.optPIC.value =1," PIC: Si ",iif(.optPIC.value = 2," PIC: No ",'' )) ;
					+ iif(.optPIC.value =1, iif(mvalorpic <>0," Valor: "+transf(mvalorpic ,'999')+"mm hg",'' ) ;
					+" Desde:"+dtoc(mfecinipic )+ "Días:"+transf(mdiaspic ,'999')+chr(10),'')
				mevolm = iif(!empty(mevolma),' Neurológico' + chr(10) + mevolma,'')
			endwith
			with .Page2
				mEIM_RtipoResp  = .txttiporesp.value
				mevolma =  iif(!empty(mEIM_RtipoResp),'Tipo y Frec.Resp.:'+alltrim(mEIM_RtipoResp)+chr(10),'')
				mEIM_Ralteraciones  = .txtaltera.value
				mevolma =  mevolma +iif(!empty(mEIM_Ralteraciones),'Alteraciones semiológicas toracopulmonares:'+alltrim(mEIM_Ralteraciones  )+chr(10),'')
				mEIM_Rmascarao2  = (.optmascO2.value = 1 )
				mRmascarao2  = .optmascO2.value
				mEIM_Rcanula  = (.OptCanula.value = 1 )
				mevolma2 = iif(mRmascarao2 =1," Máscara O2: Si ",iif(mRmascarao2    = 2," Máscara O2: No ",'' ));
					+iif(.OptCanula.value =1," Cánula: Si ",iif(.OptCanula.value = 2," Cánula: No ",'' ))+iif(!empty(mevolma2),chr(10),'')
				mevolma = mevolma + mevolma2
				mtuboot = .opttuboot.value
				mtotfini  = .txtfecinitubo.value
				mtotdias  = .txtdiastubo.value
				mevolma2 =  ''
				mevolma2 =  iif(mtuboot =1," Tubo Orotraqueal: Si ",iif(mtuboot = 2," Tubo Orotraqueal: No ",'' ));
					+iif(mtuboot =1," Desde:"+dtoc(mtotfini)+ "Días:"+transf(mtotdias,'999')+chr(10),'' )
				mevolma = mevolma + mevolma2
				mtraq = .opttraq.value
				mtraqfini = .txttraqfini.value
				mtraqdias  = .txttraqdias.value
				mevolma2 =  ''
				mevolma2 =  iif(mtraq =1," Traqueostomía: Si ",iif(mtraq = 2," Traqueostomía: No ",'' ));
					+iif(mtraq =1," Desde:"+dtoc(mtraqfini )+ "Días:"+transf(mtraqdias  ,'999')+chr(10),'' )
				mevolma = mevolma + mevolma2

				mEIM_RdrenPleu  = (.optdrenpleu.value = 1)
				mRdrenPleu  = .optdrenpleu.value
				mEIM_Rdrender  = .chkder.value
				mEIM_Rdrenizq  = .chkizq.value
				mEIM_Roscila  = (.optoscila.value =1 )
				mRoscila  = .optoscila.value
				mEIM_Rburbujea  = (.optburbuja.value = 1 )
				mRburbujea  = .optburbuja.value
				mEIM_Rdebito  = (.optdebito.value = 1)
				mRdebito  = .optdebito.value
				mEIM_RdebTipo  = .txttipodeb.value
				mevolma2 =  ''
				mevolma2 =  iif(mRdrenPleu  =1," Drenaje pleural: Si ",iif(mRdrenPleu  = 2," Drenaje pleural: No ",'' ));
					+iif(mEIM_Rdrender=1 ," Derecho ",'')+ iif(mEIM_Rdrenizq=1 ," Izquierdo ",'' );
					+iif(mRoscila  =1," Oscila: Si ",iif(mRoscila  = 2," Oscila: No ",'' ));
					+iif(mRburbujea    =1," Burbujea: Si ",iif(mRburbujea    = 2," Burbujea: No ",'' ));
					+iif(mRdebito    =1," Débito: Si ",iif(mRdebito    = 2," Débito: No ",'' ));
					+iif(mRdebito    =1," Tipo Débito: "+alltrim(mEIM_RdebTipo),'' );
					+iif(!empty(mevolma2),chr(10),'')
				mevolma = mevolma + mevolma2

				mEIM_RARM  = (.optARM.value=1)
				mEIM_RfrecResp  = .txtfr.value
				mEIM_Rpeep  = .txtARMpeep.value
				mEIM_Rppico = .txtppico.value
				mEIM_RsatO2  = .txtsato2.value
				mEIM_Rvt  = .txtARMvt.value
				marmmodo = .cboARMmodo.value
				marmcomp = .CboARMCompl.value
				marmmot = .CboARMMot.value
				marmfini = .txtARMfini.value
				marmpeep = .optpeep.value
				mARMdias  = .txtARMdias.value
				mevolma2 =  ''
				mevolma2 =  iif(.optARM.value=1," ARM: Si ",iif(.optARM.value= 2," ARM: No ",'' ));
					+iif(.optARM.value=1,"  Modo: "+.cboARMmodo.displayvalue ;
					+" Desde:"+dtoc(marmfini )+ "Días:"+transf(mARMdias ,'999');
					+ iif(mEIM_Rpeep>0, " PEEP:"+transform (mEIM_Rpeep  ,'999')+"cm H2O",'' );
					+" Motivo:" +.CboARMMot.displayvalue,'') +iif(!empty(mevolma),chr(10),'')
				mevolma = mevolma + mevolma2
				mevolma2 =  ''
				mevolma2 =  iif(.optARM.value=1,iif(mEIM_Rvt  >0,"  VT: "+transform (mEIM_Rvt,'999')+"ml/Kg",'');
					+iif(mEIM_RfrecResp>0,"  FR: "+transform (mEIM_RfrecResp,'999')+"P/min",'');
					+iif(mEIM_RsatO2>0,"  Sat O2: "+transform (mEIM_RsatO2,'999')+"%",'');
					+iif(mEIM_Rppico>0,"  P.Pico: "+transform (mEIM_Rppico,'999')+"cm H2O",'');
					+" Complicaciones:" +.CboARMCompl.displayvalue +chr(10),'')
				mevolma = mevolma + mevolma2

				mevolm = mevolm +iif(!empty(mevolma),' Aparato Respiratorio' + chr(10) + mevolma,'')

			endwith

			with .Page3
				mEIM_CVtipoPulso = .txttipopulso.value
				mEIM_CVPVC = .txtpvc.value
				mEIM_CVtension = .TxtTaSist.value
				mEIM_CVtensiond = .TxtTaDia.value
				mevolma =  ''
				mevolma =  iif(!empty(mEIM_CVtipoPulso ),'Frec. y caract. del pulso:'+alltrim(mEIM_CVtipoPulso )+" P/min",'');
					+iif(mEIM_CVtension >0,"  TA "+transform (mEIM_CVtension ,'999')+"/"+;
					transform (mEIM_CVtensiond ,'999')+" mm Hg ",'');
					+iif(mEIM_CVPVC >0,"  PVC"+transform (mEIM_Rppico,'999')+" cm H2O",'')+iif(!empty(mevolma),chr(10),'')
				mEIM_CValteraciones = .txtaltera.value
				mevolma = mevolma + iif(!empty(mEIM_CValteraciones ),'Alteraciones semiológicas cardiovasculares:'+alltrim(mEIM_CValteraciones )+chr(10),'')
				mEIM_CVpulsosPer  = (.optpperif.value = 1)
				mCVpulsosPer  = .optpperif.value
				mEIM_CVedemas = (.optedemas.value = 1)
				mCVedemas = .optedemas.value
				mevolma2 =  ''
				mevolma2 =  iif(mCVpulsosPer    =1," Pulsos periféricos: Iguales ",iif(mCVpulsosPer    = 2," Pulsos periféricos: Simétricos ",'' ));
					+iif(mCVedemas  =1," Edemas: Si ",iif(mCVedemas  = 2," Edemas: No ",'' ))+iif(!empty(mevolma2),chr(10),'')
				mevolma = mevolma + mevolma2


				mvevp =.optvevp.value
				mvevpfini = .txtvevpfini.value
				mvevpffin = iif(empty(.txtvevpffin.value) or .txtvevpffin.value=ctod("  /  /  "),mfecfin,.txtvevpffin.value)
				mvevdias =	.txtvevpdias.value
				mvevpacc = .cbovevpacc.value
				mvevpcomp = .cbovevpcompl.value

				mevolma2 =  ''
				do case
					case mvevp = 1
						mevolma2 = ' Vías EV Perifer. desde:'+transform(mvevpfini )+" Días:"+transf(mvevdias ,'999')+" Con acceso:"+.cbovevpacc.displayvalue+ ;
							iif(!empty(.cbovevpcompl.displayvalue), " Complicaciones: "+.cbovevpcompl.displayvalue,'') + chr(10)
					case mvevp = 2
						mevolma2 = iif(empty(.cbovevpacc.displayvalue),' Vías EV Perifer. NO',' Vías EV Perifer. desde:'+;
							transform(mvevpfini )+' hasta:'+transform(mvevpffin )+" Días:"+transf(mvevdias ,'999')+" Con acceso:"+.cbovevpacc.displayvalue+ ;
							iif(!empty(.cbovevpcompl.displayvalue), " Complicaciones: "+.cbovevpcompl.displayvalue,'') ) + chr(10)
				endcase
				mevolma = mevolma + mevolma2
				mvcacc = .cboVCacc.value
				mvccomp = .cboVCcompl.value
				mvcdias =	.txtvcdias.value
				mvc = .optvia.value
				mvcfini = .txtVCfini.value
				mvcffin = iif(empty(.txtVCffin.value) or .txtVCffin.value=ctod("  /  /  "),mfecfin,.txtVCffin.value)
				mevolma2 =  ''
				do case
					case mvc = 1
						mevolma2 = ' Vías EV Central desde:'+transform(mvcfini )+" Días:"+transf(mvcdias ,'999')+" Con acceso:"+.cbovcacc.displayvalue+ ;
							iif(!empty(.cbovccompl.displayvalue), " Complicaciones: "+.cbovccompl.displayvalue,'') + chr(10)
					case mvc = 2
						mevolma2 = iif(empty(.cbovcacc.displayvalue), ' Vías EV Central NO ',' Vías EV Central desde:'+;
							transform(mvcfini )+' hasta:'+transform(mvcffin )+" Días:"+transf(mvcdias ,'999')+" Con acceso:"+.cbovcacc.displayvalue+ ;
							iif(!empty(.cbovccompl.displayvalue), " Complicaciones: "+.cbovccompl.displayvalue,'')) + chr(10)
				endcase
				mevolma = mevolma + mevolma2
				mcartacc = .cbocartacc.value
				mcartcom = .cbocartcompl.value
				mcart = .optcart.value
				mcartfini = .txtcartfini.value
				mcartdias =	.txtcartdias.value
				mcartffin = iif(empty(.txtcartffin.value) or .txtcartffin.value=ctod("  /  /  "),mfecfin,.txtcartffin.value)
				mevolma2 =  ''
				do case
					case mcart = 1
						mevolma2 = ' Cat.Arterial desde:'+transform(mcartfini )+" Días:"+transf(mcartdias ,'999')+" Con acceso:"+.cbocartacc.displayvalue+ ;
							iif(!empty(.cbocartcompl.displayvalue), " Complicaciones: "+.cbocartcompl.displayvalue,'') + chr(10)
					case mcart = 2
						mevolma2 = iif(empty(.cbocartacc.displayvalue), ' Cat.Arterial NO ', ' Cat.Arterial desde:'+transform(mcartfini )+' hasta:'+transform(mcartffin )+;
							" Días:"+transf(mcartdias ,'999')+" Con acceso:"+.cbocartacc.displayvalue+ ;
							iif(!empty(.cbocartcompl.displayvalue), " Complicaciones: "+.cbocartcompl.displayvalue,'')) + chr(10)
				endcase
				mevolma = mevolma + mevolma2
				mcsg = .optcsg.value
				mcsgfini = .txtcsgfini.value
				mcsgdias =	.txtcsgdias.value
				mcsgffin = iif(empty(.txtcsgffin.value) or .txtcsgffin.value=ctod("  /  /  "),mfecfin,.txtcsgffin.value)
				mcsgacc = .cbocsgacc.value
				mcsgcomp = .cbocsgcompl.value
				mevolma2 =  ''
				do case
					case mcsg = 1
						mevolma2 = ' Cateter S.Ganz desde:'+transform(mcsgfini )+" Días:"+transf(mcsgdias ,'999')+" Con acceso:"+.cbocsgacc.displayvalue+ ;
							iif(!empty(.cbocsgcompl.displayvalue), " Complicaciones: "+.cbocsgcompl.displayvalue,'') + chr(10)
					case mcsg = 2
						mevolma2 = iif(empty(.cbocsgacc.displayvalue), ' Cateter S.Ganz NO ',  ' Cateter S.Ganz desde:'+transform(mcsgfini )+' hasta:'+transform(mcsgffin )+;
							" Días:"+transf(mcsgdias ,'999')+" Con acceso:"+.cbocsgacc.displayvalue+ ;
							iif(!empty(.cbocsgcompl.displayvalue), " Complicaciones: "+.cbocsgcompl.displayvalue,'') )+ chr(10)
				endcase
				mevolma = mevolma + mevolma2
				mevolm = mevolm +iif(!empty(mevolma),' Aparato Cardiovascular' + chr(10) + mevolma,'')

			endwith


			with .Page4

				mEIM_GAalteraciones = .txtaltera.value
				mevolma =  ''
				mevolma = iif(!empty(mEIM_GAalteraciones), 'Alteraciones semiológicas abdominales:'+alltrim(mEIM_GAalteraciones)+chr(10),'')
				mEIM_GARHA = (.optRha.value = 1)
				mGARHA = .optRha.value
				mEIM_GAvomito = (.optVom.value = 1)
				mGAvomito = .optVom.value
				mEIM_GAcatar = (.optcatar.value = 1)
				mGAcatar = .optcatar.value
				mEIM_GAdolor = (.optdolor.value = 1)
				mGAdolor = .optdolor.value
				mevolma2 =  ''
				mevolma2 =  iif(mGARHA =1," RHA: (+) ",iif(mGARHA = 2," RHA: (-) ",'' ));
					+iif(mGAvomito =1," Vómitos: Si ",iif(mGAvomito = 2," Vómitos: No ",'' ));
					+iif(mGAcatar =1," Catarsis: (+) ",iif(mGAcatar = 2," Catarsis: (-) ",'' ));
					+iif(mGAdolor =1," Dolor: Si ",iif(mGAdolor = 2," Dolor: No ",'' ));
					+iif(!empty(mevolma2),chr(10),'')
				mevolma = mevolma + mevolma2

				mEIM_GAherCX = (.optherida.value = 1)
				mGAherCX = .optherida.value
				mEIM_GAdren = (.optdrenaje.value = 1 )
				mGAdren  = .optdrenaje.value
				mEIM_GAdrenDeb = .txtdren.value
				mEIM_GAdrenTipo = .txtdrentipo.value
				mevolma2 =  ''
				mevolma2 =  iif(mGAdren  =1," Drenaje: Si ",iif(mGAdren  = 2," Drenaje: No ",'' ));
					+iif(mGAdren  =1," Débito :"+transform(mEIM_GAdrenDeb ,'999.99')+ " Tipo:"+alltrim(mEIM_GAdrenTipo ),'' );
					+iif(!empty(mevolma2),chr(10),'')
				mevolma = mevolma + mevolma2

			 	mEIM_GAestadoCX =  .OptestHerida.value 
			 	mecx = mEIM_GAestadoCX 
			 	mEIM_GAcrepita = (.optcrepita.value = 1)
			 	mGAcrepita = .optcrepita.value
				mevolma2 =  ''
				mevolma2 =  iif(mGAherCX  =1," Heridas quirúrgicas: Si ",iif(mGAherCX  = 2," Heridas quirúrgicas: No ",'' ));
				iif(mecx =1," Limpia ",iif(mecx = 2," Supuración ",iif(mecx = 3," Flogosis ",iif(mecx = 4," Necrosis ",'' )) ));
					+iif(optcrepita =1," Con crepitación ",'' )	+iif(!empty(mevolma2),chr(10),'')
				mevolma = mevolma + mevolma2

				mEIM_GAotrasLes = .txtotrasles.value
				mevolma = mevolma + iif(!empty(mEIM_GAotrasLes ), 'Otras lesiones:'+alltrim(mEIM_GAotrasLes )+chr(10),'')

				mEIM_ALingreso = .txtingre.value
				mEIM_ALdiuresis = .txtdiuresis.value
				mEIM_ALbalance = .txtbalance.value
				mevolma2 =  ''
				mevolma2 =  iif(!empty(mEIM_ALingreso )," Ingreso fluídos 24 hs :"+ alltrim(transform(mEIM_ALingreso ))+ 'ml','' );
					+iif(!empty(mEIM_ALdiuresis )," Diuresis 24 hs:"+alltrim(transform(mEIM_ALdiuresis ))+ 'ml','' );
					+iif(!empty(mEIM_ALbalance )," Balance 24 hs:"+alltrim(transform(mEIM_ALbalance ))+ 'ml','' );
					+iif(!empty(mevolma2),chr(10),'')
				mevolma = mevolma + mevolma2

				mEIM_ALsonda = (.optsves.value = 1 )
				msves = .optsves.value
				msvesfini = .txtsvesfini.value
				msvesdias =	.txtsvesdias.value
				mSVESacc =	.cbosvesacc.value
				mevolma2 =  ''
				do case
					case msves = 1
						mevolma2 = '  Sonda vesical desde:'+transform(msvesfini )+" Días:"+transf(msvesdias ,'999')+" Con acceso:"+.cbosvesacc.displayvalue+ ;
							iif(!empty(.cbocsgcompl.displayvalue), " Complicaciones: "+.cbocsgcompl.displayvalue,'') + chr(10)
					case msves = 2
						mevolma2 = iif(empty(.cbosvesacc.displayvalue), ' Sonda vesical NO ',  ' Sonda vesical desde:'+transform(msvesfini )+' hasta:'+transform(mfechadia)+;
							" Días:"+transf(msvesdias ,'999')+" Con acceso:"+.cbosvesacc.displayvalue) + chr(10)
				endcase
				mevolma = mevolma + mevolma2

				mevolma2 = ''
				mGAsng = .optsng.value
				mEIM_GAsngDeb = .txtsngdeb.value
				mEIM_GAsngTipo = .txtsngtipo.value
				if mGAsng = 1
					mevolma2 = ' SNG SI '+iif(mEIM_GAsngDeb>0," Débito :"+transform(mEIM_GAsngDeb,'999.99'),'')+ ;
						iif(!empty(mEIM_GAsngTipo )," Tipo:"+alltrim(mEIM_GAsngTipo ),'' )+chr(10)
				endif
				mevolma = mevolma + mevolma2

				mEIM_ALdialisis = (.optdial.value = 1)
				mALdialisis = .optdial.value
				mEIM_ALdialPer = .txtdialper.value
				mEIM_ALhemodia = .txthemodial.value
				mEIM_GAtipoHD =  .opttipoHD.value
				mEIM_ALsonda = (.optdial.value = 1 )
				mdialtipo = mEIM_GAtipoHD
				mdial = .optdial.value
				mdialfini = .txtHDfini.value
				mdialdias =	.txtHDdias.value
				mdialffin = iif(empty(.txtHDffin.value) or .txtHDffin.value=ctod("  /  /  "),mfecfin,.txtHDffin.value)
				mdialacc = .cboHDacc.value
				mdialcomp = .cboHDcompl.value
				mHDfini = .txtHDfini.value
				mHDdias =	.txtHDdias.value
				mevolma2 =  ''
				mevolma2 =  iif(mALdialisis =1," Diálisis: Si ",iif(mALdialisis = 2," Diálisis: No ",'' ));
					+iif(!empty(mEIM_ALhemodia ), " Hemodiálisis: "+alltrim(mEIM_ALhemodia ),'') ;
					+iif(!empty(mEIM_ALdialPer ), " Diálisis peritoneal: "+alltrim(mEIM_ALdialPer ),'') ;
					+iif(!empty(mevolma2),chr(10),'')

				mevolma = mevolma + mevolma2
				mevolma2 =  ''
				do case
					case mALdialisis = 1
						mevolma2 = ' Dialisis Tipo :'+iif(mEIM_GAtipoHD =1,.opttipoHD.option1.caption, ;
							iif(mEIM_GAtipoHD =2,.opttipoHD.option2.caption, ''))+;
							" Desde: "+ transform(mHDfini )+" Días:"+transf(msvesdias ,'999')+ chr(10)
					case mALdialisis = 2
						mevolma2 = iif(mEIM_GAtipoHD =0,' Dialisis  NO ', ' Dialisis Tipo :'+iif(mEIM_GAtipoHD =1,.opttipoHD.option1.caption, ;
							iif(mEIM_GAtipoHD =2,.opttipoHD.option2.caption, ''))+;
							' Desde:'+transform(mHDfini )+' hasta:'+transform(mfechadia)+" Días:"+transf(mHDdias ,'999')) + chr(10)
				endcase
				mevolma = mevolma + mevolma2
				mevolm = mevolm +iif(!empty(mevolma),' Ap.Genito Urinario - Abdomen' + chr(10) + mevolma,'')

			endwith
			with .Page6
				select * from mwkatbesquema into cursor mwkctresq  &&where id>0
				select mwkatbesquema
				miesquema = ''
				scan
					if id>40
						midesq = id
						if EATB_fechafin>=ttod(mwkfecserv.fechahora)-1  and EATB_fechafin<mfecfin   && dar de baja
						else
							miesquema  = miesquema +alltrim(EATB_esquema)+"/"
						endif
					else
						if EATB_fechafin = mfecfin
							miesquema  = miesquema +alltrim(EATB_esquema)+"/"

						endif
					endif
				endscan

				mEIM_CATB = (reccount('mwkctresq')>0)
				mCATB = iif(reccount('mwkctresq')>0,1,2)
				mEIM_Cdias = 0
				mEIM_Cesquema = miesquema
				mEIM_Ccultivo = .TxtEd_ed_cultivo.value
				mevolma =  ''
				if mlmodifatb
					mevolma =  iif(mCATB =1," ATB: Si ",iif(mCATB = 2," ATB: No ",'' ))+;
						iif(mCATB >0," Esquema ATB: "+alltrim(miesquema )+ " Cultivo:"+ alltrim(mEIM_Ccultivo )+chr(10),'')
					mevolm = mevolm + mevolma
				endif
			endwith
		endwith
	endwith
	mEIM_evol = mevolm + iif(!empty(mEIM_evol),"Evolución:"+chr(10)+alltrim(mEIM_evol ),'')


	with mopage7.pgindicaciones
		mindnurse = ""
		with .Page1

			mEIM_ALalimenta = (.opttiponut.value=1)
			mALalimenta = .opttiponut.value
			mEIM_ALtipoNut = .CboNuttipo.value
			mevolma =  ''
			mevolma =  iif(mALalimenta =1," Alimentación: Si ",iif(mALalimenta = 2," Alimentación: No ",'' ));
				+iif(!empty(.CboNuttipo.displayvalue), " Tipo: "+.CboNuttipo.displayvalue,'') ;
				+iif(!empty(mevolma),chr(10),'')

			mevolm = mevolm + mevolma
			mEIM_ALcalorias = .txtcalorias.value
			mEIM_ALtolera = .txttolerancia.value
			mEIM_ALfecSusp = iif(empty(.txtNutffin.value) or .txtNutffin.value=ctod("  /  /  "),mfecfin,.txtNutffin.value)
			mEIM_ALmotSusp = .txtmotivo.value
			mevolma2 =  ''
			mevolma2 = iif(mEIM_ALcalorias >0 ," Calorías :"+transform(mEIM_ALcalorias ),'')+ iif(!empty(mEIM_ALtolera )," Tolerancia:"+alltrim(mEIM_ALtolera ),'' );
				+iif(.ChkSusp.value = 1,' Fecha de Suspensión.:'+ttoc(mEIM_ALfecSusp )+ ' Motivo:' +alltrim(mEIM_ALmotSusp ),'');
				+iif(!empty(mevolma2),chr(10),'')
			mevolma = mevolma + mevolma2
			mevolma2 =  ''

			msng = .optsng.value
			msngfini = .txtsngfini.value
			msngdias =	.txtsngdias.value
			msngffin = mfecfin
			msngacc = .cbosngacc.value
			msngcomp = 0
			mEIM_GAsng = (.optsng.value = 1)
			mGAsng = .optsng.value
			mEIM_GAsngDeb = 0&&.txtsngdeb.value
			mEIM_GAsngTipo = ''&&.txtsngtipo.value
			mevolma2 =  ''
			do case
				case msng = 1
					mevolma2 = ' SNG desde:'+transform(msngfini )+" Días:"+transf(msngdias ,'999')+;
						" Con acceso:"+.cbosngacc.displayvalue+;
						iif(mEIM_GAsngDeb>0," Débito :"+transform(mEIM_GAsngDeb,'999.99'),'')+ ;
						iif(!empty(mEIM_GAsngTipo )," Tipo:"+alltrim(mEIM_GAsngTipo ),'' )+chr(10)
				case msng = 2
					mevolma2 = iif(empty(.cbosngacc.displayvalue),'',' SNG desde:'+transform(msngfini )+' hasta:'+transform(msngffin )+" Días:"+transf(msngdias ,'999')+;
						" Con acceso:"+.cbosngacc.displayvalue+ chr(10))
			endcase
			mevolma = mevolma + mevolma2

			mevolm = mevolm +iif(!empty(mevolma),' Nutrición ' + chr(10) + mevolma,'')

		endwith

		with .page2 &&&sueros
		endwith
		with .page3 &&&medicacion
		endwith

		with .page4&&&estudios
		endwith
		with .page5 &&&cuidados
			mEIM_aislamiento = ALLTRIM(.cntAisla.txtAislamiento.value)
			mevolma = mevolma + IIF(!EMPTY(mEIM_aislamiento),"Aislamiento: "+mEIM_aislamiento+CHR(10),'')

			with .Amoverlistas1.Lista2
				mcadprest = 'inlist (id'
				if .listcount>0
					mindnurse = mindnurse + "CUIDADOS COMPLEMENTARIOS:"+chr(10)
					for ip = 1 to .listcount
						mindnurse = mindnurse + alltrim(.list(ip,1))+chr(10)
						mcadprest = mcadprest +","+.list(ip,2)
					next ip
					mcadprest =mcadprest +")"
					select * from mwkindCCDisp where &mcadprest into cursor mwkindCCDind
					do sp_grabo_evol_int_cuim  with midevol
				endif
			endwith
		endwith
		with .page6 &&&akr
			with .Amoverlistas1.Lista2
				mcadprest = 'inlist (id'
				if .listcount>0
					mindnurse = mindnurse + "Asistencia Kinesica y respiratoria:"+chr(10)
					for ip = 1 to .listcount
						mindnurse = mindnurse + alltrim(.list(ip,1))+chr(10)
						mcadprest = mcadprest +","+.list(ip,2)
					next ip
					mcadprest =mcadprest +")"
					select * from mwkindCCDisp where &mcadprest into cursor mwkindCCind
*					do sp_grabo_evol_int_nut  with midevol,alltrim(.TxtedIMAnt.value)
				endif
			endwith
		endwith
		mindnurse  = iif(!empty(alltrim(mindnurse )), ttoc(mfechahora ) + ' ' +;
			iif(used('mwkusuarios'),alltrim(mwkusuarios.idusuario) ,transf(mmedico))+ '->', '') + ;
			alltrim(mindnurse)  &&alltrim(.txteditevol.value) +

	endwith

	with mopage4.pgcontrol.pgCSVMed
		mEI_scrapacheii = .txtscrapache.value
		mEI_scrfisher = .txtscrfisher.value
		mEI_scrhyh	= .txtscrhyh.value
		mEI_scrranson = .txtscrtanson.value
		mEI_scrsofa = .txtscsrofa.value
	endwith
	if mlcambiocsv
		with mopage4.pgcontrol.pgCSVNur
			mhoratoma 	= .txthora.value
			mpartenssis = .txttasist.value
			mpartensdia = .txttadia.value
			mpartam	= .TxtTAM.value
			mparfrecard	= .txtfcard.value
			mparfreresp = .txtfresp.value
			mpartemaxl 	= .txttempax.value
			mparsatur 	= .txtsat.value
			mpargluc 	= .txtgluc.value
			mparpeso 	= .txtpeso.value
			mparalt 	= .txtalt.value
			mparimc 	= .txtimc.value
			mpartembuc 	= .txttempbc.value
			mpartemrct 	= .txttemprt.value
			mparpic 	= .TxtPic.value
		endwith
	endif
	if mlmodifevoln
		with mopage4.pgcontrol.pgCSVNur
			mhoratoma 	= .txthora.value
			mnurse = ' Datos de las '+transform(mhoratoma)+chr(10)
			mpartenssis = .txttasist.value
			mpartensdia = .txttadia.value
			mnurse = mnurse + iif(mpartenssis # 0, 'T.Art.Sistólica mmHg:' + transf(mpartenssis ,'999');
				+ " T.Art.Diastólica mmHg:"+ transf(mpartensdia ,'999') +chr(10),'')
			mpartam	= .TxtTAM.value
			mnurse = mnurse + iif(mpartam# 0, 'TAM:'+ transf(mpartam,'999') + chr(10),'')
			mparfrecard	= .txtfcard.value
			mnurse = mnurse + iif(mparfrecard# 0, 'Frecuencia Cardíaca (latidos x min.):'+ transf(mparfrecard,'999') + chr(10),'')
			mparfreresp = .txtfresp.value
			mnurse = mnurse + iif(mparfreresp # 0, 'Frecuencia Respiratoria (respiración x min.):'+ transf(mparfreresp ,'999') + chr(10),'')
			mpartemaxl 	= .txttempax.value
			mnurse = mnurse + iif(mpartemaxl # 0, 'Tª Axilar (grado centigrado):'+ transf(mpartemaxl ,'99.9') + chr(10),'')
			mparsatur 	= .txtsat.value
			mnurse = mnurse + iif(mparsatur # 0, 'Saturación de O2 en sangre %'+ transf(mparsatur ,'999') + chr(10),'')
			mpargluc 	= .txtgluc.value
			mnurse = mnurse + iif(mpargluc # 0, ' Glucemia:'+ transf(mpargluc ,'9999') + ' mg/dl '+ chr(10),'')
			mparpeso 	= .txtpeso.value
			mnurse = mnurse + iif(mparpeso # 0 and mwkulvalp.valor #mparpeso , ' Peso:'+ transf(mparpeso ,'999.9') +' Kgs '+ chr(10),'')
			mparalt 	= .txtalt.value
			mnurse = mnurse + iif(mparalt # 0 and mwkulvala.valor #mparalt , ' Altura:'+ transf(mparalt ,'999') +' Cm '+ chr(10),'')
			mparimc 	= .txtimc.value
			mnurse = mnurse + iif(mparimc # 0, ' IMC:'+ transf(mparimc ,'999.99') +' '+ chr(10),'')
			mpartembuc 	= .txttempbc.value
			mnurse = mnurse + iif(mpartembuc # 0, ' Tª Bucal:'+ transf(mpartembuc ,'99.9') + chr(10),'')
			mpartemrct 	= .txttemprt.value
			mnurse = mnurse + iif(mpartemrct # 0, ' Tª Rectal:'+ transf(mpartemrct ,'99.9') + chr(10),'')
			mparpic 	= .TxtPic.value
			mnurse = mnurse + iif(mparpic # 0, ' Presión IC:'+ transf(mparpic ,'999') + chr(10),'')
			if .txtglas1.value >0
				mnurse = mnurse + ' Glasgow:'+ transf(.txtglas1.value,'99')+ '/'+transf(.txtglas2.value,'99')+chr(10)
			endif

*!*			mpardiur	= 0 && .OptDiur.value
*!*			if mpardiur	>0
*!*				mnurse = mnurse + ' Diuresis:'+ iif(mpardiur=1,' Positiva ',' Negativa') + chr(10)
*!*				mpardiur	= .txtdiurml.value
*!*				mnurse = mnurse + iif(mpardiur # 0, '  Vol. ml:'+ transf(mpardiur,'9999') + chr(10),'')
*!*				mpardiur	= .txtdiurpeso.value
*!*				mnurse = mnurse + iif(mpardiur # 0, '  Peso mg:'+ transf(mpardiur,'999.9') + chr(10),'')
*!*			endif
		endwith


		mnurse = iif(!empty(mnurse), 'C.S.V. ' + chr(10) + mnurse,'')
		with mopage3.pgnurse.page2
			mparalerg 		= .optalerg.value
			mparalergque 	=.txtalergias.value
			mparadmf = ''
			lhayaf = .f.
			minurse =  " Administración de Fármacos "
			for i = 1 to 11
				cvar = ".Txtf"+transf(i,"@L 99")+".value"
				mfarma = alltrim(&cvar)
				cvar = ".TxtD"+transf(i,"@L 99")+".value"
				mdosis = alltrim(&cvar)
				cvar = ".TxtD"+transf(i,"@L 99")+".enabled"
				cchk = ".Check"+alltrim(transf(i,"@L 99"))+".value"
				mparadmf = mparadmf + transf(&cchk,"9")
				minurse = minurse + iif(&cchk # 0,chr(10) + mfarma + " " + mdosis+ " " + admfar(i),'')
				lhayaf = (lhayaf or &cchk # 0)
			next
			mnurse = mnurse + iif(lhayaf,chr(10)+ minurse ,'')
		endwith

		with mopage3.pgnurse.page3
			mparotros  = ''
			lhayaf     = .f.
			minurse    = "Procedimientos"

			for i = 1 to 3
				cvar = ".TxtP"+transf(i,"@L 99")+".value"
				mdet = alltrim(&cvar)

				cvar = ".Optiongroup"+transf(i,"@L 9")+".value"
				miop = transf(&cvar ,"@L 9")
				if &cvar >0
					cvar = ".Optiongroup"+transf(i,"@L 9")+".option"+miop+".caption"
					mcopt = &cvar
				else
					mcopt = ''
				endif
				cchk       = ".Check"+alltrim(transf(i,"@L 99"))+".value"
				mparotros  = mparotros  + transf(&cchk,"9")
				minurse    = minurse + iif(&cchk # 0,chr(10) + "Se coloca " + pract(i) + " " + mcopt + " " + mdet,'')

				lhayaf = (lhayaf or &cchk # 0)
			next

			for i = 4 to 13
				cvar = ".TxtP"+transf(i,"@L 99")+".value"
				mdet = alltrim(&cvar)

				cchk      = ".Check"+alltrim(transf(i,"@L 99"))+".value"
				mparotros = mparotros  + transf(&cchk,"9")
				minurse   = minurse + iif(&cchk # 0,chr(10) + "Se realiza " + pract(i) + " " + mdet,'')
				lhayaf    = (lhayaf or &cchk # 0)
			next

			mnurse = mnurse + iif(lhayaf,chr(10)+ minurse ,'')

		endwith

		with mopage3.pgnurse.page4
			if .chkpiso.value = 0
				mhorapiso = ''
			else
				mhorapiso = iif(empty(nvl(mwkevolprot.EI_parotros,'')),ttoc(mfechahora ),mwkevolprot.EI_parotros)
			endif

			moptproc = .optprocede.value
			if moptproc > 0
				cvar   = ".OptProcede.option"+ transf(moptproc ,"@L 9") + ".caption"
				mcopt  = &cvar
				mnurse = mnurse + chr(10)+ "Procede de:" + mcopt
			endif

*!*			mopting = .cboMotingreso.value
*!*			if mopting > 0
*!*				cvar   = ".OptIngreso.option"+ transf(mopting,"@L 9") + ".caption"
*!*				mcopt  = &cvar
*!*				mnurse = mnurse + chr(10)+ "Medios: " + mcopt
*!*			endif

			minurse = iif(.chkacomp.value = 1,"Tiene acompañantes ",'')
			mopting = .optacomp.value

			if mopting > 0
				cvar    = ".OptAcomp.option"+ transf(mopting,"@L 9") + ".caption"
				mcopt   = &cvar
				minurse = minurse + chr(9)+ mcopt
			endif
			minurse = minurse + iif(.optacompedad.value = 1,chr(9) + " Mayor de Edad ",;
				iif(.optacompedad.value = 2,chr(9) + " Menor de Edad ",''))

			mnurse = mnurse +iif(!empty(minurse), chr(10)+'Acompañantes:' + chr(10) + minurse,'')

			moptpert = .optpert.value
			if moptpert > 0
				cvar   = ".OptPert.option"+ transf(moptpert ,"@L 9") + ".caption"
				mcopt  = &cvar
				mnurse = mnurse + chr(10)+ "Se entregan pertenencias a:" + mcopt + " - Nombre: "+alltrim(.txtnombre.value)
			endif
			if !empty(mhorapiso)
				mnurse = mnurse + chr(10)+ "Hora de Entrega a Camillero: " + mhorapiso
			endif

		endwith

		with mopage3.pgnurse.page5
			minurse = iif(.chkbaranda.value # 0, 'Colocación de Barandas' + chr(10),'')
			minurse = minurse + iif(.chkcbiopanial.value # 0, 'Cambio de Pañal' + chr(10),'')
			minurse = minurse + iif(.chkcbiorcama.value # 0, 'Cambio de Ropa de Cama' + chr(10),'')
			minurse = minurse + iif(.optcatarsis.value # 0, 'Catarsis ' + ;
				iif(.optcatarsis.value =1,'Positiva','Negativa') + chr(10),'')
			minurse = minurse + iif(.opthigiene.value # 0, 'Higiene ' + ;
				iif(.opthigiene.value = 2,'Parcial','Total') + chr(10),'')
			miop = .optpos.value
			if miop # 0
				cvar = ".OptPos.option"+transf(miop ,"@L 9") +".caption"
				mcopt = &cvar
				minurse = minurse + 'Cuidado de la Piel en posición ' + mcopt + chr(10)
			endif
			mnurse = mnurse + iif(!empty(minurse), chr(10) + " Higiene y Confort " + chr(10) + minurse ,'')
		endwith
	endif
	if musua > 0  && Planilla enfermeria
		megparalerg = 0
		msoloevol = iif(!empty(alltrim(mopage3.txteditevol.value )), ;
			alltrim(mopage3.txteditevol.value ) +chr(10),'') + alltrim(mnurse)
		miedit = iif(!empty(alltrim(mopage3.txteditevol.value + mnurse )), ttoc(mfechahora ) + ' ' +;
			iif(used('mwkusuarios'),alltrim(mwkusuarios.idusuario) ,transf(musua))+ '->', '') + ;
			iif(!empty(alltrim(mopage3.txteditevol.value )), ;
			alltrim(mopage3.txteditevol.value) + chr(10),'')+ alltrim(mnurse)
		mevolnurse 	= alltrim(mopage3.txtedtevol.value)+iif(!empty(alltrim(mopage3.txtedtevol.value)),chr(10),'') + miedit
	else
		miedit = alltrim(mopage3.txteditevol.value) + alltrim(mindnurse )
		mevolnurse 	= alltrim(mopage3.txtedtevol.value)
	endif

endif

mret = sqlexec(mcon1, "SELECT * FROM TabIntEvol " + ;
	" where  EI_idevol = ?midevol ", "mwkVerEvol")
if mret < 0
	=aerr(eros)
	messagebox(eros(3), 48, "Validacion")
endif

if reccount('mwkVerEvol')= 0

	mret = sqlexec(mcon1, "insert into tabintevol " + ;
		" ( EI_evolnurse,EI_fechaHora,EI_idevol,EI_indicNurse,EI_scrapacheii,EI_scrfisher,EI_scrhyh "+;
		",EI_scrranson,EI_scrsofa,EI_usuario)"+;
		" values "+;
		" (?mevolnurse,?mfechahora, ?midevol,?miedit, ?mEI_scrapacheii , ?mEI_scrfisher , ?mEI_scrhyh,"+;
		" ?mEI_scrranson ,?mEI_scrsofa ,?midusuario )" )

	if mret < 0
		messagebox("ERROR EN EL INGRESO"+chr(10)+;
			"AVISE A SISTEMAS",16, "ERROR")
		do log_errores with error(), message(), message(1), program(), lineno()
	endif
else
	midintevol = mwkVerEvol.id
	mevolnursea = nvl(EI_evolnurse,'')
	mevolnursett = nvl(EI_evolnurse,'') + iif(empty(nvl(EI_evolnurse,'')),'',chr(10))+  alltrim(mevolnursea)
	mindictt = nvl(EI_indicNurse,'') + iif(empty(nvl(EI_indicNurse,'')),'',chr(10))+ alltrim(miedit)
	mret = sqlexec(mcon1, "update tabintevol " + ;
		" set  EI_evolnurse = ?mevolnursett ,EI_fechaHora = ?mfechahora,EI_indicNurse = ?mindictt "+;
		" ,EI_scrapacheii = ?mEI_scrapacheii  ,EI_scrfisher = ?mEI_scrfisher ,EI_scrhyh = ?mEI_scrhyh "+;
		",EI_scrranson =?mEI_scrranson ,EI_scrsofa= ?mEI_scrsofa ,EI_usuario = ?midusuario  where id = ?midintevol " )
	if mret < 0
		messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
			"AVISE A SISTEMAS",16, "ERROR")
		do log_errores with error(), message(), message(1), program(), lineno()
	endif

endif

if  musua = 0
	if mlcambioevol
		mret = sqlexec(mcon1, "insert into tabintevolMed " + ;
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
			",EIM_RsatO2,EIM_RtipoResp,EIM_Rtoraco,EIM_Rvt,EIM_CVtensiond ,EIM_Rcanula,EIM_GAtipoHD,EIM_aislamiento   )"+;
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
			", ?mEIM_RsatO2, ?mEIM_RtipoResp, ?mEIM_Rtoraco, ?mEIM_Rvt,?mEIM_CVtensiond ,?mEIM_Rcanula,?mEIM_GAtipoHD,?mEIM_aislamiento   )" )

		if mret < 0
			messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
				"AVISE A SISTEMAS",16, "ERROR")
			do log_errores with error(), message(), message(1), program(), lineno()
		endif



****  actualiza esquemas
		if mlmodifatb

			mret = sqlexec(mcon1, "select ID, EATB_dias, EATB_esquema, EATB_fechafin, EATB_fechaini, EATB_idevol "+;
				" from TabIntEsquemas "+;
				"where EATB_idevol= ?midevol"  , "mwkatbesq")

			select mwkatbesquema
			scan
				if id>40
					midesq = id
					if EATB_fechafin>=ttod(mwkfecserv.fechahora)-1  and EATB_fechafin<mfecfin   && dar de baja
						mfec = EATB_fechafin
						mret = sqlexec(mcon1, "update TabIntEsquemas set EATB_fechafin = ?mfec "+;
							" where Id = ?midesq ")
						if mret < 0
							messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
								"AVISE A SISTEMAS",16, "ERROR")
							do log_errores with error(), message(), message(1), program(), lineno()
						endif
					endif
				else
					if mEATB_fechafin = mfecfin
						mEATB_dias = mwkatbesquema->EATB_dias
						mEATB_esquema = mwkatbesquema->EATB_esquema
						mEATB_fechafin = mwkatbesquema->EATB_fechafin
						mEATB_fechaini = mwkatbesquema->EATB_fechaini
						mret = sqlexec(mcon1, "insert into TabIntEsquemas " + ;
							" ( EATB_dias, EATB_esquema, EATB_fechafin, EATB_fechaini, EATB_idevol)"+;
							" values "+;
							" (?mEATB_dias ,?mEATB_esquema , ?mEATB_fechafin ,?mEATB_fechaini ,?midevol )" )
						if mret < 0
							messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
								"AVISE A SISTEMAS",16, "ERROR")
							do log_errores with error(), message(), message(1), program(), lineno()
						endif
					endif
				endif
			endscan
		endif

****  actualiza ARM
		select mwkARM
		miavn = mwkARM.id
		if mEIM_RARM = .t. and reccount('mwkARM')>0   &&&& da por finalizada
			mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
				" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo=1 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia ")
			if mret < 0
				messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
					"AVISE A SISTEMAS",16, "ERROR")
				do log_errores with error(), message(), message(1), program(), lineno()
			endif
		else &&& actualiza o inserta
			if mEIM_RARM = .t.
				mret = sqlexec(mcon1, "SELECT id FROM TabIntAVN " + ;
					" where  AVN_idevol = ?midevol and AVN_tipo=1 and AVN_fechafin = ?mfecfin ", "mwkVerAVN")
				miavn = mwkVerAVN.id
*!*					if miavn = 0 &&&inserto
				mret = sqlexec(mcon1, "insert into TabIntAVN " + ;
					" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
					" values "+;
					" (?marmcomp  ,?mfecfin, ?mfechahora,?marmfini, ?midevol,?marmmodo, ?marmmot , 1,?midusuario  )" )
				if mret < 0
					messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
						"AVISE A SISTEMAS",16, "ERROR")
					do log_errores with error(), message(), message(1), program(), lineno()
				endif
*!*					else
*!*						if mlcbioARM
*!*							mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   "+;
*!*								" ,AVN_modo = ?marmmodo ,AVN_motivo = ?marmmot , AVN_complica = ?marmcomp  where id = ?miavn ")
*!*						endif
*!*					endif
			endif
		endif
****  actualiza tubo OT
		select mwkToT
		mitot = mwkToT.id
		if mtuboot = 0 and reccount('mwkToT')>0   &&&& da por finalizada
			mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
				" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo=4 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia ")
			if mret < 0
				messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
					"AVISE A SISTEMAS",16, "ERROR")
				do log_errores with error(), message(), message(1), program(), lineno()
			endif
		else &&& actualiza o inserta
			if mtraq = 1
				mret = sqlexec(mcon1, "SELECT id FROM TabIntAVN " + ;
					" where  AVN_idevol = ?midevol and AVN_tipo = 4 and AVN_fechafin = ?mfecfin", "mwkVerAVN")
				mitot = mwkVerAVN.id
*!*					if mitraq = 0 &&&inserto
				mret = sqlexec(mcon1, "insert into TabIntAVN " + ;
					" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
					" values "+;
					" (0,?mfecfin, ?mfechahora,?mtotfini, ?midevol,0,0 , 4,?midusuario  )" )
				if mret < 0
					messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
						"AVISE A SISTEMAS",16, "ERROR")
					do log_errores with error(), message(), message(1), program(), lineno()
				endif
*!*					else
*!*	*					if mtraq = 1
*!*							mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   "+;
*!*								" ,AVN_modo = ?marmmodo ,AVN_motivo = ?marmmot , AVN_complica = ?marmcomp  where id = ?mitraq ")
*!*	*					endif
*!*					endif
			endif
		endif
****  actualiza traq
		select mwkTraq
		mitraq = mwkTraq.id
		if mtraq = 0 and reccount('mwkTraq')>0   &&&& da por finalizada
			mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
				" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo=  5 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia ")
			if mret < 0
				messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
					"AVISE A SISTEMAS",16, "ERROR")
				do log_errores with error(), message(), message(1), program(), lineno()
			endif
		else &&& actualiza o inserta
			if mtraq = 1
				mret = sqlexec(mcon1, "SELECT id FROM TabIntAVN " + ;
					" where  AVN_idevol = ?midevol and AVN_tipo = 5 and AVN_fechafin = ?mfecfin", "mwkVerAVN")
				mitraq = mwkVerAVN.id
*!*					if mitraq = 0 &&&inserto
				mret = sqlexec(mcon1, "insert into TabIntAVN " + ;
					" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
					" values "+;
					" (0,?mfecfin, ?mfechahora,?mtraqfini , ?midevol,0,0 , 5,?midusuario  )" )
				if mret < 0
					messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
						"AVISE A SISTEMAS",16, "ERROR")
					do log_errores with error(), message(), message(1), program(), lineno()
				endif
*!*					else
*!*	*					if mtraq = 1
*!*							mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   "+;
*!*								" ,AVN_modo = ?marmmodo ,AVN_motivo = ?marmmot , AVN_complica = ?marmcomp  where id = ?mitraq ")
*!*	*					endif
*!*					endif
			endif
		endif

****  actualiza PIC
		select mwkPIC
		mipic = mwkPIC.id
		if mipic = 0 and reccount('mwkPIC')>0   &&&& da por finalizada
			mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
				" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo=  9 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia ")
			if mret < 0
				messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
					"AVISE A SISTEMAS",16, "ERROR")
				do log_errores with error(), message(), message(1), program(), lineno()
			endif
		else &&& actualiza o inserta
			if mipic = 1
				mret = sqlexec(mcon1, "SELECT id FROM TabIntAVN " + ;
					" where  AVN_idevol = ?midevol and AVN_tipo = 9 and AVN_fechafin = ?mfecfin", "mwkVerAVN")
				miPIC = mwkVerAVN.id
*				if miPIC = 0 &&&inserto
				mret = sqlexec(mcon1, "insert into TabIntAVN " + ;
					" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
					" values "+;
					" (0,?mfecfin, ?mfechahora,?mfecinipic , ?midevol,0,0 , 9,?midusuario  )" )
				if mret < 0
					messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
						"AVISE A SISTEMAS",16, "ERROR")
					do log_errores with error(), message(), message(1), program(), lineno()
				endif
*!*			else
*!*	*					if mtraq = 1
*!*							mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   "+;
*!*								" ,AVN_modo = ?marmmodo ,AVN_motivo = ?marmmot , AVN_complica = ?marmcomp  where id = ?miPIC ")
*!*	*					endif
*!*					endif
			endif
		endif

****  actualiza VEVP
		select mwkEVP
		mivevp = mwkEVP.id
		if mvevp = 0 and reccount('mwkEVP')>0   &&&& da por finalizada
			mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
				" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo=  6 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia ")
			if mret < 0
				messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
					"AVISE A SISTEMAS",16, "ERROR")
				do log_errores with error(), message(), message(1), program(), lineno()
			endif
		else &&& actualiza o inserta
			if mvevp = 1
				mret = sqlexec(mcon1, "SELECT id FROM TabIntAVN " + ;
					" where  AVN_idevol = ?midevol and AVN_tipo=6 and AVN_fechafin = ?mfecfin ", "mwkVervevp")
				mivevp = mwkVervevp.id
*!*					if miavn = 0 &&&inserto
				mret = sqlexec(mcon1, "insert into TabIntAVN " + ;
					" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
					" values "+;
					" (?mvevpcomp ,?mfecfin, ?mfechahora,?mvevpfini , ?midevol,?mvevpacc , 0, 6,?midusuario  )" )
				if mret < 0
					messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
						"AVISE A SISTEMAS",16, "ERROR")
					do log_errores with error(), message(), message(1), program(), lineno()
				endif
*!*					else
*!*						if mlcbioARM
*!*							mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   "+;
*!*								" ,AVN_modo = ?marmmodo ,AVN_motivo = ?marmmot , AVN_complica = ?marmcomp  where id = ?miavn ")
*!*						endif
*!*					endif
			endif
		endif

****  actualiza VIAC
		select mwkCVC
		mivcac = mwkCVC.id
		if mvc = 0 and reccount('mwkCVC')>0   &&&& da por finalizada
			mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
				" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo=  2 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia ")
			if mret < 0
				messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
					"AVISE A SISTEMAS",16, "ERROR")
				do log_errores with error(), message(), message(1), program(), lineno()
			endif
		else &&& actualiza o inserta
			if mvc = 1
				mret = sqlexec(mcon1, "SELECT id FROM TabIntAVN " + ;
					" where  AVN_idevol = ?midevol and AVN_tipo= 2 and AVN_fechafin = ?mfecfin ", "mwkVerVC")
				mivc = mwkVerVC.id
*!*					if miavn = 0 &&&inserto
				mret = sqlexec(mcon1, "insert into TabIntAVN " + ;
					" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
					" values "+;
					" (?mvccomp ,?mfecfin, ?mfechahora,?mvcfini , ?midevol,?mvcacc , 0, 2,?midusuario  )" )
				if mret < 0
					messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
						"AVISE A SISTEMAS",16, "ERROR")
					do log_errores with error(), message(), message(1), program(), lineno()
				endif
*!*					else
*!*						if mlcbioARM
*!*							mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   "+;
*!*								" ,AVN_modo = ?marmmodo ,AVN_motivo = ?marmmot , AVN_complica = ?marmcomp  where id = ?miavn ")
*!*						endif
*!*					endif
			endif
		endif

****  actualiza CART
		select mwkCART
		micart = mwkCART.id
		if mcart = 0 and reccount('mwkCART')>0   &&&& da por finalizada
			mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
				" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo=  7 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia ")
			if mret < 0
				messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
					"AVISE A SISTEMAS",16, "ERROR")
				do log_errores with error(), message(), message(1), program(), lineno()
			endif
		else &&& actualiza o inserta
			if mcart = 1
				mret = sqlexec(mcon1, "SELECT id FROM TabIntAVN " + ;
					" where  AVN_idevol = ?midevol and AVN_tipo= 7  and AVN_fechafin = ?mfecfin ", "mwkVercart")
				micart = mwkVercart.id
*!*					if miavn = 0 &&&inserto
				mret = sqlexec(mcon1, "insert into TabIntAVN " + ;
					" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
					" values "+;
					" (?mcartcom ,?mfecfin, ?mfechahora,?mcartfini , ?midevol,?mcartacc , 0, 7,?midusuario  )" )
				if mret < 0
					messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
						"AVISE A SISTEMAS",16, "ERROR")
					do log_errores with error(), message(), message(1), program(), lineno()
				endif
*!*					else
*!*						if mlcbioARM
*!*							mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   "+;
*!*								" ,AVN_modo = ?marmmodo ,AVN_motivo = ?marmmot , AVN_complica = ?marmcomp  where id = ?miavn ")
*!*						endif
*!*					endif
			endif
		endif
****  actualiza CSG
		select mwkCSG
		micsg = mwkCSG.id
		if mcsg = 0 and reccount('mwkCSG')>0   &&&& da por finalizada
			mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia  "+;
				" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo=  8 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia ")
			if mret < 0
				messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
					"AVISE A SISTEMAS",16, "ERROR")
				do log_errores with error(), message(), message(1), program(), lineno()
			endif
		else &&& actualiza o inserta
			if mcsg = 1
				mret = sqlexec(mcon1, "SELECT id FROM TabIntAVN " + ;
					" where  AVN_idevol = ?midevol and AVN_tipo= 8  and AVN_fechafin = ?mfecfin ", "mwkVercSG")
				micsg = mwkVercSG.id
*!*					if miavn = 0 &&&inserto
				mret = sqlexec(mcon1, "insert into TabIntAVN " + ;
					" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
					" values "+;
					" (?mcsgcomp ,?mfecfin, ?mfechahora,?mcsgfini , ?midevol,?mcsgacc , 0, 8,?midusuario  )" )
				if mret < 0
					messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
						"AVISE A SISTEMAS",16, "ERROR")
					do log_errores with error(), message(), message(1), program(), lineno()
				endif
*!*					else
*!*						if mlcbioARM
*!*							mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   "+;
*!*								" ,AVN_modo = ?marmmodo ,AVN_motivo = ?marmmot , AVN_complica = ?marmcomp  where id = ?miavn ")
*!*						endif
*!*					endif
			endif
		endif
****  actualiza dialisis
		select mwkHD
		midial = mwkHD.id
		if mdial = 0 and reccount('mwkHD')>0   &&&& da por finalizada
			mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
				" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo=  10 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia ")
			if mret < 0
				messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
					"AVISE A SISTEMAS",16, "ERROR")
				do log_errores with error(), message(), message(1), program(), lineno()
			endif
		else &&& actualiza o inserta
			if mdial = 1
				mret = sqlexec(mcon1, "SELECT id FROM TabIntAVN " + ;
					" where  AVN_idevol = ?midevol and AVN_tipo= 10 and AVN_fechafin = ?mfecfin ", "mwkVerVC")
				mivc = mwkVerVC.id
*!*					if miavn = 0 &&&inserto
				mret = sqlexec(mcon1, "insert into TabIntAVN " + ;
					" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
					" values "+;
					" (?mdialcomp ,?mfecfin, ?mfechahora,?mdialfini , ?midevol,?mdialacc , ?mdialtipo, 10,?midusuario  )" )
				if mret < 0
					messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
						"AVISE A SISTEMAS",16, "ERROR")
					do log_errores with error(), message(), message(1), program(), lineno()
				endif
*!*					else
*!*						if mlcbioARM
*!*							mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   "+;
*!*								" ,AVN_modo = ?marmmodo ,AVN_motivo = ?marmmot , AVN_complica = ?marmcomp  where id = ?miavn ")
*!*						endif
*!*					endif
			endif
		endif




****  actualiza SNG
		select mwkSNG
		miSNG = mwkSNG.id
		if mSNG = 0 and reccount('mwkSNG')>0   &&&& da por finalizada
			mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
				" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo=  3 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia  ")
			if mret < 0
				messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
					"AVISE A SISTEMAS",16, "ERROR")
				do log_errores with error(), message(), message(1), program(), lineno()
			endif
		else &&& actualiza o inserta
			if mSNG = 1
				mret = sqlexec(mcon1, "SELECT id FROM TabIntAVN " + ;
					" where  AVN_idevol = ?midevol and AVN_tipo= 3  and AVN_fechafin = ?mfecfin ", "mwkVerSNG")
				miSNG = mwkVerSNG.id
*!*					if miavn = 0 &&&inserto
				mret = sqlexec(mcon1, "insert into TabIntAVN " + ;
					" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
					" values "+;
					" (?mSNGcomp ,?mfecfin, ?mfechahora,?mSNGfini , ?midevol,?mSNGacc , 0, 3,?midusuario  )" )
				if mret < 0
					messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
						"AVISE A SISTEMAS",16, "ERROR")
					do log_errores with error(), message(), message(1), program(), lineno()
				endif
*!*					else
*!*						if mlcbioARM
*!*							mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   "+;
*!*								" ,AVN_modo = ?marmmodo ,AVN_motivo = ?marmmot , AVN_complica = ?marmcomp  where id = ?miavn ")
*!*						endif
*!*					endif
			endif
		endif
****  actualiza SVES
		select mwkSVES
		miSVES = mwkSVES.id
		if mSVES = 0 and reccount('mwkSVES')>0   &&&& da por finalizada
			mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechafin= ?mfechadia "+;
				" ,AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   where AVN_tipo= 11 and AVN_idevol = ?midevol and AVN_fechafin > ?mfechadia  ")
			if mret < 0
				messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
					"AVISE A SISTEMAS",16, "ERROR")
				do log_errores with error(), message(), message(1), program(), lineno()
			endif
		else &&& actualiza o inserta
			if mSVES = 1
				mret = sqlexec(mcon1, "SELECT id FROM TabIntAVN " + ;
					" where  AVN_idevol = ?midevol and AVN_tipo = 11  and AVN_fechafin = ?mfecfin ", "mwkVerSVES")
				miSVES = mwkVerSVES.id
*!*					if miavn = 0 &&&inserto
				mret = sqlexec(mcon1, "insert into TabIntAVN " + ;
					" ( AVN_complica,AVN_fechafin,AVN_fechaH,AVN_fechaini,AVN_idevol,AVN_modo,AVN_motivo,AVN_tipo,AVN_usuario)"+;
					" values "+;
					" (0,?mfecfin, ?mfechahora,?mSVESfini , ?midevol,?mSVESacc , 0, 11,?midusuario  )" )
				if mret < 0
					messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
						"AVISE A SISTEMAS",16, "ERROR")
					do log_errores with error(), message(), message(1), program(), lineno()
				endif
*!*					else
*!*						if mlcbioARM
*!*							mret = sqlexec(mcon1, "update TabIntAVN set AVN_fechaH = ?mfechahora  ,AVN_usuario = ?midusuario   "+;
*!*								" ,AVN_modo = ?marmmodo ,AVN_motivo = ?marmmot , AVN_complica = ?marmcomp  where id = ?miavn ")
*!*						endif
*!*					endif
			endif
		endif



	else
		if mlmodifevoln
			mret = sqlexec(mcon1, "insert into tabintevolNurse " + ;
				" (EIn_codcienanda , EIn_evolnurse , EIn_fechah , EIn_paradmf , EIn_paralerg , " + ;
				"EIn_paralergque , EIn_parotros , EIN_idevol , EIn_usuario ) values "+;
				" (1, ?msoloevol,?mfechahora ,?mparadmf , ?mparalerg , "+;
				" ?mparalergque , ?mparotros  , ?midevol ,?midusuario   )" )
			if mret < 0
				messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
					"AVISE A SISTEMAS",16, "ERROR")
				do log_errores with error(), message(), message(1), program(), lineno()
			endif

		endif
	endif
endif
if mlmodifresumen
	mret = sqlexec(mcon1, "insert into TabIntResumenHC	 " + ;
		"(RH_fechaHora,RH_idevol,RH_resumen,RH_usuario)  values"+;
		"(?mfechahora ,?midevol,?mresumen,?midusuario  )")
	if mret < 0
		messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
			"AVISE A SISTEMAS",16, "ERROR")
		do log_errores with error(), message(), message(1), program(), lineno()
	endif
endif
if mlmodifIC
	mret = sqlexec(mcon1, "insert into TabIntevolIC 	 " + ;
		"(EIC_fechaHora ,EIC_idevol ,EIC_evolIC ,EIC_usuario )  values"+;
		"(?mfechahora ,?midevol,?mintercons,?midusuario  )")
	if mret < 0
		messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
			"AVISE A SISTEMAS",16, "ERROR")
		do log_errores with error(), message(), message(1), program(), lineno()
	endif
endif
if mlcambiocsv
	mret = sqlexec(mcon1, "insert into TabIntCSV" + ;
		" (ESV_fechah ,ESV_hora ,ESV_parfrecard , ESV_parfreresp , ESV_pargluc ,ESV_parpic ," + ;
		"ESV_parpeso , ESV_parsatur , ESV_partemaxl , ESV_partembuc , ESV_partemrct , " + ;
		"ESV_partensdia , ESV_partenssis , ESV_parTensAM, ESV_idevol, ESV_usuario,ESV_parAltura  "+;
		" ) values "+;
		" (?mfechahora , ?mhoratoma,?mparfrecard,?mparfreresp , ?mpargluc , " +;
		" ?mparpic  , ?mparpeso , ?mparsatur , ?mpartemaxl , ?mpartembuc , ?mpartemrct ,"+;
		" ?mpartensdia , ?mpartenssis , ?mpartam,?midevol,?midusuario ,?mparalt )" )
	if mret < 0
		messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
			"AVISE A SISTEMAS",16, "ERROR")
		do log_errores with error(), message(), message(1), program(), lineno()
	endif
endif


if musua = 0		&&&& datos medicos

	if mwktaltas.tipoest=0 &&and mltipalta<>0
		miestado = mwktaltas.id
		mcodcie10 = mwkcie9.id
		mIH_resumen = mopage6.txteditresumen.value

		mret = sqlexec(mcon1, "update TabIntHCE set IH_horaCierre = ?mfechahora , IH_codestado = ?miestado "+;
			",IH_codmedcie = ?mmedico,IH_codcie = ?mcodcie10,IH_resumen = ?mIH_resumen  "+;
			" where Id = ?midevol ")
		if mret < 0
			messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
				"AVISE A SISTEMAS",16, "ERROR")
			do log_errores with error(), message(), message(1), program(), lineno()
		endif

		with mopage6
			mires = .txteditresumen.value

			select mwkciesec
			scan
				if id>0
					midepi = id
					if IE_fechaHBaja>=ttod(mwkfecserv.fechahora)-1  and IE_fechaHBaja<mfecfin   && dar de baja
						mfec = IE_fechaHBaja
						mret = sqlexec(mcon1, "update TabIntEpi set IE_fechaHBaja = ?mfec "+;
							" where Id = ?midepi ")
						if mret < 0
							messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
								"AVISE A SISTEMAS",16, "ERROR")
							do log_errores with error(), message(), message(1), program(), lineno()
						endif
					endif
				else
					midcie10 = idcie10
&&,IE_patologia
					mret = sqlexec(mcon1, "insert into TabIntEpi " + ;
						" ( IE_codcie ,IE_codmed ,IE_fechaHora,IE_fechaHBaja, IE_idevol ,IE_tipo)"+;
						" values "+;
						" (?midcie10 ,?mmedico, ?mfechahora,?mfecfin ,?midevol,0 )" )
					if mret < 0
						messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
							"AVISE A SISTEMAS",16, "ERROR")
						do log_errores with error(), message(), message(1), program(), lineno()
					endif
				endif
			endscan

**codcie10 ,descrip,idcie10,IE_codcie ,IE_codmed ,IE_patologia,IE_fechaHora,IE_fechaHBaja, IE_idevol ,IE_tipo
			with .CntAntProc.Pageframe1
				for hh = 1 to .pagecount
					cmpage = ".Page"+alltrim(transform(hh))
					with &cmpage
						mpatologia = alltrim(.Txtedit1.value)
						mret = sqlexec(mcon1, "insert into TabIntEpi " + ;
							" ( IE_codcie ,IE_codmed ,IE_fechaHora,IE_fechaHBaja,IE_patologia, IE_idevol ,IE_tipo)"+;
							" values "+;
							" (0 ,?mmedico, ?mfechahora,?mfecfin ,?mpatologia ,?midevol,?hh )" )
						if mret < 0
							messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
								"AVISE A SISTEMAS",16, "ERROR")
							do log_errores with error(), message(), message(1), program(), lineno()
						endif
					endwith
				next hh
			endwith
		endwith
	else
		if mlmedcabe
			mret = sqlexec(mcon1, "update TabIntHCE set IH_motIngreso = ?mIH_motIngreso , IH_procedencia = ?mIH_procedencia "+;
				",ih_codmed = ?mmedico where Id = ?midevol ")
		else
			mret = sqlexec(mcon1, "update TabIntHCE set IH_motIngreso = ?mIH_motIngreso , IH_procedencia = ?mIH_procedencia "+;
				" where Id = ?midevol ")
		endif
		if mlcambioepicris
			miestado = mwktaltas.id
			mcodcie10 = mwkcie9.id
			mIH_resumen = mopage6.txteditresumen.value

			mret = sqlexec(mcon1, "update TabIntHCE set IH_horaCierre = ?mfechahora , IH_codestado = ?miestado "+;
				",IH_codmedcie = ?mmedico,IH_codcie = ?mcodcie10,IH_resumen = ?mIH_resumen  "+;
				" where Id = ?midevol ")
		endif
		if mret < 0
			messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
				"AVISE A SISTEMAS",16, "ERROR")
			do log_errores with error(), message(), message(1), program(), lineno()
		endif
	endif
endif
