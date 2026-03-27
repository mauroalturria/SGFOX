***
*** Generacion de planilla de Turnos Generados por Medico
***

parameters mcodmed, mfecdes, mfechas,mbusca,mnoagrupa,lsinres
if type ('mbusca')#"C"
	mbusca = ''
endif
if vartype(lsinres)<>"N"
	lsinres =0
endif
mccpoamb = ''
mccpoambt =''
mccpoambbf = ''
if mxambito >1
	mccpoambbf = ' where codambito = ?mxambito '
	mccpoambt = "  and turnos.codambito = ?mxambito  "
	mccpoamb = "  and turnos.codambito = ?mxambito and medpresta.codambito = ?mxambito "
endif
cgroup = 'turnos.'+ iif(mnoagrupa,'id','afiliado')
cgroupf = ' ,'+ iif(mnoagrupa,'id','afiliado')
mret = SQLExec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	' '+mccpoambbf+' order by fechacierre ','mwkctrlfecha')

if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_busco_turno_generados1'
	cancel
endif

go bottom in mwkctrlfecha
mfechalimite = mwkctrlfecha.fechacierre
use in mwkctrlfecha
fechatop=ctod('01/01/1900')
if lsinres =0 &&& opcion anterior
	mret = SQLExec(mcon1, 'select turnos.id, fechatur, horatur, codreserva, pre_descriprest, ' + ;
		'turnos.diasem, abreviatura, fecvigenh, turnos.codmed ,sala, turnos.tipoturno, hhmmTur,  ' + ;
		'medpresta.reservados,canturnos, turnos.Observa ,turnos.afiliado,turnos.fechagenera,turnos.usuariogenera ' + ;
		'from  turnos,medpresta left outer join prestacions on ' + ;
		'turnos.codprest = prestacions.pre_codprest ' + ;
		'left outer join tabtipoturno on turnos.tipoturno = tabtipoturno.tipoturno ' + ;
		'where turnos.codmed = ?mcodmed and turnos.tipoturno <> 9 and ' + ;
		'turnos.codmed = medpresta.codmed and ' + ;
		'turnos.diasem = medpresta.diasem and ' + ;
		'turnos.fechatur >= medpresta.fecvigend and ' + ;
		'hhmmtur >= hhmmdes and hhmmtur< hhmmhas and ' + ;
		'turnos.fechatur <  medpresta.fecvigenh and ' + ;
		'fechatur >= ?mfecdes and fechatur <= ?mfechas ' +mccpoamb   + mbusca +;
		'group by fechatur, horatur, ' + cgroup+ ;
		'', 'mwkphorarioa')

else
	mret = SQLExec(mcon1, 'select turnos.id, fechatur, horatur, codreserva, pre_descriprest, ' + ;
		"turnos.diasem, abreviatura,  turnos.codmed ,'' AS sala, turnos.tipoturno, hhmmTur,  " + ;
		'0 as reservados,1 as canturnos, turnos.Observa ,turnos.afiliado,turnos.fechagenera,turnos.usuariogenera ' + ;
		'from  turnos left outer join prestacions on ' + ;
		'turnos.codprest = prestacions.pre_codprest ' + ;
		'left outer join tabtipoturno on turnos.tipoturno = tabtipoturno.tipoturno ' + ;
		'where turnos.codmed = ?mcodmed and turnos.tipoturno <> 9 and ' + ;
		'fechatur >= ?mfecdes and fechatur <= ?mfechas ' +mccpoambt  + mbusca +;
		'group by fechatur, horatur, ' + cgroup+ ;
		'', 'mwkphorarioa')
endif

if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_busco_turno_generados2'
	cancel
endif
if mfecdes <= mfechalimite
	if lsinres =0
		mret = SQLExec(mcon1, 'select turnos.id, fechatur, horatur, codreserva, pre_descriprest, ' + ;
			'turnos.diasem, abreviatura, fecvigenh, turnos.codmed ,sala, turnos.tipoturno, hhmmTur,  ' + ;
			'medpresta.reservados,canturnos, turnos.Observa ,turnos.afiliado,turnos.fechagenera,turnos.usuariogenera ' + ;
			'from turnoshis as turnos, medpresta left outer join prestacions on ' + ;
			'turnos.codprest = prestacions.pre_codprest ' + ;
			'left outer join tabtipoturno on turnos.tipoturno = tabtipoturno.tipoturno ' + ;
			'where turnos.codmed = ?mcodmed and (turnos.tipoturno < 9 or turnos.tipoturno >= 13) and ' + ;
			'turnos.codmed = medpresta.codmed and ' + ;
			'turnos.diasem = medpresta.diasem and ' + ;
			'turnos.fechatur >= medpresta.fecvigend and ' + ;
			'hhmmtur >= hhmmdes and hhmmtur< hhmmhas and ' + ;
			'turnos.fechatur <  medpresta.fecvigenh and ' + ;
			'fechatur >= ?mfecdes and fechatur <= ?mfechas ' +mccpoamb + mbusca +;
			'group by fechatur, horatur, ' + cgroup+ ;
			'', 'mwkphorariob')
	else
		mret = SQLExec(mcon1, 'select turnos.id, fechatur, horatur, codreserva, pre_descriprest, ' + ;
			"turnos.diasem, abreviatura, turnos.codmed ,'' AS sala, turnos.tipoturno, hhmmTur,  " + ;
			'0 as reservados,1 as canturnos, turnos.Observa ,turnos.afiliado,turnos.fechagenera,turnos.usuariogenera ' + ;
			'from turnoshis as turnos left outer join prestacions on ' + ;
			'turnos.codprest = prestacions.pre_codprest ' + ;
			'left outer join tabtipoturno on turnos.tipoturno = tabtipoturno.tipoturno ' + ;
			'where turnos.codmed = ?mcodmed and (turnos.tipoturno < 9 or turnos.tipoturno >= 13) and ' + ;
			'fechatur >= ?mfecdes and fechatur <= ?mfechas ' +mccpoambt  + mbusca +;
			'group by fechatur, horatur, ' + cgroup+ ;
			'', 'mwkphorariob')

	endif
	if mret < 0
		=aerr(eros)
		do prg_error with eros,'sp_busco_turno_generados3'
		cancel
	else
		if reccount('mwkphorariob')>0
			select * from mwkphorarioa  ;
				union all ;
				select * from mwkphorariob ;
				into cursor mwkphorarios
		else
			select * from mwkphorarioa ;
				into cursor mwkphorarios
		endif
	endif
else
	select * from mwkphorarioa ;
		into cursor mwkphorarios
ENDIF
if lsinres =0
	select * from mwkphorarios where nvl(canturnos,1) = 1 group by fechatur, horatur,codreserva;
		union all;
		select * from mwkphorarios where nvl(canturnos,1) > 1 and empty(nvl(codreserva,''))  group by fechatur, horatur,id;
		union all;
		select * from mwkphorarios where nvl(canturnos,1) > 1 and !empty(nvl(codreserva,''))  group by fechatur, horatur,codreserva;
		into cursor mwkphorario
else

	select * from mwkphorarios where empty(nvl(codreserva,''))  group by fechatur, horatur &cgroupf ;
		union all;
		select * from mwkphorarios where !empty(nvl(codreserva,''))  group by fechatur, horatur,codreserva ;
		into cursor mwkphorario
endif
if !eof('mwkphorario')
	msql = "select iif(diasem = 2, 'Lun', iif(diasem = 3, 'Mar', " + ;
		"iif(diasem = 4, 'Mie', iif(diasem = 5, 'Jue', " + ;
		"iif(diasem = 6, 'Vie', iif(diasem = 7, 'Sab', 'Dom')))))) as dia, " + ;
		"fechatur, left(ttoc(horatur,2), 5) as hora, " + ;
		"iif(isnull(codreserva), '          ', codreserva ) as codreserva , " + ;
		"iif(isnull(pre_descriprest), '                      ', pre_descriprest) as Presta, "+ ;
		"abreviatura, sala, " + ;
		"iif(nvl(reservados,0) = 0,' ','X') as reservados, " + ;
		"codmed, tipoturno, hhmmTur, Observa,iif(afiliado=1,'B',' ') as bloqueo  " + ;
		" from mwkphorario "+;
		"order by fechatur, horatur into cursor mwkphorarios "
endif

