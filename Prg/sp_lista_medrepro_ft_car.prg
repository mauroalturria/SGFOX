***
*** Generacion de planilla de Reprogramaciones
***
Parameter mfecdes, mfechas, mbusco, mbuscom
aaaaaaa
*parameter mfecdes,mfecrep

If used('dias')
	Use in dias
Endif

mfecd = prg_dtoc(mfecdes)
mfech = prg_dtoc(mfechas)
mfect = mfecdes - 12 * 7 && 12 semanas de anticipacion
mfeclimite = ctod("05/01/2012")
lturnoscancel = (mfect < mfeclimite)

mret  = sqlexec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	'  where id<100000 order by fechacierre ','mwkctrlfecha')

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

mret =	sqlexec(mcon1, "select ESP_codesp, ESP_descripcion "+ ;
	"from prestacions , especialid " + ;
	" where trim(pre_especialidad) = trim(esp_codesp) and pre_agendaturnos='S' " , "mwkpres")
If mret < 0
	=aerr(eros)
	Do prg_error with eros,'sp_lista_med_repro3'
Endif

** Agregado 09/03/2012
Select * from mwkpres group by esp_codesp into cursor mwkpres


mret = sqlexec(mcon1,"select nombre ,cantidadpac,codmed,codmedrepro,motivo,fecharep,fechaturant,"+;
	" fechaturnva, turnosreprog.id as idreprog,paccancel "+;
	" from turnosreprog , prestadores  " + ;
	" where turnosreprog.codmed = prestadores.id and " + ;
	' turnosreprog.fechaturant>= ?mfecdes', "mwkturnorepro01")

