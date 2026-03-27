mcon1 = SQLConnect("conec02")
Do sp_busco_estados With 7, " and tipo = 46 ", "mwkAdmonline"
Do sp_busco_estados With 7, " and tipo = 45 ", "mwkservprueba"
Do sP_desconexion
Go Top In mwkservprueba
mstringcon = mwkservprueba.Descrip
mcon1 = SQLConnect("conec01")
mret = SQLExec(mcon1, "select sec_codsector, sec_descripsec, sec_habitsala"+;
	",SEC_secquirur,SEC_internacion from sectores " + ;
	"where sec_internacion = 1 order by sec_descripsec", "mwksectorint")


Select altas
Go Top
Set Step On
mihc = ''
misrgistros = 0
*locate for pacientes= "0Z7209-9"
Do While !Eof() &&and misrgistros <700
	micta = altas.episodio
*	Do cws_admision_110 With mtipo,mihc,micta,0,""

		Do cws_trasla_110 With 2,micta,54095,""
		Select altas
*		If pac_tipopac =1
*			Do cws_traslado_110 With 2,micta,54095,""
*		Endif
*endif
	Select altas
	Skip 1

Enddo

Do sP_desconexion
