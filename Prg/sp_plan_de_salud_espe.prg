*****************************
* Genera Plan de Salud 
* AUTOR:Claudia Antoniow
*****************************
* FECHA:20/08/2002
*****************************
	 
	mndiasem=dow(mdmasX)
	mncanttur=1 
	
	*Sql 1) de plan de salud que trata criterio=Cantidad por franja y por hr. reservada de turno (No insert del turno)
*	do sp_busco_med_prepaga with mdmasX,mndiasem,'F','R','MWKPlanS_FR',0		
if mxambito >1
	mccpoamb = "  medpresta.codambito = ?mxambito and "
else
	mccpoamb = ''	
endif
	mret=sqlexec(mcon1,"select a.cantidadps,a.codmed,a.tipodato, " + ;
								"a.criterio,a.diasem,a.horadesde,a.horahasta " + ;
						"from tabprepaga as a " + ;
						"where ?mdmasX between a.fecvigend and a.fecvigenh and " + ;
						"a.diasem = ?mndiasem and " + ;
						"a.criterio = 'F' and a.tipodato = 'R' "+;
						" And a.codmed in (select codmed  from medpresta " + ;
								"WHERE &mccpoamb diasem =?mndiasem and codesp=?mccodesp and " + ;
								"?mdmasX between fecvigend and fecvigenh " + ;
								"group by codmed) "+;
						"order by A.Codmed","MWKPlanS_FR")
 	
	sele MWKPlanS_FR
	go top

	do while !eof('MWKPlanS_FR') 
		
		mncodmed  =MWKPlanS_FR.codmed
		mnporc    =MWKPlanS_FR.cantidadps
		mtfechatur=mdmasX
		thora     =ttoc(MWKPlanS_FR.Horadesde,2)
		thorad    = MWKPlanS_FR.Horadesde
		thorah    = MWKPlanS_FR.Horahasta
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
*	do sp_busco_med_prepaga with mdmasX,mndiasem,'F','A','MWKPlanS_FA',0
	
	mret=sqlexec(mcon1,"select a.cantidadps, a.codmed, a.tipodato, " + ;
						"a.criterio, a.diasem, a.horadesde, a.horahasta " + ;
						"from tabprepaga as a " + ;
 						"where ?mdmasX between a.fecvigend and a.fecvigenh and " + ;
 							"a.criterio= 'F' and a.tipodato= 'A' And " + ;
 							"a.codmed in (select codmed  " + ;
 								"from medpresta WHERE &mccpoamb diasem = ?mndiasem and " + ;  
 							"?mdmasX between fecvigend and fecvigenh " + ;
 								"group by codmed, diasem, horadesde)  " + ;
 						"order by A.Codmed","MWKPlanS_FA")
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