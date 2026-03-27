*
* Armado de tablas ficha Paciente con TRAUMA
*
* Nuevo parametro msepara = "S" ó "N" (default) a raiz de la solicitud de agrupar los combos del AIS, caso contrario
*                            obtengo sendos combos por separado msepara = "S" . ( 24-06-2010 )
*
Lparameters mbas1, mnrotb, msepara

If vartype(msepara)<>'C'
	msepara = "N"
Endif

If vartype(mbas1)<>'C'
	mbas1 = ""
Endif

If msepara = "S"

*!* Todas las tablas (29) que representan los combos del Registro de Trauma

	If vartype(mnrotb)<>'N'
		mdesde = 01
		mnrotb = 22
	Else
		mdesde = mnrotb
	Endif

*!* Para el frmguardia64 se utilizan los cursores respondiendo al nombre mwkbase..
*!* se evitan desde el 23 al 28 van en uno sólo

	For mindi = mdesde to mnrotb
		If len(mbas1) = 0
			mbase = 'mwkbase' + alltrim(str(mindi))
		Else
			mbase = mbas1
		Endif
		If used( mbase )
			Use in &mbase
		Endif
		mret = sqlexec(mcon1,"select * from TabFichaTrauVal where FTV_agrupa=?mindi",mbase)
		If mret < 0
			=aerror(merror)
			Messagebox("EN CONSULTA BASES DE TRAUMA"+chr(10)+;
				alltrim(merror(3))+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
			Exit
		Endif
	Next mindi


	If mdesde <> mnrotb

		mindi = 29
		mbase = 'mwkbase'+alltrim(str(mindi))
		If used( mbase )
			Use in &mbase
		Endif
		mret = sqlexec(mcon1,"select * from TabFichaTrauVal where FTV_agrupa=?mindi",mbase)
		If mret < 0
			=aerror(merror)
			Messagebox("EN CONSULTA BASES DE TRAUMA"+chr(10)+;
				alltrim(merror(3))+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
			Exit
		Endif


	Endif


Else

*
*  Desde / Hasta codigos de agrupacion de combos a saber : cabeza/cuello,cara,torax,
*                                                          abdomen,extremidades,grneral o externa
*
	If used('mwkbaseg')
		Use in mwkbaseg
	Endif

	mdesde = 22
	mhasta = 29

	mret = sqlexec(mcon1,"select * from TabFichaTrauVal where FTV_agrupa>?mdesde and FTV_agrupa<?mhasta","mwkbaseg")
	If mret < 0
		=aerror(merror)
		Messagebox("EN CONSULTA BASES DE TRAUMA"+chr(10)+;
			alltrim(merror(3))+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Exit
	Endif

Endif

* AIS
If !used('mwkais')

	mtipo=5
	mret = sqlexec(mcon1,"select * from TabEstados"+;
		" where propietario=2 and tipo=?mtipo order by estado","mwkais")

	If mret < 0
		Messagebox("CONSULTA TABLA AIS",16,"ERROR")
	Endif

Endif
