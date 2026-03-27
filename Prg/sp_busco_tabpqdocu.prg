LPARAMETERS mFiltro
USE IN SELECT("mwkmlDocu")
mret = SQLEXEC(mcon1,"select * from TabPQadjunto where " + mFiltro,"mwkmlDocu")

If mRet<=0
	Messagebox("ERROR EN LA LECTURA DE DOCUMENTOS",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
Endif