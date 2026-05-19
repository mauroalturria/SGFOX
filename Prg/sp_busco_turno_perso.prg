***
*** Generacion de planilla de Turnos
***
Parameters mbusco1,mpreacre,mfecha,lcontrol,mbusco2,tbCodAmb,mcentro
If Vartype(lcontrol)#"N"
	lcontrol= 0
Endif
If Vartype(mcentro)#"N"
	mcentro = 1
Endif
mccpoamb = ''
mccpoambbf = ''
If mxambito >1
	mccpoambbf = ' codambito = ?mxambito and '
	mccpoamb = "  t.codambito = ?mxambito and medpresta.codambito = ?mxambito and "
Endif
*mccentro = Iif(mcentro=1,' where  AT("LIMA",sala)=0 ', ' where  AT("LIMA",sala)>0 ')
mccentro =  Iif(mxambito = 1,Iif(mcentro=1,' where  (AT("LIMA",sala)=0 and  AT("CP",sala)=0) ', ;
	Iif(mcentro=2,' where   AT("LIMA",sala)>0 ', ' where  AT("CP",sala)>0 ')),' ')
If Type('mfecha')#"D"
	mfecha = Ctod("01/01/1900")
Endif
mret = SQLExec(mcon1,'select * FROM TurnosFechas '+ ; &&FechaCierre,FechaProceso
' where &mccpoambbf  id<100000 order by fechacierre ','mwkctrlfecha')
If !((mxambito> 1 And mwkctrlfecha.codambito>1) OR ( mxambito=1 And NVL(mwkctrlfecha.codambito,0)<=1) )  &&& tengo la conexion erronea
	Do sp_desconexion
	Do sp_conexion
	mret = SQLExec(mcon1,'select * FROM TurnosFechas '+ ; &&FechaCierre,FechaProceso
	' where &mccpoambbf  id<100000 order by fechacierre ','mwkctrlfecha')
Endif
Go Bottom In mwkctrlfecha
mfechalimite = mwkctrlfecha.fechacierre
Use In mwkctrlfecha
lhist=(mfecha <= mfechalimite)

If Used('mwkpMed')
	Use In mwkpMed
Endif
Do sp_busco_phordatos

mok = .T.
mnada = .T.
mccpoamb = ''
mccpoambbf = ''
If mxambito >1
	mccpoambbf = ' codambito = ?mxambito and '
	mccpoamb = "  t.codambito = ?mxambito and medpresta.codambito = ?mxambito and "
Endif

If mpreacre # 1
** busco en turnos
	mret = SQLExec(mcon1, 'select t.id, t.fechatur, t.horatur, t.codesp, t.diasem, t.codprest,'+ Iif(tbCodAmb, "t.CodAmbito, ", "cast( " + Transform(mxambito) + " as Int) as CodAmbito, " )+ ;
	't.usuario, t.fechatomado, t.confirmado, t.codreserva, t.codmedsoli, ' + ;
	't.solicigia, t.tipoturno, t.codserv, t.codmed, t.codent, AFI_nroafiliado, ' + ;
	'registracio.REG_nrohclinica, registracio.REG_numdocumento, registracio.REG_nombrepac, ' + ;
	'registracio.REG_telefonos, t.afiliado, medpresta.sala, cast(0 as integer) as preacre, ' + ;
	't.observa, AFI_fechabaja, t.fechaobserva, t.nrovale,t.tipotomado, t.fechagenera ' + ;
	'from turnos as t '+;
	'inner join registracio on t.afiliado = registracio.REG_nroregistrac '+;
	'inner join afiliacion on ('+;
	'registracio.REG_nroregistrac = afiliacion.registracio and ' + ;
	't.codent = afiliacion.AFI_codentidad )' + ;
	'inner join medpresta on (' + ;
	't.codmed	= medpresta.codmed and ' + ;
	't.codprest = medpresta.codprest and ' + ;
	't.diasem	= medpresta.diasem and ' + ;
	't.fechatur >= medpresta.fecvigend and ' + ;
	't.fechatur <  medpresta.fecvigenh and ' + ;
	't.hhmmtur >= medpresta.hhmmDes and ' + ;
	't.hhmmtur < medpresta.hhmmHas and ' + ;
	'medpresta.fecvigenh <> medpresta.fecvigend )' + ;
	" where t.codreserva<>'' and " + ;
	'(t.tipoturno < 9 or t.tipoturno >= 13) and ' +mccpoamb + mbusco1  , 'mwkphorario4')

	If mret < 0
