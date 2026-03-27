****
** busca turnos dados paa una entidad y una prestacion
****

parameter mcodent, mfecdes, mfechas, mnroreg

mfilent = ''
if mcodent>0
	mfilent = 	" turnos.codent = ?mcodent and " 
endif
if mxambito >1
	mccpoamb = "  turnos.codambito = ?mxambito and "
else
	mccpoamb = ''	
endif
mret = sqlexec(mcon1, "select horatur as fecha, REG_nombrepac as paciente, nombre as profesional, " 	 + ;
	"pre_descriprest as prestacion, codreserva, REG_telefonos, " + ;
	"codmed, fechatur, codprest " + ;
	"from turnos, prestadores, registracio, prestacions " + ;
	"where &mccpoamb  turnos.codreserva<>'' and turnos.afiliado = REG_nroregistrac and " + ;
	"turnos.codmed = prestadores.id and " + ;
	"turnos.codprest = pre_codprest and " + mfilent+;
	"turnos.fechatur >= ?mfecdes and " + ;
	"turnos.fechatur <= ?mfechas and " + ;
	"(turnos.tipoturno < 9 or turnos.tipoturno >= 13) " + ;
	"order by  fecha", "mwktodosr")

mret = sqlexec(mcon1, "select horatur as fecha, preregistra.nombre as paciente, prestadores.nombre as profesional, " 	 + ;
	"pre_descriprest as prestacion, codreserva, preregistra.telefono as REG_telefonos, " + ;
	"codmed, fechatur, codprest " + ;
	"from turnos, prestadores, preregistra, prestacions " + ;
	"where &mccpoamb turnos.codreserva<>'' and turnos.afiliado = preregistra.id and " + ;
	"turnos.codmed = prestadores.id and " + ;
	"turnos.codprest = pre_codprest and " + mfilent+;
	"turnos.fechatur >= ?mfecdes and " + ;
	"turnos.fechatur <= ?mfechas and " + ;
	"(turnos.tipoturno < 9 or turnos.tipoturno >= 13) " + ;
	"order by  fecha", "mwktodosp")

select * from mwktodosr union select * from mwktodosp into cursor mwktodos


mnroreg = _tally

if mret < 0
	messagebox('ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS', 16,'Validacion')
	DO sp_desconexion WITH "error"
	cancel
endif

