Lparameters mOpcion, mId, maniomes, ;
	mecofecha, mecosem, medadgest, mfechaucg, ;
	mfpp, mfum, mmac, mnroregis, mpeso, mritmo, mtermino, ;
	mmena, mirc, mgf, mantec, mlacta, mcantmes, mrequirio, mcondRN, mObs      

Do Case 

	Case mOpcion = 1 && completo

		mRet = Sqlexec(mcon1,"Insert into TabAmbGesta ( " + ;
			"Tag_aniomes, Tag_ecofecha, Tag_ecosem, " + ;
			"Tag_edadgest, Tag_fechaucg, Tag_fpp, Tag_fum, Tag_mac, " + ;
			"Tag_nroregis, Tag_peso, Tag_ritmo, Tag_termino ) Values " + ;
			"( ?maniomes, ?mecofecha, ?mecosem, " + ;
			"?medadgest, ?mfechaucg, ?mfpp, ?mfum, ?mmac, " + ;
			"?mnroregis, ?mpeso, ?mritmo, ?mtermino ) " )
			
	Case mOpcion = 2 && completo

		mRet = Sqlexec(mcon1,"Update TabAmbGesta Set " + ;
			"Tag_aniomes = ?maniomes, " + ;
			"Tag_ecofecha = ?mecofecha, Tag_ecosem = ?mecosem, " + ;
			"Tag_edadgest = ?medadgest, Tag_fechaucg = ?mfechaucg, " + ;
			"Tag_fpp = ?mfpp, Tag_fum = ?mfum, Tag_mac = ?mmac, " + ;
			"Tag_peso = ?mpeso, " + ;
			"Tag_ritmo = ?mritmo, Tag_termino = ?mtermino " + ;
			"Where Id = ?mId ")


	Case mOpcion = 3 && antecedentes

		mRet = Sqlexec(mcon1,"Insert into TabAmbGesta ( " + ;
			"Tag_nroregis, Tag_aniomes, Tag_termino, Tag_edadgest, Tag_peso, Tag_antec, " + ;
			"TAG_lacta, TAG_cantmes, TAG_neo, Tag_condRN, Tag_Obs " + ;
			" ) Values " + ;
			"(?mnroregis, ?maniomes, ?mtermino, ?medadgest, ?mpeso, ?mantec, " + ;
			" ?mlacta, ?mcantmes, ?mrequirio, ?mcondRN, ?mObs ) " )
			
	Case mOpcion = 4 && antecedentes

		mRet = Sqlexec(mcon1,"Update TabAmbGesta Set " + ;
			"Tag_aniomes = ?maniomes, " + ;
			"Tag_termino = ?mtermino, " + ;
			"Tag_peso = ?mpeso, " + ;
			"Tag_edadgest = ?medadgest, " + ;
			"Tag_antec = ?mantec, " + ;
			"TAG_lacta = ?mlacta, " + ;
			"TAG_cantmes = ?mcantmes, " + ;
			"TAG_neo = ?mrequirio, " + ;
			"Tag_condRN = ?mcondRN, " + ;
			"Tag_Obs = ?mObs " + ;			
			"Where Id = ?mId ")


	Case mOpcion = 5 && alta gesta

		mRet = Sqlexec(mcon1,"Insert into TabAmbGesta ( " + ;
			"Tag_aniomes, Tag_ecofecha, Tag_ecosem, " + ;
			"Tag_edadgest, Tag_fechaucg, Tag_fpp, Tag_fum, Tag_mac, " + ;
			"Tag_nroregis, Tag_peso, Tag_ritmo, Tag_termino, Tag_condRN ) Values " + ;
			"( ?maniomes, ?mecofecha, ?mecosem, " + ;
			"?medadgest, ?mfechaucg, ?mfpp, ?mfum, ?mmac, " + ;
			"?mnroregis, ?mpeso, ?mritmo, ?mtermino, ?mcondRN ) " )
			
	Case mOpcion = 6 && modif gesta

		mRet = Sqlexec(mcon1,"Update TabAmbGesta Set " + ;
			"Tag_aniomes = ?maniomes, " + ;
			"Tag_ecofecha = ?mecofecha, Tag_ecosem = ?mecosem, " + ;
			"Tag_edadgest = ?medadgest, Tag_fechaucg = ?mfechaucg, " + ;
			"Tag_fpp = ?mfpp, Tag_fum = ?mfum, Tag_mac = ?mmac, " + ;
			"Tag_peso = ?mpeso, " + ;
			"Tag_ritmo = ?mritmo, Tag_termino = ?mtermino, " + ;
			"Tag_condRN = ?mcondRN " + ;
			"Where Id = ?mId ")

Endcase 						

If mRet <= 0
	Messagebox("ERROR AL GUARDAR LA GESTACION ",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif 