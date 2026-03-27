****
** Listado estadistico para Morgulis primero disponible, cantidad ocupados, libres
****

parameter mfecdes, mfechas, mbusco1, mlista

lsigue = .t.
** Control de fecha de cierre
	mret = sqlexec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
		' order by fechacierre ','mwkctrlfecha')
	go bottom in mwkctrlfecha
	mfechalimite = mwkctrlfecha.fechacierre
	use in mwkctrlfecha

mret = sqlexec(mcon1, "select afiliado, fechatur, horatur, codmed, nombre, " + ;
						"tipoturno, confirmado, turnos.diasem " + ;
						", {fn HOUR(horatur)}*100+{fn MINUTE(horatur)} as ht " +;
						"from turnos, prestadores " + ;
						"where turnos.codmed = prestadores.id and " + ;
						"fechatur >= ?mfecdes and fechatur <= ?mfechas and " + ;
						"tipoturno < 9 " + ;
						"&mbusco1 ", "mwktodosa")

if mfecdes <= mfechalimite

	mret = sqlexec(mcon1, "select afiliado, fechatur, horatur, turnos.codmed, nombre, " + ;
			"turnos.tipoturno, confirmado, turnos.diasem " + ;
			"from turnoshis as turnos, prestadores " + ;
			"where turnos.codmed = prestadores.id and " + ;
			"fechatur >= ?mfecdes and fechatur <= ?mfechas and " + ;
			"turnos.tipoturno < 9 " + ; 
			"&mbusco1 ", "mwktodosb")
endif							
mret = sqlexec(mcon1, "select codmed, diasem, fecvigend, fecvigenh, horadesde, horahasta, " + ;
			" tipoturno as pe, abrevio, estructura "+; 
			", {fn HOUR(horadesde)}*100+{fn MINUTE(horadesde)} as hdf " +;
			", {fn HOUR(horahasta)}*100+{fn MINUTE(horahasta)} as hhf " +;
			" from franjahoraria, tabtipofranja " + ;
			" where fecvigenh > ?mfecdes and " + ;
				"tiposervicio = tabtipofranja.id " + ;
			"group by codmed, diasem, horahasta, fecvigenh, tiposervicio " + ;
			"order by codmed, diasem ", "mwkfranjas")						
						
if mret < 0 
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
	cancel
endif

if mfecdes <= mfechalimite
	select * from mwktodosa ;
	union all ;
	select * from mwktodosb ;
	into cursor mwktodos
else
	select * from mwktodosa ;
	into cursor mwktodos
endif						
do sp_medpresta_mas_st_sos with mfechas

select mwktodos.diasem,	mwktodos.codmed, afiliado, fechatur, horatur, nombre, ;
	mwktodos.tipoturno, confirmado, hdesde1, hhasta1, cantidad, porcentaje, mwkfranjas.abrevio, pe, ;
	mwkmedpre.horadesde, mwkmedpre.horahasta, estructura ; 
	from mwktodos
	left join mwkmedpre on (mwktodos.fechatur >= mwkmedpre.fecvigend and ;
		  mwktodos.fechatur <  mwkmedpre.fecvigenh and ; 
		  ht >= hdm and ht<hhm and ;
		  mwktodos.codmed = mwkmedpre.codmed and ;
		  mwktodos.diasem = mwkmedpre.diasem );
	left join mwkfranjas on (mwktodos.fechatur >= mwkfranjas.fecvigend and ;
		  mwktodos.fechatur <  mwkfranjas.fecvigenh and ; 
		  ht >= hdf and ht<hhf and ;
		  mwktodos.codmed = mwkfranjas.codmed and ;
		  mwktodos.diasem = mwkfranjas.diasem );
	into cursor mwktodosa	

if mlista = 1
	select nombre, fechatur, ;
		iif(diasem = 2, 'Lun', iif(diasem = 3, 'Mar', ;
		iif(diasem = 4, 'Mie', iif(diasem = 5, 'Jue', ;
		iif(diasem = 6, 'Vie', 'Sab'))))) as dia, ; 		
		sum(iif(afiliado = 0, 1, 0000)) as libre, ;
 		sum(iif(afiliado > 0, 1, 0000)) as ocupa, ;
 		sum(iif(afiliado > 0 and confirmado = 0, 1, 0000)) as falto, ; 
 		sum(iif(afiliado > 0 and confirmado = 1, 1, 0000)) as vino, ; 
 		count(afiliado) as ofrecido, hdesde1, hhasta1, cantidad, ;
 		porcentaje, abrevio, pe, estructura ;
 		from mwktodosa ;
 		group by nombre, diasem, horadesde, horahasta, abrevio ;
 		order by nombre, diasem, horadesde, horahasta, abrevio ;
 		into cursor mwklista

else
	select nombre, fechatur, ;
		iif(dow(fechatur) = 2, 'Lunes', iif(dow(fechatur) = 3, 'Martes', ;
		iif(dow(fechatur) = 4, 'Miercoles', iif(dow(fechatur) = 5, 'Jueves', ;
		iif(dow(fechatur) = 6, 'Viernes', 'Sabado'))))) as dia, ; 		
		sum(iif(afiliado = 0, 1, 0000)) as libre, ;
 		sum(iif(afiliado > 0, 1, 0000)) as ocupa, ;
 		sum(iif(afiliado > 0 and confirmado = 0, 1, 0000)) as falto, ; 
 		sum(iif(afiliado > 0 and confirmado = 1, 1, 0000)) as vino, ; 
 		count(afiliado) as ofrecido, hdesde1, hhasta1, cantidad, porcentaje ;
 		from mwktodosa ;
 		group by nombre, fechatur, horadesde, horahasta ;
 		order by nombre, fechatur, horadesde, horahasta ;
 		into cursor mwklista
endif