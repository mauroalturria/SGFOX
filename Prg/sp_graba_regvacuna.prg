Lparameters mRegistracio,mEstadoVac,mUsuario

Local lResult
Local mID
Local mFecHor

lResult = .T.
mID = 0
mFecHor = sp_busco_fecha_serv('DT')

mret = SQLExec(mcon1,"select * from TabRegDatos " + ;
	"where TRDA_Registracio = ?mRegistracio","mwkTempRegVacu")

If mret<=0
	Messagebox("ERROR EN LA LECTURA DE TABREGDATOS",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	lResult =  .F.
Endif

If lResult
	Select mwkTempRegVacu
	Go Top

	If Reccount() > 0  && Actualizamos
		mID = mwkTempRegVacu.Id

		mret = SQLExec(mcon1,"update TABREGDATOS set " +;
			"TRDA_VacCovid = ?mEstadoVac, "+;
			"FecHorDbUpd = ?mFecHor, " +;
			"UserDbUpd = ?mUsuario " +;
			"where id = ?mId" )
	Else   && Insertamos
		mret = SQLExec(mcon1,"insert into TABREGDATOS (TRDA_Registracio,TRDA_VacCovid,FecHorDbAdd,UserDbAdd) Values( " +;
			"?mRegistracio,?mEstadoVac,?mFecHor,?mUsuario)")
	Endif

	If mret < 0
		Messagebox("ERROR AL INTENTAR GRABAR TABREGDATOS",26,"ERROR")
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		lResult =  .F.
	Endif

Endif

Use In Select("mwkTempRegVacu")

Return lResult
