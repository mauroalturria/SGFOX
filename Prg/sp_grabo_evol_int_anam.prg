************
*   grabacion de anamnesis dl paciente
**********

Lparameters mpgAnam,midevolhce
lsigue = .T.
With mpgAnam
	If .pgAnDiagno.page1.txtEd_an_impDiag.ReadOnly = .F.
		mia_idevol 		= midevolhce
		mIA_impdiag 	= .pgAnDiagno.page1.txtEd_an_impDiag.Value
		mIA_Planterap 	= .pgAnDiagno.page2.txtEd_an_planT.Value
		mIA_postCX	= .optpostCX.Value

*!* -----------------   Cargamos datos del page pgAnApa ------------------------------------------------------
		With .pgAnApa

*!* -----------------         Octava (primer) Página -----------------------------------------------------------------
			With .page8
				mIA_Gdecubito = .optPos.Value
				mIA_Gfacies = .txtfacies.Value
				mIA_fechahoraIng = .txthing.Value
				mIA_RtipoResp = .txtresp.Value
				mIA_RfrecResp = .txtfr.Value
				mIA_RsatO2 		= .TxtSat.Value
				mIA_CVfrecCar = .txtfc.Value
				mIA_EGimpGral= .optIG.Value
				mIA_EGimpNivel = .optnivel.Value
				mIA_EGdecubitoOP = .optposOB.Value
				mIA_EGTemAxl = .TxtTempAx.Value
				mIA_EGTemBuc = .TxtTempBc.Value
				mIA_EGTemRct = .TxtTempRt.Value
				mIA_CVpresionArt =.txtPA.Value
				mIA_CVpresionArtd = .txtPAd.Value
				mIA_EGfiO2 = .txtfio2.Value
				mIA_CVpvc = .txtpvc.Value
				mIA_EGperfPer = .txtpper.Value
				mIA_EGrellCap = .txtrcap.Value
				mIA_EGevP = .optvevp.Value
				mIA_EGevpAcc = mwkEVPModoa.estado
				mIA_EGevC = .optvia.Value
				mIA_EGevCAcc = mwkEVCModoa.estado
				mIA_Gestable = .OptEstable.Value

			Endwith

*!* -----------------         Primera Página          ------------------------------------------------------
			With .page1
				mIA_Gconstitucion = .txtconst.Value
				mIA_Gpiel = .txtpiel.Value
				mIA_Gfaneras = .txtfaneras.Value
				mIA_GadenoPalp = (.opdadeno.Value = 1)
				mIA_GtcsCant =	.txtcant.Value
				mIA_GedTipo =	.txtedtipo.Value
				mIA_GedColor =	.txtedcolo.Value
				mIA_GedLoc =	.txtedloc.Value
				mIA_Gpiel = .txtpiel.Value
				mIA_GpielCol = .txtpielcol.Value
				mIA_Gulcera = .chkulcera.Value
				mIA_Gcicatriz = .chkcicat.Value

			Endwith
*!* -----------------         Segunda Página -----------------------------------------------------------------
			With .page2
				mIA_CCtipo = .txtconst.Value
				mIA_CChendpalp = .txthp.Value
				mIA_CCconjuntivas = .txtconj.Value
				mIA_CCreflejoOc = Transform(.optro1.Value,"@L 9") + Transform(.optro2.Value,"@L 9") + Transform(.chkro3.Value,"@L 9");
					+ Transform(.optro4.Value,"@L 9") + Transform(.chkro5.Value,"@L 9") + Transform(.chkro6.Value,"@L 9")
				mIA_CCojos = Transform(.chkojo1.Value,"@L 9") + Transform(.chkojo2.Value,"@L 9") + Transform(.chkojo3.Value,"@L 9");
					+ Transform(.chkojo4.Value,"@L 9") + Transform(.chkojo5.Value,"@L 9")
				mIA_CCfdoojo = .txtfdo.Value
				mIA_CCfosasNas = .txtfosa.Value
				mIA_CCboca = .txtboca.Value
				mIA_CCoido = .txtoido.Value
				mIA_CCingYug = .txtiy.Value
				mIA_CClatVen = .txtlv.Value
				mIA_CClatCar = .txtlcar.Value
				mIA_CCsoplo = .txtsoplo.Value
				mIA_CCtiroides = .txttiroi.Value
				mIA_CCotro = .txtotro.Value
				mIA_CCpupilas = mwkANPupilas.estado
				mIA_CCmucosas = mwkANMucosa.estado
			Endwith
			Select mwkanam
*!* -----------------         Tercera Página -----------------------------------------------------------------
			With .page3
				mIA_RtipoTorax = .txttorax.Value
				mIA_Rinspeccion = .txtinsp.Value
				mIA_Rpalpacion = .txtpalp.Value
				mIA_Rpercusion = .txtperc.Value
				mIA_Rauscultacion = .txtausc.Value
				mIA_EGtraq = .chkTraq.Value
				mIA_EGtorac = .chktora.Value
				mIA_EGdrenP = .optdrenpleu.Value
				mIA_EGdrenPAcc = mwkDPModo.estado
			Endwith
*!* -----------------         Cuarta Página -----------------------------------------------------------------
			With .page4
				mIA_CVlcVis = .chklcvis.Value
				mIA_CVlcPal = .chklcpal.Value
				mIA_CVsoplo = .chkSoplo.Value
				mIA_CVsoploLoc = .txtsoploLoc.Value
				mIA_CVsoploInt = .txtsoploInt.Value
				mIA_CVlatcarp = .txtlcp.Value
				mIA_CVpulsoRad = .txtperc.Value
				mIA_CVcaract = .txtcaract.Value
				mIA_CVpulsosPerif = .txtpp.Value
				mIA_CVr1o = .optr1.Value
				mIA_CVr2o =  .optr2.Value
				mIA_CVr3o = .optr3.Value
				mIA_CVr3g = .optr3g.Value
				mIA_CVr4o = .optr4.Value
				mIA_CVsistole = .txtsis.Value
				mIA_CVdiastole = .txtdias.Value
				mIA_CVfrotes = .chkfrotes.Value
				mIA_CVfrem = .chkfrem.Value
			Endwith
*!* -----------------         Quinta Página -----------------------------------------------------------------
			With .page5
				mIA_AGinspeccion = .txtinsp.Value
				mIA_AGdrenaje = .txtresp.Value
				mIA_AGinsp = .optinsp.Value
				mIA_AGpalp = .optpalpa.Value
				mIA_AGdolor = .optdolor.Value
				mIA_AGhigado = .txthig.Value
				mIA_AGptosU = .optPure.Value
				mIA_AGAGtacto = .txttr.Value
				mIA_AGasc = .chkAsc.Value
				mIA_AGbazo = .optBazo.Value
				mIA_AGRHA = (.optRha.Value = 1)
				mIA_AGPPL = (.optPPL.Value = 1)
				mIA_EGSNG = .ChkSNG.Value
				mIA_EGSV = .chksv.Value

			Endwith
*!* -----------------         Sexta Página -----------------------------------------------------------------
			With .page6
				mIA_locomotor = .txtEd_an_loc.Value
			Endwith
