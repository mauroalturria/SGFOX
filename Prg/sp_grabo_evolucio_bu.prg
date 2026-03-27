****
** Grabo evolucion del paciente
****
parameters mnroreg, mprot, mmedico,mopage2, mopage3, musua
dimension admFar(11),Pract(11)
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
Pract(1) 	= " CatV "
Pract(2) 	= " SNG  "
Pract(3) 	= " SRc  "
Pract(4) 	= " Cur  "
Pract(5) 	= " LvOi "
Pract(6) 	= " Ene  "
Pract(7) 	= " LvVs "
Pract(8) 	= " ECG  "
Pract(9) 	= " ExSg "
Pract(10) 	= " MOr  "
Pract(11) 	= " MMF  "

fechor = sp_busco_fecha_serv("DT")
if type('mopage2')='O'
* TxtEdtIndic  medico
* TxteditEvol ingresado ahora
* TxtEdtEvol  anterior
	calta 	= iif(mwkveoproto.tipoest =0,"Evolución Posterior al CIERRE del Protocolo ","")
	mMotC 	= mopage2.TxteditMotC.value
	mAntec 	= mopage2.TxteditAntec.value
	mEvol	= calta + mopage2.TxteditEvol.value
	mEvolF	= mopage2.TxteditEvolF.value
	mEvolA	= mopage2.edtEvol.value
	mfechaHora 	= nvl(mopage3.txthateNurse.value,ctot("01/01/1900"))
	mfechaHora = iif(mfechaHora=ctot("  /  /    "),ctot("01/01/1900"),mfechaHora )
	mcodCIENanda = mopage3.cbocie9Nurse.value
	mIndic		= mopage3.TxtEdtIndic.value
* TxtEdtIndic  medico
* TxteditEvol ingresado ahora
* TxtEdtEvol  anterior
	mNurse = ''
	with mopage3.pgnurse.page1
		mparTensSis = .TxtTaSist.value
		mparTensDia = .TxtTaDia.value
		mNurse = mNurse + iif(mparTensSis # 0, 'T.Art.Sistólica mmHg:' + transf(mparTensSis ,'999');
			+ " T.Art.Diastólica mmHg:"+ transf(mparTensDia ,'999') +chr(10),'')
		mparFreCard	= .TxtFcard.value
		mNurse = mNurse + iif(mparFreCard# 0, 'Frecuencia Cardíaca (latidos x min.):'+ transf(mparFreCard,'999') + chr(10),'')
		mparFreResp = .TxtFresp.value
		mNurse = mNurse + iif(mparFreResp # 0, 'Frecuencia Respiratoria (respiración x min.):'+ transf(mparFreResp ,'999') + chr(10),'')
		mparTemAxl 	= .TxtTempAx.value
		mNurse = mNurse + iif(mparTemAxl # 0, 'Tª Axilar (grado centigrado):'+ transf(mparTemAxl ,'99.9') + chr(10),'')
		mparSatur 	= .TxtSat.value
		mNurse = mNurse + iif(mparSatur # 0, 'Saturación de O2 en sangre %'+ transf(mparSatur ,'999') + chr(10),'')
		mparGluc 	= .TxtGluc.value
		mNurse = mNurse + iif(mparGluc # 0, ' Glucemia:'+ transf(mparGluc ,'9999') + chr(10),'')
		mparPeso 	= .TxtPeso.value
		mNurse = mNurse + iif(mparPeso # 0, ' Peso:'+ transf(mparPeso ,'999.9') + chr(10),'')
		mparTemBuc 	= .TxtTempBc.value
		mNurse = mNurse + iif(mparTemBuc # 0, ' Tª Bucal:'+ transf(mparTemBuc ,'99.9') + chr(10),'')
		mparTemRct 	= .TxtTempRt.value
		mNurse = mNurse + iif(mparTemRct # 0, ' Tª Rectal:'+ transf(mparTemRct ,'99.9') + chr(10),'')

	endwith
	mNurse = iif(!empty(mNurse), 'C.C.V. ' + chr(10) + mNurse,'')
	with mopage3.pgnurse.page2
		mparAlerg 		= .Optalerg.value
		mparAlergQue 	=.TxtAlergias.value
		mparAdmF = ''
		lhayAF = .f.
		miNurse =  " Administración de Fármacos "+chr(10)
		for i = 1 to 11
			cchk = ".Check"+alltrim(transf(i,"@L 99"))+".value"
			mparAdmF = mparAdmF + transf(&cchk,"9")
			miNurse = miNurse + iif(&cchk # 0,admfar(i),'')
			lhayAF = (lhayAF or &cchk # 0)
		next
		mNurse = mNurse + iif(lhayAF,chr(10)+ miNurse ,'')
	endwith
	with mopage3.pgnurse.page3
		mparOtros  = ''
		lhayAF = .f.
		miNurse = "Procedimientos" + chr(10)
		for i = 1 to 11
			cchk = ".Check"+alltrim(transf(i,"@L 99"))+".value"
			mparOtros  = mparOtros  + transf(&cchk,"9")
			miNurse = miNurse + iif(&cchk # 0,Pract(i),'')
			lhayAF = (lhayAF or &cchk # 0)
		next
		mNurse = mNurse + iif(lhayAF,chr(10)+ miNurse ,'')

	endwith
	moptpert = mopage3.pgnurse.Page4.OptPert.value
	if moptpert > 0
		mNurse = mNurse + chr(10)+ "Se entregan pertenencias a:" + ;
			iif(moptpert = 1, "Familiar",iif(moptpert = 2, "Vigilador","Paciente" ) )
	endif
	if musua > 0  && Planilla enfermeria
		miedit = iif(!empty(alltrim(mopage3.TxteditEvol.value + mNurse )), ttoc(fechor) + ' ' +;
			iif(used('mwkusuarios'),alltrim(mwkusuarios.idusuario) ,transf(musua))+ '->', '') + ;
			alltrim(mopage3.TxteditEvol.value) + chr(10)+ alltrim(mNurse)
		mevolNurse 	= alltrim(mopage3.TxtEdtEvol.value)+iif(!empty(alltrim(mopage3.TxtEdtEvol.value)),chr(10),'') + miedit
	else
		miedit = alltrim(mopage3.TxteditEvol.value)
		mevolNurse 	= alltrim(mopage3.TxtEdtEvol.value)
	endif

else
	messagebox("algo esta mal")
endif

mret = sqlexec(mcon1, "SELECT * FROM TabGuaEvol " + ;
	" where EG_nroregistrac = ?mnroreg and EG_protocolo = ?mprot ", "mwkVerEvol")
if mret < 0
	=aerr(eros)
	messagebox(eros(3), 48, "Validacion")
endif
if reccount('mwkVerEvol')= 0
	mret = sqlexec(mcon1, "insert into TabGuaEvol " + ;
		" (EG_nroregistrac , EG_protocolo , EG_usuario , EG_fechaHora , "+;
		" EG_motConsulta , EG_anteceden , EG_evolNurse , EG_exFisico , EG_evolHist , "+;
		" EG_indicNurse , EG_parAdmF , EG_parAlerg , EG_parFreCard , EG_parFreResp , "+;
		" EG_parGluc , EG_parOtros , EG_parPeso , EG_parSatur , EG_parTemAxl , "+;
		" EG_parTemBuc , EG_parTemRct , EG_parTensDia , EG_parTensSis,EG_parAlergQue,"+;
		" EG_codCIENanda "+;
		" ) values "+;
		" (?mnroreg, ?mprot,?musua,?mfechaHora,?mMotC,?mAntec,?mevolNurse,?mEvolF,"+;
		" '', ?mIndic, ?mparAdmF , ?mparAlerg , ?mparFreCard, ?mparFreResp , ?mparGluc ,"+;
		" ?mparOtros  , ?mparPeso , ?mparSatur , ?mparTemAxl , ?mparTemBuc , ?mparTemRct ,"+;
		" ?mparTensDia , ?mparTensSis , ?mparAlergQue ,?mcodCIENanda  )" )
	if mret < 0
		=aerr(eros)
		messagebox(eros(3), 48, "Validacion")
	endif
	if musua = 0
		mret = sqlexec(mcon1, "insert into TabGuaEvolMed " + ;
			" (EGM_proto , EGM_codmed , EGM_fechaH , EGM_evol ) values "+;
			" (?mprot, ?mmedico, ?fechor, ?mEvol )" )
	endif
else
	mid = mwkVerEvol.id
	if musua = 0		&&&& datos medicos
		mret = sqlexec(mcon1, "update TabGuaEvol set EG_motConsulta = ?mMotC "+;
			", EG_anteceden =?mAntec, EG_exFisico = ?mEvolF , EG_evolHist =?mEvolA "+;
			" , EG_indicNurse =?mIndic where id = ?mid ")
		if !empty(mEvol) and musua = 0
			mret = sqlexec(mcon1, "insert into TabGuaEvolMed " + ;
				" (EGM_proto , EGM_codmed , EGM_fechaH , EGM_evol ) values "+;
				" (?mprot, ?mmedico, ?fechor, ?mEvol )" )
		endif
	else
		mret = sqlexec(mcon1, "update TabGuaEvol set EG_evolNurse =?mevolNurse, EG_parAdmF = ?mparAdmF "+;
			", EG_parAlerg = ?mparAlerg , EG_parFreCard=?mparFreCard , EG_parFreResp =?mparFreResp, "+;
			" EG_parGluc =?mparGluc, EG_parOtros=?mparOtros  , EG_parPeso = ?mparPeso , EG_parSatur=?mparSatur "+;
			", EG_parTemAxl =?mparTemAxl,EG_parTemBuc =?mparTemBuc, EG_parTemRct=?mparTemRct ,"+;
			" EG_parTensDia =?mparTensDia, EG_parTensSis = ?mparTensSis,EG_parAlergQue=?mparAlergQue "+;
			",EG_codCIENanda = ?mcodCIENanda where id = ?mid ")
	endif
endif
if mret < 0
	=aerr(eros)
	messagebox(eros(3), 48, "Validacion")
endif

* EGM_proto , EGM_codmed , EGM_fechaH , EGM_evol
* SELECT ID , EG_nroregistrac , EG_protocolo , EG_codmed , EG_fechaHora ,
*EG_motConsulta , EG_anteceden , EG_evolucion , EG_exFisico , EG_evolHist
