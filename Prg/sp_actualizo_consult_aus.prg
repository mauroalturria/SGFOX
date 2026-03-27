lParameters lnId

mret = SqlExec(mcon1,"Update TabLlamador " + ;
		"Set Lla_Consultorio = 'AUS' Where Id = ?lnId "  )

if mret <= 0
	MessageBox("ERROR AL ACTUALIZAR EL LLAMADOR",48,"VALIDACION")
Endif 
