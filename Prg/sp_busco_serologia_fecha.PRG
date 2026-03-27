Lparameters mWhere, mCursor
*!*	mcon1 = Sqlconnect("172.16.1.246")
*!*	ldFecha = Date() - 365*2
*!*	lnRegistracio = 820225

*!*	mWhere = " Where (SN_fecha >= ?ldFecha Or SN_fecha is null )and (SN_Registracio =  ?lnRegistracio Or SN_Registracio is null)"
*!*	mCursor = "mwkSerologia"

*mRet = Sqlexec(mcon1,"Select " + ;


mRet = Sqlexec(mcon1,"Select TabAmbGestSerologia.*, " + ;
	"TabAmbSerologias.Id as sero_ID, " + ;
	"TabAmbSerologias.Sero_Descrip, " + ;
	"TabAmbSerologias.Sero_SiValor, " + ;
	"TabAmbSerologias.Sero_ValMin, " + ;
	"TabAmbSerologias.Sero_ValMax " + ;
	"from TabAmbSerologias  " + ;
	"Left Join TabAmbGestSerologia on " + ;
		" TabAmbSerologias.Id = TabAmbGestSerologia.SN_SeroId " + ;
	" " + mWhere + " " + ;
	"Order by sero_Descrip ", mCursor)
	
*!*		

If mRet < 0
	Messagebox("EN CONSULTA DE SEROLOGIA.",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif 