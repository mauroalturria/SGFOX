
	do sp_conexion

	mret = sqlexec(mcon1, "select pre_codprest, pre_descriprest, trim(descrip) as preparacion " + ;
					"from prestacions left outer join turnosprepara on pre_codprest = codpres " + ;
					"where pre_fechapasiva is null and " + ;
					"pre_agendaturnos = 'S' ", "mwkpre")
					
	=sqldisconnect(mcon1)
	
		oleapp = createobject("excel.application")
		oleapp.workbooks.add
		oleapp.visible = .t.

	i = 1	
	do while !eof("mwkpre")
	
		oleapp.cells(i,2).value   = mwkpre.pre_codprest
		oleapp.cells(i,3).value   = alltrim(mwkpre.pre_descriprest)
		oleapp.cells(i,4).value   = alltrim(mwkpre.preparacion)
		i = i + 1
		skip 1 in mwkpre
	
	enddo

