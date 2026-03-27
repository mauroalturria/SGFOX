SELECT * FROM  tabregctg GROUP BY rc_nroregistracio HAVING COUNT(id)>1 INTO CURSOR anilis 
Select * From  tabregctg Where rc_nroregistracio In (Select rc_nroregistracio  From anilis) Into Cursor analisis
SELECT * FROM  analisis GROUP BY rc_nroregistracio,rc_estado INTO CURSOR ana1 
SELECT * FROM  ana1 GROUP BY rc_nroregistracio HAVING COUNT(id)>1  INTO CURSOR ana2
SELECT * FROM  analisis where rc_nroregistracio in (SELECT rc_nroregistracio FROM ana2) INTO CURSOR sigo
LOCATE FOR id = sigo.ID

Select sigo
Go Top
mireg = rc_nroregistracio
mifin = rc_fechafin
mid = Id
Skip
Do While !Eof()
	Do While !Eof() And mireg = rc_nroregistracio
		If mifin > rc_fechainicio
			Set Step On
			*Update tabregctg Set rc_fechafin=sigo.rc_fechainicio Where Id = mid
		Endif
		Select sigo
		mireg = rc_nroregistracio
		mifin = rc_fechafin
		mid = Id
		Skip
	ENDDO
		Select sigo
		mireg = rc_nroregistracio
		mifin = rc_fechafin
		mid = Id
		Skip
Enddo


