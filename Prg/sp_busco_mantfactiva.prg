*
* Mantenimiento busqueda de Fecha de Activación Valida
*
Lparameters mFechaIngSolic

mFechaIngSolicF = ttod(mFechaIngSolic)
mFechaIngSolicH = hour(mFechaIngSolic)
mfecturno       = mFechaIngSolicF
mdia = day(mfecturno )
mmes = month(mfecturno )
mlok = .f.

If !inlist(dow(mfecturno), 7, 1)
	mret = sqlexec(mcon1,"SELECT dia FROM feriaturnosA WHERE dia =?mfecturno ",'MWKFeriados')
	mlok = (reccount('MWKFeriados')>0)
	If (mdia = 24 or mdia = 31) and mmes = 12
		mlok = .t.
	Endif
Else
	mlok = .t.
Endif

If !mlok
	mfechaVS = mfecturno + 1 &&& Busco Viernes Santo
	mret = sqlexec(mcon1,"SELECT dia,Motivo FROM feriaturnosA,Tabferiados "+;
		"WHERE dia =?mfechaVS  and Motivo = Tabferiados.ID and motivo= 10 ",'MWKFeriados')
	mlok = (reccount('MWKFeriados')>0)
Endif

If mlok  && No laborable
*!*     Buscar dia habil siguiente y cargar a las 7
		mFechaActivacion = ctot( dtoc( prg_calcula_diahabil(mfecturno  , 1, "1,7" ) ) + " 07:00:00" )
Else     && Día Hábil
	If mFechaIngSolicH >= 7 and mFechaIngSolicH < 18
		mFechaActivacion = mFechaIngSolic
	Else
		If mFechaIngSolicH < 7
*!*         Ese dia a las 7
			mFechaActivacion = ctot( dtoc( mFechaIngSolicF ) + " 07:00:00" )
		Else
*!*         Dia siguiente a las 7
			mFechaActivacion = ctot( dtoc( prg_calcula_diahabil(mfecturno, 1, "1,7" ) ) + " 07:00:00" )
		Endif
	Endif
Endif

Return mFechaActivacion
