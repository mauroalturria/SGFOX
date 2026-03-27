Parameters lnId, lcIp, lcDescrip, lnTipo, ldFecAlta


Do Case
	Case lnId = 0
		mRet = SqlExec(mcon1,"Insert into TabStProgram (Pg_Ip, Pg_Descrip, Pg_Tipo, Pg_FecAlta) " + ;
							" Values (?lcIp, ?lcDescrip, ?lnTipo, ?ldFecAlta )" )
	Case lnId > 0
		mRet = SqlExec(mcon1,"Update TabStProgram Set Pg_Ip = ?lcIp, " + ;
							" Pg_Descrip = ?lcDescrip, Pg_Tipo = ?lnTipo, " + ;
							"Pg_FecAlta = ?ldFecAlta Where Id = ?lnId ")
EndCase	


If mRet <= 0
	MessageBox("ERROR AL ACTUALIZAR PROGRAMAS",48 ,"VALIDACION")
	Return .f.
Endif 
