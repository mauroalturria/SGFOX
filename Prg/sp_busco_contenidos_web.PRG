*
* Elaboración de Tabla Contenidos
* hConn = MySql
* mcon1 = Cache
*

Wait "GENERANDO TABLA DE CONTENIDOS WEB, AGUARDE UNOS MINUTOS" Windows Nowait

*!* Quitar, para pruebas

*!*	Set DATE TO FRENCH
*!*	Set CENTURY ON
*!*	Set SYSMENU TO
*!*	Set EXCLUSIVE OFF
*!*	Set DECIMALS TO 2
*!*	Set MULTILOCKS ON
*!*	Set NOTIFY OFF
*!*	Set CPDIALOG OFF
*!*	Set SAFETY OFF
*!*	hConn = Sqlstringconnect("Driver=MySQL ODBC 3.51 Driver;Server=172.16.2.101;UID=malturria;PWD=mauro;Database=prueba")
*!*	=SQLSETPROP(hConn,"Transactions",2)
*!*	=SQLSETPROP(hConn,"Asynchronous",.F.)

*!* mpaso = .t.

*!*
*!* Actualización Tabla MySql Especialidades
*!*

mret = sqlexec(hConn,"delete from TabEspec")
If mret > 0
	If used('mwkTabEspec')
		Use in mwkTabEspec
	Endif
	mret = sqlexec(mcon1,"select esp_codesp,esp_descripcion from especialid where ESP_Web = 'S'","mwkTabEspec")
	If mret > 0
		Select mwkTabEspec
		Scan
			mcod = mwkTabEspec.esp_codesp
			mdes = mwkTabEspec.esp_descripcion
			mret = sqlexec(hConn,"insert into TabEspec (Esp_codesp,Esp_descripcion) values (?mcod,?mdes)")
			If mret < 0
				mpaso = .f.
				Messagebox("EN ACTUALIZACION MAESTRO MySQL TabEspec",16,"ERROR")
				Exit
			Endif
		Endscan
		Use in mwkTabEspec
	Else
		mpaso = .f.
		Messagebox("EN CONSULTA MAESTRO DE ESPECIALIDADES",16,"ERROR")
	Endif
Else
	mpaso = .f.
	Messagebox("EN INICILIZACION MAESTRO MySQL TabEspec",16,"ERROR")
Endif

*!*
*!* Actualización Tabla MySql Coordinadores
*!*
If mpaso

	If file('c:\temp\web2\archtcl.txt')
		Delete file c:\temp\web2\archtcl.txt
	Endif

	mret = sqlexec(hConn,"delete from TabCoordL")
	If mret > 0
		If used('mwkTabCoordL')
			Use in mwkTabCoordL
		Endif
		
