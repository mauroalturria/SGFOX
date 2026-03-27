*
* Tablas Incidentes adversos x ID de incidente
*
Lparameters mlidin

mret = SQLExec(mcon1,"select * from TabLGIncAdP where ID = ?mlidin","mwkincadP")

If mret > 0
	mret = SQLExec(mcon1,"select * from TabLGIncAdD where TID_idincidente = ?mlidin","mwkincadD")

	If mret > 0
		mret = SQLExec(mcon1,"select * from TabLGIncAdMed where TIM_idincidente = ?mlidin","mwkincadM")
	Else
		Messagebox("EN BUSQUEDA DEL PROFESIONAL ASIGNDAO AL INC.ADV."+Chr(10)+;
			"AVISE A SISTEMAS",16,"ERROR")
	Endif
Else
	Messagebox("EN BUSQUEDA DEL Incidentes de Seguridad"+Chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
ENDIF

Use In Select("mwkincadCaida")

mret = SQLExec(mcon1,"select * from TabLGIncAdCa where TIC_idincad = ?mlidin","mwkincadCaida")

If mret < 0
	Messagebox("EN BUSQUEDA DE Incidentes de Seguridad CAIDAS"+Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
Endif
