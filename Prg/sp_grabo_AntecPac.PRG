Lparameters tnOpcion, tnId, tnAT_IdAnt, tnAT_IdFam, tcAT_valor, tnAT_codmed, tnAT_registracio, tbAt_Alert, tcTexto,lcOpcion

mFecHoy = sp_busco_fecha_serv("DT")
mFecNull = Ctod("01/01/1900")

Do Case

	Case tnOpcion = 1
		mRet = SQLExec(mcon1,"Insert into TabAntecPac " + ;
			"(AT_IdAnt, AT_IdFam, AT_valor, AT_codmed, AT_FecAlta, AT_registracio, AT_FPasiva, At_Alert, At_Obs, At_CodAmbito,At_opcion) " + ;
			"Values " + ;
			"(?tnAT_IdAnt, ?tnAT_IdFam, ?tcAT_valor, ?tnAT_codmed, ?mFecHoy, ?tnAT_registracio, ?mFecNull,"+;
			" ?tbAt_Alert, ?tcTexto, ?mxambito,?lcOpcion) ")

	Case tnOpcion = 3
		mRet = SQLExec(mcon1,"Update TabAntecPac set AT_fpasiva = ?mFecHoy Where Id = ?tnId")

	Case tnOpcion = 4
		mRet = SQLExec(mcon1,"Update TabAntecPac set At_Alert= ?tbAt_Alert Where Id = ?tnId")

Endcase

If mRet <= 0
	Messagebox("ERROR DE ACTUALIZACION - ANTECEDENTES",16,"ERROR")
	Return .F.
Endif



