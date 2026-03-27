***
*** Generacion de planilla de Turnos
***
Parameters mbusco1,mfecha,tbCodAmb

mccpoamb = ''
mccpoambbf = ''
If mxambito >1
	mccpoambbf = ' codambito = ?mxambito and '
	mccpoamb = "  medpresta.codambito = ?mxambito  and "
Endif
If Type('mfecha')#"D"
	mfecha = Ctod("01/01/1900")
Endif
mret = SQLExec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	'  where &mccpoambbf id<100000 order by fechacierre ','mwkctrlfecha')
Go Bottom In mwkctrlfecha
mfechalimite = mwkctrlfecha.fechacierre
Use In mwkctrlfecha
lhist=(mfecha <= mfechalimite)

mccpoambtm = ''
If mxambito >1
	mccpoambtm = "  and turnos.codambito = ?mxambito and medpresta.codambito = ?mxambito "
Endif


mok = .T.
** busco en turnos
mret = SQLExec(mcon1, 'select turnos.*, prestadores.nombre, ' +  Iif(tbCodAmb, "turnos.CodAmbito, ", "cast( " + Transform(mxambito) + " as Int) as CodAmbito, " )+ ;
	'AFI_nroafiliado, registracio.REG_nrohclinica, registracio.REG_numdocumento, ' + ;
	'registracio.REG_nombrepac, prestacions.pre_descriprest, entidades.ENT_descrient, ' + ;
	'registracio.REG_telefonos, medpresta.sala, 0 as preacre, ' + ;
	'AFI_fechabaja, ENT_turnoshabilit, ENT_fecpas, turnos.tipotomado  ' + ;
	'from registracio,entidades,afiliacion,turnos  '+;
	' left join prestadores on turnos.codmed = prestadores.id ' + ;
	' left join prestacions  on turnos.codprest = prestacions.pre_codprest ' + ;
	' left outer join medpresta on turnos.codmed	= medpresta.codmed ' + ;
	' and turnos.codprest = medpresta.codprest ' + ;
	" where  turnos.codreserva<>'' and " + ;
	'turnos.afiliado = registracio.REG_nroregistrac and ' + ;
	'turnos.codent	= entidades.ENT_codent and ' + ;
	'registracio.REG_nroregistrac = afiliacion.registracio and ' + ;
	'turnos.codent = afiliacion.AFI_codentidad and ' + ;
	'(turnos.tipoturno < 9 or turnos.tipoturno >= 13) and ' +mccpoamb + ;
	mbusco1  , 'mwkphorario4')

If mret < 0
	=Aerr(eros)
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	mok = .F.
	Do prg_cancelo
Endif
** busco en turnoshis
If lhist
	mret = SQLExec(mcon1, 'select turnos.*, prestadores.nombre, ' + Iif(tbCodAmb, "turnos.CodAmbito, ", "cast( " + Transform(mxambito) + " as Int) as CodAmbito, " )+ ;
		'AFI_nroafiliado, registracio.REG_nrohclinica, registracio.REG_numdocumento, ' + ;
		'registracio.REG_nombrepac, prestacions.pre_descriprest, entidades.ENT_descrient, ' + ;
		'registracio.REG_telefonos, medpresta.sala, 0 as preacre, ' + ;
		'AFI_fechabaja, ENT_turnoshabilit, ENT_fecpas, turnos.tomado as tipotomado ' + ;
		'from registracio,entidades,afiliacion,turnoshis as turnos '+;
		' left join prestadores on turnos.codmed = prestadores.id ' + ;
		' left join prestacions  on turnos.codprest = prestacions.pre_codprest ' + ;
		' left outer join medpresta on turnos.codmed	= medpresta.codmed ' + ;
		' and turnos.codprest = medpresta.codprest ' + ;
		" where  turnos.codreserva<>'' and " + ;
		'turnos.afiliado = registracio.REG_nroregistrac and ' + ;
		'turnos.codent	= entidades.ENT_codent and ' + ;
		'registracio.REG_nroregistrac = afiliacion.registracio and ' + ;
		'turnos.codent = afiliacion.AFI_codentidad and ' + ;
		'(turnos.tipoturno < 9 or turnos.tipoturno >= 13) and ' +mccpoamb  + ;
		mbusco1 , 'mwkphorario5')


	If mret < 0
		Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
		mok = .F.
		Do prg_cancelo
	Endif
Endif
mnada = .T.
If Reccount("mwkphorario4") > 0
	mnada = .F.
Endif
If Used("mwkphorario5")
	If Reccount("mwkphorario5") > 0
		mnada = .F.
	Endif
