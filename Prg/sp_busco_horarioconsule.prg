*!*	Busqueda de cb para un medico / fecha
Lparameters mOpcion, mCodMed, mFechDes, mFechHas 

Do Case
	case mOpcion = 1 && SE USO PARA REPROGRAMACIONES FRMTURNOS13
		mret = sqlexec(mcon1, " SELECT * " + ;
			" FROM horarioConsulE " + ;
			" WHERE fecha = ?mfechDes " + ;
			" and CODMED = ?mcodmed	" + ;
			" ","MwkControlM")

	case mOpcion = 2 && SE USO PARA CANCELACIONES MASIVAS FRMTURNOS35
		mret = sqlexec(mcon1, " SELECT * " + ;
			" FROM horarioConsulE " + ;
			" WHERE fecha between ?mfechDes and ?mFechHas " + ;
			" and CODMED = ?mcodmed	" + ;
			" ","MwkControlM")

	otherwise

endcase

If mRet <= 0
	Messagebox("ERROR DE LECTURA DE CB ",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif 



