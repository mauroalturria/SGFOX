*************************************************************
* Genera Sobre Ofertas
* AUTOR:Claudia Antoniow
*****************************
* FECHA:13/02/2002
**************************************
* Fecha Ult. Modificación: 23/05/2003
**************************************
mddiasem   = dow(mdmasX)
mndiasem   = dow(mdmasX)
mncanttur  = 1
singenerar = 0
mlismed    = '( '

if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''
endif
mret=sqlexec(mcon1,"SELECT codmed, diasem, horadesde, horahasta, porcentaje, cantidad "+;
	" FROM tabsobretoA " +;
	" WHERE &mccpoamb Diasem = ?mddiasem AND porcentaje >0 and tipoturno = 2 and " + ;
	" ?mdmasx between fvigend and fvigenh " + ;
	" AND Codmed IN ( SELECT codmed from turnos " + ;
	" Where &mccpoamb fechatur = ?mdmasX And tipoturno in(0,4,5,7                 ) " +;
	" Group By codmed ) " +;
	" GROUP BY Codmed, diasem, Horadesde, porcentaje " +;
	" ORDER BY Codmed, diasem, Horadesde, porcentaje ","MWKSobre")

sele MWKsobre
go top

do while !eof('MWKsobre')

	mncodmed   = MWKsobre.codmed
	mnporc     = MWKsobre.porcentaje/100
	mtfechatur = mdmasX
	thorad     = MWKSobre.Horadesde
	thorah     = MWKSobre.Horahasta
	thorahr     = MWKSobre.Horahasta

	if mnporc >0 
		if (thorah - thorad)/3600>=2
			thorah= thorah-3600
		endif
		if !(isnull(thorad) and isnull(thorah))

			do sp_valido_sobreofer
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
					do sp_valido_franjaHor with mncodmed, mddiasem,;
						thorad, thorahr, mtfechatur
					sele MWKExisteFr
					go top

					if !eof('MWKExisteFr')
						do sp_cargo_sobreofer with 1, MwkPorcSOfer.porc, thorad, thorah, lSOtipoPE
					else
						if mlismed    = '( '
							mlismed   = mlismed  + allt(str(mncodmed))
						else
							mlismed   = mlismed  + ',' + allt(str(mncodmed))
						endif
						singenerar = singenerar + 1
					endif

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
	if used('MWKExisteFr')
		sele MWKExisteFr
		use
	endif
	skip 1 in MWKsobre
enddo

if singenerar > 0
	messagebox('No se generar  SO para ' + allt(str(singenerar)) +;
		' Medicos Por dif. de franjas ',64,'Validacion')
	mlismed = mlismed + ')'

	do prg_listo_medicos with mlismed
	mtfhoy =sp_busco_fecha_serv('DT')
	sele MwkLisMed
	go top
	report form repturno41 noconsole to printer
endif
