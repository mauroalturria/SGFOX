****
**  Busco medpresta vigente,  devuelve sala
****

Parameter mxfecha1, mxmed, mxpres

mccpoamb = ''

If mxambito >1
	mccpoamb = "  and medpresta.codambito = ?mxambito "
	mcjoinamb = " franjahoraria.codambito = medpresta.codambito and "
Endif
mccpocmed = " and centromed = ?mxcentromedico "
mdiasem = Dow(mxfecha1)

mfecnul = Ctod("01/01/1900")

mret = SQLExec(mcon1, "select medpresta.* " +;
	" from medpresta" +;
	" join franjahoraria on" +;
	" franjahoraria.codmed = medpresta.codmed and" +;
	" franjahoraria.diasem = medpresta.diasem and" +;
	" franjahoraria.hhmmdes = medpresta.hhmmdes and" +;
	" franjahoraria.hhmmhas = medpresta.hhmmhas and" +;
	mcjoinamb+;
	" medpresta.fecvigend >= franjahoraria.fecvigend and" +;
	" medpresta.fecvigenh <= franjahoraria.fecvigenh"+;
	" where medpresta.codmed = ?mxmed codprest = ?mxpres and diasem = ?mdiasem  " +;
	" medpresta.fecvigend <= ?mxfecha1" +;
	" and medpresta.fecvigenh > ?mxfecha1" +;
	" and medpresta.fecvigend < medpresta.fecvigenh " +mccpocmed  +;
	mccpoamb , "mwkMPsala")

Endif

If mret < 1
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",48,"Validación")
Else
	Return mwkMPsala.sala
Endif
