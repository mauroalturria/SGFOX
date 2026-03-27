*****************************
* Genera Plan de Salud Turnos laboratorio
* AUTOR:Claudia Antoniow
*****************************
* FECHA:13/04/2002
*****************************
	mndiasem=dow(mdmasX)
	mncanttur=1 
	mret=sqlexec(mcon1,"SELECT codmed,diasem,horadesde,horahasta,cantidad FROM tabsobreto " +;
					" WHERE Diasem=?mndiasem AND Cantidad >0 and tipoturno=5" +;
					" AND Codmed IN ( SELECT codmed from turnos " + ;
				    " Where fechatur=?mdmasX And tipoturno in(0,4) " +;
				    " Group By codmed ) " +;
					" GROUP BY Codmed,diasem,Horadesde,cantidad " +;
					" ORDER BY Codmed,diasem,Horadesde,cantidad ","MWKPlanS")
					
		
	sele MWKPlanS
	go top
	do while !eof('MWKPlanS') 
		
		mncodmed  =MWKPlanS.codmed
		mnporc    =MWKPlanS.cantidad
		mtfechatur=mdmasX
		thora     =ttoc(MWKPlanS.Horadesde,2)
		thorad    = MWKPlanS.Horadesde
		thorah    = MWKPlanS.Horahasta
		
		if mnporc >0 
			*do sp_valido_sobretur.prg	
			*sele MWKExisteTurno
			*go top
			*if eof('MWKExisteTurno') or bof('MWKExisteTurno')
				mnporc  =MWKPlanS.cantidad
				do sp_datos_sobretur.prg	
				sele MwkPorcSOfer
				go top
				if !eof('MwkPorcSOfer') or !bof('MwkPorcSOfer')
			   		if MwkPorcSOfer.Cantur >0
			   			do sp_cargo_PlanS WITH 5, mnporc,thorad, thorah
	
			   		endif	
				endif	  
			*endif
		endif
		*if used('MWKExisteTurno')
		*	sele MWKExisteTurno
		*	use
		*endif	
		if used('MwkPorcSOfer')
			sele MwkPorcSOfer
			use
		endif
		if USED('MWKHorasTr')
			sele MWKHorasTr
			use
		endif	
		
		skip 1 in MWKPlanS
	enddo