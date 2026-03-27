****
** Listado estadistico para Morgulis primero disponible, cantidad ocupados, libres
** Modificado por Claudia el 13/6/03 lineas 12 y 13 de ambos querys
****

parameter mfecdes, mfechas, mbusco1, mlista, mbusco, mbusco2, mbusco3,mbusco2f,mpe  &&&mpe es siempre 1
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
	mbusco2  = mbusco2  + " and pac_codambito=?mxambito " 
else
	mccpoamb = ''
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
mret =sqlexec(mcon1, "select VAL_codservvale " + ;
	",pia_cantsolicitada,pia_codprest,val_prestador  "+;
	", VAL_circuitoorigen, VAL_fechasolicitud,pac_centromedico " +;
	"from valesasist, presinsuvas  " +;
	" inner join pacientes on valesasist.VAL_codadmision = pacientes.pac_codadmision "+;
	" where VAL_codsector = 'AMB' and VAL_fechasolicitud >= ?mfecdes and " + ;
	"VAL_fechasolicitud <= ?mfechas and valesasist = pia_valesasist " + ;
	" and VAL_codservvale not in (7000,6400) "+ mbusco2  , "mwktotval2")
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_rendi_profe2'
	cancel
endif

use in select("mwkespecag")
mret = sqlexec(mcon1,"select TE_codambito, TE_codesp,TE_codespag"+;
	" from Tabespecialid where TE_codambito = ?mxambito ", "mwkespecag")
if used("MWKespec1")
	use in MWKespec1
endif
mret=sqlexec(mcon1," SELECT ESP_codesp, ESP_descripcion ,ESP_cantsinturno"+;
	" FROM especialid " + ;
	" WHERE ESP_descripcion is not Null " +;
	" ORDER BY ESP_descripcion","MWKespec1")

select ESP_codesp, ESP_cantsinturno,TE_codesp,TE_codespag;
	from mwkespec1 left join mwkespecag on ESP_codesp = TE_codesp;
	into cursor mwkespea

select nvl(TE_codespag,ESP_codesp) as  ESP_codesp, ESP_cantsinturno;
	,ESP_codesp as codespsa;
	from mwkespea;
	into cursor mwkespecnv

mret =	sqlexec(mcon1, "select pre_codprest,pre_especialidad,PRE_agendaturnos " + ;
	"from prestacions " + ;
	" where PRE_codservicio > 0 " , "mwkpres0")

if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_rendi_profe3'
	cancel
endif
select pre_codprest,pre_especialidad,mwkespecnv.ESP_codesp, ;
	PRE_agendaturnos, mwkespecnv.ESP_cantsinturno,codespsa ;
	from mwkpres0,mwkespecnv where codespsa= pre_especialidad;
	into cursor mwkpres

mgroup = iif( mlista = 1,'',', val_prestador ')

if mfechas < ctod("04/09/2022") &&&inicio Lima
	select *,sum(pia_cantsolicitada ) as total from mwktotval2,mwkpres ;
		where  	pre_codprest = pia_codprest &mbusco2f ;
		group by pre_especialidad, VAL_codservvale, VAL_circuitoorigen &mgroup ;
		into cursor mwktotval1
else
	select *,sum(pia_cantsolicitada ) as total from mwktotval2,mwkpres ;
		where  nvl(pac_centromedico,1) = mxcentromedico and	pre_codprest = pia_codprest &mbusco2f ;
		group by pre_especialidad, VAL_codservvale, VAL_circuitoorigen &mgroup ;
		into cursor mwktotval1
endif
mret    = SQLExec(mcon1,"Select id, (piso || descrip || numero) as lugar"+;
		",cast (0 as integer) as esta  from tabubicacion "+;
		" where   centromedico   = ?mxcentromedico   "+;
		" and codambito = ?mxambito order by piso, numero ",'Mwkqcon')

mret = sqlexec(mcon1, " select codmed, diasem, fecvigend,medpresta.codesp,codprest  "+;
	", fecvigenh,  hdesde1, hhasta1, horadesde, horahasta, bloquedesde , bloquehasta  "+;
	", hhmmDes, hhmmHas,demanda,nombre ,generaagen,sala " +;
	" from medpresta ,prestadores "+;
	" where &mccpoamb codmed = prestadores.id  &mbusco1 "+;
	" and fecvigenh > ?mfecdes and fecvigend <= ?mfechas "+;
	" and fecvigenh <> fecvigend "+;
	" group by codmed, medpresta.codesp, diasem, fecvigenh, hhmmDes,demanda ","Mwkmedpre0a")
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_rendi_profe4'
	cancel
endif
	Select Mwkmedpre0a.* From Mwkmedpre0a,Mwkqcon;
		where  Mwkmedpre0a.sala = lugar;
		INTO Cursor Mwkmedpre0

select codmed, diasem, fecvigend,esp_codesp as codesp,codprest, fecvigenh,  hdesde1, hhasta1;
	, horadesde, horahasta, bloquedesde , bloquehasta ;
	, hhmmDes, hhmmHas,demanda,nombre ,generaagen ,100 as porc,codespsa ;
	from Mwkmedpre0 ,mwkespecnv where codespsa = codesp ;
	into cursor Mwkmedpre
if mxambito >1
	mccpoamb = "  turnos.codambito = ?mxambito and "
else
	mccpoamb = ''
endif

mret = sqlexec(mcon1, "select turnos.id,afiliado, fechatur, horatur, codmed, turnos.codesp, " + ;
	"tipoturno, confirmado, turnos.diasem,hhmmtur " + ;
	", turnos.codserv,codprest "  + ;
	"from turnos " + ;
	" where &mccpoamb turnos.codreserva<>'' and  fechatur >= ?mfecdes and fechatur <= ?mfechas  and turnos.codserv<>7000 "+;
	" and (turnos.tipoturno < 8 or turnos.tipoturno >=13) " , "mwktodosc1") && mbusco3 
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
	" and (turnos.tipoturno < 8 or turnos.tipoturno >=13) " + mbusco1 , "mwktodosl1")
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_rendi_profe6'
	cancel
endif

if mfecdes <= mfechalimite
	mret = sqlexec(mcon1, "select turnos.id,afiliado, fechatur, horatur, codmed, turnos.codesp, " + ;
		"tipoturno, confirmado, turnos.diasem,hhmmtur " + ;
		", turnos.codserv,codprest " + ;
		"from turnoshis as turnos " + ;
		"where &mccpoamb turnos.codreserva<>'' and  turnos.fechatur >= ?mfecdes and turnos.fechatur <= ?mfechas  "+;
		" and turnos.codserv<>7000 " , "mwktodosc2a") && mbusco3 

	if mret < 0
		=aerr(eros)
		do prg_error with eros,'sp_lista_rendi_profe7'
		cancel
	endif
   select * from mwktodosc2a where (tipoturno < 8 or tipoturno >=13) into cursor mwktodosc2
	mret = sqlexec(mcon1, "select turnos.id,afiliado, fechatur, horatur, codmed, turnos.codesp, " + ;
		"tipoturno, confirmado, turnos.diasem,hhmmtur, turnos.codserv,codprest   " + ;
		"from turnoshis as turnos " + ;
		"where &mccpoamb afiliado <= 1  and turnos.codserv<>7000 " + ;
		" and turnos.fechatur >= ?mfecdes and turnos.fechatur <= ?mfechas "+;
		" " + mbusco1 , "mwktodosl2a")
	if mret < 0
		=aerr(eros)
		do prg_error with eros,'sp_lista_rendi_profe8'
		cancel
	endif
    select * from mwktodosl2a where (tipoturno < 8 or tipoturno >=13) into cursor mwktodosl2

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
	,mwkespecnv.ESP_codesp,Mwkmedpre.codespsa  ;
	from mwktodos, Mwkmedpre  ;
	inner join mwkespecnv on mwkespecnv.codespsa = Mwkmedpre.codespsa;
	where mwktodos.codesp = Mwkmedpre.codespsa &mbusco ;
	and mwktodos.fechatur >= Mwkmedpre.fecvigend and ;
	mwktodos.fechatur <  Mwkmedpre.fecvigenh and ;
	hhmmtur >= Mwkmedpre.hhmmdes and hhmmtur<Mwkmedpre.hhmmhas and ;
	mwktodos.codmed = Mwkmedpre.codmed and ;
	mwktodos.diasem = Mwkmedpre.diasem ;
	into cursor mwktodoscsa

select * from mwktodoscsa;
	group by afi,codmed, codespsa , horatur, tipoturno ;
	into cursor mwktodosc


*!*	select mwktodosl.id,mwktodosl.afiliado, mwktodosl.fechatur, mwktodosl.horatur;
*!*		, mwktodosl.codmed, Mwkmedpre.codesp, mwktodosl.tipoturno;
*!*		, mwktodosl.confirmado, mwktodosl.diasem, mwktodosl.hhmmtur, mwktodosl.codserv,Mwkmedpre.codprest ;
*!*		, mwktodosl.afi,nombre,Mwkmedpre.porc,Mwkmedpre.hdesde1, Mwkmedpre.hhasta1  ;
*!*		, hhmmDes, hhmmHas,mwkpres.codespsa as codespsa ;
*!*		,mwkpres.ESP_codesp as ESP_codesp ;
*!*		from mwktodosl,Mwkmedpre left join mwkpres on Mwkmedpre.codespsa = mwkpres.codespsa;
*!*		where  mwktodosl.afiliado <= 1 and mwktodosl.fechatur >= Mwkmedpre.fecvigend and ;
*!*		mwktodosl.fechatur <  Mwkmedpre.fecvigenh and ;
*!*		hhmmtur >= Mwkmedpre.hhmmdes and hhmmtur<Mwkmedpre.hhmmhas and ;
*!*		mwktodosl.codmed = Mwkmedpre.codmed and ;
*!*		mwktodosl.diasem = Mwkmedpre.diasem &mbusco;
*!*		into cursor mwktodosclsa
select mwktodosl.id,mwktodosl.afiliado, mwktodosl.fechatur, mwktodosl.horatur;
	, mwktodosl.codmed, Mwkmedpre.codespsa as codesp, mwktodosl.tipoturno;
	, mwktodosl.confirmado, mwktodosl.diasem, mwktodosl.hhmmtur, mwktodosl.codserv,Mwkmedpre.codprest ;
	, mwktodosl.afi,nombre,Mwkmedpre.porc,Mwkmedpre.hdesde1, Mwkmedpre.hhasta1  ;
	, hhmmDes, hhmmHas,mwkpres.codespsa  ;
	,mwkpres.ESP_codesp as ESP_codesp ;
	from mwktodosl,Mwkmedpre left join mwkpres on Mwkmedpre.codespsa = mwkpres.codespsa ;
	where  mwktodosl.afiliado <= 1 and mwktodosl.fechatur >= Mwkmedpre.fecvigend and ;
	mwktodosl.fechatur <  Mwkmedpre.fecvigenh and ;
	hhmmtur >= Mwkmedpre.hhmmdes and hhmmtur<Mwkmedpre.hhmmhas and ;
	mwktodosl.codmed = Mwkmedpre.codmed and ;
	mwktodosl.diasem = Mwkmedpre.diasem &mbusco;
	into cursor mwktodosclsa
&&	and Mwkmedpre.codespsa = mwkpres.codespsa ;  &&Mwkmedpre.codesp = mwkpres.codespsa ;  

select * from mwktodosclsa;
	group by afi,codmed, codespsa , horatur, tipoturno ;
	into cursor mwktodoscl

select id,afiliado,fechatur,horatur,codmed,codesp,tipoturno,confirmado,diasem,hhmmtur,codserv,codprest,afi,nombre,porc,hdesde1,hhasta1,hhmmdes,hhmmhas,esp_codesp,codespsa from mwktodoscl;
	union select id,afiliado,fechatur,horatur,codmed,codesp,tipoturno,confirmado,diasem,hhmmtur,codserv,codprest,afi,nombre,porc,hdesde1,hhasta1,hhmmdes,hhmmhas,esp_codesp,codespsa from mwktodosc where !isnull(porc)  ;
	into cursor mwktodoscc

select fechatur, codmed, codserv, codespsa ,codesp, ESP_codesp,tipoturno,afiliado from mwktodoscc into cursor mwktodosb

*** busca medicos de demanda espontanea

select id,afiliado, dias.fechatur, horatur,codesp, codesp as codespsa ,;
	tipoturno, confirmado, dias.diasem,hhmmtur ,codserv from dias,mwktodos;
	where dias.fechatur= mwktodos.fechatur group by dias.fechatur into cursor mwkdias

select mwkdias.id,afiliado, fechatur, horatur, Mwkmedpre.nombre;
	, hhmmtur, 2200 as codserv,recno("Mwkmedpre") as afi,porc,hdesde1, hhasta1,generaagen ;
	,Mwkmedpre.codmed,Mwkmedpre.codesp,Mwkmedpre.codespsa,Mwkmedpre.diasem,demanda,hhmmDes, hhmmHas  ;
	,ESP_codesp ;
	from Mwkmedpre left join mwkpres on Mwkmedpre.codespsa = trim(pre_especialidad);
	left join mwkdias on (fechatur >= fecvigend and fechatur <  fecvigenh and ;
	(fechatur > bloquehasta  or fechatur < bloquedesde ) and ;
	mwkdias.diasem = Mwkmedpre.diasem );
	where demanda = 1 ;
	group by Mwkmedpre.codespsa, Mwkmedpre.codmed, fechatur, hhmmDes, hhmmHas;
	into cursor mwktodosaD1

select iif(mxambito = 1,306,122)  as codmed, "MEDICO DEMANDA ESPONTANEA" as nombre, fechatur,sum(round(((hhasta1 - hdesde1)*porc/100 /3600), 2)) as horas;
	,codserv, codesp,codespsa,ESP_codesp ;
	from mwktodosaD1 ;
	group by codespsa ;
	order by ESP_codesp ;
	into cursor mwktodosaD

if mlista = 1

	select nombre, fechatur, hdesde1, hhasta1, ;
		codmed, codesp,codespsa,ESP_codesp,tipoturno,porc,codserv ;
		from mwktodoscc ;
		group by ESP_codesp, codmed, fechatur,hhmmDes, hhmmHas ;
		order by ESP_codesp, codmed, fechatur, hdesde1 ;
		into cursor mwktodosa1

	select sum(round(((hhasta1 - hdesde1)*porc/100 /3600), 2)) as horas, codesp,ESP_codesp,tipoturno ,codserv;
		from mwktodosa1 ;
		group by ESP_codesp ;
		order by ESP_codesp, codmed ;
		into cursor mwktodosa

	select a.ESP_codesp, afiliado, b.fechatur, b.codserv, a.horas,b.tipoturno ;
		from mwktodosa as a, mwktodosb as b ;
		where a.ESP_codesp = b.ESP_codesp ;
		into cursor mwktodos
else
	select nombre, fechatur, hdesde1, hhasta1, ;
		codmed, codesp,ESP_codesp,tipoturno,porc,codserv ;
		from mwktodoscc ;
		group by ESP_codesp, codmed, fechatur, hhmmDes, hhmmHas ;  &&ESP_codesp
		order by ESP_codesp, codmed, fechatur, hdesde1 ;
		into cursor mwktodosa1

	select sum(round(((hhasta1 - hdesde1)*porc/100 /3600), 2)) as horas;
		,fechatur , codesp,ESP_codesp,tipoturno ,codmed,nombre,codserv ;
		from mwktodosa1 ;
		group by ESP_codesp,codmed ;  &&ESP_codesp
		order by ESP_codesp,codmed ;
		into cursor mwktodosa


	select a.ESP_codesp, a.nombre,a.codmed,afiliado, b.fechatur, b.codserv, a.horas,b.tipoturno ;
		from mwktodosa as a, mwktodosb as b ;
		where a.ESP_codesp = b.ESP_codesp and b.codmed=a.codmed;
		into cursor mwktodos
endif

if mlista = 1
	select mwkespecnv.ESP_codesp, horas, codserv,"" as nombre, ;
		sum(iif(codserv = 2200 and afiliado > 1 , 1, 0000)) as consulta, ;
		sum(iif(codserv <> 2200 and afiliado > 1 , 1, 0000)) as practica, ;
		sum(iif(afiliado <= 1 , 1, 0000)) as libres, ;
		0 as pe,0 as codmed ;
		from mwktodos,mwkespecnv where mwkespecnv.codespsa = mwktodos.esp_codesp ; 
		group by mwkespecnv.ESP_codesp ;
		into cursor mwklista1

else
	select ESP_codesp, horas, codserv,nombre, ;
		sum(iif(codserv = 2200 and afiliado > 1 , 1, 0000)) as consulta, ;
		sum(iif(codserv <> 2200 and afiliado > 1 , 1, 0000)) as practica, ;
		sum(iif(afiliado <= 1 , 1, 0000)) as libres, ;
		0 as pe,codmed ; &&sum(iif(INLIST(codent,100,101,106), 1, 0))
		from mwktodos ;
		group by ESP_codesp, codmed ;
		into cursor mwklista1
endif

select ESP_codesp as ESPcodesp , VAL_codservvale,VAL_fechasolicitud,val_prestador, ;
	sum(iif(VAL_codservvale  = 2200 and (VAL_circuitoorigen = '1' or isnull(VAL_circuitoorigen)) , total, 00000)) as totc1, ;
	sum(iif(VAL_codservvale  = 2200 and VAL_circuitoorigen = '2', total, 00000)) as totc2, ;
	sum(iif(VAL_codservvale <> 2200 and (VAL_circuitoorigen = '1' or isnull(VAL_circuitoorigen)), total, 00000)) as totd1, ;
	sum(iif(VAL_codservvale <> 2200 and VAL_circuitoorigen = '2', total, 00000)) as totd2 ;
	from mwktotval1 ;
	group by ESPcodesp  &mgroup ;
	order by ESPcodesp &mgroup into cursor mwktotval

mjoin = iif(mlista=1,'','and val_prestador = codmed ')

select mwklista1.*, totc1, totc2, totd1, totd2 ;
	from mwktotval left outer join mwklista1 on ;
	(mwklista1.ESP_codesp = mwktotval.ESPcodesp  &mjoin ) ;  
	into cursor mwklistat

select mwklista1.*,espcodesp, totc1, totc2, totd1, totd2 ;
	from mwktotval left outer join mwklista1 on ;
	(mwklista1.ESP_codesp = mwktotval.ESPcodesp and val_prestador = codmed  ) ;
	into cursor mwklistatD

select ESPcodesp as ESP_codesp ,mwktodosaD.horas as horas, 2200 as codserv;
	,"MEDICO DEMANDA ESPONTANEA" as nombre, ;
	sum(0) as consulta, sum(0) as practica, sum(0) as libres, sum(0) as pe,iif(mxambito = 1,306,122)  as codmed ;
	, sum(totc1) as totc1 , sum(totc2) as totc2, sum(totd1) as totd1;
	, sum(totd2) as totd2 ;
	from mwklistatD ,mwktodosaD ;
	where isnull(mwklistatD.nombre) ;
	and ESPcodesp = mwktodosaD.ESP_codesp ;
	group by ESPcodesp  into cursor mwklistad

select ESP_codesp, horas, codserv,padr(nombre,50) as nombre,consulta, practica, libres, pe,codmed ;
	, totc1, totc2, totd1, totd2 from mwklistat where !isnull(nombre);
	union select ESP_codesp ,horas, codserv,padr(nombre,50) as nombre,consulta, practica, libres, pe,codmed ;
	, totc1, totc2, totd1, totd2  from mwklistad into cursor mwklista
if mlista = 1
	select mwklista.ESP_codesp ,ESP_descripcion,sum(horas) as horas, codserv,padr(nombre,50) as nombre;
		,max(consulta) as consulta, max(practica) as practica, max(libres) as libres;
		, max(pe) as pe ,codmed ;
		, max(totc1) as totc1, max(totc2) as totc2,max(totd1) as totd1,max(totd2) as totd2;
		from mwklista,MWKespec1 where MWKespec1.ESP_codesp = mwklista.ESP_codesp ;
		group by mwklista.ESP_codesp into cursor mwklista

else
	select mwklista.*,esp_descripcion from mwklista,MWKespec1 ;
		where MWKespec1.ESP_codesp = mwklista.ESP_codesp  ;
		into cursor mwklista

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
