***
*** Generacion de planilla de Turnos de un afiliado
***

Parameter mafili,mprereg,mfecha, tbCodAmb

If Type('mprereg')#"N"
	mprereg = 0
Endif
If Type('mfecha')#"D"
	mfecha = sp_busco_fecha_serv('DD') + 100
Endif

If Used('mwkpMed')
	Use In mwkpmed
Endif

Do sp_busco_phordatos

*mfecha = Ctod("2015-01-01")

mccpoamb = ''
If mxambito >1
	mccpoamb = "  and turnos.codambito = ?mxambito and medpresta.codambito = ?mxambito "
	mret = SQLExec(mcon1, "SELECT TOP 1 * from  tabambulatorio "+ ;
		" ORDER BY ID ", "mwkctrlamb")
	Select mwkctrlamb
	Scatter Memvar
	If Vartype(m.codambito)#"N"
		mccpoamb = ''
	Endif
	Use In Select("mwkctrlamb")
Endif
If mprereg = 0
&& busco en turnos
	mret = SQLExec(mcon1, 'select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, ' + Iif(tbCodAmb, "turnos.CodAmbito, ", "cast( " + Transform(mxambito) + " as Int) as CodAmbito, " ) +  ;
		'turnos.diasem, turnos.codprest, AFI_nroafiliado, turnos.confirmado, ' + ;
		'turnos.codreserva, registracio.REG_nrohclinica, registracio.REG_numdocumento, ' + ;
		'registracio.REG_nombrepac, turnos.usuario, turnos.fechatomado, AFI_fechabaja, ' + ;
		'turnos.codent, turnos.codserv, turnos.afiliado, turnos.codmedsoli,turnos.solicigia, '+;
		'cast(0 as integer) as codcancela,turnos.codmed, ' + ;
		'turnos.nrovale, medpresta.sala, turnos.observa, turnos.fechaobserva,turnos.tipotomado,turnos.tipoturno,hhmmtur  ' + ;
		'from turnos , registracio, afiliacion, medpresta ' + ;
		" where turnos.codreserva<>'' And " + ;
		'turnos.afiliado = registracio.REG_nroregistrac And ' + ;
		'registracio.REG_nroregistrac = afiliacion.registracio And ' + ;
		'turnos.codent = afiliacion.AFI_codentidad And ' + ;
		'turnos.codmed   = medpresta.codmed And ' + ;
		'turnos.codprest = medpresta.codprest And ' + ;
		'turnos.diasem	= medpresta.diasem And ' + ;
		'turnos.fechatur >= medpresta.fecvigend And ' + ;
		'medpresta.fecvigenh <> medpresta.fecvigend And ' + ;
		'turnos.fechatur <  medpresta.fecvigenh And ' + ;
		'turnos.hhmmtur >= medpresta.hhmmDes And ' + ;
		'turnos.hhmmtur < medpresta.hhmmHas And ' + ;
		"turnos.fechatur <= ?mfecha and " + ;
		'turnos.afiliado = ?mafili ' + mccpoamb +;
		'Group By turnos.fechatur, turnos.codmed, AFI_nroafiliado, turnos.codreserva, turnos.horatur,turnos.codprest' + ;
		'', 'mwkphorario3')

	If mret < 0
		=Aerr(eros)
		Messagebox(eros(3))
		Return .F.
*messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	Endif
&& busco en turnoshis
	mret = SQLExec(mcon1, 'select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, ' + Iif(tbCodAmb, "turnos.CodAmbito, ", "cast( "  + Transform(mxambito) + " as Int) as CodAmbito, " ) +  ;
		'turnos.diasem, turnos.codprest, AFI_nroafiliado, turnos.confirmado, ' + ;
		'turnos.codreserva, registracio.REG_nrohclinica, registracio.REG_numdocumento, ' + ;
		'registracio.REG_nombrepac, turnos.usuario, turnos.fechatomado, AFI_fechabaja, ' + ;
		'turnos.codent, turnos.codserv, turnos.afiliado, turnos.codmedsoli,turnos.solicigia, '+;
		'cast(0 as integer) as codcancela,turnos.codmed, ' + ;
		'turnos.nrovale, medpresta.sala, turnos.observa, turnos.fechaobserva,turnos.tomado as tipotomado,turnos.tipoturno,hhmmtur ' + ;
		'from turnoshis as turnos , registracio, afiliacion, medpresta ' + ;
		" where  turnos.codreserva<>'' And " + ;
		'turnos.afiliado = registracio.REG_nroregistrac And ' + ;
		'registracio.REG_nroregistrac = afiliacion.registracio And ' + ;
		'turnos.codent = afiliacion.AFI_codentidad And ' + ;
		'turnos.codmed   = medpresta.codmed And ' + ;
		'turnos.codprest = medpresta.codprest And ' + ;
		'turnos.diasem	= medpresta.diasem And ' + ;
		'turnos.fechatur >= medpresta.fecvigend And ' + ;
		'turnos.fechatur <  medpresta.fecvigenh And ' + ;
		'medpresta.fecvigenh <> medpresta.fecvigend And ' + ;
		'turnos.hhmmtur  >= medpresta.hhmmDes And ' + ;
		'turnos.hhmmtur  < medpresta.hhmmHas And ' + ;
		"turnos.fechatur <= ?mfecha and " + ;
		'turnos.afiliado = ?mafili ' + mccpoamb +;
		'Group By turnos.fechatur, turnos.codmed, AFI_nroafiliado, turnos.codreserva, turnos.horatur,turnos.codprest ' + ;
		'', 'mwkphorario4')

	If mret < 0
		=Aerr(eros)
		Messagebox(eros(3))
		Return .F.
*messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	Endif

&& busco los cancelados
	mret = SQLExec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, " + Iif(tbCodAmb, "turnos.CodAmbito, ", "cast( "  + Transform(mxambito) + " as Int) as CodAmbito, " ) +  ;
		"turnos.diasem, turnos.codprest, AFI_nroafiliado, cast(3 as integer) as confirmado, " + ;
		"turnos.codreserva, registracio.REG_nrohclinica, registracio.REG_numdocumento, " + ;
		"registracio.REG_nombrepac, turnos.usucancela as usuario, turnos.feccancela as fechatomado, " + ;
		"AFI_fechabaja, turnos.codent, turnos.codserv, turnos.afiliado,fecvigend,fecvigenh, " + ;
		"turnos.codmedsoli,turnos.solicigia, turnos.codcancela,turnos.codmed, turnos.nrovale, medpresta.sala,turnos.tipotomado,turnos.tipoturno,hhmmtur " + ;
		"from registracio, afiliacion,turnoscancel as turnos "+;
		" LEFT JOIN medpresta  ON ( " + ;
		'turnos.codmed   = medpresta.codmed and ' + ;
		'turnos.codprest = medpresta.codprest and ' + ;
		'turnos.diasem	= medpresta.diasem ) ' +;
		" where  turnos.codreserva<>'' and turnos.fechatur <= ?mfecha and " + ;
		"turnos.afiliado = registracio.REG_nroregistrac and " + ;
		"registracio.REG_nroregistrac = afiliacion.registracio and " + ;
		"turnos.codent = afiliacion.AFI_codentidad and " + ;
		"turnos.afiliado = ?mafili " + mccpoamb +;
		"group by turnos.fechatur, turnos.codmed, AFI_nroafiliado, turnos.codreserva, turnos.horatur,medpresta.id,turnos.codprest  " + ;
		"", "mwkphorario5aux")
	If mret < 0
		=Aerr(eros)
		Messagebox(eros(3))
		Return .F.
*messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	Endif

	Select Id, fechatur, horatur, codesp,codambito,diasem, codprest, AFI_nroafiliado, confirmado,   ;
		codreserva,  REG_nrohclinica, REG_numdocumento,REG_nombrepac, usuario, fechatomado,   ;
		AFI_fechabaja, codent, codserv, afiliado,  ;
		codmedsoli,solicigia, codcancela,codmed, nrovale,  sala,tipotomado,tipoturno,hhmmtur   ;
		FROM mwkphorario5aux ;
		WHERE Between(fechatur,fecvigend,fecvigenh);
		group By  fechatur,  codmed, AFI_nroafiliado,  codreserva,  horatur,codprest Into Cursor mwkphorario5a1

	Select Id, fechatur, horatur, codesp,codambito,diasem, codprest, AFI_nroafiliado, confirmado,   ;
		codreserva,  REG_nrohclinica, REG_numdocumento,REG_nombrepac, usuario, fechatomado,   ;
		AFI_fechabaja, codent, codserv, afiliado,  ;
		codmedsoli,solicigia, codcancela,codmed, nrovale,  sala,tipotomado,tipoturno,hhmmtur   ;
		FROM mwkphorario5aux ;
		WHERE codreserva Not In (Select  codreserva From mwkphorario5a1);
		Group By  fechatur,  codmed, AFI_nroafiliado,  codreserva,  horatur,codprest Into Cursor mwkphorario5a2
	If Reccount('mwkphorario5a2')>0
		Select * From mwkphorario5a1 Union All;
			select * From mwkphorario5a2;
			INTO Cursor mwkphorario5
	Else
		Select * From mwkphorario5a1 Into Cursor mwkphorario5
	Endif

*	"turnos.fechatur >= medpresta.fecvigend and " +
*	'medpresta.fecvigenh <> medpresta.fecvigend and ' +
*	"turnos.codprest = medpresta.codprest and " +

&&  *	"turnos.fechatur <  medpresta.fecvigenh and "
	Select * From mwkphorario3 ;
		union All ;
		select * From mwkphorario4 ;
		union All ;
		select Id, fechatur, horatur, codesp, codambito, diasem, codprest ;
		, AFI_nroafiliado, confirmado, codreserva, REG_nrohclinica;
		, REG_numdocumento, REG_nombrepac ;
		,usuario, fechatomado, AFI_fechabaja;
		, codent, codserv, afiliado, codmedsoli,solicigia, codcancela,codmed, nrovale, sala;
		, Space(100) As observa ,Ctot("  /  /  ") As fechaobserva,tipotomado,tipoturno,hhmmtur ;
		from mwkphorario5 ;
		into Cursor mwkphorario
	mihora = sp_busco_fecha_serv("DT")
	midia = Ttod(mihora)
	Select mwkphorario.*,mwkpmed.nombre,pre_descriprest, ent_descrient, ;
		ent_turnoshabilit, ent_fecpas, ;
		iif(At("->",observa)>0,"*"," ") As reprog,pre_tipomuestra,PRE_Lateralidad ,PRE_tipozona ;
		,Iif(midia =fechatur And horatur<mihora And confirmado= 0,Int((mihora-horatur)/60),0000 ) As demora;
		From mwkphorario;
		left Join mwkpent On codent = ent_codent ;
		left Join mwkpesp On codesp = esp_codesp ;
		left Join mwkpmed On codmed = mwkpmed.Id ;
		left Join mwkppres On codprest = pre_codprest ;
		order By fechatur, codmed, horatur,codprest	;
		into Cursor mwkphorarios
Else
&& busco en turnos por preregistrados
	mret = SQLExec(mcon1, 'select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, ' + Iif(tbCodAmb, "turnos.CodAmbito, ", "cast( "  + Transform(mxambito) + " as Int) as CodAmbito, " ) +  ;
		'turnos.diasem, turnos.codprest, turnos.afiliado as AFI_nroafiliado, ' + ;
		'turnos.confirmado, turnos.codreserva, 0 as REG_nrohclinica, preregistra.nrodocumento as REG_numdocumento, ' + ;
		'preregistra.nombre as REG_nombrepac, turnos.usuario, turnos.fechatomado, turnos.codent, turnos.codserv, ' + ;
		'preregistra.fechabaja as AFI_fechabaja, turnos.afiliado, turnos.codmedsoli,turnos.solicigia, '+;
		'cast(0 as integer) as codcancela,' + ;
		'turnos.codmed, turnos.nrovale, medpresta.sala,turnos.observa, turnos.fechaobserva,turnos.tipotomado,turnos.tipoturno,hhmmtur  ' + ;
		'from turnos , preregistra, medpresta ' + ;
		" where  turnos.codreserva<>'' and " + ;
		'turnos.afiliado = preregistra.id and ' + ;
		'turnos.codmed   = medpresta.codmed and ' + ;
		'turnos.codprest = medpresta.codprest and ' + ;
		'turnos.diasem	= medpresta.diasem and ' + ;
		'turnos.fechatur >= medpresta.fecvigend and ' + ;
		'turnos.fechatur <  medpresta.fecvigenh and ' + ;
		'turnos.hhmmtur >= medpresta.hhmmDes and ' + ;
		'turnos.hhmmtur < medpresta.hhmmHas and ' + ;
		'medpresta.fecvigenh <> medpresta.fecvigend and ' + ;
		'turnos.fechatur <= ?mfecha and ' + ;
		'turnos.afiliado = ?mafili ' +mccpoamb + ;
		'group by turnos.fechatur, turnos.codmed, turnos.afiliado, turnos.codreserva, turnos.horatur,turnos.codprest  ' + ;
		'', 'mwkphorario3')


	If mret < 0
		=Aerr(eros)
		Messagebox(eros(3))
		Return .F.
*messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	Endif
*!*		If mret < 0
*!*			=Aerr(eros)
*!*			Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
*!*		Endif

&& busco los cancelados
	mret = SQLExec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, " + Iif(tbCodAmb, "turnos.CodAmbito, ", "cast( "  + Transform(mxambito) + " as Int) as CodAmbito, " ) +  ;
		"turnos.diasem, turnos.codprest, turnos.afiliado as AFI_nroafiliado, CAST(3 as integer) as confirmado, " + ;
		"turnos.codreserva, 0 as  REG_nrohclinica, preregistra.nrodocumento as REG_numdocumento, " + ;
		"preregistra.nombre as REG_nombrepac, turnos.usucancela as usuario, turnos.feccancela as fechatomado, " + ;
		"turnos.codent, turnos.codserv, preregistra.fechabaja as AFI_fechabaja, turnos.afiliado, " + ;
		"turnos.codmedsoli,turnos.solicigia, turnos.codcancela,turnos.codmed, turnos.nrovale, medpresta.sala,turnos.tipotomado,turnos.tipoturno,hhmmtur " + ;
		"from turnoscancel as turnos , preregistra, medpresta " + ;
		"where  turnos.codreserva<>'' and " + ;
		"turnos.afiliado = preregistra.id and " + ;
		"turnos.codmed   = medpresta.codmed and " + ;
		"turnos.diasem	 = medpresta.diasem and " + ;
		"turnos.fechatur <= ?mfecha and " + ;
		'turnos.hhmmtur >= medpresta.hhmmDes and ' + ;
		'turnos.hhmmtur < medpresta.hhmmHas and ' + ;
		"turnos.afiliado = ?mafili " + mccpoamb +;
		"group by turnos.fechatur, turnos.codmed, turnos.afiliado, turnos.codreserva, turnos.horatur ,turnos.codprest " + ;
		"", "mwkphorario5")

	If mret < 0
		=Aerr(eros)
		Messagebox(eros(3))
		Return .F.
*messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	Endif

*!*			union all ;
*!*			select * from mwkphorario4

*!*		select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, ' + Iif(tbCodAmb, "turnos.CodAmbito, ", "cast( "  + Transform(mxambito) + " as Int) as CodAmbito, " ) +  ;
*!*			'turnos.diasem, turnos.codprest, turnos.afiliado as AFI_nroafiliado, ' + ;
*!*			'turnos.confirmado, turnos.codreserva, 0 as REG_nrohclinica, preregistra.nrodocumento as REG_numdocumento, ' + ;
*!*			'preregistra.nombre as REG_nombrepac, turnos.usuario, turnos.fechatomado, turnos.codent, turnos.codserv, ' + ;
*!*			'preregistra.fechabaja as AFI_fechabaja, turnos.afiliado, turnos.codmedsoli,turnos.solicigia, '+;
*!*			'cast(0 as integer) as codcancela,' + ;
*!*			'turnos.codmed, turnos.nrovale, medpresta.sala,turnos.observa, turnos.fechaobserva,turnos.tipoturno,hhmmtur  ' + ;

	Select * From mwkphorario3 ;
		union All ;
		select Id, fechatur, horatur, codesp,codambito,diasem, codprest;
		, AFI_nroafiliado, confirmado, codreserva, REG_nrohclinica;
		, REG_numdocumento, REG_nombrepac ;
		, usuario, fechatomado, codent, codserv, AFI_fechabaja;
		, afiliado, codmedsoli,solicigia, codcancela,codmed;
		, nrovale, sala, Space(100) As observa, Ctot("  /  /  ") As fechaobserva,tipotomado,tipoturno,hhmmtur;
		from mwkphorario5 ;
		into Cursor mwkphorario

	mihora = sp_busco_fecha_serv("DT")
	midia = Ttod(mihora)
	Select mwkphorario.*,mwkpmed.nombre,pre_descriprest, ent_descrient, ;
		ent_turnoshabilit, ent_fecpas, ;
		iif(At("->",observa)>0,"*"," ") As reprog,pre_tipomuestra,PRE_Lateralidad ,PRE_tipozona ;
		,Iif(midia =fechatur And horatur<mihora And confirmado= 0,Int((mihora-horatur)/60),0 ) As demora;
		From mwkphorario;
		left Join mwkpent On codent = ent_codent ;
		left Join mwkpesp On codesp = esp_codesp ;
		left Join mwkpmed On codmed = mwkpmed.Id ;
		left Join mwkppres On codprest = pre_codprest ;
		order By fechatur, codmed, horatur	;
		into Cursor mwkphorarios

Endif

If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	Do prg_cancelo
Else
*!* ,iif(codesp='PSIC','__','')+pre_descriprest as pre_descriprest
	If !Used("mwktabambito")
		Do sp_busco_tabla_id With 'tabambito', ' ','mwktabambito'
	Endif

	msql = "select mwkphorarios.fechatur, left(ttoc(mwkphorarios.horatur,2), 5) as hora, mwkphorarios.nombre,"+;
		" mwkphorarios.pre_descriprest, mwkTabAmbito.Ambito, " + ;
		"iif(mwkphorarios.confirmado = 0, 'NO ', iif(mwkphorarios.confirmado = 1, 'SI ',"+;
		" iif(mwkphorarios.codcancela = 49, 'IVR ', 'AN ')))+reprog as confirmado, " + ;
		"mwkphorarios.codreserva, mwkphorarios.usuario, mwkphorarios.fechatomado, mwkphorarios.id, mwkphorarios.nrovale, " + ;
		"mwkphorarios.sala, mwkphorarios.codmed,mwkphorarios.codserv,mwkphorarios.horatur, mwkphorarios.observa, mwkphorarios.fechaobserva, " + ;
		"mwkphorarios.tipotomado,mwkphorarios.REG_nombrepac, mwkphorarios.tipoturno,hhmmtur,mwkphorarios.pre_tipomuestra,PRE_Lateralidad ,PRE_tipozona ,demora " + ;
		"from mwkphorarios " + ;
		"Inner Join mwkTabAmbito On mwkTabAmbito.Id = mwkphorarios.Codambito " + ;
		"order by mwkphorarios.fechatur desc into cursor mwkphorarios2"

Endif

If Used('mwkphorario3')
	Select mwkphorario3
	Use
Endif
If Used('mwkphorario4')
	Select mwkphorario4
	Use
Endif
If Used('mwkphorario5')
	Select mwkphorario5
	Use
Endif
If Used('mwkphorario')
	Select mwkphorario
	Use
Endif
