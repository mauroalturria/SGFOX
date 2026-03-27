*parameter mfecdes, mfechas, mbusco1, mlista


mret = sqlexec(mcon1, "select turnos.codmed, turnos.fechatur, turnos.horatur, " + ;
				"medpresta.hdesde1, medpresta.hhasta1, prestadores.nombre, " + ;
				"medpresta.codesp, especialid.esp_descripcion " + ;
				"from turnos, prestadores, medpresta, especialid " + ;
				"where turnos.codmed = prestadores.id and " + ;
				"turnos.diasem = medpresta.diasem and " + ;
				"turnos.codmed = medpresta.codmed and " + ;
				"medpresta.codesp = trim(especialid.esp_codesp) and " + ;
				"turnos.fechatur >= medpresta.fecvigend and " + ;
				"turnos.fechatur < medpresta.fecvigenh and " + ;
				"turnos.fechatur >= ?mfecdes and turnos.fechatur <= ?mfechas and " + ;
				"tipoturno < 9 " + ;
				"&mbusco1" + ;
				"order by turnos.codmed, turnos.fechatur, hdesde1 " , "mwktodosc")

if mlista = 1
	select esp_descripcion ,nombre, fechatur, hdesde1, hhasta1, codmed, codesp ;
	from mwktodosc ;
	where   round(val(strtran(left(ttoc(horatur,2), 5), ':', '')), 0) >= ;
			round(val(strtran(left(ttoc(hdesde1,2), 5), ':', '')), 0) and ;
			round(val(strtran(left(ttoc(horatur,2), 5), ':', '')), 0) <  ;
			round(val(strtran(left(ttoc(hhasta1,2), 5), ':', '')), 0)   ;		
	group by codesp, codmed, fechatur, hdesde1 ;
	order by codesp, codmed, fechatur, hdesde1 ;
	into cursor mwktodosa1

	select esp_descri, sum(round(((hhasta1 - hdesde1) /3600), 2)) as horas, codesp ;
	from mwktodosa1 ;
	group by codesp ;
	order by codesp, codmed ;
	into cursor mwktodosa
else
	select esp_descripcion, nombre, sum(round(((hhasta1 - hdesde1) /3600), 2)) as horas, codesp ;
	from mwktodosc ;
	where   round(val(strtran(left(ttoc(horatur,2), 5), ':', '')), 0) >= ;
			round(val(strtran(left(ttoc(hdesde1,2), 5), ':', '')), 0) and ;
			round(val(strtran(left(ttoc(horatur,2), 5), ':', '')), 0) <  ;
			round(val(strtran(left(ttoc(hhasta1,2), 5), ':', '')), 0)   ;		
	group by codesp ;
	order by codesp ;
	into cursor mwktodosa
endif

mret = sqlexec(mcon1, "select fechatur, codmed, codserv, codesp, tipoturno, esp_descripcion " + ;
				"from turnos, especialid " + ;
				"where trim(turnos.codesp) = trim(especialid.esp_codesp) and " + ;
				"turnos.fechatur >= ?mfecdes and turnos.fechatur <= ?mfechas and " + ;
				"tipoturno < 9 and afiliado > 0 " + ;
				"&mbusco1" , "mwktodosb")

select b.esp_descripcion, b.fechatur, b.codserv, a.horas ;
from mwktodosa as a, mwktodosb as b ;
where a.codesp = b.codesp ;
into cursor mwktodos

if mlista = 1
	select esp_descripcion, fechatur, horas, ;
		sum(iif(codserv = 2200, 1, 0000)) as consulta, ;
 		sum(iif(codserv <> 2200, 1, 0000)) as practica ;
 		from mwktodos ;
 		group by esp_descripcion ;
 		order by esp_descripcion ;
 		into cursor mwklista

else
	select esp_descripcion, fechatur, horas, ;
		iif(dow(fechatur) = 2, 'Lunes    ', iif(dow(fechatur) = 3, 'Martes   ', ;
		iif(dow(fechatur) = 4, 'Miercoles', iif(dow(fechatur) = 5, 'Jueves   ', ;
		iif(dow(fechatur) = 6, 'Viernes  ', 'Sabado   '))))) as dia, ; 		
		sum(iif(codserv = 2200, 1, 0000)) as consulta, ;
 		sum(iif(codserv <> 2200, 1, 0000)) as practica ;
 		from mwktodos ;
 		group by esp_descripcion, fechatur ;
 		order by esp_descripcion, fechatur ;
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
if used('mwktodosc')
	select mwktodosc
	use
endif
if used('mwktodos')
	select mwktodos
	use
endif