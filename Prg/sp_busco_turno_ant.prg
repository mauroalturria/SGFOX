*****
** BUSCO turnos anteriores para ese paciente de hominis
*****
parameter mafili,mfhtur

mccpoamb = ''	
mbuscoval  =  " "
mcjoinvales = ""
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
	mcjoinvales = " inner join pacientes on valesasist.VAL_codadmision = pacientes.pac_codadmision "
	mbuscoval  =  " and pac_codambito=?mxambito " 
endif

mret = SQLEXEC(mcon1, "select VAL_codadmision "+;
	" from Valesasist, Histambgua" + mcjoinvales +;
	" where Histambgua.HIS_codadmision = VAL_codadmision " + ;
	" and (Histambgua.HIS_nroregistrac = ?mafili " + ; 
	" and Histambgua.HIS_codentidad in (102,100,101) " + ;
	" and VAL_codservvale = 2200 " + ;
	" and VAL_fechasolicitud <= ?mfecturno ) "+mbuscoval   , "mwkvValesant")
&&& omito 106
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	do prg_cancelo
endif

mret = SQLEXEC(mcon1, "select horatur,nombre from turnos,prestadores " + ;
	" where &mccpoamb  turnos.codreserva<>'' and prestadores.id = codmed and codprest = 42010181 and " + ;
	" fechatur >= ?mfecturno and horatur < ?mfhtur and afiliado = ?mafili ", "mwkveoturant")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	do prg_cancelo
endif