Endif

If mnada
	mret = SQLExec(mcon1, 'select turnos.*, prestadores.nombre, ' + Iif(tbCodAmb, "turnos.CodAmbito, ", "cast( " + Transform(mxambito) + " as Int) as CodAmbito, " )+ ;
		'preregistra.afiliado as AFI_nroafiliado, 0 as REG_nrohclinica, nrodocumento as REG_numdocumento, ' + ;
		'preregistra.nombre as REG_nombrepac, prestacions.pre_descriprest, entidades.ENT_descrient, ' + ;
		'preregistra.telefono as  REG_telefonos, medpresta.sala, 1 as preacre, ' + ;
		'preregistra.fechabaja as AFI_fechabaja, ENT_turnoshabilit, ENT_fecpas,turnos.tipotomado  ' + ;
		'from preregistra,entidades,afiliacion,turnos  '+;
		' left join prestadores on turnos.codmed = prestadores.id ' + ;
		' left join prestacions  on turnos.codprest = prestacions.pre_codprest ' + ;
		' left outer join medpresta on turnos.codmed	= medpresta.codmed ' + ;
		' and turnos.codprest = medpresta.codprest ' + ;
		" where  turnos.codreserva<>'' and " + ;
		'turnos.afiliado = preregistra.id and ' + ;
		'turnos.codent	= entidades.ENT_codent and ' +mccpoamb + ;
		mbusco1 , 'mwkphorario4')
	If mret < 0
		Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
		Do prg_cancelo
	Endif
	If lhist
		mret = SQLExec(mcon1, 'select turnos.*, prestadores.nombre, ' + Iif(tbCodAmb, "turnos.CodAmbito, ", "cast( " + Transform(mxambito) + " as Int) as CodAmbito, " )+ ;
			'preregistra.afiliado as AFI_nroafiliado, 0 as REG_nrohclinica, nrodocumento as REG_numdocumento, ' + ;
			'preregistra.nombre as REG_nombrepac, prestacions.pre_descriprest, entidades.ENT_descrient, ' + ;
			'preregistra.telefono as  REG_telefonos, medpresta.sala, 1 as preacre, ' + ;
			'preregistra.fechabaja as AFI_fechabaja, ENT_turnoshabilit, ENT_fecpas,turnos.tomado as tipotomado  ' + ;
			'from preregistra,entidades,afiliacion,turnoshis as turnos  '+;
			' left join prestadores on turnos.codmed = prestadores.id ' + ;
			' left join prestacions  on turnos.codprest = prestacions.pre_codprest ' + ;
			' left outer join medpresta on turnos.codmed	= medpresta.codmed ' + ;
			' and turnos.codprest = medpresta.codprest ' + ;
			" where  turnos.codreserva<>'' and " + ;
			'turnos.afiliado = preregistra.id and ' + ;
			'turnos.codent	= entidades.ENT_codent and ' +mccpoamb  + ;
			mbusco1 , 'mwkphorario5')


		If mret < 0
			Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
			Do prg_cancelo
		Endif
	Endif
Endif
If Used('mwkphorario5') And Reccount('mwkphorario5')>0
	If Reccount('mwkphorario4') >0
		Select * From mwkphorario4 ;
			union All ;
			select * From mwkphorario5 ;
			into Cursor mwkphorario
	Else
		Select * From mwkphorario5 ;
			into Cursor mwkphorario
	Endif
Else
	Select * From mwkphorario4 ;
		into Cursor mwkphorario
Endif
msql = "select fechatur, left(ttoc(horatur,2), 5) as hora, IIF(isnull(sala),'CONTROLE PRESTACION',nombre) as nombre, pre_descriprest, codreserva, REG_nrohclinica, " + ;
	" '--' as sala1 , " + ;
	"REG_telefonos, usuario, fechatomado, observa, id, diasem, ENT_descrient, confirmado, REG_nombrepac, afiliado, " + ;
	"horatur, codserv, codprest, codmed, codent, tipoturno, codesp, codmedsoli, solicigia, preacre, REG_numdocumento, " + ;
	"AFI_fechabaja, ENT_turnoshabilit, ENT_fecpas, AFI_nroafiliado, nrovale, sala, tipotomado,CodAmbito " + ;
	"from mwkphorario order by fechatur, codmed, horatur into cursor mwkphorarios"


If Used('mwkphorario4')
	Select mwkphorario4
	Use
Endif
If Used('mwkphorario5')
	Select mwkphorario5
	Use
Endif
