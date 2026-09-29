Lparameters tcidevol, xmCUA_SDRA , xmCUA_decubitoProno , xmCUA_fechaH , xmCUA_hemodialisis ;
	, xmCUA_limitaTerapia , xmCUA_patologia , xmCUA_plasmaferesis , xmCUA_procede , xmCUA_traqueotomia

musuario = mwkusuarios.Id

If Vartype(xmCUA_fechaH )<>"T"
	xmCUA_fechaH = sp_busco_fecha_serv("DT")
Endif
mRet = SQLExec(mcon1," SELECT ID FROM  ZabIntUCIClas where CUA_idevol =?tcidevol " , 'mwktabintuci' )
If Reccount('mwktabintuci')>0
	mid = mwktabintuci.Id
	mRet = SQLExec(mcon1,"update ZabIntUCIClas SET CUA_SDRA = ?xmCUA_SDRA , CUA_decubitoProno = ?xmCUA_decubitoProno "+;
		", CUA_fechaH = ?xmCUA_fechaH , CUA_hemodialisis = ?xmCUA_hemodialisis ,  CUA_limitaTerapia = ?xmCUA_limitaTerapia "+;
		", CUA_patologia = ?xmCUA_patologia , CUA_plasmaferesis = ?xmCUA_plasmaferesis  "+;
		", CUA_procede = ?xmCUA_procede  , CUA_traqueotomia = ?xmCUA_traqueotomia , CUA_usuario = ?musuario   where CUA_idevol =?mid "   )
Else
	mRet = SQLExec(mcon1," insert into ZabIntUCIClas (CUA_SDRA , CUA_decubitoProno , CUA_fechaH , CUA_hemodialisis "+;
		", CUA_idevol , CUA_limitaTerapia , CUA_patologia , CUA_plasmaferesis , CUA_procede , CUA_traqueotomia "+;
		", CUA_usuario) values " +;
		" (?xmCUA_SDRA , ?xmCUA_decubitoProno , ?xmCUA_fechaH , ?xmCUA_hemodialisis, ?tcidevol "+;
		", ?xmCUA_limitaTerapia , ?xmCUA_patologia , ?xmCUA_plasmaferesis , ?xmCUA_procede , ?xmCUA_traqueotomia,?musuario   )" )
Endif


If mRet <= 0
	Messagebox("ERROR DE LECTURA PARAMETROS DE UCI" ,16,"ERROR")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif
