Lparameters mCursor

mRet = Sqlexec(mcon1,"Select TabAmbSerologias.* " + ;
	"from TabAmbSerologias " + ;
		"Order by Sero_Descrip ", mCursor)

If mRet < 0
	Messagebox("EN CONSULTA DE SEROLOGIA.",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif 