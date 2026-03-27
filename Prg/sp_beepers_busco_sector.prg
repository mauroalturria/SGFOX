
Lparameters mGrabTipo

sqlgraba = "Select * From tabestados Where propietario = 84 and tipo = 1 and estado = ?mGrabTipo order by descrip asc"
If !prg_ejecutosql(sqlgraba,"mwkcbosector")
	Return .F.
Endif

