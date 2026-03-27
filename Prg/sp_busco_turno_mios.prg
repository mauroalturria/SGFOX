*****
** BUSCO TURNO PARA ESE DIA Y ESE PACIENTE
*****
parameter mfecha, mafili

if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''	
endif
mret = SQLEXEC(mcon1, "select * from turnos " + ;
	"where &mccpoamb  (tipoturno < 9 or tipoturno >= 13) and " + ;
	"  codreserva<>'' and fechatur = ?mfecha and afiliado = ?mafili ", "mwkveotur")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	do prg_cancelo
endif