*!*			=AERROR(eros)
*!*			MESSAGEBOX(eros(3))
		Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
		mok = .F.
		Do prg_cancelo
	Endif
	If Reccount('mwkphorario4') = 0 And lcontrol = 1  &&&& esto es una truchada para arreglar la entidad
		mret = SQLExec(mcon1, 'select t.id, AFI_fechabaja, AFI_codentidad ' + ;
		'from turnos as t, registracio, afiliacion ' + ;
		" where  t.codreserva<>'' and " + ;
		't.afiliado = registracio.REG_nroregistrac and ' + ;
		'registracio.REG_nroregistrac = afiliacion.registracio and ' + ;
		mbusco2 , 'mwkphorario3')
		If Reccount('mwkphorario3') > 0
			Select AFI_codentidad From mwkphorario3 Where Isnull(AFI_fechabaja) Into Cursor mwkcontrol
			If Reccount('mwkcontrol') = 0
				Select AFI_codentidad From mwkphorario3 Order By AFI_fechabaja Desc Into Cursor mwkcontrol
			Endif
			Select Distinct Id From mwkphorario3 Into Cursor mwkarreglo
			mcodent = mwkcontrol.AFI_codentidad
			Select mwkarreglo
			Scan
				mid = mwkarreglo.Id
				mret = SQLExec(mcon1, "update turnos set codent = ?mcodent where id = ?id")
			Endscan
			Use In mwkarreglo
			Use In mwkphorario3
			Use In mwkcontrol
			mret = SQLExec(mcon1, 'select t.id, t.fechatur, t.horatur, t.codesp, t.diasem, t.codprest, ' +Iif(tbCodAmb, "t.CodAmbito, ", "cast( " + Transform(mxambito) + " as Int) as CodAmbito, " )+ ;
			't.usuario, t.fechatomado, t.confirmado, t.codreserva, t.codmedsoli, ' + ;
			't.solicigia, t.tipoturno, t.codserv, t.codmed, t.codent, AFI_nroafiliado, ' + ;
			'registracio.REG_nrohclinica, registracio.REG_numdocumento, registracio.REG_nombrepac, ' + ;
			'registracio.REG_telefonos, t.afiliado, medpresta.sala, cast(0 as integer) as preacre, ' + ;
			't.observa, AFI_fechabaja, t.fechaobserva, t.nrovale,t.tipotomado,t.fechagenera ' + ;
			'from turnos as t '+;
			'inner join  registracio on t.afiliado = registracio.REG_nroregistrac '+;
			'inner join  afiliacion on ('+;
			'registracio.REG_nroregistrac = afiliacion.registracio and ' + ;
			't.codent = afiliacion.AFI_codentidad ) ' + ;
			'inner join  medpresta on (' + ;
			't.codmed	= medpresta.codmed and ' + ;
			't.codprest = medpresta.codprest and ' + ;
			't.diasem	= medpresta.diasem and ' + ;
			't.fechatur >= medpresta.fecvigend and ' + ;
			't.fechatur <  medpresta.fecvigenh and ' + ;
			't.hhmmtur >= medpresta.hhmmDes and ' + ;
			't.hhmmtur < medpresta.hhmmHas and ' + ;
			'medpresta.fecvigenh <> medpresta.fecvigend )' + ;
			" where  t.codreserva<>'' and " + ;
			'(t.tipoturno < 9 or t.tipoturno >= 13) and ' +mccpoamb + mbusco1  , 'mwkphorario4')

		Endif
	Endif

