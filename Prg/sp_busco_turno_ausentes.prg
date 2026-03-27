*****
** control de TURNOS anteriores ausentes de un paciente.
*****
parameter mfecha, mafili

if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''	
endif
mfechad = mfecha - 180
mconec = IIF(mcon1=0,mcon3,mcon1)
mret = SQLEXEC(mconec , "select fechatur, horatur, confirmado,codesp " + ;
	" from turnos " + ;
	"where &mccpoamb turnos.codreserva<>'' and  fechatur >= ?mfechad and " + ;   &&tipoturno < 9 and 
	"fechatur < ?mfecha and afiliado = ?mafili "+;
	" group by codreserva,fechatur,hhmmtur ", "mwkctrltur")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	do prg_cancelo
else
	select * from mwkctrltur order by horatur desc into cursor mwkcontrol
	select mwkcontrol
	cfecha = ""
	mausente = 0
	locate for confirmado = 0
	do while !eof() and mausente < 3
		if 	confirmado = 1
			mausente = 0
			cfecha = ""
		else
			if 	confirmado = 0
				mausente = mausente +1
				cfecha = cfecha + left(ttoc(horatur),16)+ " - " + alltrim(codesp)+chr(13)
			endif
		endif
		select mwkcontrol
		skip
	enddo

	if mausente >= 3
		messagebox("PACIENTE CON 3 AUSENTES CONSECUTIVOS" + chr(13) + cfecha,64, "Control de Ausentismo")
	endif
endif
