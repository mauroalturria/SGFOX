****
**  Busco medpresta vigente, si viene con variable mcjoin ( c/join ) busco ID de franja horaria
****

Parameter mfecha1, mbusci, mfecha2, mcjoin

If type('mcjoin') # "C"
	mcjoin = 'N'
Endif

If type('mbusci') # "C"
	mbusci = ''
Endif

If vartype(mfecha2) # "D"
	mfecha2 = mfecha1
Endif
mccpoamb = ''
mcjoinamb = ''
if mxambito >1
	mccpoamb = "  and medpresta.codambito = ?mxambito "
	mcjoinamb = " franjahoraria.codambito = medpresta.codambito and " 
endif
	mccpocmed = " and centromed = ?mxcentromedico "


mfecnul = CTOD("01/01/1900")

If mcjoin = 'N'

	mret = sqlexec(mcon1, "select medpresta.*, prestadores.id,nombre,bloquedesde, bloquehasta  "+;
		" from medpresta,prestadores "+;
		" where (fecpasivap = ?mfecnul or fecpasivap > ?mfecha1 ) "+;
		" and medpresta.fecvigend <= ?mfecha2 and codmed = prestadores.id " + ;
		" and medpresta.fecvigenh >?mfecha1 and fecvigend<fecvigenh " + mbusci +;
		mccpoamb , "mwkMPfecha")
Else

	mret = sqlexec(mcon1, "select medpresta.*, prestadores.id, prestadores.nombre, franjahoraria.ID as idfranja" +;
		",bloquedesde, bloquehasta "+;
		" from medpresta" +;
		" join prestadores on" +;
		" (prestadores.fecpasivap = ?mfecnul or prestadores.fecpasivap > ?mfecha1)"+;
		" and prestadores.id = medpresta.codmed" +;
		" join franjahoraria on" +;
		" franjahoraria.codmed = prestadores.id and" +;
		" franjahoraria.diasem = medpresta.diasem and" +;
		" franjahoraria.hhmmdes = medpresta.hhmmdes and" +;
		" franjahoraria.hhmmhas = medpresta.hhmmhas and" +;
		mcjoinamb+;
		" medpresta.fecvigend >= franjahoraria.fecvigend and" +;
		" medpresta.fecvigenh <= franjahoraria.fecvigenh"+;
		" where " +;
		" medpresta.fecvigend <= ?mfecha2" +;
		" and medpresta.fecvigenh > ?mfecha1" +;
		" and medpresta.fecvigend < medpresta.fecvigenh " + mbusci+mccpocmed  +;
		mccpoamb , "mwkMPfecha")

Endif

If mret < 1
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",48,"Validación")
	Cancel
Endif

