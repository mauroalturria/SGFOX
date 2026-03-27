***
*** Generacion de planilla de Turnos
***
Parameters mbusco1,mpreacre,tbCodAmb
If mxambito >1
	mccpoamb = "  t.codambito = ?mxambito and "
Else
	mccpoamb = ''
Endif

Do Case
Case mpreacre = 0
	mret = SQLExec(mcon1, 'select t.id, t.fechatur, t.horatur, t.codesp, t.diasem, t.codprest, ' + Iif(tbCodAmb, "t.CodAmbito, ", "cast( " + Transform(mxambito) + " as Int) as CodAmbito, " )+ ;
		't.usuario, t.fechatomado, t.confirmado, t.codreserva, prestadores.nombre, ' + ;
		't.codmedsoli, t.solicigia, t.tipoturno, t.codserv, t.codmed, t.codent, ' + ;
		'AFI_nroafiliado, registracio.REG_nrohclinica, registracio.REG_numdocumento,REG_bloq_comen, ' + ;
		'registracio.REG_nombrepac, prestacions.pre_descriprest, entidades.ENT_descrient, ' + ;
		'registracio.REG_telefonos, t.afiliado, 0 as preacre, t.codcancela, t.observa, null as fechaobserva,' + ;
		'feccancela, usucancela,t.tipotomado,t.confirmado,t.nrovale,t.idturnos ' + ;
		'from turnoscancel as t, prestadores, registracio, prestacions, entidades, afiliacion ' + ;
		" where &mccpoamb  t.codreserva<>'' and t.codmed = prestadores.id and "+ ;
		't.codprest = prestacions.pre_codprest and '  + ;
		't.afiliado = registracio.REG_nroregistrac and ' + ;
		't.codent = entidades.ENT_codent and ' + ;
		'registracio.REG_nroregistrac = afiliacion.registracio and ' + ;
		't.codent = afiliacion.AFI_codentidad and ' + ;
		' (t.tipoturno < 8 or t.tipoturno >=13) and ' + mbusco1 , 'mwkphorario')

Case mpreacre = 1
	mret = SQLExec(mcon1, 'select t.id, t.fechatur, t.horatur, t.codesp, t.diasem, t.codprest, ' +  Iif(tbCodAmb, "t.CodAmbito, ", "cast( " + Transform(mxambito) + " as Int) as CodAmbito, " )+ ;
		't.usuario, t.fechatomado, t.confirmado, t.codreserva, prestadores.nombre, ' + ;
		't.codmedsoli, t.solicigia, t.tipoturno, t.codserv, t.codmed, t.codent, ' + ;
		'preregistra.afiliado as AFI_nroafiliado, 0 as REG_nrohclinica, nrodocumento as REG_numdocumento, ' + ;
		'preregistra.nombre as REG_nombrepac, prestacions.pre_descriprest, entidades.ENT_descrient, ' + ;
		'preregistra.telefono as  REG_telefonos, t.afiliado, 1 as preacre, t.codcancela, t.observa, null as fechaobserva,' + ;
		'feccancela, usucancela,t.tipotomado,t.confirmado,t.nrovale,t.idturnos ' + ;
		'from turnoscancel as t, prestadores, preregistra, prestacions, entidades ' + ;
		"where &mccpoamb t.codreserva<>'' and t.codmed = prestadores.id and " + ;
		't.codprest = prestacions.pre_codprest and '  + ;
		't.codent   = entidades.ENT_codent and ' + ;
		't.afiliado = preregistra.id and ' + ;
		' (t.tipoturno < 8 or t.tipoturno >=13) and '+ mbusco1 , 'mwkphorario')

Case mpreacre = 2
	mret = SQLExec(mcon1, 'select t.id, t.fechatur, t.horatur, t.codesp, t.diasem, t.codprest, ' +  Iif(tbCodAmb, "t.CodAmbito, ", "cast( " + Transform(mxambito) + " as Int) as CodAmbito, " )+ ;
		't.usuario, t.fechatomado, t.confirmado, t.codreserva, prestadores.nombre, ' + ;
		't.codmedsoli, t.solicigia, t.tipoturno, t.codserv, t.codmed, t.codent, ' + ;
		'AFI_nroafiliado, registracio.REG_nrohclinica, registracio.REG_numdocumento,REG_bloq_comen, ' + ;
		'registracio.REG_nombrepac, prestacions.pre_descriprest, entidades.ENT_descrient, ' + ;
		'registracio.REG_telefonos, t.afiliado, 0 as preacre, t.codcancela, t.observa, null as fechaobserva,' + ;
		'feccancela, usucancela,t.tipotomado,t.confirmado,t.nrovale,t.idturnos ' + ;
		'from turnoscancel as t, prestadores, registracio, prestacions, entidades, afiliacion ' + ;
		"where &mccpoamb t.codreserva<>'' and t.codmed = prestadores.id and " + ;
		't.codprest = prestacions.pre_codprest and '  + ;
		't.afiliado = registracio.REG_nroregistrac and ' + ;
		't.codent = entidades.ENT_codent and ' + ;
		'registracio.REG_nroregistrac = afiliacion.registracio and ' + ;
		't.codent = afiliacion.AFI_codentidad and ' + ;
		' (t.tipoturno < 8 or t.tipoturno >=13) and ' + mbusco1 , 'mwkphorario1')
	If mret < 0
		Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
		Do prg_cancelo
	Endif
	mret = SQLExec(mcon1, 'select t.id, t.fechatur, t.horatur, t.codesp, t.diasem, t.codprest, ' +  Iif(tbCodAmb, "t.CodAmbito, ", "cast( " + Transform(mxambito) + " as Int) as CodAmbito, " )+ ;
		't.usuario, t.fechatomado, t.confirmado, t.codreserva, prestadores.nombre, ' + ;
		't.codmedsoli, t.solicigia, t.tipoturno, t.codserv, t.codmed, t.codent, ' + ;
		'preregistra.afiliado as AFI_nroafiliado, 0 as REG_nrohclinica, nrodocumento as REG_numdocumento, ' + ;
		'preregistra.nombre as REG_nombrepac, prestacions.pre_descriprest, entidades.ENT_descrient, ' + ;
		'preregistra.telefono as  REG_telefonos, t.afiliado, 1 as preacre, t.codcancela, t.observa, null as fechaobserva,' + ;
		'feccancela, usucancela,t.tipotomado,t.confirmado,t.nrovale,t.idturnos ' + ;
		'from turnoscancel as t, prestadores, preregistra, prestacions, entidades ' + ;
		" where &mccpoamb t.codreserva<>'' and t.codmed = prestadores.id and " + ;
		't.codprest = prestacions.pre_codprest and '  + ;
		't.codent   = entidades.ENT_codent and ' + ;
		't.afiliado = preregistra.id and ' + ;
		' (t.tipoturno < 8 or t.tipoturno >=13) and '+ mbusco1 , 'mwkphorario2')

	Select * From mwkphorario1 Union Select Id, fechatur, horatur, codesp, diasem, codprest,CodAmbito,;
		usuario, fechatomado, confirmado, codreserva, nombre,  ;
		codmedsoli, solicigia, tipoturno, codserv, codmed, codent, ;
		AFI_nroafiliado, "00000000-0"  As REG_nrohclinica, REG_numdocumento,space(200) as REG_bloq_comen,  ;
		REG_nombrepac, pre_descriprest, ENT_descrient, ;
		REG_telefonos, afiliado, preacre, codcancela, observa, fechaobserva,feccancela, usucancela,tipotomado  ;
		, confirmado, nrovale, idturnos;
		from mwkphorario2 Into Cursor mwkphorario

Endcase

If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	Do prg_cancelo
Else

	msql = 'select fechatur, left(ttoc(horatur,2), 5) as hora, nombre, pre_descriprest, codreserva, REG_nrohclinica, ' + ;
		'REG_telefonos, usuario, fechatomado, id, diasem, ENT_descrient, confirmado, REG_nombrepac, afiliado, ' + ;
		'horatur, codserv, codprest, codmed, codent, tipoturno, codesp, codmedsoli, solicigia, preacre, REG_numdocumento,REG_bloq_comen, ' + ;
		'codcancela, observa, fechaobserva,fechaobserva,feccancela, usucancela,tipotomado, confirmado,'+;
		' nrovale, idturnos,CodAmbito from mwkphorario '+;
		'order by fechatur, codmed,horatur into cursor mwkphorarios'

Endif

If Used("mwkphorario1")
	Use In mwkphorario1
Endif
If Used("mwkphorario2")
	Use In mwkphorario2
Endif
