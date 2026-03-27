****
** Listado estadistico para Morgulis cantidad ocupados, libres
****

parameter mfecdes, mfechas, mbusco1, mlista, mbusco, mbusco2, mbusco3,mbusco2f

if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
	mcjoinvales = " inner join pacientes on valesasist.VAL_codadmision = pacientes.pac_codadmision "
	mbusco2  = mbusco2  + " and pac_codambito=?mxambito " 
else
	mccpoamb = ''
	mcjoinvales = ""
endif
mret = sqlexec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	'  where &mccpoamb id<100000 order by fechacierre ','mwkctrlfecha')
go bottom in mwkctrlfecha
mfechalimite = mwkctrlfecha.fechacierre
use in mwkctrlfecha
	use in select("mwkespecag")
	mret = sqlexec(mcon1,"select TE_codambito, TE_codesp,TE_codespag"+;
				" from Tabespecialid where TE_codambito = ?mxambito ", "mwkespecag")

mret = sqlexec(mcon1, " select codmed, diasem, fecvigend,codesp "+;
	", fecvigenh,  hdesde1, hhasta1, horadesde, horahasta "+;
	", hhmmDes, hhmmHas " +;
	" from medpresta"+;
	" where &mccpoamb diasem > 0 &mbusco1 "+;
	" and fecvigenh > ?mfecdes and fecvigend <= ?mfechas "+;
	" and fecvigenh <> fecvigend "+;
	" group by codmed, codesp, diasem, fecvigenh, hdesde1 ","Mwkmedpre0")
if mret < 0
	=aerr(eros)
	messagebox(eros(2), 16, "Validacion")
	messagebox(eros(3), 16, "Validacion")
endif

select *,100 as porc from Mwkmedpre0 ;
	where transf(codmed)+transf(diasem)+ttoc(hdesde1)  not in (select transf(codmed)+transf(diasem)+ttoc(hdesde1) from Mwkmedpre0 ;
	group by codmed, diasem, fecvigenh, hdesde1 ;
	having count(codesp)>1) order by codmed, diasem, fecvigenh, hdesde1 ;
	into cursor Mwkmedpre1
select * from Mwkmedpre0 ;
	where transf(codmed)+transf(diasem)+ttoc(hdesde1) in (select transf(codmed)+transf(diasem)+ttoc(hdesde1) from Mwkmedpre0 ;
	group by codmed, diasem, fecvigenh, hdesde1 ;
	having count(codesp)>1) order by codmed, diasem, fecvigenh, hdesde1 ;
	into cursor Mwkmedpre2

