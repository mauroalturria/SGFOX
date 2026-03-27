*************************
*Autor:Claudia Antoniow
*************************
*Fecha:20/08/2002
*************************
*Ult. Modificación:20/08/2002
*****************************

* Reserva turnos para la prepaga
if used('MWKPlanS_FR')
	if !isnull(MWKPlanS_FR.cantidadps) and MWKPlanS_FR.cantidadps > 0 
		mncant_t = int(MwkPorcSOfer.cantur/MWKPlanS_FR.cantidadps)

		do sp_busco_turnos_disponibles
		if !eof('mwkturnosDisp')
			 sele mwkturnosDisp
			 go top
			 if reccount()>1
			 	go record 2 in mwkturnosDisp
			 endif	
		endif	
		
		
		if !eof('mwkturnosDisp')
			for i=1 to mnporc 
				sele mwkturnosDisp
				do sp_reservo_turnoDisp with mwkturnosDisp.id,5
				skip mncant_t in mwkturnosDisp
				if eof('mwkturnosDisp')
					exit
				endif
			endfor	
		endif	
		sele mwkturnosDisp
		use
		sele MwkPorcSOfer
		use
	 
	endif
endif
* revisar

if used('MWKPlanS_TR')
   if !eof('MWKPlanS_TR')
	do sp_busco_turnos_disponibles
		if !eof('mwkturnosDisp')
			 sele mwkturnosDisp
			 go top
			 mncant_t = reccount()
		endif	
		if !eof('mwkturnosDisp')
			for i=1 to mncant_t  
				sele mwkturnosDisp
				do sp_reservo_turnoDisp with mwkturnosDisp.id,5
				skip 1 in mwkturnosDisp
				if eof('mwkturnosDisp')
					exit
				endif
			endfor	
		endif	
		sele mwkturnosDisp
		use
		
	endif	
endif

