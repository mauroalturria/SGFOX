****
** Rendimiento por especialidad
****
****  ESP_cantsinturno es el rendimiento esperado x 10 (xq no acepta decimales)

parameter mfecdes, mfechas, mbusco1, mlista, mbusco, mbusco2, mbusco3,mbusco2f,mpe

if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''	
endif

mret = sqlexec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	'  where &mccpoamb id<100000 order by fechacierre ','mwkctrlfecha')
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_rendimiento1'
endif
go bottom in mwkctrlfecha
mfechalimite = mwkctrlfecha.fechacierre
use in mwkctrlfecha
	use in select("mwkespecag")
	mret = sqlexec(mcon1,"select TE_codambito, TE_codesp,TE_codespag"+;
				" from Tabespecialid where TE_codambito = ?mxambito ", "mwkespecag")

mret =	sqlexec(mcon1, "select pre_codprest,pre_especialidad,ESP_codesp, " + ;
	"PRE_agendaturnos, ESP_descripcion,ESP_cantsinturno   " + ;
	"from prestacions , especialid " + ;
	" where pre_especialidad = ESP_codesp " , "mwkpres")

select * from mwkpres group by ESP_descripcion into cursor mwkpress

if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_rendimiento6'
	cancel
endif
mret = sqlexec(mcon1, " select codmed, diasem, fecvigend,codesp ,codserv"+;
	", fecvigenh,  hdesde1, hhasta1, horadesde, horahasta "+;
	", hhmmDes, hhmmHas " +;
	" from medpresta"+;
	" where &mccpoamb diasem > 0  " + mbusco1+ mbusco +;
	" and fecvigenh > ?mfecdes and fecvigend <= ?mfechas "+;
	" and fecvigenh <> fecvigend "+;
	" group by codmed, codesp,codserv, diasem, fecvigenh, hdesde1 ","Mwkmedpre00")
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_rendimiento2'
	cancel
endif
select *,right(ttoc(hdesde1),8) as hdes1,right(ttoc(hhasta1), 8) as hhas1   ;
	from Mwkmedpre00 into cursor Mwkmedpre01

select * from Mwkmedpre01;
	group by codmed, codesp,codserv, diasem, fecvigenh, hdes1 ;
	into cursor Mwkmedpre0

select transf(codmed,"9999")+transf(diasem,"9")+dtoc(fecvigenh)+ hdes1 as valor from Mwkmedpre0 ;
	group by codmed, diasem, fecvigenh, hdes1 ;
	having count(codesp)>1 into cursor mwkmedpmix

select *,100 as porc from Mwkmedpre0 ;
	where transf(codmed,"9999")+transf(diasem,"9")+dtoc(fecvigenh)+ hdes1  ;
	not in (select valor from mwkmedpmix) order by codmed, diasem, fecvigenh, hdes1 ;
	into cursor Mwkmedpre1
select * from Mwkmedpre0 ;
	where transf(codmed,"9999")+transf(diasem,"9")+dtoc(fecvigenh)+ hdes1  ;
	in (select valor from mwkmedpmix) order by codmed, diasem, fecvigenh, hdes1 ;
	into cursor Mwkmedpre2

select *,iif(codesp= 'GINE',60.00,iif(codesp= 'OBST',40.00,;
	iif(codesp= 'OFTA',80.00,iif(codesp= 'OFTI',20.00,;
	iif(codesp= 'NEUF',60.00,iif(codesp= 'NFII',40.00,;
	iif(codesp= 'CIVP',80.00,iif(codesp= 'CIRC',20.00,;
	iif(codesp= 'NUTI',50.00,iif(codesp= 'DIAI',50.00,99.99)))))))))) as porc ;
	from Mwkmedpre2 into cursor Mwkmedpre3

select * from Mwkmedpre1 ;
	union select * from Mwkmedpre3 into cursor Mwkmedpresf

if mpe=1
	select * from Mwkmedpresf into cursor Mwkmedpre
else
	mtipope = iif(mpe=2," and tipoturno=7 "," and tipoturno<>7 ")
	mret = sqlexec(mcon1, "select codmed ,diasem, hhmmdes,hhmmhas, fecvigend, fecvigenh, tipoturno "+;
		" from franjahoraria "+;
		" where &mccpoamb diasem > 0 "+;
		" and fecvigenh > ?mfecdes and fecvigend <= ?mfechas "+;
		" and fecvigenh <> fecvigend "+ mtipope + mbusco1 +;
		" group by codmed, diasem, fecvigenh, hhmmdes,tipoturno ","Mwkfran0")

	select Mwkmedpresf.* from Mwkmedpresf,Mwkfran0;
		where Mwkfran0.codmed 	= Mwkmedpresf.codmed and  ;
		Mwkfran0.diasem 	= Mwkmedpresf.diasem and ;
		Mwkfran0.hhmmDes 	= Mwkmedpresf.hhmmDes and ;
		Mwkfran0.hhmmHas 	= Mwkmedpresf.hhmmHas and ;
		Mwkfran0.fecvigend 	<= Mwkmedpresf.fecvigend and ;
		Mwkfran0.fecvigenh 	>= Mwkmedpresf.fecvigenh ;
		group by Mwkmedpresf.codmed, Mwkmedpresf.codesp, Mwkmedpresf.codserv, Mwkmedpresf.diasem, Mwkmedpresf.fecvigenh, Mwkmedpresf.hdes1 ;
		order by Mwkmedpresf.codmed, Mwkmedpresf.codesp, Mwkmedpresf.codserv, Mwkmedpresf.diasem, Mwkmedpresf.fecvigenh, Mwkmedpresf.hdes1 ;
		into cursor Mwkmedpre

endif
if mxambito >1
	mccpoamb = "  turnos.codambito = ?mxambito and "
else
	mccpoamb = ''	
endif

mret = sqlexec(mcon1, "select turnos.id,afiliado, fechatur, horatur, codmed, nombre,turnos.codesp, " + ;
	" tipoturno, confirmado, diasem,hhmmtur, codserv,nrovale "+;
	" from turnos " + ;
	" left join prestadores on turnos.codmed = prestadores.id "+;
	" where &mccpoamb turnos.fechatur >= ?mfecdes and turnos.fechatur <= ?mfechas "+;
	" and tipoturno<8 " , "mwktodosc1")

if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_rendimiento3'
	cancel
endif


if mfecdes <= mfechalimite
	mret = sqlexec(mcon1, "select turnos.id,afiliado, fechatur, horatur, codmed, nombre,turnos.codesp, " + ;
		" tipoturno, confirmado, turnos.diasem,hhmmtur " + ;
		", turnos.codserv " + ;
		" from turnoshis as turnos " + ;
		" left join prestadores on turnos.codmed = prestadores.id "+;
		" where &mccpoamb turnos.fechatur >= ?mfecdes and turnos.fechatur <= ?mfechas "+;
		" and tipoturno<8 " , "mwktodosc2")

	if mret < 0
		=aerr(eros)
		do prg_error with eros,'sp_lista_rendimiento4'
		cancel
	endif

	if reccount('mwktodosc1')>0
		select *,iif(afiliado <= 1,id, afiliado) as afi from mwktodosc1 ;
			union all ;
			select *,iif(afiliado <= 1,id, afiliado) as afi  from mwktodosc2 ;
			into cursor mwktodosc
	else
		select *,iif(afiliado <= 1,id, afiliado) as afi  from mwktodosc2 ;
			into cursor mwktodosc
	endif

else
	select *,iif(afiliado <= 1,id, afiliado) as afi   from mwktodosc1 ;
		into cursor mwktodosc

endif

select mwktodosc.*, ESP_descripcion,ESP_cantsinturno;
	from mwktodosc,mwkpress;
	where codesp = trim(ESP_codesp) and afiliado > 1 ;
	and codserv<>7000 group by afiliado,horatur,codmed into cursor mwktodos

