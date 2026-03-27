****
** Listado estadistico para Morgulis primero disponible, cantidad ocupados, libres
** Modificado por Claudia el 13/6/03 lineas 12 y 13 de ambos querys
****

Parameter mfecdes, mfechas, mbusco1, mlista, mbusco, mbusco2, mbusco3,mbusco2f,mpe
If used('dias')
	Use in dias
Endif

Create cursor dias (fechatur D,diasem n )
For i = 0 to mfechas - mfecdes
	mdias = mfecdes + i
	Insert into dias ( fechatur,diasem  ) values ( mdias, dow(mdias) )
Next
If mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
	mcjoinvales = " inner join pacientes on valesasist.VAL_codadmision = pacientes.pac_codadmision "
	mbusco2  = mbusco2  + " and pac_codambito=?mxambito "
Else
	mccpoamb = ''
	mcjoinvales = " inner join pacientes on valesasist.VAL_codadmision = pacientes.pac_codadmision "

Endif
mret = sqlexec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	'  where &mccpoamb id<100000 order by fechacierre ','mwkctrlfecha')
If mret < 0
	=aerr(eros)
	Do prg_error with eros,'sp_lista_rendi_profe1'
	Cancel
Endif
Go bottom in mwkctrlfecha
mfechalimite = mwkctrlfecha.fechacierre
Use in mwkctrlfecha

****
** busco los vales en valesasist
****
If mpe=2
	mret =sqlexec(mcon1, "select VAL_codservvale " + ;
		",pia_cantsolicitada,pia_codprest,val_prestador  "+;
		", VAL_circuitoorigen, VAL_fechasolicitud,pac_centromedico,cob_codentidad " + ;
		"from valesasist,presinsuvas,coberturas  "+;
		" inner join pacientes on valesasist.VAL_codadmision = pacientes.pac_codadmision "+;
		" where VAL_codsector = 'AMB' and VAL_fechasolicitud >= ?mfecdes and " + ;
		" VAL_codadmision = COB_pacientes and "+;
		"VAL_fechasolicitud <= ?mfechas and valesasist = pia_valesasist " + ;
		" and VAL_codservvale not in (7000,6400) " + mbusco2  , "mwktotval2")
Else
	mret =sqlexec(mcon1, "select VAL_codservvale " + ;
		",pia_cantsolicitada,pia_codprest,val_prestador  "+;
		", VAL_circuitoorigen, VAL_fechasolicitud,pac_centromedico " + ;
		"from valesasist, presinsuvas  "+;
		" inner join pacientes on valesasist.VAL_codadmision = pacientes.pac_codadmision "+;
		" where VAL_codsector = 'AMB' and VAL_fechasolicitud >= ?mfecdes and " + ;
		"VAL_fechasolicitud <= ?mfechas and valesasist = pia_valesasist " + ;
		" and VAL_codservvale not in (7000,6400) "+ mbusco2  , "mwktotval2")
Endif

If mret < 0
	=aerr(eros)
	Do prg_error with eros,'sp_lista_rendi_profe2'
	Cancel
Endif

Use in select("mwkespecag")
mret = sqlexec(mcon1,"select TE_codambito, TE_codesp,TE_codespag"+;
	" from Tabespecialid where TE_codambito = ?mxambito ", "mwkespecag")

mret =	sqlexec(mcon1, "select pre_codprest,pre_especialidad,PRE_agendaturnos " + ;
	",ESP_codesp, ESP_descripcion "+ ;
	"from prestacions "+;
	"inner join especialid on trim(pre_especialidad) = trim(ESP_codesp) " + ;
	" where PRE_codservicio > 0 group by  pre_codprest" , "mwkpres")

*!*	mret=sqlexec(mcon1," SELECT ESP_codesp, ESP_descripcion FROM especialid " + ;
*!*		" WHERE ESP_descripcion is not Null and ESP_genagendaturno <>'N' " ,"MWKpesp")

If mret < 0
	=aerr(eros)
	Do prg_error with eros,'sp_lista_rendi_profe3'
	Cancel
Endif

mgroup = iif( mlista = 1,'',', val_prestador ')

If mfechas < ctod("04/09/2022") &&&inicio Lima
	Select *,sum(pia_cantsolicitada ) as total from mwktotval2,mwkpres ;
		where 	pre_codprest = pia_codprest &mbusco2f ;
		group by pre_especialidad, VAL_codservvale, VAL_circuitoorigen &mgroup ;
		into cursor mwktotval1

Else

	Select *,sum(pia_cantsolicitada ) as total from mwktotval2,mwkpres ;
		where nvl(pac_centromedico,1) = mxcentromedico and 	pre_codprest = pia_codprest &mbusco2f ;
		group by pre_especialidad, VAL_codservvale, VAL_circuitoorigen &mgroup ;
		into cursor mwktotval1
Endif
mret    = sqlexec(mcon1,"Select id, (piso || descrip || numero) as lugar"+;
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
	" group by codmed, medpresta.codesp, diasem, fecvigenh, hdesde1,demanda ","Mwkmedprea")

Select Mwkmedprea.* From Mwkmedprea,Mwkqcon;
	where  Mwkmedprea.sala = lugar;
	INTO Cursor Mwkmedpre
If mret < 0
	=aerr(eros)
	Do prg_error with eros,'sp_lista_rendi_profe4'
	Cancel
Endif
Select Mwkmedpre.*;
	from Mwkmedpre ;
	into cursor Mwkmedpre0

Select *,100 as porc from Mwkmedpre0 ;
	where transf(codmed)+transf(diasem)+ttoc(hdesde1)  not in (select transf(codmed)+transf(diasem)+ttoc(hdesde1) from Mwkmedpre0 ;
	group by codmed, diasem, fecvigenh, hdesde1 ;
	having count(codesp)>1) order by codmed, diasem, fecvigenh, hdesde1 ;
	into cursor Mwkmedpre1

Select * from Mwkmedpre0 ;
	where transf(codmed)+transf(diasem)+ttoc(hdesde1) in (select transf(codmed)+transf(diasem)+ttoc(hdesde1) from Mwkmedpre0 ;
	group by codmed, diasem, fecvigenh, hdesde1 ;
	having count(codesp)>1) order by codmed, diasem, fecvigenh, hdesde1 ;
	into cursor Mwkmedpre2

Select *,iif(codesp= 'GINE',60.00,iif(codesp= 'OBST',40.00,;
	iif(codesp= 'OFTA',80.00,iif(codesp= 'OFTI',20.00,;
	iif(codesp= 'NEUF',60.00,iif(codesp= 'NFII',40.00,;
	iif(codesp= 'CIVP',80.00,iif(codesp= 'CIRC',20.00,;
	iif(codesp= 'NUTI',50.00,iif(codesp= 'DIAI',50.00,99.99)))))))))) as porc ;
	from Mwkmedpre2 into cursor Mwkmedpre3

Select * from Mwkmedpre1 ;
	union select * from Mwkmedpre3 into cursor Mwkmedpre

mret = sqlexec(mcon1, "select turnos.id,afiliado, fechatur, horatur, codmed, turnos.codesp, " + ;
	"tipoturno, confirmado, turnos.diasem,hhmmtur " + ;
	", turnos.codserv,codprest,turnos.codent "  + ;
	"from turnos " + ;
	" where &mccpoamb fechatur >= ?mfecdes and fechatur <= ?mfechas  and turnos.codserv<>7000 "+;
	" and (turnos.tipoturno < 8 or turnos.tipoturno >=13) " +	mbusco3 , "mwktodosc1")

If mret < 0
	=aerr(eros) turnos.codreserva<>'' and 
	Do prg_error with eros,'sp_lista_rendi_profe5'
	Cancel
Endif

mret = sqlexec(mcon1, "select turnos.id,afiliado, fechatur, horatur, codmed, turnos.codesp, " + ;
	"tipoturno, confirmado, turnos.diasem,hhmmtur, turnos.codserv ,codprest,turnos.codent  " + ;
	"from turnos " + ;
	"where &mccpoamb afiliado <= 1 " + ;
	" and fechatur >= ?mfecdes and fechatur <= ?mfechas  and turnos.codserv<>7000 "+;
	" and (turnos.tipoturno < 8 or turnos.tipoturno >=13) " + mbusco1 , "mwktodosl1")
If mret < 0
	=aerr(eros)
	Do prg_error with eros,'sp_lista_rendi_profe6'
	Cancel
Endif


If mfecdes <= mfechalimite
	mret = sqlexec(mcon1, "select turnos.id,afiliado, fechatur, horatur, codmed, turnos.codesp, " + ;
		"tipoturno, confirmado, turnos.diasem,hhmmtur " + ;
		", turnos.codserv,codprest,turnos.codent " + ;
		"from turnoshis as turnos " + ;
		"where &mccpoamb turnos.codreserva<>'' and  turnos.fechatur >= ?mfecdes and turnos.fechatur <= ?mfechas  "+;
		" and turnos.codserv<>7000 " + ;
		mbusco3 , "mwktodosc2a")

	If mret < 0
		=aerr(eros)
		Do prg_error with eros,'sp_lista_rendi_profe7'
		Cancel
	Endif
	Select * from mwktodosc2a where (tipoturno < 8 or tipoturno >=13) into cursor mwktodosc2
	mret = sqlexec(mcon1, "select turnos.id,afiliado, fechatur, horatur, codmed, turnos.codesp, " + ;
		"tipoturno, confirmado, turnos.diasem,hhmmtur, turnos.codserv,codprest,turnos.codent   " + ;
		"from turnoshis as turnos " + ;
		"where &mccpoamb afiliado <= 1  and turnos.codserv<>7000 " + ;
		" and turnos.fechatur >= ?mfecdes and turnos.fechatur <= ?mfechas "+;
		" " + mbusco1 , "mwktodosl2a")
	If mret < 0
		=aerr(eros)
		Do prg_error with eros,'sp_lista_rendi_profe8'
		Cancel
	Endif
	Select * from mwktodosl2a where (tipoturno < 8 or tipoturno >=13) into cursor mwktodosl2
	If reccount('mwktodosc1')>0
		Select *,iif(afiliado <= 1,id, afiliado) as afi from mwktodosc1 ;
			union all ;
			select *,iif(afiliado <= 1,id, afiliado) as afi  from mwktodosc2 ;
			into cursor mwktodos
	Else
		Select *,iif(afiliado <= 1,id, afiliado) as afi  from mwktodosc2 ;
			into cursor mwktodos
	Endif

	If reccount('mwktodosl1')>0
		Select *,id as afi from mwktodosl1 ;
			union all ;
			select *,id as afi  from mwktodosl2 ;
			into cursor mwktodosl
	Else
		Select *,id as afi  from mwktodosl2 ;
			into cursor mwktodosl
	Endif

Else
	Select *,iif(afiliado <= 1,id, afiliado) as afi   from mwktodosc1 ;
		into cursor mwktodos


	Select *,id as afi from mwktodosl1  ;
		into cursor mwktodosl
Endif


