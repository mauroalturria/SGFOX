

SET DEFAULT TO C:\Fabian

	PUBLIC oexcel as excel.application
	oexcel = CREATEOBJECT("excel.application")
	oexcel.Workbooks.Open("C:\Fabian\Beepers2.xlsx")
	oexcel.Visible = .T.
** mcon1 = SQLCONNECT("172.16.1.190")



I = 1
DO WHILE .t.

	lcvalor = oexcel.Cells(I,1).text
	?lcvalor	
	IF EMPTY(lcvalor) 
		EXIT 
	ENDIF 	
	
	v1 = oexcel.Cells(I,1).text
	v2 = oexcel.Cells(I,2).text
	v3 = oexcel.Cells(I,3).text
	*v4 = UPPER(oexcel.Cells(I,5).text)
	*v5 = UPPER(oexcel.Cells(I,6).text)
	
	* pin estado subestado
	
	SQLEXEC(mcon1,"insert into tabbeepers (BEE_Pin, BEE_Sector, BEE_Descrip) values (?v1, ?v2, ?v3)")
	
*	SQLEXEC(mcon1,"insert into tabestados (descrip, estado, subestado, tipo, propietario) Values (?v1, ?v2, ?v3, ?v4, ?v5)")
		
	I = I + 1 
	
ENDDO 

