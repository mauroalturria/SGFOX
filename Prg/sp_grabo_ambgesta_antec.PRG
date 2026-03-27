Lparameters mOpcion, mId, mritmo, mmac, mfechaucg, ;
	mmena, mirc, mgf, mgrupo, mfactor

*!*		mlacta , mcantmes, mrequirio, mcondRN

Do Case 

	Case mOpcion = 1 && completo

		mRet = Sqlexec(mcon1,"Update TabAmbGesta Set " + ;
			"Tag_ritmo = ?mritmo, " + ;
			"Tag_mac = ?mmac, " + ;
			"Tag_fechaucg = ?mfechaucg, " + ;
			"TAG_menaca = ?mmena, " + ;
			"TAG_irs = ?mirc, " + ;
			"TAG_gf = ?mgf, " + ;
			"TAG_gruposangre = ?mgrupo, " + ;
			"TAG_factorsangre = ?mfactor " + ;
			"Where Id = ?mId ")

*!*			"TAG_lacta = ?mlacta, " + ;
*!*				"TAG_cantmes = ?mcantmes, " + ;
*!*				"TAG_neo = ?mrequirio, " + ;
*!*				"Tag_condRN = ?mcondRN "

Endcase 						

If mRet <= 0
	Messagebox("ERROR AL GUARDAR LOS ANTECEDENTES - GESTACION ",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif 