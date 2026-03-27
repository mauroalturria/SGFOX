mcon1 = SQLConnect("conec02")
Do sp_busco_estados With 7, " and tipo = 46 ", "mwkAdmonline"
Do sp_busco_estados With 7, " and tipo = 45 ", "mwkservprueba"
Do sP_desconexion
Go Top In mwkservprueba
mstringcon = mwkservprueba.Descrip

*miconex = Sqlstringconnect("Driver={InterSystems ODBC};PORT=1972;SERVER="+mstringcon )

*Select paciente

*!*	Set Step On
*!*	mihc = ''
*!*	Do While !Eof()
*!*		micta = admiN.CUENTA
*!*		mtipo = "INT"
*!*	*Do cws_admision_110 With mtipo,mihc,micta,0,"CLIN"
*!*		If mtipo ="INT"
*!*			Do cws_traslado_110 With 1,micta,54095,""
*!*			Select datos
*!*			If pac_tipopac =1
*!*				Do cws_traslado_110 With 2,micta,54095,"CLIN"
*!*			Endif
*!*		Endif
*!*		Select admiN
*!*		Skip 1

*!*	Enddo
mcon1 = SQLConnect("conec01")
mret = SQLExec(mcon1, "select sec_codsector, sec_descripsec, sec_habitsala"+;
	",SEC_secquirur,SEC_internacion from sectores " + ;
	"where sec_internacion = 1 order by sec_descripsec", "mwksectorint")
mret = SQLExec(mcon1, "select cuil  from prestadores " + ;
	"where fecpasivap='1900-01-01' ", "mwkcuits")

*!*	Select * From pacbristol Group By pac_codadmision Order By pac_codhci,pac_codadmison ;
*!*		into Cursor pacientes
*!*	Select cuentas
*!*	go top
*!*	Scan
*!*		mnroreg = PACIENTES
*!*	*!*		mireg = pac_codhci
*!*	*!*		mret = SQLExec(mcon1, "select  HIS_codentidad "+;
*!*	*!*			" FROM histambgua "+ ;
*!*	*!*			" where  HIS_nroregistrac= ?mireg and histambgua.HIS_codadmision = ?mnroreg " +;
*!*	*!*			" order by HIS_fechaadmision desc ","mwkctasamb")
*!*	*!*		If Inlist(mwkctasamb.HIS_codentidad,876,27,149,903)
*!*			mret = SQLExec(mcon1, "select * "+;
*!*				" FROM pacientes,registracio "+ ;
*!*				" where  PAC_codadmision  = ?mnroreg and PAC_codhci = REG_nroregistrac " +;
*!*				" ","mwkbuspacie")
*!*			If mret < 0
*!*				=Aerr(eros)
*!*				Messagebox(eros(3))
*!*			Endif
*!*			If !Used('datos')
*!*				Select * From mwkbuspacie Into Cursor datos
*!*			Else
*!*				Select * From mwkbuspacie Union All Select * From datos Into Cursor datos2
*!*				Select * From datos2 Into Cursor datos

*!*	*!*			Endif
*!*		Endif
*!*	Endscan
*!*	Set Step On
*!*	*!*	mcon1 = SQLConnect("conec02")
*!*	*!*	Select Distinct * From datos Into Cursor pacientes
*!*	*!*	Select pacientes
*!*	*!*	Scan
*!*	*!*		micta = pac_codadmision
*!*	*!*		mihc = pac_codhce
*!*	*!*		Select * From datos Where pac_codhce = mihc Into Cursor mwkbuspacie
*!*	*!*		Do cws_registra_110 With mihc
*!*	*!*	Endscan
*!*	*!*	Do sP_desconexion
*!*	*select * from pacientes order by pac_codhci into cursor datos

SELECT * FROM mwkcuits WHERE VAL(cuil)>20 INTO CURSOR vercuit
SELECT vercuit
GO top
Select datos
Go Top
Set Step On
mihc = ''
misrgistros = 0
*locate for pacientes="0ZS080-9"
Do While !Eof() &&and misrgistros <70

		micuit = vercuit.cuil
		SKIP 1 IN vercuit
		IF EOF('vercuit')
			GO TOP IN 'vercuit'
		endif

*!*		micta = datos.pacientes
*!*		If mihc <> datos.pac_codhce
*!*			mihc = datos.pac_codhce
		mihc = datos.histclin
		misrgistros =misrgistros +1
		Use In Select('mwkbuspacie')
		Do cws_registra_110 With mihc,micuit 
*!*		ENDIF
		Select datos

*!*		mtipo = pac_tipopacIENTE

*!*	*	if mtipo #"INT"
*!*		Do cws_admision_110 With mtipo,mihc,micta,0,""
*!*		If mtipo ="INT"
*!*			Do cws_traslado_110 With 1,micta,54095,""
*!*			Select datos
*!*			If pac_tipopac =1
*!*				Do cws_traslado_110 With 2,micta,54095,""
*!*			Endif
*!*		Endif
*endif
	Select datos
	Skip 1

Enddo

Do sP_desconexion

For ti=1 To 3
	SQLDisconnect(ti)

Next ti
miconex = 0
