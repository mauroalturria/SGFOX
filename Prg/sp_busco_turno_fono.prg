****
** verifico la existencia de turnos para foniatria
****

parameters mregistracio
mfecdes = sp_busco_fecha_serv('DD')
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''
endif

mret = sqlexec(mcon1, "select fechatur, horatur, codmed " + ;
	"from turnos " + ;
	"where &mccpoamb turnos.codreserva<>'' and afiliado = ?mregistracio and (turnos.tipoturno < 8 or turnos.tipoturno >=13) and " + ;
	"fechatur >= ?mfecdes and codesp = 'FONI' " + ;
	"order by fechatur, horatur ", "mwkveofono")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	do prg_cancelo
endif
