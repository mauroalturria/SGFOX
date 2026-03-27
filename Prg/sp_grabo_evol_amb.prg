*!*	-----------------------------------------------------------------------------------------------------
*!*	Grabo evolucion del paciente
*!*	-----------------------------------------------------------------------------------------------------
parameters mnroreg, mprot, mmedico, mopage2, mopage3, musua, lvaaarchivo, lcierreant, mlevolnurse,mformorigen,ltelecons

dimension admFar(11),Pract(13)
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
pract(1) 	= " Curaciones "
pract(2) 	= " Lavado Oido "
pract(3) 	= " ECG "
pract(4) 	= " Cat.Vesical "
pract(5) 	= " Sonda Nasogast. "
pract(6) 	= " Acc.Ven.Perif. "
pract(7) 	= " Enema "
pract(8) 	= " Lavado Vesical "
pract(9) 	= " Extración Sangre "
pract(10) 	= " Muestra Orina "
pract(11) 	= " Muestra Mat.Fecal "
pract(12) 	= " Monitoreo Cardíaco Continuo "
pract(13) 	= " Contención Física "

if vartype(mlevolnurse) = "U"
	mlevolnurse = .f.
endif

mEAN_codmed = Iif(musua = 0, mmedico, null)
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

*!*	---------------------------------------------------------------------------
*!*	PAGE2
*!*	---------------------------------------------------------------------------
if type('mopage2')='O'

	mltipalta = mopage2.parent.parent.ltipalta
	mlcodesta = mopage2.parent.parent.lcodesta
	mlreceta = mopage2.parent.parent.lmodifevolR 
* TxtEdtIndic  medico
* TxteditEvol  ingresado ahora
* TxtEdtEvol   anterior

	miprotquir = ''
	mcodmedpq  = 0
	mprotq     = mopage2.ChkProtQuir.value
	if INLIST(mformorigen , 8 ,99)
		mmedico = mwkusuarios.idcodmed
*		cusumed = alltrim(mwkusuarios.nomape)+ " "
	endif

	if mopage2.ChkProtQuir.value = 1
		miprotquir = alltrim(mopage2.TxtedtPQuir.value)
		mcodmedpq  = mmedico
	endif

	calta 	 = iif(mwkveoproto.tipoest  =0 or lcierreant,"Evolución Posterior al CIERRE del Protocolo ","")
	caltaNur = iif((mwkveoproto.tipoest =0 or lcierreant) and ;
		!empty(mopage3.TxtEdtIndic.value),"Indicación Posterior al CIERRE del Protocolo ","")
	mMotC  	 = mopage2.TxteditMotC.value
	mAntec   = mopage2.TxteditAntec.value
	mEvol	 = calta + mopage2.TxteditEvol.value
	mEvolF	 = mopage2.TxteditEvolF.value
	mEvolA	 = mopage2.edtEvol.value
	mNurse   = ''

	mfechaHora  = iif(mwkveoproto.codprest = 42030723, mopage2.txthate_emerg.value, ctot("01/01/1900"))
	mIndic		= caltaNur+ mopage3.TxtEdtIndic.value
	mEAnewIndic	= mopage3.chkNewIndic.value


*!*  -------------------------------------------- MODIFICACION 100408
*!*		With mopage3.pgnurse.page1

*!*	-----------------------------------------------------------------------------------------------------
*!*	C.S.V
*!*	-----------------------------------------------------------------------------------------------------
	with mopage3.parent.page5

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

		mparIMC 	= .TxtIMC.value
		mNurse = mNurse + iif(mparIMC # 0, ' IMC_:'+ transf(mparIMC ,'999.99') +' '+ chr(10),'')

		mparsatur = iif(empty(.txtcintura.value),0,.txtcintura.value)
		mNurse = mNurse + iif(mparsatur # 0,    ' Circunferencia Abdominal:'+ transf(mparsatur ,'999') +' cm '+ chr(10),'')


	endwith

	mNurse = iif(!empty(mNurse), 'C.S.V. ' + chr(10) + mNurse,'')
&&  20101214 se agregan los signos vitales en la evolucion del medico
	if !empty(mNurse)
		mSignos = mNurse
		lcSep   = chr(10)
		mEvol   = mSignos + lcSep + mEvol
	endif

	with mopage3.pgnurse.page2
		mparalerg 		= .optalerg.value
		mparalergque 	=.txtalergias.value
		mparadmf = ''
		lhayaf = .f.
	endwith
	with mopage3.pgnurse.page3
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
	with mopage3.pgnurse.page4
		mparOtros  = ''
		lhayAF = .f.
		miNurse = "Procedimientos"

		for i = 1 to 3
			cvar = ".TxtP"+transf(i,"@L 99")+".value"
			mdet = alltrim(&cvar)
			cchk       = ".Check"+alltrim(transf(i,"@L 99"))+".value"
			mparotros  = mparotros  + transf(&cchk,"9")
			minurse    = minurse + iif(&cchk # 0,chr(10) + "Se realiza " + pract(i) + " " +  mdet,'')

			lhayaf = (lhayaf or &cchk # 0)
		next

*!*			for i = 4 to 13
*!*				cvar = ".TxtP"+transf(i,"@L 99")+".value"
*!*				mdet = alltrim(&cvar)

*!*				cchk      = ".Check"+alltrim(transf(i,"@L 99"))+".value"
*!*				mparotros = mparotros  + transf(&cchk,"9")
*!*				minurse   = minurse + iif(&cchk # 0,chr(10) + "Se realiza " + pract(i) + " " + mdet,'')
*!*				lhayaf    = (lhayaf or &cchk # 0)
*!*			next

		mNurse = mNurse + iif(lhayAF,chr(10)+ miNurse ,'')
	endwith

	msoloevol = iif(!empty(alltrim(mopage3.TxteditEvol.value )), ;
		alltrim(mopage3.TxteditEvol.value ) +chr(10),'') + alltrim(mNurse)

*!*	-----------------------------------------------------------------------------------------------------
*!*	-----------------------------------------------------------------------------------------------------
	if musua > 0  && Planilla enfermeria
*       mEAnewIndic = 0

		msoloevol = iif(!empty(alltrim(mopage3.TxteditEvol.value )), ;
			alltrim(mopage3.TxteditEvol.value ) +chr(10),'') + alltrim(mNurse)

		miedit = iif(!empty(alltrim(mopage3.TxteditEvol.value + mNurse )), ttoc(fechor) + ' ' + ;
			iif(used('mwkusuarios'),alltrim(mwkusuarios.idusuario) ,transf(musua))+ '->', '') + ;
			iif(!empty(alltrim(mopage3.TxteditEvol.value )), ;
			alltrim(mopage3.TxteditEvol.value) + chr(10),'') + alltrim(mNurse)

		mevolNurse 	= alltrim(mopage3.TxtEdtEvol.value) + ;
			iif(!empty(alltrim(mopage3.TxtEdtEvol.value)),chr(10),'') + miedit

	else
*!*	-----------------------------------------------------------------------------------------------------
&& 101201 se agrega medico
		miedit = alltrim(mopage3.TxteditEvol.value)
		mevolNurse = alltrim(mopage3.TxtEdtEvol.value)
		if !empty(mNurse)
			mMedic = alltrim(mopage3.parent.parent.medcabnom) && login
			mevolNurse = mevolNurse + chr(10) + ttoc(fechor) + space(1) + mMedic + " -> " + alltrim(mNurse)
		endif
*!*			miedit = alltrim(mopage3.TxteditEvol.value)
*!*			mevolNurse 	= alltrim(mopage3.TxtEdtEvol.value) + chr(10) + alltrim(mNurse)

	endif
endif
*!*	---------------------------------------------------------------------------
*!*	FIN DE PAGE2
*!*	---------------------------------------------------------------------------

mret = SQLExec(mcon1, "SELECT id,EA_horacierre FROM TabambEvol " + ;
	" where EA_nroregistrac = ?mnroreg and EA_protocolo = ?mprot ", "mwkVerEvol")

if mret <= 0
	messagebox("ERROR DE LECTURA. EVOLUCION ",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

if reccount('mwkVerEvol')= 0
*!*	-----------------------------------------------------------------------------------------------------

*!* 24-02-2011 Fecha Hora Cierre Protocolo s/Tipo Alta

	mret = SQLExec(mcon1, "insert into TabambEvol " + ;
		" (EA_nroregistrac, EA_protocolo, EA_motConsulta, EA_exFisico, EA_indicNurse, "+;
		" EA_evolNurse, EA_evolucion, EA_antecedentes, EA_horacierre) " + ;
		" values " + ;
		" (?mnroreg, ?mprot,?mMotC, ?mEvolF, ?mIndic, " + ;
		" ?mevolNurse, ?miprotquir, ?mAntec, "+;
		iif(mwktaltas.tipoest=0,"?fechor","'1900-01-01 00:00:00'")+")" )

	if mret <= 0
		messagebox("ERROR AL GUARDAR LA EVOLUCION ",16,"ERROR")
		do log_errores with error(), message(), message(1), program(), lineno()
	endif

	if mlevolnurse
*!*	-----------------------------------------------------------------------------------------------------
		mret = SQLExec(mcon1, "insert into TabambEvolNurse " + ;
			"(EAN_evolNurse,EAN_fechaH,EAN_parAdmF,EAN_parAlerg,EAN_parAlergQue,"+;
			"EAN_parFreCard,EAN_parFreResp,EAN_parGluc,EAN_parOtros,EAN_parPeso,EAN_parTemAxl,"+;
			"EAN_parTemBuc,EAN_parTensDia,EAN_parTensSis,EAN_partalla,EAN_proto,EAN_usuario,EAN_codmed,EAN_parSatur)"+;
			" values "+;
			"(?msoloevol,?fechor,?mparAdmF,?mparAlerg,?mparAlergQue,?mparFreCard,?mparFreResp,?mparGluc," +;
			"?mparOtros,?mparPeso,?mparTemAxl,?mparTemBuc,?mparTensDia,?mparTensSis,?mparTalla,?mprot,?musua,?mEAN_codmed,?mparsatur )" )

		if mret <= 0
			messagebox("ERROR AL GUARDAR LA EVOLUCION ENFERMERIA",16,"ERROR")
			do log_errores with error(), message(), message(1), program(), lineno()
		endif
*!*	-----------------------------------------------------------------------------------------------------
	endif

	if  musua = 0
*!*	-----------------------------------------------------------------------------------------------------
		mret = SQLExec(mcon1, "insert into TabambEvolMed " + ;
			" (EAM_proto , EAM_codmed , EAM_fechaH , EAM_evol ) values "+;
			" (?mprot, ?mmedico, ?fechor, ?mEvol )" )


		if mret <= 0
			messagebox("ERROR AL GUARDAR LA EVOLUCION MEDICA",16,"ERROR")
			do log_errores with error(), message(), message(1), program(), lineno()
		endif
*!*	-----------------------------------------------------------------------------------------------------
	endif

else

	mid = mwkVerEvol.id
	if  musua = 0		&&&& datos medicos

*!*	-----------------------------------------------------------------------------------------------------

*!* 24-02-2011 Fecha Hora cierre protocolo s/tipo alta y reversiones

		mhoracierre = mwkVerEvol.EA_horacierre

		mret = SQLExec(mcon1, "update TabambEvol set EA_motConsulta = ?mMotC "+;
			",EA_exFisico = ?mEvolF , EA_indicNurse =?mIndic "+;
			",EA_evolucion = ?miprotquir,EA_newindic = ?mEAnewIndic, EA_antecedentes = ?mAntec "+;
			iif(mwktaltas.tipoest=0 and mltipalta<>0,",EA_horacierre = ?fechor",+;
			iif(mwktaltas.tipoest<>0 and mltipalta=0,",EA_horacierre='1900-01-01 00:00:00'",",EA_horacierre=?mhoracierre"))+;
			" where id = ?mid ")

		if mret <= 0
			messagebox("ERROR EN LA ACTUALIZACION DE LA EVOLUCION",16,"ERROR")
			do log_errores with error(), message(), message(1), program(), lineno()
		endif

*!*     Reversion estado de ALTA
		if mwktaltas.tipoest<>0 and mltipalta=0
			do sp_amb_revierte_alta with mwkVerEvol.EA_horacierre,mmedico,mlcodesta,mwktaltas.id,mprot
		endif

*!*     ,EA_codCIENanda = ?mcodCIENanda

		if !empty(mEvol)  and musua = 0
*!*	-----------------------------------------------------------------------------------------------------
			mret = SQLExec(mcon1, "insert into TabambEvolMed " + ;
				" (EAM_proto , EAM_codmed , EAM_fechaH , EAM_evol ) values "+;
				" (?mprot, ?mmedico, ?fechor, ?mEvol )" )

			if mret <= 0
				messagebox("ERROR AL GUARDAR LA EVOLUCION MEDICA",16,"ERROR")
				do log_errores with error(), message(), message(1), program(), lineno()
			endif
*!*	-----------------------------------------------------------------------------------------------------
		endif
	endif

	if mlevolnurse
*!*	-----------------------------------------------------------------------------------------------------
		mret = SQLExec(mcon1, "update TabambEvol set EA_evolNurse =?mevolNurse "+;
			",EA_newindic = ?mEAnewIndic  where id = ?mid ")

		if mret <= 0
			messagebox("ERROR EN LA ACTUALIZACION DE LA EVOLUCION",16,"ERROR")
			do log_errores with error(), message(), message(1), program(), lineno()
		endif
*!*	-----------------------------------------------------------------------------------------------------
		mret = SQLExec(mcon1, "insert into TabambEvolNurse " + ;
			" (EAN_evolNurse , EAN_fechaH , EAN_parAdmF , EAN_parAlerg , " + ;
			"EAN_parAlergQue , EAN_parFreCard , EAN_parFreResp , EAN_parGluc , EAN_parOtros , " + ;
			"EAN_parPeso , EAN_parTemAxl , EAN_parTemBuc , " + ;
			"EAN_parTensDia , EAN_parTensSis , EAN_parTalla ,EAN_proto , EAN_usuario,EAN_codmed  "+;
			" ) values "+;
			" (?msoloevol,?fechor,?mparAdmF , ?mparAlerg , "+;
			" ?mparAlergQue ,?mparFreCard,?mparFreResp , ?mparGluc , " +;
			" ?mparOtros  , ?mparPeso , ?mparTemAxl , ?mparTemBuc , "+;
			" ?mparTensDia , ?mparTensSis , ?mparTalla,?mprot,?musua,?mEAN_codmed)" )

		if mret <= 0
			messagebox("ERROR EN LA ACTUALIZACION DE ENFERMERIA",16,"ERROR")
			do log_errores with error(), message(), message(1), program(), lineno()
		endif
*!*	-----------------------------------------------------------------------------------------------------
	endif

endif

