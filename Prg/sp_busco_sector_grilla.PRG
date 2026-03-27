Lparameters mId

sqlgraba = "Select * From tabestados Where propietario = 84 and tipo = 1 and estado = ?mId"

If !prg_ejecutosql(sqlgraba,"mwkcbosector")
	Return .F.
Endif