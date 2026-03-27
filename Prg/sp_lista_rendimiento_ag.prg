****
** Rendimiento por especialidad
****
****  ESP_cantsinturno es el rendimiento esperado x 10 (xq no acepta decimales)

Parameter mfecdes, mfechas, mbusco1, mlista, mbusco, mbusco2, mbusco3,mbusco2f,mpe


mfinde = 1
If mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
	mcjoinvales = " inner join pacientes on valesasist.VAL_codadmision = pacientes.pac_codadmision "
	mbuscov  =  " and pac_codambito=?mxambito "
Else
	mccpoamb = ''
	mbuscov  = ''
	mcjoinvales = ""
Endif

mret = sqlexec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	'  where &mccpoamb id<100000 order by fechacierre ','mwkctrlfecha')
If mret < 0
	=aerr(eros)
	Do prg_error with eros,'sp_lista_rendimiento1'
Endif
Go bottom in mwkctrlfecha
mfechalimite = mwkctrlfecha.fechacierre
Use in mwkctrlfecha
mbusco20 = ''

If mfinde = 0
	mbusco1	= mbusco1 + " and diasem not in(1,7) "
	mbusco3	= mbusco3 + " and turnos.diasem not in(1,7) "
	mbusco2	= mbusco2 + " and !inlist(dow(VAL_fechasolicitud), 1,7) "
	mbusco20 = " where !inlist(dow(VAL_fechasolicitud), 1,7) "
Endif
mret    = sqlexec(mcon1,"Select id, (piso || descrip || numero) as lugar"+;
	",cast (0 as integer) as esta  from tabubicacion "+;
	" where   centromedico   = ?mxcentromedico   "+;
	" and codambito = ?mxambito order by piso, numero ",'Mwkqcon')

mret = sqlexec(mcon1, " select codmed, diasem, fecvigend,codesp "+;
	", fecvigenh,  hdesde1, hhasta1, horadesde, horahasta,sala "+;
	", hhmmDes, hhmmHas " +;
	" from medpresta"+;
	" where &mccpoamb diasem > 0 &mbusco1 "+;
	" and fecvigenh > ?mfecdes and fecvigend <= ?mfechas "+;
	" and fecvigenh <> fecvigend "+;
	" group by codmed, codesp, diasem, fecvigenh, hdesde1 ","Mwkmedprea")
If mret < 0
	=aerr(eros)
	Do prg_error with eros,'sp_lista_rendimiento2'
	Cancel
Endif
Select Mwkmedprea.* From Mwkmedprea,Mwkqcon;
	where  Mwkmedprea.sala = lugar;
	INTO Cursor Mwkmedpre0

Use in select("mwkespecag")
mret = sqlexec(mcon1,"select TE_codambito, TE_codesp,TE_codespag"+;
	" from Tabespecialid where TE_codambito = ?mxambito ", "mwkespecag")
If used("MWKespec1")
	Use in mwkespec1
Endif
mret=sqlexec(mcon1," SELECT ESP_codesp, ESP_descripcion ,ESP_cantsinturno"+;
	" FROM especialid " + ;
	" WHERE ESP_descripcion is not Null " +;
	" ORDER BY ESP_descripcion","MWKespec1")

Select ESP_codesp, ESP_cantsinturno,TE_codesp,TE_codespag;
	from mwkespec1 left join mwkespecag on ESP_codesp = TE_codesp;
	into cursor mwkespea

Select nvl(TE_codespag,ESP_codesp) as  ESP_codesp, ESP_cantsinturno;
	,ESP_codesp as codespsa;
	from mwkespea;
	into cursor mwkespecnv

Select codmed, diasem, fecvigend,ESP_codesp as codesp, fecvigenh,  hdesde1, hhasta1, horadesde;
	, horahasta, hhmmDes, hhmmHas ,100 as porc,codespsa ;
	from Mwkmedpre0 ,mwkespecnv where codespsa = codesp ;
	into cursor Mwkmedpre
If mxambito >1
	mccpoamb = "  turnos.codambito = ?mxambito and "
Else
	mccpoamb = ''
Endif

&&especialid.ESP_descripcion ,ESP_cantsinturno
&&	" inner join especialid on turnos.codesp = trim(especialid.ESP_codesp) "

mret = sqlexec(mcon1, "select turnos.id,afiliado, fechatur, horatur, codmed, nombre,turnos.codesp, " + ;
	"tipoturno, confirmado, turnos.diasem,hhmmtur " + ;
	", turnos.codserv " + ;
	" from turnos "+;
	" left join prestadores on turnos.codmed = prestadores.id "+;
	" where  &mccpoamb  turnos.codreserva<>'' and (turnos.tipoturno < 8 or turnos.tipoturno >=13) " + ;
	" and turnos.fechatur >= ?mfecdes and turnos.fechatur <= ?mfechas and turnos.codserv<>7000 " + ;
	+ mbusco3 , "mwktodosc10")

If mret < 0
	=aerr(eros)
	Do prg_error with eros,'sp_lista_rendimiento3'
	Cancel
Endif
Select * from mwktodosc10 where fechatur >= mfecdes and fechatur <= mfechas ;
	into cursor mwktodosc1

Select fechatur, codmed, codserv, codesp, tipoturno from mwktodosc1 ;
	where afiliado > 1 into cursor mwktodosb1


If mfecdes <= mfechalimite
	mret = sqlexec(mcon1, "select turnos.id,afiliado, fechatur, horatur, codmed, nombre,turnos.codesp, " + ;
		"tipoturno, confirmado, turnos.diasem,hhmmtur " + ;
		", turnos.codserv " + ;
		" from turnoshis as turnos " + ;
		" left join prestadores on turnos.codmed = prestadores.id "+;
		" where &mccpoamb  turnos.codreserva<>'' and (turnos.tipoturno < 8 or turnos.tipoturno >=13) " + ;
		" and turnos.fechatur >= ?mfecdes and turnos.fechatur <= ?mfechas " + ;
		"  and turnos.codserv<>7000 " + mbusco3 , "mwktodosc2")

	If mret < 0
		=aerr(eros)
		Do prg_error with eros,'sp_lista_rendimiento4'
		Cancel
	Endif
	Select fechatur, codmed, codserv, codesp, tipoturno from mwktodosc2;
		where afiliado > 1  into cursor mwktodosb2

	If reccount('mwktodosc1')>0
		Select *,iif(afiliado <= 1,id, afiliado) as afi from mwktodosc1 ;
			union all ;
			select *,iif(afiliado <= 1,id, afiliado) as afi  from mwktodosc2 ;
			into cursor mwktodos
	Else
		Select *,iif(afiliado <= 1,id, afiliado) as afi  from mwktodosc2 ;
			into cursor mwktodos
	Endif

	If reccount('mwktodosb1')>0
		Select * from mwktodosb1 ;
			union all ;
			select * from mwktodosb2 ;
			into cursor mwktodosb0
	Else
		Select * from mwktodosb2 ;
			into cursor mwktodosb0
	Endif

	Select mwktodosb0.*,ESP_cantsinturno ,ESP_codesp,codespsa ;
		from mwktodosb0 ;
		inner join mwkespecnv on mwkespecnv.codespsa = mwktodosb1.codesp ;
		into cursor mwktodosb
Else
	Select *,iif(afiliado <= 1,id, afiliado) as afi   from mwktodosc1 ;
		into cursor mwktodos

	Select mwktodosb1.*,ESP_cantsinturno ,ESP_codesp,codespsa ;
		from mwktodosb1 ;
		inner join mwkespecnv on mwkespecnv.codespsa = mwktodosb1.codesp ;
		into cursor mwktodosb
Endif


Select mwktodos.*,Mwkmedpre.porc,Mwkmedpre.hdesde1, Mwkmedpre.hhasta1,ESP_cantsinturno ,ESP_codesp ;
	from mwktodos ;
	inner join mwkespecnv on mwkespecnv.codespsa = mwktodos.codesp ;
	inner join Mwkmedpre on (mwktodos.fechatur >= Mwkmedpre.fecvigend and ;
	mwktodos.fechatur <  Mwkmedpre.fecvigenh and ;
	hhmmtur >= Mwkmedpre.hhmmDes and hhmmtur<Mwkmedpre.hhmmHas and ;
	mwktodos.codmed = Mwkmedpre.codmed and ;
	mwktodos.codesp = Mwkmedpre.codespsa and ;
	mwktodos.diasem = Mwkmedpre.diasem );
	where 1= 1 &mbusco;
	group by afi,mwktodos.codmed, mwktodos.codesp, fechatur, horatur, tipoturno ;
	into cursor mwktodosc

If mlista = 1

	Select codesp ,nombre, fechatur, hdesde1, hhasta1, ;
		codmed, tipoturno,porc,ESP_cantsinturno ,ESP_codesp   ;
		from mwktodosc ;
		group by ESP_codesp, codmed, fechatur, hdesde1, hhasta1 ;
		order by ESP_codesp, codmed, fechatur, hdesde1 ;
		into cursor mwktodosa1

	Select sum(round(((hhasta1 - hdesde1)*porc/100 /3600), 2)) as horas, codesp,tipoturno,ESP_cantsinturno ,ESP_codesp   ;
		from mwktodosa1 ;
		group by ESP_codesp ;
		order by ESP_codesp, codmed ;
		into cursor mwktodosa

	Select a.codesp, b.fechatur, b.codserv, a.horas,b.tipoturno,a.ESP_cantsinturno ,a.ESP_codesp   ;
		from mwktodosa as a, mwktodosb as b ;
		where a.ESP_codesp = b.ESP_codesp ;
		into cursor mwktodos
Else
	Select codesp,nombre, fechatur, hdesde1, hhasta1, ;
		codmed, tipoturno,porc,ESP_cantsinturno ,ESP_codesp   ;
		from mwktodosc ;
		group by ESP_codesp, codmed, fechatur, hdesde1, hhasta1 ;
		order by ESP_codesp, codmed, fechatur, hdesde1 ;
		into cursor mwktodosa1

	Select sum(round(((hhasta1 - hdesde1)*porc/100 /3600), 2)) as horas;
		,fechatur , codesp,tipoturno,ESP_cantsinturno ,ESP_codesp   ;
		from mwktodosa1 ;
		group by ESP_codesp,fechatur ;
		order by ESP_codesp,fechatur ;
		into cursor mwktodosa

	Select a.codesp,b.fechatur, b.codserv, a.horas,b.tipoturno,a.ESP_cantsinturno ,a.ESP_codesp  ;
		from mwktodosa as a, mwktodosb as b ;
		where a.ESP_codesp = b.ESP_codesp and b.fechatur=a.fechatur;
		into cursor mwktodos
Endif

If mlista = 1
	Select codesp,fechatur, horas, codserv, ;
		sum(iif(codserv = 2200, 1, 0000)) as consulta, ;
		sum(iif(codserv <> 2200, 1, 0000)) as practica, ;
		sum(iif(tipoturno=7, 1, 0)) as pe,ESP_cantsinturno ,ESP_codesp   ;
		from mwktodos ;
		group by ESP_codesp ;
		into cursor mwklista1

Else
	Select codesp,fechatur, horas, codserv, ;
		iif(dow(fechatur) = 2, 'Lunes     ', iif(dow(fechatur) = 3, 'Martes    ', ;
		iif(dow(fechatur) = 4, 'Miércoles ', iif(dow(fechatur) = 5, 'Jueves    ', ;
		iif(dow(fechatur) = 6, 'Viernes   ', iif(dow(fechatur) = 7, 'Sabado    ', ;
		'Domingo   ')))))) as dia, ;
		sum(iif(codserv = 2200, 1, 0000)) as consulta, ;
		sum(iif(codserv <> 2200, 1, 0000)) as practica, ;
		sum(iif(tipoturno=7, 1, 0)) as pe,ESP_cantsinturno ,ESP_codesp   ;
		from mwktodos ;
		group by ESP_codesp, fechatur ;
		into cursor mwklista1
Endif

****
** busco los vales en valesasist
****
mseco = seconds()
If mpe=2

	mret =sqlexec(mcon1, "select VAL_codservvale " + ;
		",pia_cantsolicitada,pia_codprest,val_prestador,VAL_codvaleasist,pac_centromedico  "+;
		", VAL_circuitoorigen, VAL_fechasolicitud,(select cob_codentidad from coberturas " + ;
		" where COB_pacientes = VAL_codadmision ) as cob_codentidad ,VAL_codvaleasist "+;
		"from valesasist,presinsuvas "+ ;
		" inner join pacientes on valesasist.VAL_codadmision = pacientes.pac_codadmision "+;
		" where VAL_codsector = 'AMB' and VAL_fechasolicitud >= ?mfecdes and " + ;
		"VAL_fechasolicitud <= ?mfechas and valesasist = pia_valesasist " + mbuscov  +;
		"" , "mwktotval20")
	Select * from mwktotval20 where &mbusco2 into cursor mwktotval2

Else
	mret =sqlexec(mcon1, "select VAL_codservvale " + ;
		",pia_cantsolicitada,pia_codprest  "+;
		", VAL_circuitoorigen, VAL_fechasolicitud ,VAL_codvaleasist,pac_centromedico  " +;
		"from valesasist, presinsuvas "+;
		" inner join pacientes on valesasist.VAL_codadmision = pacientes.pac_codadmision "+;
		" where VAL_codsector = 'AMB' and VAL_fechasolicitud >= ?mfecdes and " + ;
		"VAL_fechasolicitud <= ?mfechas and valesasist = pia_valesasist " +mbuscov  + ;
		"" , "mwktotval20")
	Select * from mwktotval20 &mbusco20 into cursor mwktotval2
Endif
mseco2= seconds()
*wait windows (transf(mseco2-mseco)) nowait
&&" and "
If mret < 0
	=aerr(eros)
	Do prg_error with eros,'sp_lista_rendimiento5'
	Cancel
Endif


mret =	sqlexec(mcon1, "select pre_codprest,pre_especialidad ,PRE_agendaturnos " +;
	"from prestacions " , "mwkpres0")

If mret < 0
	=aerr(eros)
	Do prg_error with eros,'sp_lista_rendimiento6'
	Cancel
Endif
Select pre_codprest,pre_especialidad,ESP_codesp, ;
	PRE_agendaturnos, ESP_cantsinturno ;
	from mwkpres0,mwkespecnv where codespsa= pre_especialidad;
	into cursor mwkpres

mgroup = iif( mlista = 1,'',',VAL_fechasolicitud')

If mfechas < ctod("04/09/2022") &&&inicio Lima

	Select *,sum(pia_cantsolicitada ) as total from mwktotval2,mwkpres ;
		where 	pre_codprest = pia_codprest and PRE_agendaturnos='S' &mbusco2f ;
		group by pre_especialidad, VAL_codservvale, VAL_circuitoorigen &mgroup ;
		into cursor mwktotval1

Else

	Select *,sum(pia_cantsolicitada ) as total from mwktotval2,mwkpres ;
		where nvl(pac_centromedico,1) = mxcentromedico and 	pre_codprest = pia_codprest and PRE_agendaturnos='S' &mbusco2f ;
		group by pre_especialidad, VAL_codservvale, VAL_circuitoorigen &mgroup ;
		into cursor mwktotval1

Endif


Select ESP_codesp, VAL_codservvale,VAL_fechasolicitud, ;
	sum(iif(VAL_codservvale  = 2200 and (VAL_circuitoorigen = '1' or isnull(VAL_circuitoorigen)) , total, 00000)) as totc1, ;
	sum(iif(VAL_codservvale  = 2200 and VAL_circuitoorigen = '2', total, 00000)) as totc2, ;
	sum(iif(VAL_codservvale <> 2200 and (VAL_circuitoorigen = '1' or isnull(VAL_circuitoorigen)), total, 00000)) as totd1, ;
	sum(iif(VAL_codservvale <> 2200 and VAL_circuitoorigen = '2', total, 00000)) as totd2,ESP_cantsinturno;
	from mwktotval1 ;
	group by ESP_codesp  &mgroup ;
	order by ESP_codesp  &mgroup into cursor mwktotval

mjoin = iif(mlista=1,'','and VAL_fechasolicitud= fechatur')
Select mwklista1.*, totc1, totc2, totd1, totd2 ;
	from mwklista1 left outer join mwktotval on ;
	(mwklista1.ESP_codesp = mwktotval.ESP_codesp &mjoin ) ;
	order by mwklista1.ESP_codesp  ;
	into cursor mwklista

Select mwklista.*,esp_descripcion from mwklista,mwkespec1 ;
	where mwkespec1.ESP_codesp = mwklista.ESP_codesp  ;
	into cursor mwklista

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
