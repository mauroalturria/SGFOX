****
** Listado estadistico para Morgulis primero disponible, cantidad ocupados, libres
** Modificado por Claudia el 13/6/03 linea 7, 8 ,10 y 11  de ambos querys
****

parameter mfecdes, mfechas, mbusco1,mbusco2 

	mret = sqlexec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
		'  where id<100000 order by fechacierre ','mwkctrlfecha')
	go bottom in mwkctrlfecha
	mfechalimite = mwkctrlfecha.fechacierre
	use in mwkctrlfecha
	mret = sqlexec(mcon1, "select codmed, diasem, fecvigend, fecvigenh, horadesde, horahasta, " + ;
			" abrevio, estructura "+; 
			", {fn HOUR(horadesde)}*100+{fn MINUTE(horadesde)} as hdf " +;
			", {fn HOUR(horahasta)}*100+{fn MINUTE(horahasta)} as hhf " +;
			" from franjahoraria left join tabtipofranja on tiposervicio = tabtipofranja.id " + ;
			" where fecvigenh > ?mfecdes &mbusco2 " + ;
			"group by codmed, diasem, horahasta, fecvigenh, tiposervicio " + ;
			" ", "mwkfranjas")
	if mret < 0 
		=aerr(eros)
		messagebox(eros(2), 16, "Validacion")
		messagebox(eros(3), 16, "Validacion")
	endif
	mret = sqlexec(mcon1, " select codmed, diasem, fecvigend,codesp "+;
					  ", fecvigenh,  hdesde1, hhasta1, horadesde, ESP_descripcion, horahasta "+;
					", {fn HOUR(hdesde1)}*100+{fn MINUTE(hdesde1)} as hdm " +;
					", {fn HOUR(hhasta1)}*100+{fn MINUTE(hhasta1)} as hhm " +;
					  " from medpresta, especialid "+;
					  " where diasem > 0 &mbusco2 "+;
					" and trim(medpresta.codesp) = especialid.ESP_codesp " + ;
					  " and fecvigenh > ?mfecdes "+;
					  " group by codmed, diasem, fecvigenh, hdesde1 ","Mwkmedpre")
	if mret < 0 
		=aerr(eros)
		messagebox(eros(2), 16, "Validacion")
		messagebox(eros(3), 16, "Validacion")
	endif

	mret = sqlexec(mcon1, "select turnos.*, nombre " + ;
							", {fn HOUR(horatur)}*100+{fn MINUTE(horatur)} as ht " +;
							"from turnos, prestadores " + ;
							"where turnos.codmed =  prestadores.id and " + ;
								"turnos.fechatur >= ?mfecdes and turnos.fechatur <= ?mfechas and " + ;
								"turnos.tipoturno < 9 &mbusco2 " + ;
							" " , "mwktodosa")
	if mret < 0 
		=aerr(eros)
		messagebox(eros(2), 16, "Validacion")
		messagebox(eros(3), 16, "Validacion")
	endif
if mfecdes <= mfechalimite
		mret = sqlexec(mcon1, "select turnos.*, nombre " + ;
							", {fn HOUR(horatur)}*100+{fn MINUTE(horatur)} as ht " +;
							"from turnoshis as turnos, prestadores" + ;
								"where turnos.codmed =  prestadores.id and " + ;
									"turnos.fechatur >= ?mfecdes and turnos.fechatur <= ?mfechas and " + ;
									"turnos.tipoturno < 9 &mbusco2 " + ;
								" " , "mwktodosa")
								

	if mret < 0 
		messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
		cancel
	endif

		select *,iif(afiliado = 0,id, afiliado) as afi  from mwktodosa ;
		union all ;
		select *,iif(afiliado = 0,id, afiliado) as afi  from mwktodosb ;
		into cursor mwktodos 
else
		select *,iif(afiliado = 0,id, afiliado) as afi  from mwktodosa ;
		into cursor mwktodos 
endif	
select mwktodos.*,nvl(mwkfranjas.abrevio,"S/D") as abrevio, Mwkmedpre.codesp, ESP_descripcion ;
	from mwktodos ;
	left join Mwkmedpre on (mwktodos.fechatur >= Mwkmedpre.fecvigend and ;
		  mwktodos.fechatur <  Mwkmedpre.fecvigenh and ; 
		  ht >= hdm and ht<hhm and ;
		  mwktodos.codmed = Mwkmedpre.codmed and ;
		  mwktodos.diasem = Mwkmedpre.diasem );
	left join mwkfranjas on (mwktodos.fechatur >= mwkfranjas.fecvigend and ;
		  mwktodos.fechatur <  mwkfranjas.fecvigenh and ; 
		  ht >= hdf and ht<hhf and ;
		  mwktodos.codmed = mwkfranjas.codmed and ;
		  mwktodos.diasem = mwkfranjas.diasem );
	where 1= 1 &mbusco1;
	group by afi,mwktodos.codmed, mwktodos.codesp, fechatur, horatur, tipoturno ;
	into cursor mwktodosg	
	
select * from mwktodosg	;
into cursor mwktodos

	select nombre, fechatur, abrevio, ;
		(fechatur - mfecdes) as dias, ;
		iif(dow(fechatur) = 2, 'Lun', iif(dow(fechatur) = 3, 'Mar', ;
		iif(dow(fechatur) = 4, 'Mie', iif(dow(fechatur) = 5, 'Jue', ;
		iif(dow(fechatur) = 6, 'Vie', 'Sab'))))) as dia, ; 		
		sum(iif(afiliado = 0, 1, 0000)) as libre, ;
 		sum(iif(afiliado > 0, 1, 0000)) as ocupa, ;
 		sum(iif(tipoturno = 0, 1, 0000)) as tn, ; 
 		sum(iif(tipoturno = 1, 1, 0000)) as so, ;
 		sum(iif(tipoturno = 2, 1, 0000)) as st, ;
 		sum(iif(tipoturno = 3, 1, 0000)) as gi, ;
 		sum(iif(tipoturno = 4, 1, 0000)) as es, ;
 		sum(iif(tipoturno = 5, 1, 0000)) as ps, ;  
 		sum(iif(tipoturno = 6, 1, 0000)) as re, ;
 		sum(iif(tipoturno = 7, 1, 0000)) as pe, ;  
 		count(afi) as ofrecido, ESP_descripcion, codmed ;
 		from mwktodos ;
 		group by nombre, fechatur, abrevio ;
 		order by nombre, fechatur ;
 		into cursor mwklista

	select nombre, fechatur, abrevio, ;
		(fechatur - mfecdes) as dias, ;
		iif(dow(fechatur) = 2, 'Lun', iif(dow(fechatur) = 3, 'Mar', ;
		iif(dow(fechatur) = 4, 'Mie', iif(dow(fechatur) = 5, 'Jue', ;
		iif(dow(fechatur) = 6, 'Vie', 'Sab'))))) as dia, ; 		
		sum(iif(afiliado = 0, 1, 0000)) as libre, ;
 		sum(iif(afiliado > 0, 1, 0000)) as ocupa, ;
 		sum(iif(afiliado = 0 and tipoturno = 0, 1, 0000)) as tn, ; 
 		sum(iif(afiliado = 0 and tipoturno = 1, 1, 0000)) as so, ;
 		sum(iif(afiliado = 0 and tipoturno = 2, 1, 0000)) as st, ;
 		sum(iif(afiliado = 0 and tipoturno = 3, 1, 0000)) as gi, ;
 		sum(iif(afiliado = 0 and tipoturno = 4, 1, 0000)) as es, ;
 		sum(iif(afiliado = 0 and tipoturno = 5, 1, 0000)) as ps, ;  
 		sum(iif(afiliado = 0 and tipoturno = 6, 1, 0000)) as re, ;
 		sum(iif(afiliado = 0 and tipoturno = 7, 1, 0000)) as pe, ;  
 		count(afiliado) as ofrecido, ESP_descripcion, codmed ;
 		from mwktodos ;
 		group by nombre, fechatur, abrevio ;
 		order by nombre, fechatur ;
 		into cursor mwklista1
