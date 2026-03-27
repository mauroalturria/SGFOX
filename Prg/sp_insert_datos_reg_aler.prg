***
*	agrega datos de registracio
***
Lparameters mnroreg,cupdate
mret = SQLExec(mcon1, "select id from TabRegdatos where TRDA_Registracio = ?mnroreg ","mwkregdctr")
If Reccount("mwkregdctr") > 0
	mid = mwkregdctr.Id
	mret = SQLExec(mcon1, "update TabRegDatos set  " + cupdate +;
		" where id = ?mid ")
Else
	mret = SQLExec(mcon1, "insert into TabRegDatos( TRDA_Registracio, TRDA_ApelMat,TRDA_ApellidoEleccion , TRDA_GeneroEleccion , TRDA_NombreEleccion ) " + ;
		"values( ?mnroreg,'','','','')")
	mret = SQLExec(mcon1, "select id from TabRegdatos where TRDA_Registracio = ?mnroreg ","mwkregdctr")
	If Reccount("mwkregdctr") > 0
		mid = mwkregdctr.Id
		mret = SQLExec(mcon1, "update TabRegDatos set  " + cupdate +;
			" where id = ?mid ")
	Else
*		ERROR
	Endif
Endif
