Lparameters mWhere, mCursor

mRet = Sqlexec(mcon1,"Select TabAmbGestSerologia.*, " + ;
	"TabAmbSerologias.sero_Descrip " + ;
	"from TabAmbGestSerologia " + ;
	"Left Join TabAmbSerologias on " + ;
		"TabAmbGestSerologia.SN_SeroId = TabAmbSerologias.Id " + mWhere + " " + ;
		"Order by sero_Descrip ", mCursor)

If mRet < 0
	Messagebox("EN CONSULTA DE SEROLOGIA.",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif 