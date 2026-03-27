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
mfect = mfecdes - 12 * 7 && 12 semanas de anticipacion
mret = sqlexec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	'  where id<100000 order by fechacierre ','mwkctrlfecha')
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_med_repro1'
	cancel
endif
Do sp_busco_estados With 102, "", "mwkmotivo"

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
	" where trim(pre_especialidad) = trim(esp_codesp) and pre_agendaturnos='S' " , "mwkpres")

if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_med_repro3'
	cancel
endif

mret = sqlexec(mcon1,"select nombre ,cantidadpac,codmed,codmedrepro,motivo,fecharep,fechaturant,"+;
	" fechaturnva, turnosreprog.id as idreprog "+;
	" from turnosreprog , prestadores  " + ;
	" where turnosreprog.codmed = prestadores.id and " + ;
	' turnosreprog.fecharep>= ?mfecd ' + ;
	"", "mwkturnorepro01")
if mret < 0
	=aerr(eros)
	cancel
endif
mret = sqlexec(mcon1, " Select codMed,CodEsp from medpresta where fecVigenH > ?mfect " ,"mwkMedPresta")

if mret < 0
	=aerr(eros)
	cancel
endif
mbuscocur = iif(empty(mbusco),'', " and codesp = '" + mcodesp + "'")
select mwkturnorepro01.nombre as nombre,cantidadpac,mwkturnorepro01.codmed,codmedrepro,motivo,fecharep,fechaturant,fechaturnva,codesp ;
	from mwkturnorepro01 left join mwkmedpresta on mwkmedpresta.codmed = mwkturnorepro01.codmed ;
	where fecharep < mfechas +1 &mbuscocur   group by idreprog  ;
	into cursor mwkturnorepro1

*si esta entre desde y el hasta, lo mismo en cancelacion masiva
mret = sqlexec(mcon1, "select fechatur, turnos.codesp,nombre, feccancela,turnos.codmed,afiliado  "  + ;
	" from turnoscancel as turnos , prestadores " + ;
	" where turnos.codmed = prestadores.id and " + ;
	' turnos.feccancela >= ?mfecd and ' + ;
	" codcancela = 5 " + mbusco + ;
	" group by turnos.codmed, turnos.fechatur, afiliado, turnos.codreserva " + ;
	"", "mwkturnorepro2")

*mayor que hoy fecha de turno,buscar fecha de cancelacion en mi maquina
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_med_repro6'
	cancel
endif


select ttod(fecharep) as fecharep,iif(codmedrepro = 0,'CH',iif(codmedrepro = 2,'CT',;
	iif(codmedrepro = 29,'CA','RP'))) as ctipo,fechaturnva as fechatur, codesp, ;
	nombre as nombrea,codmed , codmedrepro as codmedr ;
	,fechaturant- ttod(fecharep) as dias,cantidadpac as totur,mwkmotivo.descrip,mwkmotivo.tipo;
	from mwkturnorepro1 left join mwkmotivo on motivo = mwkmotivo.id;
	order by fecharep  into cursor mwkturnorepr11a

select ttod(feccancela) as fecharep,'CM' as ctipo,fechatur, codesp, nombre as nombrea,codmed ;
	,codmed as codmedr,afiliado ;
	,fechatur - ttod(feccancela)  as dias     ;
	from mwkturnorepro2  where feccancela < mfechas+1 &mbuscom ;
	order by fecharep  into cursor mwkturnorepr022

select fecharep,ctipo ,fechatur, codesp, nombrea,codmed,codmedr,;
	dias,count(afiliado)as totur from mwkturnorepr022 ;
	group by codesp,codmedr,ctipo,fechatur,codmed ;
	order by codesp,nombrea into cursor mwkturnorepr22

select * where 1 = 1 &mbuscom from mwkturnorepr11a ;
	union all ;
	select *,space(50) as descrip,171 as tipo  from mwkturnorepr22  ;
	into cursor mwkturnorepr
	
*!*	select * from mwkturnorepr,mwkMed, mwkpres ;
*!*		where id = codmedr and codesp=trim(esp_codesp) ;
*!*		group by codesp,codmedr,ctipo,fechatur,codmed ;
*!*		order by codesp,nombre into cursor mwklista
select * from mwkturnorepr ;
	left join mwkmed on id = codmedr left join mwkpres  on codesp=trim(esp_codesp) ;
	group by codesp,codmedr,ctipo,tipo,fechatur,codmed ;
	order by codesp,nombrea,fecharep,ctipo into cursor mwklista

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
	use in mwkmed
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