*!*			mret = sqlexec(mcon1,"Select prestadores.id as iDmedico,prestadores.nombre as lnombre"+;
*!*				" From prestadores"+;
*!*				" Left join TabProfEsp on prestadores.id = TabProfEsp.codprof"+;
*!*				" Left join tabcargo on TabProfEsp.codcargo = tabcargo.id"+;
*!*				" Left join especialid on TabProfEsp.codiesp = especialid.esp_codesp"+;
*!*				" Where"+;
*!*				" ((dambula = 1 and (prestadores.fecpasiva='1900-01-01' or"+;
*!*				" prestadores.fecpasiva > current_date)"+;
*!*				" And (prestadores.fecalta <= current_date )) or"+;
*!*				" (dguardia = 1 and (prestadores.fecpasivag='1900-01-01' or"+;
*!*				" prestadores.fecpasivag > current_date)"+;
*!*				" And (prestadores.fecaltag <= current_date )) or"+;
*!*				" (dinterna = 1 and (prestadores.fecpasivai='1900-01-01' or"+;
*!*				" prestadores.fecpasivai > current_date)"+;
*!*				" And (prestadores.fecaltai <= current_date )) or"+;
*!*				" (prestadores.fecaltap <= current_date ))"+;
*!*				" And (prestadores.fecpasivap='1900-01-01' or  prestadores.fecpasivap >current_date)"+;
*!*				" And codiesp is not null and codcargo is not null"+;
*!*				" And esp_descripcion is not null"+;
*!*				" And prestadores.web = 'S'"+;
*!*				" And especialid.ESP_Web = 'S'"+;
*!*				" And ( TabProfEsp.codcargo = 1 or TabProfEsp.codcargo = 13 or TabProfEsp.codcargo = 18)"+;
*!*				" Group by prestadores.id"+;
*!*				" Order by TabProfEsp.codcargo,prestadores.id,esp_descripcion,nombre","mwkTabCoordL")
			
			
            mret = sqlexec(mcon1,"select prestadores.id as IDmedico,prestadores.nombre as lnombre"+;
				" from prestadores"+;
				" left join TabProfEsp on prestadores.id=tabprofesp.codprof"+;
				" left join tabcargo on tabprofesp.codcargo = tabcargo.id"+;
				" left join especialid on tabprofesp.codiesp = especialid.esp_codesp"+;
				" left join tabareades on tabprofesp.codarea = tabareades.id"+;
				" where"+;
				" ( ( dambula = 1 and (prestadores.fecpasiva='1900-01-01' or prestadores.fecpasiva >current_date)"+;
				" and (prestadores.fecalta <= current_date ) ) or ( dguardia = 1 and (prestadores.fecpasivag='1900-01-01'"+;
				" or prestadores.fecpasivag > current_date) and (prestadores.fecaltag <= current_date )  )"+;
				" or ( dinterna = 1 and (prestadores.fecpasivai='1900-01-01'"+;
				" or prestadores.fecpasivai > current_date) and (prestadores.fecaltai <= current_date ) )"+;
				" or (prestadores.fecaltap <= current_date ))"+;
				" and (prestadores.fecpasivap='1900-01-01' or  prestadores.fecpasivap > current_date) and CodCargo in (20,21,25,26,42,40)"+;
				" group by prestadores.id","mwkTabCoordL")
								
*!*	select
*!*	, tabprofesp.codiesp,especialid.esp_descripcion,"+;
*!*				    "tabprofesp.codarea,tabareades.area,tabprofesp.CodCargo,tabcargo.descrip,prestadores.fecaltap,prestadores.fecpasivap,"+;
*!*					"prestadores.cuil, prestadores.matriculas, prestadores.nroproveedor ,prestadores.email, prestadores.fecalta as FechaAmbA,"+;
*!*					"prestadores.fecpasiva as FechaAmbB, prestadores.fecaltag as FechaGuaA, prestadores.fecpasivag as FechaGuaB,"+;
*!*					"prestadores.fecaltai as FechaIntA, prestadores.fecpasivai as FechaIntB, prestadores.lseguro ,"+;
*!*					"(trim(upper(tabcargo.descrip)) || ' ' || trim(upper(tabareades.area))) as campo1,"+;
*!*					"(case when trim(upper(tabareades.area)) = 'GUARDIA' THEN 'GUAR' ELSE codiesp END ) as campo2,"+;
*!*					"(case when trim(upper(tabareades.area)) = 'GUARDIA' THEN 'GUARDIA MEDICA (EMERGENCIAS MEDICAS)' "+;
*!*					" ELSE tabareades.area END ) as campo3"+;								
								
*group ,tabprofesp.codarea order by esp_descripcion,nombre,codcargo,tabprofesp.codarea								
								
		If mret > 0
			Select mwkTabCoordL
			Scan
				mlid = mwkTabCoordL.iDmedico
				mnom = mwkTabCoordL.lnombre
				mmail = space(40)
				mcarg = space(40)
				mret = sqlexec(hConn,"insert into TabCoordL (TSC_IdMed,TSC_apenom,TSC_cargo,TSC_email) values (?mlid,?mnom,?mcarg,?mmail)")
				If mret < 0
					mpaso = .f.
					Messagebox("EN ACTUALIZACION MAESTRO MySQL TabCoordL",16,"ERROR")
					Exit
				Endif

				mlid2 = transform(mlid,"99999")
				mlinea = ''
				mlinea = mlid2+'|'+mnom+'|'+mcarg+'|'+mmail+chr(13)+chr(10)
				Strtofile( mlinea, "c:\temp\web2\archtcl.txt", .t. )

			Endscan
			Use in mwkTabCoordL
		Else
			mpaso = .f.
			Messagebox("EN CONSULTA MAESTRO DE COORDINADORES",16,"ERROR")
		Endif
	Else
		mpaso = .f.
		Messagebox("EN INICILIZACION MAESTRO MySQL TabCoordL",16,"ERROR")
	Endif
Endif

*!*
*!* Actualización Tabla MySql SubCoordinadores
*!*
If mpaso

	If file('c:\temp\web2\archtscl.txt')
		Delete file c:\temp\web2\archtscl.txt
	Endif

	mret = sqlexec(hConn,"delete from TabSubCoordL")
	If mret > 0
		If used('mwkTabCoordL')
			Use in mwkTabCoordL
		Endif
*!*			mret = sqlexec(mcon1,"Select prestadores.id as iDmedico,prestadores.nombre as lnombre"+;
*!*				" From prestadores"+;
*!*				" Left join TabProfEsp on prestadores.id = TabProfEsp.codprof"+;
*!*				" Left join tabcargo on TabProfEsp.codcargo = tabcargo.id"+;
*!*				" Left join especialid on TabProfEsp.codiesp = especialid.esp_codesp"+;
*!*				" Where"+;
*!*				" ((dambula = 1 and (prestadores.fecpasiva='1900-01-01' or"+;
*!*				" prestadores.fecpasiva > current_date)"+;
*!*				" And (prestadores.fecalta <= current_date )) or"+;
*!*				" (dguardia = 1 and (prestadores.fecpasivag='1900-01-01' or"+;
*!*				" prestadores.fecpasivag > current_date)"+;
*!*				" And (prestadores.fecaltag <= current_date )) or"+;
*!*				" (dinterna = 1 and (prestadores.fecpasivai='1900-01-01' or"+;
*!*				" prestadores.fecpasivai > current_date)"+;
*!*				" And (prestadores.fecaltai <= current_date )) or"+;
*!*				" (prestadores.fecaltap <= current_date ))"+;
*!*				" And (prestadores.fecpasivap='1900-01-01' or  prestadores.fecpasivap > current_date)"+;
*!*				" And codiesp is not null and codcargo is not null"+;
*!*				" And esp_descripcion is not null"+;
*!*				" And prestadores.web = 'S'"+;
*!*				" And especialid.ESP_Web = 'S'"+;
*!*				" And ((TabProfEsp.codcargo >= 2 and TabProfEsp.codcargo <= 4)"+;
*!*				" Or ( TabProfEsp.codcargo >= 14 and TabProfEsp.codcargo <= 17))"+;
*!*				" Group by prestadores.id"+;
*!*				" Order by prestadores.id,esp_descripcion,nombre,TabProfEsp.codcargo","mwkTabSubCoordL")
*!*				
			 mret = sqlexec(mcon1,"select prestadores.id as IDmedico,prestadores.nombre as lnombre"+;
				" from prestadores"+;
				" left join TabProfEsp on prestadores.id=tabprofesp.codprof"+;
				" left join tabcargo on tabprofesp.codcargo = tabcargo.id"+;
				" left join especialid on tabprofesp.codiesp = especialid.esp_codesp"+;
				" left join tabareades on tabprofesp.codarea = tabareades.id"+;
				" where"+;
				" ( ( dambula = 1 and (prestadores.fecpasiva='1900-01-01' or prestadores.fecpasiva >current_date)"+;
				" and (prestadores.fecalta <= current_date ) ) or ( dguardia = 1 and (prestadores.fecpasivag='1900-01-01'"+;
				" or prestadores.fecpasivag > current_date) and (prestadores.fecaltag <= current_date )  )"+;
				" or ( dinterna = 1 and (prestadores.fecpasivai='1900-01-01'"+;
				" or prestadores.fecpasivai > current_date) and (prestadores.fecaltai <= current_date ) )"+;
				" or (prestadores.fecaltap <= current_date ))"+;
				" and (prestadores.fecpasivap='1900-01-01' or  prestadores.fecpasivap > current_date) "+;
				" and tabcargo.staff = 2 and not ( CodCargo in (20,21,25,26,42,40))"+;
				" group by prestadores.id","mwkTabSubCoordL")

		If mret > 0
		
			Select mwkTabSubCoordL
			Scan
				mlid = mwkTabSubCoordL.iDmedico
				mnom = mwkTabSubCoordL.lnombre
				mcarg = space(40)
				mmail = space(40)
				mret = sqlexec(hConn,"insert into TabSubCoordL (TSC_IdMed,TSC_apenom,TSC_cargo,TSC_email) values (?mlid,?mnom,?mcarg,?mmail)")
				If mret < 0
					mpaso = .f.
					Messagebox("EN ACTUALIZACION MAESTRO MySQL TabSubCoordL",16,"ERROR")
					Exit
				Endif

				mlid2 = transform(mlid,"99999")
				mlinea = ''
				mlinea = mlid2+'|'+mnom+'|'+mcarg+'|'+mmail+chr(13)+chr(10)
				Strtofile( mlinea, "c:\temp\web2\archtscl.txt", .t. )

			Endscan
			Use in mwkTabSubCoordL
		Else
			mpaso = .f.
			Messagebox("EN CONSULTA MAESTRO DE SUBCOORDINADORES",16,"ERROR")
		Endif
	Else
		mpaso = .f.
		Messagebox("EN INICILIZACION MAESTRO MySQL TabSubCoordL",16,"ERROR")
	Endif
Endif

If mpaso
	mret = sqlexec(hConn,"delete from contenido")
	If mret > 0
		
		
		use in select("mwkpresta")
		
*!*			mret = sqlexec(mcon1,"select prestadores.id as iDmedico,prestadores.nombre,TabProfEsp.codiesp"+;
*!*				" from prestadores"+;
*!*				" left join TabProfEsp on prestadores.id=tabprofesp.codprof"+;
*!*				" left join tabcargo on tabprofesp.codcargo = tabcargo.id"+;
*!*				" left join especialid on tabprofesp.codiesp = especialid.esp_codesp"+;
*!*				" where"+;
*!*				" ((dambula = 1 and (prestadores.fecpasiva='1900-01-01' or prestadores.fecpasiva > current_date)"+;
*!*				" and (prestadores.fecalta <= current_date )) or"+;
*!*				" (dguardia = 1 and (prestadores.fecpasivag='1900-01-01' or prestadores.fecpasivag > current_date)"+;
*!*				" and (prestadores.fecaltag <= current_date )) or"+;
*!*				" (dinterna = 1 and (prestadores.fecpasivai='1900-01-01' or prestadores.fecpasivai > current_date)"+;
*!*				" and (prestadores.fecaltai <= current_date )) or"+;
*!*				" (prestadores.fecaltap <= current_date ))"+;
*!*				" and (prestadores.fecpasivap='1900-01-01' or  prestadores.fecpasivap > current_date)"+;
*!*				" and codiesp is not null and (codcargo = 1 or codcargo = 13 or codcargo = 18)"+;
*!*				" and esp_descripcion is not null"+;
*!*				" and PRESTADORES.web = 'S'"+;
*!*				" and especialid.ESP_Web = 'S'"+;
*!*				" order by prestadores.id,ESP_descripcion,tabprofesp.CodCargo,nombre","mwkpresta")
*!*				
			

			mret = sqlexec(mcon1,"select prestadores.id as IDmedico,prestadores.nombre, tabprofesp.codiesp,especialid.esp_descripcion,"+;
			    "tabprofesp.codarea,tabareades.area,tabprofesp.CodCargo,tabcargo.descrip,prestadores.fecaltap,prestadores.fecpasivap,"+;
				"prestadores.cuil, prestadores.matriculas, prestadores.nroproveedor ,prestadores.email, prestadores.fecalta as FechaAmbA,"+;
				"prestadores.fecpasiva as FechaAmbB, prestadores.fecaltag as FechaGuaA, prestadores.fecpasivag as FechaGuaB,"+;
				"prestadores.fecaltai as FechaIntA, prestadores.fecpasivai as FechaIntB, prestadores.lseguro ,"+;
				"(trim(upper(tabcargo.descrip)) || ' ' || trim(upper(tabareades.area))) as campo1,"+;
				"(case when trim(upper(tabareades.area)) = 'GUARDIA' THEN 'GUAR' ELSE codiesp END ) as campo2,"+;
				"(case when trim(upper(tabareades.area)) = 'GUARDIA' THEN 'GUARDIA MEDICA (EMERGENCIAS MEDICAS)' "+;
				" ELSE tabareades.area END ) as campo3"+;
				" from prestadores"+;
				" left join TabProfEsp on prestadores.id=tabprofesp.codprof"+;
				" left join tabcargo on tabprofesp.codcargo = tabcargo.id"+;
				" left join especialid on tabprofesp.codiesp = especialid.esp_codesp"+;
				" left join tabareades on tabprofesp.codarea = tabareades.id"+;
				" where"+;
				" ( ( dambula = 1 and (prestadores.fecpasiva='1900-01-01' or prestadores.fecpasiva >current_date)"+;
				" and (prestadores.fecalta <= current_date ) ) or ( dguardia = 1 and (prestadores.fecpasivag='1900-01-01'"+;
				" or prestadores.fecpasivag > current_date) and (prestadores.fecaltag <= current_date )  )"+;
				" or ( dinterna = 1 and (prestadores.fecpasivai='1900-01-01'"+;
				" or prestadores.fecpasivai > current_date) and (prestadores.fecaltai <= current_date ) )"+;
				" or (prestadores.fecaltap <= current_date ))"+;
				" and (prestadores.fecpasivap='1900-01-01' or  prestadores.fecpasivap > current_date) and CodCargo in (20,21,25,26,42,40)"+;
				" group by prestadores.id,tabprofesp.codarea order by esp_descripcion,nombre,codcargo,tabprofesp.codarea","mwkpresta")
					
		
			
		If mret >0
		
		* 22/03/2012 Ver pedido Nico
		
