*mcon1 = sqlconnect("conec01")
DO sp_conexion
do sp_busco_estados with 7, " and tipo = 46 ", "mwkAdmonline"
do sp_busco_estados with 7, " and tipo = 45 ", "mwkservprueba"
do sP_desconexion
go top in mwkservprueba
mstringcon = mwkservprueba.descrip

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
mcon1 = sqlconnect("conec01")
Do sp_busco_estados With 25,' and tipo = 48 order by estado ','mwksECESP'
mret = SQLExec(mcon1, "select sec_codsector, sec_descripsec, sec_habitsala"+;
	",SEC_secquirur,SEC_internacion from sectores " + ;
	"where sec_internacion = 1 order by sec_descripsec", "mwksectorint")
mret = SQLExec(mcon1, "SELECT ID, cuil FROM Prestadores"+;
	" WHERE fecpasivap = '1900-01-01' AND Prestadores.cuil > '10' order by id desc ","vercuit")
*!*	Select pacamb
*!*	*Select cuentas
*!*	Scan
*!*		mnroreg = pacientes
*!*		mireg =  pac_codhci
*!*		mret = SQLExec(mcon1, "select  HIS_codentidad "+;
*!*			" FROM histambgua "+ ;
*!*			" where  HIS_nroregistrac= ?mireg and histambgua.HIS_codadmision = ?mnroreg " +;
*!*			" order by HIS_fechaadmision desc ","mwkctasamb")
*!*		If Inlist(mwkctasamb.HIS_codentidad,149)   &&,27,149)

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

*!*			Endif
*!*		Endif
*!*	Endscan
*!*	Set Step On
*!*	mcon1 = SQLConnect("conec02")
*!*	Select Distinct * From datos Into Cursor pacientes
*!*	Select pacientes
*!*	Scan
*!*		micta = pac_codadmision
*!*		mihc = pac_codhce
*!*		Select * From datos Where pac_codhce = mihc Into Cursor mwkbuspacie
*!*		Do cws_registra_110 With mihc
*!*	Endscan
*!*	Do sP_desconexion
*select * from pacientes order by pac_codhci into cursor datos

select datos
go top
set step on
mihc = ''
misrgistros = 0
*locate for pacientes= "0JK456-A"
do while !eof() &&and misrgistros <700
	micta = datos.pacientes
*	If mihc <> datos.pac_codhce
	mihc = datos.pac_codhce &&&REG_nrohclinica  &&pac_codhce
	misrgistros =misrgistros +1
	use in select('mwkbuspacie')
*!*		If Val(Nvl(reg_cuit,''))<10
*!*			micuit = prg_calculo_cuit(Alltrim(REG_sexo),Int(REG_numdocumento))
*!*			Do cws_registra With mihc,micuit
*!*		Else
*!*				Do cws_registra With mihc
*!*		Endif
*	Endif
miespe='CLIN'
	mtipo = iif(datos.pac_tipopac=3,'GUA',iif(datos.pac_tipopac=2,'AMB','INT'))
*	if mtipo #"INT"		 xtipopac,nrohclinica,mnroadm,mcodcie,mespec,msinreg,leseme	
	do cws_admision_110 with mtipo,mihc,micta,0,miespe
	if mtipo ="INT"
		do cws_traslado_110 with 1,micta,54095,""
		select datos
		if pac_tipopac =1
			do cws_traslado_110 with 2,micta,54095,""
		endif
	endif
*endif
	select datos
	skip 1

enddo

do sP_desconexion

for ti=1 to 3
	SQLDisconnect(ti)

next ti
miconex = 0
