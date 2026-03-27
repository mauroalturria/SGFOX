*
* Alta registro Paciente Traumatizado
*
Lparameters mform

If used('mwkdatos')
	Use in mwkdatos
Endif

If used('mwkactu')
	Use in mwkactu
Endif

Select * from mwkbaseg1 where estado = 1 into cursor mwkactu

muse = mwkusuario.idusuario
mfec = sp_busco_fecha_serv('DT')

*myip = IPAddress()

Dimension vdat[72]

With mform.PGConsulta

	vdat[01] = alltrim(mform.txthistoria.value)  && hce
	vdat[02] = alltrim(mform.txtprotocolo.value)  && protocolo
	vdat[03] = mform.lproto                 && edad solo digitos
	vdat[04] = alltrim(mform.txtsexo.value) && sexo

	With .Page1
		vdat[05] = mwkbase3.id              && antecedentes traumaticos personales
		vdat[06] = iif(.txtfecha.value={//},ctod("01/01/1900"),.txtfecha.value) && fecha traumatismo
		vdat[07] = .txthora.value           && hora
		vdat[08] = dow(.txtfecha.value)     && dia de la semana
		vdat[09] = mwkbase4.id              && tipo

		mvalor = ''
		For mi = 1 to 4
			mcampo = '.chk'+alltrim(str(mi))+'.value'
			mvalor = mvalor + alltrim(str(&mcampo))
		Next mi

		vdat[10] = mvalor         && Quemadura - Intoxicacion
		vdat[11] = mwkbase5.id    && Circunstancia
		vdat[12] = mwkbase6.id    && Mecanismo
		vdat[13] = .txtdesc.value && Breve descripcion
		vdat[14] = .chk5.value    && Accidente de transito
		vdat[15] = mwkbase7.id    && condicion
		vdat[16] = mwkbase8.id    && pasajero
		vdat[17] = mwkbase9.id    && tipo de incidente
		vdat[18] = mwkbase10.id   && 1er Vehiculo
		vdat[19] = mwkbase11.id   && 2do Vehiculo
		vdat[20] = mwkbase12.id   && proteccion
		vdat[21] = mwkbase13.id   && lugar incidente
		vdat[22] = mwkbase14.id   && ambiente
	Endwith

	With .Page2
		vdat[23] = .chk6.value    && manejo inicial en el lugar

		mvalor = ''
		For mi = 7 to 13
			mcampo = '.chk'+alltrim(str(mi))+'.value'
			mvalor = mvalor + alltrim(str(&mcampo))
		Next mi
		vdat[24] = mvalor         && opciones manejo inicial
		vdat[25] = mwkbase15.id   && atendido por
		vdat[26] = mwkbase16.id   && operador

		mvalor = ''
		For mi = 14 to 21
			mcampo = '.chk'+alltrim(str(mi))+'.value'
			mvalor = mvalor + alltrim(str(&mcampo))
		Next mi

		vdat[27] = mvalor         && transporte desde lugar incidente
		vdat[28] = .chk22.value   && hospital intermedio

		mvalor = ''
		For mi = 23 to 27
			mcampo = '.chk'+alltrim(str(mi))+'.value'
			mvalor = mvalor + alltrim(str(&mcampo))
		Next mi
		vdat[29] = mvalor         && tratamiento
		vdat[30] = .chk28.value   && derivacion x necesidad alta complejidad

		mvalor = ''
		For mi = 29 to 35
			mcampo = '.chk'+alltrim(str(mi))+'.value'
			mvalor = mvalor + alltrim(str(&mcampo))
		Next mi
		vdat[31] = mvalor          && transporte desde ultima institucion
		vdat[32] = .txtinst.value  && cantidad de instituciones
		vdat[33] = .txthoras.value && hs. permanencia

	Endwith

	With .Page3
		vdat[34] = iif(	.txtfingreso.value={//},ctod("01/01/1900"),.txtfingreso.value) && fecha ingreso
		vdat[35] = .txthoraing.value  && hora ingreso
		vdat[36] = .txtctp.value      && tiempo traumatismo CTP
		vdat[37] = .chk1.value        && derivado vivo...
		vdat[38] = .txtdistan.value   && distancia desde lugar hecho...
		vdat[39] = mwkbase17.id       && estado al ingreso
		vdat[40] = .txttemp.value     && temperatura
		vdat[41] = mwkbase18.id       && lugar de registro temp.
		vdat[42] = mwkbase1.id        && frecuencia respiratoria
		vdat[43] = .txtfrecard.value  && frecuencia cardiaca
		vdat[44] = mwkbase19.id       && respiracion
		vdat[45] = .chk2.value        && intubado
		vdat[46] = mwkbase2.id        && tension sistolica
		vdat[47] = .txtrts.value      && indice RTS
		vdat[48] = .txtglasgow.value  && puntaje glasgow
		vdat[49] = mwkbase20.id       && apertura ocular
		vdat[50] = mwkbase21.id       && respuesta verbal
		vdat[51] = mwkbase22.id       && mejor resp. motora
		vdat[52] = .txtiss.value      && score ISS

		*vdat[53] = mwkbase23.id       && lesion respiratoria
		*vdat[54] = mwkbase24.id       && lesion abdominal
		*vdat[55] = mwkbase25.id       && lesion sistema nervioso
		*vdat[56] = mwkbase26.id       && lesion musculoesqueletica
		*vdat[57] = mwkbase27.id       && lesion cardiovascular
		*vdat[58] = mwkbase28.id       && lesion de la piel

	Endwith

	With .Page4

		mvalor = ''
		For mi = 1 to 8
			mcampo = '.chk'+alltrim(str(mi))+'.value'
			mvalor = mvalor + alltrim(str(&mcampo))
		Next mi
		vdat[59] = mvalor        && estudios
		vdat[60] = .chk9.value   && tratamiento

		mvalor = ''
		For mi = 10 to 26
			mcampo = '.chk'+alltrim(str(mi))+'.value'
			mvalor = mvalor + alltrim(str(&mcampo))
		Next mi
		vdat[61] = mvalor        && tipo de tratamiento

		vdat[62] = .chk27.value  && complicaciones

		mvalor = ''
		For mi = 28 to 42
			mcampo = '.chk'+alltrim(str(mi))+'.value'
			mvalor = mvalor + alltrim(str(&mcampo))
		Next mi
		vdat[63] = mvalor        && tipo de complicaciones

		vdat[64] = .chk43.value  && condiciones preexistentes

		mvalor = ''
		For mi = 44 to 50
			mcampo = '.chk'+alltrim(str(mi))+'.value'
			mvalor = mvalor + alltrim(str(&mcampo))
		Next mi
		vdat[65] = mvalor        && tipo de condiciones

	Endwith

	With .Page5
		vdat[66] = .chk1.value        && discapacidad o secuelas...
		vdat[67] = .txtdesc.value     && breve descripcion...
		vdat[68] = iif(.txtegreso.value={//},ctod("01/01/1900"),.txtegreso.value)   && fecha egreso
		vdat[69] = .txtintotal.value  && dias int. totales
		vdat[70] = .txtintsala.value  && dias int. sala
		vdat[71] = .txtintucip.value  && dias int. UCIP
		vdat[72] = mwkbase29.id       && estado al egreso
	Endwith

Endwith

If mform.ltipo = 1

	msg = "INGRESO"

*!*		mret = sqlexec(mcon1,"insert into TabFichaTraumatologica"+;
*!*			"(FT_hce, FT_protocolo, FT_edad, FT_sexo, FT_antTrauEsp, FT_fechaTrau, FT_horaTrau, FT_diasemana, " +;
*!*			"FT_tipoTrau, FT_queint, FT_circunst, FT_mecanismo, FT_descr, FT_actran, FT_condicion, FT_pasajero,"+;
*!*			"FT_tipoinci, FT_privehicu, FT_segvehicu, FT_proteccion, FT_lugarinc, FT_ambiente, FT_manejoini, "+;
*!*			"FT_manopc, FT_atendido, FT_operador, FT_transp, FT_hospint, FT_tratamto, FT_deriva, FT_transpu, "+;
*!*			"FT_insinter, FT_hsinst, FT_fechaIngr, FT_horaIngr, FT_hsCTP, FT_dervivo, FT_distancia, FT_estadoing, "+;
*!*			"FT_temperatura, FT_lugartemp, FT_frecResp, FT_frecCar, FT_respira, FT_intubado, FT_tas, FT_indRts, "+;
*!*			"FT_glasgow, FT_aperOcular, FT_respVerbal, FT_respMotora, FT_iss, FT_lesionresp, FT_lesionabdo, "+;
*!*			"FT_lesionNerv, FT_lesionMusc, FT_lesionCardio, FT_lesionPiel, FT_estudios, FT_tratamiento, "+;
*!*			"FT_tratipo, FT_complica, FT_compltip, FT_condpre, FT_condtip, FT_secuelas, FT_descsec, "+;
*!*			"FT_fecEgreso, FT_diasint, FT_diasSala, FT_diasucip, FT_estadoEgr)"+;
*!*			" values "+;
*!*			"(?vdat[01],?vdat[02],?vdat[03],?vdat[04],?vdat[05],?vdat[06],?vdat[07],?vdat[08],?vdat[09],"+;
*!*			"?vdat[10],?vdat[11],?vdat[12],?vdat[13],?vdat[14],?vdat[15],?vdat[16],?vdat[17],?vdat[18],?vdat[19],"+;
*!*			"?vdat[20],?vdat[21],?vdat[22],?vdat[23],?vdat[24],?vdat[25],?vdat[26],?vdat[27],?vdat[28],?vdat[29],"+;
*!*			"?vdat[30],?vdat[31],?vdat[32],?vdat[33],?vdat[34],?vdat[35],?vdat[36],?vdat[37],?vdat[38],?vdat[39],"+;
*!*			"?vdat[40],?vdat[41],?vdat[42],?vdat[43],?vdat[44],?vdat[45],?vdat[46],?vdat[47],?vdat[48],?vdat[49],"+;
*!*			"?vdat[50],?vdat[51],?vdat[52],?vdat[53],?vdat[54],?vdat[55],?vdat[56],?vdat[57],?vdat[58],?vdat[59],"+;
*!*			"?vdat[60],?vdat[61],?vdat[62],?vdat[63],?vdat[64],?vdat[65],?vdat[66],?vdat[67],?vdat[68],?vdat[69],"+;
*!*			"?vdat[70],?vdat[71],?vdat[72])")


	mret = sqlexec(mcon1,"insert into TabFichaTraumatologica"+;
		"(FT_hce, FT_protocolo, FT_edad, FT_sexo, FT_antTrauEsp, FT_fechaTrau, FT_horaTrau, FT_diasemana, " +;
		"FT_tipoTrau, FT_queint, FT_circunst, FT_mecanismo, FT_descr, FT_actran, FT_condicion, FT_pasajero,"+;
		"FT_tipoinci, FT_privehicu, FT_segvehicu, FT_proteccion, FT_lugarinc, FT_ambiente, FT_manejoini, "+;
		"FT_manopc, FT_atendido, FT_operador, FT_transp, FT_hospint, FT_tratamto, FT_deriva, FT_transpu, "+;
		"FT_insinter, FT_hsinst, FT_fechaIngr, FT_horaIngr, FT_hsCTP, FT_dervivo, FT_distancia, FT_estadoing, "+;
		"FT_temperatura, FT_lugartemp, FT_frecResp, FT_frecCar, FT_respira, FT_intubado, FT_tas, FT_indRts, "+;
		"FT_glasgow, FT_aperOcular, FT_respVerbal, FT_respMotora, FT_iss, FT_estudios, FT_tratamiento, "+;
		"FT_tratipo, FT_complica, FT_compltip, FT_condpre, FT_condtip, FT_secuelas, FT_descsec, "+;
		"FT_fecEgreso, FT_diasint, FT_diasSala, FT_diasucip, FT_estadoEgr,"+;
		"FT_ipadress,FT_idusuario,FT_fechamov )"+;
		" values "+;
		"(?vdat[01],?vdat[02],?vdat[03],?vdat[04],?vdat[05],?vdat[06],?vdat[07],?vdat[08],?vdat[09],"+;
		"?vdat[10],?vdat[11],?vdat[12],?vdat[13],?vdat[14],?vdat[15],?vdat[16],?vdat[17],?vdat[18],?vdat[19],"+;
		"?vdat[20],?vdat[21],?vdat[22],?vdat[23],?vdat[24],?vdat[25],?vdat[26],?vdat[27],?vdat[28],?vdat[29],"+;
		"?vdat[30],?vdat[31],?vdat[32],?vdat[33],?vdat[34],?vdat[35],?vdat[36],?vdat[37],?vdat[38],?vdat[39],"+;
		"?vdat[40],?vdat[41],?vdat[42],?vdat[43],?vdat[44],?vdat[45],?vdat[46],?vdat[47],?vdat[48],?vdat[49],"+;
		"?vdat[50],?vdat[51],?vdat[52],?vdat[59],"+;
		"?vdat[60],?vdat[61],?vdat[62],?vdat[63],?vdat[64],?vdat[65],?vdat[66],?vdat[67],?vdat[68],?vdat[69],"+;
		"?vdat[70],?vdat[71],?vdat[72],?myip,?muse,?mfec)")

	If mret > 0
		mret = sqlexec(mcon1,"select id as lid from TabFichaTraumatologica"+;
			" where FT_ipadress=?myip and FT_idusuario=?muse and FT_fechamov=?mfec","mwkdatos")
		If mret > 0
			Select mwkdatos
			Go top
			mlidat = mwkdatos.lid
			Use in mwkdatos

			Select  mwkactu
			Scan all
				midais = mwkactu.lid
				mret = sqlexec(mcon1,"insert into TabFichaTrauVal2 (FT_idAis, FT_idficha) values (?midais,?mlidat)")
				If mret < 0
					msg = msg +", ALTA CODIGOS AIS"
					Exit
				Endif
			Endscan

		Else
			msg = msg + ", BUSQUEDA ID FICHA TRAUMA"
		Endif
	Endif

Else

	msg = "ACTUALIZACION"

*!*		mret = sqlexec(mcon1,"update TabFichaTraumatologica set "+;
*!*			"FT_hce=?vdat[01],"+;
*!*			"FT_edad=?vdat[03],"+;
*!*			"FT_sexo=?vdat[04],"+;
*!*			"FT_antTrauEsp=?vdat[05],"+;
*!*			"FT_fechaTrau=?vdat[06],"+;
*!*			"FT_horaTrau=?vdat[07],"+;
*!*			"FT_diasemana=?vdat[08],"+;
*!*			"FT_tipoTrau=?vdat[09],"+;
*!*			"FT_queint=?vdat[10],"+;
*!*			"FT_circunst=?vdat[11],"+;
*!*			"FT_mecanismo=?vdat[12],"+;
*!*			"FT_descr=?vdat[13],"+;
*!*			"FT_actran=?vdat[14],"+;
*!*			"FT_condicion=?vdat[15],"+;
*!*			"FT_pasajero=?vdat[16],"+;
*!*			"FT_tipoinci=?vdat[17],"+;
*!*			"FT_privehicu=?vdat[18],"+;
*!*			"FT_segvehicu=?vdat[19],"+;
*!*			"FT_proteccion=?vdat[20],"+;
*!*			"FT_lugarinc=?vdat[21],"+;
*!*			"FT_ambiente=?vdat[22],"+;
*!*			"FT_manejoini=?vdat[23],"+;
*!*			"FT_manopc=?vdat[24],"+;
*!*			"FT_atendido=?vdat[25],"+;
*!*			"FT_operador=?vdat[26],"+;
*!*			"FT_transp=?vdat[27],"+;
*!*			"FT_hospint=?vdat[28],"+;
*!*			"FT_tratamto=?vdat[29],"+;
*!*			"FT_deriva=?vdat[30],"+;
*!*			"FT_transpu=?vdat[31],"+;
*!*			"FT_insinter=?vdat[32],"+;
*!*			"FT_hsinst=?vdat[33],"+;
*!*			"FT_fechaIngr=?vdat[34],"+;
*!*			"FT_horaIngr=?vdat[35],"+;
*!*			"FT_hsCTP=?vdat[36],"+;
*!*			"FT_dervivo=?vdat[37],"+;
*!*			"FT_distancia=?vdat[38],"+;
*!*			"FT_estadoing=?vdat[39],"+;
*!*			"FT_temperatura=?vdat[40],"+;
*!*			"FT_lugartemp=?vdat[41],"+;
*!*			"FT_frecResp=?vdat[42],"+;
*!*			"FT_frecCar=?vdat[43],"+;
*!*			"FT_respira=?vdat[44],"+;
*!*			"FT_intubado=?vdat[45],"+;
*!*			"FT_tas=?vdat[46],"+;
*!*			"FT_indRts=?vdat[47],"+;
*!*			"FT_glasgow=?vdat[48],"+;
*!*			"FT_aperOcular=?vdat[49],"+;
*!*			"FT_respVerbal=?vdat[50],"+;
*!*			"FT_respMotora=?vdat[51],"+;
*!*			"FT_iss=?vdat[52],"+;
*!*			"FT_lesionresp=?vdat[53],"+;
*!*			"FT_lesionabdo=?vdat[54],"+;
*!*			"FT_lesionNerv=?vdat[55],"+;
*!*			"FT_lesionMusc=?vdat[56],"+;
*!*			"FT_lesionCardio=?vdat[57],"+;
*!*			"FT_lesionPiel=?vdat[58],"+;
*!*			"FT_estudios=?vdat[59],"+;
*!*			"FT_tratamiento=?vdat[60],"+;
*!*			"FT_tratipo=?vdat[61],"+;
*!*			"FT_complica=?vdat[62],"+;
*!*			"FT_compltip=?vdat[63],"+;
*!*			"FT_condpre=?vdat[64],"+;
*!*			"FT_condtip=?vdat[65],"+;
*!*			"FT_secuelas=?vdat[66],"+;
*!*			"FT_descsec=?vdat[67],"+;
*!*			"FT_fecEgreso=?vdat[68],"+;
*!*			"FT_diasint=?vdat[69],"+;
*!*			"FT_diasSala=?vdat[70],"+;
*!*			"FT_diasucip=?vdat[71],"+;
*!*			"FT_estadoEgr=?vdat[72] where FT_protocolo=?vdat[02]")


	mret = sqlexec(mcon1,"update TabFichaTraumatologica set "+;
		"FT_hce=?vdat[01],"+;
		"FT_edad=?vdat[03],"+;
		"FT_sexo=?vdat[04],"+;
		"FT_antTrauEsp=?vdat[05],"+;
		"FT_fechaTrau=?vdat[06],"+;
		"FT_horaTrau=?vdat[07],"+;
		"FT_diasemana=?vdat[08],"+;
		"FT_tipoTrau=?vdat[09],"+;
		"FT_queint=?vdat[10],"+;
		"FT_circunst=?vdat[11],"+;
		"FT_mecanismo=?vdat[12],"+;
		"FT_descr=?vdat[13],"+;
		"FT_actran=?vdat[14],"+;
		"FT_condicion=?vdat[15],"+;
		"FT_pasajero=?vdat[16],"+;
		"FT_tipoinci=?vdat[17],"+;
		"FT_privehicu=?vdat[18],"+;
		"FT_segvehicu=?vdat[19],"+;
		"FT_proteccion=?vdat[20],"+;
		"FT_lugarinc=?vdat[21],"+;
		"FT_ambiente=?vdat[22],"+;
		"FT_manejoini=?vdat[23],"+;
		"FT_manopc=?vdat[24],"+;
		"FT_atendido=?vdat[25],"+;
		"FT_operador=?vdat[26],"+;
		"FT_transp=?vdat[27],"+;
		"FT_hospint=?vdat[28],"+;
		"FT_tratamto=?vdat[29],"+;
		"FT_deriva=?vdat[30],"+;
		"FT_transpu=?vdat[31],"+;
		"FT_insinter=?vdat[32],"+;
		"FT_hsinst=?vdat[33],"+;
		"FT_fechaIngr=?vdat[34],"+;
		"FT_horaIngr=?vdat[35],"+;
		"FT_hsCTP=?vdat[36],"+;
		"FT_dervivo=?vdat[37],"+;
		"FT_distancia=?vdat[38],"+;
		"FT_estadoing=?vdat[39],"+;
		"FT_temperatura=?vdat[40],"+;
		"FT_lugartemp=?vdat[41],"+;
		"FT_frecResp=?vdat[42],"+;
		"FT_frecCar=?vdat[43],"+;
		"FT_respira=?vdat[44],"+;
		"FT_intubado=?vdat[45],"+;
		"FT_tas=?vdat[46],"+;
		"FT_indRts=?vdat[47],"+;
		"FT_glasgow=?vdat[48],"+;
		"FT_aperOcular=?vdat[49],"+;
		"FT_respVerbal=?vdat[50],"+;
		"FT_respMotora=?vdat[51],"+;
		"FT_iss=?vdat[52],"+;
		"FT_estudios=?vdat[59],"+;
		"FT_tratamiento=?vdat[60],"+;
		"FT_tratipo=?vdat[61],"+;
		"FT_complica=?vdat[62],"+;
		"FT_compltip=?vdat[63],"+;
		"FT_condpre=?vdat[64],"+;
		"FT_condtip=?vdat[65],"+;
		"FT_secuelas=?vdat[66],"+;
		"FT_descsec=?vdat[67],"+;
		"FT_fecEgreso=?vdat[68],"+;
		"FT_diasint=?vdat[69],"+;
		"FT_diasSala=?vdat[70],"+;
		"FT_diasucip=?vdat[71],"+;
		"FT_estadoEgr=?vdat[72] where FT_protocolo=?vdat[02]")

	mlidficha = mwktrauma.id

	mret = sqlexec(mcon1,"delete from TabFichaTrauVal2 where FT_idficha=?mlidficha")

	If mret < 0
		msg = msg + ", ACTUALIZACION CODIGOS AIS"
	Else

		Select  mwkactu
		Scan all
			midais = mwkactu.lid
			mret = sqlexec(mcon1,"insert into TabFichaTrauVal2 (FT_idAis, FT_idficha) values (?midais,?mlidficha)")
			If mret < 0
				msg = msg +", ALTA CODIGOS AIS"
				Exit
			Endif
		Endscan

	Endif

Endif

If mret < 0
	=aerror(merror)
	Messagebox("EN "+msg+", MAESTRO DE PACIENTES TRAUMATIZADOS"+;
		chr(10)+alltrim(merror(3))+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
Endif

Release vdat









