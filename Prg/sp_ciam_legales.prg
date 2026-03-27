*
* Querys Update NRO.REGISTRACION CIAM y LEGALES
*

Lparameters nroregistra, newregistra

*!* Legales
mret = sqlexec(mcon1, "Update TabLGDema set TLD_nroregistrac = ?newregistra " + ;
	"where TLD_nroregistrac = ?nroregistra")

If mret < 0
	Messagebox("EN ACTUALIZACION DE LEGALES DEMANDAS"+chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
Endif

*!* Legales Incidentes de Seguridad
mret = sqlexec(mcon1, "Update TabLGIncAdp set TIP_nroregistrac = ?newregistra " + ;
	"where TIP_nroregistrac = ?nroregistra")

If mret < 0
	Messagebox("EN ACTUALIZACION DE Incidentes de Seguridad"+chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
Endif

*!* CIAM - CUD
mret = sqlexec(mcon1, "Update TabCiamderiva set TCD_nroregistrac = ?newregistra " + ;
	"where TCD_nroregistrac = ?nroregistra")

If mret < 0
	Messagebox("EN ACTUALIZACION DEL CENTRO UNICO DE"+chr(10)+;
		"DERIVACIONES - AVISE A SISTEMAS",16, "ERROR")
Endif

