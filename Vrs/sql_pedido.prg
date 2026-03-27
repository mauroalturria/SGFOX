****
** sQL DE BUSQUEDA DE TURNOS
****

if used('mwkmedp')
	select mwkmedp
	use
endif

if used('mwktur')
	select mwktur
	use
endif


mbusqueda = ''
if msql_espe <> '' 
	mbusqueda = "medpresta.codesp = ?msql_espe "
endif

if msql_presta > 0 
	if mbusqueda = ''
		mbusqueda = "medpresta.codprest = ?msql_presta "
	else
		mbusqueda = mbusqueda + " and medpresta.codprest = ?msql_presta "
	endif
endif

if msql_codmed > 0
	if mbusqueda = ''
		mbusqueda = "medpresta.codmed = ?msql_codmed "
	else
		mbusqueda = mbusqueda + " and medpresta.codmed = ?msql_codmed "
	endif		
endif

mret = sqlexec(mcon1, "select codmed, diasem, horadesde, horahasta, codprest, sala, " + ;
						"fecvigend, fecvigenh, hdesde1, hhasta1 " + ;
						"from medpresta " + ; 
						"where &mbusqueda " + ;
						"and diasem > 0 and generaagen = 1 " + ;
						"order by codmed, diasem, hdesde1 " , "mwkmedp")

if mret < 0 
	messagebox('ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS', 16,'Validacion')
	cancel
endif

	select codmed from mwkmedp group by codmed into cursor mwkseparo

	mlis_id = "" 
				
	do while !eof('mwkseparo')

		if mlis_id = ""
			mlis_id = "in(" + allt(str(mwkseparo.codmed, 5))
		else
			mlis_id = mlis_id + "," + allt(str(mwkseparo.codmed, 5))
		endif
		skip 1 in mwkseparo	
	enddo
	
	if mlis_id = ""
		mlis_id =  "in(0)"
		messagebox("NO HAY MEDICO ASOCIADO A ESTA PRESTACION", 64,"Validacion")
		
	else					
		mlis_id = mlis_id + ")"
	endif
	
mret = sqlexec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codmed, " + ; 
 						"turnos.codserv, turnos.codesp, turnos.diasem, turnos.tipoturno, " + ;
						"prestadores.nombre " + ;
 						"from turnos, prestadores, tabnivel " + ;
 						"where turnos.codmed = prestadores.id and " + ;
 						"turnos.codmed &mlis_id and " + ;
       					"turnos.afiliado = 0 and " + ;
      					"tabnivel.nivel = ?msql_nivel and " + ;
      					"turnos.tipoturno = tabnivel.tipoturno and " + ;
      				    "turnos.diasem &msql_dias and " + ;
      				    "turnos.fechatur >= ?msql_fecha " + ;
      					"&msql_horas "  + ;
      					"order by fechatur, horatur, codmed, turnos.tipoturno ", "mwktur")
      					
if mret < 0 
	messagebox('ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS', 16,'Validacion')
	cancel
endif

	select turnos.id, turnos.fechatur, turnos.horatur, turnos.codmed, ;
		turnos.codserv, turnos.codesp, turnos.diasem, turnos.tipoturno, ;
		medpresta.codprest, medpresta.horadesde, medpresta.horahasta,  ;
		medpresta.sala, fecvigend, fecvigenh, nombre  ;
	from mwktur as turnos, mwkmedp as medpresta ;
	where medpresta.codmed = turnos.codmed and  ;
			medpresta.diasem = turnos.diasem and  ;
     		fechatur >= fecvigend and fechatur < fecvigenh  ;
    group by fechatur, horatur, turnos.codmed, turnos.tipoturno, medpresta.hdesde1 ;
	order by fechatur into cursor mwkturnos
     

     
