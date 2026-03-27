mcon1 = Sqlconnect("172.16.1.4")

lcf = "c:\quiro\PRESTA.xlsx" 

Public oExcel as Excel.application
oExcel = Createobject("Excel.application")
oExcel.Workbooks.Open(lcf)
oExcel.Visible = .T.

*!*	lrow = 3
*!*	lcol = 3
*!*	lncod = 1
*!*	lnqui = 2
*!*	lngru = 4

lrow = 5
lcol = 4	
lncod = 1
lnqui = 2
lngru = 3

Do While !Empty(Nvl(oexcel.Cells(lrow,lcol).Text,'') )

	lcod = Nvl(oexcel.Cells(lrow,lncod).Text,'')
	?lcod
	
	If !Empty(lcod)
		?Sqlexec(mcon1,"select * from prestacions where pre_codprest = ?lcod","mwkp")
		oexcel.Cells(lrow,lnqui ).Value = Alltrim(mwkp.Pre_CargaQuirofano)
		
		?Sqlexec(mcon1,"select * from tabPrestgrupo where TPG_Presta = ?lcod and TPG_Tipo = 1 ","mwkg")
		
		oexcel.Cells(lrow,lngru).Value = mwkg.id
		
	Endif 	
	lrow = lrow + 1  
Enddo 

Sqldisconnect(mcon1) 