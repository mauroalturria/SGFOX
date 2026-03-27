Lparameters tnOpcion, toForm


Do Case
	Case tnOpcion = 1
		lcValAux = Alltrim(toForm.txtBusco.Value)
		lnMat = Val(lcValAux)

		If lnMat = 0
			lcWhere = strtran(lcValAux," ","%' And TQF_nombre like '%")
			c = strtran(lcValAux," ","%' And TQF_nombre like '%")
			lcWhere = " and TQF_nombre like '%" + lcWhere + "%'"
						
			*lcWhere = " and nombre like '%" + lcValAux + "%' " 
		Else
			lcWhere = " and TQF_Matricula = ?lnMat "
		Endif 	
				
		Set Step On
		
		Do sp_busco_quirotipo With mwkQuiroProf.TQF_Tipo, lcWhere, 'mwkBusAux'
		
		Select 0000 as id, TQF_nombre as Nombre, TQF_Matricula as Matriculas ;
			From mwkBusAux ;
			into Cursor mwktextoPrestad

		.grid1.RecordSource = "mwktextoPrestad"
		.grid1.Column1.ControlSource = "mwktextoPrestad.Matriculas"
		.grid1.Column2.ControlSource = "mwktextoPrestad.Nombre"
		
	Otherwise

endcase