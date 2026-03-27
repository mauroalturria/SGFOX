LPARAMETERS mFiltro
USE IN SELECT("mwkmlDocu")
mret = SQLEXEC(mcon1,"select ZabIntAdjunto.*,pac_codhci  from ZabIntAdjunto"+;
" inner join tabinthce on IDA_idevol= tabinthce .id"+;
" inner join pacientes on pac_codadmision = tabinthce.ih_admision"+;
" where " + mFiltro,"mwkmlDocu")

If mRet<=0
*	Messagebox("ERROR EN LA LECTURA DE DOCUMENTOS",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
Endif