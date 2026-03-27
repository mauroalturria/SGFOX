Lparameters mNroReg

mret = SQLExec(mcon1, "select * " + ;
	"from TabAmbEvol "+;
	"where EA_nroregistrac = ?mNroReg ", "mwkambevol" )

If mRet <= 0
	Messagebox("ERROR DE LECTURA DE EVOLUCION AMB",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif 