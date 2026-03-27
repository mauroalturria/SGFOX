************
*   grabacion de anamnesis dl paciente
**********

lparameters mpgAnam,midevolhce
with mpgAnam
	mia_idevol 		= midevolhce
	mIA_impdiag 	= .pgAnDiagno.page1.txtEd_an_impDiag.value
	mIA_Planterap 	= .pgAnDiagno.page2.txtEd_an_planT.value
	mIA_postCX	= .optpostCX.value

*!* -----------------   Cargamos datos del page pgAnApa ------------------------------------------------------
	with .pgAnApa

*!* -----------------         Octava (primer) Página -----------------------------------------------------------------
		with .page8
			mIA_Gdecubito = .optPos.value
			mIA_Gfacies = .txtfacies.value
			mIA_RtipoResp = .txtresp.value
			mIA_RfrecResp = .txtfr.value
			mIA_RsatO2 		= .TxtSat.value
			mIA_CVfrecCar = .txtfc.value
			mIA_EGimpGral= .optIG.value
			mIA_EGimpNivel = .optnivel.value
			mIA_EGdecubitoOP = .optposOB.value
			mIA_EGTemAxl = .TxtTempAx.value
			mIA_EGTemBuc = .TxtTempBc.value
			mIA_EGTemRct = .TxtTempRt.value
			mIA_CVpresionArt =.txtPA.value
			mIA_CVpresionArtd = .txtPAd.value
			mIA_EGfiO2 = .txtfio2.value
			mIA_CVpvc = .txtpvc.value
			mIA_EGperfPer = .txtpper.value
			mIA_EGrellCap = .txtrcap.value
			mIA_EGevP = .optvevp.value
			mIA_EGevpAcc = mwkEVPModoa.estado
			mIA_EGevC = .optvia.value
			mIA_EGevCAcc = mwkEVCModoa.estado
			mIA_Gestable = .OptEstable.value 

		endwith

*!* -----------------         Primera Página          ------------------------------------------------------
		with .page1
			mIA_Gconstitucion = .txtconst.value
			mIA_Gpiel = .txtpiel.value
			mIA_Gfaneras = .txtfaneras.value
			mIA_GadenoPalp = (.opdadeno.value = 1)
			mIA_GtcsCant =	.txtcant.value
			mIA_GedTipo =	.txtedtipo.value
			mIA_GedColor =	.txtedcolo.value
			mIA_GedLoc =	.txtedloc.value
			mIA_Gpiel = .txtpiel.value
			mIA_GpielCol = .txtpielcol.value
			mIA_Gulcera = .chkulcera.value
			mIA_Gcicatriz = .chkcicat.value

		endwith
*!* -----------------         Segunda Página -----------------------------------------------------------------
		with .page2
			mIA_CCtipo = .txtconst.value
			mIA_CChendpalp = .txthp.value
			mIA_CCconjuntivas = .txtconj.value
			mIA_CCreflejoOc = transform(.optro1.value,"@L 9") + transform(.optro2.value,"@L 9") + transform(.chkro3.value,"@L 9");
				+ transform(.optro4.value,"@L 9") + transform(.chkro5.value,"@L 9") + transform(.chkro6.value,"@L 9")
			mIA_CCojos = transform(.chkojo1.value,"@L 9") + transform(.chkojo2.value,"@L 9") + transform(.chkojo3.value,"@L 9");
				+ transform(.chkojo4.value,"@L 9") + transform(.chkojo5.value,"@L 9")
			mIA_CCfdoojo = .txtfdo.value
			mIA_CCfosasNas = .txtfosa.value
			mIA_CCboca = .txtboca.value
			mIA_CCoido = .txtoido.value
			mIA_CCingYug = .txtiy.value
			mIA_CClatVen = .txtlv.value
			mIA_CClatCar = .txtlcar.value
			mIA_CCsoplo = .txtsoplo.value
			mIA_CCtiroides = .txttiroi.value
			mIA_CCotro = .txtotro.value
			mIA_CCpupilas = mwkANPupilas.estado
			mIA_CCmucosas = mwkANMucosa.estado
		endwith
		select mwkanam
*!* -----------------         Tercera Página -----------------------------------------------------------------
		with .page3
			mIA_RtipoTorax = .txttorax.value
			mIA_Rinspeccion = .txtinsp.value
			mIA_Rpalpacion = .txtpalp.value
			mIA_Rpercusion = .txtperc.value
			mIA_Rauscultacion = .txtausc.value
			mIA_EGtraq = .chkTraq.value
			mIA_EGtorac = .chktora.value
			mIA_EGdrenP = .optdrenpleu.value
			mIA_EGdrenPAcc = mwkDPModo.estado
		endwith
*!* -----------------         Cuarta Página -----------------------------------------------------------------
		with .page4
			mIA_CVlcVis = .chklcvis.value
			mIA_CVlcPal = .chklcpal.value
			mIA_CVsoplo = .chkSoplo.value
			mIA_CVsoploLoc = .txtsoploLoc.value
			mIA_CVsoploInt = .txtsoploInt.value
			mIA_CVlatcarp = .txtlcp.value
			mIA_CVpulsoRad = .txtperc.value
			mIA_CVcaract = .txtcaract.value
			mIA_CVpulsosPerif = .txtpp.value
			mIA_CVr1o = .optr1.value
			mIA_CVr2o =  .optr2.value
			mIA_CVr3o = .optr3.value
			mIA_CVr3g = .optr3g.value
			mIA_CVr4o = .optr4.value
			mIA_CVsistole = .txtsis.value
			mIA_CVdiastole = .txtdias.value
			mIA_CVfrotes = .chkfrotes.value
			mIA_CVfrem = .chkfrem.value
		endwith
*!* -----------------         Quinta Página -----------------------------------------------------------------
		with .page5
			mIA_AGinspeccion = .txtinsp.value
			mIA_AGdrenaje = .txtresp.value
			mIA_AGinsp = .optinsp.value
			mIA_AGpalp = .optpalpa.value
			mIA_AGdolor = .optdolor.value
			mIA_AGhigado = .txthig.value
			mIA_AGptosU = .optPure.value
			mIA_AGAGtacto = .txttr.value
			mIA_AGasc = .chkAsc.value
			mIA_AGbazo = .optBazo.value 
			mIA_AGRHA = (.optRha.value = 1)
			mIA_AGPPL = (.optPPL.value = 1)
			mIA_EGSNG = .ChkSNG.value
			mIA_EGSV = .chksv.value

		endwith
*!* -----------------         Sexta Página -----------------------------------------------------------------
		with .page6
			mIA_locomotor = .txtEd_an_loc.value
		endwith
*!* -----------------         Séptima Página -----------------------------------------------------------------
		with .page7
			mIA_NSconciencia  = mwkANConciencia.estado
			mIA_NSparesCran = .txtpares.value
			mIA_NSGmot = .txtgmot.value
			mIA_NSGver = .txtgver.value
			mIA_NSGocu = .txtgocu.value
			mIA_NSmovVol = transform(.chkmvsd.value,"@L 9") + transform(.chkmvsi.value,"@L 9") ;
				+ transform(.chkmvid.value,"@L 9") + transform(.chkmvii.value,"@L 9")
			mIA_NSmovPas = transform(.chkmpsd.value,"@L 9") + transform(.chkmpsi.value,"@L 9") ;
				+ transform(.chkmpid.value,"@L 9") + transform(.chkmpii.value,"@L 9")
			mIA_NSreflejoOst = transform(.chkrosd.value,"@L 9") + transform(.chkrosi.value,"@L 9") ;
				+ transform(.chkroid.value,"@L 9") + transform(.chkroii.value,"@L 9")
			mIA_NSsensib  = transform(.chkssd.value,"@L 9") + transform(.chkssi.value,"@L 9") ;
				+ transform(.chksid.value,"@L 9") + transform(.chksii.value,"@L 9")
			mIA_NScabGral = transform(.chkcga.value,"@L 9") + transform(.chkcgp.value,"@L 9") ;
				+ transform(.chkcgr.value,"@L 9") + transform(.chkcgrf.value,"@L 9");
				+ transform(.chkcgs.value,"@L 9") + transform(.chkcgsf.value,"@L 9")+ + transform(.chkbabin.value,"@L 9")


			mIA_NStaxia = .txttaxia.value
			mIA_NSpraxia = .txtpraxia.value

			mIA_NSnivSens = .txtNivsens.value
			mIA_NSctrlEsf = .chkce.value
			mIA_NSsgExP = .chksep.value
			mIA_NSsgMen = .chksm.value
			mIA_NStaxiao = .chktax.value
			mIA_NSpraxiao = .chkprax.value
			mIA_NSprosexia = .chkpros.value
			mIA_NSamnesia = .chkamn.value
			mIA_NSpsiquis = .txtpsi.value
			mIA_NSpsiq1  = .chkexc.value
			mIA_NSpsiq2 = .chkdep.value
			mIA_NSpsiq3 = .chkans.value
			mIA_NSpsiq4 = .chkbrad.value
			mIA_NSpsiq5 = .chkabul.value
		endwith
	endwith
endwith
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
mIA_NSflexorP = .f.
mIA_NSreflejoCA = .f.
mIA_fechahora = mwkfecserv.fechahora
mret = sqlexec(mcon1, "SELECT id FROM TabIntAnam " + ;
	" where IA_idevol = ?midevolhce ", "mwkVerana")

if mret < 0
	=aerr(eros)
	messagebox(eros(3), 48, "Validacion")
endif

if reccount('mwkVerana')= 0
&& IA_CVsoplo = ?mIA_CVsoplo
	mret = sqlexec(mcon1, "insert into TabIntAnam " + ;
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
		"IA_NSctrlEsf , IA_NSnivSens , IA_NSpraxiao , IA_NSprosexia , IA_NSsgExP , IA_NSsgMen , IA_NStaxiao,IA_Gestable, IA_postCX, IA_fechahora	 )"+;
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
		"?mIA_NSctrlEsf , ?mIA_NSnivSens , ?mIA_NSpraxiao , ?mIA_NSprosexia , ?mIA_NSsgExP , ?mIA_NSsgMen , ?mIA_NStaxiao , ?mIA_Gestable , ?mIA_postCX ,?mIA_fechahora   )")
else
	mret = sqlexec(mcon1, "update TabIntAnam set " + ;
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
		" ,IA_AGhigado = ?mIA_AGhigado"+;
		" where IA_idevol = ?midevolhce ")

endif


if mret < 0
	mret=aerr(eros)
	messagebox(eros(3),"Validacion")
endif
USE IN SELECT('mwkVerana')
