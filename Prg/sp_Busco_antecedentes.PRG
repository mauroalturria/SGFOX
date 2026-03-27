Lparameters tcCodEsp, tcWhere, tcCursor

If Parameters() = 0
	tcCodEsp = '    '
Endif 

If Vartype(tcWhere) # "C"
	tcWhere = ""
Endif 	

If Vartype(tcCursor) # "C"
	tcCursor = "mwkCodEspTa"
Endif	

mRet = Sqlexec(mcon1, "Select * from TabAntecedentes where TA_CodEsp = ?tcCodEsp " + tcWhere, tcCursor)

If mRet <= 0
	Messagebox("ERROR DE LECTURA ",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif 