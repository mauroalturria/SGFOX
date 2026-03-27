****
**  Busco entidades
****
Parameters fechad, tipod, mtipoe

If vartype(mtipoe) # "N"
	mtipoe = 1  && Tipo de Entidades a listar 1 : Sólo Activas 2 : Todas, pasivas también
Endif

If mtipoe = 1
	If type('fechad') # "D"
		If type('tipod') # "C"
			mret = sqlexec(mcon1,"select ENT_codent, ENT_descrient,ENT_codagrup from entidades " + ;
				"where ENT_fecpas is null order by ENT_descrient", "mwkentidad")
		Else
			mret = sqlexec(mcon1,"select ENT_codent, ENT_descrient,ENT_codagrup,ENT_fecpas"+;
				" from entidades" + ;
				" where ENT_fecpas is not null order by ENT_descrient", "mwkentidad")
		Endif
	Else
		mret = sqlexec(mcon1,"select ENT_codent, ENT_descrient,ENT_codagrup from entidades " + ;
			"where ENT_fecpas is null or ENT_fecpas >= ?fechad "+;
			"order by ENT_descrient", "mwkentidad")
	Endif
Else
	mret = sqlexec(mcon1,"select ENT_descrient,ENT_codent from entidades " + ;
		"order by ENT_descrient", "mwkentidad")
Endif

If mret < 0
	Messagebox("ERROR EN LA CONSULTA DE ENTIDADES",16,"ERROR")
	Do prg_cancelo
Endif
