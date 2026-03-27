Parameters tnRegFoto

lcSql = "select id,TRF_Foto " + ;
		"from TabRegFoto " + ;
		"where TRF_Registracio  = ?tnRegFoto "

If !Prg_EjecutoSql(lcSql  , "mwkRegFoto")
	Return .f.
Endif 