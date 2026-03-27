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
mret = sqlexec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	'  where id<100000 order by fechacierre ','mwkctrlfecha')
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_med_repro1'
	cancel
endif
go bottom in mwkctrlfecha
mfechalimite = mwkctrlfecha.fechacierre
use in mwkctrlfecha
mret = SQLExec(mcon1,"SELECT id, nombre FROM prestadores " , "mwkMed" )
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
ENDIF
 
	mret = sqlexec(mcon1,"select nombre ,cantidadpac,codmed,codmedrepro,fecharep,fechaturant,fechaturnva,"+;
 	 " TurnosReprog.id as idReprog "+;
 	 " from TurnosReprog , prestadores  " + ;
	 " where TurnosReprog.codmed = prestadores.id and " + ;
	 ' TurnosReprog.fechaRep>= ?mfecd ' + ;
	 "", "mwkturnorepro01")
	if mret < 0
		=aerr(eros)
		cancel
	ENDIF
	mret = sqlexec(mcon1, " Select codMed,CodEsp from medpresta where fecVigenH > ?mfecd " ,"mwkMedPresta")

	if mret < 0
		=aerr(eros)
		cancel
	ENDIF
select mwkturnorepro01.nombre as nombre,cantidadpac,mwkturnorepro01.codmed,codmedrepro,fecharep,fechaturant,fechaturnva,codesp ;
   from mwkturnorepro01 LEFT JOIN mwkMedPresta ON mwkMedPresta.codmed = mwkturnorepro01.codMed ;
   where fecharep < mfechas +1  GROUP BY idReprog  ;
   into cursor mwkturnorepro1

*si esta entre desde y el hasta, lo mismo en cancelacion masiva
mret = sqlexec(mcon1, "select fechatur, turnos.codesp,nombre, feccancela,turnos.codmed,afiliado  "  + ;
	" from turnoscancel as turnos , prestadores " + ;
	" where turnos.codmed = prestadores.id and " + ;
	' turnos.feccancela >= ?mfecd and ' + ;
	" observa like 'CANC.MASIVA%' " + mbusco + ;
	" group by turnos.codmed, turnos.fechatur, afiliado, turnos.codreserva " + ;
	"", "mwkturnorepro2")
	
*mayor que hoy fecha de turno,buscar fecha de cancelacion en mi maquina
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_med_repro6'
	cancel
endif


select ttod(fecharep) as fecharep,'RP' as ctipo,fechaturNva as fechatur, codesp, nombre as nombrea,codmed ;
	, CODMEDREPRO as codmedr ;
	,fechaturant- ttod(fecharep) as dias,cantidadpac as totur  ;
	from mwkturnorepro1 ;
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
	select * from mwkturnorepr22  ;
	into cursor mwkturnorepr 

*!*	select * from mwkturnorepr,mwkMed, mwkpres ;
*!*		where id = codmedr and codesp=trim(esp_codesp) ;
*!*		group by codesp,codmedr,ctipo,fechatur,codmed ;
*!*		order by codesp,nombre into cursor mwklista
select * from mwkturnorepr ;
	Left join mwkMed on id = codmedr Left join mwkpres  on codesp=trim(esp_codesp) ;
	group by codesp,codmedr,ctipo,fechatur,codmed ;
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
FUNCTION buscamed(mobs,cm )
	local mposi,mposf
	mposf = at("|",mobs)
	mposi = at("00(",mobs)
	mm = iif(mposi > 0 and mposi< mposf , val(substr(mobs,mposi+3,4)),cm)
	RETURN mm
ENDFUNC

