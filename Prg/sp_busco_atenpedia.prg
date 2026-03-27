Lparameters lnOpcion, tcBusco, lcProto, tnRegistra

mccpoamb = ''
If mxambito >1
	mccpoamb = "  and Tabambulatorio.codambito = ?mxambito "
Endif 

Do Case 
	Case lnOpcion = 1

		mret = Sqlexec(mcon1, "Select TabAmbPedia.* from TabAmbPedia " + ;
			" Where 1 = 1 " + tcBusco + ;
			"","mwkAtenPedia")

	Case lnOpcion = 2

		mret = Sqlexec(mcon1, "Select TabAmbPedia.*, Prestadores.Nombre " + ;
			"from TabAmbPedia " + ;
			"Left Join TabAmbulatorio on TabAmbulatorio.Protocolo = " + ;
				"TabAmbPedia.AP_protocolo " + mccpoamb + ;
			"Left Join Prestadores on Prestadores.Id = TabAmbulatorio.CodMed " + ;
			"Where 1 = 1 " + tcBusco + ;
			"","mwkAtenPedia")


	Case lnOpcion = 3

		mret = Sqlexec(mcon1, "Select * from TabAmbPedia " + ;
			"Inner join (Select protocolo from TabAmbulatorio where nroregistrac = ?tnRegistra " + mccpoamb + ")  as b " + ;
				" on AP_protocolo = protocolo  " + ;
			" " + tcBusco + " " ,"mwkAtenPedia")

*				" Where 1 = 1" + ;

EndCase	

If mret <= 0
	Messagebox("ERROR DE LECTURA PEDIATRIA",48,"VALIDACION")
	Return .f.
Endif 	