select * from mwktodosc;
	where afiliado <= 1 group by horatur,codmed into cursor mwktodosb

select mwktodos.*,porc,hdesde1, hhasta1,right(ttoc(hdesde1),8) as hdes1,right(ttoc(hhasta1), 8) as hhas1     ;
	from mwktodos, Mwkmedpre;
	where mwktodos.fechatur >= Mwkmedpre.fecvigend and ;
	mwktodos.fechatur <  Mwkmedpre.fecvigenh and ;
	hhmmtur >= Mwkmedpre.hhmmdes and hhmmtur<Mwkmedpre.hhmmhas and ;
	mwktodos.codmed = Mwkmedpre.codmed and ;
	mwktodos.codserv = Mwkmedpre.codserv and ;
	mwktodos.codesp = Mwkmedpre.codesp and ;
	mwktodos.diasem = Mwkmedpre.diasem  ;
	group by afi,mwktodos.codmed, mwktodos.codesp, mwktodos.codserv, fechatur, horatur, tipoturno ;
	into cursor mwktodost

*mbusco = " and codesp = ?mcodesp "
mbuscosql = strtran(mbusco,'codesp = ?','Mwkmedpre.codesp = ')

select id,afiliado, fechatur, horatur, mwktodosb.codmed, nombre,Mwkmedpre.codesp, ;
	tipoturno, confirmado, mwktodosb.diasem,hhmmtur, Mwkmedpre.codserv, 10000-10000 as afi ;
	, ESP_descripcion,ESP_cantsinturno,porc,hdesde1,hhasta1,hdes1,hhas1;
	from mwktodosb, Mwkmedpre,mwkpress;
	where mwktodosb.fechatur >= Mwkmedpre.fecvigend and ;
	mwktodosb.fechatur <  Mwkmedpre.fecvigenh and ;
	hhmmtur >= Mwkmedpre.hhmmdes and hhmmtur<Mwkmedpre.hhmmhas and ;
	mwktodosb.codmed = Mwkmedpre.codmed and ;
	mwktodosb.diasem = Mwkmedpre.diasem &mbuscosql ;
	and Mwkmedpre.codesp = trim(ESP_codesp) and Mwkmedpre. codserv<>7000 ;
	group by afi,mwktodosb.codmed, Mwkmedpre.codesp, fechatur, horatur, tipoturno ;
	into cursor mwktodosl

select * from mwktodost ;
	union select * from mwktodosl ;
	into cursor mwktodosu

if mlista = 1

	select ESP_descripcion ,nombre, fechatur, hdesde1, hhasta1,hhas1, ;
		codmed, codesp,tipoturno,porc,ESP_cantsinturno  ;
		from mwktodosu ;
		group by codesp, codmed, fechatur, hdes1 ;  &&&, hhas1
	order by codesp, codmed, fechatur, hdes1 ;
		into cursor mwktodosa1

	select ESP_descripcion, sum(round(((hhasta1 - hdesde1)*porc/100 /3600), 2)) as horas,  ;
		codesp,tipoturno,ESP_cantsinturno ;
		from mwktodosa1 ;
		group by codesp ;
		order by codesp, codmed ;
		into cursor mwktodosa

	select a.ESP_descripcion, b.nombre, b.fechatur, b.codserv, a.horas,b.tipoturno;
		, a.ESP_cantsinturno, b.hdesde1, b.hhasta1,	b.codmed, b.codesp,b.porc;
		from mwktodost as b, mwktodosa as a ;
		where a.codesp = b.codesp ;
		into cursor mwktodos
else
	select ESP_descripcion ,nombre, fechatur, hdesde1, hhasta1, ;
		codmed, codesp,tipoturno,porc,ESP_cantsinturno  ;
		from mwktodosu ;
		group by codesp, codmed, fechatur, hdes1 ;   &&&&, hhas1
	order by codesp, codmed, fechatur, hdes1 ;
		into cursor mwktodosa1

	select ESP_descripcion, sum(round(((hhasta1 - hdesde1)*porc/100 /3600), 2)) as horas;
		,fechatur , codesp,tipoturno,ESP_cantsinturno  ;
		from mwktodosa1 ;
		group by codesp,fechatur ;
		order by codesp,fechatur ;
		into cursor mwktodosa

	select a.ESP_descripcion, b.fechatur, b.codserv, a.horas,b.tipoturno,a.ESP_cantsinturno  ;
		,b.confirmado;
		from mwktodost as b, mwktodosa as a ;
		where a.codesp = b.codesp and b.fechatur=a.fechatur;
		into cursor mwktodos
endif

if mlista = 1
	select ESP_descripcion, fechatur, horas, codserv, ;
		sum(iif(codserv = 2200 , 1, 0000)) as consulta, ;
		sum(iif(codserv <> 2200, 1, 0000)) as practica, ;
		sum(iif(tipoturno=7, 1, 0)) as pe,ESP_cantsinturno  ;
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
		sum(iif(tipoturno=7, 1, 0)) as pe,ESP_cantsinturno  ;
		from mwktodos ;
		group by ESP_descripcion, fechatur ;
		order by ESP_descripcion, fechatur ;
		into cursor mwklista1
endif

****
** busco los vales en valesasist
****
mseco = seconds()
if mpe>1
	mret =sqlexec(mcon1, "select VAL_codservvale " + ;
		",pia_cantsolicitada,pia_codprest,val_prestador  "+;
		", VAL_circuitoorigen, VAL_fechasolicitud,(select cob_codentidad from coberturas " + ;
		" where COB_pacientes = VAL_codadmision ) as cob_codentidad  ,val_codvaleasist "+;
		"from valesasist,presinsuvas "+;
		" where VAL_codsector = 'AMB' and VAL_fechasolicitud >= ?mfecdes and " + ;
		"VAL_fechasolicitud <= ?mfechas and valesasist = pia_valesasist " + ;
		"" , "mwktotval20")
	select * from mwktotval20 where &mbusco2 into cursor mwktotval2
else
	mret =sqlexec(mcon1, "select VAL_codservvale " + ;
		",pia_cantsolicitada,pia_codprest,val_prestador  "+;
		", VAL_circuitoorigen, VAL_fechasolicitud ,val_codvaleasist " + ;
		"from valesasist, presinsuvas  "+;
		" where VAL_codsector = 'AMB' and VAL_fechasolicitud >= ?mfecdes and " + ;
		"VAL_fechasolicitud <= ?mfechas and valesasist = pia_valesasist " + ;
		"", "mwktotval2")
endif
mseco2= seconds()
*wait windows (transf(mseco2-mseco)) nowait
&&" and "
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_rendimiento5'
	cancel
endif

mgroup = iif( mlista = 1,'',',VAL_fechasolicitud')
*mbusco = " and codesp = ?mcodesp "
mbusco2f = strtran(mbusco,'codesp = ?','esp_codesp = ')

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
	sum(iif(VAL_codservvale <> 2200 and VAL_circuitoorigen = '2', total, 00000)) as totd2,ESP_cantsinturno  ;
	from mwktotval1 ;
	group by ESP_descripcion  &mgroup ;
	order by ESP_descripcion  &mgroup into cursor mwktotval

mjoin = iif(mlista=1,'','and VAL_fechasolicitud= fechatur')
select mwklista1.*, totc1, totc2, totd1, totd2,mwklista1.horas as espe,mwktotval.esp_codesp  ;
	from mwklista1 left outer join mwktotval on ;
	(mwklista1.ESP_descripcion = mwktotval.ESP_descripcion &mjoin ) ;
	order by mwklista1.ESP_descripcion ;
	into cursor mwklistat

if mlista = 1
select mwktotval.ESP_descripcion, val_fechasolicitud as fechatur, 0000 as Horas;
		, val_codservvale as codserv, 0000 as consulta ;
		,0000  as practica, 0000 as pe,mwktotval.ESP_cantsinturno;
		,totc1, totc2, totd1, totd2,mwklista1.horas as espe,mwktotval.esp_codesp ;
		from mwktotval left outer join mwklista1 on ;
		(mwklista1.ESP_descripcion = mwktotval.ESP_descripcion &mjoin ) ;
		order by mwktotval.ESP_descripcion ;
		into cursor mwklistav
else
	select mwktotval.ESP_descripcion, val_fechasolicitud as fechatur, 0000 as Horas;
		, val_codservvale as codserv, ;
		iif(dow(val_fechasolicitud) = 2, 'Lunes     ', iif(dow(val_fechasolicitud) = 3, 'Martes    ', ;
		iif(dow(val_fechasolicitud) = 4, 'Miércoles ', iif(dow(val_fechasolicitud) = 5, 'Jueves    ', ;
		iif(dow(val_fechasolicitud) = 6, 'Viernes   ', iif(dow(val_fechasolicitud) = 7, 'Sabado    ', ;
		'Domingo   ')))))) as dia, ;
		0000 as consulta, 0000  as practica, 0000 as pe,mwktotval.ESP_cantsinturno ;
		,totc1, totc2, totd1, totd2,mwklista1.horas as espe,mwktotval.esp_codesp ;
		from mwktotval left outer join mwklista1 on ;
		(mwklista1.ESP_descripcion = mwktotval.ESP_descripcion &mjoin ) ;
		order by mwktotval.ESP_descripcion ;
		into cursor mwklistav
endif
select * from mwklistat ;
	union select * from mwklistav ;
	where isnull(espe) and ESP_codesp in (select  codesp from Mwkmedpresf);
	into cursor mwklista

*!*	if used('Mwkmedpre00')
*!*		select Mwkmedpre00
*!*		use
*!*	endif

*!*	if used('Mwkmedpre01')
*!*		select Mwkmedpre01
*!*		use
*!*	endif
*!*	if used('Mwkmedpre0')
*!*		select Mwkmedpre0
*!*		use
*!*	endif
*!*	if used('Mwkmedpre1')
*!*		select Mwkmedpre1
*!*		use
*!*	endif
*!*	if used('Mwkmedpre2')
*!*		select Mwkmedpre2
*!*		use
*!*	endif
*!*	if used('Mwkmedpre3')
*!*		select Mwkmedpre3
*!*		use
*!*	endif
*!*	if used('Mwkmedpresf')
*!*		select Mwkmedpresf
*!*		use
*!*	endif


*!*	if used('mwktodosa1')
*!*		select mwktodosa1
*!*		use
*!*	endif
*!*	if used('mwktodosa')
*!*		select mwktodosa
*!*		use
*!*	endif
*!*	if used('mwktodosu')
*!*		select mwktodosu
*!*		use
*!*	endif
*!*	if used('mwktodosl')
*!*		select mwktodosl
*!*		use
*!*	endif
*!*	if used('mwktodosb')
*!*		select mwktodosb
*!*		use
*!*	endif
*!*	if used('mwktodosb1')
*!*		select mwktodosb1
*!*		use
*!*	endif
*!*	if used('mwktodosb2')
*!*		select mwktodosb2
*!*		use
*!*	endif
*!*	if used('mwktodosc')
*!*		select mwktodosc
*!*		use
*!*	endif
*!*	if used('mwktodost')
*!*		select mwktodost
*!*		use
*!*	endif
*!*	if used('mwktodosc1')
*!*		select mwktodosc1
*!*		use
*!*	endif
*!*	if used('mwktodosc2')
*!*		select mwktodosc2
*!*		use
*!*	endif
*!*	if used('mwktodos')
*!*		select mwktodos
*!*		use
*!*	endif
*!*	if used('mwklista1')
*!*		select mwklista1
*!*		use
*!*	endif
*!*	if used('mwktotval1')
*!*		select mwktotval1
*!*		use
*!*	endif
*!*	if used('mwktotval')
*!*		select mwktotval
*!*		use
*!*	endif
*!*	if used('mwktotval2')
*!*		select mwktotval2
*!*		use
*!*	endif
