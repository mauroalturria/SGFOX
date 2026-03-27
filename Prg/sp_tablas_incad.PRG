*
* Tablas Incidentes adversos
*
Lparameters mlidin

mret = sqlexec(mcon1,"select * from TabLGIncAdP where ID = ?mlidin","mwkincadP")

If mret > 0
	mret = sqlexec(mcon1,"select * from TabLGIncAdD where TID_idincidente = ?mlidin","mwkincadD")

	If mret > 0
		mret = sqlexec(mcon1,"select * from TabLGIncAdMed where TIM_idincidente = ?mlidin","mwkincadM")
	Else
		Messagebox("EN BUSQUEDA DEL PROFESIONAL ASIGNDAO AL INC.ADV."+chr(10)+;
			"AVISE A SISTEMAS",16,"ERROR")
	Endif
Else
	Messagebox("EN BUSQUEDA DEL Incidentes de Seguridad"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif


