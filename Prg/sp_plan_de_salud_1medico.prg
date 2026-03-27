*****************************
* Genera Plan de Salud Turnos laboratorio
* AUTOR:Claudia Antoniow
*****************************
* FECHA:13/04/2002
*****************************
parameters vr_thorad, vr_thorah

do sp_busco_med_prepaga with mdmasX,mddiasem,'F','R','MWKPlanS_FR',mncodmed

sele MWKPlanS_FR
go top
do while !eof('MWKPlanS_FR')

	mnporc    =MWKPlanS_FR.cantidadps
	mtfechatur=mdmasX
	thora     =ttoc(MWKPlanS_FR.Horadesde,2)
	thorad = MWKPlanS_FR.Horadesde
	thorah = MWKPlanS_FR.Horahasta
	do case
		case vr_thorad = ctot('00:00:00')
			thorad    = MWKPlanS_FR.Horadesde
		case vr_thorah = ctot('00:00:00')
			thorah = MWKPlanS_FR.Horahasta
		otherwise
			thorad    = vr_thorad
			thorah = vr_thorah
	endcase
	if  (ttoc(MWKPlanS_FR.horahasta-1,2)< ttoc(thorad ,2) or ttoc(MWKPlanS_FR.horadesde,2)> ttoc(thorah ,2)) 	
		skip 1 in MWKPlanS_FR
		if eof('MWKPlanS_FR')
			exit
		else
			loop
		endif
	endif

	if mnporc >0
		if !(isnull(thorad) and isnull(thorah))
			do sp_valido_PS.prg
			sele MWKExisteTurno
			go top
			if reccount('MWKExisteTurno') = 0
*mnporc  =MWKPlanS_FA.cantidad
				do sp_datos_sobretur
				sele MwkPorcSOfer
				go top
				if reccount('MwkPorcSOfer')>0
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
	if used('MWKHorasTr')
		sele MWKHorasTr
		use
	endif

	skip 1 in MWKPlanS_FR
enddo
*Sql 2) de plan de salud que trata criterio=Cantidad por franja y por turno Agregado
do sp_busco_med_prepaga with mdmasX,mndiasem,'F','A','MWKPlanS_FA',mncodmed


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
	if used('MWKHorasTr')
		sele MWKHorasTr
		use
	endif

	skip 1 in MWKPlanS_FA
enddo

*Sql 2) de plan de salud que trata criterio=Cantidad por franja y por turno Agregado
do sp_busco_med_prepaga with mdmasX,mndiasem,'T','R','MWKPlanS_TR',mncodmed


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
	if used('MWKHorasTr')
		sele MWKHorasTr
		use
	endif

	skip 1 in MWKPlanS_TR
enddo
