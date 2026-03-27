****
** Listado estadistico para Morgulis primero disponible, cantidad ocupados, libres
****

parameter mfecdes, mfechas, mbusco1, mlista

mret = sqlexec(mcon1, "select afiliado, fechatur, horatur, turnos.codmed, nombre, " + ;
						"turnos.tipoturno, confirmado, turnos.diasem, abrevio, pre_descriprest " + ;
						"from turnos, prestadores, franjahoraria, tabtipofranja, prestacions " + ;
						"where turnos.codmed = prestadores.id and " + ;
						"turnos.codmed   =  franjahoraria.codmed and " + ;
						"turnos.fechatur >= franjahoraria.fecvigend and " + ;
						"turnos.fechatur <  franjahoraria.fecvigenh and " + ;
						"turnos.diasem   =  franjahoraria.diasem and " + ;
						"turnos.codprest = prestacions.pre_codprest and " + ;
						"{fn CONVERT(horatur, SQL_TIME)} " + ;
						"between {fn CONVERT(franjahoraria.horadesde, SQL_TIME)} and " + ;
								"{fn CONVERT(franjahoraria.horahasta, SQL_TIME)} and " + ;
						"turnos.fechatur >= ?mfecdes and turnos.fechatur <= ?mfechas and " + ;
						"tiposervicio = tabtipofranja.id and tipoturno < 9 " + ;
						"&mbusco1" , "mwktodosa")

mret = sqlexec(mcon1, "select afiliado, fechatur, horatur, turnos.codmed, nombre, " + ;
						"turnos.tipoturno, confirmado, turnos.diasem, abrevio, pre_descriprest " + ;
						"from turnoshis as turnos, prestadores, franjahoraria, tabtipofranja, prestacions " + ;
						"where turnos.codmed = prestadores.id and " + ;
						"turnos.codmed   =  franjahoraria.codmed and " + ;
						"turnos.fechatur >= franjahoraria.fecvigend and " + ;
						"turnos.fechatur <  franjahoraria.fecvigenh and " + ;
						"turnos.diasem   =  franjahoraria.diasem and " + ;
						"turnos.codprest =  prestacions.pre_codprest and " + ;
						"{fn CONVERT(horatur, SQL_TIME)} " + ;
						"between {fn CONVERT(franjahoraria.horadesde, SQL_TIME)} and " + ;
								"{fn CONVERT(franjahoraria.horahasta, SQL_TIME)} and " + ;
						"turnos.fechatur >= ?mfecdes and turnos.fechatur <= ?mfechas and " + ;
						"tiposervicio = tabtipofranja.id and tipoturno < 9 " + ;
						"&mbusco1" , "mwktodosb")
						
if mret < 0 
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
	cancel
endif
						
select * from mwktodosa ;
union all ;
select * from mwktodosb ;
into cursor mwktodos
						
do sp_medpresta_mas_st_so with mfechas

select mwktodos.diasem,	mwktodos.codmed, afiliado, fechatur, horatur, nombre, ;
		tipoturno, confirmado, hdesde1, hhasta1, cantidad, porcentaje, abrevio, pre_descriprest ; 
	from mwktodos, mwkmedpre ;
	where mwktodos.fechatur >= mwkmedpre.fecvigend and ;
		  mwktodos.fechatur <  mwkmedpre.fecvigenh and ;
		  round(val(strtran(left(ttoc(horatur,2), 5), ':', '')), 0) >= ;
		  round(val(strtran(left(ttoc(hdesde1,2), 5), ':', '')), 0) and ;
		  round(val(strtran(left(ttoc(horatur,2), 5), ':', '')), 0) <  ;
		  round(val(strtran(left(ttoc(hhasta1,2), 5), ':', '')), 0) and ;
		  mwktodos.codmed = mwkmedpre.codmed and ;
		  mwktodos.diasem = mwkmedpre.diasem ;
	into cursor mwktodosa	

if mlista = 1
	select nombre, fechatur, pre_descriprest, ;
		iif(diasem = 2, 'Lun', iif(diasem = 3, 'Mar', ;
		iif(diasem = 4, 'Mie', iif(diasem = 5, 'Jue', ;
		iif(diasem = 6, 'Vie', 'Sab'))))) as dia, ; 		
		sum(iif(afiliado = 0, 1, 0000)) as libre, ;
 		sum(iif(afiliado > 0, 1, 0000)) as ocupa, ;
 		sum(iif(afiliado > 0 and confirmado = 0, 1, 0000)) as falto, ; 
 		sum(iif(afiliado > 0 and confirmado = 1, 1, 0000)) as vino, ; 
 		count(afiliado) as ofrecido, hdesde1, hhasta1, cantidad, porcentaje, abrevio ;
 		from mwktodosa ;
 		group by nombre, diasem, hdesde1, hhasta1, abrevio, pre_descriprest ;
 		order by nombre, diasem, hdesde1, hhasta1, abrevio, pre_descriprest ;
 		into cursor mwklista

else
	select nombre, fechatur, pre_descriprest, ;
		iif(dow(fechatur) = 2, 'Lunes', iif(dow(fechatur) = 3, 'Martes', ;
		iif(dow(fechatur) = 4, 'Miercoles', iif(dow(fechatur) = 5, 'Jueves', ;
		iif(dow(fechatur) = 6, 'Viernes', 'Sabado'))))) as dia, ; 		
		sum(iif(afiliado = 0, 1, 0000)) as libre, ;
 		sum(iif(afiliado > 0, 1, 0000)) as ocupa, ;
 		sum(iif(afiliado > 0 and confirmado = 0, 1, 0000)) as falto, ; 
 		sum(iif(afiliado > 0 and confirmado = 1, 1, 0000)) as vino, ; 
 		count(afiliado) as ofrecido, hdesde1, hhasta1, cantidad, porcentaje ;
 		from mwktodosa ;
 		group by nombre, fechatur, hdesde1, hhasta1, pre_descriprest ;
 		order by nombre, fechatur, hdesde1, hhasta1, pre_descriprest ;
 		into cursor mwklista
endif