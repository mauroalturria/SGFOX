Lparameters tcProtocolo, tbCierraCursor, tcNameCursor

*!*	tbCierraCursor = .t.
*!*	tcProtocolo = '2006455'


If Vartype(tcNameCursor) <> "C"
	tcNameCursor = "mwkPatientsOnline"
Endif 

mRet = Sqlexec(mcon1,"Select * from dbo.v_PatientsOnline " + ;
	"Where dbo.v_PatientsOnline.accession_number = ?tcProtocolo",tcNameCursor)

If mRet <= 0	
	Messagebox("ERROR DE LECTURA DE PACIENTES ONLINE",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .f. && ver si da ERROR o dejamos que diga con el diagnet
Endif 	

Select (tcNameCursor)
Count To lnCant

If tbCierraCursor
	Select (tcNameCursor)
	Use 
Endif 

*!*	Sqldisconnect(mcon1)	

Return (lnCant > 0)