** busco en turnoshis
	If lhist
		mret = SQLExec(mcon1, 'select t.id, t.fechatur, t.horatur, t.codesp, t.diasem, t.codprest, ' + Iif(tbCodAmb, "t.CodAmbito, ", "cast( " + Transform(mxambito) + " as Int) as CodAmbito, " )+  ;
		't.usuario, t.fechatomado, t.confirmado, t.codreserva, t.codmedsoli, ' + ;
		't.solicigia, t.tipoturno, t.codserv, t.codmed, t.codent, AFI_nroafiliado, ' + ;
		'registracio.REG_nrohclinica, registracio.REG_numdocumento, registracio.REG_nombrepac, ' + ;
		'registracio.REG_telefonos, t.afiliado, medpresta.sala, cast(0 as integer) as preacre, t.observa, ' + ;
		'AFI_fechabaja, t.fechaobserva, t.nrovale,t.tomado as tipotomado,t.fechagenera ' + ;
		'from turnoshis as t '+;
		'inner join registracio on t.afiliado = registracio.REG_nroregistrac '+;
		'inner join afiliacion on ('+;
		'registracio.REG_nroregistrac = afiliacion.registracio and ' + ;
		't.codent = afiliacion.AFI_codentidad )' + ;
		'inner join medpresta on (' + ;
		't.codmed	= medpresta.codmed and ' + ;
		't.codprest = medpresta.codprest and ' + ;
		't.diasem	= medpresta.diasem and ' + ;
		't.fechatur >= medpresta.fecvigend and ' + ;
		't.fechatur <  medpresta.fecvigenh and ' + ;
		't.hhmmtur >= medpresta.hhmmDes and ' + ;
		't.hhmmtur < medpresta.hhmmHas and ' + ;
		'medpresta.fecvigenh <> medpresta.fecvigend )' + ;
		" where  t.codreserva<>'' and "+ ;
		'(t.tipoturno < 9 or t.tipoturno >= 13) and ' +mccpoamb + mbusco1  , 'mwkphorario5')

		If mret < 0
			Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
			mok = .F.
			Do prg_cancelo
		Endif
	Endif
	If Reccount("mwkphorario4") > 0
		mnada = .F.
	Endif
	If Used("mwkphorario5")
		If Reccount("mwkphorario5") > 0
			mnada = .F.
		Endif
	Endif
Endif
If mnada And mpreacre # 0
	mret = SQLExec(mcon1, 'select t.id, t.fechatur, t.horatur, t.codesp, t.diasem, t.codprest, ' +  Iif(tbCodAmb, "t.CodAmbito, ", "cast( " + Transform(mxambito) + " as Int) as CodAmbito, " )+ ;
	't.usuario, t.fechatomado, t.confirmado, t.codreserva, t.codmedsoli, ' + ;
	't.solicigia, t.tipoturno, t.codserv, t.codmed, t.codent, preregistra.afiliado as AFI_nroafiliado, ' + ;
	'0 as REG_nrohclinica, nrodocumento as REG_numdocumento, preregistra.nombre as REG_nombrepac, ' + ;
	'preregistra.telefono as  REG_telefonos, t.afiliado, medpresta.sala, cast(1 as integer) as preacre, t.observa, ' + ;
	'preregistra.fechabaja as AFI_fechabaja, t.fechaobserva, t.nrovale,t.tipotomado,t.fechagenera  ' + ;
	'from turnos as t '+;
	'inner join preregistra on t.afiliado = preregistra.id  '+;
	'inner join medpresta on (' + ;
	't.codmed   = medpresta.codmed and ' + ;
	't.codprest = medpresta.codprest and ' + ;
	't.fechatur >= medpresta.fecvigend and ' + ;
	't.fechatur <  medpresta.fecvigenh and ' + ;
	't.hhmmtur >= medpresta.hhmmDes and ' + ;
	't.hhmmtur < medpresta.hhmmHas and ' + ;
	't.diasem	= medpresta.diasem and ' + ;
	'medpresta.fecvigenh <> medpresta.fecvigend )' + ;
	" where t.codreserva<>'' and "+ ;
	'(t.tipoturno < 9 or t.tipoturno >= 13) and ' +mccpoamb +mbusco1 , 'mwkphorario4')
	If mret < 0
		Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
		Do prg_cancelo
	Endif
	If lhist
		mret = SQLExec(mcon1, 'select t.id, t.fechatur, t.horatur, t.codesp, t.diasem, t.codprest, ' +  Iif(tbCodAmb, "t.CodAmbito, ", "cast( " + Transform(mxambito) + " as Int) as CodAmbito, " )+ ;
		't.usuario, t.fechatomado, t.confirmado, t.codreserva, t.codmedsoli, ' + ;
		't.solicigia, t.tipoturno, t.codserv, t.codmed, t.codent, preregistra.afiliado as AFI_nroafiliado, ' + ;
		'0 as REG_nrohclinica, nrodocumento as REG_numdocumento, preregistra.nombre as REG_nombrepac, ' + ;
		'preregistra.telefono as  REG_telefonos, t.afiliado, medpresta.sala, cast(1 as integer) as preacre, t.observa, ' + ;
		'preregistra.fechabaja as AFI_fechabaja, t.fechaobserva, t.nrovale,t.tomado as tipotomado,t.fechagenera  ' + ;
		'from turnoshis as t '+;
		'inner join preregistra on t.afiliado = preregistra.id '+;
		'inner join medpresta on (' + ;
		't.codmed   = medpresta.codmed and ' + ;
		't.codprest = medpresta.codprest and ' + ;
		't.diasem	= medpresta.diasem and ' + ;
		't.fechatur >= medpresta.fecvigend and ' + ;
		't.fechatur <  medpresta.fecvigenh and ' + ;
		'medpresta.fecvigenh <> medpresta.fecvigend and ' + ;
		't.hhmmtur >= medpresta.hhmmDes and ' + ;
		't.hhmmtur < medpresta.hhmmHas )' + ;
		" where t.codreserva<>'' and " + ;
		'(t.tipoturno < 9 or t.tipoturno >= 13) and ' +mccpoamb  +	mbusco1 , 'mwkphorario5')
		If mret < 0
			Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
			Do prg_cancelo
		Endif
	Endif
Endif
If Used('mwkphorario5')
	If Reccount("mwkphorario5") > 0
		Select * From mwkphorario4 ;
		union All ;
		select * From mwkphorario5 ;
		into Cursor mwkphorario_a
	Else
		Select * From mwkphorario4 ;
		into Cursor mwkphorario_a
	Endif
Else
	Select * From mwkphorario4 ;
	into Cursor mwkphorario_a
Endif

Select mwkphorario_a.*,nombre,pre_descriprest, ent_descrient, ;
ent_turnoshabilit, ent_fecpas,pre_tipomuestra,PRE_Lateralidad ,PRE_tipozona  ;
from mwkphorario_a ;
left Join mwkpent On codent = ent_codent ;
left Join mwkpesp On codesp = esp_codesp ;
left Join mwkpmed On codmed = mwkpmed.Id ;
left Join mwkppres On codprest = pre_codprest ;
order By fechatur, codmed, horatur Into Cursor mwkphorario

msql = "select fechatur, left(ttoc(horatur,2), 5) as hora, nombre, pre_descriprest, codreserva, REG_nrohclinica, " + ;
"left(sala, 2) + ' ' + substr(sala,3,4) + ' ' + substr(sala,7,2) as sala1 , " + ;
"REG_telefonos, usuario, fechatomado,alltrim(iif(isnull(fechaobserva),'                   ',Ttoc(fechaobserva)))+observa as observa,"+;
" id, diasem, ENT_descrient, confirmado, REG_nombrepac, afiliado,tipotomado,fechagenera,  " + ;
"horatur, codserv, codprest, codmed, codent, tipoturno, codesp, codmedsoli, solicigia, preacre, REG_numdocumento, " + ;
"AFI_fechabaja, ENT_turnoshabilit, ENT_fecpas, AFI_nroafiliado, nrovale, sala,CodAmbito " + ;
"from mwkphorario order by fechatur, codmed, horatur,pre_tipomuestra,PRE_Lateralidad ,PRE_tipozona  "+mccentro +;
" into cursor mwkphorarios"


If Used('mwkphorario4')
	Select mwkphorario4
	Use
Endif
If Used('mwkphorario5')
	Select mwkphorario5
	Use
Endif
