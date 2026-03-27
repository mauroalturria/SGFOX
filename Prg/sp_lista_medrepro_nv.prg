***
*** Generacion de planilla de Reprogramaciones
***
Parameter mfecdes, mfechas, mbusco, mbuscom, mlista

If used('dias')
	Use in dias
Endif

mfecd = prg_dtoc(mfecdes)
mfech = prg_dtoc(mfechas)
mfect = mfecdes - 12 * 7 && 12 semanas de anticipacion

if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''	
endif

mfeclimite = ctod("05/01/2012")
lturnoscancel = (mfect < mfeclimite)

mret  = sqlexec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	'  where &mccpoamb id<100000 order by fechacierre ','mwkctrlfecha')

If mret < 0
	=aerr(eros)
	Do prg_error with eros,'sp_lista_med_repro1'
	Cancel
Endif
Do sp_busco_estados With 102, "", "mwkmotivo"

Go bottom in mwkctrlfecha
mfechalimite = mwkctrlfecha.fechacierre
Use in mwkctrlfecha
mret = sqlexec(mcon1,"SELECT id, nombre FROM prestadores " , "mwkMed" )
If mret < 0
	=aerr(eros)
	Do prg_error with eros,'sp_lista_med_repro2'
	Cancel
Endif

	use in select("mwkespecag")
	mret = sqlexec(mcon1,"select TE_codambito, TE_codesp,TE_codespag"+;
				" from Tabespecialid where TE_codambito = ?mxambito ", "mwkespecag")

mret =	sqlexec(mcon1, "select ESP_codesp, ESP_descripcion "+ ;
	"from prestacions , especialid " + ;
	" where trim(pre_especialidad) = trim(esp_codesp) and pre_agendaturnos='S' " , "mwkpres")
If mret < 0
	=aerr(eros)
	Do prg_error with eros,'sp_lista_med_repro3'
	Cancel
Endif

** Agregado 12/03/2012
Select * from mwkpres group by esp_codesp into cursor mwkpres

mret = sqlexec(mcon1,"select nombre ,cantidadpac,codmed,codmedrepro,motivo,fecharep,fechaturant,"+;
	" fechaturnva, turnosreprog.id as idreprog,paccancel"+;
	" from turnosreprog , prestadores  " + ;
	" where &mccpoamb turnosreprog.codmed = prestadores.id and " + ;
	' turnosreprog.fecharep>= ?mfecd ' + ;
	"", "mwkturnorepro01")

