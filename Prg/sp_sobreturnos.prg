**************************
* Genera Sobre Turnos
* AUTOR:Claudia Antoniow
**************************
* FECHA:13/02/2002
**************************
singenerar_st = 0
mlismed    = '( '

if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''
endif
mndiasem=dow(mdmasX)
mncanttur=1

mret=sqlexec(mcon1,"SELECT codmed, diasem, horadesde, horahasta, porcentaje, cantidad " + ;
	"FROM tabsobretoA " + ;
	"Where &mccpoamb  Diasem = ?mndiasem AND cantidad > 0 and tipoturno = 2 " + ;
	"AND ?mdmasx between fvigend and fvigenh " + ;
	"AND Codmed IN (SELECT codmed from turnos " + ;
	"Where &mccpoamb  fechatur = ?mdmasX And tipoturno in(0,4,5,7) " + ;
	"Group By codmed) " +;
	"GROUP BY Codmed, diasem, Horadesde, porcentaje " +;
	"ORDER BY Codmed, diasem, Horadesde, porcentaje ", "MWKSobre")

sele MWKSobre
go top
do while !eof('MWKsobre')

	mncodmed  =MWKsobre.codmed
	mnporc    =MWKSobre.cantidad
	mtfechatur=mdmasX
	thora     =ttoc(MWKSobre.Horadesde,2)
	thorad    =MWKSobre.Horadesde
	thorah    =MWKSobre.Horahasta

	if mnporc >0
		do sp_valido_sobretur.prg
		sele MWKExisteTurno
		go top
		if eof('MWKExisteTurno') or bof('MWKExisteTurno')
			mnporc  =MWKSobre.cantidad
			do sp_datos_sobretur.prg
			sele MwkPorcSOfer
			go top
			if !eof('MwkPorcSOfer') or !bof('MwkPorcSOfer')
				if MwkPorcSOfer.Cantur >0
					do sp_valido_franjaHor with mncodmed, mddiasem,;
						thorad, thorah, mtfechatur
					sele MWKExisteFr
					go top

					if !eof('MWKExisteFr')
						do sp_cargo_sobretur with 2, mnporc, thorad, thorah
					else
						if mlismed    = '( '
							mlismed   = mlismed  + allt(str(mncodmed))
						else
							mlismed   = mlismed  + ',' + allt(str(mncodmed))
						endif
						singenerar_st = singenerar_st + 1
					endif

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

	skip 1 in MWKsobre
enddo

if singenerar_st > 0
	messagebox('No se generaron ST para ' + allt(str(singenerar_st)) +;
		' Medicos Por dif. de franjas ',64,'Validacion')
	mlismed = mlismed + ')'

	do prg_listo_medicos with mlismed
	mtfhoy =sp_busco_fecha_serv('DT')

	sele MwkLisMed
	go top
	if !eof('MwkLisMed')
		report form repturno41B noconsole to printer
	endif
endif
