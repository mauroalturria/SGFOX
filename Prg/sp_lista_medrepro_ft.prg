***
*** Generacion de planilla de Reprogramaciones
***
parameter mfecdes, mfechas, mbusco, mbuscom
*parameter mfecdes,mfecrep

if used('dias')
	use in dias
endif

mfecd = prg_dtoc(mfecdes)
mfech = prg_dtoc(mfechas)
mfect = mfecdes - 12 * 7 && 12 semanas de anticipacion
mfeclimite = ctod("05/01/2012")
lturnoscancel = (mfect < mfeclimite)
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''	
endif

mret  = sqlexec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	'  where &mccpoamb id<100000 order by fechacierre ','mwkctrlfecha')

if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_med_repro1'
	cancel
endif

do sp_busco_estados with 102, "", "mwkmotivo"

go bottom in mwkctrlfecha
mfechalimite = mwkctrlfecha.fechacierre
use in mwkctrlfecha

mret = sqlexec(mcon1,"SELECT id, nombre FROM prestadores " , "mwkMed" )
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_med_repro2'
	cancel
endif
	use in select("mwkespecag")
	mret = sqlexec(mcon1,"select TE_codambito, TE_codesp,TE_codespag"+;
				" from Tabespecialid where TE_codambito = ?mxambito ", "mwkespecag")

mret =	sqlexec(mcon1, "select ESP_codesp, ESP_descripcion "+ ;
	"from prestacions , especialid " + ;
	" where trim(pre_especialidad) = trim(esp_codesp) and pre_agendaturnos='S' " , "mwkpres")
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_med_repro3'
endif

** Agregado 09/03/2012
select * from mwkpres group by esp_codesp into cursor mwkpres


mret = sqlexec(mcon1,"select nombre ,cantidadpac,codmed,codmedrepro,motivo,fecharep,fechaturant,"+;
	" fechaturnva, turnosreprog.id as idreprog,paccancel,turnosreprog.usuario "+;
	" from turnosreprog , prestadores  " + ;
	" where &mccpoamb turnosreprog.codmed = prestadores.id and " + ;
	' turnosreprog.fechaturant>= ?mfecdes', "mwkturnorepro01")

if mret < 0
	messagebox("EN CONSULTA DE TURNOS",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

mret = sqlexec(mcon1, " Select codMed,CodEsp from medpresta where &mccpoamb fecVigenH > ?mfect " ,"mwkMedPresta")

if mret < 0
	messagebox("EN CONSULTA PRESTACIONES DE PROFESIONALES",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

select * from mwkMedPresta group by codmed into cursor mwkMedPresta

mbuscocur = iif(empty(mbusco),'', " and codesp = '" + mcodesp + "'")

select mwkturnorepro01.nombre as nombre,cantidadpac,mwkturnorepro01.codmed,codmedrepro,;
	motivo,fecharep,fechaturant,fechaturnva,codesp,paccancel ;
	from mwkturnorepro01 ;
	join mwkMedPresta on mwkMedPresta.codmed = mwkturnorepro01.codmed ;
	where fechaturant <= mfechas  &mbuscocur ;
	group by cantidadpac, mwkturnorepro01.codmed,codmedrepro, fecharep,fechaturant, fechaturnva,motivo, ;
	paccancel,mwkturnorepro01.usuario ;
	into cursor mwkturnorepro1

select ttod(fecharep) as fecharepro,iif(codmedrepro = 0,'CH',iif(codmedrepro = 2,'CT',;
	iif(codmedrepro = 29,'CA',iif(paccancel = 0,'RM','RP')))) as ctipo,fechaturant,fechaturnva as fechatur, codesp, ;
	nombre as nombrea,codmed , codmedrepro as codmedr ;
	,fechaturant- ttod(fecharep) as dias,fecharep,cantidadpac as totur,mwkmotivo.descrip,mwkmotivo.tipo;
	,paccancel;
	from mwkturnorepro1 left join mwkmotivo on motivo = mwkmotivo.id;
	order by fecharep  into cursor mwkturnorepr11a

if lturnoscancel
mret = sqlexec(mcon1, "select fechatur, turnos.codesp,nombre, feccancela,turnos.codmed,afiliado  "  + ;
		" from turnoscancel as turnos , prestadores " + ;
		" where &mccpoamb turnos.codmed = prestadores.id and " + ;
		' turnos.fechatur>=?mfecdes and turnos.fechatur<= ?mfechas  and  ' + ;
		" codcancela = 5 " + mbusco + ;
		" group by turnos.codmed, turnos.fechatur, afiliado, turnos.codreserva " + ;
		"", "mwkturnorepro2")
		
* mayor que hoy fecha de turno,buscar fecha de cancelacion en mi maquina
	if mret < 0
		=aerr(eros)
		do prg_error with eros,'sp_lista_med_repro6'
	endif
	select ttod(feccancela) as fecharepro,'CM' as ctipo,fechatur, codesp, nombre as nombrea,codmed ;
		,codmed as codmedr,afiliado ;
		,fechatur - ttod(feccancela)  as dias,feccancela as fecharep;
		from mwkturnorepro2  where fechatur <= mfechas &mbuscom ;
		into cursor mwkturnorepr022

	select fecharepro,ctipo ,fechatur, codesp, nombrea,codmed,codmedr,;
		dias,fecharep,count(afiliado)as totur from mwkturnorepr022 ;
		group by codmed,fecharep  ;
		into cursor mwkturnorepr22

&& Agregado CM y Anulación AM // XX
endif
mbuscom = strtran(mbuscom,'codmed','mwkturnorepr11a.codmed')
if lturnoscancel
	if reccount('mwkturnorepr22')>0 
		select mwkturnorepr11a.*, mwkturnorepr22.totur as cmpac where 1= 1  &mbuscom from mwkturnorepr11a ;
			left join mwkturnorepr22 on (mwkturnorepr11a.codmed = mwkturnorepr22.codmed and ;
			mwkturnorepr11a.fechatur = mwkturnorepr22.fechatur and ;
			mwkturnorepr11a.fecharep = mwkturnorepr22.fecharep );
			into cursor mwkturnorepr

	else
		select *,0 as cmpac where 1 = 1 &mbuscom from mwkturnorepr11a ;
			into cursor mwkturnorepr
	endif
else
	select *,0 as cmpac where 1 = 1 &mbuscom from mwkturnorepr11a ;
		into cursor mwkturnorepr
endif	

select * from mwkturnorepr ;
	left join mwkmed on id = codmedr left join mwkpres  on codesp=trim(esp_codesp) ;
	order by nombrea,fecharep,fechatur,ctipo into cursor mwklista   &&codesp,
*	group by fecharep,codmedr,ctipo,tipo,fechatur,codmed 


use in select('mwkturnorepro1')
use in select('mwkturnorepro2')
use in select('mwkturnorepro01')
use in select('mwkturnorepro02')
use in select('mwkturnorepr11')
use in select('mwkturnorepr22')
use in select('mwkrep')
use in select('mwkturnorepr11a')
use in select('mwkturnorepr22')
use in select('mwkMed')
use in select('mwkturnorepr')

