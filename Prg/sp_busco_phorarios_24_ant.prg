***
*** Generacion de planilla de Turnos
***
parameters mfecturno, mbusco1,mltodo
if type('mltodo')#"N"
	mltodo=1
endif

** Dia anterior
mfectur_ant = mfecturno - iif( dow(mfecturno) = 2, 2, 1)
do while .t.
	mret=sqlexec(mcon1,"SELECT dia FROM feriaturnosA WHERE dia =?mfectur_ant",'MWKFeriados')
	if mret < 0
		=aerr(eros)
		do prg_error with eros,'sp_busco_phorarios_24_1'
		cancel
	endif
	if reccount('MWKFeriados')>0
		mfectur_ant = mfectur_ant -1
	else
		exit
	endif
enddo
if used('MWKFeriados')
	use in 	mwkferiados
endif
if dow(mfectur_ant) = 7
	mfectur_antv = mfectur_ant-1
	cbusca = " fechatur >= ?mfectur_ant and fechatur <= ?mfectur_antv  "
else
	cbusca = " fechatur = ?mfectur_ant "
endif
do sp_busco_medprestam with mfecturno

mret=sqlexec(mcon1,"SELECT * FROM TabHCUbica ",'MWKubica')
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_busco_phorarios_24_2'
	cancel
endif


mret = sqlexec(mcon1, 'select afiliado  ' + ;
	'from turnos ' + ;
	'where  ' + ;
	" CODprest not in (78010600,78010601,67010201,22020300) and (not (CODprest like '28010%') or CODprest = 28010602 ) and " + ;
	" not (CODprest like '20012%') and " + ;
	'&cbusca and ' + ;
	"codesp not in('KINE', 'NFII', 'NEUF', 'HOLT', 'ECGR', 'ECIN', 'ECOC', 'ECOO', 'ECOG', 'ECOI', 'ERGO', 'LABO', 'RADI', 'RESO', 'TOMO') " + ;
	'', 'mwkphoraant1')

select * from mwkphoraant1 group by afiliado  into cursor mwkphoraant

if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_busco_phorarios_24_3'
	cancel
else
	mret = sqlexec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, " + ;
		"turnos.codmed, turnos.diasem, turnos.codprest, AFI_nroafiliado, REG_telefonos, " + ;
		"turnos.codreserva, registracio.REG_nrohclinica, registracio.REG_numdocumento, " + ;
		"registracio.REG_nombrepac, turnos.codent,hhmmtur ,hca_motfalta,hca_fechaInic, " + ;
		"turnos.fechatomado, turnos.usuario, turnos.afiliado, REG_fecnacimiento as fechanac " + ;
		"from turnos , afiliacion, registracio" + ;
		" left outer join TabHCArchivo on registracio.REG_nroregistrac = TabHCArchivo.hca_registrac " + ;
		"where " + ;
		"turnos.afiliado = registracio.REG_nroregistrac and " + ;
		"registracio.REG_nroregistrac = afiliacion.registracio and " + ;
		"turnos.codent = afiliacion.AFI_codentidad and " + ;
		" &mbusco1 "  + ;
		"turnos.fechatur = ?mfecturno  " + ;
		"order by turnos.fechatur,AFI_nroafiliado, turnos.codreserva ,turnos.hhmmtur desc ", "mwkphorario1")
	if mret < 0
		=aerr(eros)
		do prg_error with eros,'sp_busco_phorarios_24_4'
		cancel
	endif
	select * from  mwkphorario1 group by fechatur, AFI_nroafiliado, codreserva into cursor mwkphorario1
	mret = sqlexec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, " + ;
		"preregistra.telefono as REG_telefonos, turnos.diasem, turnos.codprest, preregistra.afiliado as AFI_nroafiliado, " + ;
		"turnos.codreserva, ('0000000000') as REG_nrohclinica, nrodocumento as REG_numdocumento, " + ;
		"(preregistra.nombre) as REG_nombrepac, turnos.codent,hhmmtur , " + ;
		"turnos.fechatomado, turnos.usuario, turnos.codmed, turnos.afiliado, fechanac " + ;
		"from turnos , preregistra " + ;
		"where " + ;
		"turnos.afiliado = preregistra.id and " + ;
		" &mbusco1 " + ;
		"turnos.fechatur = ?mfecturno " + ;
		"order by turnos.fechatur,AFI_nroafiliado, turnos.codreserva ,turnos.hhmmtur desc ", "mwkphorario2")
*	" codesp in('LABO', 'PSIC', 'FONI') and "

	if mret < 0
		=aerr(eros)
		do prg_error with eros,'sp_busco_phorarios_24_5'
		cancel
	endif
	select * from  mwkphorario2 group by fechatur, AFI_nroafiliado, codreserva into cursor mwkphorario2

	select left(ttoc(horatur,2), 5) as hora, left(reg_nombrepac, 40) as reg_nombrepac, ;
		ent_descrient, pre_descriprest, codreserva, left(reg_nrohclinica, 10) as reg_nrohclinica, ;
		reg_telefonos, mwkphorario1.usuario, fechatomado, fechatur, nombre, afi_nroafiliado, reg_numdocumento, ;
		horatur, mwkphorario1.id, left(right(alltrim(reg_nrohclinica), 4), 2) as termina, esp_descripcion, ;
		ttoc(hdesde1,2) as hdesde1, hhasta1, mwkphorario1.codesp, mwkphorario1.codmed, mwkphorario1.diasem, sala, ;
		'*' + str(mwkphorario1.diasem,1) + strtran(str(mwkphorario1.codmed,4), ' ', '0') + ;
		strtran(substr(dtoc(fechatur),1, 5),'/','') +  left(ttoc(hdesde1,2), 2) + '*' as codbarra, afiliado, ;
		int((mfecturno-nvl(fechanac,mfecturno))/365) as edad, left(sala,1) as piso, mwkphorario1.codprest,;
		nvl(hca_motfalta,0) as hca_motfalta,nvl(hca_fechaInic,ctot("01/01/1900")) as hca_fechaInic;
		from mwkphorario1 ;
		left join mwkpent on codent = ent_codent ;
		left join mwkpesp on codesp = esp_codesp ;
		left join mwkppres on codprest = pre_codprest ;
		left join mwkmpfecha on (mwkphorario1.codmed = mwkmpfecha.codmed and ;
		mwkphorario1.codprest = mwkmpfecha.codprest and ;
		mwkphorario1.fechatur >= mwkmpfecha.fecvigend and ;
		mwkphorario1.fechatur < mwkmpfecha.fecvigenh and ;
		mwkphorario1.hhmmtur >= mwkmpfecha.hhmmdes and ;
		mwkphorario1.hhmmtur<mwkmpfecha.hhmmhas and ;
		mwkphorario1.diasem = mwkmpfecha.diasem );
		where generaagen = 1 ;
		order by fechatur, horatur, afi_nroafiliado	;
		into cursor mwkphorario3

	select left(ttoc(horatur,2), 5) as hora, left(reg_nombrepac, 40) as reg_nombrepac, ;
		ent_descrient, pre_descriprest, codreserva, left(reg_nrohclinica, 10) as reg_nrohclinica, ;
		reg_telefonos, mwkphorario2.usuario, fechatomado, fechatur, nombre, afi_nroafiliado, reg_numdocumento, ;
		horatur, mwkphorario2.id, left(right(alltrim(reg_nrohclinica), 4), 2) as termina, esp_descripcion, ;
		ttoc(hdesde1,2) as hdesde1, hhasta1, mwkphorario2.codesp, mwkphorario2.codmed, mwkphorario2.diasem, sala, ;
		'*' + str(mwkphorario2.diasem,1) + strtran(str(mwkphorario2.codmed,4), ' ', '0') + ;
		strtran(substr(dtoc(fechatur),1, 5),'/','') +  left(ttoc(hdesde1,2), 2) + '*' as codbarra, afiliado , ;
		int((mfecturno-nvl(fechanac,mfecturno))/365) as edad, left(sala,1) as piso, mwkphorario2.codprest  ;
		,0 as hca_motfalta,ctot("01/01/1900") as hca_fechaInic;
		from mwkphorario2 ;
		left join mwkpent on codent = ent_codent ;
		left join mwkpesp on codesp = esp_codesp ;
		left join mwkppres on codprest = pre_codprest ;
		left join mwkmpfecha on (mwkphorario2.codmed = mwkmpfecha.codmed and ;
		mwkphorario2.codprest = mwkmpfecha.codprest and ;
		mwkphorario2.fechatur >= mwkmpfecha.fecvigend and ;
		mwkphorario2.fechatur < mwkmpfecha.fecvigenh and ;
		mwkphorario2.hhmmtur >= mwkmpfecha.hhmmdes and ;
		mwkphorario2.hhmmtur<mwkmpfecha.hhmmhas and ;
		mwkphorario2.diasem = mwkmpfecha.diasem );
		where generaagen = 1 ;
		order by fechatur, horatur;
		into cursor mwkphorario4

	select * from mwkphorario3 ;
		union ;
		select * from mwkphorario4;
		into cursor mwkphorarioss

*** busca primer medico para archivo
	select distinc afiliado,codmed;
		from mwkphorario3;
		where  codesp not in ('KINE', 'NFII', 'NEUF', 'HOLT', 'ECGR', 'ECIN', 'ECOC', 'ECOO', 'ECOG', 'ECOI', 'ERGO', 'LABO', 'RADI', 'RESO', 'TOMO') ;
		and  (at('28010', alltrim(str(CODprest))) # 1 or CODprest = 28010602);
		and at('20012', alltrim(str(CODprest)) )# 1 and  !inlist (CODprest,78010600,78010601,67010201,22020300);
		into cursor mwkturnospac

	select afiliado,count(afiliado) as canttur;
		from mwkturnospac;
		group by afiliado order by afiliado;
		into cursor mwkcantur

	select afiliado,horatur,codmed,nombre as otromedI  from mwkphorario3 ;
		where codesp not in ('KINE', 'NFII', 'NEUF', 'HOLT', 'ECGR', 'ECIN', 'ECOC', 'ECOO', 'ECOG', 'ECOI', 'ERGO', 'LABO', 'RADI', 'RESO', 'TOMO') ;
		and  (at('28010', alltrim(str(CODprest))) # 1 or CODprest = 28010602);
		and at('20012', alltrim(str(CODprest)) )# 1 and !inlist (CODprest,78010600,78010601,67010201,22020300) ;
		and mwkphorario3.afiliado in ;
		( select afiliado from mwkcantur ;
		where canttur >1 and mwkcantur.afiliado = mwkphorario3.afiliado ) ;
		order by afiliado,horatur desc into cursor mwktrasla

	if used('mwkturnospac')
		use in mwkturnospac
	endif


	if used('mwkcantur')
		use in mwkcantur
	endif

	select * from mwktrasla group by afiliado into cursor mwkprimed

	if used('mwktrasla')
		use in mwktrasla
	endif


****
** Agregado para Archivo
****
	create cursor consumo ( nrohclinica c(10),afi n(10) )

	select afiliado,reg_nrohclinica,hca_fechaInic from mwkphorario1 ;
		order by afiliado group by afiliado into cursor mwkphorarioar

	nsegu = seconds()
	select mwkphorarioar
	totalr = reccount('mwkphorarioar')
	van = 0
	scan
		mregistracio = mwkphorarioar.afiliado
		mnrohclinica = mwkphorarioar.reg_nrohclinica
		van=van+1
		wait windows (str(van) + " de  "+ str(totalr)) nowait
		lsigue =( hca_fechaInic = ctot("01/01/1900"))
		if lsigue

			mret = sqlexec(mcon1, "select afiliado,codesp , CODprest " + ;
				"from turnos  " + ;
				"where fechatur < ?mfecturno and " + ;
				"afiliado = ?mregistracio " , "mwkconsumos")

			select * from mwkconsumos;
				where  codesp not in ('KINE', 'NFII', 'NEUF', 'HOLT', 'ECGR', 'ECIN', 'ECOC', 'ECOO', 'ECOG', 'ECOI', 'ERGO', 'LABO', 'RADI', 'RESO', 'TOMO') ;
				and  (at('28010', alltrim(str(CODprest))) # 1 or CODprest = 28010602);
				and at('20012', alltrim(str(CODprest)) )# 1 and !inlist(CODprest,78010600,78010601,67010201,22020300);
				into cursor mwkconsumos1

			if mret < 0
				=aerr(eros)
				do prg_error with eros,'sp_busco_phorarios_24_6'
				cancel
			endif
			lsigue =( reccount ("mwkconsumos1") = 0)
		endif
		if lsigue
			mret = sqlexec(mcon1, "select afiliado,codesp , CODprest " + ;
				"from turnoshis  " + ;
				"where fechatur < ?mfecturno and " + ;
				"afiliado = ?mregistracio " , "mwkconsumos")
			if mret < 0
				=aerr(eros)
				do prg_error with eros,'sp_busco_phorarios_24_7'
				cancel
			endif
			select * from mwkconsumos;
				where  codesp not in ('KINE', 'NFII', 'NEUF', 'HOLT', 'ECGR', 'ECIN', 'ECOC', 'ECOO', 'ECOG', 'ECOI', 'ERGO', 'LABO', 'RADI', 'RESO', 'TOMO') ;
				and  (at('28010', alltrim(str(CODprest))) # 1 or CODprest = 28010602);
				and at('20012', alltrim(str(CODprest)) )# 1 and !inlist(CODprest,78010600,78010601,67010201,22020300);
				into cursor mwkconsumos2
			lsigue =( reccount ("mwkconsumos2") = 0)
		endif
		if lsigue
			mret = sqlexec(mcon1, "select HIS_nroregistrac " + ;
				"from  servicios, histambgua, " + ;
				"valesasist " + ;
				"where HIS_codadmision = VAL_codadmision and " + ;
				"VAL_codsector = 'AMB' and " + ;
				"VAL_codservvale = ser_codserv and " + ;
				"ser_ambulatorio = 'S' and " + ;
				"his_nroregistrac = ?mregistracio " , "mwkconsumos4")
			if mret < 0
				=aerr(eros)
				do prg_error with eros,'sp_busco_phorarios_24_9'
				cancel
			endif
			lsigue =( reccount ("mwkconsumos4") = 0)
		endif
		if !lsigue
			insert into consumo (nrohclinica) values (mnrohclinica )
		endif

	endscan
*	messagebox ("tardo" + transf(seconds()- nsegu ))


	select mwkphorarioss.*,mwkphoraant.afiliado as afi,consumo.nrohclinica,otromedI,abrevio;
		from mwkphorarioss ;
		left outer join consumo on nrohclinica = reg_nrohclinica;
		left join MWKubica on codubi = hca_motfalta ;
		left outer join mwkphoraant on mwkphoraant.afiliado = mwkphorarioss.afiliado;
		left outer join mwkprimed on (mwkprimed.afiliado = mwkphorarioss.afiliado;
		and mwkprimed.codmed # mwkphorarioss.codmed );
		into cursor mwkphorarios


	if used('mwkphorarioss')
		use in  mwkphorarioss
	endif
	if used('mwkphorario3')
		use in  mwkphorario3
	endif
	if used('mwkphorario4')
		use in  mwkphorario4
	endif
	if mltodo=1

****
** Agregado para Psicopatologia
****

*	mfec_desde = ctod('31/05/2003')
		mfec_anio  = year(sp_busco_fecha_serv('DD'))
		mfec_hasta = mfecturno

		mret = sqlexec(mcon1, "select afiliado,sum( case when datepart(yyyy, fechatur) = ?mfec_anio and fechatur <= ?mfec_hasta then 1 else 0 end ) as turhis, " + ;
			"sum( case when datepart(yyyy, fechatur) < ?mfec_anio then 1 else 0 end ) as turhisant   " + ;
			"from turnos " + ;
			"where turnos.codesp = 'PSIC' " + ;
			"group by afiliado " + ;
			"", "mwkphoragre1")
		if mret < 0
			=aerr(eros)
			do prg_error with eros,'sp_busco_phorarios_24_10'
			cancel
		endif

		mret = sqlexec(mcon1, "select afiliado,sum( case when datepart(yyyy, fechatur) = ?mfec_anio then 1 else 0 end ) as turhis, sum( case when datepart(yyyy, fechatur) < ?mfec_anio then 1 else 0 end ) as turhisant   " + ;
			"from turnoshis " + ;
			"where codesp = 'PSIC' " + ;
			"group by afiliado " + ;
			"", "mwkphoragre2")

		if mret < 0
			=aerr(eros)
			do prg_error with eros,'sp_busco_phorarios_24_11'
			cancel
		endif

		select * from mwkphoragre1 ;
			union all ;
			select * from mwkphoragre2 ;
			into cursor mwktodos1

		select afiliado, sum(turhis) as turhis,sum(turhisant) as turhisant  ;
			from mwktodos1 ;
			group by afiliado order by afiliado ;
			into cursor mwktodos


****
** Agregado para Foniatria
****
		if used('mwktodos1')
			use in  mwktodos1
		endif
		if used('mwkphoragre1')
			use in  mwkphoragre1
		endif
		if used('mwkphoragre2')
			use in  mwkphoragre2
		endif

*	mfec_desde = ctod('01/11/2003')
		mfec_anio  = year(sp_busco_fecha_serv('DD'))
		mfec_hasta = mfecturno

		mret = sqlexec(mcon1, "select afiliado,fechatur " + ;
			"from turnos " + ;
			"where codesp = 'FONI' and " + ;
			"datepart(yy, fechatur) = ?mfec_anio ", "mwkphoragr1")
		if mret < 0
			=aerr(eros)
			do prg_error with eros,'sp_busco_phorarios_24_12'
			cancel
		endif

		select afiliado, count(afiliado) as turhis ;
			from mwkphoragr1 ;
			where  fechatur <= mfec_hasta group by afiliado ;
			into cursor mwkphoragre1


		mret = sqlexec(mcon1, "select turnos.afiliado, count(afiliado) as turhis " + ;
			"from turnoshis as turnos " + ;
			"where turnos.codesp = 'FONI' and " + ;
			"datepart(yy, turnos.fechatur) = ?mfec_anio " + ;
			"group by afiliado " + ;
			"", "mwkphoragre2")

		if mret < 0
			=aerr(eros)
			do prg_error with eros,'sp_busco_phorarios_24_13'
			cancel
		endif
		select * from mwkphoragre1 ;
			union all ;
			select * from mwkphoragre2 ;
			into cursor mwktodos1

		select afiliado, sum(turhis) as turhis ;
			from mwktodos1 ;
			group by afiliado order by afiliado ;
			into cursor mwktodosf

		if used('mwktodos1')
			use in  mwktodos1
		endif
		if used('mwkphoragre1')
			use in  mwkphoragre1
		endif
		if used('mwkphoragre2')
			use in  mwkphoragre2
		endif

	endif
****
** Agregado para Medicos sin turnos dados
****
	mbusco1na = ''  && strtran(mbusco1,'turnos.codesp','prestadores.codesp')
	mret = sqlexec(mcon1,"SELECT fecvigend , fecvigenh , horahasta , horadesde , turnos.codmed "+;
		", fecpasiva , nombre , hhmmdes , hhmmhas,prestadores.nombre,fechatur,"+;
		" turnos.diasem,esp_descripcion,hhmmtur  "+;
		" FROM turnos , prestadores , franjahoraria,especialid"+;
		" WHERE prestadores.id = turnos.codmed AND fecvigend <> fecvigenh " + ;
		" AND fecvigend <= ?mfecturno AND fecvigenh >= ?mfecturno " + ;
		" AND afiliado = 0 AND hhmmtur >= hhmmdes AND hhmmtur <= hhmmhas and "+;
		" turnos.diasem = franjahoraria.diasem and "+;
		mbusco1na + " esp_codesp  = prestadores.codesp AND fechatur = ?mfecturno and "+;
		" franjahoraria.codmed = turnos.codmed and turnos.tipoturno < 8","mwkTurNoAsig")

	select  mwkTurNoAsig.fecvigend , mwkTurNoAsig.fecvigenh , mwkTurNoAsig.horahasta ,;
		mwkTurNoAsig.horadesde as hdesde1 , mwkTurNoAsig.codmed , mwkTurNoAsig.fecpasiva , ;
		mwkTurNoAsig.nombre , mwkTurNoAsig.hhmmdes , '*' + str(mwkTurNoAsig.diasem,1) + ;
		strtran(str(mwkTurNoAsig.codmed,4), ' ', '0') + ;
		strtran(substr(dtoc(mwkTurNoAsig.fechatur),1, 5),'/','') + ;
		left(ttoc(mwkTurNoAsig.horadesde,2), 2) + '*' as codbarra ;
		,mwkTurNoAsig.hhmmhas,mwkTurNoAsig.fechatur,mwkmpfecha.codesp,mwkTurNoAsig.diasem,;
		mwkTurNoAsig.esp_descripcion ;
		from mwkTurNoAsig ;
		left join mwkmpfecha on (mwkTurNoAsig.codmed = mwkmpfecha.codmed and ;
		mwkTurNoAsig.fechatur >= mwkmpfecha.fecvigend and ;
		mwkTurNoAsig.fechatur < mwkmpfecha.fecvigenh and ;
		mwkTurNoAsig.hhmmtur >= mwkmpfecha.hhmmdes and ;
		mwkTurNoAsig.hhmmtur<mwkmpfecha.hhmmhas and ;
		mwkTurNoAsig.diasem = mwkmpfecha.diasem );
		where generaagen = 1 ;
		group by mwkTurNoAsig.codmed ,mwkTurNoAsig.hhmmdes  ;
		into cursor mwkTurNoAsig2
endif
