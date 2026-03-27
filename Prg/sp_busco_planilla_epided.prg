*
* Fichas de Epidemiología / Contactos
*
* mtipo = 1 (Epidemiología) / mbuscar = protocolo
* mtipo = 2 (Contactos)     / mbuscar = id de TabFichEp
*
* mtipe = "H1N1" ó "DENGUE"
*
Lparameters mbuscar, mtipo, mtipe

If vartype(mtipe)#"C"
	mtipe = "H1N1"
Endif

If mtipo = 1

	If used('mwkepidemio')
		Use in mwkepidemio
	Endif

	mret = sqlexec(mcon1,"select id as lid,* from "+;
		iif(mtipe="H1N1","TabFichEp","TabFichEp2")+" where FE_proto=?mbuscar","mwkepidemio")

	If mret < 0
		Messagebox("FICHAS DE EPIDEMIOLOGIA"+chr(10)+;
			"AVISE A SISTEMAS",16,"ERROR")
	Endif

Else

	if mtipe = "H1N1"
	
		If used('mwkepidecon')
			Use in mwkepidecon
		Endif

		mret = sqlexec(mcon1,"select * from TabFichEpCon"+;
			" where FEC_idfich=?mbuscar","mwkepidecon")

		If mret < 0
			Messagebox("EN FICHAS DE EPIDEMIOLOGIA CONTACTOS"+chr(10)+;
				"AVISE A SISTEMAS",16,"ERROR")
		Endif
		
	else
	
		If used('mwkepidesin')
			Use in mwkepidesin
		Endif

		mret = sqlexec(mcon1,"select * from TabFichEpSin"+;
			" where FES_idfich=?mbuscar","mwkepidesin")

		If mret < 0
			Messagebox("EN FICHAS DE EPIDEMIOLOGIA SINTOMAS"+chr(10)+;
				"AVISE A SISTEMAS",16,"ERROR")
		Endif
	
	endif

Endif


