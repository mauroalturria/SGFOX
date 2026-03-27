Lparameters tcCursor, tcWhere

If Parameters() < 1
	tcCursor = "mwkGesta"
Endif 

If Vartype(tcWhere) # "C"
	tcWhere = ""
Endif 

If Not "WHERE" $ UPPER(tcWhere) And !Empty(tcWhere)
	tcWhere = "Where " + tcWhere
Endif 

mRet = Sqlexec(mcon1,"Select * from TabAmbGesta " + tcWhere ,tcCursor)

If mRet <= 0
	Messagebox("ERROR DE LECTURA ",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif  