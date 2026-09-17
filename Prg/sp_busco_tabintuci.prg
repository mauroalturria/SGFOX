Lparameters tcidevol
SET STEP ON
mRet = SQLExec(mcon1," SELECT ID , CUA_SDRA , CUA_decubitoProno , CUA_fechaH , CUA_hemodialisis "+;
	", CUA_idevol , CUA_limitaTerapia , CUA_patologia , CUA_plasmaferesis , CUA_procede , CUA_traqueotomia "+;
	", CUA_usuario FROM  ZabIntUCIClas where CUA_idevol =?tcidevol " , 'mwktabintuci' )

If mRet <= 0
	Messagebox("ERROR DE LECTURA PARAMETROS DE UCI" ,16,"ERROR")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif
