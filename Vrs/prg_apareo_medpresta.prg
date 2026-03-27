****
** Apareo Archivos de Medpresta Permanentes Vs Temporarios
****

mcon1= SQLCONNECT('Conec02','_system','sys')

** parameters md_fecha_age
	mfecpas			= ctod('01/01/1900')
	md_fecha_age	= ctod('19/11/2002')
	md_fecha_age1	= ctot(dtoc(md_fecha_age))
	mdiasem 		= dow(md_fecha_age)

	***  selecciona los permanetes con y sin bloqueo
	mret = sqlexec(mcon1, "select f.id, f.codmed, f.diasem, f.estructura, f.fecvigend, " + ;
							"f.fecvigenh, f.horadesde, f.horahasta, f.imparchivo, " + ;
							"f.tiposervicio, f.fechagraba, b.codprest, b.fechadesde, b.fechahasta " + ;
							"from prestadores, franjahoraria as f left outer join tabbloqueos as b on " + ;
								"f.id = b.idfranja and f.diasem = b.diasem " + ;
							"where f.diasem = ?mdiasem and " + ;
								"?md_fecha_age >= f.fecvigend and " + ;
								"?md_fecha_age <= f.fecvigenh and " + ;
								"f.codmed = prestadores.id and " + ;
								"prestadores.fecpasiva = ?mfecpas and " + ;
								"f.estructura = 'P'", "mwkfranjap")
	
	*** busco las frecuencias que generan
	mret = sqlexec(mcon1, "select f.id, f.codmed, f.diasem, f.estructura, f.fecvigend, " + ;
							"f.fecvigenh, f.horadesde, f.horahasta, f.imparchivo, " + ;
							"f.tiposervicio, f.fechagraba " + ;
							"from franjahoraria as f, tabfrecuencias, prestadores " + ;
							"where f.id = tabfrecuencias.idfranja and " + ;
							"(?md_fecha_age1 = dateadd('dd', cantdias, fechageneracion) or " + ;
							"?md_fecha_age = fecha) and " + ;
							"?md_fecha_age >= fecvigend and " + ;
							"?md_fecha_age <= fecvigenh and " + ;
							"f.codmed = prestadores.id and " + ;
							"prestadores.fecpasiva = ?mfecpas and " + ;
							"estructura = 'P'", "mwkfranjapf")

	*** busco las frecuencias que no generan
	mret = sqlexec(mcon1, "select f.id, f.codmed, f.diasem, f.estructura, f.fecvigend, " + ;
							"f.fecvigenh, f.horadesde, f.horahasta, f.imparchivo, " + ;
							"f.tiposervicio, f.fechagraba " + ;
							"from franjahoraria as f, tabfrecuencias, prestadores " + ;
							"where f.id = tabfrecuencias.idfranja and " + ;
							"(?md_fecha_age1 <> dateadd('dd', cantdias, fechageneracion) or " + ;
							"?md_fecha_age <> fecha) and " + ;
							"?md_fecha_age >= fecvigend and " + ;
							"?md_fecha_age <= fecvigenh and " + ;
							"f.codmed = prestadores.id and " + ;
							"prestadores.fecpasiva = ?mfecpas and " + ;
							"estructura = 'P'", "mwkfranjapfn")

	***
	***
	***  selecciona los transitorios con y sin bloqueo			   				
	mret = sqlexec(mcon1, "select f.id, f.codmed, f.diasem, f.estructura, f.fecvigend, " + ;
							"f.fecvigenh, f.horadesde, f.horahasta, f.imparchivo, " + ;
							"f.tiposervicio, f.fechagraba, b.codprest, b.fechadesde, b.fechahasta " + ;
							"from prestadores, franjahoraria as f left outer join tabbloqueos as b on " + ;
								"f.id = b.idfranja and f.diasem = b.diasem " + ;
							"where f.diasem = ?mdiasem and " + ;
								"?md_fecha_age >= f.fecvigend and " + ;
								"?md_fecha_age <= f.fecvigenh and " + ;
								"f.codmed = prestadores.id and " + ;
								"prestadores.fecpasiva = ?mfecpas and " + ;
								"f.estructura = 'T' " + ;
							"order by f.codmed, f.id desc ", "mwkfranjat")


	*** busco las frecuencias que no generan
	mret = sqlexec(mcon1, "select f.id, f.codmed, f.diasem, f.estructura, f.fecvigend, " + ;
							"f.fecvigenh, f.horadesde, f.horahasta, f.imparchivo, " + ;
							"f.tiposervicio, f.fechagraba " + ;
							"from franjahoraria as f, tabfrecuencias, prestadores " + ;
							"where f.id = tabfrecuencias.idfranja and " + ;
							"(?md_fecha_age1 <> dateadd('dd', cantdias, fechageneracion) or " + ;
							"?md_fecha_age <> fecha) and " + ;
							"?md_fecha_age >= fecvigend and " + ;
							"?md_fecha_age <= fecvigenh and " + ;
							"f.codmed = prestadores.id and " + ;
							"prestadores.fecpasiva = ?mfecpas and " + ;
							"estructura = 'T'", "mwkfranjatfn")
	
	*** busco los codigos de medicos
	select codmed from mwkfranjat ;
	group by codmed ;
	into cursor mwkmed
	
	do while !eof('mwkmed')
	
		mcodmed = mwkmed.codmed
		select * from mwkfranjat where codmed = mcodmed into cursor mwkmiro
		mcantreg = _tally

		if mcantreg > 1
			do while !eof('mwkmiro')
			
				mhorades = mwkmiro.horadesde
				mhorahas = mwkmiro.horahasta
				midreg	 = mwkmiro.id
			
				select * from mwkfranjat ;
				where mwkfranjat.id = midreg and mwkfranjat.codmed = mcodmed ;
				into cursor mwkmiro1
			
				if mwkmiro1.estructura = 'T'
				
					update mwkfranjat ;
						set estructura = 'A' ;
						where codmed = mcodmed and id <> midreg and ;
							round(val(strtran(left(ttoc(horadesde,2), 5), ':', '')), 0) >= ;
							round(val(strtran(left(ttoc(mhorades,2), 5), ':', '')), 0) and ;
							round(val(strtran(left(ttoc(horahasta,2), 5), ':', '')), 0) =< ;
							round(val(strtran(left(ttoc(mhorahas,2), 5), ':', '')), 0) 

					update mwkfranjat ;
						set estructura = 'A' ;
						where codmed = mcodmed and id <> midreg and ;
							round(val(strtran(left(ttoc(mhorades,2), 5), ':', '')), 0) < ;
							round(val(strtran(left(ttoc(horadesde,2), 5), ':', '')), 0) and ;
							round(val(strtran(left(ttoc(mhorahas,2), 5), ':', '')), 0) > ;
							round(val(strtran(left(ttoc(horadesde,2), 5), ':', '')), 0) 
							
					update mwkfranjat ;
						set estructura = 'A' ;
						where codmed = mcodmed and id <> midreg and ;
							round(val(strtran(left(ttoc(mhorades,2), 5), ':', '')), 0) < ;
							round(val(strtran(left(ttoc(horahasta,2), 5), ':', '')), 0) and ;
							round(val(strtran(left(ttoc(mhorahas,2), 5), ':', '')), 0) > ;
							round(val(strtran(left(ttoc(horahasta,2), 5), ':', '')), 0) 

					update mwkfranjat ;
						set estructura = 'A' ;
						where codmed = mcodmed and id <> midreg and ;
							round(val(strtran(left(ttoc(mhorades,2), 5), ':', '')), 0) <= ;
							round(val(strtran(left(ttoc(horadesde,2), 5), ':', '')), 0) and ;
							round(val(strtran(left(ttoc(mhorahas,2), 5), ':', '')), 0) >= ;
							round(val(strtran(left(ttoc(horahasta,2), 5), ':', '')), 0) 
					
				endif	
				select mwkmiro
				skip 1 in mwkmiro
			enddo	
		endif	
		skip 1 in mwkmed
	
	enddo

	*** saco todos los medicos que estan en frecuencia por no generar						
	do while !eof('mwkfranjatfn')
		
		update mwkfranjat set estructura = 'A' ;
		where mwkfranjat.codmed = mwkfranjatfn.codmed and id = mwkfranjatfn.id				
		
		skip 1 in mwkfranjatfn
	enddo

	*** depuro los bloqueados
	select * from mwkfranjat ;
	where (!between(md_fecha_age,fechadesde, fechahasta) or isnull(fechadesde)) ;
	into cursor mwkfranjat1

	*** depuro los anulados
	select * from mwkfranjat1 ;
	where estructura = 'T' ;
	into cursor mwkfranjat2

	*** elimino desde los temporarios hacia permanentes y frecuencias
	do while !eof('mwkfranjat2')
	
		mcodmed		= mwkfranjat2.codmed
		mhorades	= mwkfranjat2.horadesde
		mhorahas	= mwkfranjat2.horahasta
		
		**** busco en los permanentes	
		update mwkfranjap ;
			set estructura = 'A' ;
			where codmed = mcodmed and ;
				round(val(strtran(left(ttoc(horadesde,2), 5), ':', '')), 0) >= ;
				round(val(strtran(left(ttoc(mhorades,2), 5), ':', '')), 0) and ;
				round(val(strtran(left(ttoc(horahasta,2), 5), ':', '')), 0) =< ;
				round(val(strtran(left(ttoc(mhorahas,2), 5), ':', '')), 0)
			
		update mwkfranjap ;
			set estructura = 'A' ;
			where codmed = mcodmed and ;
				round(val(strtran(left(ttoc(mhorades,2), 5), ':', '')), 0) < ;
				round(val(strtran(left(ttoc(horadesde,2), 5), ':', '')), 0) and ;
				round(val(strtran(left(ttoc(mhorahas,2), 5), ':', '')), 0) > ;
				round(val(strtran(left(ttoc(horadesde,2), 5), ':', '')), 0) 

		update mwkfranjap ;
			set estructura = 'A' ;
			where codmed = mcodmed and ;
				round(val(strtran(left(ttoc(mhorades,2), 5), ':', '')), 0) < ;
				round(val(strtran(left(ttoc(horahasta,2), 5), ':', '')), 0) and ;
				round(val(strtran(left(ttoc(mhorahas,2), 5), ':', '')), 0) > ;
				round(val(strtran(left(ttoc(horahasta,2), 5), ':', '')), 0) 

		update mwkfranjap ;
			set estructura = 'A' ;
			where codmed = mcodmed and ;
				round(val(strtran(left(ttoc(mhorades,2), 5), ':', '')), 0) <= ;
				round(val(strtran(left(ttoc(horadesde,2), 5), ':', '')), 0) and ;
				round(val(strtran(left(ttoc(mhorahas,2), 5), ':', '')), 0) >= ;
				round(val(strtran(left(ttoc(horahasta,2), 5), ':', '')), 0) 
					
		**** busco en las frecuencias
		update mwkfranjapf ;
			set estructura = 'A' ;
			where codmed = mcodmed and ;
				round(val(strtran(left(ttoc(horadesde,2), 5), ':', '')), 0) >= ;
				round(val(strtran(left(ttoc(mhorades,2), 5), ':', '')), 0) and ;
				round(val(strtran(left(ttoc(horahasta,2), 5), ':', '')), 0) =< ;
				round(val(strtran(left(ttoc(mhorahas,2), 5), ':', '')), 0) 

		update mwkfranjapf ;
			set estructura = 'A' ;
			where codmed = mcodmed and ;
				round(val(strtran(left(ttoc(mhorades,2), 5), ':', '')), 0) < ;
				round(val(strtran(left(ttoc(horadesde,2), 5), ':', '')), 0) and ;
				round(val(strtran(left(ttoc(mhorahas,2), 5), ':', '')), 0) > ;
				round(val(strtran(left(ttoc(horadesde,2), 5), ':', '')), 0) 

		update mwkfranjapf ;
			set estructura = 'A' ;
			where codmed = mcodmed and ;
				round(val(strtran(left(ttoc(mhorades,2), 5), ':', '')), 0) < ;
				round(val(strtran(left(ttoc(horahasta,2), 5), ':', '')), 0) and ;
				round(val(strtran(left(ttoc(mhorahas,2), 5), ':', '')), 0) > ;
				round(val(strtran(left(ttoc(horahasta,2), 5), ':', '')), 0) 

		update mwkfranjapf ;
			set estructura = 'A' ;
			where codmed = mcodmed and ;
				round(val(strtran(left(ttoc(mhorades,2), 5), ':', '')), 0) <= ;
				round(val(strtran(left(ttoc(horadesde,2), 5), ':', '')), 0) and ;
				round(val(strtran(left(ttoc(mhorahas,2), 5), ':', '')), 0) >= ;
				round(val(strtran(left(ttoc(horahasta,2), 5), ':', '')), 0) 


		skip 1 in mwkfranjat2
	enddo	

	*** saco todos los medicos que estan en frecuencia							
	do while !eof('mwkfranjapfn')
		
		update mwkfranjap set estructura = 'A' ;
		where mwkfranjap.codmed = mwkfranjapfn.codmed and id = mwkfranjapfn.id 				
		
		skip 1 in mwkfranjapfn
	enddo

	select mwkfranjap
	go top
	
	*** saco los eliminados por frecuencia y temporarios							
	select * from mwkfranjap ;
	where estructura = 'P' ;	
	into cursor mwkfranjap1

	*** saco los bloqueados							
	select * from mwkfranjap1 ;
	where (!between(md_fecha_age,fechadesde, fechahasta) or isnull(fechadesde)) ;	
	into cursor mwkfranjap2

	*** junto todos 
	select * from mwkfranjap2 ;
	union all ;
	select * from mwkfranjat2 ;
	into cursor mwkfranjas
	
	select * from mwkfranjas ;
	order by codmed into cursor mwkfranjasa

*****
**  Genero la nueva estructura de medpresta
*****

	do while !eof('mwkfranjasa')
		
		mcodmed = mwkfranjasa.codmed
		mdiasem = mwkfranjasa.diasem
		mhdesde = mwkfranjasa.horadesde
		mhhasta = mwkfranjasa.horahasta
		mfvigd  = mwkfranjasa.fecvigend
		mfvigh  = mwkfranjasa.fecvigenh
		
		if mwkfranjasa.estructura = 'P'
			marchivo = 'medprestamae'
		else
			marchivo = 'medprestatem'
		endif

		mret = sqlexec(mcon1, 'select * from &marchivo where codmed = ?mcodmed and ' + ;
								'diasem = ?mdiasem and ?md_fecha_age >= fecvigend and ' + ;
								'?md_fecha_age < fecvigenh and ' + ;
								'fechaultagenda < ?md_fecha_age', 'mwkpresta')
								 
		do while !eof('mwkpresta')
		
			if	round(val(strtran(left(ttoc(mwkpresta.horadesde,2), 5), ':', '')), 0) >= ;
				round(val(strtran(left(ttoc(mwkfranjasa.horadesde,2), 5), ':', '')), 0) and ;
				round(val(strtran(left(ttoc(mwkpresta.horahasta,2), 5), ':', '')), 0) <= ;
				round(val(strtran(left(ttoc(mwkfranjasa.horahasta,2), 5), ':', '')), 0) 
		
			&& insert de medpresta	
				midfra 	= mwkfranjasa.id
				mestru	= mwkfranjasa.estructura
				mimpar	= mwkfranjasa.imparchivo
				mtipse	= mwkfranjasa.tiposervicio
				mcantu	= iif(isnull(mwkpresta.canturnos), 1, mwkpresta.canturnos)
				mcodme	= mwkpresta.codmed
				mcodpr	= mwkpresta.codprest			
				mcodse	= mwkpresta.codserv
				mcodes	= mwkpresta.codesp
				mdurac  = ttoc(mwkpresta.duracion,2)
				mfecul	= mwkpresta.fechaultagenda
				mfecde	= mwkpresta.fecvigend
				mfecha	= mwkpresta.fecvigenh
				mfbaja	= ctot('01/01/1900')
				mfgrab	= datetime()
				mgenag	= 1
				mhdesd	= mwkpresta.horadesde
				mhhast	= mwkpresta.horahasta
				mobser	= ''
				msala	= alltrim(mwkpresta.sala)
				musuba	= ''
				
				mret = sqlexec(mcon1, "insert into medprestaa values(?mcantu, ?mcodes, ?mcodme, " + ;
										"?mcodpr, ?mcodse, ?mdiasem, ?mdurac, ?mestru, ?md_fecha_age, " + ;
										"?mfecul, ?mfecde, ?mfecha, ?mfbaja, ?mfgrab, ?mgenag, " + ;
										"?mhdesd, ?mhhast, ?midfra, ?mimpar, ?mobser, ?msala, " + ;
										"?mtipse, ?midusu, ?musuba)") 
			endif
			skip 1 in mwkpresta
		enddo
		skip 1 in mwkfranjasa	

	enddo
	
=sqldisconnect(mcon1)	