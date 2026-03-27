
	mfecdes = ctod('01/05/2002')
	mfechas = ctod('31/05/2002')
	
	oleapp = createobject("excel.application")
	oleapp.visible = .t.

	oleapp.workbooks.open("H:\qepd1a1\xlt\Preparaciones.xlt")
		
	oleapp.cells(3,2).value = "Periodo del " + dtoc(mfecdes) + " al " + dtoc(mfechas)

		
	oleapp.cells(3,2).value = "Preparaciones por Prestacion "
	i = 6
	
	do while !eof("mwkmensaje")
	
		oleapp.cells(i,2).value   = mwkmensaje.pre_descriprest
		oleapp.cells(i,5).value   = mwkmensaje.descri
		
		i = i + 1
		skip 1 in mwkmensaje
		
	enddo