Select mwktodos.*,nombre,Mwkmedpre.porc,Mwkmedpre.hdesde1, Mwkmedpre.hhasta1, hhmmDes, hhmmHas   ;
	,ESP_codesp, ESP_descripcion  ;
	from mwktodos, mwkpres,Mwkmedpre  ;
	where mwktodos.codesp = trim(ESP_codesp) &mbusco;
	and mwktodos.fechatur >= Mwkmedpre.fecvigend and ;
	mwktodos.fechatur <  Mwkmedpre.fecvigenh and ;
	hhmmtur >= Mwkmedpre.hhmmDes and hhmmtur<Mwkmedpre.hhmmHas and ;
	mwktodos.codmed = Mwkmedpre.codmed and ;
	mwktodos.codesp = Mwkmedpre.codesp and ;
	mwktodos.diasem = Mwkmedpre.diasem ;
	into cursor mwktodoscsa

Select * from mwktodoscsa;
	group by afi,codmed, codesp, horatur, tipoturno ;
	into cursor mwktodosc


Select mwktodosl.id,mwktodosl.afiliado, mwktodosl.fechatur, mwktodosl.horatur;
	, mwktodosl.codmed, Mwkmedpre.codesp, mwktodosl.tipoturno;
	, mwktodosl.confirmado, mwktodosl.diasem, mwktodosl.hhmmtur, mwktodosl.codserv,Mwkmedpre.codprest,mwktodosl.codent;
	, mwktodosl.afi,nombre,Mwkmedpre.porc,Mwkmedpre.hdesde1, Mwkmedpre.hhasta1  ;
	, hhmmDes, hhmmHas ;
	,ESP_codesp, ESP_descripcion  ;
	from mwktodosl,Mwkmedpre left join mwkpres on Mwkmedpre.codesp = trim(ESP_codesp);
	where  mwktodosl.afiliado <= 1 and mwktodosl.fechatur >= Mwkmedpre.fecvigend and ;
	mwktodosl.fechatur <  Mwkmedpre.fecvigenh and ;
	hhmmtur >= Mwkmedpre.hhmmDes and hhmmtur<Mwkmedpre.hhmmHas and ;
	mwktodosl.codmed = Mwkmedpre.codmed and ;
	mwktodosl.diasem = Mwkmedpre.diasem &mbusco;
	into cursor mwktodosclsa

Select * from mwktodosclsa;
	group by afi,codmed, codesp, horatur, tipoturno ;
	into cursor mwktodoscl

Select * from mwktodoscl;
	union select * from mwktodosc where !isnull(porc)  ;
	into cursor mwktodoscc

Select fechatur, codmed, codserv, codesp, tipoturno,afiliado from mwktodoscc into cursor mwktodosb

*** busca medicos de demanda espontanea
Select id,afiliado, dias.fechatur, horatur,codesp, ;
	tipoturno, confirmado, dias.diasem,hhmmtur ,codserv,codent from dias,mwktodos;
	where dias.fechatur= mwktodos.fechatur group by dias.fechatur into cursor mwkdias

Select mwkdias.id,afiliado, fechatur, horatur, Mwkmedpre.nombre;
	, hhmmtur, 2200 as codserv,2 as codent,recno("Mwkmedpre") as afi,porc,hdesde1, hhasta1,generaagen ;
	,Mwkmedpre.codmed,Mwkmedpre.codesp,Mwkmedpre.diasem,demanda,hhmmDes, hhmmHas  ;
	,ESP_codesp, ESP_descripcion  ;
	from Mwkmedpre left join mwkpres on Mwkmedpre.codesp = trim(ESP_codesp);
	left join mwkdias on (fechatur >= fecvigend and fechatur <  fecvigenh and ;
	(fechatur > bloquehasta  or fechatur < bloquedesde ) and ;
	mwkdias.diasem = Mwkmedpre.diasem );
	where demanda = 1 ;
	group by Mwkmedpre.codesp, Mwkmedpre.codmed, fechatur, hhmmDes, hhmmHas;
	into cursor mwktodosaD1

Select iif(mxambito = 1,306,122)  as codmed, "MEDICO DEMANDA ESPONTANEA" as nombre, fechatur,ESP_descripcion, sum(round(((hhasta1 - hdesde1)*porc/100 /3600), 2)) as horas;
	,codserv,codent, codesp ;
	from mwktodosaD1 ;
	group by codesp ;
	order by codesp ;
	into cursor mwktodosaD

If mlista = 1

	Select ESP_descripcion ,nombre, fechatur, hdesde1, hhasta1, ;
		codmed, codesp,tipoturno,porc,codserv,codent ;
		from mwktodoscc ;
		group by codesp, codmed, fechatur,hhmmDes, hhmmHas ;
		order by codesp, codmed, fechatur, hdesde1 ;
		into cursor mwktodosa1

	Select ESP_descripcion, sum(round(((hhasta1 - hdesde1)*porc/100 /3600), 2)) as horas, codesp,tipoturno ,codserv,codent;
		from mwktodosa1 ;
		group by codesp ;
		order by codesp, codmed ;
		into cursor mwktodosa

	Select a.ESP_descripcion,afiliado, b.fechatur, b.codserv,b.codent, a.horas,b.tipoturno ;
		from mwktodosa as a, mwktodosb as b ;
		where a.codesp = b.codesp ;
		into cursor mwktodos
Else
	Select ESP_descripcion ,nombre, fechatur, hdesde1, hhasta1, ;
		codmed, codesp,tipoturno,porc,codserv,codent ;
		from mwktodoscc ;
		group by codesp, codmed, fechatur, hhmmDes, hhmmHas ;
		order by codesp, codmed, fechatur, hdesde1 ;
		into cursor mwktodosa1

	Select ESP_descripcion, sum(round(((hhasta1 - hdesde1)*porc/100 /3600), 2)) as horas;
		,fechatur , codesp,tipoturno ,codmed,nombre,codserv,codent ;
		from mwktodosa1 ;
		group by codesp,codmed ;
		order by codesp,codmed ;
		into cursor mwktodosa


	Select a.ESP_descripcion, a.nombre,a.codmed,afiliado, b.fechatur, b.codserv,codent, a.horas,b.tipoturno ;
		from mwktodosa as a, mwktodosb as b ;
		where a.codesp = b.codesp and b.codmed=a.codmed;
		into cursor mwktodos
Endif

If mlista = 1
	Select ESP_descripcion, horas, codserv,codent,"" as nombre, ;
		sum(iif(codserv = 2200 and afiliado > 1 , 1, 0000)) as consulta, ;
		sum(iif(codserv <> 2200 and afiliado > 1 , 1, 0000)) as practica, ;
		sum(iif(afiliado <= 1 , 1, 0000)) as libres, ;
		sum(iif(INLIST(codent,100,101,106), 1, 0)) as pe,0 as codmed ;
		from mwktodos ;
		group by ESP_descripcion ;
		order by ESP_descripcion ;
		into cursor mwklista1

Else
	Select ESP_descripcion, horas, codserv,codent,nombre, ;
		sum(iif(codserv = 2200 and afiliado > 1 , 1, 0000)) as consulta, ;
		sum(iif(codserv <> 2200 and afiliado > 1 , 1, 0000)) as practica, ;
		sum(iif(afiliado <= 1 , 1, 0000)) as libres, ;
		sum(iif(INLIST(codent,100,101,106), 1, 0)) as pe,codmed ;
		from mwktodos ;
		group by ESP_descripcion, codmed ;
		order by ESP_descripcion, nombre ;
		into cursor mwklista1
Endif

Select ESP_codesp as ESPcodesp , ESP_descripcion as ESPdescripcion, VAL_codservvale,VAL_fechasolicitud,val_prestador, ;
	sum(iif(VAL_codservvale  = 2200 and (VAL_circuitoorigen = '1' or isnull(VAL_circuitoorigen)) , total, 00000)) as totc1, ;
	sum(iif(VAL_codservvale  = 2200 and VAL_circuitoorigen = '2', total, 00000)) as totc2, ;
	sum(iif(VAL_codservvale <> 2200 and (VAL_circuitoorigen = '1' or isnull(VAL_circuitoorigen)), total, 00000)) as totd1, ;
	sum(iif(VAL_codservvale <> 2200 and VAL_circuitoorigen = '2', total, 00000)) as totd2 ;
	from mwktotval1 ;
	group by ESPdescripcion  &mgroup ;
	order by ESPdescripcion  &mgroup into cursor mwktotval

mjoin = iif(mlista=1,'','and val_prestador = codmed ')

Select mwklista1.*, ESPdescripcion,totc1, totc2, totd1, totd2 ;
	from mwktotval left outer join mwklista1 on ;
	(mwklista1.ESP_descripcion = mwktotval.ESPdescripcion &mjoin ) ;
	order by mwklista1.ESP_descripcion ;
	into cursor mwklistat

Select mwklista1.*, ESPdescripcion,totc1, totc2, totd1, totd2 ;
	from mwktotval left outer join mwklista1 on ;
	(mwklista1.ESP_descripcion = mwktotval.ESPdescripcion and val_prestador = codmed  ) ;
	order by mwklista1.ESP_descripcion ;
	into cursor mwklistatD

Select ESPdescripcion as ESP_descripcion,mwktodosaD.horas as horas, 2200 as codserv,2 as codent;
	,"MEDICO DEMANDA ESPONTANEA" as nombre, ;
	sum(0) as consulta, sum(0) as practica, sum(0) as libres, sum(0) as pe,iif(mxambito = 1,306,122)  as codmed ;
	, sum(totc1) as totc1 , sum(totc2) as totc2, sum(totd1) as totd1;
	, sum(totd2) as totd2 ;
	from mwklistatD ,mwktodosaD ;
	where isnull(mwklistatD.nombre) ;
	and ESPdescripcion = mwktodosaD.ESP_descripcion;
	group by ESPdescripcion into cursor mwklistad

Select ESP_descripcion,horas, codserv,codent,padr(nombre,50) as nombre,consulta, practica, libres, pe,codmed ;
	, totc1, totc2, totd1, totd2 from mwklistat where !isnull(nombre);
	union select ESP_descripcion,horas, codserv,codent,padr(nombre,50) as nombre,consulta, practica, libres, pe,codmed ;
	, totc1, totc2, totd1, totd2  from mwklistad into cursor mwklista
If mlista = 1
	Select ESP_descripcion,sum(horas) as horas, codserv,codent,padr(nombre,50) as nombre;
		,max(consulta) as consulta, max(practica) as practica, max(libres) as libres;
		, max(pe) as pe ,codmed ;
		, max(totc1) as totc1, max(totc2) as totc2,max(totd1) as totd1,max(totd2) as totd2;
		from mwklista group by ESP_descripcion into cursor mwklista

Endif
If used('mwktodosa1')
	Select mwktodosa1
	Use
Endif
If used('mwktodosa')
	Select mwktodosa
	Use
Endif
If used('mwktodosb')
	Select mwktodosb
	Use
Endif
If used('mwktodosb1')
	Select mwktodosb1
	Use
Endif
If used('mwktodosb2')
	Select mwktodosb2
	Use
Endif
If used('mwktodosc')
	Select mwktodosc
	Use
Endif
If used('mwktodoscc')
	Select mwktodoscc
	Use
Endif
If used('mwktodoscl')
	Select mwktodoscl
	Use
Endif

If used('mwktodosc1')
	Select mwktodosc1
	Use
Endif
If used('mwktodosc2')
	Select mwktodosc2
	Use
Endif
If used('mwktodos')
	Select mwktodos
	Use
Endif
If used('mwklista1')
	Select mwklista1
	Use
Endif
If used('mwktotval1')
	Select mwktotval1
	Use
Endif
If used('mwktotval')
	Select mwktotval
	Use
Endif

If used('mwktodoscsa8')
	Use in mwktodoscsa8
Endif

