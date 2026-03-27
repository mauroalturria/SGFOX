****
** verifico la existencia de turnos antes de cancelar
****

parameters mfecdes, mfechas, mcodmed, mbusco1,mcodesp,LSINMK
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''
ENDIF
If Vartype(lsinMK)="N"
	mccpoamb  = mccpoamb + " usuariogenera<>'TURNOSMARKEY' AND "
Endif
if mcodmed>0

	mret = sqlexec(mcon1, "select turnos.*,TabTipoTurno.grupo " + ;
		"from turnos,TabTipoTurno " + ;
		"where &mccpoamb codmed = ?mcodmed &mbusco1 and turnos.tipoturno<>9 and " + ;
		"fechatur >= ?mfecdes and fechatur <= ?mfechas and turnos.tipoturno = TabTipoTurno.TipoTurno " + ;
		"order by fechatur, horatur ", "mwkveoturnos")
else
	mret = sqlexec(mcon1, "select turnos.*,TabTipoTurno.grupo " + ;
		"from turnos,TabTipoTurno " + ;
		"where &mccpoamb  " + ;
		"fechatur >= ?mfecdes &mbusco1 and fechatur <= ?mfechas and turnos.tipoturno = TabTipoTurno.TipoTurno and turnos.tipoturno<>9 " + ;
		"order by fechatur, horatur ", "mwkveoturnos")
endif
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	do prg_cancelo
endif
