***
*** Generacion de planilla de Turnos
***
parameters mbusco1,mfecha,tbCodAmb

mccpoamb = ''
mccpoambbf = ''
if mxambito >1
	mccpoambbf = ' codambito = ?mxambito and '
	mccpoamb = "  medpresta.codambito = ?mxambito  and "
endif
if type('mfecha')#"D"
	mfecha = ctod("01/01/1900")
endif
mret = SQLExec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	'  where &mccpoambbf id<100000 order by fechacierre ','mwkctrlfecha')
go bottom in mwkctrlfecha
mfechalimite = mwkctrlfecha.fechacierre
use in mwkctrlfecha
lhist=(mfecha <= mfechalimite)

mccpoambtm = ''
if mxambito >1
	mccpoambtm = "  and turnos.codambito = ?mxambito and medpresta.codambito = ?mxambito "
endif


mok = .t.
** busco en turnos
mret = SQLExec(mcon1, 'select turnos.*, prestadores.nombre, ' +  iif(tbCodAmb, "turnos.CodAmbito, ", "cast( " + transform(mxambito) + " as Int) as CodAmbito, " )+ ;
	'registracio.REG_nrohclinica, registracio.REG_numdocumento, ' + ;
	'registracio.REG_nombrepac, prestacions.pre_descriprest, entidades.ENT_descrient, ' + ;
	'registracio.REG_telefonos, medpresta.sala, 0 as preacre, ' + ;
	'ENT_turnoshabilit, ENT_fecpas, turnos.tipotomado  ' + ;
	'from registracio,turnos  '+;
	' left join entidades on turnos.codent	= entidades.ENT_codent ' + ;
	' left join prestadores on turnos.codmed = prestadores.id ' + ;
	' left join prestacions  on turnos.codprest = prestacions.pre_codprest ' + ;
	' left outer join medpresta on turnos.codmed	= medpresta.codmed ' + ;
	' and turnos.codprest = medpresta.codprest ' + ;
	" where  turnos.codreserva<>'' and " + ;
	'turnos.afiliado = registracio.REG_nroregistrac and ' + ;
	'(turnos.tipoturno < 9 or turnos.tipoturno >= 13) and ' +mccpoamb + ;
	mbusco1  , 'mwkphorariom')

if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	mok = .f.
	do prg_cancelo
endif

if reccount('mwkphorariom')>0
	mreg = mwkphorariom.afiliado
	do sp_busco_entidad_afiliado1 with mreg
	select mwkphorariom.*,AFI_nroafiliado, AFI_fechabaja,afi_codentidad, mwkafient.ENT_descrient as entiafi;
		from mwkphorariom, mwkafient into cursor mwkphorario
	msql = "select fechatur, left(ttoc(horatur,2), 5) as hora, IIF(AFI_codentidad#codent,'CONTROLE ENTIDAD',nombre) as nombre, "+;
		"pre_descriprest, codreserva, REG_nrohclinica, " + ;
		"left(sala, 2) + ' ' + substr(sala,3,4) + ' ' + substr(sala,7,2) as sala1 , " + ;
		"REG_telefonos, usuario, fechatomado, observa, id, diasem, ENT_descrient, confirmado, REG_nombrepac, afiliado, " + ;
		"horatur, codserv, codprest, codmed, codent, tipoturno, codesp, codmedsoli, solicigia, preacre, REG_numdocumento, " + ;
		"AFI_fechabaja, ENT_turnoshabilit, ENT_fecpas, AFI_nroafiliado, nrovale, sala, tipotomado,CodAmbito " + ;
		"from mwkphorario  group by fechatur, codmed, horatur order by fechatur, codmed, horatur,turnos.codprest into cursor mwkphorarios"
	&msql
endif
if used('mwkphorariom')
	select mwkphorariom
	use
endif
