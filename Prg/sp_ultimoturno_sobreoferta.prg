***************************
*Claudia Antoniow
*10/04/2002
*********************************************************************
* Trae el horario del ultimo turno normal para tomarlo en sobreofeta
* Como hora fe finalizacion de la atención
************************************************************************
Lparameter xtipo,sope

If Vartype(sope) = "U"
	sope = .F.
Endif
tt = Iif(sope,",7","")

If mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
Else
	mccpoamb = ''
Endif

fhorahasta = Datetime(Year(mtfechatur),Month(mtfechatur),Day(mtfechatur),;
	hour(vr_horah_teo),Minute(vr_horah_teo),0)
fhoradesde = Datetime(Year(mtfechatur),Month(mtfechatur),Day(mtfechatur),;
	hour(vr_horad_teo),Minute(vr_horad_teo),0)

If Vartype(xtipo)#"C"
	mret = SQLExec(mcon1," select max(horatur) as ulthr  from Turnos, Tabtipoturno " + ;
		" WHERE &mccpoamb Turnos.tipoturno = Tabtipoturno.tipoturno and  fechatur = ?mtfechatur "+;
		" and codmed = ?mncodmed and  Tabtipoturno.grupo IN (0,1,3) " +;
		" and horatur between ?fhoradesde and ?fhorahasta ","MWKUltTurno")
	If mret < 0
		Messagebox("Error Cursor de SobreOferta ultimo Turno (MWKUltTurno), REINTENTE",16,"Validacion")
		Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
		mret = 0
	Endif
Else
	mret = SQLExec(mcon1," select Turnos.id,horatur as ulthr  from Turnos, Tabtipoturno " + ;
		" WHERE &mccpoamb Turnos.tipoturno = Tabtipoturno.tipoturno and  fechatur = ?mtfechatur "+;
		" and codmed = ?mncodmed and  Tabtipoturno.grupo IN (0,1,3) " +;
		" and horatur between ?fhoradesde and ?fhorahasta "+;
		" order by horatur ","MWKUltTurn")

	If mret < 0
		Messagebox("Error Cursor de SobreOferta ultimo Turno (MWKUltTurn), REINTENTE",16,"Validacion")
		Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
		mret = 0
	Endif

	Select MWKUltTurn
	Go Bott
	If !Eof()
		Skip -1
	Endif
	mid = Id
	Select * From MWKUltTurn Where Id = mid Into Cursor MWKUltTurno
	Use In MWKUltTurn
Endif