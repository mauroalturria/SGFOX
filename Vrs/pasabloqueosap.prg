*mcon1 = SQLConnect("conec01")
Do sp_conexion
Public mstringcon
Do sp_busco_estados With 7, " and tipo = 46 ", "mwkAdmonline"
Do sp_busco_estados With 7, " and tipo = 45 ", "mwkservprueba"
*do sP_desconexion
Go Top In mwkservprueba
mstringcon = Alltrim(mwkservprueba.Descrip)

Do sp_busco_estados With 25,' and tipo = 48 order by estado ','mwksECESP'
mret = SQLExec(mcon1, "select sec_codsector, sec_descripsec, sec_habitsala"+;
	",SEC_secquirur,SEC_internacion from sectores " + ;
	"where sec_internacion = 1 order by sec_descripsec", "mwksectorint")

Select datos
Go Top
Set Step On

Do While !Eof() &&and misrgistros <50

	Select datos
	micta = Alltrim(envio)
	Do cws_desbloquea With micta

	Select datos
	Skip 1

Enddo

Do sP_desconexion

For ti=1 To 3
	SQLDisconnect(ti)

Next ti
miconex = 0
