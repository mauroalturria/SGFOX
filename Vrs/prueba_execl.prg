*
*
**
PUBLIC mrg
mrg = rgb(255, 0, 0)

	oleapp = createobject("excel.application")
	oleapp.workbooks.open("H:\qepd1a1\xlt\horarios_consul_dia.xlt")
	oleapp.cells(6,2).value = "Cons 1"
	oleapp.cells(6,3).value = "SAUL ALEJANDRO"
    oleApp.Range(oleApp.Cells(6,4),oleApp.Cells(6,7)).Value='X'
    
  	
	
	OLEAPP.VISIBLE = .T.
