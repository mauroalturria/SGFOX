* sp_Grabo_datos_DerivPapel
* Marcelo Torres, 13/04/2022
Lparameters nIdTurno,nnrovale

Local mFecha,mCentro,nCodMed,mMatricula,mMedico,nSector,mAfiliado, nCodent, nCodReserva
If Vartype(nnrovale)<>"N"
	nnrovale=0
Endif
* ------------------------------
*!*	mwkDatosMedDeriv(nombre c(50),matricula c(15), IdCodMed N(15), Centro N(3), Sector N(3))
* La tabla se crea en frmdatosderiva

If Used("mwkDatosMedDeriv")
	mbusco = ''
	Select mwkDatosMedDeriv
	Go Top
	If Reccount() > 0
		If nIdTurno>0
			mret = SQLExec(mcon1,"select * from turnos where id = ?nIdTurno","mwkTmpTurno")
			mbusco = " and TDP_IdTurno = ?nIdTurno "
			If mret < 0
				Messagebox("ERROR AL CONSULTAR LOS DATOS DEL TURNO - DERIVACION EN PAPEL",26,"ERROR")
				Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Use In Select("mwkDatosMedDeriv")
				Return .F.
			Endif

			Select mwkTmpTurno
			Go Top

			mAfiliado = mwkTmpTurno.afiliado
			nCodent = mwkTmpTurno.codent
			nCodReserva = mwkTmpTurno.codreserva
			mFecha = sp_busco_fecha_serv("DD")
			ncodprest = mwkTmpTurno.codprest

		Else
			mret = SQLExec(mcon1, "Select * from tabambula "+;
				" Where nrovale = ?nnrovale  ", "mwkValeexterno")
			mbusco = " and nrovale  = ?nnrovale  "

			mAfiliado = mwkValeexterno.nroregistrac
			nCodent = mwkValeexterno.codent
			nCodReserva = mwkValeexterno.protocolo
			mFecha = sp_busco_fecha_serv("DD")
			ncodprest = mwkValeexterno.codprest

		Endif
		Select mwkDatosMedDeriv

		mCentro = mwkDatosMedDeriv.Centro
		nCodMed = mwkDatosMedDeriv.IdCodMed
		mMatricula = mwkDatosMedDeriv.Matricula
		mMedico = mwkDatosMedDeriv.Nombre
		nSector = mwkDatosMedDeriv.Centro
		mobserva = mwkDatosMedDeriv.observa
		mret = SQLExec(mcon1,"select id from  ZabTurnosDerivPapel where TDP_Afiliado=?mAfiliado  "+mbusco,"mwkctrderiv")
		If Reccount("mwkctrderiv")=0
			mret = SQLExec(mcon1,"insert into ZabTurnosDerivPapel (TDP_Afiliado,codambito, TDP_Centro, TDP_CodEnt, TDP_CodMed, TDP_CodReserva"+;
				",TDP_Fecha,TDP_IdTurno,TDP_Matricula,TDP_Medico,TDP_Sector,nrovale,observa) values(" +;
				"?mAfiliado,?mxambito,?mCentro,?nCodent,?nCodMed,?nCodReserva"+;
				",?mFecha,?nIdTurno,?mMatricula,?mMedico,?nSector,?nnrovale,?mobserva )")
		Else
			mid = mwkctrderiv.Id
			mret = SQLExec(mcon1,"update ZabTurnosDerivPapel set TDP_Centro = ?mCentro,  "+;
				" TDP_Matricula = ?mMatricula,TDP_Medico = ?mMedico,TDP_Sector = ?nSector,nrovale = ?nnrovale,observa=?mcobs where id = ?mid  ")

		Endif
		If mret < 0
			Messagebox("ERROR GRABAR DATOS DE LA DERIVACION EN PAPEL",26,"ERROR")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()

		Endif

	Endif

Endif

Use In Select("mwkDatosMedDeriv")
Use In Select("mwkTmpTurno")


