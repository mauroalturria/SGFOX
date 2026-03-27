Parameters mnIdEvol

mcEvol = ""

For mPesta = 1 To 15

	This.buscoevol(mnIdEvol,mPesta)

	mcPesta = ""
	mcNombre = ""

	Do Case
	Case mPesta = 1
		mcPesta = "Aspecto"
	Case mPesta = 2
		mcPesta = "Piel"
	Case mPesta = 3
		mcPesta = "Respira"
	Case mPesta = 4
		mcPesta = "Cardio"
	Case mPesta = 5
		mcPesta = "Abdomen"
	Case mPesta = 6
		mcPesta = "Neuro"
	Case mPesta = 7
		mcPesta = "Oseo"
	Case mPesta = 8
		mcPesta = "Infecto"
	Case mPesta = 9
		mcPesta = "Hemato"
	Case mPesta = 10
		mcPesta = "Antro"
	Case mPesta = 11
		mcPesta = "Oftalmo"
	Case mPesta = 12
		mcPesta = "Metabo"
	Case mPesta = 13
		mcPesta = "Nutri"
	Case mPesta = 14
		mcPesta = "Malforma"
	Case mPesta = 15
		mcPesta = "Quiro"
	Otherwise
		mcPesta = "OTROS"
	Endcase

	mcNombre = Alltrim(mwkEvolMenu.cmenu)

	mcCursor = "mwkNeoE" + mcPesta

	Select mwkNeoGrillaEvolAnt
	mPrefijo1 = Upper(Alltrim(Field(1,"mwkNeoGrillaEvolAnt")))
	mPrefijo = Substr(mPrefijo1,At(".",mPrefijo1)+1,3)

	Use In Select(mcCursor)
	Select * From mwkNeoGrillaEvolAnt Into Cursor &mcCursor
	Select &mcCursor
	Scan All
		mDato0 = sp_armo_datos_evolucion_neo(mPesta,mnIdEvol)
		If !Empty(mDato0)
			mFecEvo = mcCursor + '.' + mPrefijo + '_fechahora'
			mDocEvo = mcCursor + '.nomape'
			mDato = Chr(13) + '--------------------- Fecha: ' + Dtoc(&mFecEvo) + ' - Hora: ' + Left(Ttoc(&mFecEvo,2),5) + ' - Médico: ' + &mDocEvo + Chr(13) + mDato0
			mcEvol = mcEvol + mDato
		Endif
	Endscan
Endfor

Return mcEvol
