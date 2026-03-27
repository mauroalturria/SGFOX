mcon1 = SQLConnect("conec01")
*Do sp_conexion
Public mstringcon
Do sp_busco_estados With 7, " and tipo = 46 ", "mwkAdmonline"
Do sp_busco_estados With 7, " and tipo = 45 ", "mwkservprueba"
*do sP_desconexion
Go Top In mwkservprueba
mstringcon = Alltrim(mwkservprueba.Descrip)
mcon2 = mcon1
*DO sp_desconexion
*mcon1 = SQLConnect("conec01")
USE IN select('datos')
USE IN select('datos2')
Do sp_busco_estados With 25,' and tipo = 48 order by estado ','mwksECESP'
mret = SQLExec(mcon1, "select sec_codsector, sec_descripsec, sec_habitsala"+;
	",SEC_secquirur,SEC_internacion from sectores " + ;
	"where sec_internacion = 1 order by sec_descripsec", "mwksectorint")

mret = SQLExec(mcon1, "SELECT ID, cuil FROM Prestadores"+;
	" WHERE fecpasivap = '1900-01-01' AND Prestadores.cuil > '10'","vercuit")
*Select Distinct Episodio,Fe_admis,Cama_adm,Hora_alta,cama_alta From internados Into Cursor datos
* Select admis
*!*	*Do cws_registra With '3857472-3'

*!*	*!*	Set Step On

*!*	*!*	Set Step On
*!*	     SCAN 
  	mnroreg = '0VE775-F' &&cuentas.episodio
*!*	*!*		
*!*	   	mnroreg =  admis.episodio
	mret = SQLExec(mcon1, "select * "+;
		" FROM pacientes "+ ;
		" where  PAC_codadmision  = ?mnroreg  "+;
		" ","mwkbuspacie")
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
*!*	  Endscan

Select datos
Go Top
Set Step On
mihc = ''
misrgistros = 0
*locate for pacientes="0Z8679-A"
*!*	skip
Set Step On
Do While !Eof() &&and misrgistros <50

	Select datos
	micta = Alltrim(pacientes)
	mret = SQLExec(mcon1,"SELECT Lugarintern.*, Sectores.SEC_habitsala"+;
		" FROM Lugarintern INNER JOIN SQLUser.SECTORES Sectores "+;
		" ON  Lugarintern.LUG_codsector = Sectores.SEC_codsector "+;
		" WHERE  LUG_PACIENTES = ?micta "+;
		" ORDER BY LUG_fechaingreso,LUG_horaingreso  " ,"mwklugarinterna")
	Select datos
	mtipo = Iif(datos.pac_tipopac=3,'GUA',Iif(datos.pac_tipopac=2,'AMB','INT'))
	mihc = pac_codhce
	miespe = ''&&guardia_vales.PRE_especialidad
Do cws_admisionnreg With mtipo,mihc,micta, pac_codhci
 	Requery('tabintserv')
	m9 = datos.pac_sectorinternac
	miespe =''
	midiesp = 1000
	Select mwksECESP
	Scan
		If m9  $ Alltrim(mwksECESP.Descrip)
			midiesp = mwksECESP.estado
			Exit
		Endif
	Endscan
	Select mwksECESP
	mret = SQLExec(mcon1,"SELECT * FROM ZapServEspec "+;
		" WHERE  NroServicio  = ?midiesp ","mwkespxpiso")
	miespe = mwkespxpiso.codesp
	Do cws_admision_110 With mtipo,mihc,micta,0,miespe
	Select mwklugarinterna
	Scan
		Do cws_traslado_110 With 1,micta,0,'' &&miespe
	Endscan
	If datos.pac_tipopac =1
		If Empty(miespe )
			miespe = 'CLIN'
		Endif
		If miespe="EMER"
			miespe = 'CLIN'
		Endif
		Do cws_traslado_110 With 101, micta,0,miespe
	Endif

	Select datos
	Skip 1

Enddo

Do sP_desconexion

For ti=1 To 3
	SQLDisconnect(ti)

Next ti
miconex = 0
