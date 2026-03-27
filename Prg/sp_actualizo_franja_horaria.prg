****
** actualizo tipo turno, imprime archivo, tipo servicio en franjahoraria
****

Parameter  mncodmed, mddiasem, mthorad, mthorah, mfecturnod, mfecturnoh, mntipoturfranja, ;
	mnarchi, mntiposerv, mdate, midusua,mestruc
If Type('midusua')#"C"
	midusua = midusu
Endif
If Vartype('mestruc')#"C"
	ccampo = ''
	mctipostruc = 'T'
Else
	ccampo = ',Estructura = ?mestruc '
	mctipostruc = mestruc
Endif
mccpoamb = ''
If mxambito >1
	mccpoamb = "  and codambito = ?mxambito "
Endif
mccampo = ''
mvcampo = ''
If mxambito >1
	mccampo = ", codambito "
	mvcampo = ", ?mxambito "
Endif
 
	mccpocmed = " and centromed = ?mxcentromedico "
 
hhmmD		= Val(Left(mthorad,2)+Substr(mthorad,4,2))
hhmmH		= Val(Left(mthorah,2)+Substr(mthorah,4,2))
mret= SQLExec(mcon1," select * from FranjaHoraria " +;
	" where codmed = ?mncodmed and diasem = ?mddiasem "+ ;
	" and hhmmDes = ?hhmmD"+;
	" and hhmmHas= ?hhmmH"+mccpoamb+mccpocmed +;
	" And fecvigend =?mfecturnod and fecvigenh =?mfecturnoh ","mwkcontrol")

If Reccount("mwkcontrol")>0

	mret= SQLExec(mcon1," Update FranjaHoraria set tipoturno = ?mnTipoTurFranja, "+;
		" imparchivo = ?mnArchi, tiposervicio = ?mntiposerv, " +;
		" fechagraba = ?mdate, usuario = ?midusua,centromed = ?mxcentromedico  " + ccampo   +;
		" where codmed = ?mncodmed and diasem = ?mddiasem "+ ;
		" and hhmmDes = ?hhmmD"+;
		" and hhmmHas= ?hhmmH"+;
		" And fecvigend =?mfecturnod and fecvigenh =?mfecturnoh " )
Else
	fecaudi   = sp_busco_fecha_serv('DT')
	mdhdesde1 = Ctot('01/01/1900 '+ mthorad  )
	mdhhasta1 = Ctot('01/01/1900 ' + mthorah  )

	mret = SQLExec(mcon1," INSERT INTO FranjaHoraria "+;
		" ( codmed,  diasem,  estructura," +;
		"  fechagraba, fecvigend, fecvigenh,  HoraDesde, HoraHasta,  " +;
		"  ImpArchivo, tiposervicio, usuario, tipoturno, hhmmDes, hhmmHas,centromed  &mccampo    ) " +;
		"  values (?mncodmed, ?mddiasem , ?mctipostruc, ?fecaudi,        " +;
		"  ?mfecturnod , ?mfecturnoh , ?mdhdesde1 , ?mdhhasta1 , ?mnArchi, " +;
		"  ?mntiposerv, ?midusua, ?mnTipoTurFranja, ?hhmmD, ?hhmmH,?mxcentromedico &mvcampo  )")
Endif
If mret < 0
	Messagebox('NO SE GUARDARON LOS ATRIBUTOS DE FRANJA!!! ', 16, 'Validacion')
	mret = 0
Else
	Messagebox('NUEVOS DATOS DE FRANJA GUARDADOS!!! ', 48, 'Validacion')
Endif

