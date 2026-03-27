*************************
*Autor:Claudia Antoniow
*************************
*Fecha:20/08/2002
*************************
*Ult. Modificación:20/08/2002
*****************************
mcanturnos5 = 0
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''	
endif


mcicpoamb = ''
mvicpoamb = ''
if mxambito >1
	mcicpoamb = "  ,codambito "
	mvicpoamb = "  ,?mxambito "
endif
* Reserva turnos para la prepaga
if used('MWKPlanS_FR')
	if !isnull(MWKPlanS_FR.cantidadps) and MWKPlanS_FR.cantidadps > 0
		mncant_t = int(MwkPorcSOfer.cantur/MWKPlanS_FR.cantidadps)
		mdthorad =datetime(year(mdmasx),month(mdmasx),day(mdmasx),hour(MWKPlanS_FR.horadesde),minute(MWKPlanS_FR.horadesde),0)
		mdthorah =datetime(year(mdmasx),month(mdmasx),day(mdmasx),hour(MWKPlanS_FR.horahasta),minute(MWKPlanS_FR.horahasta),0)

		do sp_busco_turnos_disponibles with mdthorad,mdthorah
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
				mcanturnos5 = mcanturnos5 +1
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
				mcanturnos5 = mcanturnos5 +1
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
mret=sqlexec(mcon1,'select tipoturno from turnos '+;
	'where &mccpoamb diasem = ?mddiasem and codmed = ?mncodmed '+;
	'and tipoturno = 5 and fechatur = ?mtfechatur ','mwkTurresCtrl')
if reccount('mwkTurresCtrl') < mcanturnos5
	mret = sqlexec(mcon1, "insert into turnosaudit (afiliado, turnoid, fechatomado, usuario, observa, codigo &mcicpoamb) "+;
		"values (  ?mncodmed, 5, ?mtfechatur , ?mcanturnos5, ?myip, 22 &mvicpoamb ) ")
endif