*!* -----------------         Séptima Página -----------------------------------------------------------------
			With .page7
				mIA_NSconciencia  = mwkANConciencia.estado
				mIA_NSparesCran = .txtpares.Value
				mIA_NSGmot = .txtgmot.Value
				mIA_NSGver = .txtgver.Value
				mIA_NSGocu = .txtgocu.Value
				mIA_NSmovVol = Transform(.chkmvsd.Value,"@L 9") + Transform(.chkmvsi.Value,"@L 9") ;
					+ Transform(.chkmvid.Value,"@L 9") + Transform(.chkmvii.Value,"@L 9")
				mIA_NSmovPas = Transform(.chkmpsd.Value,"@L 9") + Transform(.chkmpsi.Value,"@L 9") ;
					+ Transform(.chkmpid.Value,"@L 9") + Transform(.chkmpii.Value,"@L 9")
				mIA_NSreflejoOst = Transform(.chkrosd.Value,"@L 9") + Transform(.chkrosi.Value,"@L 9") ;
					+ Transform(.chkroid.Value,"@L 9") + Transform(.chkroii.Value,"@L 9")
				mIA_NSsensib  = Transform(.chkssd.Value,"@L 9") + Transform(.chkssi.Value,"@L 9") ;
					+ Transform(.chksid.Value,"@L 9") + Transform(.chksii.Value,"@L 9")
				mIA_NScabGral = Transform(.chkcga.Value,"@L 9") + Transform(.chkcgp.Value,"@L 9") ;
					+ Transform(.chkcgr.Value,"@L 9") + Transform(.chkcgrf.Value,"@L 9");
					+ Transform(.chkcgs.Value,"@L 9") + Transform(.chkcgsf.Value,"@L 9")+ + Transform(.chkbabin.Value,"@L 9")


				mIA_NStaxia = .txttaxia.Value
				mIA_NSpraxia = .txtpraxia.Value

				mIA_NSnivSens = .txtNivsens.Value
				mIA_NSctrlEsf = .chkce.Value
				mIA_NSsgExP = .chksep.Value
				mIA_NSsgMen = .chksm.Value
				mIA_NStaxiao = .chktax.Value
				mIA_NSpraxiao = .chkprax.Value
				mIA_NSprosexia = .chkpros.Value
				mIA_NSamnesia = .chkamn.Value
				mIA_NSpsiquis = .txtpsi.Value
				mIA_NSpsiq1  = .chkexc.Value
				mIA_NSpsiq2 = .chkdep.Value
				mIA_NSpsiq3 = .chkans.Value
				mIA_NSpsiq4 = .chkbrad.Value
				mIA_NSpsiq5 = .chkabul.Value
			Endwith
		Endwith
	Else
		lsigue = .F.
	Endif
Endwith
If 	lsigue
	mIA_AGpalpacion = ''
	mIA_CVausculta = ''
	mIA_CVinspeccion = ''
	mIA_CVlatcar = ''
	mIA_CVpalpacion = ''
	mIA_CVr1 = ''
	mIA_CVr2 = ''
	mIA_CVr3 = ''
	mIA_CVr4 = ''
	mIA_Gotro = ''
	mIA_GtejidoSubc = ''
	mIA_NSotro = ''
	mIA_NSsignosMen = ''
	mIA_EGfascies = ''
	mIA_EGtipoResp = ''
	mIA_NSflexorP = .F.
	mIA_NSreflejoCA = .F.
	mIA_fechahora = mwkfecserv.fechahora
	mret = SQLExec(mcon1, "SELECT id FROM TabIntAnam " + ;
		" where IA_idevol = ?midevolhce ", "mwkVerana")

	If mret < 0
		=Aerr(eros)
		Messagebox(eros(3), 48, "Validacion")
	Endif

	If Reccount('mwkVerana')= 0
