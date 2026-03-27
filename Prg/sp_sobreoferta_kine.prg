*************************************************************
* Genera Sobre Ofertas
* AUTOR:Claudia Antoniow
*****************************
* FECHA:13/02/2002
*****************************

*mdmasX    =ctod('20/05/2004')
*mccodesp  ='FONI'

mndiasem   =dow(mdmasX)
mddiasem   =dow(mdmasX)
mncanttur  =1
singenerar =0
mlismed    = '( '

if mxambito >1
	mccpoambm = " m.codambito = ?mxambito and "
	mccpoambt = " t.codambito = ?mxambito and "
	mcjoin = 	" and m.codambito = t.codambito "
else
	mccpoambm = ''
	mcjoin = ''
	mccpoambt = ''
endif
mret=sqlexec(mcon1,"SELECT t.codmed,t.diasem,t.horadesde,t.horahasta,t.porcentaje,t.cantidad "+;
	" FROM tabsobretoA as t, medpresta as m ,turnos as a "+;
	" WHERE &mccpoambt &mccpoambm t.Diasem=?mndiasem AND t.porcentaje >0 and t.tipoturno=2 "+;
	" AND t.Codmed = a.codmed and a.fechatur=?mdmasX "+;
	" AND a.tipoturno in(0,4,5,7) "+mcjoin +;
	" AND m.codmed=t.codmed AND m.codesp=?mccodesp "+;
	" AND ?mdmasX between t.fvigend and t.fvigenh   "+;
	" AND ?mdmasX between m.fecVigend and m.fecVigenH "+;
	" GROUP BY t.Codmed,t.diasem,t.Horadesde,t.cantidad "+;
	" ORDER BY t.Codmed,t.diasem,t.Horadesde,t.cantidad ","MWKSobre")

sele MWKsobre
go top


do while !eof('MWKsobre')

	mncodmed  = MWKsobre.codmed
	mnporc    = MWKsobre.porcentaje/100
	mtfechatur= mdmasX
	thorad    = MWKSobre.Horadesde
	thorah    = MWKSobre.Horahasta
	thorahr = thorah

	if mnporc >0
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

if singenerar > 0
	messagebox('No se generar  SO para ' + str(singenerar) +;
		' Medicos Por dif. de franjas ',64,'Validacion')

	mlismed = mlismed + ')'

	do prg_listo_medicos with mlismed
	mtfhoy =sp_busco_fecha_serv('DT')

	sele MwkLisMed
	go top
	report form repturno41 noconsole to printer
endif
