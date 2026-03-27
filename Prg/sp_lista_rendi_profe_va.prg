****
** Listado estadistico para Morgulis primero disponible, cantidad ocupados, libres
** Modificado por Claudia el 13/6/03 lineas 12 y 13 de ambos querys
****

parameter mfecdes, mfechas, mbusco1, mlista, mbusco, mbusco2, mbusco3,mbusco2f,mpe
if used('dias')
	use in dias
endif
create cursor dias (fechatur D,diasem n )
for i = 0 to mfechas - mfecdes
	mdias = mfecdes + i
	insert into dias ( fechatur,diasem  ) values ( mdias, dow(mdias) )
next
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
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_rendi_profe1'
	cancel
endif
go bottom in mwkctrlfecha
mfechalimite = mwkctrlfecha.fechacierre
use in mwkctrlfecha

****
** busco los vales en valesasist
****
if mpe=2
		mret =sqlexec(mcon1, "select VAL_codservvale " + ;
		",pia_cantsolicitada,pia_codprest,val_prestador  "+;
		", VAL_circuitoorigen, VAL_fechasolicitud " + ;
		"from valesasist,presinsuvas,coberturas  "+mcjoinvales +;
		" where VAL_codsector = 'AMB' and VAL_fechasolicitud >= ?mfecdes and " + ;
		" VAL_codadmision = COB_pacientes and "+;
		"VAL_fechasolicitud <= ?mfechas and valesasist = pia_valesasist " + ;
		" and VAL_codservvale not in (7000,6400) " + mbusco2  , "mwktotval2")
else
	mret =sqlexec(mcon1, "select VAL_codservvale " + ;
		",pia_cantsolicitada,pia_codprest,val_prestador  "+;
		", VAL_circuitoorigen, VAL_fechasolicitud " + ;
		"from valesasist, presinsuvas  "+mcjoinvales +;
		" where VAL_codsector = 'AMB' and VAL_fechasolicitud >= ?mfecdes and " + ;
		"VAL_fechasolicitud <= ?mfechas and valesasist = pia_valesasist " + ;
		" and VAL_codservvale not in (7000,6400) "+ mbusco2  , "mwktotval2")
endif

if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_rendi_profe2'
	cancel
endif

	use in select("mwkespecag")
	mret = sqlexec(mcon1,"select TE_codambito, TE_codesp,TE_codespag"+;
				" from Tabespecialid where TE_codambito = ?mxambito ", "mwkespecag")

mret =	sqlexec(mcon1, "select pre_codprest,pre_especialidad,PRE_agendaturnos " + ;
	",ESP_codesp, ESP_descripcion "+ ;
	"from prestacions , especialid " + ;
	" where trim(pre_especialidad) = trim(ESP_codesp) and PRE_codservicio > 0 " , "mwkpres")

*!*	mret=sqlexec(mcon1," SELECT ESP_codesp, ESP_descripcion FROM especialid " + ;
*!*		" WHERE ESP_descripcion is not Null and ESP_genagendaturno <>'N' " ,"MWKpesp")
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_rendi_profe3'
	cancel
endif

mgroup = iif( mlista = 1,'',', val_prestador ')

if mfechas < ctod("01/02/2005")

	select *,count(pia_cantsolicitada ) as total from mwktotval2,mwkpres ;
		where 	pre_codprest = pia_codprest &mbusco2f ;
		group by pre_especialidad, VAL_codservvale, VAL_circuitoorigen &mgroup ;
		into cursor mwktotval1

else

	select *,sum(pia_cantsolicitada ) as total from mwktotval2,mwkpres ;
		where 	pre_codprest = pia_codprest &mbusco2f ;
		group by pre_especialidad, VAL_codservvale, VAL_circuitoorigen &mgroup ;
		into cursor mwktotval1
endif
mret = sqlexec(mcon1, " select codmed, diasem, fecvigend,medpresta.codesp,codprest  "+;
	", fecvigenh,  hdesde1, hhasta1, horadesde, horahasta, bloquedesde , bloquehasta  "+;
	", hhmmDes, hhmmHas,demanda,nombre ,generaagen " +;
	" from medpresta ,prestadores "+;
	" where &mccpoamb codmed = prestadores.id  &mbusco1 "+;
	" and fecvigenh > ?mfecdes and fecvigend <= ?mfechas "+;
	" and fecvigenh <> fecvigend "+;
	" group by codmed, medpresta.codesp, diasem, fecvigenh, hdesde1,demanda ","Mwkmedpre")
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_rendi_profe4'
	cancel
endif
select Mwkmedpre.*;
	from Mwkmedpre ;
	into cursor Mwkmedpre0

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

select *,iif(codesp= 'GINE',60.00,iif(codesp= 'OBST',40.00,;
	iif(codesp= 'OFTA',80.00,iif(codesp= 'OFTI',20.00,;
	iif(codesp= 'NEUF',60.00,iif(codesp= 'NFII',40.00,;
	iif(codesp= 'CIVP',80.00,iif(codesp= 'CIRC',20.00,;
	iif(codesp= 'NUTI',50.00,iif(codesp= 'DIAI',50.00,99.99)))))))))) as porc ;
	from Mwkmedpre2 into cursor Mwkmedpre3

select * from Mwkmedpre1 ;
	union select * from Mwkmedpre3 into cursor Mwkmedpre

mret = sqlexec(mcon1, "select turnos.id,afiliado, fechatur, horatur, codmed, turnos.codesp, " + ;
	"tipoturno, confirmado, turnos.diasem,hhmmtur " + ;
	", turnos.codserv,codprest "  + ;
	"from turnos " + ;
	" where &mccpoamb fechatur >= ?mfecdes and fechatur <= ?mfechas  and turnos.codserv<>7000 "+;
	" and tipoturno<8 " +	mbusco3 , "mwktodosc1")
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_rendi_profe5'
	cancel
endif

mret = sqlexec(mcon1, "select turnos.id,afiliado, fechatur, horatur, codmed, turnos.codesp, " + ;
	"tipoturno, confirmado, turnos.diasem,hhmmtur, turnos.codserv ,codprest  " + ;
	"from turnos " + ;
	"where &mccpoamb afiliado <= 1 " + ;
	" and fechatur >= ?mfecdes and fechatur <= ?mfechas  and turnos.codserv<>7000 "+;
	" and tipoturno<8 " + mbusco1 , "mwktodosl1")
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_rendi_profe6'
	cancel
endif

if mfecdes <= mfechalimite
	mret = sqlexec(mcon1, "select turnos.id,afiliado, fechatur, horatur, codmed, turnos.codesp, " + ;
		"tipoturno, confirmado, turnos.diasem,hhmmtur " + ;
		", turnos.codserv,codprest " + ;
		"from turnoshis as turnos, especialid " + ;
		"where &mccpoamb turnos.fechatur >= ?mfecdes and turnos.fechatur <= ?mfechas  "+;
		" and turnos.codserv<>7000 and turnos.tipoturno<8 " + ;
		mbusco3 , "mwktodosc2")

	if mret < 0
		=aerr(eros)
		do prg_error with eros,'sp_lista_rendi_profe7'
		cancel
	endif
	mret = sqlexec(mcon1, "select turnos.id,afiliado, fechatur, horatur, codmed, turnos.codesp, " + ;
		"tipoturno, confirmado, turnos.diasem,hhmmtur, turnos.codserv,codprest   " + ;
		"from turnoshis as turnos " + ;
		"where &mccpoamb afiliado <= 1  and turnos.codserv<>7000 " + ;
		" and turnos.fechatur >= ?mfecdes and turnos.fechatur <= ?mfechas "+;
		" and tipoturno<8 " + mbusco1 , "mwktodosl2")
	if mret < 0
		=aerr(eros)
		do prg_error with eros,'sp_lista_rendi_profe8'
		cancel
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

	if reccount('mwktodosl1')>0
		select *,id as afi from mwktodosl1 ;
			union all ;
			select *,id as afi  from mwktodosl2 ;
			into cursor mwktodosl
	else
		select *,id as afi  from mwktodosl2 ;
			into cursor mwktodosl
	endif

else
	select *,iif(afiliado <= 1,id, afiliado) as afi   from mwktodosc1 ;
		into cursor mwktodos


	select *,id as afi from mwktodosl1  ;
		into cursor mwktodosl
endif

select mwktodos.*,nombre,Mwkmedpre.porc,Mwkmedpre.hdesde1, Mwkmedpre.hhasta1, hhmmDes, hhmmHas   ;
	,ESP_codesp, ESP_descripcion  ;
	from mwktodos, mwkpres,Mwkmedpre  ;
	where mwktodos.codesp = trim(ESP_codesp) &mbusco;
	and mwktodos.fechatur >= Mwkmedpre.fecvigend and ;
	mwktodos.fechatur <  Mwkmedpre.fecvigenh and ;
	hhmmtur >= Mwkmedpre.hhmmdes and hhmmtur<Mwkmedpre.hhmmhas and ;
	mwktodos.codmed = Mwkmedpre.codmed and ;
	mwktodos.codesp = Mwkmedpre.codesp and ;
	mwktodos.diasem = Mwkmedpre.diasem ;
	into cursor mwktodoscsa
	
select * from mwktodoscsa;
	group by afi,codmed, codesp, horatur, tipoturno ;
	into cursor mwktodosc


select mwktodosl.id,mwktodosl.afiliado, mwktodosl.fechatur, mwktodosl.horatur;
	, mwktodosl.codmed, Mwkmedpre.codesp, mwktodosl.tipoturno;
	, mwktodosl.confirmado, mwktodosl.diasem, mwktodosl.hhmmtur, mwktodosl.codserv,Mwkmedpre.codprest ;
	, mwktodosl.afi,nombre,Mwkmedpre.porc,Mwkmedpre.hdesde1, Mwkmedpre.hhasta1  ;
	, hhmmDes, hhmmHas ;
	,ESP_codesp, ESP_descripcion  ;
	from mwktodosl,Mwkmedpre left join mwkpres on Mwkmedpre.codesp = trim(ESP_codesp);
	where  mwktodosl.afiliado <= 1 and mwktodosl.fechatur >= Mwkmedpre.fecvigend and ;
	mwktodosl.fechatur <  Mwkmedpre.fecvigenh and ;
	hhmmtur >= Mwkmedpre.hhmmdes and hhmmtur<Mwkmedpre.hhmmhas and ;
	mwktodosl.codmed = Mwkmedpre.codmed and ;
	mwktodosl.diasem = Mwkmedpre.diasem &mbusco;
	into cursor mwktodosclsa
	
select * from mwktodosclsa;
	group by afi,codmed, codesp, horatur, tipoturno ;
	into cursor mwktodoscl

select * from mwktodoscl;
	union select * from mwktodosc where !isnull(porc)  ;
	into cursor mwktodoscc

select fechatur, codmed, codserv, codesp, tipoturno,afiliado from mwktodoscc into cursor mwktodosb

*** busca medicos de demanda espontanea
select id,afiliado, dias.fechatur, horatur,codesp, ;
	tipoturno, confirmado, dias.diasem,hhmmtur ,codserv from dias,mwktodos;
	where dias.fechatur= mwktodos.fechatur group by dias.fechatur into cursor mwkdias

select mwkdias.id,afiliado, fechatur, horatur, Mwkmedpre.nombre;
	, hhmmtur, 2200 as codserv,recno("Mwkmedpre") as afi,porc,hdesde1, hhasta1,generaagen ;
	,Mwkmedpre.codmed,Mwkmedpre.codesp,Mwkmedpre.diasem,demanda,hhmmDes, hhmmHas  ;
	,ESP_codesp, ESP_descripcion  ;
	from Mwkmedpre left join mwkpres on Mwkmedpre.codesp = trim(ESP_codesp);
	left join mwkdias on (fechatur >= fecvigend and fechatur <  fecvigenh and ;
	(fechatur > bloquehasta  or fechatur < bloquedesde ) and ;
	mwkdias.diasem = Mwkmedpre.diasem );
	where demanda = 1 ;
	group by Mwkmedpre.codesp, Mwkmedpre.codmed, fechatur, hhmmDes, hhmmHas;
	into cursor mwktodosaD1

select iif(mxambito = 1,306,122)  as codmed, "MEDICO DEMANDA ESPONTANEA" as nombre, fechatur,ESP_descripcion, sum(round(((hhasta1 - hdesde1)*porc/100 /3600), 2)) as horas;
	,codserv, codesp ;
	from mwktodosaD1 ;
	group by codesp ;
	order by codesp ;
	into cursor mwktodosaD

if mlista = 1

	select ESP_descripcion ,nombre, fechatur, hdesde1, hhasta1, ;
		codmed, codesp,tipoturno,porc,codserv ;
		from mwktodoscc ;
		group by codesp, codmed, fechatur,hhmmDes, hhmmHas ;
		order by codesp, codmed, fechatur, hdesde1 ;
		into cursor mwktodosa1

	select ESP_descripcion, sum(round(((hhasta1 - hdesde1)*porc/100 /3600), 2)) as horas, codesp,tipoturno ,codserv;
		from mwktodosa1 ;
		group by codesp ;
		order by codesp, codmed ;
		into cursor mwktodosa

	select a.ESP_descripcion,afiliado, b.fechatur, b.codserv, a.horas,b.tipoturno ;
		from mwktodosa as a, mwktodosb as b ;
		where a.codesp = b.codesp ;
		into cursor mwktodos
else
	select ESP_descripcion ,nombre, fechatur, hdesde1, hhasta1, ;
		codmed, codesp,tipoturno,porc,codserv ;
		from mwktodoscc ;
		group by codesp, codmed, fechatur, hhmmDes, hhmmHas ;
		order by codesp, codmed, fechatur, hdesde1 ;
		into cursor mwktodosa1

	select ESP_descripcion, sum(round(((hhasta1 - hdesde1)*porc/100 /3600), 2)) as horas;
		,fechatur , codesp,tipoturno ,codmed,nombre,codserv ;
		from mwktodosa1 ;
		group by codesp,codmed ;
		order by codesp,codmed ;
		into cursor mwktodosa


	select a.ESP_descripcion, a.nombre,a.codmed,afiliado, b.fechatur, b.codserv, a.horas,b.tipoturno ;
		from mwktodosa as a, mwktodosb as b ;
		where a.codesp = b.codesp and b.codmed=a.codmed;
		into cursor mwktodos
endif

if mlista = 1
	select ESP_descripcion, horas, codserv,"" as nombre, ;
		sum(iif(codserv = 2200 and afiliado > 1 , 1, 0000)) as consulta, ;
		sum(iif(codserv <> 2200 and afiliado > 1 , 1, 0000)) as practica, ;
		sum(iif(afiliado <= 1 , 1, 0000)) as libres, ;
		sum(iif(tipoturno=7, 1, 0)) as pe,0 as codmed ;
		from mwktodos ;
		group by ESP_descripcion ;
		order by ESP_descripcion ;
		into cursor mwklista1

else
	select ESP_descripcion, horas, codserv,nombre, ;
		sum(iif(codserv = 2200 and afiliado > 1 , 1, 0000)) as consulta, ;
		sum(iif(codserv <> 2200 and afiliado > 1 , 1, 0000)) as practica, ;
		sum(iif(afiliado <= 1 , 1, 0000)) as libres, ;
		sum(iif(tipoturno=7, 1, 0)) as pe,codmed ;
		from mwktodos ;
		group by ESP_descripcion, codmed ;
		order by ESP_descripcion, nombre ;
		into cursor mwklista1
endif

select ESP_codesp as ESPcodesp , ESP_descripcion as ESPdescripcion, VAL_codservvale,VAL_fechasolicitud,val_prestador, ;
	sum(iif(VAL_codservvale  = 2200 and (VAL_circuitoorigen = '1' or isnull(VAL_circuitoorigen)) , total, 00000)) as totc1, ;
	sum(iif(VAL_codservvale  = 2200 and VAL_circuitoorigen = '2', total, 00000)) as totc2, ;
	sum(iif(VAL_codservvale <> 2200 and (VAL_circuitoorigen = '1' or isnull(VAL_circuitoorigen)), total, 00000)) as totd1, ;
	sum(iif(VAL_codservvale <> 2200 and VAL_circuitoorigen = '2', total, 00000)) as totd2 ;
	from mwktotval1 ;
	group by ESPdescripcion  &mgroup ;
	order by ESPdescripcion  &mgroup into cursor mwktotval

mjoin = iif(mlista=1,'','and val_prestador = codmed ')

select mwklista1.*, ESPdescripcion,totc1, totc2, totd1, totd2 ;
	from mwktotval left outer join mwklista1 on ;
	(mwklista1.ESP_descripcion = mwktotval.ESPdescripcion &mjoin ) ;
	order by mwklista1.ESP_descripcion ;
	into cursor mwklistat
	
select mwklista1.*, ESPdescripcion,totc1, totc2, totd1, totd2 ;
	from mwktotval left outer join mwklista1 on ;
	(mwklista1.ESP_descripcion = mwktotval.ESPdescripcion and val_prestador = codmed  ) ;
	order by mwklista1.ESP_descripcion ;
	into cursor mwklistatD

select ESPdescripcion as ESP_descripcion,mwktodosaD.horas as horas, 2200 as codserv;
	,"MEDICO DEMANDA ESPONTANEA" as nombre, ;
	Sum(0) as consulta, Sum(0) as practica, Sum(0) as libres, Sum(0) as pe,iif(mxambito = 1,306,122)  as codmed ;
	, sum(totc1) as totc1 , sum(totc2) as totc2, sum(totd1) as totd1;
	, sum(totd2) as totd2 ;
	from mwklistatD ,mwktodosaD ;
	where isnull(mwklistatD.nombre) ;
	and ESPdescripcion = mwktodosaD.ESP_descripcion;
	group by ESPdescripcion into cursor mwklistad

select ESP_descripcion,horas, codserv,padr(nombre,50) as nombre,consulta, practica, libres, pe,codmed ;
	, totc1, totc2, totd1, totd2 from mwklistat where !isnull(nombre);
	union select ESP_descripcion,horas, codserv,padr(nombre,50) as nombre,consulta, practica, libres, pe,codmed ;
	, totc1, totc2, totd1, totd2  from mwklistad into cursor mwklista
if mlista = 1
	select ESP_descripcion,sum(horas) as horas, codserv,padr(nombre,50) as nombre;
		,max(consulta) as consulta, max(practica) as practica, max(libres) as libres;
		, max(pe) as pe ,codmed ;
		, max(totc1) as totc1, max(totc2) as totc2,max(totd1) as totd1,max(totd2) as totd2;
		from mwklista group by ESP_descripcion into cursor mwklista

endif
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
if used('mwktodoscc')
	select mwktodoscc
	use
endif
if used('mwktodoscl')
	select mwktodoscl
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
