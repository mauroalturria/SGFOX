Parameters mIdInforme

* mIdInforme = 0 && Prueba

* Tipo 3 = Confirmado

mFecha = ""

If mIdInforme > 0

	lcSQL = "Select * from InformesLog Where idInforme = ?mIdInforme and TipoLog = 3"

	If !Prg_EjecutoSql(lcSQL,"mwkFecInforme")
		Return .F.
	Endif

	If Reccount("mwkFecInforme")>0
		mFecha = Alltrim(Dtoc(mwkFecInforme.FechaLog)) + " - Hora: " + Alltrim(Left(Ttoc(mwkFecInforme.FechaLog,2),5))
	Endif

Else

	mFecha0 = sp_busco_fecha_serv('DT')
	mFecha = Alltrim(Dtoc(mFecha0)) + " - Hora: " + Alltrim(Left(Ttoc(mFecha0,2),5))

Endif

Return mFecha

