*!*	--------------------------------------------------------------
*!*	PRESTACIONES ACTIVAS QUE GENERAN AGENDA FILTRADAS POR ESPECIALIDAD
*!*	Ejemplos
*!*	mfiltro = " ('ALER','CLIN')"
*!*	mfiltro = " ('')"
*!*	Resultado mwkPrestEsp
*!*	--------------------------------------------------------------
Lparameters mopcion, mfiltro,mactiva,mfecact
If Vartype(mactiva)<>"N"
	mactiva=0
Endif
If Vartype(mfecact)<>"N"
	mfecact=  sp_busco_fecha_serv("DD")
Endif
mfechoy  = mfecact
If mxambito >1
	mccpoamb = ",Tabprestambito.PA_duracion, Tabprestambito.PA_fecpasiva,"+;
		" Tabprestambito.PA_retiroestudios, Tabprestambito.PA_turnosmultip,PRE_Web "+;
		',PRE_EdadDesde, PRE_EdadHasta '+;
		" FROM Prestacions "+Iif(mactiva=1,",medpresta  " ,"")	+;
		" left outer join TabPRESTambito ON ( Tabprestambito.PA_codambito = ?mxambito "+;
		" and Prestacions.PRE_codprest = Tabprestambito.PA_codiprest) "

Else

	mccpoamb = ",pre_duracion as PA_duracion, pre_fechapasiva as PA_fecpasiva,"+;
		" pre_retiroestudios as PA_retiroestudios, pre_turnosmultip as PA_turnosmultip,PRE_Web "+;
		',PRE_EdadDesde, PRE_EdadHasta '+;
		" FROM Prestacions "+Iif(mactiva=1,",medpresta  " ,"")
Endif
Do Case
	Case mopcion = 1 && Completa

		mret = SQLExec(mcon1,"SELECT Prestacions.PRE_codprest, Prestacions.PRE_descriprest, " + ;
			"Prestacions.PRE_codservicio, Prestacions.PRE_especialidad, " + ;
			"Prestacions.PRE_duracion, Prestacions.PRE_turnosmultip,PRE_Web,PRE_WebTurnos, " + ;
			"Prestacions.PRE_retiroestudios,Prestacions.pre_tipomuestra,PRE_Lateralidad " + ;
			',Prestacions.PRE_EdadDesde, Prestacions.PRE_EdadHasta '+;
			mccpoamb + ;
			"WHERE Prestacions.PRE_fechapasiva IS NULL " + ;
			"AND Prestacions.PRE_AgendaTurnos = 'S' " + ;
			IIF(mactiva=1," and medpresta.codprest = prestacions.pre_codprest and " + ;
			' medpresta.fecvigend <> medpresta.fecvigenh and ' + ;
			' medpresta.diasem > 0 and  medpresta.fecvigenh >= ?mfechoy  ','')+;
			" group by PRE_codprest ORDER BY PRE_especialidad, PRE_descriprest " ,"mwkPrestEsp")


	Case mopcion = 2 && Filtrado x especialidad

		mret = SQLExec(mcon1,"SELECT Prestacions.PRE_codprest, Prestacions.PRE_descriprest, " + ;
			"Prestacions.PRE_codservicio, Prestacions.PRE_especialidad, " + ;
			"Prestacions.PRE_duracion, Prestacions.PRE_turnosmultip,PRE_Web,PRE_WebTurnos, " + ;
			"Prestacions.PRE_retiroestudios,Prestacions.pre_tipomuestra,PRE_Lateralidad " + ;
			',Prestacions.PRE_EdadDesde, Prestacions.PRE_EdadHasta '+;
			mccpoamb  + ;
			"WHERE Prestacions.PRE_fechapasiva IS NULL " + ;
			"AND Prestacions.PRE_AgendaTurnos = 'S' " + ;
			"AND Prestacions.PRE_especialidad in " + mfiltro + ;
			IIF(mactiva=1," and medpresta.codprest = prestacions.pre_codprest and " + ;
			' medpresta.fecvigend <> medpresta.fecvigenh and ' + ;
			' medpresta.diasem > 0 and  medpresta.fecvigenh >= ?mfechoy  ','')+;
			" group by PRE_codprest ORDER BY PRE_especialidad, PRE_descriprest " ,"mwkPrestEsp")

Endcase

If mret <= 0
	Messagebox("ERROR DE LECTURA ", 48, "VALIDACION")
	Return .F.
Endif