If mret < 0
	Messagebox("EN CONSULTA DE TURNOS",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
Endif

mret = sqlexec(mcon1, " Select codMed,CodEsp from medpresta where fecVigenH > ?mfect " ,"mwkMedPresta")

If mret < 0
	Messagebox("EN CONSULTA PRESTACIONES DE PROFESIONALES",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
Endif

** Agregado 09/03/2012
*select * from mwkMedPresta group by codmed,codesp into cursor mwkMedPresta

* 12/03/2012
Select * from mwkMedPresta group by codmed into cursor mwkMedPresta

mbuscocur = iif(empty(mbusco),'', " and codesp = '" + mcodesp + "'")

*!*	Select mwkturnorepro01.nombre as nombre,cantidadpac,mwkturnorepro01.codmed,codmedrepro,;
*!*		motivo,fecharep,fechaturant,fechaturnva,codesp,paccancel ;
*!*		from mwkturnorepro01 ;
*!*		left join mwkmedpresta on mwkmedpresta.codmed = mwkturnorepro01.codmed ;
*!*		where fechaturant <= mfechas  &mbuscocur ;
*!*		group by idreprog  ;
*!*		into cursor mwkturnorepro1

** Modificado 09/03/2012

Select mwkturnorepro01.nombre as nombre,cantidadpac,mwkturnorepro01.codmed,codmedrepro,;
	motivo,fecharep,fechaturant,fechaturnva,codesp,paccancel ;
	from mwkturnorepro01 ;
	join mwkMedPresta on mwkMedPresta.codmed = mwkturnorepro01.codmed ;
	where fechaturant <= mfechas  &mbuscocur ;
	group by idreprog  ;
	into cursor mwkturnorepro1

* si esta entre desde y el hasta, lo mismo en cancelacion masiva


Select ttod(fecharep) as fecharep,iif(codmedrepro = 0,'CH',iif(codmedrepro = 2,'CT',;
	iif(codmedrepro = 29,'CA','RP'))) as ctipo,fechaturnva as fechatur, codesp, ;
	nombre as nombrea,codmed , codmedrepro as codmedr ;
	,fechaturant- ttod(fecharep) as dias,cantidadpac as totur,mwkmotivo.descrip,mwkmotivo.tipo,paccancel;
	from mwkturnorepro1 left join mwkmotivo on motivo = mwkmotivo.id;
	order by fecharep  into cursor mwkturnorepr11a

if lturnoscancel
	mret = sqlexec(mcon1, "select fechatur, turnos.codesp,nombre, feccancela,turnos.codmed,afiliado  "  + ;
		" from turnoscancel as turnos , prestadores " + ;
		" where turnos.codmed = prestadores.id and " + ;
		' between(turnos.fechatur, ?mfecdes ,mfechas) and  ' + ;
		" codcancela = 5 " + mbusco + ;
		" group by turnos.codmed, turnos.fechatur, afiliado, turnos.codreserva " + ;
		"", "mwkturnorepro2")

	* mayor que hoy fecha de turno,buscar fecha de cancelacion en mi maquina
	If mret < 0
		=aerr(eros)
		Do prg_error with eros,'sp_lista_med_repro6'
	Endif
	Select ttod(feccancela) as fecharep,'CM' as ctipo,fechatur, codesp, nombre as nombrea,codmed ;
		,codmed as codmedr,afiliado ;
		,fechatur - ttod(feccancela)  as dias ;
		from mwkturnorepro2  where fechatur <= mfechas and feccancela < mfeclimite &mbuscom ;
		order by fecharep  into cursor mwkturnorepr022
	endif

&& Agregado CM y Anulación AM // XX
If used("mwkturnorepr022")
	If reccount("mwkturnorepr022")=0

		Use in select("mwkpc1")
		Select * from mwkturnorepr11a where paccancel > 0 and fecharep < mfeclimite  into cursor mwkpc1

		Select fecharep,'CM' as ctipo,fechatur,codesp,nombrea,codmed,codmedr, 1 as afiliado,dias ;
			from mwkpc1 where 1=1 &mbuscom order by fecharep  into cursor mwkturnorepr022ant

		Use in select("mwkpc1")

	Else
		If empty(mbuscom)

			Use in select("mwkpc1")
			Use in select("mwkpc1b")

			Select * from mwkturnorepr11a where paccancel > 0;
				and codmed not in (select codmed from mwkturnorepr022) into cursor mwkpc1

			If used("mwkpc1")
				If reccount("mwkpc1")>0

					Select fecharep,'CM' as ctipo,fechatur, codesp, nombrea, codmed	,codmedr, 1 as afiliado, dias     ;
						from mwkpc1 ;
						order by fecharep  into cursor mwkpc1b

					If used("mwkpc1b")
						If reccount("mwkpc1b")>0

							Select * from mwkturnorepr022;
								union ;
								select * from mwkpc1b;
								into cursor mwkturnorepr022
						Endif
					Endif

				Endif
			Endif
			Use in select("mwkpc1")
			Use in select("mwkpc1b")
		Endif
	Endif
Endif

* 12/03/2012

*!*	Select fecharep,ctipo ,fechatur, codesp, nombrea,codmed,codmedr,;
*!*		dias,count(afiliado)as totur from mwkturnorepr022 ;
*!*		group by codesp,codmedr,ctipo,fechatur,codmed ;
*!*		order by codesp,nombrea into cursor mwkturnorepr22

Select fecharep,ctipo ,fechatur, codesp, nombrea,codmed,codmedr,;
	dias,count(afiliado)as totur from mwkturnorepr022 ;
	group by codmedr,ctipo,fechatur,codmed ;
	order by nombrea into cursor mwkturnorepr22


Select * from mwkturnorepr11a where 1 = 1 &mbuscom ;
	union all ;
	select *,space(50) as descrip,171 as tipo, 0 as paccancel from mwkturnorepr22  ;
	into cursor mwkturnorepr

*!*	*!*	select * from mwkturnorepr,mwkMed, mwkpres ;
*!*	*!*		where id = codmedr and codesp=trim(esp_codesp) ;
*!*	*!*		group by codesp,codmedr,ctipo,fechatur,codmed ;
*!*	*!*		order by codesp,nombre into cursor mwklista

* 12/03/2012

*!*	Select * from mwkturnorepr ;
*!*		left join mwkmed on id = codmedr ;
*!*		join mwkpres on codesp=trim(esp_codesp) ;
*!*		group by codesp,codmedr,ctipo,tipo,fechatur,codmed ;
*!*		order by codesp,nombrea,fecharep,fechatur,ctipo into cursor mwklista


*!*	*****
*!*	Select *,iif(left(ctipo,1)="R",1,iif(ctipo="CM",3,1)) as ctipo2 from mwkturnorepr ;
*!*		left join mwkmed on id = codmedr ;
*!*		join mwkpres on codesp=trim(esp_codesp) ;
*!*		group by codmedr,ctipo,tipo,fechatur,codmed ;
*!*		order by nombrea,fechatur,ctipo into cursor mwklista
*!*	****


Select *,iif(left(ctipo,1)="R",3,iif(ctipo="CM",2,1)) as ctipo2 from mwkturnorepr ;
	left join mwkmed on id = codmedr ;
	join mwkpres on codesp=trim(esp_codesp) ;
	group by codmedr,ctipo,tipo,fechatur,codmed ;
	order by nombrea,fechatur,ctipo into cursor mwklista



*fecharep,
*!* *	order by codesp,nombrea,fecharep,ctipo into cursor mwklista

* 12/03/2012

Select * from mwklista order by nombrea,fecharep,fechatur,ctipo2 into cursor mwklista


Use in select('mwkturnorepro1')
Use in select('mwkturnorepro2')
Use in select('mwkturnorepro01')
Use in select('mwkturnorepro02')
Use in select('mwkturnorepr11')
Use in select('mwkturnorepr22')
Use in select('mwkrep')
Use in select('mwkturnorepr11a')
Use in select('mwkturnorepr22')
Use in select('mwkMed')
Use in select('mwkturnorepr')

Function buscamed(mobs,cm )
Local mposi,mposf
mposf = at("|",mobs)
mposi = at("00(",mobs)
mm = iif(mposi > 0 and mposi< mposf , val(substr(mobs,mposi+3,4)),cm)
Return mm
Endfunc

