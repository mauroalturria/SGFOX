
*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
* MODIFICADO:26/02/2002
******************************
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''	
endif

mret=sqlexec(mcon1,"SELECT *,cast(0 as integer) as bloqueo " + ;
	"FROM turnos " + ;
	"WHERE &mccpoamb codmed = ?mncodmed AND " + ;
	"diasem = ?mndiasem AND fechatur = ?mtfechatur AND " + ;
	"horatur = ?mthorad AND tipoturno <> 9 ",'MWKExisteTurno')

if mret < 0
	messagebox("ERROR DE GENERACION DE CURSOR",16,"Validación")
	mret=0
endif

if reccount('MWKExisteTurno')= 0

	vthorad ='1900-01-01 '+ ttoc(mthorad,2)

	if mxambito >1
		mccpoamb = "  franjahoraria.codambito = ?mxambito and "
	endif
	mret=sqlexec(mcon1,"SELECT *,cast(1 as integer) as bloqueo "+;
		" FROM tabbloqueoamb join franjahoraria "+;
		" ON tabbloqueoamb.idfranja = franjahoraria.id " +;
		" WHERE &mccpoamb tabbloqueoamb.codmed = ?mncodmed AND franjahoraria.diasem = ?mndiasem " + ;
		" AND ?mtfechatur between tabbloqueoamb.fvigend AND tabbloqueoamb.fvigenh " + ;
		" AND ?vthorad between tabbloqueoamb.horadesde AND tabbloqueoamb.horahasta "+;
		" AND bloqanulado <> 1 ",'MWKExisteTurno')

	if mret < 0
		=aerr(eros)
		messagebox(eros(3),16,"Validación")
		mret=0
	endif

	if used("MWKValCtrlTur")
		if reccount("MWKExisteTurno") > 0
			insert into MWKValCtrlTur (ESTADO, CODMED, NDIA, FECHATUR, HORATUR) values ;
										("BLOQUEADO", mncodmed, mndiasem, mtfechatur, mthorad )
		
		else
			insert into MWKValCtrlTur (ESTADO, CODMED, NDIA, FECHATUR, HORATUR) values ;
									("SIN GENERAR", mncodmed, mndiasem, mtfechatur, mthorad )
		endif
	Endif 
else
*!*		if used("MWKValCtrlTur ")
*!*			insert into MWKValCtrlTur (ESTADO, CODMED, NDIA, FECHATUR, HORATUR) values ;
*!*									("GENERARADO", mncodmed, mndiasem, mtfechatur, mthorad )
*!*		Endif 
endif
