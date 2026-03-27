****
** Listado horas trabajadas
****
Parameter mfecdes, mfechas, mbuscom, mbuscot, mlista, mpermanente,mbuscoF

* set step on
mccpoamb = ''
if mxambito >1
	mccpoamb = "  and codambito = ?mxambito "
endif
mret = sqlexec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	'  where id<100000 order by fechacierre ','mwkctrlfecha')

Go bottom in mwkctrlfecha

mfechalimite = mwkctrlfecha.fechacierre

Use in mwkctrlfecha
If used('dias')
	Use in dias
Endif

Create cursor dias (fechatur D,diasem n )
For i = 0 to mfechas - mfecdes
	mdias = mfecdes + i
	mret=sqlexec(mcon1,"SELECT dia FROM feriaturnosA WHERE dia =?mdias",'MWKFeriados')
	If reccount('MWKFeriados')=0
		Insert into dias ( fechatur,diasem  ) values ( mdias, dow(mdias) )
	Endif
Next
qbusco = iif(empty(mbuscom ), '',strtran(mbuscom ,'tt','franjahoraria'))

mret = sqlexec(mcon1, "select codmed ,diasem, hhmmdes,hhmmhas, fecvigend, fecvigenh, tipoturno "+;
	" from franjahoraria "+;
	" where diasem > 0 "+ qbusco + mbuscoF  +;
	" and fecvigenh > ?mfecdes and fecvigend <= ?mfechas "+;
	" and fecvigenh <> fecvigend "+mccpoamb+;
	" group by codmed, diasem, fecvigenh, hhmmdes,hhmmhas,tipoturno ","Mwkfran0")

If mret < 0
	= aerr(eros)
	Messagebox(eros(3),16,'VALIDACION')
Endif
qbusco = iif(empty(mbuscot), '',strtran(mbuscot,'tt','medpresta'))

* Prestadores.
mret = sqlexec(mcon1, " select codmed, diasem, fecvigend,medpresta.codesp "+;
	", fecvigenh,  hdesde1, hhasta1, horadesde, horahasta, bloquedesde , bloquehasta  "+;
	", hhmmDes, hhmmHas,demanda,nombre as nn,generaagen,codserv " +;
	" from medpresta "+;
	" left join prestadores on medpresta.codmed = prestadores.id "+;
	" where 1=1 "+qbusco +;
	" and fecvigenh > ?mfecdes and fecvigend <= ?mfechas "+;
	" and fecvigenh <> fecvigend "+mccpoamb+;
	" ","Mwkmedpre00")

	use in select("mwkespecag")
	mret = sqlexec(mcon1,"select TE_codambito, TE_codesp,TE_codespag"+;
				" from Tabespecialid where TE_codambito = ?mxambito ", "mwkespecag")
	if used("MWKespec1")
		use in MWKespec1
	endif
	mret=sqlexec(mcon1," SELECT ESP_codesp, ESP_descripcion ,ESP_cantsinturno"+;
		" FROM especialid " + ;
		" WHERE ESP_descripcion is not Null  " +;
		" ORDER BY ESP_descripcion","MWKespec1")

select ESP_codesp, ESP_descripcion ,ESP_cantsinturno,TE_codesp,TE_codespag;
	from mwkespec1 left join mwkespecag on ESP_codesp = TE_codesp;
	into cursor mwkespea
	
select nvl(TE_codespag,ESP_codesp) as  ESP_codesp, ESP_descripcion ,ESP_cantsinturno;
	,ESP_codesp as codespsa;
	from mwkespea;
	into cursor mwkespecnv

Select codmed, diasem, fecvigend,ESP_codesp as codesp, fecvigenh,  hdesde1, hhasta1, horadesde, ;
	horahasta, bloquedesde , bloquehasta, hhmmDes, hhmmHas,nvl(demanda,0) as demanda,;
	ESP_descripcion ,nn,generaagen ,codserv,ttoc(hdesde1,2) as hdes1,codespsa  ;
	from Mwkmedpre00 ,mwkespecnv where codespsa = codesp ;
	into cursor Mwkmedpre01

Select * from Mwkmedpre01;
	group by codmed, codespsa,codserv,diasem, fecvigenh, hdes1 ;
	into cursor Mwkmedpre0

If mret < 0
	=aerr(eros)
	Messagebox(eros(3), 16, "Validacion")
ENDIF  

* Marcelo Torres, 03/05/2012.
* buscamos los bloqueos.
Do sp_busco_bloqueos_franja with mfecdes, mfechas, 0
mccpoamb = ''
if mxambito >1
	mccpoamb = "  and codambito = ?mxambito "
endif

If mpermanente

	Select Mwkmedpre0.codmed, Mwkmedpre0.diasem, Mwkfran0.fecvigend,Mwkmedpre0.codesp ;
		, Mwkfran0.fecvigenh, Mwkmedpre0.hdesde1, Mwkmedpre0.hhasta1, Mwkmedpre0.hdes1, Mwkmedpre0.horadesde;
		, Mwkmedpre0.horahasta, Mwkmedpre0.hhmmDes, Mwkmedpre0.hhmmHas,codserv,Mwkmedpre0.demanda,Mwkmedpre0.codespsa;
		,100 as porc, iif(tipoturno  = 7, 'PE',space(2)) as Franja,generaagen,tipoturno as tipofran ;
		,iif(demanda = 1,'DE','  ') as de,iif(demanda = 0 and generaagen = 0 ,'FI','  ') as FI,Mwkmedpre0.ESP_descripcion, nn, bloquedesde , bloquehasta ;
		from Mwkmedpre0 ;
		Inner join Mwkfran0 on (;
		Mwkmedpre0.codmed 	= Mwkfran0.codmed and  ;
		Mwkmedpre0.diasem 	= Mwkfran0.diasem and ;
		Mwkfran0.hhmmDes 	= Mwkmedpre0.hhmmDes and ;
		Mwkfran0.hhmmHas 	= Mwkmedpre0.hhmmHas and ;
		Mwkfran0.fecvigend 	<= Mwkmedpre0.fecvigend and ;
		Mwkfran0.fecvigenh 	>= Mwkmedpre0.fecvigenh );
		group by Mwkmedpre0.codmed, Mwkmedpre0.diasem, Mwkmedpre0.fecvigenh, ;
		Mwkmedpre0.hdes1,codserv,demanda,Franja ;
		order by Mwkmedpre0.codmed, Mwkmedpre0.diasem, Mwkmedpre0.fecvigenh, Mwkmedpre0.hdes1 ;
		into cursor Mwkmedpre

Else

	Select Mwkmedpre0.codmed, Mwkmedpre0.diasem, Mwkfran0.fecvigend,Mwkmedpre0.codesp ;
		, Mwkfran0.fecvigenh, Mwkmedpre0.hdesde1, Mwkmedpre0.hhasta1, Mwkmedpre0.hdes1, Mwkmedpre0.horadesde;
		, Mwkmedpre0.horahasta, Mwkmedpre0.hhmmDes, Mwkmedpre0.hhmmHas,codserv,Mwkmedpre0.demanda,Mwkmedpre0.codespsa;		
		,100 as porc, iif(tipoturno  = 7, 'PE',space(2)) as Franja,generaagen,tipoturno as tipofran ;
		,iif(demanda = 1,'DE','  ') as de,iif(demanda = 0 and generaagen = 0 ,'FI','  ') as FI,Mwkmedpre0.ESP_descripcion, nn, bloquedesde , bloquehasta ;
		from Mwkmedpre0 ;
		left join Mwkfran0 on (;
		Mwkmedpre0.codmed 	= Mwkfran0.codmed and  ;
		Mwkmedpre0.diasem 	= Mwkfran0.diasem and ;
		Mwkfran0.hhmmDes 	= Mwkmedpre0.hhmmDes and ;
		Mwkfran0.hhmmHas 	= Mwkmedpre0.hhmmHas and ;
		Mwkfran0.fecvigend 	<= Mwkmedpre0.fecvigend and ;
		Mwkfran0.fecvigenh 	>= Mwkmedpre0.fecvigenh );
		group by Mwkmedpre0.codmed, Mwkmedpre0.diasem, Mwkmedpre0.fecvigenh, ;
		Mwkmedpre0.hdes1,codserv,demanda,Franja ;
		order by Mwkmedpre0.codmed, Mwkmedpre0.diasem, Mwkmedpre0.fecvigenh, Mwkmedpre0.hdes1 ;
		into cursor Mwkmedpre
Endif
qbusco = iif(empty(mbuscom), '',strtran(mbuscom,'tt','turnos'))

mret = sqlexec(mcon1, "select turnos.id,afiliado, fechatur, horatur, codmed, nombre,turnos.codesp, " + ;
	"tipoturno, confirmado, turnos.diasem,hhmmtur,codprest " + ;
	", turnos.codserv " + ;
	"from turnos,prestadores  " + ;
	"where turnos.codmed = prestadores.id  " + ;
	" and turnos.fechatur >= ?mfecdes and turnos.fechatur <= ?mfechas " + ;
	" and turnos.tipoturno in (0,3,4,5,6,7) and turnos.afiliado <> 1 " + ;
	qbusco +mccpoamb, "mwktodosc1")

If mret < 0
	=aerr(eros)
	Messagebox("ERROR EN LA GENERACION DE CURSOR, REINTENTE", 13,"Validacion")
	Cancel
Endif

Select fechatur, codmed, codserv, codesp, tipoturno from mwktodosc1 into cursor mwktodosb1

If mfecdes <= mfechalimite

	mret = sqlexec(mcon1, "select turnos.id,afiliado, fechatur, horatur, codmed, nombre,turnos.codesp, " + ;
		"tipoturno, confirmado, turnos.diasem,hhmmtur,codprest " + ;
		", turnos.codserv " + ;
		"from turnoshis as turnos, prestadores " + ;
		"where turnos.codmed = prestadores.id "+;
		" and turnos.fechatur >= ?mfecdes and turnos.fechatur <= ?mfechas " + ;
		" and turnos.tipoturno in (0,3,4,5,6,7) " + qbusco + mccpoamb , "mwktodosc2")

	If mret < 0
		Messagebox("ERROR EN LA GENERACION DE CURSOR, REINTENTE", 13,"Validacion")
		Cancel
	Endif
	Select fechatur, codmed, codserv, codesp, tipoturno  from mwktodosc1 into cursor mwktodosb2

	If reccount('mwktodosc1')>0
		Select *,iif(afiliado = 0,id, afiliado) as afi,iif(tipoturno  = 7, 'PE',space(2)) as Franjat  ;
			from mwktodosc1 ;
			union all ;
			select *,iif(afiliado = 0,id, afiliado) as afi,iif(tipoturno  = 7, 'PE',space(2)) as Franjat ;
			from mwktodosc2 ;
			into cursor mwktodos
	Else
		Select *,iif(afiliado = 0,id, afiliado) as afi,iif(tipoturno  = 7, 'PE',space(2)) as Franjat ;
			from mwktodosc2 ;
			into cursor mwktodos
	Endif

	If reccount('mwktodosb1')>0
		Select * from mwktodosb1 ;
			union all ;
			select * from mwktodosb2 ;
			into cursor mwktodosb
	Else
		Select * from mwktodosb2 ;
			into cursor mwktodosb
	Endif

Else

	Select *,iif(afiliado = 0,id, afiliado) as afi,iif(tipoturno  = 7, 'PE',space(2)) as Franjat;
		from mwktodosc1 ;
		into cursor mwktodos

	Select * from mwktodosb1 into cursor mwktodosb

Endif

&& Demanda espontanea

*!* Agregado de group by mwktodos.franjat

Select id,afiliado, dias.fechatur, horatur, ;
	tipoturno, confirmado, dias.diasem,hhmmtur ,codserv from dias left join mwktodos;
	on dias.fechatur = mwktodos.fechatur group by dias.fechatur, mwktodos.Franjat into cursor mwkdiass

Select nvl(id,1) as id ,nvl(afiliado,1) as afiliado, fechatur,;
	nvl(horatur,dtot(fechatur)) as horatur,nvl(tipoturno,0) as tipoturno, nvl(confirmado,0) as confirmado, ;
	diasem,nvl(hhmmtur,0) as hhmmtur ,nvl(codserv,2200) as codserv from mwkdiass into cursor mwkdias

Select mwkdias.id,afiliado, fechatur, horatur, Mwkmedpre.nn as nombre,tipoturno, confirmado;
	,hhmmtur, mwkdias.codserv,recno("Mwkmedpre") as afi,porc,hdesde1,hdes1, hhasta1,generaagen ;
	,Mwkmedpre.codmed,Mwkmedpre.codesp,Mwkmedpre.diasem,demanda,Franja,Franja as Franjat,Mwkmedpre.ESP_descripcion,hhmmDes,;
	hhmmHas ;
	from Mwkmedpre left join mwkdias on (fechatur >= fecvigend and fechatur <  fecvigenh and ;
	(fechatur > bloquehasta  or fechatur < bloquedesde ) and  ;
	mwkdias.diasem = Mwkmedpre.diasem );
	where demanda = 1 ;
	group by Mwkmedpre.codesp, Mwkmedpre.codmed, fechatur, hhmmDes, hhmmHas,tipoturno  ;
	into cursor mwktodosccd

Select mwkdias.id,afiliado, fechatur, horatur, Mwkmedpre.nn as nombre,tipoturno, confirmado;
	,hhmmtur, mwkdias.codserv,recno("Mwkmedpre") as afi,porc,hdesde1,hdes1, hhasta1,generaagen ;
	,Mwkmedpre.codmed,Mwkmedpre.codesp,Mwkmedpre.diasem,demanda,Franja,Franja as Franjat,Mwkmedpre.ESP_descripcion,hhmmDes,;
	hhmmHas ;
	from Mwkmedpre left join mwkdias on (fechatur >= fecvigend and fechatur <  fecvigenh and ;
	(fechatur > bloquehasta  or fechatur < bloquedesde ) and  ;
	mwkdias.diasem = Mwkmedpre.diasem );
	where demanda = 0 and generaagen = 0 ;
	group by Mwkmedpre.codesp, Mwkmedpre.codmed, fechatur, hhmmDes, hhmmHas,tipoturno  ;
	into cursor mwktodosccfi

&&Turnos dados

Select mwktodos.*,Mwkmedpre.codesp, Mwkmedpre.porc,Mwkmedpre.ESP_descripcion, Mwkmedpre.hdesde1, Mwkmedpre.hdes1, Mwkmedpre.hhasta1;
	,demanda,Franja ,generaagen ,hhmmDes, hhmmHas  ;
	from mwktodos,Mwkmedpre  ;
	where mwktodos.fechatur >= Mwkmedpre.fecvigend and ;
	mwktodos.fechatur <  Mwkmedpre.fecvigenh and ;
	hhmmtur >= Mwkmedpre.hhmmDes and hhmmtur<Mwkmedpre.hhmmHas and ;
	mwktodos.codmed = Mwkmedpre.codmed and ;
	mwktodos.codesp = Mwkmedpre.codespsa and ;
	mwktodos.codserv = Mwkmedpre.codserv and ;
	mwktodos.diasem = Mwkmedpre.diasem and generaagen = 1 and ( demanda = 0 or  isnull(demanda));
	group by afi,mwktodos.codmed, mwktodos.codesp, fechatur, hhmmDes, hhmmHas,tipoturno ;
	into cursor mwktodoscc

&&Turnos libres

Select mwktodos.*,Mwkmedpre.codesp, Mwkmedpre.porc,Mwkmedpre.ESP_descripcion, Mwkmedpre.hdesde1, Mwkmedpre.hdes1, Mwkmedpre.hhasta1;
	,demanda,Franja,generaagen ,hhmmDes, hhmmHas  ;
	from mwktodos,Mwkmedpre ;
	where mwktodos.fechatur >= Mwkmedpre.fecvigend and ;
	mwktodos.fechatur <  Mwkmedpre.fecvigenh and ;
	hhmmtur >= Mwkmedpre.hhmmDes and hhmmtur<Mwkmedpre.hhmmHas and ;
	mwktodos.codmed = Mwkmedpre.codmed and ;
	mwktodos.diasem = Mwkmedpre.diasem and generaagen = 1 and ( demanda = 0 or  isnull(demanda));
	group by afi,mwktodos.codmed, Mwkmedpre.codesp, fechatur, hhmmDes, hhmmHas,tipoturno ;
	into cursor mwktodosccl

Select nvl(id,0) as id,afiliado, fechatur, horatur, nombre,tipoturno, confirmado, hhmmtur, codserv;
	,ESP_descripcion, afi,nvl(porc,000) as porc,hdesde1,hdes1,hhasta1,hhmmDes, hhmmHas  ;
	,codmed,codesp_b as codesp,diasem,demanda,Franja,generaagen,Franjat   from mwktodoscc ;
	union all ;
	select nvl(id,0),afiliado, fechatur, horatur, nombre,tipoturno, confirmado, hhmmtur, codserv;
	,ESP_descripcion, afi,nvl(porc,000) as porc,hdesde1,hdes1,hhasta1,hhmmDes, hhmmHas  ;
	,codmed,codesp_b as codesp,diasem,demanda,Franja,generaagen,Franjat  from mwktodosccl ;
	into cursor mwktodosct

Select * from 	mwktodosct ;
	group by codmed, codesp, fechatur,hhmmDes, hhmmHas, tipoturno ;
	into cursor mwktodoscct

Select * from mwktodosct ;
	union all ;
	select nvl(id,0),nvl(afiliado,0), fechatur, horatur, nombre,tipoturno, confirmado, hhmmtur, codserv;
	,ESP_descripcion, afi,nvl(porc,000) as porc,hdesde1,hdes1,hhasta1,hhmmDes, hhmmHas  ;
	,codmed,codesp,diasem,demanda,Franja,generaagen,Franjat from mwktodosccd where !isnull(afiliado) ;
	union all ;
	select nvl(id,0),nvl(afiliado,0), fechatur, horatur, nombre,tipoturno, confirmado, hhmmtur, codserv;
	,ESP_descripcion, afi,nvl(porc,000) as porc,hdesde1,hdes1,hhasta1,hhmmDes, hhmmHas  ;
	,codmed,codesp,diasem,demanda,Franja,generaagen,Franjat from mwktodosccfi where !isnull(afiliado) ;
	into cursor mwktodosc

* Modificaciones

If mlista = 1

	Select ESP_descripcion ,nombre, fechatur, hdesde1,hdes1, hhasta1,month(fechatur) as mes, ;
		codmed, codesp,tipoturno,porc,demanda,Franja,generaagen,Franjat ,hhmmDes, hhmmHas, diasem, ;
		horatur as horatur1 ;
		from mwktodosc ;
		group by codmed, fechatur, codesp,hhmmDes, hhmmHas,demanda,generaagen,Franjat ;
		order by codmed, fechatur, hdes1 ;
		into cursor mwktodosa1

*****


	Select ESP_descripcion, nombre,codmed,demanda,Franja,generaagen,Franjat;
		,sum(round(((hhasta1 - hdesde1)*porc/100 /3600), 2)) as horas,fechatur,codesp,tipoturno,mes, diasem, sum(round(((hhasta1 - hdesde1)*porc/100 /3600), 2)) as horatur, ;
		horatur1 ;
		from mwktodosa1 group by codmed, codesp ,fechatur,demanda,generaagen,mes,Franja ;
		order by codmed,fechatur where Franjat = Franja ;
		into cursor mwkpp1a

	Select ESP_descripcion, nombre,codmed,demanda,Franja,generaagen,Franjat;
		,sum(round(((hhasta1 - hdesde1)*porc/100 /3600), 2)) as horas,fechatur,codesp,tipoturno,mes, diasem, sum(round(((hhasta1 - hdesde1)*porc/100 /3600), 2)) as horatur, ;
		horatur1 ;
		from mwktodosa1 group by codmed, codesp ,fechatur,demanda,generaagen,mes;
		order by codmed,fechatur where Franjat <> Franja;
		into cursor mwkpp1b
		
	Select * from mwkpp1a union select * from mwkpp1b into cursor mwkpp1

	Select * from mwkpp1 order by codmed,fechatur into cursor mwktodosaP

****


	Select *,(iif(demanda = 1, horas, horas-horas)) as hde, ;
		(iif(Franjat="PE", horas, horas-horas)) as hPE, ;
		(iif(generaagen= 1 and demanda = 0 and Franjat="  ", horas, horas-horas)) as hn ;
		,iif(demanda = 0 and generaagen = 0, horas, horas-horas) as hfi;
		from mwktodosaP ;
		order by codmed,fechatur ;
		into cursor mwktodos

Else

	Select ESP_descripcion ,nombre, fechatur, hdesde1,hdes1, hhasta1, ;
		codmed, codesp,tipoturno,porc,demanda,Franja,generaagen,Franjat ,hhmmDes, hhmmHas,month(fechatur) as mes, ;
		horatur,diasem,hhmmtur ;
		from mwktodosc ;
		group by codmed, codesp , fechatur,hhmmDes, hhmmHas,demanda,generaagen,Franjat ;
		order by codesp,codmed, fechatur, hdes1 ;
		into cursor mwktodosa1

****

	Select ESP_descripcion, nombre,codmed,demanda,Franja,generaagen,Franjat;
		,sum(round(((hhasta1 - hdesde1)*porc/100 /3600), 2)) as horas,fechatur,codesp,tipoturno,mes, ;
		horatur, diasem,hhmmtur ;
		from mwktodosa1 group by codmed, codesp ,fechatur,demanda,mes,generaagen,Franja ;
		order by codmed,fechatur where Franjat = Franja;
		into cursor mwkpp1a

	Select ESP_descripcion, nombre,codmed,demanda,Franja,generaagen,Franjat;
		,sum(round(((hhasta1 - hdesde1)*porc/100 /3600), 2)) as horas,fechatur,codesp,tipoturno,mes, ;
		horatur, diasem, hhmmtur ;
		from mwktodosa1 group by codmed, codesp ,fechatur,demanda,generaagen,mes;
		order by codmed,fechatur where Franjat <> Franja;
		into cursor mwkpp1b

	Select * from mwkpp1a union select * from mwkpp1b into cursor mwkpp1

	Select * from mwkpp1 order by codmed,fechatur into cursor mwktodosaP

****


	Select *,(iif(demanda = 1, horas, horas-horas)) as hde, ;
		(iif(Franjat="PE", horas, horas-horas)) as hPE, ;
		(iif(generaagen= 1 and demanda = 0 and Franjat="  ", horas, horas-horas)) as hn ;
		,iif(demanda = 0 and generaagen = 0, horas, horas-horas) as hfi;
		from mwktodosaP ;
		order by codmed,fechatur ;
		into cursor mwktodos

Endif

*!* Agregado de goup by , Franjat

If mlista = 1

	Select MWKespec1.ESP_descripcion, nombre,codmed,horas, ;
		hn,hde,hPE,hfi,mes,;
		Franja,generaagen,Franjat;
		from mwktodos,MWKespec1 where MWKespec1.esp_codesp = mwktodos.codesp ;
		order by nombre ;
		into cursor mwklista1

Else

	Select MWKespec1.ESP_descripcion, nombre,codmed,fechatur, horas,;
		iif(dow(fechatur) = 2, 'Lunes    ', iif(dow(fechatur) = 3, 'Martes   ', ;
		iif(dow(fechatur) = 4, 'Miercoles', iif(dow(fechatur) = 5, 'Jueves   ', ;
		iif(dow(fechatur) = 6, 'Viernes  ', 'Sabado   '))))) as dia, ;
		hn,hde,hPE,hfi,mes,;
		Franja,generaagen,Franjat;
		from mwktodos,MWKespec1 where MWKespec1.esp_codesp = mwktodos.codesp ;
		order by nombre, fechatur ;
		into cursor mwklista1

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
If used('mwkpp1a')
	Use in mwkpp1a
Endif
If used('mwkpp1b')
	Use in mwkpp1b
Endif
If used('mwkpp2')
	Use in mwkpp2
Endif
If used('mwkpp3')
	Use in mwkpp3
Endif