If mret < 0
	Messagebox("EN CONSULTA DE TURNOS",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Cancel
Endif

mret = sqlexec(mcon1, " Select codMed,CodEsp from medpresta where &mccpoamb fecVigenH > ?mfect " ,"mwkMedPresta")
If mret < 0
	Messagebox("EN CONSULTA PRESTACIONES DE PROFESIONALES",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Cancel
Endif

* 12/03/2012
Select * from mwkMedPresta group by codmed into cursor mwkMedPresta

mbuscocur = iif(empty(mbusco),'', " and codesp = '" + mcodesp + "'")

Select mwkturnorepro01.nombre as nombre,cantidadpac,mwkturnorepro01.codmed,codmedrepro,motivo,fecharep,fechaturant,fechaturnva,codesp, ;
	mwkturnorepro01.paccancel;
	from mwkturnorepro01 left join mwkMedPresta on mwkMedPresta.codmed = mwkturnorepro01.codmed ;
	where fecharep < mfechas +1 &mbuscocur   group by idreprog  ;
	into cursor mwkturnorepro1

Select ttod(fecharep) as fecharep,iif(codmedrepro = 0,'CH',iif(codmedrepro = 2,'CT',;
	iif(codmedrepro = 29,'CA',iif(paccancel = 0,'RM','RP')))) as ctipo,fechaturant,fechaturnva as fechatur, codesp, ;
	nombre as nombrea,codmed , codmedrepro as codmedr ;
	,fechaturant- ttod(fecharep) as dias,cantidadpac as totur,mwkmotivo.descrip,mwkmotivo.tipo,;
	paccancel;
	from mwkturnorepro1 left join mwkmotivo on motivo = mwkmotivo.id;
	order by fecharep into cursor mwkturnorepr11a

* Si esta entre desde y el hasta, lo mismo en cancelacion masiva
If lturnoscancel

	mret = sqlexec(mcon1, "select fechatur, turnos.codesp,nombre, feccancela,turnos.codmed,afiliado  "  + ;
		" from turnoscancel as turnos , prestadores " + ;
		" where &mccpoamb turnos.codmed = prestadores.id and " + ;
		' turnos.feccancela >= ?mfecd and ' + ;
		" codcancela = 5 " + mbusco + ;
		" group by turnos.codmed, turnos.fechatur, afiliado, turnos.codreserva " + ;
		"", "mwkturnorepro2")

*   Mayor que hoy fecha de turno,buscar fecha de cancelacion en mi maquina

	If mret < 0
		=aerr(eros)
		Do prg_error with eros,'sp_lista_med_repro6'
		Cancel
	Endif

	Select ttod(feccancela) as fecharep,'CM' as ctipo,fechatur, codesp, nombre as nombrea,codmed ;
		,codmed as codmedr,afiliado ;
		,fechatur - ttod(feccancela)  as dias ;
		from mwkturnorepro2  where  fechatur <= mfechas and feccancela < mfeclimite &mbuscom ;
		into cursor mwkturnorepr022

	Select fecharep,ctipo ,fechatur, codesp, nombrea,codmed,codmedr,;
		dias,count(afiliado)as totur from mwkturnorepr022 ;
		group by codmedr,fecharep ;
		into cursor mwkturnorepr22
		*,ctipo,fechatur,codmed

Endif

If lturnoscancel
	If reccount('mwkturnorepr22')>0
		Select mwkturnorepr11a.*, mwkturnorepr22.totur as cmpac where 1= 1  &mbuscom from mwkturnorepr11a ;
			left join mwkturnorepr22 on (mwkturnorepr11a.codmed = mwkturnorepr22.codmed and ;
			mwkturnorepr11a.fechatur = mwkturnorepr22.fechatur and ;
			mwkturnorepr11a.fecharep = mwkturnorepr22.fecharep );
			into cursor mwkturnorepr

	Else
		Select *,0 as cmpac where 1 = 1 &mbuscom from mwkturnorepr11a ;
			into cursor mwkturnorepr
	Endif
Else
	Select *,0 as cmpac where 1 = 1 &mbuscom from mwkturnorepr11a ;
		into cursor mwkturnorepr
Endif


Select * from mwkturnorepr ;
	left join mwkmed on id = codmedr left join mwkpres  on codesp=trim(esp_codesp) ;
	order by nombrea,fecharep,fechatur,ctipo into cursor mwklista

*	codesp,nombrea,fecharep,ctipo into cursor mwklista
*	group by fecharep,codmedr,ctipo,tipo,fechatur,codmed ;


If used ('mwkturnorepro1')
	Use in mwkturnorepro1
Endif
If used ('mwkturnorepro2')
	Use in mwkturnorepro2
Endif
If used ('mwkturnorepro01')
	Use in mwkturnorepro01
Endif
If used ('mwkturnorepro02')
	Use in mwkturnorepro02
Endif
If used ('mwkturnorepr11')
	Use in mwkturnorepr11
Endif
If used ('mwkturnorepr22')
	Use in mwkturnorepr22
Endif
If used('mwkrep')
	Use in mwkrep
Endif
If used('mwkturnorepr11a')
	Use in mwkturnorepr11a
Endif
If used('mwkturnorepr22')
	Use in mwkturnorepr22
Endif
If used ('mwkMed')
	Use in mwkmed
Endif
If used ('mwkturnorepr')
	Use in mwkturnorepr
Endif

Function buscamed(mobs,cm )
	Local mposi,mposf
	mposf = at("|",mobs)
	mposi = at("00(",mobs)
	mm = iif(mposi > 0 and mposi< mposf , val(substr(mobs,mposi+3,4)),cm)
	Return mm
Endfunc
