Parameters tnOpcion, tnId, tnCCB_cirugia, tnCCB_codigoBolsa, tdCCB_fechapasiva, tnCCB_servicio


Do Case 
	Case tnOpcion = 1
		tdCCB_fechapasiva = Ctod("01/01/1900")
		
		lcSql = "Insert Into Tabcpcirbol (CCB_cirugia, CCB_codigoBolsa, CCB_fechapasiva, CCB_servicio) " + ;
			"Values (?tnCCB_cirugia, ?tnCCB_codigoBolsa, ?tdCCB_fechapasiva, ?tnCCB_servicio)"
		
 	Case tnOpcion = 2

		lcSql = "Update Tabcpcirbol Set " + ;
			"CCB_cirugia = ?tnCCB_cirugia, " + ;
			"CCB_codigoBolsa = ?tnCCB_codigoBolsa, " + ;
			"CCB_fechapasiva = ?tdCCB_fechapasiva, " + ;
			"CCB_servicio = ?tnCCB_servicio " + ;
			"Where Id = ?tnId "

 Endcase 	
 
 
If !prg_ejecutosql(lcSql, "", .f.)
	Return .f.
Endif 

Return .t.