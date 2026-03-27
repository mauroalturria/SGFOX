****
** Grabo datos del protocolo quirurgico
****
parameter mopcion, mCodadmision,mtipopac, mquirofano, mhoraLiquidos, mdeambula, mcomentario, mcumpleIA, mdolor, mdolorcabeza, mdolorgarg,;
	mestadoGral, mevacuacion, mfiebre, minflamacion, mliquido, mmasdolor, mmiccion, mnauseas, mpreguntas,;
	mreceptor, msangrado, msolido, msupura, mtos,mentendIA
cantvar = parameters()
if vartype(mhoraLiquidos)#"T"
	mhoraLiquidos = ctot("01/01/1900")
endif
if vartype(mdeambula)#"T"
	mdeambula = ctot("01/01/1900")
endif
mfechaHora	= sp_busco_fecha_serv('DT')
mfecnul = ctod("01/01/1900")
musua = alltrim(mwkusuario.idusuario)

do case
	case  mopcion= 1		&& inserto nuevo registro
		mret = sqlexec(mcon1, "select id from TabquirofanoIQB where TQI_admision =?mCodadmision","mwkcontrol")
		if cantvar>6
			mret = sqlexec(mcon1, "insert into TabquirofanoIQB (TQI_admision, TQI_quirofano,TQI_horaLiquidos,TQI_deambula,"+;
				" TQI_comentario ,TQI_cumpleIA ,TQI_dolor ,TQI_dolorcabeza , TQI_estadoGral, "+;
				"TQI_evacuacion,TQI_fechahora, TQI_fiebre,TQI_inflamacion, TQI_liquido,TQI_masdolor, TQI_miccion,"+;
				"TQI_nauseas, TQI_preguntas,TQI_receptor,TQI_sangrado, TQI_solido,TQI_supura, "+;
				"TQI_usuario, TQI_tipoPac,TQI_entendioIA ) "+;
				"values(?mCodadmision, ?mquirofano, ?mhoraLiquidos, ?mdeambula, ?mcomentario, ?mcumpleIA, ?mdolor, "+;
				"?mdolorcabeza, ?mestadoGral, ?mevacuacion, ?mfechaHora,?mfiebre, ?minflamacion, ?mliquido, "+;
				"?mmasdolor, ?mmiccion, ?mnauseas, ?mpreguntas,?mreceptor, ?msangrado, ?msolido, ?msupura, ?musua, ?mtipopac,?mentendIA )")
		else
			if reccount("mwkcontrol")=0
				mret = sqlexec(mcon1, "insert into TabquirofanoIQB(TQI_admision, TQI_fechahora, TQI_usuario,TQI_tipoPac )"+;
					" values(?mCodadmision, ?mfechaHora, ?musua,0 )")
			endif
		endif
		if mret < 0
			=aerr(eros)
			messagebox(eros(3)+' AVISE error 1', 64,'Validacion')
		endif
	case mopcion= 2		&& actualizo datos
		mret = sqlexec(mcon1, "select id from TabquirofanoIQB where TQI_admision =?mCodadmision","mwkcontrol")
		if mret < 0
			=aerr(eros)
			messagebox(eros(3)+' AVISE error 2', 64,'Validacion')
		endif
		mid = mwkcontrol.id
		if mid > 0
			mret = sqlexec(mcon1, "update TabquirofanoIQB set TQI_tipoPac = ?mtipopac"+;
				", TQI_usuario = ?musua "+;
				" where ID = ?mid"  )
*!*				endif
			if mret < 0
				=aerr(eros)
				messagebox(eros(3)+' AVISE error 3', 64,'Validacion')
			endif
		else
			mret = sqlexec(mcon1, "insert into TabquirofanoIQB (TQI_admision, TQI_quirofano,TQI_horaLiquidos,TQI_deambula,"+;
				" TQI_comentario ,TQI_cumpleIA ,TQI_dolor ,TQI_dolorcabeza , TQI_estadoGral, "+;
				"TQI_evacuacion,TQI_fechahora, TQI_fiebre,TQI_inflamacion, TQI_liquido,TQI_masdolor, TQI_miccion,"+;
				"TQI_nauseas, TQI_preguntas,TQI_receptor,TQI_sangrado, TQI_solido,TQI_supura, "+;
				"TQI_usuario, TQI_tipoPac,TQI_entendioIA ) "+;
				"values(?mCodadmision, ?mquirofano, ?mhoraLiquidos, ?mdeambula, ?mcomentario, ?mcumpleIA, ?mdolor, "+;
				"?mdolorcabeza, ?mestadoGral, ?mevacuacion, ?mfiebre, ?minflamacion, ?mliquido, "+;
				"?mmasdolor, ?mmiccion, ?mnauseas, ?mpreguntas,?mreceptor, ?msangrado, ?msolido, ?msupura, ?mtipopac,?mentendIA ")
			if mret < 0
				=aerr(eros)
				messagebox(eros(3)+' AVISE error 4', 64,'Validacion')
			endif
		endif
	case mopcion= 3		&& da de baja
		mret = sqlexec(mcon1, "select id from TabquirofanoIQB where TQI_admision =?mCodadmision","mwkcontrol")
		mid = mwkcontrol.id
		if mid > 0
			mret = sqlexec(mcon1, "update TabquirofanoIQB set TQI_tipoPac = 99 "+;
				" where TQI_admision =?mCodadmision "  )
			if mret < 0
				=aerr(eros)
				messagebox(eros(3)+' AVISE error 5', 64,'Validacion')
			endif
		endif
	case mopcion= 4		&& actualizo datos de pisos
		mret = sqlexec(mcon1, "select id from TabquirofanoIQB where TQI_admision =?mCodadmision","mwkcontrol")
		if mret < 0
			=aerr(eros)
			messagebox(eros(3)+' AVISE error 2', 64,'Validacion')
		endif
		mid = mwkcontrol.id
		if mid > 0
			mret = sqlexec(mcon1, "update TabquirofanoIQB set TQI_tipoPac = ?mtipopac"+;
				", TQI_usuario = ?musua, TQI_horaLiquidos = ?mhoraLiquidos,TQI_deambula = ?mdeambula"+;
				" where ID = ?mid"  )
*!*				endif
			if mret < 0
				=aerr(eros)
				messagebox(eros(3)+' AVISE error 3', 64,'Validacion')
			endif
		else
			mret = sqlexec(mcon1, "insert into TabquirofanoIQB (TQI_admision, TQI_quirofano,TQI_horaLiquidos,TQI_deambula,"+;
				" TQI_comentario ,TQI_cumpleIA ,TQI_dolor ,TQI_dolorcabeza , TQI_estadoGral, "+;
				"TQI_evacuacion,TQI_fechahora, TQI_fiebre,TQI_inflamacion, TQI_liquido,TQI_masdolor, TQI_miccion,"+;
				"TQI_nauseas, TQI_preguntas,TQI_receptor,TQI_sangrado, TQI_solido,TQI_supura, "+;
				"TQI_usuario, TQI_tipoPac,TQI_entendioIA ) "+;
				"values(?mCodadmision, ?mquirofano, ?mhoraLiquidos, ?mdeambula, ?mcomentario, ?mcumpleIA, ?mdolor, "+;
				"?mdolorcabeza, ?mestadoGral, ?mevacuacion, ?mfiebre, ?minflamacion, ?mliquido, "+;
				"?mmasdolor, ?mmiccion, ?mnauseas, ?mpreguntas,?mreceptor, ?msangrado, ?msolido, ?msupura, ?mtipopac,?mentendIA ")
			if mret < 0
				=aerr(eros)
				messagebox(eros(3)+' AVISE error 4', 64,'Validacion')
			endif
		endif

endcase