&& IA_CVsoplo = ?mIA_CVsoplo
		mret = SQLExec(mcon1, "insert into TabIntAnam " + ;
			"(IA_AGAGtacto,IA_AGbazo,IA_AGdrenaje,IA_AGhigado,IA_AGinspeccion,IA_AGpalpacion,IA_AGPPL,IA_AGRHA,IA_CCboca,"+;
			"IA_CCconjuntivas,IA_CCfdoojo,IA_CCfosasNas,IA_CChendpalp,IA_CCingYug,IA_CClatCar,IA_CClatVen,IA_CCmucosas,"+;
			"IA_CCoido,IA_CCotro,IA_CCpupilas,IA_CCreflejoOc,IA_CCsoplo,IA_CCtipo,IA_CCtiroides,IA_CVausculta,IA_CVcaract,"+;
			"IA_CVdiastole,IA_CVfrecCar,IA_CVinspeccion,IA_CVlatcar,IA_CVlatcarp,IA_CVpalpacion,IA_CVpresionArt,IA_CVpulsoRad,"+;
			"IA_CVpulsosPerif,IA_CVpvc,IA_CVr1,IA_CVr2,IA_CVr3,IA_CVr4,IA_CVsistole,IA_GadenoPalp,IA_Gconstitucion,IA_Gdecubito,"+;
			"IA_Gfacies,IA_Gfaneras,IA_Gotro,IA_Gpiel,IA_GtejidoSubc,IA_idevol,IA_impDiag,IA_locomotor,IA_NSconciencia,"+;
			"IA_NSflexorP,IA_NSGmot,IA_NSGocu,IA_NSGver,IA_NSmovVol,IA_NSmovPas,IA_NSotro,IA_NSparesCran,IA_NSpraxia,IA_NSpsiq1,IA_NSpsiq2,"+;
			"IA_NSpsiq3,IA_NSpsiq4,IA_NSpsiq5,IA_NSpsiquis,IA_NSreflejoCA,IA_NSreflejoOst,IA_NSsensib,IA_NSsignosMen,IA_NStaxia,"+;
			"IA_planTerap,IA_Rauscultacion,IA_RfrecResp,IA_Rinspeccion,IA_Rpalpacion,IA_Rpercusion,IA_RtipoResp,IA_RtipoTorax,"+;
			"IA_CVpresionArtd ,IA_RsatO2,IA_CVsoplo, IA_AGasc , IA_AGdolor , IA_AGinsp , IA_AGpalp , IA_AGptosU , IA_CCojos,"+;
			"IA_CVfrem , IA_CVfrotes , IA_CVlcPal , IA_CVlcVis , IA_CVr1o , IA_CVr2o , IA_CVr3g , IA_CVr3o , IA_CVr4o,"+;
			"IA_CVsoploInt , IA_CVsoploLoc , IA_EGdecubitoOP , IA_EGdrenP ,IA_EGdrenPAcc , IA_EGevC , IA_EGevCAcc , IA_EGevP,"+;
			"IA_EGevpAcc , IA_EGfascies , IA_EGfiO2 , IA_EGimpGral , IA_EGimpNivel , IA_EGperfPer , IA_EGrellCap , IA_EGSNG,"+;
			"IA_EGSV , IA_EGTemAxl , IA_EGTemBuc , IA_EGTemRct , IA_EGtipoResp , IA_EGtorac , IA_EGtraq , IA_Gcicatriz , "+;
			"IA_GedColor , IA_GedLoc , IA_GedTipo , IA_GpielCol , IA_GtcsCant , IA_Gulcera , IA_NSamnesia , IA_NScabGral ,"+;
			"IA_NSctrlEsf , IA_NSnivSens , IA_NSpraxiao , IA_NSprosexia , IA_NSsgExP , IA_NSsgMen , IA_NStaxiao,IA_Gestable,"+;
			" IA_postCX, IA_fechahora	 )"+;
			" values (?mIA_AGAGtacto, ?mIA_AGbazo, ?mIA_AGdrenaje, ?mIA_AGhigado, ?mIA_AGinspeccion, ?mIA_AGpalpacion, ?mIA_AGPPL"+;
			", ?mIA_AGRHA, ?mIA_CCboca, ?mIA_CCconjuntivas, ?mIA_CCfdoojo, ?mIA_CCfosasNas, ?mIA_CChendpalp, ?mIA_CCingYug"+;
			", ?mIA_CClatCar, ?mIA_CClatVen, ?mIA_CCmucosas, ?mIA_CCoido, ?mIA_CCotro, ?mIA_CCpupilas, ?mIA_CCreflejoOc,"+;
			" ?mIA_CCsoplo, ?mIA_CCtipo, ?mIA_CCtiroides, ?mIA_CVausculta, ?mIA_CVcaract, ?mIA_CVdiastole, ?mIA_CVfrecCar"+;
			", ?mIA_CVinspeccion, ?mIA_CVlatcar, ?mIA_CVlatcarp, ?mIA_CVpalpacion, ?mIA_CVpresionArt, ?mIA_CVpulsoRad, "+;
			"?mIA_CVpulsosPerif, ?mIA_CVpvc, ?mIA_CVr1, ?mIA_CVr2, ?mIA_CVr3, ?mIA_CVr4, ?mIA_CVsistole, ?mIA_GadenoPalp"+;
			", ?mIA_Gconstitucion, ?mIA_Gdecubito,?mIA_Gfacies, ?mIA_Gfaneras, ?mIA_Gotro, ?mIA_Gpiel, ?mIA_GtejidoSubc"+;
			", ?mIA_idevol, ?mIA_impDiag, ?mIA_locomotor, ?mIA_NSconciencia, ?mIA_NSflexorP, ?mIA_NSGmot, ?mIA_NSGocu"+;
			", ?mIA_NSGver, ?mIA_NSmovVol, ?mIA_NSmovPas, ?mIA_NSotro, ?mIA_NSparesCran, ?mIA_NSpraxia, ?mIA_NSpsiq1, ?mIA_NSpsiq2, "+;
			"?mIA_NSpsiq3, ?mIA_NSpsiq4, ?mIA_NSpsiq5, ?mIA_NSpsiquis, ?mIA_NSreflejoCA, ?mIA_NSreflejoOst, ?mIA_NSsensib"+;
			", ?mIA_NSsignosMen, ?mIA_NStaxia,?mIA_planTerap, ?mIA_Rauscultacion, ?mIA_RfrecResp, ?mIA_Rinspeccion"+;
			", ?mIA_Rpalpacion, ?mIA_Rpercusion, ?mIA_RtipoResp, ?mIA_RtipoTorax,?mIA_CVpresionArtd ,?mIA_RsatO2,?mIA_CVsoplo "+;
			", ?mIA_AGasc , ?mIA_AGdolor , ?mIA_AGinsp , ?mIA_AGpalp , ?mIA_AGptosU , ?mIA_CCojos,"+;
			"?mIA_CVfrem , ?mIA_CVfrotes , ?mIA_CVlcPal , ?mIA_CVlcVis , ?mIA_CVr1o , ?mIA_CVr2o , ?mIA_CVr3g , ?mIA_CVr3o , ?mIA_CVr4o,"+;
			"?mIA_CVsoploInt , ?mIA_CVsoploLoc , ?mIA_EGdecubitoOP , ?mIA_EGdrenP ,?mIA_EGdrenPAcc , ?mIA_EGevC , ?mIA_EGevCAcc , ?mIA_EGevP,"+;
			"?mIA_EGevpAcc , ?mIA_EGfascies , ?mIA_EGfiO2 , ?mIA_EGimpGral , ?mIA_EGimpNivel , ?mIA_EGperfPer , ?mIA_EGrellCap , ?mIA_EGSNG,"+;
			"?mIA_EGSV , ?mIA_EGTemAxl , ?mIA_EGTemBuc , ?mIA_EGTemRct , ?mIA_EGtipoResp , ?mIA_EGtorac , ?mIA_EGtraq , ?mIA_Gcicatriz , "+;
			"?mIA_GedColor , ?mIA_GedLoc , ?mIA_GedTipo , ?mIA_GpielCol , ?mIA_GtcsCant , ?mIA_Gulcera , ?mIA_NSamnesia , ?mIA_NScabGral ,"+;
			"?mIA_NSctrlEsf , ?mIA_NSnivSens , ?mIA_NSpraxiao , ?mIA_NSprosexia , ?mIA_NSsgExP , ?mIA_NSsgMen , ?mIA_NStaxiao , ?mIA_Gestable , "+;
			"?mIA_postCX ,?mIA_fechahora  )")

		If mret < 0
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Endif

		mret = SQLExec(mcon1, "update TabIntAnam set IA_fechahoraIng  = ?mIA_fechahoraIng  where IA_idevol = ?midevolhce ")

		If mret < 0
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Endif
	Else
		mret = SQLExec(mcon1, "update TabIntAnam set IA_fechahoraIng  = ?mIA_fechahoraIng  where IA_idevol = ?midevolhce ")
		If mret < 0
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Endif

		mret = SQLExec(mcon1, "update TabIntAnam set " + ;
			"IA_AGAGtacto = ?mIA_AGAGtacto, IA_AGbazo = ?mIA_AGbazo, IA_AGdrenaje = ?mIA_AGdrenaje,"+;
			" IA_AGinspeccion = ?mIA_AGinspeccion, IA_AGpalpacion = ?mIA_AGpalpacion,"+;
			" IA_AGPPL = ?mIA_AGPPL, IA_AGRHA = ?mIA_AGRHA,  IA_CCboca = ?mIA_CCboca,"+;
			" IA_CCconjuntivas = ?mIA_CCconjuntivas, IA_CCfdoojo = ?mIA_CCfdoojo, IA_CCfosasNas = ?mIA_CCfosasNas,"+;
			" IA_CChendpalp = ?mIA_CChendpalp, IA_CCingYug = ?mIA_CCingYug, IA_CClatCar = ?mIA_CClatCar, "+;
			" IA_CClatVen = ?mIA_CClatVen, IA_CCmucosas = ?mIA_CCmucosas ,IA_CCoido = ?mIA_CCoido, IA_CCotro = ?mIA_CCotro,"+;
			" IA_CCpupilas = ?mIA_CCpupilas, IA_CCreflejoOc = ?mIA_CCreflejoOc, IA_CCsoplo = ?mIA_CCsoplo, IA_CCtipo = ?mIA_CCtipo , "+;
			" IA_CCtiroides = ?mIA_CCtiroides, IA_CVausculta = ?mIA_CVausculta, IA_CVcaract = ?mIA_CVcaract, "+;
			" IA_CVdiastole = ?mIA_CVdiastole, IA_CVfrecCar = ?mIA_CVfrecCar, IA_CVinspeccion = ?mIA_CVinspeccion,"+;
			" IA_CVlatcar = ?mIA_CVlatcar,IA_CVlatcarp = ?mIA_CVlatcarp, IA_CVpalpacion = ?mIA_CVpalpacion,IA_CVsoplo = ?mIA_CVsoplo, "+;
			" IA_CVpresionArt = ?mIA_CVpresionArt, IA_CVpulsoRad = ?mIA_CVpulsoRad ,IA_CVpulsosPerif = ?mIA_CVpulsosPerif,"+;
			" IA_CVpvc = ?mIA_CVpvc, IA_CVr1 = ?mIA_CVr1, IA_CVr2 = ?mIA_CVr2, IA_CVr3 = ?mIA_CVr3, IA_CVr4 = ?mIA_CVr4,  "+;
			" IA_CVsistole = ?mIA_CVsistole, IA_GadenoPalp = ?mIA_GadenoPalp, IA_Gconstitucion = ?mIA_Gconstitucion, "+;
			" IA_Gdecubito = ?mIA_Gdecubito,IA_Gfacies = ?mIA_Gfacies, IA_Gfaneras = ?mIA_Gfaneras, IA_Gotro = ?mIA_Gotro, "+;
			" IA_Gpiel = ?mIA_Gpiel, IA_GtejidoSubc = ?mIA_GtejidoSubc, IA_idevol = ?mIA_idevol,  IA_impDiag = ?mIA_impDiag, "+;
			" IA_locomotor = ?mIA_locomotor, IA_NSconciencia = ?mIA_NSconciencia ,IA_NSflexorP = ?mIA_NSflexorP,"+;
			" IA_NSGmot = ?mIA_NSGmot, IA_NSGocu = ?mIA_NSGocu, IA_NSGver = ?mIA_NSGver, IA_NSmovVol = ?mIA_NSmovVol, IA_NSmovPas = ?mIA_NSmovPas, "+;
			" IA_NSotro = ?mIA_NSotro, IA_NSparesCran = ?mIA_NSparesCran, IA_NSpraxia = ?mIA_NSpraxia, IA_NSpsiq1 = ?mIA_NSpsiq1,"+;
			" IA_NSpsiq2 = ?mIA_NSpsiq2,IA_NSpsiq3 = ?mIA_NSpsiq3 , IA_NSpsiq4 = ?mIA_NSpsiq4 , IA_NSpsiq5 = ?mIA_NSpsiq5, "+;
			" IA_NSpsiquis = ?mIA_NSpsiquis , IA_NSreflejoCA = ?mIA_NSreflejoCA ,  IA_NSreflejoOst = ?mIA_NSreflejoOst, "+;
			" IA_NSsensib = ?mIA_NSsensib, IA_NSsignosMen = ?mIA_NSsignosMen, IA_NStaxia = ?mIA_NStaxia, "+;
			" IA_planTerap = ?mIA_planTerap , IA_Rauscultacion = ?mIA_Rauscultacion , IA_RfrecResp = ?mIA_RfrecResp, "+;
			" IA_Rinspeccion = ?mIA_Rinspeccion  ,  IA_Rpalpacion = ?mIA_Rpalpacion, IA_Rpercusion = ?mIA_Rpercusion,"+;
			" IA_RtipoResp = ?mIA_RtipoResp, IA_RtipoTorax = ?mIA_RtipoTorax ,IA_CVpresionArtd = ?mIA_CVpresionArtd, IA_RsatO2 = ?mIA_RsatO2,  "+;
			" IA_AGasc = ?mIA_AGasc , IA_AGdolor = ?mIA_AGdolor , IA_AGinsp = ?mIA_AGinsp , IA_AGpalp = ?mIA_AGpalp , IA_AGptosU = ?mIA_AGptosU ,"+;
			" IA_CCojos = ?mIA_CCojos,IA_CVfrem = ?mIA_CVfrem , IA_CVfrotes = ?mIA_CVfrotes , IA_CVlcPal = ?mIA_CVlcPal , IA_CVlcVis = ?mIA_CVlcVis ,"+;
			" IA_CVr1o = ?mIA_CVr1o , IA_CVr2o = ?mIA_CVr2o , IA_CVr3g = ?mIA_CVr3g , IA_CVr3o = ?mIA_CVr3o , IA_CVr4o = ?mIA_CVr4o,"+;
			" IA_CVsoploInt = ?mIA_CVsoploInt , IA_CVsoploLoc = ?mIA_CVsoploLoc , IA_EGdecubitoOP = ?mIA_EGdecubitoOP , IA_EGdrenP = ?mIA_EGdrenP ,"+;
			" IA_EGdrenPAcc= ?mIA_EGdrenPAcc , IA_EGevC = ?mIA_EGevC , IA_EGevCAcc = ?mIA_EGevCAcc , IA_EGevP = ?mIA_EGevP,"+;
			" IA_EGevpAcc = ?mIA_EGevpAcc , IA_EGfascies = ?mIA_EGfascies , IA_EGfiO2 = ?mIA_EGfiO2 , IA_EGimpGral = ?mIA_EGimpGral ,"+;
			" IA_EGimpNivel = ?mIA_EGimpNivel , IA_EGperfPer = ?mIA_EGperfPer , IA_EGrellCap = ?mIA_EGrellCap , IA_EGSNG = ?mIA_EGSNG,"+;
			" IA_EGSV = ?mIA_EGSV , IA_EGTemAxl = ?mIA_EGTemAxl , IA_EGTemBuc = ?mIA_EGTemBuc , IA_EGTemRct = ?mIA_EGTemRct ,"+;
			" IA_EGtipoResp = ?mIA_EGtipoResp , IA_EGtorac = ?mIA_EGtorac , IA_EGtraq = ?mIA_EGtraq , IA_Gcicatriz = ?mIA_Gcicatriz , "+;
			" IA_GedColor = ?mIA_GedColor , IA_GedLoc = ?mIA_GedLoc , IA_GedTipo = ?mIA_GedTipo , IA_GpielCol = ?mIA_GpielCol ,"+;
			" IA_GtcsCant = ?mIA_GtcsCant , IA_Gulcera = ?mIA_Gulcera , IA_NSamnesia = ?mIA_NSamnesia , IA_NScabGral  = ?mIA_NScabGral ,"+;
			" IA_NSctrlEsf = ?mIA_NSctrlEsf , IA_NSnivSens = ?mIA_NSnivSens , IA_NSpraxiao = ?mIA_NSpraxiao , IA_NSprosexia = ?mIA_NSprosexia ,"+;
			" IA_NSsgExP = ?mIA_NSsgExP , IA_NSsgMen = ?mIA_NSsgMen , IA_NStaxiao = ?mIA_NStaxiao ,IA_Gestable = ?mIA_Gestable , IA_postCX	= ?mIA_postCX "+;
			" ,IA_AGhigado = ?mIA_AGhigado  where IA_idevol = ?midevolhce ")

		If mret < 0
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Endif

	Endif
Endif
Use In Select('mwkVerana')
