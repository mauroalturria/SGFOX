*
* Actualizacion Maestro CIAM Auditoria de Internaciones
*

Lparameters mlmovi, mfecha, mnafil, mndocu, mnombr, mcentr,;
	mobrso,	msectr,	mlsexo,	mfenac,	mledad, mfegre,	mmotiv,;
	mdiagn, mactse, mlidac

midusua = mwkusuario.idusuario
mfecmov = sp_busco_fecha_serv('DT')

If mlmovi = 'ALTA'
	mret = sqlexec(mcon1,"insert into TabCiamAudInt"+;
		" (TCI_fecing,TCI_nroafi,TCI_nrodoc,TCI_nombrepac,TCI_idcentro,TCI_identi,TCI_idsector,"+;
		"TCI_sexo,TCI_fecnac,TCI_txtedad,TCI_fecegr,TCI_idmotivo,TCI_usuario,TCI_fecmov,TCI_diagnos)"+;
		" values (?mfecha,?mnafil,?mndocu,?mnombr,?mcentr,?mobrso,?msectr,?mlsexo,?mfenac,"+;
		"?mledad,?mfegre,?mmotiv,?midusua,?mfecmov,?mdiagn)")
	If mret > 0
		mret = sqlexec(mcon1,"select ID as lId from TabCiamAudInt"+;
			" where TCI_fecing=?mfecha and TCI_nroafi=?mnafil and"+;
			" TCI_usuario=?midusua and TCI_fecmov=?mfecmov","mwkAudInt2")
		If mret > 0
			If used('mwkAudInt2')
				If reccount('mwkAudInt2')>0
					mlid = mwkAudInt2.lId
					mret = sqlexec(mcon1,"insert into TabCiamSector"+;
						" (TCS_idaudita,TCS_fecha,TCS_idsector,TCS_usuario)"+;
						" values (?mlid,?mfecha,?msectr,?midusua)")
					If mret < 0
						Messagebox("EN REGISTRO DEL SECTOR DE AUDITORIAS DE INTERNACION"+CHR(10)+;
							"AVISE A SISTEMAS",16,"ERROR")
					Endif
				Endif
				Use in mwkAudInt2
			Endif
		Else
			Messagebox("EN LA CONSULTA DE LA AUDITORIA DE INTERNACION"+chr(10)+;
				"AVISE A SISTEMAS",16,"ERROR")
		Endif
	Else
		Messagebox("EN REGISTRO DE AUDITORIA DE INTERNACION"+CHR(10)+;
			"AVISE A SISTEMAS",16,"ERROR")
	Endif
Else
	mlid = mlidac
	mret = sqlexec(mcon1,"update TabCiamAudInt set "+;
		"TCI_fecing=?mfecha,TCI_nroafi=?mnafil,TCI_nrodoc=?mndocu,TCI_nombrepac=?mnombr,TCI_idcentro=?mcentr,"+;
		"TCI_identi=?mobrso,TCI_idsector=?msectr,TCI_sexo=?mlsexo,TCI_fecnac=?mfenac,TCI_txtedad=?mledad,"+;
		"TCI_fecegr=?mfegre,TCI_idmotivo=?mmotiv,TCI_usuario=?midusua,TCI_fecmov=?mfecmov,TCI_diagnos=?mdiagn"+;
		" where id = ?mlid")
	If mret > 0
		If mactse
			mret = sqlexec(mcon1,"insert into TabCiamSector"+;
				" (TCS_idaudita,TCS_fecha,TCS_idsector,TCS_usuario)"+;
				" values (?mlid,?mfecha,?msectr,?midusua)")
			If mret < 0
				Messagebox("EN REGISTRO DEL SECTOR DE AUDITORIAS DE INTERNACION"+CHR(10)+;
					"AVISE A SISTEMAS",16,"ERROR")
			Endif
		Endif
	Else
		Messagebox("EN ACTUALIZACION DE DATOS DE LA"+CHR(10)+;
			"AUDITORIA DE INTERNACION",16,"ERROR")
	Endif
Endif
