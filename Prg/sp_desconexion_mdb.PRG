If VarType(GMDB)="U"
	Return .F.
Endif 

lcError = On("ERROR")
On Error *

Sqldisconnect(GMDB)

On Error &lcError 

Return .T.