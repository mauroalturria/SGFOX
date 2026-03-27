Parameters tcCodAdmi, tcWhere

lcSql = "Select PREPEN_CodAdmision, PREPEN_Codigo, PREPEN_Servicio, PREPEN_FechaVale, PREPEN_Vale " + ;
		"FROM PRESTAPENDI " + ;
		"Where PREPEN_CodAdmision = ?tcCodAdmi  " + tcWhere

If !prg_ejecutosql(lcSql,'mwkPrestPend')
	Messagebox("NO SE REALIZO CONSULTA",64,"VALIDACIÓN")
	Return .F.
Endif