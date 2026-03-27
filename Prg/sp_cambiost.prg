Lparameters lfecdes,lfechas,lfecgen,lusu,lntipo   
If mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
Else
	mccpoamb = ''
Endif

mret=SQLExec(mcon1,"SELECT *  " + ;
	"FROM turnos " + ;
	"WHERE &mccpoamb AFILIADO = 1 AND  fechatur between  ?lfecdes AND ?lfechas " + ;
	" and usuariogenera = ?lusu and fechagenera>= ?lfecgen AND tipoturno = 2 ",'MWKExTurno')

If mret < 0
	Messagebox("ERROR DE GENERACION DE CURSOR",16,"Validación")
	mret=0
Endif

If Reccount('MWKExTurno')>0
	mret=SQLExec(mcon1,"update turnos set tipoturno = ?lntipo   " + ;
		"WHERE &mccpoamb AFILIADO = 1 AND  fechatur between  ?lfecdes AND ?lfechas " + ;
		" and usuariogenera = ?lusu and fechagenera>= ?lfecgen AND tipoturno = 2 " )

	If mret < 0
		Messagebox("ERROR DE GENERACION DE CURSOR",16,"Validación")
		mret=0
	Endif
Endif
