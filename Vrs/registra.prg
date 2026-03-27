mcon1 = SQLConnect("conec01")
Do sp_busco_estados With 7, " and tipo = 46 ", "mwkAdmonline"
Do sp_busco_estados With 7, " and tipo = 45 ", "mwkservprueba"
Do sP_desconexion
Go Top In mwkservprueba
mstringcon = mwkservprueba.Descrip

*!*	Enddo
mcon1 = SQLConnect("conec01")
mret = SQLExec(mcon1, "select sec_codsector, sec_descripsec, sec_habitsala"+;
	",SEC_secquirur,SEC_internacion from sectores " + ;
	"where sec_internacion = 1 order by sec_descripsec", "mwksectorint")
mret = SQLExec(mcon1, "SELECT ID, cuil FROM Prestadores"+;
	" WHERE fecpasivap = '1900-01-01' AND Prestadores.cuil > '10' order by id desc ","vercuit")
Select arreglo
Go Top
Set Step On
mihc = ''
misrgistros = 0
*locate for pacientes= "0Z7209-9"
Scan
	mihc = arreglo.REG_nrohclinica  &&pac_codhce
	misrgistros =misrgistros +1
	Use In Select('mwkbuspacie')
	If Val(Nvl(arreglo.reg_cuit,''))<10
		micuit = prg_calculo_cuit(Alltrim(arreglo.REG_sexo),Int(arreglo.REG_numdocumento))
		If (arreglo.reg_fecnacimiento>Date()-90 And arreglo.REG_numdocumento < 57597813)
			micuit = ''
		Endif
		Do cws_registra With mihc,micuit
	Else
		Do cws_registra With mihc
	Endif

Endscan

Do sP_desconexion

For ti=1 To 3
	SQLDisconnect(ti)

Next ti
miconex = 0