*!*			use in select("mwkprestaG")
*!*			mret = sqlexec(mcon1,"select prestadores.id as iDmedico,prestadores.nombre,TabProfEsp.codiesp"+;
*!*				" from prestadores"+;
*!*				" left join TabProfEsp on prestadores.id=tabprofesp.codprof"+;
*!*				" left join tabcargo on tabprofesp.codcargo = tabcargo.id"+;
*!*				" left join especialid on tabprofesp.codiesp = especialid.esp_codesp"+;
*!*				" where"+;
*!*				" ((dambula = 1 and (prestadores.fecpasiva='1900-01-01' or prestadores.fecpasiva > current_date)"+;
*!*				" and (prestadores.fecalta <= current_date )) or"+;
*!*				" (dguardia = 1 and (prestadores.fecpasivag='1900-01-01' or prestadores.fecpasivag > current_date)"+;
*!*				" and (prestadores.fecaltag <= current_date )) or"+;
*!*				" (dinterna = 1 and (prestadores.fecpasivai='1900-01-01' or prestadores.fecpasivai > current_date)"+;
*!*				" and (prestadores.fecaltai <= current_date )) or"+;
*!*				" (prestadores.fecaltap <= current_date ))"+;
*!*				" and (prestadores.fecpasivap='1900-01-01' or  prestadores.fecpasivap > current_date)"+;
*!*				" and codiesp is not null and (codcargo = 1 or codcargo = 13 or codcargo = 18)"+;
*!*				" and esp_descripcion is not null"+;
*!*				" and PRESTADORES.web = 'S'"+;
*!*				" and especialid.ESP_Web = 'S'"+;
*!*				" order by prestadores.id,ESP_descripcion,tabprofesp.CodCargo,nombre","mwkprestaG")
*!*			
		
*!*			select prestadores.id as iDmedico,prestadores.nombre,TabProfEsp.codiesp,TabProfEsp.codarea
*!*	 			 from prestadores
*!*	 			 left join TabProfEsp on prestadores.id=tabprofesp.codprof
*!*	 			 left join tabcargo on tabprofesp.codcargo = tabcargo.id
*!*	 			 left join especialid on tabprofesp.codiesp = especialid.esp_codesp
*!*	 			 where
*!*	                         TabProfEsp.codarea <> 2 and
*!*	 			 ((dambula = 1 and (prestadores.fecpasiva='1900-01-01' or prestadores.fecpasiva > current_date)
*!*	 			 and (prestadores.fecalta <= current_date )) or
*!*	 			 (dguardia = 1 and (prestadores.fecpasivag='1900-01-01' or prestadores.fecpasivag > current_date)
*!*	 			 and (prestadores.fecaltag <= current_date )) or
*!*	 			 (dinterna = 1 and (prestadores.fecpasivai='1900-01-01' or prestadores.fecpasivai > current_date)
*!*	 			 and (prestadores.fecaltai <= current_date )) or
*!*	 			 (prestadores.fecaltap <= current_date ))
*!*	 			 and (prestadores.fecpasivap='1900-01-01' or  prestadores.fecpasivap > current_date)
*!*	 			 and codiesp is not null and (codcargo = 20 or codcargo = 21 or codcargo = 40)
*!*	 			 and esp_descripcion is not null
*!*	 			 and PRESTADORES.web = 'S'
*!*	 			 and especialid.ESP_Web = 'S'
*!*	 			 order by prestadores.id,ESP_descripcion,tabprofesp.CodCargo,nombre
*!*			
*!*			
*!*			
		
			If used('mwkcoord1')
				Use in mwkcoord1
			Endif
			mret = sqlexec(hConn,"select * from TabCoord order by TCO_especialidad","mwkcoord1")
			If mret > 0
				If used('mwkcoord')
					Use in mwkcoord
				Endif

*               09/04/2012
				
