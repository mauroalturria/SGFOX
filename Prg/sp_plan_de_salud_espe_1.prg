*****************************
* Genera Plan de Salud 
* AUTOR:Claudia Antoniow
*****************************
* FECHA:20/08/2002
*****************************
*parameters vr_thorad, vr_thorah

	 
	mndiasem=dow(mdmasX)
	mncanttur=1 
	
	*Sql 1) de plan de salud que trata criterio=Cantidad por franja y por hr. reservada de turno (No insert del turno)
	mret=sqlexec(mcon1,"select a.cantidadps,a.codmed,a.tipodato,a.criterio, " + ;
				"b.diasem,b.horadesde,b.horahasta from tabprepaga as a,(select codmed,codesp,diasem,horadesde,horahasta,fecvigend,fecvigenh "+;
 				" from medpresta WHERE diasem =?mndiasem and codesp=?mccodesp "+;
 				" and ?mdmasX between fecvigend and fecvigenh "+;
 				" group by codmed,horadesde) as b "+;
 				" where ?mdmasX between a.fecvigend and a.fecvigenh "+;
 				" and a.criterio='F' and a.tipodato='R' And a.codmed=b.codmed "+;  
 				" order by A.Codmed","MWKPlanS_FR")
 				
	
	sele MWKPlanS_FR
	go top
	do while !eof('MWKPlanS_FR') 
		
		mncodmed  =MWKPlanS_FR.codmed
		mnporc    =MWKPlanS_FR.cantidadps
		mtfechatur=mdmasX
		thora     =ttoc(MWKPlanS_FR.Horadesde,2)
		*if vr_thorad= ctod('00:00:00')
			thorad    = MWKPlanS_FR.Horadesde
		*else
		*	thorad    = vr_thorad
		*endif
		*if vr_thorah= ctod('00:00:00')	
			thorah    = MWKPlanS_FR.Horahasta
		*else
		*	thorah    = vr_thorah
		*endif	
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
	mret=sqlexec(mcon1,"select a.*,b.diasem,b.horadesde,b.horahasta from tabprepaga as a,(select codmed,diasem,horadesde,horahasta,fecvigend,fecvigenh "+;
 				" from medpresta WHERE diasem =?mndiasem "+;
 				" group by codmed,diasem,horadesde) as b "+;
 				" where ?mdmasX between a.fecvigend and a.fecvigenh "+;
 				" and a.criterio='F' and a.tipodato='A' And a.codmed=b.codmed "+;  
 				" and ?mdmasX between B.fecvigend and B.fecvigenh "+;
 				" order by A.Codmed","MWKPlanS_FA")
						 

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