*!*	select *,iif(codesp= 'GINE',60,iif(codesp= 'OBST',40,;
*!*		iif(codesp= 'OFTA',80,iif(codesp= 'OFTI',20,;
*!*		 from Mwkmedpre2 into cursor Mwkmedpre3
select *,iif(codesp= 'GINE',60.00,iif(codesp= 'OBST',40.00,;
	iif(codesp= 'OFTA',80.00,iif(codesp= 'OFTI',20.00,;
	iif(codesp= 'NEUF',60.00,iif(codesp= 'NFII',40.00,;
	iif(codesp= 'CIVP',80.00,iif(codesp= 'CIRC',20.00,;
	iif(codesp= 'NUTI',50.00,iif(codesp= 'DIAI',50.00,99.99)))))))))) as porc ;
	from Mwkmedpre2 into cursor Mwkmedpre3

select * from Mwkmedpre1 ;
	union select * from Mwkmedpre3 into cursor Mwkmedpre


mret = sqlexec(mcon1, "select turnos.id,afiliado, fechatur, horatur, codmed, nombre,turnos.codesp, " + ;
	"tipoturno, confirmado, turnos.diasem,hhmmtur " + ;
	", especialid.ESP_descripcion " + ;
	" from turnos "+;
	" inner join especialid on turnos.codesp = trim(especialid.ESP_codesp) " + ;
	" left join prestadores on turnos.codmed = prestadores.id "+;
	" where &mccpoamb turnos.codreserva<>'' and  " + ;
	" turnos.fechatur >= ?mfecdes and turnos.fechatur <= ?mfechas " + ;
	" and (turnos.tipoturno < 8 or turnos.tipoturno >=13) " + mbusco3 , "mwktodosc1")
if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DE CURSOR, REINTENTE", 13,"Validacion")
endif

mret = sqlexec(mcon1, "select fechatur, codmed, codserv, codesp, tipoturno " + ;
	"from turnos " + ;
	"where &mccpoamb  turnos.codreserva<>'' and turnos.fechatur >= ?mfecdes and turnos.fechatur <= ?mfechas and " + ;
	"afiliado > 1  and (turnos.tipoturno < 8 or turnos.tipoturno >=13) " +  mbusco3 , "mwktodosb1")

if mret < 0
	messagebox("ERROR EN LA GENERACION DE CURSOR, REINTENTE", 13,"Validacion")
endif

if mfecdes <= mfechalimite
	mret = sqlexec(mcon1, "select turnos.id,afiliado, fechatur, horatur, codmed, nombre,turnos.codesp, " + ;
		"tipoturno, confirmado, turnos.diasem,hhmmtur " + ;
		", especialid.ESP_descripcion " + ;
		"from especialid,turnoshis as turnos " + ;
		" left join prestadores on turnos.codmed = prestadores.id "+;
		"where &mccpoamb turnos.codreserva<>'' and  turnos.codesp = trim(especialid.ESP_codesp) " + ;
		" and turnos.fechatur >= ?mfecdes and turnos.fechatur <= ?mfechas " + ;
		" and (turnos.tipoturno < 8 or turnos.tipoturno >=13) " + mbusco3 , "mwktodosc2")

	if mret < 0
		messagebox("ERROR EN LA GENRACION DE CURSOR, REINTENTE", 13,"Validacion")
	endif
	mret = sqlexec(mcon1, "select fechatur, codmed, codserv, codesp, tipoturno " + ;
		"from turnoshis as turnos " + ;
		"where &mccpoamb turnos.codreserva<>'' and  turnos.fechatur >= ?mfecdes and turnos.fechatur <= ?mfechas and " + ;
		"afiliado > 1  and (turnos.tipoturno < 8 or turnos.tipoturno >=13) " +  mbusco3 , "mwktodosb2")

	if mret < 0
		messagebox("ERROR EN LA GENRACION DE CURSOR, REINTENTE", 13,"Validacion")
	endif

	if reccount('mwktodosc1')>0
		select *,iif(afiliado <= 1,id, afiliado) as afi from mwktodosc1 ;
			union all ;
			select *,iif(afiliado <= 1,id, afiliado) as afi  from mwktodosc2 ;
			into cursor mwktodos
	else
		select *,iif(afiliado <= 1,id, afiliado) as afi  from mwktodosc2 ;
			into cursor mwktodos
	endif

	if reccount('mwktodosb1')>0
		select * from mwktodosb1 ;
			union all ;
			select * from mwktodosb2 ;
			into cursor mwktodosb
	else
		select * from mwktodosb2 ;
			into cursor mwktodosb
	endif

else
	select *,iif(afiliado <= 1,id, afiliado) as afi   from mwktodosc1 ;
		into cursor mwktodos

	select * from mwktodosb1 ;
		into cursor mwktodosb
endif

select mwktodos.*,Mwkmedpre.porc,Mwkmedpre.hdesde1, Mwkmedpre.hhasta1  ;
	from mwktodos ;
	left join Mwkmedpre on (mwktodos.fechatur >= Mwkmedpre.fecvigend and ;
	mwktodos.fechatur <  Mwkmedpre.fecvigenh and ;
	hhmmtur >= Mwkmedpre.hhmmdes and hhmmtur<Mwkmedpre.hhmmhas and ;
	mwktodos.codmed = Mwkmedpre.codmed and ;
	mwktodos.codesp = Mwkmedpre.codesp and ;
	mwktodos.diasem = Mwkmedpre.diasem );
	where 1= 1 &mbusco;
	group by afi,mwktodos.codmed, mwktodos.codesp, fechatur, horatur, tipoturno ;
	into cursor mwktodosc

if mlista = 1

	select ESP_descripcion ,nombre, fechatur, hdesde1, hhasta1, ;
		codmed, codesp,tipoturno,porc ;
		from mwktodosc ;
		group by codesp, codmed, fechatur, hdesde1, hhasta1 ;
		order by codesp, codmed, fechatur, hdesde1 ;
		into cursor mwktodosa1

	select ESP_descripcion, sum(round(((hhasta1 - hdesde1)*porc/100 /3600), 2)) as horas, codesp,tipoturno ;
		from mwktodosa1 ;
		group by codesp ;
		order by codesp, codmed ;
		into cursor mwktodosa

	select a.ESP_descripcion, b.fechatur, b.codserv, a.horas,b.tipoturno ;
		from mwktodosa as a, mwktodosb as b ;
		where a.codesp = b.codesp ;
		into cursor mwktodos
else
	select ESP_descripcion ,nombre, fechatur, hdesde1, hhasta1, ;
		codmed, codesp,tipoturno,porc ;
		from mwktodosc ;
		group by codesp, codmed, fechatur, hdesde1, hhasta1 ;
		order by codesp, codmed, fechatur, hdesde1 ;
		into cursor mwktodosa1

	select ESP_descripcion, sum(round(((hhasta1 - hdesde1)*porc/100 /3600), 2)) as horas;
		,fechatur , codesp,tipoturno ;
		from mwktodosa1 ;
		group by codesp,fechatur ;
		order by codesp,fechatur ;
		into cursor mwktodosa

	select a.ESP_descripcion, b.fechatur, b.codserv, a.horas,b.tipoturno ;
		from mwktodosa as a, mwktodosb as b ;
		where a.codesp = b.codesp and b.fechatur=a.fechatur;
		into cursor mwktodos
endif

if mlista = 1
	select ESP_descripcion, fechatur, horas, codserv, ;
		sum(iif(codserv = 2200, 1, 0000)) as consulta, ;
		sum(iif(codserv <> 2200, 1, 0000)) as practica, ;
		sum(iif(tipoturno=7, 1, 0)) as pe ;
		from mwktodos ;
		group by ESP_descripcion ;
		order by ESP_descripcion ;
		into cursor mwklista1

else
	select ESP_descripcion, fechatur, horas, codserv, ;
		iif(dow(fechatur) = 2, 'Lunes    ', iif(dow(fechatur) = 3, 'Martes   ', ;
		iif(dow(fechatur) = 4, 'Miercoles', iif(dow(fechatur) = 5, 'Jueves   ', ;
		iif(dow(fechatur) = 6, 'Viernes  ', 'Sabado   '))))) as dia, ;
		sum(iif(codserv = 2200, 1, 0000)) as consulta, ;
		sum(iif(codserv <> 2200, 1, 0000)) as practica, ;
		sum(iif(tipoturno=7, 1, 0)) as pe ;
		from mwktodos ;
		group by ESP_descripcion, fechatur ;
		order by ESP_descripcion, fechatur ;
		into cursor mwklista1
endif

****
** busco los vales en valesasist
****

mret =sqlexec(mcon1, "select VAL_codservvale " + ;
	",pia_cantsolicitada,pia_codprest"+;
	", VAL_circuitoorigen, VAL_fechasolicitud " + ;
	"from valesasist "+;
	"left join coberturas on valesasist.VAL_codadmision = coberturas.COB_pacientes "+;
	"left join presinsuvas on valesasist.valesasist = presinsuvas.pia_valesasist "+mcjoinvales +;
	" where VAL_fechasolicitud >= ?mfecdes and " + ;
	"VAL_fechasolicitud <= ?mfechas and " + ;
	"VAL_codsector = 'AMB' "+ mbusco2  , "mwktotval2")


if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DE CURSOR, REINTENTE", 13,"Validacion")
endif

mret =	sqlexec(mcon1, "select pre_codprest,pre_especialidad,ESP_codesp, " + ;
	"PRE_agendaturnos, ESP_descripcion  " + ;
	"from prestacions , especialid " + ;
	" where trim(pre_especialidad) = trim(ESP_codesp) " , "mwkpres")
if mret<1
	=aerr(eros)
	messagebox(eros(2))
endif


mgroup = iif( mlista = 1,'',',VAL_fechasolicitud')

if mfechas < ctod("01/02/2005")

	select *,count(pia_cantsolicitada ) as total from mwktotval2,mwkpres ;
		where 	pre_codprest = pia_codprest and PRE_agendaturnos='S' &mbusco2f ;
		group by pre_especialidad, VAL_codservvale, VAL_circuitoorigen &mgroup ;
		into cursor mwktotval1

else

	select *,sum(pia_cantsolicitada ) as total from mwktotval2,mwkpres ;
		where 	pre_codprest = pia_codprest and PRE_agendaturnos='S' &mbusco2f ;
		group by pre_especialidad, VAL_codservvale, VAL_circuitoorigen &mgroup ;
		into cursor mwktotval1

endif


select ESP_codesp, ESP_descripcion, VAL_codservvale,VAL_fechasolicitud, ;
	sum(iif(VAL_codservvale  = 2200 and (VAL_circuitoorigen = '1' or isnull(VAL_circuitoorigen)) , total, 00000)) as totc1, ;
	sum(iif(VAL_codservvale  = 2200 and VAL_circuitoorigen = '2', total, 00000)) as totc2, ;
	sum(iif(VAL_codservvale <> 2200 and (VAL_circuitoorigen = '1' or isnull(VAL_circuitoorigen)), total, 00000)) as totd1, ;
	sum(iif(VAL_codservvale <> 2200 and VAL_circuitoorigen = '2', total, 00000)) as totd2 ;
	from mwktotval1 ;
	group by ESP_descripcion  &mgroup ;
	order by ESP_descripcion  &mgroup into cursor mwktotval

mjoin = iif(mlista=1,'','and VAL_fechasolicitud= fechatur')
select mwklista1.*, totc1, totc2, totd1, totd2 ;
	from mwklista1 left outer join mwktotval on ;
	(mwklista1.ESP_descripcion = mwktotval.ESP_descripcion &mjoin ) ;
	order by mwklista1.ESP_descripcion ;
	into cursor mwklista


if used('mwktodosa1')
	select mwktodosa1
	use
endif
if used('mwktodosa')
	select mwktodosa
	use
endif
if used('mwktodosb')
	select mwktodosb
	use
endif
if used('mwktodosb1')
	select mwktodosb1
	use
endif
if used('mwktodosb2')
	select mwktodosb2
	use
endif
if used('mwktodosc')
	select mwktodosc
	use
endif
if used('mwktodosc1')
	select mwktodosc1
	use
endif
if used('mwktodosc2')
	select mwktodosc2
	use
endif
if used('mwktodos')
	select mwktodos
	use
endif
if used('mwklista1')
	select mwklista1
	use
endif
if used('mwktotval1')
	select mwktotval1
	use
endif
if used('mwktotval')
	select mwktotval
	use
endif
