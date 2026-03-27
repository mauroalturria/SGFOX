*!*
*!*	 Generacion de planilla de Turnos
*!*
*!*	 Nuevo parámetro : mbusfecha Tipo Lógico
*!*                    valor por defecto nullo, si esta definido viene con .T. para buscar por FECHATUR
*!*                    caso contrario busca por HORATUR
*!*

Parameters mfecturno, mbusco1, mltodo, mbusfecha

If vartype( mbusfecha ) # "L"
	mbusfecha = .f.
Endif

If type('mltodo')#"N"
	mltodo = 1
Endif

If type('mltodo')#"N"
	mltodo = 1
Endif

** Dia anterior
	if !used('mwkdatos')
		do sp_busco_datos
	endif
	mfechafiltro = ctod(trans(mwkdatos.valorfloat2,"99/99/9999"))
	mfiltraesp = ''

mfectur_ant = mfecturno - iif( dow(mfecturno) = 2, 2, 1)

Do while .t.
	mret=sqlexec(mcon1,"SELECT dia FROM feriaturnosA WHERE dia =?mfectur_ant",'MWKFeriados')
	If mret < 0
		=aerr(eros)
		Do prg_error with eros,'sp_busco_phorarios_24_1'
		Cancel
	Endif
	If reccount('MWKFeriados')>0
		mfectur_ant = mfectur_ant - 1
	Else
		Exit
	Endif
Enddo
If used('MWKFeriados')
	Use in 	mwkferiados
Endif

If dow(mfectur_ant) = 7
	mfectur_antv = mfectur_ant - 1
	cbusca = " fechatur >= ?mfectur_antv and fechatur <= ?mfectur_ant "
Else
	cbusca = " fechatur = ?mfectur_ant "
Endif

Do sp_busco_medprestam with mfecturno
Do sp_muestra_ubicacion
select * from MwkUbica into cursor mwkconsultorio
mcbusca2 = " turnos.fechatur = ?mfecturno  "
If !mbusfecha
	mfec1    = left(prg_dtoc(mfecturno),10) + " 07:00:00"
	mfec2    = left(prg_dtoc(mfecturno + 1),10) + " 07:00:00"
	mcbusca2 = " horatur >= ?mfec1 and horatur < ?mfec2 "

	If used('mwkmpfecha')
		If reccount('mwkmpfecha')>0
			If used('mwkmpfechaB')
				Use in mwkmpfechaB
			Endif
			Select * from mwkmpfecha into cursor mwkmpfechaB
		Endif
	Endif

	Do sp_busco_medprestam with ( mfecturno + 1 )

	If used('mwkMPfecha')
		If reccount('mwkMPfecha')>0
			If used('mwkmpfechaC')
				Use in mwkmpfechaC
			Endif
			Select * from mwkmpfecha into cursor mwkmpfechaC
			Select * from mwkmpfechaB union select * from mwkmpfechaC into cursor mwkmpfecha
		Endif
	Endif

Endif

mret=sqlexec(mcon1,"SELECT * FROM TabHCUbica ",'MWKubica')
If mret < 0
	=aerr(eros)
	Do prg_error with eros,'sp_busco_phorarios_24_2'
	Cancel
Endif


mret = sqlexec(mcon1, 'select afiliado  ' + ;
	'from turnos ' + ;
	'where  ' + ;
	" CODprest not in (42010181,78010600,78010601,67010201,22020300) and (not (CODprest like '28010%') or CODprest = 28010602 ) and " + ;
	" not (CODprest like '20012%') and " + ;
	'&cbusca and codserv<>1130 and ' + ;
	"codesp not in('KINE', 'NFII', 'NEUF', 'HOLT', 'ECGR', 'ECIN', 'ECOC', 'ECOO', 'ECOG', 'ECOI', 'ERGO', 'LABO', 'RADI',"+;
	" 'RESO', 'TOMO') " + ;
	'', 'mwkphoraant1')

Select * from mwkphoraant1 group by afiliado  into cursor mwkphoraant

If mret < 0

	=aerr(eros)
	Do prg_error with eros,'sp_busco_phorarios_24_3'
	Cancel

Else

	mret = sqlexec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, " + ;
		"turnos.codmed, turnos.diasem, turnos.codprest, AFI_nroafiliado, REG_telefonos, " + ;
		"turnos.codreserva, registracio.REG_nrohclinica, registracio.REG_numdocumento, " + ;
		"registracio.REG_nombrepac, turnos.codent,hhmmtur ,hca_motfalta,hca_fechaInic, " + ;
		"turnos.fechatomado, turnos.codserv, turnos.usuario, turnos.afiliado, REG_fecnacimiento as fechanac " + ;
		"from turnos , afiliacion, registracio" + ;
		" left outer join TabHCArchivo on registracio.REG_nroregistrac = TabHCArchivo.hca_registrac " + ;
		"where " + ;
		"turnos.afiliado = registracio.REG_nroregistrac and " + ;
		"registracio.REG_nroregistrac = afiliacion.registracio and " + ;
		"turnos.codent = afiliacion.AFI_codentidad and " + ;
		mbusco1  + mcbusca2 +;
		" order by turnos.fechatur,AFI_nroafiliado, turnos.codreserva ,turnos.hhmmtur desc ", "mwkphorario1")

	If mret < 0
		=aerr(eros)
		Do prg_error with eros,'sp_busco_phorarios_24_4'
		Cancel
	Endif

	Select * from  mwkphorario1 group by fechatur, codmed,AFI_nroafiliado, codreserva into cursor mwkphorario1
	mret = sqlexec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, " + ;
		"preregistra.telefono as REG_telefonos, turnos.diasem, turnos.codprest, preregistra.afiliado as AFI_nroafiliado, " + ;
		"turnos.codreserva, ('0000000000') as REG_nrohclinica, nrodocumento as REG_numdocumento, " + ;
		"(preregistra.nombre) as REG_nombrepac, turnos.codent,hhmmtur , " + ;
		"turnos.fechatomado, turnos.codserv, turnos.usuario, turnos.codmed, turnos.afiliado, fechanac " + ;
		"from turnos , preregistra " + ;
		"where " + ;
		"turnos.afiliado = preregistra.id and " + ;
		mbusco1 + mcbusca2 + ;
		" order by turnos.fechatur,AFI_nroafiliado, turnos.codreserva ,turnos.hhmmtur desc ", "mwkphorario2")

*	" codesp in('LABO', 'PSIC', 'FONI') and "

	If mret < 0
		=aerr(eros)
		Do prg_error with eros,'sp_busco_phorarios_24_5'
		Cancel
	Endif

	Select * from  mwkphorario2 group by fechatur, codmed,AFI_nroafiliado, codreserva into cursor mwkphorario2

	Select left(ttoc(horatur,2), 5) as hora, left(reg_nombrepac, 40) as reg_nombrepac, ;
		ent_descrient, pre_descriprest, codreserva, left(reg_nrohclinica, 10) as reg_nrohclinica, ;
		reg_telefonos, mwkphorario1.usuario, fechatomado, mwkphorario1.codserv, fechatur, nombre, AFI_nroafiliado, reg_numdocumento, ;
		horatur, mwkphorario1.id, left(right(alltrim(reg_nrohclinica), 4), 2) as termina, esp_descripcion, ;
		ttoc(hdesde1,2) as hdesde1, hhasta1, mwkphorario1.codesp, mwkphorario1.codmed, mwkphorario1.diasem, sala, ;
		'*' + str(mwkphorario1.diasem,1) + strtran(str(mwkphorario1.codmed,4), ' ', '0') + ;
		strtran(substr(dtoc(fechatur),1, 5),'/','') +  left(ttoc(hdesde1,2), 2) +substr(ttoc(hdesde1,2), 4,2) +  '*' as codbarra, afiliado, ;
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
		mwkphorario1.hhmmtur < mwkmpfecha.hhmmhas and ;
		mwkphorario1.diasem = mwkmpfecha.diasem );
		where generaagen = 1 ;
		order by fechatur, horatur, AFI_nroafiliado	;
		into cursor mwkphorario3

	Select left(ttoc(horatur,2), 5) as hora, left(reg_nombrepac, 40) as reg_nombrepac, ;
		ent_descrient, pre_descriprest, codreserva, left(reg_nrohclinica, 10) as reg_nrohclinica, ;
		reg_telefonos, mwkphorario2.usuario, fechatomado, mwkphorario2.codserv, fechatur, nombre, AFI_nroafiliado, reg_numdocumento, ;
		horatur, mwkphorario2.id, left(right(alltrim(reg_nrohclinica), 4), 2) as termina, esp_descripcion, ;
		ttoc(hdesde1,2) as hdesde1, hhasta1, mwkphorario2.codesp, mwkphorario2.codmed, mwkphorario2.diasem, sala, ;
		'*' + str(mwkphorario2.diasem,1) + strtran(str(mwkphorario2.codmed,4), ' ', '0') + ;
		strtran(substr(dtoc(fechatur),1, 5),'/','') +  left(ttoc(hdesde1,2), 2) +substr(ttoc(hdesde1,2), 4,2) +  '*' as codbarra, afiliado , ;
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
		mwkphorario2.hhmmtur < mwkmpfecha.hhmmhas and ;
		mwkphorario2.diasem = mwkmpfecha.diasem );
		where generaagen = 1 ;
		order by fechatur, horatur;
		into cursor mwkphorario4

	Select * from mwkphorario3 ;
		union ;
		select * from mwkphorario4;
		into cursor mwkphorarioss

*** Busca primer medico para archivo

	Select distinc afiliado,codmed;
		from mwkphorario3;
		where  !inlist(codesp ,'KINE', 'NFII', 'NEUF', 'HOLT', 'ECGR', 'ECIN', 'ECOC', 'ECOO', 'ECOG',;
		'ECOI', 'ERGO', 'LABO', 'RADI', 'RESO', 'TOMO') and codserv # 1130  ;
		and  (at('28010', alltrim(str(codprest))) # 1 or codprest = 28010602);
		and at('20012', alltrim(str(codprest)) )# 1 and  !inlist (codprest,42010181,78010600,78010601,67010201,22020300);
		into cursor mwkturnospac

	Select afiliado,count(afiliado) as canttur;
		from mwkturnospac;
		group by afiliado order by afiliado;
		into cursor mwkcantur

	Select afiliado,horatur,codmed,nombre as otromedI  from mwkphorario3 ;
		where !inlist(codesp,'KINE', 'NFII', 'NEUF', 'HOLT', 'ECGR', 'ECIN', 'ECOC', 'ECOO', 'ECOG',;
		'ECOI', 'ERGO', 'LABO', 'RADI', 'RESO', 'TOMO') and codserv # 1130  ;
		and  (at('28010', alltrim(str(codprest))) # 1 or codprest = 28010602);
		and at('20012', alltrim(str(codprest)) )# 1 and !inlist (codprest,42010181,78010600,78010601,67010201,22020300) ;
		and mwkphorario3.afiliado in ;
		( select afiliado from mwkcantur ;
		where canttur >1 and mwkcantur.afiliado = mwkphorario3.afiliado ) ;
		order by afiliado,horatur desc into cursor mwktrasla

	If used('mwkturnospac')
		Use in mwkturnospac
	Endif

	If used('mwkcantur')
		Use in mwkcantur
	Endif

	Select * from mwktrasla group by afiliado into cursor mwkprimed

	If used('mwktrasla')
		Use in mwktrasla
	Endif

*
*
*
****
** Agregado para Archivo
****
*
*
*

	Create cursor consumo ( nrohclinica c(10),afi n(10) )

	Select afiliado,reg_nrohclinica,hca_fechaInic from mwkphorario1 ;
		order by afiliado group by afiliado into cursor mwkphorarioar

	Select mwkphorarioss.*,mwkphoraant.afiliado as afi,consumo.nrohclinica,otromedI,;
		abrevio,mwkconsultorio.interno;
		from mwkphorarioss ;
		left outer join consumo on nrohclinica = reg_nrohclinica;
		left join MWKubica on codubi = hca_motfalta ;
		left outer join mwkphoraant on mwkphoraant.afiliado = mwkphorarioss.afiliado;
		left outer join mwkconsultorio on mwkconsultorio.lugar = mwkphorarioss.sala;
		left outer join mwkprimed on (mwkprimed.afiliado = mwkphorarioss.afiliado;
		and mwkprimed.codmed # mwkphorarioss.codmed );
		into cursor mwkphorarios

	If used('mwkphorarioss')
		Use in  mwkphorarioss
	Endif
	If used('mwkphorario3')
		Use in  mwkphorario3
	Endif
	If used('mwkphorario4')
		Use in  mwkphorario4
	Endif
	If mltodo=1

****
** Agregado para Psicopatologia
****

*	    mfec_desde = ctod('31/05/2003')

		mfec_anio  = year(sp_busco_fecha_serv('DD'))
		mfec_hasta = mfecturno
		mfec_desde = ctod("01/01/" + alltrim(transfor(mfec_anio)))
		mret = sqlexec(mcon1, "select afiliado,sum( case when fechatur >= ?mfec_desde "+;
			" and fechatur <= ?mfec_hasta then 1 else 0 end ) as turhis, " + ;
			"sum( case when fechatur < ?mfec_desde then 1 else 0 end ) as turhisant   " + ;
			"from turnos " + ;
			"where turnos.codesp = 'PSIC' " + ;
			"group by afiliado " + ;
			"", "mwkphoragre1")

		If mret < 0
			=aerr(eros)
			Do prg_error with eros,'sp_busco_phorarios_24_10'
			Cancel
		Endif

		mret = sqlexec(mcon1, "select afiliado,"+;
			"sum( case when fechatur >= ?mfec_desde then 1 else 0 end ) as turhis, "+;
			"sum( case when fechatur < ?mfec_desde then 1 else 0 end ) as turhisant "+;
			"from turnoshis " + ;
			"where codesp = 'PSIC' " + ;
			"group by afiliado " + ;
			"", "mwkphoragre2")

		If mret < 0
			=aerr(eros)
			Do prg_error with eros,'sp_busco_phorarios_24_11'
			Cancel
		Endif

		Select * from mwkphoragre1 ;
			union all ;
			select * from mwkphoragre2 ;
			into cursor mwktodos1

		Select afiliado, sum(turhis) as turhis,sum(turhisant) as turhisant  ;
			from mwktodos1 ;
			group by afiliado order by afiliado ;
			into cursor mwktodos


****
** Agregado para Foniatria
****

		If used('mwktodos1')
			Use in  mwktodos1
		Endif
		If used('mwkphoragre1')
			Use in  mwkphoragre1
		Endif
		If used('mwkphoragre2')
			Use in  mwkphoragre2
		Endif

		mret = sqlexec(mcon1, "select afiliado,fechatur " + ;
			"from turnos " + ;
			"where codesp = 'FONI' and " + ;
			" fechatur >= ?mfec_desde ", "mwkphoragr1")

		If mret < 0
			=aerr(eros)
			Do prg_error with eros,'sp_busco_phorarios_24_12'
			Cancel
		Endif

		Select afiliado, count(afiliado) as turhis ;
			from mwkphoragr1 ;
			where  fechatur <= mfec_hasta group by afiliado ;
			into cursor mwkphoragre1

		mret = sqlexec(mcon1, "select turnos.afiliado, count(afiliado) as turhis " + ;
			"from turnoshis as turnos " + ;
			"where turnos.codesp = 'FONI' and " + ;
			" fechatur >= ?mfec_desde " + ;
			"group by afiliado " + ;
			"", "mwkphoragre2")

		If mret < 0
			=aerr(eros)
			Do prg_error with eros,'sp_busco_phorarios_24_13'
			Cancel
		Endif

		Select * from mwkphoragre1 ;
			union all ;
			select * from mwkphoragre2 ;
			into cursor mwktodos1

		Select afiliado, sum(turhis) as turhis ;
			from mwktodos1 ;
			group by afiliado order by afiliado ;
			into cursor mwktodosf

		If used('mwktodos1')
			Use in  mwktodos1
		Endif
		If used('mwkphoragre1')
			Use in  mwkphoragre1
		Endif
		If used('mwkphoragre2')
			Use in  mwkphoragre2
		Endif

	Endif

****
** Agregado para Medicos sin turnos dados
****
	do sp_listo_tabla with '','TabTipoFranja','mwktposerv'

	mbusco1na = ''  && strtran(mbusco1,'turnos.codesp','prestadores.codesp')
	mret = sqlexec(mcon1,"SELECT fecvigend , fecvigenh , horahasta , horadesde , turnos.codmed "+;
		", fecpasiva , nombre , hhmmdes , hhmmhas,prestadores.nombre,fechatur,"+;
		" turnos.diasem,esp_descripcion,hhmmtur,franjahoraria.tiposervicio  "+;
		" FROM turnos , prestadores , franjahoraria,especialid"+;
		" WHERE prestadores.id = turnos.codmed AND fecvigend <> fecvigenh " + ;
		" AND fecvigend <= ?mfecturno AND fecvigenh >= ?mfecturno " + ;
		" AND afiliado = 0 AND hhmmtur >= hhmmdes AND hhmmtur <= hhmmhas and "+;
		" turnos.diasem = franjahoraria.diasem and "+;
		mbusco1na + " esp_codesp  = prestadores.codesp AND fechatur = ?mfecturno and "+;
		" franjahoraria.codmed = turnos.codmed and turnos.tipoturno < 8","mwkTurNoAsig")

	Select  mwkTurNoAsig.fecvigend , mwkTurNoAsig.fecvigenh , mwkTurNoAsig.horahasta ,;
		mwkTurNoAsig.horadesde as hdesde1 , mwkTurNoAsig.codmed , mwkTurNoAsig.fecpasiva , ;
		mwkTurNoAsig.nombre , mwkTurNoAsig.hhmmdes , '*' + str(mwkTurNoAsig.diasem,1) + ;
		strtran(str(mwkTurNoAsig.codmed,4), ' ', '0') + ;
		strtran(substr(dtoc(mwkTurNoAsig.fechatur),1, 5),'/','') + ;
		left(ttoc(mwkTurNoAsig.horadesde,2), 2) + '*' as codbarra, mwktposerv.abrevio ;
		,mwkTurNoAsig.hhmmhas,mwkTurNoAsig.fechatur,mwkmpfecha.codesp,mwkTurNoAsig.diasem,;
		mwkTurNoAsig.esp_descripcion ;
		from mwkTurNoAsig ;
		left join mwktposerv on mwktposerv.id = tiposervicio ;
		left join mwkmpfecha on (mwkTurNoAsig.codmed = mwkmpfecha.codmed and ;
		mwkTurNoAsig.fechatur >= mwkmpfecha.fecvigend and ;
		mwkTurNoAsig.fechatur < mwkmpfecha.fecvigenh and ;
		mwkTurNoAsig.hhmmtur >= mwkmpfecha.hhmmdes and ;
		mwkTurNoAsig.hhmmtur<mwkmpfecha.hhmmhas and ;
		mwkTurNoAsig.diasem = mwkmpfecha.diasem );
		where generaagen = 1 ;
		group by mwkTurNoAsig.codmed ,mwkTurNoAsig.hhmmdes  ;
		into cursor mwkTurNoAsig2

Endif
