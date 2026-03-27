*****************************
* Genera Plan de Salud 
* AUTOR:Claudia Antoniow
*****************************
* FECHA:20/08/2002
*****************************
	 
	mndiasem=dow(mdmasX)
	mncanttur=1 
	
	*Sql 1) de plan de salud que trata criterio=Cantidad por franja y por hr. reservada de turno (No insert del turno)
	do sp_busco_med_prepaga with mdmasX,mndiasem,'F','R','MWKPlanS_FR',0				

	sele MWKPlanS_FR
	go top
	do while !eof('MWKPlanS_FR') 
		
		mncodmed	= MWKPlanS_FR.codmed
		mnporc		= MWKPlanS_FR.cantidadps
		mtfechatur	= mdmasX
		thora		= ttoc(MWKPlanS_FR.Horadesde,2)
		thorad		= MWKPlanS_FR.Horadesde
		thorah		= MWKPlanS_FR.Horahasta
		
		if mnporc > 0 
		
			do sp_valido_PS
			sele MWKExisteTurno
			go top
			if reccount('MWKExisteTurno') = 0
				do sp_datos_sobretur
				sele MwkPorcSOfer
				go top
				if reccount('MwkPorcSOfer')>0
					do sp_reservo_PlanS.prg					
				endif
			endif
		endif
		if used('MWKExisteTurno')
			sele MWKExisteTurno
			use
		endif	
		if used('MwkPorcSOfer')
			sele MwkPorcSOfer
			use
		endif
		if USED('MWKHorasTr')
			sele MWKHorasTr
			use
		endif	
		
		skip 1 in MWKPlanS_FR
	enddo			

		 
	*Sql 2) de plan de salud que trata criterio=Cantidad por franja y por turno Agregado
	do sp_busco_med_prepaga with mdmasX,mndiasem,'F','A','MWKPlanS_FA',0
						 

	sele MWKPlanS_FA
	go top
	do while !eof('MWKPlanS_FA') 
		
		mncodmed  =MWKPlanS_FA.codmed
		mnporc    =MWKPlanS_FA.cantidadps
		mtfechatur=mdmasX
		thora     =ttoc(MWKPlanS_FA.Horadesde,2)
		thorad    = MWKPlanS_FA.Horadesde
		thorah    = MWKPlanS_FA.Horahasta
		
		if mnporc >0 
			do sp_valido_PS.prg	
			sele MWKExisteTurno
			go top
			if eof('MWKExisteTurno') or bof('MWKExisteTurno')
				*mnporc  =MWKPlanS_FA.cantidad
				do sp_datos_sobretur.prg	
				sele MwkPorcSOfer
				go top
				if !eof('MwkPorcSOfer') or !bof('MwkPorcSOfer')
			   		if MwkPorcSOfer.Cantur >0
			   			do sp_cargo_PlanS.prg	
			   		endif	
				endif	  
			endif
		endif
		if used('MWKExisteTurno')
			sele MWKExisteTurno
			use
		endif	
		if used('MwkPorcSOfer')
			sele MwkPorcSOfer
			use
		endif
		if USED('MWKHorasTr')
			sele MWKHorasTr
			use
		endif	
		
		skip 1 in MWKPlanS_FA
	enddo
	
	*Sql 2) de plan de salud que trata criterio=Cantidad por franja y por turno Agregado
	do sp_busco_med_prepaga with mdmasX,mndiasem,'T','R','MWKPlanS_TR',0
						 

	sele MWKPlanS_TR
	go top
	do while !eof('MWKPlanS_TR') 
		
		mncodmed  =MWKPlanS_TR.codmed
		mnporc    =100
		mtfechatur= mdmasX
		thora     =ttoc(MWKPlanS_TR.Horadesde,2)
		thorad    = MWKPlanS_TR.Horadesde
		thorah    = MWKPlanS_TR.Horahasta
		
		if mnporc =100 
			do sp_valido_PS.prg	
			sele MWKExisteTurno
			go top
			if eof('MWKExisteTurno') or bof('MWKExisteTurno')
				mnporc  =100
				do sp_datos_sobretur.prg	
				sele MwkPorcSOfer
				go top
				if !eof('MwkPorcSOfer') or !bof('MwkPorcSOfer')
			   		if MwkPorcSOfer.Cantur >0
			   			do sp_reservo_PlanS.prg	
			   		endif	
				endif	  
			endif
		endif
		if used('MWKExisteTurno')
			sele MWKExisteTurno
			use
		endif	
		if used('MwkPorcSOfer')
			sele MwkPorcSOfer
			use
		endif
		if USED('MWKHorasTr')
			sele MWKHorasTr
			use
		endif	
		
		skip 1 in MWKPlanS_TR
	enddo