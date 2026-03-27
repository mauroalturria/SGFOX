*
* Relacion Entidades y Destinatarios
*
Lparameters mOpcion, mentidad, mdestino, maltapac, minform, mCensosXlt, mAdmisionXlt

muser = mwkusuario.idusuario
mfHoy = sp_busco_fecha_serv('DD')
mfnull = Ctod("01/01/1900")
mret = 0

mCensosXlt = Iif(Vartype(mCensosXlt)<> "N",0,mCensosXlt)

Do Case
Case mOpcion = 1
** Primero vemos si existe el registro.

	mret = SQLExec(mcon1,"select * from tabCensosRel " +;
		"where TCR_iddestino = ?mDestino and TCR_identidad = ?mentidad and TCR_fechapasiva = ?mfnull","mwkCensosRelLg")

	If mret < 0
		MTABLA = "CENSOS ENTIDADES/RELACIONES"
		Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN CONSULTA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

	Select mwkCensosRelLg
	Go Top

	If Reccount("mwkCensosRelLg") = 0   &&El registro no existe para esta direccion de email

		mret = SQLExec(mcon1,"insert into TabCensosRel"+;
			" (TCR_iddestino, TCR_identidad, TCR_idusuario, TCR_fecmov)"+;
			" values "+;
			" (?mdestino, ?mentidad, ?muser, ?mfHoy)")

		If mret < 0
			MTABLA = "CENSOS ENTIDADES/RELACIONES"
			Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
			Messagebox("EN GRABACION TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
			Return .F.
		Endif

	Endif

	Use In Select("mwkCensosRelLg")

*!*	If minform = 1 AND maltapac = 1 && Informar archivo anexo Alta de Pacientes sólo por Entidad

*!*		mfnull = Ctod("01/01/1900")

*!*		mret = SQLExec(mcon1,"insert into TabCensosArch"+;
*!*			" (TCA_identidad, TCA_idusuario, TCA_fecmov, TCA_fechapasiva, TCA_tipo)"+;
*!*			" values "+;
*!*			" (?mentidad, ?muser, ?mfHoy, ?mfnull, 'ALTAPAC')")

*!*		If mret < 0
*!*			MTABLA = "CENSOS ARCHIVOS A INFORMAR"
*!*			Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
*!*			Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
*!*			Return .F.
*!*		Endif

*!*	Endif

Case mOpcion = 2

**If minform = 1 And (maltapac = 1 Or mCensosXlt = 1) && Informar archivo anexo Alta de Pacientes sólo por Entidad

	If maltapac = 1
		mret = SQLExec(mcon1,"insert into TabCensosArch"+;
			" (TCA_identidad, TCA_idusuario, TCA_fecmov, TCA_fechapasiva, TCA_tipo)"+;
			" values "+;
			" (?mentidad, ?muser, ?mfHoy, ?mfnull, 'ALTAPAC')")
	Endif

	If mCensosXlt = 1
		mret = SQLExec(mcon1,"insert into TabCensosArch"+;
			" (TCA_identidad, TCA_idusuario, TCA_fecmov, TCA_fechapasiva, TCA_tipo)"+;
			" values "+;
			" (?mentidad, ?muser, ?mfHoy, ?mfnull, 'CENSOSXLT')")
	Endif

	If mAdmisionXlt = 1   &&Marcelo Torres, 15/12/2016
		mret = SQLExec(mcon1,"insert into TabCensosArch"+;
			" (TCA_identidad, TCA_idusuario, TCA_fecmov, TCA_fechapasiva, TCA_tipo)"+;
			" values "+;
			" (?mentidad, ?muser, ?mfHoy, ?mfnull, 'ADMISIOXLT')")
	Endif

	If mret < 0
		MTABLA = "CENSOS ARCHIVOS A INFORMAR"
		Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

**Endif

Endcase

Return .T.
