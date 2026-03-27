mcon1 = SQLConnect("conec01")
*Do sp_conexion

Do sp_busco_estados With 7, " and tipo = 46 ", "mwkAdmonline"
Do sp_busco_estados With 7, " and tipo = 45 ", "mwkservprueba"

*Do sP_desconexion

Go Top In mwkservprueba
mstringcon = mwkservprueba.Descrip

*!*	miconex = Sqlstringconnect("Driver={InterSystems ODBC};PORT=1972;SERVER="+mstringcon )

Select datos

Set Step On
mihc = ''
Do While !Eof()
  
	mihc = datos.hclin
	micta = datos.cta
	mret = SQLExec(mcon1,"update Registracio set " +;
		"REG_telefonos= '49598200' where REG_nrohclinica  = ?mihc ")
	Do cws_admision With "AMB",mihc,micta,0 
*!*	 	If mtipo ="INT"
*!*			Do cws_traslado_110 With 1,micta,54095,""
*!*			Select datos
*!*			If pac_tipopac =1
*!*				Do cws_traslado_110 With 2,micta,54095,"CLIN"
*!*			Endif
*!*		Endif
	Select datos
	Skip 1

Enddo
*mcon1 = SQLConnect("conec01")
SET STEP ON
Do sp_busco_estados With 25,' and tipo = 48 order by estado ','mwksECESP'

mret = SQLExec(mcon1, "select sec_codsector, sec_descripsec, sec_habitsala"+;
	",SEC_secquirur,SEC_internacion from sectores " + ;
	"where sec_internacion = 1 order by sec_descripsec", "mwksectorint")

mret = SQLExec(mcon1, "SELECT ID, cuil FROM Prestadores"+;
	" WHERE fecpasivap = '1900-01-01' AND Prestadores.cuil > '10' order by id desc ","vercuit")

*Do cws_registra With '3857472-3'

Set Step On

Select FALTAS
Scan

	mnroreg = PAC_CODADMISION

*  mnroreg = "('0O2444-A','0O2462-A','0O1186-A','0O0553-A')"
*  mnroreg = "('0P6729-A','0P8259-A' )"
*  mnroreg = '0OZ798-A'
*  mnroreg = "('0OZ798-A', '0OA583-A', '0OA568-A')"
*  mnroreg = "('0OA837-A', '0OA583-A', '0OA568-A')"
*  mnroreg = "('0P5728-A','0P4816-A','0OI806-A','0OG361-A','0OG360-A')"

*  mnroreg = "('0PV321-A','0PV320-A','0PU036-A','0PU035-A','0PU034-A','0PU033-A','0PU032-A','0PU031-A','0PU030-A','0PU029-A','0PT820-A','0PT645-A','0PS004-A','0PR341-A','556727-6')"

*mnroreg = "('0VV464-A')"


	mret = SQLExec(mcon1, "select * "+;
		" FROM pacientes "+ ;
		" where  PAC_codadmision  = ?mnroreg  "+;
		" ","mwkbuspacie")

*!*	mret = SQLExec(mcon1, "select * "+;
*!*		" FROM pacientes "+ ;
*!*		" where  PAC_codadmision  in "+mnroreg +;
*!*		" ","mwkbuspacie")

	If mret < 0
		=Aerr(eros)
		Messagebox(eros(3))
	Endif

	If !Used('datos')
		Select * From mwkbuspacie Into Cursor datos
	Else
		Select * From mwkbuspacie Union All Select * From datos Into Cursor datos2
		Select * From datos2 Into Cursor datos

	Endif

Endscan

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
*select * from pacbristoladm order by pac_codhci into cursor datos

Select datos
Go Top
Set Step On
mihc = ''
misrgistros = 0

*   locate for pacientes= "0JK456-A"

Do While !Eof() &&and misrgistros <700
	micta = datos.pacientes
	mihc = datos.pac_codhce &&&REG_nrohclinica  &&pac_codhce
	misrgistros =misrgistros +1
	Use In Select('mwkbuspacie')

	miespe =''

	mtipo = Iif(datos.pac_tipopac=3,'GUA',Iif(datos.pac_tipopac=2,'AMB','INT'))

*!*			If mtipo = "GUA"
*!*				Requery('guardia_vales')
*!*				miespe = guardia_vales.PRE_especialidad
*!*			Else
*!*				miespe =''
*!*			Endif

	Do cws_admision With mtipo,mihc,micta,0,miespe
	If mtipo ="INT"
		Do cws_traslado With 1,micta,54095,""
		Select datos
		If pac_tipopac =1
			Do cws_traslado With 2,micta,54095,""
		Endif
	Endif
	Select datos
	Skip 1

Enddo

Do sP_desconexion

For ti=1 To 3
	SQLDisconnect(ti)
Next ti

miconex = 0
