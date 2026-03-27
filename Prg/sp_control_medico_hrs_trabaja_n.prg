****
** Listado horas trabajadas
****
Parameter mfecdes, mfechas, mbuscom, mbuscot, mlista, mpermanente,mbuscoF

*!* set step on

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

mret = sqlexec(mcon1, "select codmed ,diasem, hhmmdes,hhmmhas, fecvigend, fecvigenh, "+;
	"tiposervicio,tipoturno "+;
	" from franjahoraria "+;
	" where diasem > 0 "+ qbusco + mbuscoF  +;
	" and fecvigenh > ?mfecdes and fecvigend <= ?mfechas "+;
	" and fecvigenh <> fecvigend "+;
	" group by codmed, diasem, fecvigenh, hhmmdes,hhmmhas,tipoturno ","Mwkfran0")

If mret < 0
	= aerr(eros)
	Messagebox(eros(3),16,'VALIDACION')
Endif
qbusco = iif(empty(mbuscot), '',strtran(mbuscot,'tt','medpresta'))

mret = sqlexec(mcon1, " select codmed, diasem, fecvigend,medpresta.codesp "+;
	", fecvigenh,  hdesde1, hhasta1, horadesde, horahasta, bloquedesde , bloquehasta  "+;
	", hhmmDes, hhmmHas,demanda,ESP_descripcion ,nombre as nn,generaagen,codserv " +;
	" from especialid,medpresta "+;
	" left join prestadores on medpresta.codmed = prestadores.id "+;
	" where medpresta.codesp = trim(especialid.ESP_codesp) "+qbusco +;
	" and fecvigenh > ?mfecdes and fecvigend <= ?mfechas "+;
	" and fecvigenh <> fecvigend "+;
	" ","Mwkmedpre00")

Select codmed, diasem, fecvigend,codesp , fecvigenh,  hdesde1, hhasta1, horadesde, ;
	horahasta, bloquedesde , bloquehasta, hhmmDes, hhmmHas,nvl(demanda,0) as demanda,;
	ESP_descripcion ,nn,generaagen ,codserv,ttoc(hdesde1,2) as hdes1  ;
	from Mwkmedpre00 into cursor Mwkmedpre01

Select * from Mwkmedpre01;
	group by codmed, codesp,codserv,diasem, fecvigenh, hdes1 ;
	into cursor Mwkmedpre0

If mret < 0
	=aerr(eros)
	Messagebox(eros(3), 16, "Validacion")
Endif

If mpermanente

	Select Mwkmedpre0.codmed, Mwkmedpre0.diasem, Mwkfran0.tiposervicio, Mwkfran0.fecvigend,Mwkmedpre0.codesp ;
		, Mwkfran0.fecvigenh, Mwkmedpre0.hdesde1, Mwkmedpre0.hhasta1, Mwkmedpre0.hdes1, Mwkmedpre0.horadesde;
		, Mwkmedpre0.horahasta, Mwkmedpre0.hhmmDes, Mwkmedpre0.hhmmHas,codserv,Mwkmedpre0.demanda;
		,100 as porc, iif(tipoturno  = 7, 'PE',space(2)) as Franja,generaagen,tipoturno as tipofran ;
		,iif(demanda = 1,'DE','  ') as de,ESP_descripcion, nn, bloquedesde , bloquehasta ;
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

	Select Mwkmedpre0.codmed, Mwkmedpre0.diasem, Mwkfran0.tiposervicio, Mwkfran0.fecvigend,Mwkmedpre0.codesp ;
		, Mwkfran0.fecvigenh, Mwkmedpre0.hdesde1, Mwkmedpre0.hhasta1, Mwkmedpre0.hdes1, Mwkmedpre0.horadesde;
		, Mwkmedpre0.horahasta, Mwkmedpre0.hhmmDes, Mwkmedpre0.hhmmHas,codserv,Mwkmedpre0.demanda;
		,100 as porc, iif(tipoturno  = 7, 'PE',space(2)) as Franja,generaagen,tipoturno as tipofran ;
		,iif(demanda = 1,'DE','  ') as de,ESP_descripcion, nn, bloquedesde , bloquehasta ;
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
	" and turnos.tipoturno < 8 and turnos.tipoturno <> 2 and turnos.afiliado <> 1 " + qbusco , "mwktodosc1")

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
		" and tipoturno < 8 and turnos.tipoturno <> 2" + qbusco , "mwktodosc2")

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
	nvl(horatur,dtot(fechatur)) as horatur,nvl(tipoturno,0) as tipoturno,tiposervicio, nvl(confirmado,0) as confirmado, ;
	diasem,nvl(hhmmtur,0) as hhmmtur ,nvl(codserv,2200) as codserv from mwkdiass into cursor mwkdias

Select mwkdias.id,afiliado, fechatur, horatur, Mwkmedpre.nn as nombre,tiposervicio, tipoturno,tiposervicio, confirmado;
	,hhmmtur, mwkdias.codserv,recno("Mwkmedpre") as afi,porc,hdesde1,hdes1, hhasta1,generaagen ;
	,Mwkmedpre.codmed,Mwkmedpre.codesp,Mwkmedpre.diasem,demanda,Franja,Franja as Franjat,ESP_descripcion,hhmmDes,;
	hhmmHas ;
	from Mwkmedpre left join mwkdias on (fechatur >= fecvigend and fechatur <  fecvigenh and ;
	(fechatur > bloquehasta  or fechatur < bloquedesde ) and  ;
	mwkdias.diasem = Mwkmedpre.diasem );
	where demanda = 1 ;
	group by Mwkmedpre.codesp, Mwkmedpre.codmed, fechatur, hhmmDes, hhmmHas,tiposervicio,tipoturno  ;
	into cursor mwktodosccd

&&Turnos dados

Select mwktodos.*,Mwkmedpre.codesp, Mwkmedpre.porc,ESP_descripcion, Mwkmedpre.hdesde1, Mwkmedpre.hdes1, Mwkmedpre.hhasta1;
	,demanda,Franja ,generaagen ,hhmmDes, hhmmHas  ;
	from mwktodos,Mwkmedpre  ;
	where mwktodos.fechatur >= Mwkmedpre.fecvigend and ;
	mwktodos.fechatur <  Mwkmedpre.fecvigenh and ;
	hhmmtur >= Mwkmedpre.hhmmDes and hhmmtur<Mwkmedpre.hhmmHas and ;
	mwktodos.codmed = Mwkmedpre.codmed and ;
	mwktodos.codesp = Mwkmedpre.codesp and ;
	mwktodos.codserv = Mwkmedpre.codserv and ;
	mwktodos.diasem = Mwkmedpre.diasem and generaagen = 1 and ( demanda = 0 or  isnull(demanda));
	group by afi,mwktodos.codmed, mwktodos.codesp, fechatur, hhmmDes, hhmmHas,tiposervicio,tipoturno ;
	into cursor mwktodoscc

&&Turnos libres

Select mwktodos.*,Mwkmedpre.codesp, Mwkmedpre.porc,ESP_descripcion, Mwkmedpre.hdesde1, Mwkmedpre.hdes1, Mwkmedpre.hhasta1;
	,demanda,Franja,generaagen ,hhmmDes, hhmmHas  ;
	from mwktodos,Mwkmedpre ;
	where mwktodos.fechatur >= Mwkmedpre.fecvigend and ;
	mwktodos.fechatur <  Mwkmedpre.fecvigenh and ;
	hhmmtur >= Mwkmedpre.hhmmDes and hhmmtur<Mwkmedpre.hhmmHas and ;
	mwktodos.codmed = Mwkmedpre.codmed and ;
	mwktodos.diasem = Mwkmedpre.diasem and generaagen = 1 and ( demanda = 0 or  isnull(demanda));
	group by afi,mwktodos.codmed, Mwkmedpre.codesp, fechatur, hhmmDes, hhmmHas,tiposervicio,tipoturno ;
	into cursor mwktodosccl

Select nvl(id,0) as id,afiliado, fechatur, horatur, nombre,tiposervicio,tipoturno, confirmado, hhmmtur, codserv;
	,ESP_descripcion, afi,nvl(porc,000) as porc,hdesde1,hdes1,hhasta1,hhmmDes, hhmmHas  ;
	,codmed,codesp_b as codesp,diasem,demanda,Franja,Franjat   from mwktodoscc ;
	union all ;
	select nvl(id,0),afiliado, fechatur, horatur, nombre,tiposervicio,tipoturno, confirmado, hhmmtur, codserv;
	,ESP_descripcion, afi,nvl(porc,000) as porc,hdesde1,hdes1,hhasta1,hhmmDes, hhmmHas  ;
	,codmed,codesp_b as codesp,diasem,demanda,Franja,Franjat  from mwktodosccl ;
	into cursor mwktodosct

Select * from 	mwktodosct ;
	group by codmed, codesp, fechatur,hhmmDes, hhmmHas, tiposervicio,tipoturno ;
	into cursor mwktodoscct

Select * from mwktodosct ;
	union all ;
	select nvl(id,0),nvl(afiliado,0), fechatur, horatur, nombre,tiposervicio,tipoturno, confirmado, hhmmtur, codserv;
	,ESP_descripcion, afi,nvl(porc,000) as porc,hdesde1,hdes1,hhasta1,hhmmDes, hhmmHas  ;
	,codmed,codesp,diasem,demanda,Franja,Franjat from mwktodosccd where !isnull(nombre) ;
	into cursor mwktodosc

* Modificaciones

If mlista = 1

	Select ESP_descripcion ,nombre, fechatur, hdesde1,hdes1, hhasta1,month(fechatur) as mes, ;
		codmed, codesp,tiposervicio,tipoturno,porc,demanda,Franja,Franjat ,hhmmDes, hhmmHas ;
		from mwktodosc ;
		group by codmed, fechatur, codesp,hhmmDes, hhmmHas,demanda,Franjat ;
		order by codmed, fechatur, hdes1 ;
		into cursor mwktodosa1

*****


	Select ESP_descripcion, nombre,codmed,demanda,Franja,Franjat;
		,sum(round(((hhasta1 - hdesde1)*porc/100 /3600), 2)) as horas,fechatur,codesp,tiposervicio,tipoturno,mes ;
		from mwktodosa1 group by codmed, codesp ,fechatur,demanda,mes,Franja ;
		order by codmed,fechatur where Franjat = Franja ;
		into cursor mwkpp1a

	Select ESP_descripcion, nombre,codmed,demanda,Franja,Franjat;
		,sum(round(((hhasta1 - hdesde1)*porc/100 /3600), 2)) as horas,fechatur,codesp,tiposervicio,tipoturno,mes ;
		from mwktodosa1 group by codmed, codesp ,fechatur,demanda,mes;
		order by codmed,fechatur where Franjat <> Franja;
		into cursor mwkpp1b
		
	Select * from mwkpp1a union select * from mwkpp1b into cursor mwkpp1

	Select * from mwkpp1 order by codmed,fechatur into cursor mwktodosaP

****


*!*		Select ESP_descripcion, nombre,codmed,demanda,Franja,Franjat ,mes,;
*!*			sum(round(((hhasta1 - hdesde1)*porc/100 /3600), 2)) as horas, codesp,tiposervicio,tipoturno ;
*!*			from mwktodosa1 ;
*!*			group by codmed, codesp,demanda,mes,Franjat  ;
*!*			order by codmed ;
*!*			into cursor mwktodosaP

*ª* Agregue franjat group

*!*		Select *,sum(iif(demanda = 1, horas, 0000)) as hde, ;
*!*			sum(iif(Franjat="PE", horas, 0000)) as hPE, ;
*!*			sum(iif(demanda = 0 and Franjat="  ", horas, 0)) as hn  ;
*!*			from mwktodosaP ;
*!*			group by codmed, codesp, mes  ;
*!*			order by codmed ;
*!*			into cursor mwktodos
*!*


	Select *,(iif(demanda = 1, horas, horas-horas)) as hde, ;
		(iif(Franjat="PE", horas, horas-horas)) as hPE, ;
		(iif(demanda = 0 and Franjat="  ", horas, horas-horas)) as hn ;
		from mwktodosaP ;
		order by codmed,fechatur ;
		into cursor mwktodos

Else

	Select ESP_descripcion ,nombre, fechatur, hdesde1,hdes1, hhasta1, ;
		codmed, codesp,tiposervicio,tipoturno,porc,demanda,Franja,Franjat ,hhmmDes, hhmmHas,month(fechatur) as mes ;
		from mwktodosc ;
		group by codmed, codesp , fechatur,hhmmDes, hhmmHas,demanda,Franjat ;
		order by codesp,codmed, fechatur, hdes1 ;
		into cursor mwktodosa1

****

*!*		create cursor mwkppp (ESP_descripcion C(50),nombre C(50),codmed N(6),demanda N(1),Franja C(2),;
*!*		Franjat C(2),horas N(6,2), fechatur D,codesp C(5),tiposervicio,tipoturno N(1),mes N(2))

*!*		Select ESP_descripcion, nombre,codmed,demanda,Franja,Franjat;
*!*			,round(((hhasta1 - hdesde1)*porc/100 /3600), 2) as horas,fechatur,codesp,tiposervicio,tipoturno,mes ;
*!*			from mwktodosa1 ;
*!*			order by codmed,fechatur where (empty(Franjat) and empty(Franja)) or Franjat <> Franja;
*!*			into cursor mwkpp1


	Select ESP_descripcion, nombre,codmed,demanda,Franja,Franjat;
		,sum(round(((hhasta1 - hdesde1)*porc/100 /3600), 2)) as horas,fechatur,codesp,tiposervicio,tipoturno,mes ;
		from mwktodosa1 group by codmed, codesp ,fechatur,demanda,mes,Franja ;
		order by codmed,fechatur where Franjat = Franja;
		into cursor mwkpp1a

	Select ESP_descripcion, nombre,codmed,demanda,Franja,Franjat;
		,sum(round(((hhasta1 - hdesde1)*porc/100 /3600), 2)) as horas,fechatur,codesp,tiposervicio,tipoturno,mes ;
		from mwktodosa1 group by codmed, codesp ,fechatur,demanda,mes;
		order by codmed,fechatur where Franjat <> Franja;
		into cursor mwkpp1b

	Select * from mwkpp1a union select * from mwkpp1b into cursor mwkpp1

*!*		Select ESP_descripcion, nombre,codmed,demanda,Franja,Franjat;
*!*			,sum(round(((hhasta1 - hdesde1)*porc/100 /3600), 2)) as horas,fechatur,codesp,tiposervicio,tipoturno,mes ;
*!*			from mwktodosa1 group by codmed, codesp ,fechatur,demanda,mes;
*!*			order by codmed,fechatur where Franjat='PE' and Franja = 'PE';
*!*			into cursor mwkpp2

*!*		Select * from mwkpp1 union select * from mwkpp2 into cursor mwkpp3

	Select * from mwkpp1 order by codmed,fechatur into cursor mwktodosaP

****

*!*		Select ESP_descripcion, nombre,codmed,demanda,Franja,Franjat ;
*!*			,sum(round(((hhasta1 - hdesde1)*porc/100 /3600), 2)) as horas;
*!*			,fechatur , codesp,tiposervicio,tipoturno,mes ;
*!*			from mwktodosa1 ;
*!*			group by codmed, codesp ,fechatur,demanda,mes,Franjat  ;
*!*			order by codmed,fechatur ;
*!*			into cursor mwktodosaP

*!*	*!*		Select ESP_descripcion, nombre,codmed,demanda,Franja,Franjat ;
*!*	*!*			,sum(round(((hhasta1 - hdesde1)/3600), 2)) as horas;
*!*	*!*			,fechatur,codesp,tiposervicio,tipoturno,mes ;
*!*	*!*			from mwktodosa1 ;
*!*	*!*			group by codmed, codesp ,fechatur,demanda,Franjat,mes  ;
*!*	*!*			order by codmed,fechatur ;
*!*	*!*			into cursor mwktodosaP

*!* Agregado de goup by Franjat

*!*		Select *,sum(iif(demanda = 1, horas, horas-horas)) as hde, ;
*!*			sum(iif(Franjat="PE", horas, horas-horas)) as hPE, ;
*!*			sum(iif(demanda = 0 and Franjat="  ", horas, horas-horas)) as hn ;
*!*			from mwktodosaP ;
*!*			group by codmed, codesp ,fechatur  ;
*!*			order by codmed,fechatur ;
*!*			into cursor mwktodos


	Select *,(iif(demanda = 1, horas, horas-horas)) as hde, ;
		(iif(Franjat="PE", horas, horas-horas)) as hPE, ;
		(iif(demanda = 0 and Franjat="  ", horas, horas-horas)) as hn ;
		from mwktodosaP ;
		order by codmed,fechatur ;
		into cursor mwktodos

Endif

*!* Agregado de goup by , Franjat

If mlista = 1

*!*		Select ESP_descripcion, nombre,codmed,horas, ;
*!*			hn,hde,hPE,mes,;
*!*			Franja,Franjat;
*!*			from mwktodos ;
*!*			group by codmed,ESP_descripcion,mes;
*!*			order by nombre ;
*!*			into cursor mwklista1

	Select ESP_descripcion, nombre,codmed,horas, ;
		hn,hde,hPE,mes,;
		Franja,Franjat;
		from mwktodos ;
		order by nombre ;
		into cursor mwklista1

Else

*!*		Select ESP_descripcion, nombre,codmed,fechatur, horas,;
*!*			iif(dow(fechatur) = 2, 'Lunes    ', iif(dow(fechatur) = 3, 'Martes   ', ;
*!*			iif(dow(fechatur) = 4, 'Miercoles', iif(dow(fechatur) = 5, 'Jueves   ', ;
*!*			iif(dow(fechatur) = 6, 'Viernes  ', 'Sabado   '))))) as dia, ;
*!*			hn,hde,hPE,mes,;
*!*			Franja,Franjat;
*!*			from mwktodos ;
*!*			group by codmed, ESP_descripcion, fechatur ;
*!*			order by nombre, fechatur ;
*!*			into cursor mwklista1
*!*

	Select ESP_descripcion, nombre,codmed,fechatur, horas,;
		iif(dow(fechatur) = 2, 'Lunes    ', iif(dow(fechatur) = 3, 'Martes   ', ;
		iif(dow(fechatur) = 4, 'Miercoles', iif(dow(fechatur) = 5, 'Jueves   ', ;
		iif(dow(fechatur) = 6, 'Viernes  ', 'Sabado   '))))) as dia, ;
		hn,hde,hPE,mes,;
		Franja,Franjat;
		from mwktodos ;
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