*!*					Select mwkcoord1.*,iDmedico,nombre from mwkcoord1,mwkpresta ;
*!*						where TCO_idMed = iDmedico and TCO_especialidad = codiesp ;
*!*						order by TCO_idmed,TCO_registro asc ;
*!*						into cursor mwkcoordN
					

				Select mwkcoord1.*,iDmedico,nombre from mwkcoord1,mwkpresta ;
					where TCO_idMed = iDmedico and TCO_especialidad = mwkpresta.campo2;
					order by TCO_idmed,TCO_registro asc ;
					into cursor mwkcoordN
					
					
					

				Select * from mwkcoordN group by TCO_idmed into cursor mwkcoord
					
				If used('mwkcoord')
					If reccount('mwkcoord') > 0
						Select mwkcoord
						Go top
						Scan
							If mwkcoord.TCO_registro <> 'REG0033' and mwkcoord.TCO_registro <> 'REG0013' and ;
									mwkcoord.TCO_registro <> 'REG0029' and mwkcoord.TCO_registro <> 'REG0035' and ;
									mwkcoord.TCO_registro <> 'REG0036' and mwkcoord.TCO_registro <> 'REG0009' and ;
									mwkcoord.TCO_registro <> 'REG0027'

								mbusca = mwkcoord.TCO_especialidad
								mtitul = 'Introducción'
								mdescr = alltrim(mwkcoord.TCO_introduccion)
								If len(mdescr) = 0
									mdescr = 'Descripción de la especialidad '+alltrim(mbusca)
								Endif
								msecci = 1
								morden = 0
								mret = sqlexec(hConn,"insert into contenido (titulo,descripcion,especialidad,seccion,orden) "+;
									"values (?mtitul,?mdescr,?mbusca,?msecci,?morden)")
								If mret < 0
									Messagebox("EN CONTENIDOS, CARGA DE INTRODUCCION",16,"ERROR")
									Exit
								Else
									msecci = 2
									morden = -1
									If len(alltrim(mwkcoord.TCO_asistencia))>0
										mtitul = 'Asistencia Ambulatoria'
										mdescr = alltrim(mwkcoord.TCO_asistencia)
										morden = morden + 1
										mret = sqlexec(hConn,"insert into contenido (titulo,descripcion,especialidad,seccion,orden) "+;
											"values (?mtitul,?mdescr,?mbusca,?msecci,?morden)")
										If mret < 0
											Messagebox("EN CONTENIDOS, CARGA DE ASISTENCIA",16,"ERROR")
											Exit
										Endif
									Endif
									If len(alltrim(mwkcoord.TCO_internacion))>0
										mtitul = 'Internación'
										mdescr = alltrim(mwkcoord.TCO_internacion)
										morden = morden + 1
										mret = sqlexec(hConn,"insert into contenido (titulo,descripcion,especialidad,seccion,orden) "+;
											"values (?mtitul,?mdescr,?mbusca,?msecci,?morden)")
										If mret < 0
											Messagebox("EN CONTENIDOS, CARGA DE INTERNACION",16,"ERROR")
											Exit
										Endif
									Endif
									If len(alltrim(mwkcoord.TCO_intervencion))>0
										mtitul = 'Intervenciones y Procedimientos'
										mdescr = alltrim(mwkcoord.TCO_intervencion)
										morden = morden + 1
										mret = sqlexec(hConn,"insert into contenido (titulo,descripcion,especialidad,seccion,orden) "+;
											"values (?mtitul,?mdescr,?mbusca,?msecci,?morden)")
										If mret < 0
											Messagebox("EN CONTENIDOS, CARGA DE INTERVENCIONES Y PROCEDIMIENTOS",16,"ERROR")
											Exit
										Endif
									Endif
									If len(alltrim(mwkcoord.TCO_emergencia))>0
										mtitul = 'Emergencia'
										mdescr = alltrim(mwkcoord.TCO_emergencia)
										morden = morden + 1
										mret = sqlexec(hConn,"insert into contenido (titulo,descripcion,especialidad,seccion,orden) "+;
											"values (?mtitul,?mdescr,?mbusca,?msecci,?morden)")
										If mret < 0
											Messagebox("EN CONTENIDOS, CARGA DE EMERGENCIA",16,"ERROR")
											Exit
										Endif
									Endif
									If len(alltrim(mwkcoord.TCO_equipo))>0
										mtitul = 'Equipamiento'
										mdescr = alltrim(mwkcoord.TCO_equipo)
										morden = morden + 1
										mret = sqlexec(hConn,"insert into contenido (titulo,descripcion,especialidad,seccion,orden) "+;
											"values (?mtitul,?mdescr,?mbusca,?msecci,?morden)")
										If mret < 0
											Messagebox("EN CONTENIDOS, CARGA DE EQUIPAMIENTO",16,"ERROR")
											Exit
										Endif
									Endif
									msecci = 3
									morden = 0
									If len(alltrim(mwkcoord.TCO_academico))>0
										mtitul = 'Actividad académica y científica'
										mdescr = alltrim(mwkcoord.TCO_academico)
										mret = sqlexec(hConn,"insert into contenido (titulo,descripcion,especialidad,seccion,orden) "+;
											"values (?mtitul,?mdescr,?mbusca,?msecci,?morden)")
										If mret < 0
											Messagebox("EN CONTENIDOS, CARGA DE EQUIPAMIENTO",16,"ERROR")
											mpaso = .f.
											Exit
										Endif
									Endif
								Endif
							Endif
						Endscan
					Endif
				Endif
			Else
				mpaso = .f.
				Messagebox("EN ACCESO A TABLA DE ESPECIALIDADES",16,"ERROR")
			Endif
		Else
			mpaso = .f.
			Messagebox("AL ACCEDER AL MAESTRO DE PRESTADORES",16,"ERROR")
		Endif
	Else
		mpaso = .f.
		Messagebox("AL INICIALIZAR MAESTRO DE CONTENIDOS",16,"ERROR")
	Endif

	If used('mwkpresta')
		Use in mwkpresta
	Endif
	If used('mwkcoord1')
		Use in mwkcoord1
	Endif
	If used('mwkcoord')
		Use in mwkcoord
	Endif

	Wait "DESCARGANDO NUEVOS ARCHIVOS DE COORDIONADORES y SUBCOORDINADORES EN WEB - SILVER" Windows Nowait

	If file('c:\temp\web2\archtcl.txt') and file('c:\temp\web2\archtscl.txt')


		Do prg_ftp_upload with "adjuntos/28/importacion/","C:\Temp\Web2\","archt*.txt",;
		"200.5.235.233","Upload","&$Upload"
		
*!*			Wait "UPLOAD FTP SILVER-CROSS (LISTAS)" Windows Nowait
*!*			Run c:\temp\web2\pasaje3.bat

		lcfile = "http://www.silver-cross.com.ar/coord/sg-importar.php"
		loBrowser = createobject("InternetExplorer.Application")
		loBrowser.Navigate(lcfile)
		loBrowser.visible=.t.
		Release loBrowser

	Endif

*!*	*!* Quitar
*!*	*!*	= SQLDisconnect(hConn)
*!*	*!*	Messagebox("PROCESO CONTENIDOS, FINALIZADO",48,"Validación")

Endif

Return
