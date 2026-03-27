*************************************************************
* Genera Sobre Ofertas
* AUTOR:Claudia Antoniow
*****************************
* FECHA:13/02/2002
*****************************
parameters vr_thorad, vr_thorah
mndiasem=dow(mdmasX)
mddiasem=dow(mdmasX)
mncanttur=1

if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''
endif
mret=sqlexec(mcon1," SELECT codmed,diasem,horadesde,horahasta,porcentaje,cantidad FROM tabsobretoA " +;
	" WHERE &mccpoamb Diasem = ?mndiasem AND porcentaje >0 and tipoturno = 2 " +;
	" AND ?mdmasx between fvigend and fvigenh "+;
	" AND Codmed =?mncodmed " +;
	" GROUP BY diasem,Horadesde,porcentaje " +;
	" ORDER BY diasem,Horadesde,porcentaje ","MWKSobre")

sele MWKsobre
go top

do while !eof('MWKsobre')

	mncodmed  = MWKsobre.codmed
	mnporc    = MWKsobre.porcentaje/100
	mtfechatur= mdmasX
	thorad = MWKSobre.Horadesde
	thorah = MWKSobre.Horahasta
	do case
		case vr_thorad = ctot('00:00:00')
			thorad    = MWKSobre.Horadesde
		case vr_thorah = ctot('00:00:00')
			thorah = MWKSobre.Horahasta
		otherwise
			thorad    = vr_thorad
			thorah = vr_thorah
	endcase
	if  (ttoc(MWKSobre.horahasta-1,2)< ttoc(thorad ,2) or ttoc(MWKSobre.horadesde,2)> ttoc(thorah ,2)) 	
			skip 1 in MWKsobre
		if eof('MWKSobre')
			exit
		else
			loop
		endif
	endif

	if mnporc >0
		thorahr = thorah

		if (thorah - thorad)/3600>=2
			thorah= thorah-3600
		endif
		do sp_valido_sobreofer.prg
		sele MWKExisteTurno
		go top
		lSOtipoPE = .f.
		if reccount('MWKExisteTurno') = 0
			do sp_valido_sobretur.prg
			sele MWKExisteTurno
			go top
			if reccount('MWKExisteTurno') = 0

*do sp_calculo_sobreofer.prg
				do sp_calculo_porcentaje
				if reccount('MwkPorcSOfer')=0
					do sp_calculo_porcentaje with 7
					lSOtipoPE =(reccount('MwkPorcSOfer')>0)
				endif
				sele MwkPorcSOfer
				go top
				if reccount('MwkPorcSOfer') >0
					do sp_valido_franjaHor with mncodmed, mddiasem, thorad, thorahr, mtfechatur
					sele MWKExisteFr
					go top
					if !eof('MWKExisteFr')
						do sp_cargo_sobreofer with 1,MwkPorcSOfer.porc,thorad,thorah,lSOtipoPE
					else
						messagebox('NO GENERO SO POR DIF. DE FRANJAS ',64,'VALIDACION')
					endif
				endif
			endif
		endif
	endif
	if used('MWKUltTurno')
		sele MWKUltTurno
		use
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
	skip 1 in MWKsobre
enddo

