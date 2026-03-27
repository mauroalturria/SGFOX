*
* Configuración propiedades conección MySQL
*
Lparameters mform

If Vartype(mform) <> 'O'
	Messagebox("PROPIEDADES MySQL FORMULARIO NO DEFINIDO"+Chr(10)+;
		"AVISE A SISTEMAS",48,"ATENCION")
	Return .F.
Endif

With mform

	If !Pemstatus(mform,"mserver",5)
		If !.AddProperty("mserver","")
			Return .F.
		Endif
	Endif

	If !Pemstatus(mform,"muid",5)
		If !.AddProperty("muid","")
			Return .F.
		Endif
	Endif

	If !Pemstatus(mform,"mpwd",5)
		If !.AddProperty("mpwd","")
			Return .F.
		Endif
	Endif

	If !Pemstatus(mform,"mdatabase",5)
		If !.AddProperty("mdatabase","")
			Return .F.
		Endif
	Endif

*	.mserver   = "localhost"
*	.muid      = "root"
*	.mpwd      = "mysql01"
*	.mdatabase = "cuiddom"

	.mserver   = "190.228.29.63"
	.muid      = "cuiddom"
	.mpwd      = "cuiddom01"
	.mdatabase = "cuiddom"

Endwith

Return .T.
