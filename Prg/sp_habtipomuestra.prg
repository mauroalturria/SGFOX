Local lResultado
Local nUbicacion

lResultado = .F.

nUbicacion = mxambito
If Vartype(mxcentromedico) <> "N"
	mxcentromedico = mxambito
Endif

*!*	If mxambito = 1 And mxcentromedico = 2
*!*		nUbicacion = mxcentromedico
*!*	Endif

* SET STEP ON

nUbicacion = 0
* ---------------------- Marcelo Torres, 27/08/2024. Resulver ubicación
* mwkambitoCM
sp_busco_tabcm()

Select mwkambitoCM
Go Top

Scan All

	If mwkambitoCM.ambito = mxambito And mwkambitoCM.centromedico = mxcentromedico
		nUbicacion = mwkambitoCM.centromedicoMK
		Exit
	Endif

Endscan

Use In Select("mwkambitoCM")
* ---------------------------------------------------------------------


Do sp_busco_estados With 57, " and tipo=15 ", "mwkHabTipoMuestra"

Select mwkHabTipoMuestra
Go Top

If Reccount() > 0


	Scan All

		If mwkHabTipoMuestra.Estado >= 1 And mwkHabTipoMuestra.subestado = nUbicacion
			lResultado = .T.
			Exit
		Endif


	Endscan


*!*		If mwkHabTipoMuestra.Estado = 1

*!*			Alines(aAmbitos,Alltrim(mwkHabTipoMuestra.Descrip),",")

*!*			For Each oIn In aAmbitos
*!*				If cUbicacion = oIn
*!*					lResult = .T.
*!*					Exit
*!*				Endif
*!*			Next

*!*		Endif

*!*	   IF mwkHabTipoMuestra.Estado = 1
*!*	      lResultado = .t.
*!*	   ENDIF
Endif

Use In Select("mwkHabTipoMuestra")

Return lResultado
