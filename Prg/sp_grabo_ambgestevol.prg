Lparameters tnOpcion, tnId, tbAge_fcf, tbAge_pprb, tnAge_alturauter, tnAge_dinamuter, ;
	tbAge_edemas, tdAge_fecha, tdAge_fhToma, tnAge_id, tbAge_movfetal, tnAge_peso, ;
	tnAge_tad, tnAge_tas, tbAge_tonouter

*Set Step On

Do Case
	Case tnOpcion = 1

		mRet = SQLExec(mcon1,"Insert into TabAmbGestEvol " + ;
			"(Age_fcf, Age_pprb, Age_alturauter, Age_dinamuter, " + ;
			"Age_edemas, Age_fecha,Age_fhToma, Age_id, Age_movfetal, Age_peso, " + ;
			"Age_tad, Age_tas, Age_tonouter) Values ( " + ;
			"?tbAge_fcf, ?tbAge_pprb, ?tnAge_alturauter, ?tnAge_dinamuter, " + ;
			"?tbAge_edemas, ?tdAge_fecha, ?tdAge_fhToma, ?tnAge_id, ?tbAge_movfetal, ?tnAge_peso, " + ;
			"?tnAge_tad, ?tnAge_tas, ?tbAge_tonouter ) ")


	Case tnOpcion = 2

		mRet = SQLExec(mcon1,"Update TabAmbGestEvol Set " + ;
			"Age_fcf = ?tbAge_fcf, Age_pprb = ?tbAge_pprb, " + ;
			"Age_alturauter = ?tnAge_alturauter, Age_dinamuter = ?tnAge_dinamuter, " + ;
			"Age_edemas = ?tbAge_edemas, Age_fecha = ?tdAge_fecha, " +;
			"Age_fhToma = ?tdAge_fhToma, Age_id = ?tnAge_id, Age_movfetal = ?tbAge_movfetal, Age_peso = ?tnAge_peso, " + ;
			"Age_tad = ?tnAge_tad, Age_tas = ?tnAge_tas, Age_tonouter = ?tbAge_tonouter " + ;
			"Where Id = ?tnId")

Endcase

If mRet <= 0
	Messagebox("ERROR AL GUARDAR",16,"ERROR")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif