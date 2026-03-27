****
** Grabo evolucion del paciente
****
Parameters mnroreg, mprot, mmedico, mopage2, mopage3, musua, lvaaarchivo, lcierreant, mlevolnurse

Dimension admFar(11),Pract(13)

If vartype(mlevolnurse) = "U"
	mlevolnurse = .f.
Endif

*****
* Campos reutilizados
*****
* Tabambevol.EA_codmed -> medico que realiza el protocolo quirurgico >0 (cero)
* Tabambevol.EA_evolucion - > detalle del protocolo quirurgico
* Tabambevol.EA_codCIENanda -> si va la historia de traumatologia a archivo
* Tabambevol.EA_newindic -> = 1 hay indicaciones para enfermeria = 0 no
******

* ID  EA_evolNurse  EA_evolucion  EA_exFisico	EA_indicNurse	EA_motConsulta  EA_nroregistrac	 EA_protocolo

lvaaarchivo = iif(vartype(lvaaarchivo)#"N", 0, lvaaarchivo )

fechor = sp_busco_fecha_serv("DT")
mcodCIENanda = 0

If type('mopage2')='O'

* TxtEdtIndic  medico
* TxteditEvol  ingresado ahora
* TxtEdtEvol   anterior

	miprotquir = ''
	mcodmedpq = 0
	mprotq = mopage2.ChkProtQuir.value
	If mopage2.ChkProtQuir.value = 1
		miprotquir = alltrim(mopage2.TxtedtPQuir.value)
		mcodmedpq = mmedico
	Endif

	calta 	= iif(mwkveoproto.tipoest =0 or lcierreant,"Evolución Posterior al CIERRE del Protocolo ","")
	caltaNur= iif((mwkveoproto.tipoest =0 or lcierreant) and !empty(mopage3.TxtEdtIndic.value),"Indicación Posterior al CIERRE del Protocolo ","")
	mMotC 	= mopage2.TxteditMotC.value
	mAntec 	= ''&&& mopage2.TxteditAntec.value
	mEvol	= calta + mopage2.TxteditEvol.value
	mEvolF	= mopage2.TxteditEvolF.value
	mEvolA	= mopage2.edtEvol.value
	mfechaHora = iif(mwkveoproto.codprest = 42010147, mopage2.txthate_emerg.value,ctot("01/01/1900"))
	mIndic		= caltaNur+ mopage3.TxtEdtIndic.value
	mEAnewIndic	= mopage3.chkNewIndic.value

	mNurse = ''
*-------------------------------------------- MODIFICACION 100408
*!*		With mopage3.pgnurse.page1
	With mopage3.parent.page5

		mparTensSis = .TxtTaSist.value

		mparTensDia = .TxtTaDia.value
		mNurse = mNurse + iif(mparTensSis # 0, ' T.Art.Sistólica mmHg:' + transf(mparTensSis ,'999');
			+ " T.Art.Diastólica mmHg:"+ transf(mparTensDia ,'999') +chr(10),'')

		mparFreCard	= .TxtFcard.value
		mNurse = mNurse + iif(mparFreCard# 0,  ' Frecuencia Cardíaca (latidos x min.):'+ transf(mparFreCard,'999') + chr(10),'')

		mparFreResp = .TxtFresp.value
		mNurse = mNurse + iif(mparFreResp # 0, ' Frecuencia Respiratoria (respiración x min.):'+ transf(mparFreResp ,'999') + chr(10),'')

		mparTemAxl 	= .TxtTempAx.value
		mNurse = mNurse + iif(mparTemAxl # 0,  ' Tª Axilar (grado centigrado):'+ transf(mparTemAxl ,'99.9') + chr(10),'')

		mparTemBuc 	= .TxtTempBc.value
		mNurse = mNurse + iif(mparTemBuc # 0,  ' Tª Bucal:'+ transf(mparTemBuc ,'99.9') + chr(10),'')

		mparGluc 	= .TxtGluc.value
		mNurse = mNurse + iif(mparGluc # 0,    ' Glucemia:'+ transf(mparGluc ,'9999') + ' mg/dl '+ chr(10),'')

		mparPeso 	= .TxtPeso.value
		mNurse = mNurse + iif(mparPeso # 0,    ' Peso_:'+ transf(mparPeso  ,'999.9') +' Kgs '+ chr(10),'')

		mparTalla 	= iif(empty(.TxtTalla.value),0,.TxtTalla.value)
		mNurse = mNurse + iif(mparTalla # 0,    ' Talla:'+ transf(mparTalla ,'999.9') +' cm '+ chr(10),'')
	Endwith

	mNurse = iif(!empty(mNurse), 'C.S.V. ' + chr(10) + mNurse,'')
	With mopage3.pgnurse.page2
		mparAlerg 	 = .Optalerg.value
		mparAdmF     = ''
		lhayAF       = .f.
		mparAlergQue = .TxtAlergias.value
		If mparAlerg = 1
			miNurse      = "Administración de Fármacos "
			mfarma       = " Fármaco_:"+alltrim(.TxtF.value)
			mdosis       = " Dosis___:"+alltrim(.TxtD.value)
			mNurse       = mNurse + miNurse + chr(10) + mfarma + chr(10) + mdosis
		Endif
	Endwith

	With mopage3.pgnurse.page3
		mparOtros  = ''
		lhayAF = .f.
		miNurse = "Procedimientos"
		mNurse = mNurse + iif(lhayAF,chr(10)+ miNurse ,'')
	Endwith

	With mopage3.pgnurse.page4
	Endwith

	msoloevol = iif(!empty(alltrim(mopage3.TxteditEvol.value )), ;
		alltrim(mopage3.TxteditEvol.value ) +chr(10),'') + alltrim(mNurse)

	If musua > 0  && Planilla enfermeria

*       mEAnewIndic = 0

		msoloevol = iif(!empty(alltrim(mopage3.TxteditEvol.value )), ;
			alltrim(mopage3.TxteditEvol.value ) +chr(10),'') + alltrim(mNurse)

		miedit = iif(!empty(alltrim(mopage3.TxteditEvol.value + mNurse )), ttoc(fechor) + ' ' + ;
				 iif(used('mwkusuarios'),alltrim(mwkusuarios.idusuario) ,transf(musua))+ '->', '') + ;
		 		 iif(!empty(alltrim(mopage3.TxteditEvol.value )), ;
				 alltrim(mopage3.TxteditEvol.value) + chr(10),'') + alltrim(mNurse)

		mevolNurse 	= alltrim(mopage3.TxtEdtEvol.value) + ;
			iif(!empty(alltrim(mopage3.TxtEdtEvol.value)),chr(10),'') + miedit

	Else
		&& 101201 se agrega medico
		mMedic = Alltrim(mopage3.Parent.Parent.medcabnom) && login
		miedit = alltrim(mopage3.TxteditEvol.value)
		mevolNurse 	= iif(!empty(mNurse),ttoc(fechor) + Space(1) + mMedic + " -> " + alltrim(mopage3.TxtEdtEvol.value)+ chr(10) + alltrim(mNurse),"")

	Endif

Endif

mret = sqlexec(mcon1, "SELECT id FROM TabambEvol " + ;
	" where EA_nroregistrac = ?mnroreg and EA_protocolo = ?mprot ", "mwkVerEvol")

If mret < 0
	=aerr(eros)
	Messagebox(eros(3), 48, "Validacion")
Endif

If reccount('mwkVerEvol')= 0

	mret = sqlexec(mcon1, "insert into TabambEvol " + ;
		" (EA_nroregistrac , EA_protocolo ,EA_motConsulta , EA_exFisico , EA_indicNurse, "+;
		" EA_evolNurse,EA_evolucion ) values "+;
		" (?mnroreg, ?mprot,?mMotC, ?mEvolF,?mIndic,?mevolNurse,?miprotquir )" )

	If mret < 0
		mret=aerr(eros)
		Messagebox(eros(3), 48, "Validacion")
	Endif

	If mlevolnurse
		mret = sqlexec(mcon1, "insert into TabambEvolNurse " + ;
			"(EAN_evolNurse,EAN_fechaH,EAN_parAdmF,EAN_parAlerg,EAN_parAlergQue,"+;
			"EAN_parFreCard,EAN_parFreResp,EAN_parGluc,EAN_parOtros,EAN_parPeso,EAN_parTemAxl,"+;
			"EAN_parTemBuc,EAN_parTensDia,EAN_parTensSis,EAN_partalla,EAN_proto,EAN_usuario)"+;
			" values "+;
			"(?msoloevol,?fechor,?mparAdmF,?mparAlerg,?mparAlergQue,?mparFreCard,?mparFreResp,?mparGluc," +;
			"?mparOtros,?mparPeso,?mparTemAxl,?mparTemBuc,?mparTensDia,?mparTensSis,?mparTalla,?mprot,?musua)" )
	endif
	if  musua = 0
		mret = sqlexec(mcon1, "insert into TabambEvolMed " + ;
			" (EAM_proto , EAM_codmed , EAM_fechaH , EAM_evol ) values "+;
			" (?mprot, ?mmedico, ?fechor, ?mEvol )" )

	Endif

Else

	mid = mwkVerEvol.id
	if  musua = 0		&&&& datos medicos

		mret = sqlexec(mcon1, "update TabambEvol set EA_motConsulta = ?mMotC "+;
			", EA_exFisico = ?mEvolF , EA_indicNurse =?mIndic "+;
			" , EA_evolucion = ?miprotquir,EA_newindic = ?mEAnewIndic "+;
			" where id = ?mid ")

*!*     ,EA_codCIENanda = ?mcodCIENanda

		If !empty(mEvol)  and musua = 0
			mret = sqlexec(mcon1, "insert into TabambEvolMed " + ;
				" (EAM_proto , EAM_codmed , EAM_fechaH , EAM_evol ) values "+;
				" (?mprot, ?mmedico, ?fechor, ?mEvol )" )
		Endif

	Endif

	If mlevolnurse
		mret = sqlexec(mcon1, "update TabambEvol set EA_evolNurse =?mevolNurse "+;
			",EA_newindic = ?mEAnewIndic  where id = ?mid ")

		mret = sqlexec(mcon1, "insert into TabambEvolNurse " + ;
			" (EAN_evolNurse , EAN_fechaH , EAN_parAdmF , EAN_parAlerg , " + ;
			"EAN_parAlergQue , EAN_parFreCard , EAN_parFreResp , EAN_parGluc , EAN_parOtros , " + ;
			"EAN_parPeso , EAN_parTemAxl , EAN_parTemBuc , " + ;
			"EAN_parTensDia , EAN_parTensSis , EAN_parTalla ,EAN_proto , EAN_usuario  "+;
			" ) values "+;
			" (?msoloevol,?fechor,?mparAdmF , ?mparAlerg , "+;
			" ?mparAlergQue ,?mparFreCard,?mparFreResp , ?mparGluc , " +;
			" ?mparOtros  , ?mparPeso , ?mparTemAxl , ?mparTemBuc , "+;
			" ?mparTensDia , ?mparTensSis , ?mparTalla,?mprot,?musua )" )

	endif

Endif

If mret < 0
	=aerr(eros)
	Messagebox(eros(3), 48, "Validacion")
Endif
