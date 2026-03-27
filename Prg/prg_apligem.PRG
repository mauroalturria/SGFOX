Clear

Public oApli
oApli = Newobject("oApliGem","c:\desaguemes\prg_apligem.PRG")
If oApli.ValidoAfiliado("62118403801")
	?oApli.lcRespuesta
Else
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
Endif 


Define Class oApliGem As Custom
	mAuform = 'XL' && AUFORM C(2)
	mAucuit = 30663434191 && AUCUIT n(11)
	mAuisoa = 000000 && AUISOA n(6)
	mAucred = '61215177703' && AUCRED c(20) && 61215177703 nicolas
	mAutrac = 01 && AUTRAC n(2)
	mAuatrc = 'A' && AUATRC c(1)
	mAumana = 'M' && AUMANA c(1)
	mAuwref = '' && AUWREF c(2)
	mAunref = 000000 && AUNREF n(6)
	mAutmat = '' && AUTMAT c(2)
	mAunmat = 000000 && AUNMAT n(6)
	mAufecp = 00000000 && AUFECP n(8)
	mAudsm1 = '' && AUDSM1 c(6)
	mAudsm2 = '' && AUDSM2 c(6)
	mAufina = 0 && AUFINA n(1)
	mAuverc = 00 && AUVERC n(2)
	mAucuef = '' && AUCUEF c(11)
	mAucupr = '' && AUCUPR c(11)
	mAuhorp = '' && AUHORP c(6)
	mAumota = '' && AUMOTA c(2)
	mAuobsp = '' && AUOBSP c(80)
	mAumutu = '' && AUMUTU c(6)
	mAutida = '' && AUTIDA c(1)
	mAubole = '' && AUBOLE c(8)
	mAuimag = '' && AUIMAG c(30)
	mAuband = '' && AUBAND c(100)
	mAulic2 = '' && AULIC2 c(14)
*!* ---------------------------------------------------------------------------
	lcDirFinal = ''
	lcDirTerm = "c:\activia\" && "O:\"
	lnTerm = "11"
	lcTerm = 'TER'
	lnError = 0
*-------------------------------------
	lcRespuesta = ''
	lcRespuestaFull = ''
	lcCodTr = ''
*!* ---------------------------------------------------------------------------
	Procedure Init
	This.Seteos()
	This.CreoStructura()
	This.Creo_lstError()

	Endproc

	Procedure Seteos()
	This.lcDirFinal = Addbs(This.lcDirTerm + This.lcTerm + This.lnTerm)
	If !Directory(This.lcDirFinal)
		*Md &This.lcDirFinal
	Endif
	Endproc

*!* ---------------------------------------------------------------------------
	Procedure ValidoAfiliado
	Lparameters tAucred
	Do While .t.
		This.CreoStructura()
		This.mAucred = tAucred
		This.mAutrac = 01  && AUTRAC n(2)
		This.mAuatrc = 'A' && AUATRC c(1)
		This.Cabecera_Add()
		This.lcCodTr = This.PasoNro(Str(clicab.AUTRAC,2,0)) + Alltrim(clicab.AUATRC)
		This.Cabecera_Save()
		This.Status_Save("C")
		If !This.Status_Read()
			Loop
		Endif 
		This.Status_Save("Q")
		This.Respuesta_Get()
		This.lcRespuesta = This.Resp_Tabla_Get()

		Wait Clear
		
		Exit
	Enddo	
	Return (This.lnError = 0)

	Endproc

*!* ---------------------------------------------------------------------------
	Function Respuesta_Get
*!* ---------------------------------------------------------------------------
	lcRespuesta = Filetostr(This.lcDirFinal + "SERESP.SLT")
	This.lcRespuestaFull = lcRespuesta
	mAuwhoo = Substr(lcRespuesta,1,2) && AUWHOO c(2)
	mAuauto = Int(Val(Substr(lcRespuesta,3,6))) && AUAUTO n(6)
	mAurest = Substr(lcRespuesta,9,2) && AUREST c(2)
	mAuleyd = Substr(lcRespuesta,11,40) && AULEYD c(40)
	mAuleyp = Substr(lcRespuesta,51,80) && AULEYP c(80)
	mAumont = Val(Substr(lcRespuesta,131,9) + "," + Substr(lcRespuesta,140,2)) && AUMONT N(9,2)
	mAuplan = Substr(lcRespuesta,142,5) && AUPLAN c(5)
	mAutaso = Substr(lcRespuesta,147,1) && AUTASO c(1)
	mAuinc1 = Int(Val(Substr(lcRespuesta,148,2))) && AUINC1 n(2)
	mAuinc2 = Int(Val(Substr(lcRespuesta,150,2))) && AUINC2 n(2)
	mAusyst = Int(Val(Substr(lcRespuesta,152,6))) && AUSYST n(6)
	mAuobse = Substr(lcRespuesta,158,50) && AUOBSE c(50)
	mAureqd = Substr(lcRespuesta,208,2) && AUREQD c(2)
	mAucred = Substr(lcRespuesta,210,20) && AUCRED c(20)
	mAunomb = Substr(lcRespuesta,230,30) && AUNOMB c(30)
	mAusexo = Substr(lcRespuesta,260,1) && AUSEXO c(1)
	mAunaci = Substr(lcRespuesta,261,8) && AUNACI c(8)
	mAucosg = Val(Substr(lcRespuesta,269,9) + "," + Substr(lcRespuesta,278,2)) && AUCOSG n(9,2)
	mFiller = Substr(lcRespuesta,280,71) && filler c(71)


	Insert Into SERESP ;
		(Auwhoo, Auauto, Aurest, Auleyd, Auleyp, ;
		Aumont, Auplan, Autaso, Auinc1, Auinc2,  ;
		Ausyst, Auobse, Aureqd, Aucred, Aunomb,  ;
		Ausexo, Aunaci, Aucosg, Filler);
		Values ;
		(mAuwhoo, mAuauto, mAurest, mAuleyd, mAuleyp, ;
		mAumont, mAuplan, mAutaso, mAuinc1, mAuinc2,  ;
		mAusyst, mAuobse, mAureqd, mAucred, mAunomb,  ;
		mAusexo, mAunaci, mAucosg, mFiller)
	Endproc

	Procedure Resp_Tabla_Get()
	lcResu = ''
	Select MWKERRACT
	Locate For Alltrim(MWKERRACT.Tr) = This.lcCodTr And Alltrim(MWKERRACT.Cod) = Alltrim(SERESP.Aurest)
	If Found()
		lcResu = MWKERRACT.Descrip
	Endif
*!*		If SERESP.AUTASO = 'O'
*!*			? "Tipo de Asociado (O)bligatorio"
*!*		Else && "D"
*!*			? "Tipo de Asociado (D)irecto"
*!*		Endif
	Return lcResu
	Endproc
*!* ---------------------------------------------------------------------------
	Procedure Status_Read
	lcStatus = Filetostr(This.lcDirFinal + "STATUS.SLT")
	Wait Window "Leo Status" nowait
	lbResu = .t.
	
	Do While Left(lcStatus,1) <> 'S'
		If File(This.lcDirFinal + "STATUS.SLT")
			lcStatus = Filetostr(This.lcDirFinal + "STATUS.SLT")
		Else
			?"NO ENCUENTRA EL ARCHIVO " + (This.lcDirFinal + "STATUS.SLT")
		Endif
		If lcStatus = 'Q'
			?"--------------- REINTENTO -----------------"  
			lbResu = .f.
			Exit 
		Endif 
	Enddo
	Return lbResu
	Endproc
*!* ---------------------------------------------------------------------------
	Procedure Status_Save
	Lparameters tcStatus
	Wait Window "Guardo Status" nowait
	Strtofile(tcStatus, This.lcDirFinal + "STATUS.SLT")
	Endproc

*!* ---------------------------------------------------------------------------
	Procedure Cabecera_Save

	Select clicab
	lcMemo = Auform + This.PasoNro(Str(Aucuit,11,0)) + This.PasoNro(Str(Auisoa,6,0)) + Aucred
	lcMemo = lcMemo + This.PasoNro(Str(AUTRAC,2,0)) + AUATRC + Aumana + Auwref
	lcMemo = lcMemo + This.PasoNro(Str(Aunref,6,0)) + Autmat + This.PasoNro(Str(Aunmat,6,0)) + This.PasoNro(Str(Aufecp,8,0))
	lcMemo = lcMemo + Audsm1 + Audsm2 + This.PasoNro(Str(Aufina,1,0)) + This.PasoNro(Str(Auverc,2,0))
	lcMemo = lcMemo + Aucuef + Aucupr + Auhorp + Aumota
	lcMemo = lcMemo + Auobsp + Aumutu + Autida + Aubole
	lcMemo = lcMemo + Auimag + Auband + Aulic2

	Strtofile(lcMemo, This.lcDirFinal + "CLICAB.SLT")



*!* ---------------------------------------------------------------------------
	Procedure Cabecera_Add

	Insert Into clicab ;
		(Auform , Aucuit, Auisoa, Aucred, AUTRAC,  ;
		AUATRC, Aumana, Auwref, Aunref, Autmat,  ;
		Aunmat, Aufecp, Audsm1, Audsm2, Aufina,  ;
		Auverc, Aucuef, Aucupr, Auhorp, Aumota,  ;
		Auobsp, Aumutu, Autida, Aubole, Auimag,  ;
		Auband, Aulic2) Values ;
		(This.mAuform , This.mAucuit, This.mAuisoa, This.mAucred, This.mAutrac,  ;
		This.mAuatrc, This.mAumana, This.mAuwref, This.mAunref, This.mAutmat,  ;
		This.mAunmat, This.mAufecp, This.mAudsm1, This.mAudsm2, This.mAufina,  ;
		This.mAuverc, This.mAucuef, This.mAucupr, This.mAuhorp, This.mAumota,  ;
		This.mAuobsp, This.mAumutu, This.mAutida, This.mAubole, This.mAuimag,  ;
		This.mAuband, This.mAulic2)
	Endproc
*!* ---------------------------------------------------------------------------
	Procedure CreoStructura

	Create Cursor clicab (Auform C(2), ;
		Aucuit N(11), ;
		Auisoa N(6), ;
		Aucred C(20), ;
		AUTRAC N(2), ;
		AUATRC C(1), ;
		Aumana C(1), ;
		Auwref C(2), ;
		Aunref N(6), ;
		Autmat C(2), ;
		Aunmat N(6), ;
		Aufecp N(8), ;
		Audsm1 C(6), ;
		Audsm2 C(6), ;
		Aufina N(1), ;
		Auverc N(2), ;
		Aucuef C(11), ;
		Aucupr C(11), ;
		Auhorp C(6), ;
		Aumota C(2), ;
		Auobsp C(80), ;
		Aumutu C(6), ;
		Autida C(1), ;
		Aubole C(8), ;
		Auimag C(30), ;
		Auband C(100), ;
		Aulic2 C(14))

	Create Cursor SERESP ;
		(Auwhoo C(2), ;
		Auauto N(6), ;
		Aurest C(2), ;
		Auleyd C(40), ;
		Auleyp C(80), ;
		Aumont N(9,2), ;
		Auplan C(5), ;
		Autaso C(1), ;
		Auinc1 N(2), ;
		Auinc2 N(2), ;
		Ausyst N(6), ;
		Auobse C(50), ;
		Aureqd C(2), ;
		Aucred C(20), ;
		Aunomb C(30), ;
		Ausexo C(1), ;
		Aunaci C(8), ;
		Aucosg N(9,2),;
		Filler C(71))



	Endproc

*!* ---------------------------------------------------------------------------
	Procedure Creo_lstError
*!* ---------------------------------------------------------------------------
	Create Cursor MWKERRACT ;
		(Tr C(3), ;
		Cod C(3), ;
		Descrip C(120), ;
		MensErrorDSP C(120), ;
		MensErrorPRT C(120))
*!* ---------------------------------------------------------------------------
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('01A', '00', 'Asociado Habilitado', 'OK, Asociado Habilitado', 'OK, Asociado Habilitado')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('01A', '01', 'Afiliado Inexistente', 'ERROR, ASOCIADO NO HABILITADO', 'Afiliado Inexistente')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('01A', '02', 'Afiliado de Baja o con Alta a futuro', 'ERROR, ASOCIADO NO HABILITADO', 'Afiliado No Vigente N° VIG: 99-9999999-99 (si lo tiene)')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('01A', '03', 'Afiliado Moroso', 'ERROR, ASOCIADO NO HABILITADO', 'Asociado NO habilitado Pase por O.S.D.E.')
*!* ---------------------------------------------------------------------------
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('01B', '00', 'Asociado con Cobertura', 'OK, Asociado y Prestación Habilitados', 'OK, Asociado y Prestación Habilitados')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('01B', '04', 'Prestación Inexistente', 'ERROR, ASOCIADO Y/O PRESTAC. NO HABILIT.', 'XX.XX.XX Inexistente')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('01B', '05', 'Carencia', 'ERROR, ASOCIADO Y/O PRESTAC. NO HABILIT.', 'XX.XX.XX NO Habilitada')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('01B', '06', 'Preexistencia', 'ERROR, ASOCIADO Y/O PRESTAC. NO HABILIT.', 'XX.XX.XX NO Habilitada')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('01B', '07', 'Excepción', 'ERROR, ASOCIADO Y/O PRESTAC. NO HABILIT.', 'XX.XX.XX NO Habilitada')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('01B', '08', 'Supera Tope', 'ERROR, ASOCIADO Y/O PRESTAC. NO HABILIT.', 'XX.XX.XX NO Habilitada')
*!* ---------------------------------------------------------------------------
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('01C', '00', 'Prestador Habilitado', 'OK. Asoc./Prest. Y Prestación Habilitados', 'OK. Asoc./Prest. Y Prestación Habilitados')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('01C', '10', 'Prestación Inexistente', 'ERROR, ASOCIADO Y/O PRESTAC. NO HABILIT.', 'Prestador Inexistente')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('01C', '11', 'Prestador NO Autorizado para POS', 'ERROR, ASOCIADO Y/O PRESTAC. NO HABILIT.', 'NO Habilit. POS.XXXX')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('01C', '12', 'Prestación NO Contratada', 'ERROR, ASOCIADO Y/O PRESTAC. NO HABILIT.', 'Prestador NO Habilitado Plan X XXX')
*!* ---------------------------------------------------------------------------
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('02A', '00', 'Prestación Registrada', 'OK, Prestación Registrada', 'OK, Prestación Registrada')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('02A', '13', 'Código de Autorización Erróneo', 'ERROR, REGISTRACIÓN NO REALIZADA.', 'Solicitud XXXXXX Errónea')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('02A', '14', 'Solicitud Anulada/Rechaza/Sin Saldo', 'ERROR, Asoc/Prest. Y/o Prestación NO habilitados', 'Cod. XXXXXX Rechazado')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('02A', '18', 'El prestador no puede emitir órdenes en la terminal', 'ERROR,PREST/ASOC/PRACTICA NO HABILITADO', 'NO PUEDE EMITIR ORD.')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('02A', '27', 'Cód. de Finalización de terapia No Válido', 'ERROR, Asoc/Prest. Y/o Prestación NO habilitados', 'COD.FIN.TER.INVALIDO')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('02A', '28', 'Fecha de práctica anterior a la fecha de la orden', 'ERROR, Asoc/Prest. Y/o Prestación NO habilitados', 'FEC.PRACT<FEC.ORDEN')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('02A', '31', 'La práctica requiere auditoría u orden de internación', 'ERROR, REGISTRACIÓN NO REALIZADA.', 'XXXXXX REQ.AUD./O.IN')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('02A', '99', 'la obra social no puede responder por problemas de comunicación.', 'ERROR, COMUNICACIÓN INTERRUMPIDA, INTENTE NUEVAMENTE.', 'ERROR, COMUNICACIÓN INTERRUMPIDA.')
*!* ---------------------------------------------------------------------------
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('02B', '00', 'Prescripción Registrada', 'OK, Prescripción Registrada', 'OK, Prescripción Registrada')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('02B', '17', 'El prestador no puede prescribir en la terminal.', 'ERROR,PREST/ASOC/PRACTICA NO HABILITADO', 'NO PUEDE PRESCRIBIR')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('02B', '20', 'Efector Inválido', 'Efector Inválido', 'Efector Inválido')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('02B', '21', 'No requiere Prescripción', 'ERROR, Prescripción no Realizada.', 'XX.XX.XX No Requiere Autoriz.')
*!* ---------------------------------------------------------------------------
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('02C', '00', 'Solicitud Registrada', 'OK, Solicitud Registrada', 'OK, Solicitud Registrada')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('02C', '23', 'La prestación NO Requiere Autorización Previa', 'ERROR, Solicitud NO Realizada', 'XX.XX.XX No Requiere Autoriz.')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('02C', '24', 'Solicitud Existente', 'ERROR, Solicitud NO Realizada', 'Solicitud Existente N° XXX.XXX') && -ERR-
*!* ---------------------------------------------------------------------------
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('02D', '00', 'Prestación off-line Registrada', 'OK, Prestación Registrada', 'OK, Prestación Registrada')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('02D', '25', 'Fecha Inválida', 'ERROR, Asoc/Prest. Y/o Prestación NO habilitados', 'Fecha Práctica Inválida.')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('02D', '26', 'Credencial Vencida', 'ERROR, Asoc/Prest. Y/o Prestación NO habilitadosa', 'Credencial Vencida')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('02D', '29', 'Transacción 2D no puede ser automática', 'ERROR,PREST/ASOC/PRACTICA NO HABILITADO', 'Debe ser ing. Manual')
*!* ---------------------------------------------------------------------------
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('03A', '00', 'Solicitud Aceptada', 'OK, Solicitud N° XXX.XXX Aceptada', 'OK, Solicitud N° XXX.XXX Aceptada')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('03A', '15', 'No Existe Solicitud para el Asociado', 'No Existe Sol.para el Asociado', 'No Existe Sol. para el Asociado')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('03A', '36', 'Pendiente de Resolución', 'Solicitud N° XXX.XXX Pendiente de Resolución', 'Solicitud N° XXX.XXX Pendiente de Resolución')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('03A', '37', 'Solicitud Rechazada', '', 'Solicitud N° XXX.XXX Rechazada')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('03A', '38', 'Solicitud N° XXX Anulada.', '', 'Solicitud N° XXX.XXX Anulada')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('03A', '39', 'Solicitud NO existente', 'ERROR, Solicitud Inexistente', 'Solicitud N° XXX.XXX Inexistente')
*!* ---------------------------------------------------------------------------
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('04A', '00', 'Anulación Registrada', 'Anulación Registrada', 'Trans. N° XXX.XXX Anulada')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('04A', '19', 'Transacción Errónea', 'Anulación NO Registrada', 'Trans. N° XXX.XXX Inexistente')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('04A', '40', 'Solicitud NO Anulable por que ya fue consumida Total o en Parte o porque fue solicitada desde otro P.O.S.', 'Anulación NO Registrada', 'Solicitud N° XXX.XXX No Anulable')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('04A', '41', 'Solicitud Inexistente.', '', 'Solicitud N° XXX.XXX No Anulable')
*!* ---------------------------------------------------------------------------
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('05x', '00', 'Solicitud de Informe Aceptada', 'Solicitud de Informe Aceptada', 'Solicitud de Informe Aceptada')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('05x', '42', 'Tipo y/o atributo transacción inválido', 'TIPO Y/O ATRIB. DE TRANSACC. INVALIDO', 'Tipo y/o atrib. De Transacc. Invalido')
	Insert Into MWKERRACT (Tr, Cod, Descrip, MensErrorDSP, MensErrorPRT) Values ('05x', '99', 'la obra social no puede responder por problemas de comunicación.', 'ERROR, COMUNICACIÓN INTERRUMPIDA, INTENTE NUEVAMENTE.', 'ERROR, COMUNICACIÓN INTERRUMPIDA.')

	Endproc

	Procedure Destroy

	Endproc

	Procedure Error(nerror, Cmethod, Nline)
		?"---------------------------------"
		?"ERROR " + Transform(nerror)
		?"METODO " + Transform(cMethod)
		?"LINEA " + Transform(Nline)
		This.lnError = nerror
		?"---------------------------------"
	Endproc

*!* ---------------------------------------------------------------------------
	Function PasoNro
	Parameters lcNro
*!* ---------------------------------------------------------------------------
	lnLen  = Len(lcNro)
	lcNro = Padl(Alltrim(lcNro),lnLen,"0")
	Return lcNro


Enddefine





