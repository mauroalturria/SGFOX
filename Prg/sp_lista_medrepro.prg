***
*** Generacion de planilla de Reprogramaciones
***
parameter mfecdes, mfechas, mbusco, mbuscom, mlista
if used('dias')
	use in dias
endif
*parameter mfecdes,mfecrep
mfecd = prg_dtoc(mfecdes)
mfech = prg_dtoc(mfechas)

if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''
endif
	use in select("mwkespecag")
	mret = sqlexec(mcon1,"select TE_codambito, TE_codesp,TE_codespag"+;
				" from Tabespecialid where TE_codambito = ?mxambito ", "mwkespecag")

mret = sqlexec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	'  where &mccpoamb id<100000 order by fechacierre ','mwkctrlfecha')
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_med_repro1'
	cancel
endif
go bottom in mwkctrlfecha
mfechalimite = mwkctrlfecha.fechacierre
use in mwkctrlfecha
mret = sqlexec(mcon1,"SELECT id, nombre FROM prestadores " , "mwkMed" )
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_med_repro2'
	cancel
endif
mret =	sqlexec(mcon1, "select ESP_codesp, ESP_descripcion "+ ;
	"from prestacions , especialid " + ;
	" where trim(pre_especialidad) = trim(ESP_codesp) and PRE_agendaturnos='S' " , "mwkpres")

if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_med_repro3'
	cancel
endif

mret = sqlexec(mcon1, "select fechatur, turnos.codesp,nombre,observa ,fechaobserva,turnos.codmed,"+;
	" afiliado " + ;
	" from turnos , prestadores  " + ;
	" where &mccpoamb turnos.codmed = prestadores.id and " + ;
	' turnos.fechaobserva>= ?mfecd and ' + ;
	" observa like 'REPR.%' " + mbusco + ;
	" group by turnos.codmed, turnos.fechatur, afiliado, turnos.codreserva " + ;
	"", "mwkturnorepro01")

if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_med_repro4'
	cancel
endif
if mfecdes <= mfechalimite
	mret = sqlexec(mcon1, "select fechatur, turnos.codesp,nombre,observa ,fechaobserva,turnos.codmed, " + ;
		" afiliado " + ;
		" from turnoshis as turnos , prestadores  " + ;
		" where &mccpoamb turnos.codmed = prestadores.id and " + ;
		' turnos.fechaobserva>= ?mfecd and ' + ;
		" (Observa like 'REPR.%' OR observa like 'REPOM%' ) " + mbusco + ;
		" group by turnos.codmed, turnos.fechatur, afiliado, turnos.codreserva " + ;
		"", "mwkturnorepro02")
*turnos.fechatur >= ?mfecdes  and
	if mret < 0
		=aerr(eros)
		do prg_error with eros,'sp_lista_med_repro5'
		cancel
	endif

	if reccount('mwkturnorepro01')>0
		select *,ctod(substr(observa,6,5)+"/"+transf(year(fechaobserva))) as fecdes from mwkturnorepro01 where fechaobserva< mfechas +1 ;
			union all ;
			select *,ctod(substr(observa,6,5)+"/"+transf(year(fechaobserva))) as fecdes from mwkturnorepro02 where fechaobserva< mfechas +1 ;
			into cursor mwkturnorepro1
	else
		select *,ctod(substr(observa,6,5)+"/"+transf(year(fechaobserva))) as fecdes from mwkturnorepro02 where fechaobserva< mfechas +1 ;
			into cursor mwkturnorepro1
	endif
else
	select *,ctod(substr(observa,6,5)+"/"+transf(year(fechaobserva))) as fecdes from mwkturnorepro01 where fechaobserva< mfechas +1 ;
		into cursor mwkturnorepro1
endif

mret = sqlexec(mcon1, "select fechatur, turnos.codesp,nombre,observa , feccancela,turnos.codmed,afiliado  "  + ;
	" from turnoscancel as turnos , prestadores " + ;
	" where &mccpoamb turnos.codmed = prestadores.id and " + ;
	' turnos.fechatur >= ?mfecd and ' + ;
	" codcancela = 5 " + mbusco + ;
	" group by turnos.codmed, turnos.fechatur, afiliado, turnos.codreserva " + ;
	"", "mwkturnorepro2")
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_med_repro6'
	cancel
endif


select ttod(fechaobserva) as fecharep,'RP' as ctipo,fechatur, codesp, nombre as nombrea,codmed ;
	,left(observa,100) as observa,buscamed(left(observa,100),codmed ) as codmedr,afiliado;
	,fecdes- ttod(fechaobserva) as dias;
	from mwkturnorepro1 ;
	where at("->",observa)>0;
	order by fecharep  into cursor mwkturnorepr11a

select ttod(feccancela) as fecharep,'CM' as ctipo,fechatur, codesp, nombre as nombrea,codmed ;
	,left(observa,100) as observa,codmed as codmedr,afiliado ;
	,fechatur - ttod(feccancela)  as dias;
	from mwkturnorepro2 where feccancela >= mfecdes and  feccancela < mfechas+1 &mbuscom ;
	order by fecharep  into cursor mwkturnorepr22
*!*	select * from mwkturnorepr11n ;
*!*		union all
select * where 1 = 1 &mbuscom from mwkturnorepr11a ;
	union all ;
	select * from mwkturnorepr22  ;
	into cursor mwkturnorepr

select * from mwkturnorepr,mwkMed, mwkpres;
	where id=codmedr and codesp=trim(esp_codesp);
	group by codesp,codmedr,ctipo,fechatur,codmed,afiliado;
	order by codesp,nombre into cursor mwkrep

select * ,count(afiliado) as totur from mwkrep;
	group by codesp,codmedr,ctipo,fechatur,codmed;
	order by codesp,nombre into cursor mwklista

if used ('mwkturnorepro1')
	use in mwkturnorepro1
endif
if used ('mwkturnorepro2')
	use in mwkturnorepro2
endif
if used ('mwkturnorepro01')
	use in mwkturnorepro01
endif
if used ('mwkturnorepro02')
	use in mwkturnorepro02
endif
if used ('mwkturnorepr11')
	use in mwkturnorepr11
endif
if used ('mwkturnorepr22')
	use in mwkturnorepr22
endif
if used('mwkrep')
	use in mwkrep
endif
if used('mwkturnorepr11a')
	use in mwkturnorepr11a
endif
if used('mwkturnorepr22')
	use in mwkturnorepr22
endif

if used ('mwkMed')
	use in mwkMed
endif
if used ('mwkturnorepr')
	use in mwkturnorepr
endif
function buscamed(mobs,cm )
	local mposi,mposf
	mposf = at("|",mobs)
	mposi = at("00(",mobs)
	mm = iif(mposi > 0 and mposi< mposf , val(substr(mobs,mposi+3,4)),cm)
	return mm
endfunc

