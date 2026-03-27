****
**  Busco entidades
****
Parameters fechad, tipod, mtipoe
****esto es para solointernados
If Vartype(musuhabil)="C"
	mfiltra = IIF(EMPTY(musuhabil),''," and ENT_tipo in ("+Alltrim(musuhabil)+") " )
Else
	mfiltra = ''
Endif
If Vartype(mtipoe) # "N"
	mtipoe = 1  && Tipo de Entidades a listar 1 : Sólo Activas 2 : Todas, pasivas también
Endif
If mxambito >1
	If !Used('mwktabambito')
		mret = SQLExec(mcon1,"select * from TabAmbito", "mwktabambito")
	Endif
	Select mwktabambito
	Locate For Id = mxambito
	mccpoamb = " and ENT_codagrup  IN ("+Alltrim(mwktabambito.tipoent)+") "

Else
	mccpoamb = ''
Endif
Use In Select("mwkentidad")

If mtipoe = 1

	If Type('fechad') # "D"

		If Type('tipod') # "C"
			mret = SQLExec(mcon1,"select ENT_codent, ENT_descrient,ENT_codagrup,ENT_tipo,ENT_nroprestadorexterno,ENT_turnosweb from entidades " + ;
				"where ENT_fecpas is null &mccpoamb &mfiltra  order by ENT_descrient", "mwkentidad")
		Else
			mret = SQLExec(mcon1,"select ENT_codent, ENT_descrient,ENT_codagrup,ENT_fecpas,ENT_tipo,ENT_nroprestadorexterno,ENT_turnosweb"+;
				" from entidades" + ;
				" where ENT_fecpas is not null &mccpoamb &mfiltra order by ENT_descrient", "mwkentidad")
		Endif

	Else

		If fechad = {//}
			fechad = Ctod("01/01/1900")
		Endif

		mret = SQLExec(mcon1,"select ENT_codent, ENT_descrient,ENT_codagrup,ENT_tipo,ENT_nroprestadorexterno,ENT_turnosweb from entidades " + ;
			" where (ENT_fecpas is null or ENT_fecpas >= ?fechad) &mccpoamb &mfiltra "+;
			" order by ENT_descrient", "mwkentidad")

	Endif

Else

	mret = SQLExec(mcon1,"select ENT_descrient,ENT_codent, ENT_tipo,ENT_nroprestadorexterno ,ENT_codagrup from entidades " + ;
		"order by ENT_descrient", "mwkentidad")

Endif

If mret < 0
	Messagebox("ERROR EN LA CONSULTA DE ENTIDADES",16,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Do prg_cancelo
Endif
