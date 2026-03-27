***
***   Dado un Profesional, Fecha, Hdesde, Hhasta, Cancelo todos los turnos
***

parameter mcodmed, mfecdes, mhorades, mhorahas, mbusco1,lsinmk
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''
endif
If Vartype(lsinMK)="N"
	mccpoamb  = mccpoamb + " usuariogenera<>'TURNOSMARKEY' AND "
Endif
mret = sqlexec(mcon1, "select * from turnos " + ;
	"where &mccpoamb codmed = ?mcodmed and fechatur = ?mfecdes &mbusco1", "mwktodos")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	do prg_cancelo
endif

select * from mwktodos ;
	where horatur >= mhorades and horatur < mhorahas ;
	order by fechatur, horatur ;
	into cursor mwkphorarios

do while !eof('mwkphorarios')

	midtur      = mwkphorarios.id
	mfeccan		= sp_busco_fecha_serv('DT')
	musua		= left(midusu,3) + '_REPR'

	if mwkphorarios.afiliado > 0

		mret = sqlexec(mcon1,"update turnos set afiliado = 0, usuario = musua, codprest = 0, " + ;
			"codmedsoli = 0, solicigia = 0, codreserva = '', codent = 0, tipotomado = 0, " + ;
			"codserv = 0, codesp = '' , tipoturno = 9, fechatomado = mfeccan, UsuarioSector = 0 " + ;
			"where &mccpoamb fechatur = ?mfecdes and codmed = ?mcodmed and id = ?midtur")

	else
		mret = sqlexec(mcon1, "update turnos set tipoturno = 9, usuario = ?musua, fechatomado = ?mfeccan " + ;
			"where &mccpoamb fechatur = ?mfecdes and " + ;
			"codmed = ?mcodmed and id = ?midtur")

	endif
	if mret < 0
		messagebox("ERROR AL ACTUALIZAR. VERIFIQUE Y REINTENTE",16, "Validacion")
		do prg_cancelo
	endif

	skip 1 in mwkphorarios

enddo
