*
* Busqueda de Evolucion de Estados, Legales
*
* TLE_idestant = 99, para Incidentes adversos
*
Lparameters mbusca, mestados

If vartype(mestados)#'N'
	mestados = 0
Endif

If used('mwklegalevo')
	Use in mwklegalevo
Endif

If mestados > 0
	mret = sqlexec(mcon1,"select * from TabLGEvo where TLE_iddemanda = ?mbusca"+;
		" and TLE_idestant=0 and TLE_idesact=0","mwklegalevo")
Else
	mret = sqlexec(mcon1,"select * from TabLGEvo where TLE_iddemanda = ?mbusca"+;
	" and  TLE_idestant <> 99","mwklegalevo")
Endif

If mret < 0
	Messagebox("EN BUSQUEDA DE EVOLUCION DE ESTADOS",16,"ERROR")
Else
	If mestados > 0
		mretorna = .f.
		If used('mwklegalevo')
			If reccount('mwklegalevo')>0
				mretorna = .t.
			Endif
		Endif
		Return mretorna
	Endif
Endif




