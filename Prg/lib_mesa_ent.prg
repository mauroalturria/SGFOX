*********************************************************
* Libreria de procedimiento y funciones
*********************************************************
**************************
**************************
procedure EjecutoSql
parameters formulario, fecha1, fecha2

*!*	if type(fecha1)#'D'
*!*		fecha1 = mhoy
*!*	endif	
*!*	if type(fecha2)#'D'
*!*		fecha2 = mhoy
*!*	endif	
	*!***********************
	*!**Conecto los motivos
	*!***********************
   if formulario= 0
   	 mret = SQLEXEC(mcon1,"Select motivotext, idmotivo "+;
   	 						"from motivos order by motivotext","mwkmotivos1")
  	 if mret < 0
		=aerr(eros)
  		  messagebox("Los Motivos no estan  disponibles - Informar a Sistemas",0+64,"Conexion")
   	 endif
  endif
  *!*****************************************
  *!*Connecto Personas que estan  sin atender
  *!***************************************** 
  if formulario = 1 or formulario = 0
  	 mret = SQLEXEC(mcon1,"SELECT	SOCIO.HoraLLegada, MOTIVOS.MotivoText,"+;
  	 						" SOCIO.ApellidoNombre, SOCIO.Observacion, "+;
  	 						" SOCIO.HoraAtencion,ObservaA, Horafinalizacion,"+;
							" paciente,MOTIVOS.MotivoText, operadora, OperadoraA, "+;
							" puestoatencion,  "+;
  	 						" SOCIO.IdSocio, MOTIVOS.IdMotivo "+;
							" FROM	SOCIO, MOTIVOS "+;
							" WHERE	SOCIO.IdMotivo = MOTIVOS.IdMotivo "+;
							" AND SOCIO.HoraAtencion is Null AND SOCIO.Atendido=0 "+;
							" ORDER	BY SOCIO.HoraLLegada ","mwkLLegadas")
  	 if mret < 0
  	 	=aerr(eros)
  		messagebox("No esta disponibles la lista de Esperas - Informar a Sistemas",0+64,"Conexion")
  	 endif		
  else
		if fecha1 < fecha2
			vbusco =" AND cast(SOCIO.HoraAtencion as date) between ?fecha1 and ?fecha2 "
		else
			vbusco =" AND cast(SOCIO.HoraAtencion as date) = ?fecha1 "
		endif	
  		
  		mret = SQLEXEC(mcon1," SELECT SOCIO.HoraLLegada, MOTIVOS.MotivoText, "+;
							" SOCIO.ApellidoNombre, SOCIO.Observacion, "+;
							" SOCIO.HoraAtencion, ObservaA, Horafinalizacion,"+;
							" A.MotivoText, operadora, OperadoraA,"+;
							" puestoatencion, SOCIO.IdSocio, "+;
							" MOTIVOS.IdMotivo,SOCIO.IdMotivoA,paciente "+;
							" FROM	SOCIO, MOTIVOS, MOTIVOS As A "+;
							" WHERE	SOCIO.IdMotivo = MOTIVOS.IdMotivo "+;
							" AND SOCIO.IdMotivoA =* A.IdMotivo "+;
							" AND SOCIO.Atendido = 1 "+ vbusco +;
							" ORDER	BY SOCIO.HoraLLegada ","mwkAtendidoA")
  	 	if mret < 0
  			=aerr(eros)
  			messagebox("No esta disponibles la lista de Atendidos - Informar a Sistemas",0+64,"Conexion")
  		else
  			mret = SQLEXEC(mcon1," SELECT SOCIO.HoraLLegada, MOTIVOS.MotivoText, "+;
							" SOCIO.ApellidoNombre, SOCIO.Observacion, "+;
							" SOCIO.HoraAtencion, ObservaA, Horafinalizacion,"+;
							" A.MotivoText, operadora, OperadoraA,"+;
							" puestoatencion, SOCIO.IdSocio, "+;
							" MOTIVOS.IdMotivo,SOCIO.IdMotivoA,paciente "+;
							" FROM	SOCIOHIS as SOCIO, MOTIVOS, MOTIVOS As A "+;
							" WHERE	SOCIO.IdMotivo = MOTIVOS.IdMotivo "+;
							" AND SOCIO.IdMotivoA =* A.IdMotivo "+;
							" AND SOCIO.Atendido = 1 "+ vbusco +;
							" ORDER	BY SOCIO.HoraLLegada ","mwkAtendidoH")
  	 		if mret < 0
  				=aerr(eros)
  				messagebox("No esta disponibles la lista de Atendidos - Informar a Sistemas",0+64,"Conexion")
  			else
  				select * from mwkAtendidoA;
  				union;
  				select * from mwkAtendidoh into cursor mwkAtendidos
  			endif
  		endif		
  endif
************************************* 
*************************************
procedure GuardoMov
parameters mape, midA, mobA,mdtF,mpac,midI,mobI,mdtll,mdtA,mopA,maten,mopI
*!************************************************************************************
*!* Rutinas del Boton de Guardado:
*!* Parametros Apellido y Nombre(mape);ID de Motivo (mid);Observacion(mob); 
*!* Fecha/Hora en que comienza ha ser atendido (mdt); Nombre del form que lo llama(mForm)
*!************************************************************************************

mret =sqlexec(mcon1," INSERT INTO SocioMod(ApellidoNombre, Atendido, "+;
 				    " HoraAtencion, HoraFinalizacion, HoraLLegada, "+;
 				    " IdMotivo, IdSocio, ObservaA, Observacion, "+;
 				    " OperadoraA, Operadora, puestoAtencion, IdMotivoA, "+;
 				    " Paciente )"+;
					" VALUES (?mape,1,?mdtA,?mdtF,?mdtll,?midI,?midsocio,"+;
					" ?mobA,?mobI,?mopA,?mopI,?maten,?midA,?mpac)")
								  
if mret > 0
	=aerr(merror)
	return .T.
else
	return .f.
endif
  
*****************************************************
***************************************************** 
procedure GuardoDatosSQL
parameters mape, mid, mob,mdt,mForm,meven,mpac,dq
*!************************************************************************************
*!* Rutinas del Boton de Guardado:
*!* Parametros Apellido y Nombre(mape);ID de Motivo (mid);Observacion(mob); 
*!* Fecha/Hora en que comienza ha ser atendido (mdt); Nombre del form que lo llama(mForm)
*!*************************************************************************************
*!***********************************************
*!* Traigo el mayor Id para generar el autonumerico
*!***********************************************
mret=SQLEXEC(mcon1,"SELECT	MAX(IdSocio) as IdSocio FROM SOCIO","mwkrreg")		 
  
if mret < 0
 	=aerr(eros)
 	messagebox("No se puede acceder a algunos Datos",0+64,"Usuario")
 	GuardoDatosSQL = .F.
else
	mnombre = allt(mwkusuario.idusuario)
	maten   = sys(0)
	mdtf    = sp_busco_fecha_serv('DT')
	

	if mForm = "frmMesa1"
		midpers= nvl(mwkrreg.IdSocio,0) + 1	
		mret =sqlexec(mcon1,"INSERT INTO Socio(ApellidoNombre, Atendido, "+;
							  "HoraLLegada,IdMotivo,IdSocio,Observacion,Operadora,puestoAtencion)"+;
							  "VALUES (?mape,0,?mdt,?mid,?midpers,?mob,?mnombre,?maten)")
		if mret<0
			=aerr(eros)
		endif							  
		mret_v =sqlexec(mcon1,"select OperadorA from Socio "+;
								  " where Horallegada=?mdt and atendido = 0 "+;
								  " and Operadora= ?mnombre "+;
							 	  " and  IdSocio= ?midpers",'mwkQuienGraba')				  
		if mret_v<0
			=aerr(erosv)
		endif							  
	else
		
		if meven=1
			if dq = 0
				mret =sqlexec(mcon1,"UPDATE Socio SET "+;
								  "HoraFinalizacion=?mdtf, atendido=1, "+;
								  "IdMotivoA=?mid, ObservaA=?mob, PuestoAtencion=?maten,"+;
								  "OperadoraA=?mnombre,Paciente=?mpac "+;
								  "WHERE IdSocio= ?midSocio and HoraFinalizacion is null")
				if mret<0
					=aerr(eros)
				endif							  
			else
				
				mret =sqlexec(mcon1,"UPDATE Socio SET "+;
								  "HoraFinalizacion=?mdtf, "+;
								  "IdMotivoA=?mid, ObservaA=?mob, PuestoAtencion=?maten,"+;
								  "OperadoraA=?mnombre,Paciente=?mpac "+;
								  "WHERE IdSocio= ?midSocio ")				  
								  
				if mret<0
					=aerr(eros)
				endif							  
			endif				  
		else
			mret =sqlexec(mcon1,"UPDATE Socio SET HoraAtencion=?mdt,atendido =1, "+;
									" OperadoraA= ?mnombre "+;
							 		 " WHERE IdSocio= ?midSocio and HoraAtencion is null ")
							 		 
			if mret<0
				=aerr(eros)
			endif							  
		 		 
		endif					  
	endif

	if mret > 0
		if meven=1
			messagebox("Se Guardaron los Datos Exitosamente!!!",0+64,"Usuario")
			GuardoDatosSQL = .T.
		else
			mret_v =sqlexec(mcon1,"select OperadorA,horaAtencion from Socio "+;
								  " where OperadoraA like ?mnombre "+;
							 	  " and  IdSocio = ?midSocio and horaAtencion is not null ",'mwkQuienGraba')	
			if mret_v > 0
				
				if eof('mwkQuienGraba')
					messagebox("Este Paciente fue llamado por Otro Operador ",64,'Usuario')
					GuardoDatosSQL = .F.
				else
					GuardoDatosSQL = .T.
				endif	
			else
				GuardoDatosSQL = .F.
			endif	
		Endif	
	else
	
		messagebox("No se Actualizaron, avisar a sistemas del siguiente error",0+64,"Usuario")	
		messagebox(eros(3))
		GuardoDatosSQL = .F.
	endif
endif	
return GuardoDatosSQL

procedure GuardoMot
parameters v_descriMot, midm

*********************************************************
*********************************************************
mret=SQLEXEC(mcon1,"insert into motivos values(?midm,?v_descriMot)") 
if mret < 0
 	messagebox("No se puede acceder a algunos Datos",0+64,"Usuario")
 	return .F. 
else
	messagebox("Se Actualizo la tabla, avisar a sistemas ",0+64,"Usuario")	
	return .T.
endif


*********************************************
*********************************************  
Procedure ActualizoGrid
parameters V_Cursor, formulario, morden
*********************************************  
* Carga la Grilla y el combo
********************************************* 
if type('morden')#"C"
	morden = 'dia,horallegada'
endif
with .pg.pgdatos	
	 .cbomotivos.controlsource = "mwkmotivos1.IdMotivo"
	 .cbomotivos.rowsource     = "mwkmotivos1.MotivoText, IdMotivo"
endwith
with .pg.pgCatalogo.Grid1 
	if used(V_Cursor)
		.enabled = .t.
					
		if formulario = 1 or formulario = 0
			Select ttod(horallegada) as dia, ttoc(horallegada,2) as horallegada,; 
	    			ApellidoNombre, MotivoText, Observacion, MotivoText1,; 
	    			ObservaA, paciente, IdSocio, IdMotivo ;
	    	from &V_Cursor order by &morden into cursor mwkLLega
	    	
	    	.columncount  = 6
	    	.column1.header1.caption ='Fecha'
	    	.column1.width = 50
	    	.column2.header1.caption = 'Hs Ll'
	    	.column2.width = 90
	    	.column3.header1.caption ='Apellido, Nombre'
	    	.column3.width = 200
	    	.column4.header1.caption ='Motivos'
	    	.column4.width = 150
			.column5.header1.caption ='Observacion'
			.column5.width =200
			.column6.header1.caption =''
			.column6.width =2
	    	.column1.header1.comment = 'dia'
	    	.column2.header1.comment = 'dia,horallegada'
	    	.column3.header1.comment = 'ApellidoNombre'
	    	.column4.header1.comment = 'MotivoText'
	    	.column5.header1.comment = 'Observacion'
	    	.column6.header1.comment = 'dia'
			
	    	.RecordSource ="Select * from mwkLLega " +;
	    				   " into cursor mwkLLegadas1"
			.Column2.controlsource	= "mwkllegadas1.horallegada"
	    
	    else
	    	Select ttod(horallegada) as dia, ttoc(horallegada,2) as horallegada,;
	    			ApellidoNombre,MotivoText1,operadora, operadoraA,; 
	    			ttoc(horaAtencion,2) as horaAtencion,; 
	    			ttoc(horafinalizacion,2) as horafinalizacion,;
	    			MotivoText, puestoAtencion,;
	    			IdSocio, IdMotivo, IdMotivoA,ObservaA, Observacion, paciente;
	    	from &V_Cursor order by &morden into cursor mwkLLega
	    	
	    	.columncount  = 9
	    	.column1.header1.caption ='Fecha'
		    .column1.width = 50
	    	.column2.header1.caption ='Hs Ll'
	    	.column2.width = 60
	    	.column3.header1.caption ='Apellido, Nombre'
	    	.column3.width = 150
	    	.column4.header1.caption ='Motivo Atendido'
	    	.column4.width = 85
			.column5.header1.caption ='Operadora Ingreso'
			.column5.width =90
			.column6.header1.caption ='Operadora Atendio'
			.column6.width =90
			.column7.header1.caption ='Hora Atendido'
	    	.column7.width =60
	    	.column8.header1.caption ='Hora finalizacion'
	    	.column8.width =60
	    	.column9.header1.caption ='Motivo Ingreso'
			.column9.width =80
	    
	    	.column1.header1.comment = 'dia'
	    	.column2.header1.comment = 'dia,horallegada'
	    	.column3.header1.comment = 'ApellidoNombre'
    		.column4.header1.comment = 'MotivoText1'
	    	.column5.header1.comment = 'operadora'
	    	.column6.header1.comment = 'operadoraA'
	    	.column7.header1.comment = 'horaAtencion'
	    	.column8.header1.comment = 'horafinalizacion'
	    	.column9.header1.comment = 'MotivoText'
*!*				.column12.header1.caption =
*!*				.column12.width =150
			
			
			
	    	.RecordSource = "Select * from mwkLLega order by &morden "+;
    				        "into cursor mwkLLegadas1 "
			.Column2.controlsource	= "mwkllegadas1.horallegada"
		endif
	else
		.enabled = .f.
	endif
endwith		 


************************************************
************************************************ 
Procedure VoyAlosDatos 
parameters formu
************************************************
*mueve el foco a la grilla de la primera pagina
************************************************
mdtf    = sp_busco_fecha_serv('DT')

midSocio   = mwkllegadas1.IdSocio
mapenom    = allt(mwkllegadas1.ApellidoNombre)
mmot_ini   = iif(isnull(mwkllegadas1.Motivotext1),mwkllegadas1.Motivotext,;
													mwkllegadas1.Motivotext1)
				
				
select mwkmotivos1
go top
locate for idmotivo = mwkllegadas1.IdMotivo	
mmotIng   = iif(found(), mwkmotivos1.Motivotext,'ERROR AVISAR A SISTEMAS') 
								
mobsI= iif(isnull(mwkllegadas1.Observacion),'',ALLT(mwkllegadas1.Observacion))
mobsA= iif(isnull(mwkllegadas1.ObservaA),'',ALLT(mwkllegadas1.ObservaA))
mpacA= iif(isnull(mwkllegadas1.paciente),'',ALLT(mwkllegadas1.paciente))
			 	
with .pg

	if formu = 0
		if GuardoDatosSQL(mwkllegadas1.ApellidoNombre,;
		 						 mwkllegadas1.IdMotivo, mwkllegadas1.Observacion,;
		 						 mdtf,"frmmesa2",0,'',formu)
		
			.activePage = 2
			 with .pgdatos
	
				.txtapenom.value         = mapenom  
				.cbomotivos.displayvalue = mmot_ini 
				.cbomotivos.value        = mwkllegadas1.IdMotivo
				.txtmotivoI.value        = mmotIng   
					    
									
				.edtobservacion.value = mobsI
				.edtobservaA.value    = mobsA
				.txtpaciente.value    = mpacA
				 	
			endwith
		else
			.Pgdatos.enabled = .f.
			.activePage = 1
		endif
	else			
		.activePage = 2
		with .pgdatos
			.txtapenom.value         = mapenom  
			.cbomotivos.displayvalue = mmot_ini 
			.cbomotivos.value        = mwkllegadas1.IdMotivo	
			.txtmotivoI.value        = mmotIng    
									
			.edtobservacion.value = mobsI
			.edtobservaA.value    = mobsA
			.txtpaciente.value    = mpacA
		endwith	
	endif	
	
endwith	

Function sp_busco_fecha_serv(vr_tipo)

mret=sqlexec(mcon1,"SELECT {fn convert({fn TIMESTAMPADD(SQL_TSI_DAY,dias,current_timestamp)},SQL_timestamp)} as fechaHora "+;
				   "from deltfec ","MWKFecServ")

if mret < 0
	if vr_tipo = 'DT'	
		vr_fdia = datetime()
	else
		vr_fdia = date()
	endif
else
	
	if vr_tipo = 'DT'	
		vr_fdia = MWKFecServ.fechaHora
	else
		vr_fdia = ttod(MWKFecServ.fechaHora)
	endif

endif

return vr_fdia

Procedure Creo_excel 
parameters url_arch_xlt, titulo, Vcursor_dat, Vcursor_nom, TitCamp, nomcamp
oleapp = createobject("excel.application")
		
oleapp.workbooks.open(url_arch_xlt )
oleapp.cells(2,2).value  =  titulo
i = 6
J = 0
pto='.'

sele &Vcursor_dat	 
go top
do while !eof(Vcursor_dat)
	sele &Vcursor_nom
	go top	 
	do while !eof(Vcursor_nom)
		j = j + 1
		
		oleapp.cells(5,j).value   = &Vcursor_nom &pto &TitCamp
		nomb =&Vcursor_nom &pto &Nomcamp
		oleapp.cells(i,j).value   =&Vcursor_dat &pto &nomb
		
		
		if !eof(Vcursor_nom)
			skip 1 in &Vcursor_nom
		else
			exit
		endif		
		
	enddo
	j = 0
	i = i + 1
	if !eof(Vcursor_dat)
		skip 1 in &Vcursor_dat
	else
		exit
	endif	
	
enddo

oleapp.visible = .t.	
