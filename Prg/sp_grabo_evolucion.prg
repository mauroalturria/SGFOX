****
** Grabo evolucion del paciente
****
parameters mnroreg, mprot, mmedico,mopage2, mopage3, musua,lvaaarchivo,lcierreant,morigen,lmismomed
dimension admfar(11),pract(13)
*****
* Campos reutilizados
*****
* Tabguaevol.EG_parotros -> ttoc(fecha-hora de pasaje a pisos)
* Tabguaevol.EG_parAdmF  -> ttoc(fecha-hora de pasaje a CEG )
* Tabguaevol.EG_codmed -> medico que realiza el protocolo quirurgico >0 (cero)
* Tabguaevol.EG_evolucion - > detalle del protocolo quirurgico
* Tabguaevol.EG_codCIENanda -> si va la historia de traumatologia a archivo
* Tabguaevol.EG_parAlerg -> = 1 hay indicaciones para enfermeria = 0 no
* Tabguaevol.EG_parFreCard-> tipo de Consulta Traumat, NO Traum, ART etc
* EG_fechaHora -> hora de atencion de emergencias
******
if vartype(morigen)#"N"
	morigen = 0
	lmismomed = .f.
endif

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

lvaaarchivo = iif(vartype(lvaaarchivo)#"N", 0, lvaaarchivo )

fechor = sp_busco_fecha_serv("DT")
mcodcienanda = iif(lvaaarchivo = 0,0,iif(lvaaarchivo= 1,9999,mwkguaevol.eg_codcienanda))  &&& se guarda valor para imprimir en HCAMB
if type('mopage2')='O'

	mltipalta = mopage2.parent.parent.ltipalta
	mlcodesta = mopage2.parent.parent.lcodesta

* TxtEdtIndic  medico
* TxteditEvol ingresado ahora
* TxtEdtEvol  anterior

	miprotquir = ''
	mcodmedpq  = 0
	mprotq     = mopage2.chkprotquir.value

	if mopage2.chkprotquir.value = 1
		miprotquir = alltrim(mopage2.txtedtpquir.value)
		mcodmedpq  = mmedico
	endif

	calta 	 = iif(mwkveoproto.tipoest =0 or lcierreant,"Evolución Posterior al CIERRE del Protocolo ","")
	caltanur = iif((mwkveoproto.tipoest =0 or lcierreant) and !empty(mopage3.txtedtindic.value),"Indicación Posterior al CIERRE del Protocolo ","")
	mmotc 	 = mopage2.txteditmotc.value
	mantec 	 = mopage2.txteditantec.value
	mevolf	 = mopage2.txteditevolf.value
	mevola	 = mopage2.edtevol.value
	mevol	 = calta + mopage2.txteditevol.value
	mindic	 = caltanur+ mopage3.txtedtindicnew.value
	mtipocons = mopage2.CboOpcCons.listindex
	
	if inlist(morigen, 100)   &&& paciente tomado desde bloqueo y no pertenecia al medico
		mevol = chr(10) + "Motivo de Consulta:"+ chr(10)+ alltrim(mopage2.txteditmotc.value)
		mevol = mevol + iif(!empty(mopage2.txteditantec.value), chr(10)+ "Antecedentes:"+chr(10)+ alltrim(mopage2.txteditantec.value),'')
		mevol = mevol + iif(!empty(mopage2.txteditevolf.value), chr(10)+ "Examen Fisico:"+chr(10)+ alltrim(mopage2.txteditevolf.value),'')
		mevol = mevol + iif(!empty(mopage2.txteditevolf.value), chr(10) + "Indicaciones Enfermeria:"+ chr(10)+ caltanur + alltrim(mopage3.txtedtindic.value),'')
		mevol = mevol + chr(10) + calta + alltrim(mopage2.txteditevol.value)
	endif

	mfechahora  = iif(mwkveoproto.codprest = 42030723, mopage2.txthate_emerg.value,ctot("01/01/1900"))
	megparalerg	= mopage3.chknewindic.value

* TxtEdtIndic  medico
* TxteditEvol ingresado ahora
* TxtEdtEvol  anterior

	mnurse = ''
	with mopage3.pgnurse.page1
		mpartenssis = .txttasist.value
		mpartensdia = .txttadia.value
		mnurse = mnurse + iif(mpartenssis # 0, 'T.Art.Sistólica mmHg:' + transf(mpartenssis ,'999');
			+ " T.Art.Diastólica mmHg:"+ transf(mpartensdia ,'999') +chr(10),'')
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
		mnurse = mnurse + iif(mparpeso # 0, ' Peso:'+ transf(mparpeso ,'999.9') +' Kgs '+ chr(10),'')
		mparalt 	= .txtalt.value
		mnurse = mnurse + iif(mparalt # 0, ' Altura:'+ transf(mparalt ,'999') +' Cm '+ chr(10),'')
		mparimc 	= .txtimc.value
		mnurse = mnurse + iif(mparimc # 0, ' IMC:'+ transf(mparimc ,'999.99') +' '+ chr(10),'')
		mpartembuc 	= .txttempbc.value
		mnurse = mnurse + iif(mpartembuc # 0, ' Tª Bucal:'+ transf(mpartembuc ,'99.9') + chr(10),'')
		mpartemrct 	= .txttemprt.value
		mnurse = mnurse + iif(mpartemrct # 0, ' Tª Rectal:'+ transf(mpartemrct ,'99.9') + chr(10),'')
		mpardiur	= 0 && .OptDiur.value
		if mpardiur	>0
			mnurse = mnurse + ' Diuresis:'+ iif(mpardiur=1,' Positiva ',' Negativa') + chr(10)
			mpardiur	= .txtdiurml.value
			mnurse = mnurse + iif(mpardiur # 0, '  Vol. ml:'+ transf(mpardiur,'9999') + chr(10),'')
			mpardiur	= .txtdiurpeso.value
			mnurse = mnurse + iif(mpardiur # 0, '  Peso mg:'+ transf(mpardiur,'999.9') + chr(10),'')
		endif
		if .txtglas1.value >0
			mnurse = mnurse + ' Glasgow:'+ transf(.txtglas1.value,'99')+ '/'+transf(.txtglas2.value,'99')+chr(10)
		endif
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
		if .chkpiso.value = 0 AND .chkfuga.value = 0
			mhorapiso = ''
		else
			mhorapiso = iif(empty(nvl(mwkevolprot.eg_parotros,'')),ttoc(fechor),mwkevolprot.eg_parotros)
		endif
		if .chkpisoceg.value = 0
			mhorapisoceg = ''
		else
			mhorapisoceg = iif(empty(nvl(mwkevolprot.eg_paradmf,'')),ttoc(fechor),mwkevolprot.eg_paradmf)
		endif

		moptproc = .optprocede.value
		if moptproc > 0
			cvar   = ".OptProcede.option"+ transf(moptproc ,"@L 9") + ".caption"
			mcopt  = &cvar
			mnurse = mnurse + chr(10)+ "Procede de:" + mcopt
		endif

		mopting = .optingreso.value
		if mopting > 0
			cvar   = ".OptIngreso.option"+ transf(mopting,"@L 9") + ".caption"
			mcopt  = &cvar
			mnurse = mnurse + chr(10)+ "Medios: " + mcopt
		endif

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

		mnurse = mnurse + iif(.chkambulancia.value = 1,chr(10)+ "Ingresa en ambulancia ",'')

		moptpert = .optpert.value
		if moptpert > 0
			cvar   = ".OptPert.option"+ transf(moptpert ,"@L 9") + ".caption"
			mcopt  = &cvar
			mnurse = mnurse + chr(10)+ "Se entregan pertenencias a:" + mcopt + " - Nombre: "+alltrim(.txtnombre.value)
		endif
		if !empty(mhorapiso)
			mnurse = mnurse + chr(10)+ "Hora de Entrega a Camillero: " + mhorapiso
		endif
		if !empty(mhorapisoceg)
			mnurse = mnurse + chr(10)+ "Hora de Ingreso a CEG: " + mhorapisoceg
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

	if musua > 0  && Planilla enfermeria
		megparalerg = 0
		msoloevol = iif(!empty(alltrim(mopage3.txteditevol.value )), ;
			alltrim(mopage3.txteditevol.value ) +chr(10),'') + alltrim(mnurse)
		miedit = iif(!empty(alltrim(mopage3.txteditevol.value + mnurse )), ttoc(fechor) + ' ' +;
			iif(used('mwkusuarios'),alltrim(mwkusuarios.idusuario) ,transf(musua))+ '->', '') + ;
			iif(!empty(alltrim(mopage3.txteditevol.value )), ;
			alltrim(mopage3.txteditevol.value) + chr(10),'')+ alltrim(mnurse)
		mevolnurse 	= alltrim(mopage3.txtedtevol.value)+iif(!empty(alltrim(mopage3.txtedtevol.value)),chr(10),'') + miedit
	else
		miedit = alltrim(mopage3.txteditevol.value)
		mevolnurse 	= alltrim(mopage3.txtedtevol.value)
	endif

endif

mret = sqlexec(mcon1, "SELECT id,EG_horacierre FROM TabGuaEvol " + ;
	" where eg_nroregistrac = ?mnroreg and eg_protocolo = ?mprot ", "mwkVerEvol")

if mret < 0
	=aerr(eros)
	messagebox(eros(3), 48, "Validacion")
endif

if reccount('mwkVerEvol')= 0

	mret = sqlexec(mcon1, "insert into TabGuaEvol " + ;
		" (eg_nroregistrac , eg_protocolo , eg_usuario , eg_fechahora , "+;
		" eg_motconsulta , eg_anteceden , eg_exfisico , eg_evolhist , eg_indicnurse, "+;
		" eg_evolnurse,eg_codcienanda,eg_codmed, eg_evolucion, eg_paralerg,"+;
		" eg_horacierre,eg_parotros ,eg_paradmf,eg_parFreCard )"+;
		" values "+;
		" (?mnroreg, ?mprot,?musua,?mfechahora, ?mmotc, ?mantec, ?mevolf,"+;
		" '', ?mindic,?mevolnurse,?mcodcienanda,?mcodmedpq ,?miprotquir,?megparalerg,"+;
		iif(mwktaltas.tipoest=0,"?fechor","'1900-01-01 00:00:00'")+",?mhorapiso"+;
		" ,?mhorapisoCEG,?mtipocons  )" )

	if mret < 0
		mret=aerr(eros)
		messagebox(eros(3), 48, "Validacion")
	endif

	if  musua = 0
		mret = sqlexec(mcon1, "insert into TabGuaEvolMed " + ;
			" (egm_proto , egm_codmed , egm_fechah , egm_evol ) values "+;
			" (?mprot, ?mmedico, ?fechor, ?mevol )" )
	else
		mret = sqlexec(mcon1, "insert into TabGuaEvolNurse " + ;
			" (egn_codcienanda , egn_evolnurse , egn_fechah , egn_paradmf , egn_paralerg , " + ;
			"egn_paralergque , egn_parfrecard , egn_parfreresp , egn_pargluc , egn_parotros , " + ;
			"egn_parpeso , egn_parsatur , egn_partemaxl , egn_partembuc , egn_partemrct , " + ;
			"egn_partensdia , egn_partenssis , egn_proto , egn_usuario  "+;
			" ) values "+;
			" (1, ?msoloevol,?fechor,?mparadmf , ?mparalerg , "+;
			" ?mparalergque ,?mparfrecard,?mparfreresp , ?mpargluc , " +;
			" ?mparotros  , ?mparpeso , ?mparsatur , ?mpartemaxl , ?mpartembuc , ?mpartemrct ,"+;
			" ?mpartensdia , ?mpartenssis , ?mprot,?musua )" )
	endif

else

	if reccount('mwkVerEvol')>1
		select mwkverevol
		go top
		skip
		do while !eof()
			middel = mwkverevol.id
			mret = sqlexec(mcon1, "update TabGuaEvol set EG_protocolo = '' "+;
				" where id = ?middel ")
			skip
		enddo
	endif
	go top
	mid = mwkverevol.id

*!* 25-02-2011
	mhoracierre = mwkverevol.eg_horacierre

	if musua = 0		&&&& datos medicos

		lactualiza = .t.
		mret = sqlexec(mcon1, "select EG_indicNurse,EG_motConsulta from TabGuaEvol where id = ?mid ","mwkctrl")
		if inlist(morigen, 100)   &&& paciente tomado desde bloqueo y no pertenecia al medico
			if !empty(mwkctrl.eg_motconsulta)
				lactualiza = .f.
			endif
		endif

		mindic = mindic + iif(!empty(alltrim(nvl(mwkctrl.eg_indicnurse,''))),chr(10)+alltrim(nvl(mwkctrl.eg_indicnurse,'')),'')

		if lactualiza  &&& solo actualiza los datos de cabecera si es el dueño

			mret = sqlexec(mcon1, "update TabGuaEvol set EG_motConsulta = ?mMotC "+;
				", eg_anteceden =?mantec, eg_exfisico = ?mevolf , eg_evolhist =?mevola "+;
				" , eg_indicnurse =?mindic,eg_codcienanda = ?mcodcienanda "+;
				" , eg_codmed = ?mcodmedpq , eg_evolucion = ?miprotquir,eg_paralerg = ?megparalerg "+;
				iif(mwktaltas.tipoest=0 and mltipalta<>0,",EG_horacierre = ?fechor",+;
				iif(mwktaltas.tipoest<>0 and mltipalta=0,",EG_horacierre='1900-01-01 00:00:00'",",EG_horacierre=?mhoracierre"))+;
				",EG_parFreCard = ?mtipocons "+;
				" where eg_nroregistrac = ?mnroreg and eg_protocolo = ?mprot ")

		else

			mret = sqlexec(mcon1, "update TabGuaEvol set EG_evolHist =?mEvolA "+;
				" , eg_indicnurse =?mindic,eg_codcienanda = ?mcodcienanda "+;
				" , eg_codmed = ?mcodmedpq , eg_evolucion = ?miprotquir "+;
				" , eg_paralerg = ?megparalerg "+;
				iif(mwktaltas.tipoest=0 and mltipalta<>0,",EG_horacierre = ?fechor",+;
				iif(mwktaltas.tipoest<>0 and mltipalta=0,",EG_horacierre='1900-01-01 00:00:00'",",EG_horacierre=?mhoracierre"))+;
				" where eg_nroregistrac = ?mnroreg and eg_protocolo = ?mprot ")


		endif
		if mret < 0
			mret=aerr(eros)
			messagebox(eros(3), 48, "Validacion")
		endif

		if !empty(mevol)  and musua = 0
			mret = sqlexec(mcon1, "insert into TabGuaEvolMed " + ;
				" (egm_proto , egm_codmed , egm_fechah , egm_evol ) values "+;
				" (?mprot, ?mmedico, ?fechor, ?mevol )" )
		endif


	else
		mret = sqlexec(mcon1, "select EG_evolNurse from TabGuaEvol "+;
			" where eg_nroregistrac = ?mnroreg and eg_protocolo = ?mprot  ","mwkctrl")
		mevolNurse = alltrim(nvl(mwkctrl.eg_evolNurse ,'')) + iif(!empty(alltrim(nvl(mwkctrl.eg_evolNurse ,''))),chr(10),'') + miedit

		mret = sqlexec(mcon1, "update TabGuaEvol set EG_evolNurse =?mevolNurse "+;
			",eg_paralerg = ?megparalerg ,eg_parotros = ?mhorapiso, eg_paradmf = ?mhorapisoceg "+;
			iif(mwktaltas.tipoest=0 and mltipalta<>0,",EG_horacierre = ?fechor",+;
			iif(mwktaltas.tipoest<>0 and mltipalta=0,",EG_horacierre='1900-01-01 00:00:00'",",EG_horacierre=?mhoracierre"))+;
			" where eg_nroregistrac = ?mnroreg and eg_protocolo = ?mprot  ")
		if mret < 0
			mret=aerr(eros)
			messagebox(eros(3), 48, "Validacion")
		endif

		mret = sqlexec(mcon1, "insert into TabGuaEvolNurse " + ;
			" (egn_codcienanda , egn_evolnurse , egn_fechah , egn_paradmf , egn_paralerg , " + ;
			"egn_paralergque , egn_parfrecard , egn_parfreresp , egn_pargluc , egn_parotros , " + ;
			"egn_parpeso , egn_parsatur , egn_partemaxl , egn_partembuc , egn_partemrct , " + ;
			"egn_partensdia , egn_partenssis , egn_proto , egn_usuario  "+;
			" ) values "+;
			" (1, ?msoloevol,?fechor,?mparadmf , ?mparalerg , "+;
			" ?mparalergque ,?mparfrecard,?mparfreresp , ?mpargluc , " +;
			" ?mparotros  , ?mparpeso , ?mparsatur , ?mpartemaxl , ?mpartembuc , ?mpartemrct ,"+;
			" ?mpartensdia , ?mpartenssis , ?mprot,?musua )" )

		if mret < 0
			mret=aerr(eros)
			messagebox(eros(3), 48, "Validacion")
		endif
	endif

*!*  25-02-2011  Reversion estado de ALTA
	if mwktaltas.tipoest<>0 and mltipalta=0
		do sp_gua_revierte_alta with mwkverevol.eg_horacierre,mmedico,mlcodesta,mwktaltas.id,mprot
	endif

endif

if mret < 0
	=aerr(eros)
	messagebox(eros(3), 48, "Validacion")
endif
