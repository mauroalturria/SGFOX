Parameters tcCursor, tcOrden


If !Used(tcCursor)
	Return .f.
Endif 

Select &tcCursor
Append Blank

Select * ;
	From &tcCursor ;
	Order By &tcOrden ;
	Into Cursor &tcCursor Readwrite 
	
Return .t.	