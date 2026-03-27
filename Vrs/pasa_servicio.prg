mcon1 = SQLConnect("conec01")
Public mstringcon
Do sp_busco_estados With 7, " and tipo = 46 ", "mwkAdmonline"
Do sp_busco_estados With 7, " and tipo = 45 ", "mwkservprueba"
*do sP_desconexion
Go Top In mwkservprueba
mstringcon = Alltrim(mwkservprueba.Descrip)

mret = SQLExec(mcon1, "select sec_codsector, sec_descripsec, sec_habitsala"+;
	",SEC_secquirur,SEC_internacion from sectores " + ;
	"where sec_internacion = 1 order by sec_descripsec", "mwksectorint")

mret = SQLExec(mcon1, "SELECT ID, cuil FROM Prestadores"+;
	" WHERE fecpasivap = '1900-01-01' AND Prestadores.cuil > '10'","vercuit")


Select pac
Go Top
Set Step On
mihc = ''
misrgistros = 0
*!*	locate for pacientes="490857-3"
*!*	skip
Do While !Eof() &&and misrgistros <50

*	micuit = prg_calculo_cuit(alltrim(REG_sexo),int(REG_numdocumento))
*!*		if empty(micuit)
*!*			micuit = vercuit.cuil
*!*			skip 1 in vercuit
*!*			if eof('vercuit')
*!*				go top in 'vercuit'
*!*			endif
*!*		endif
	Select pac
	micta = Alltrim(pacientes)
*!*		If mihc <> pac.pac_codhce
*		mihc = pac.pac_codhce
*!*			misrgistros =misrgistros +1
*!*			Use In Select('mwkbuspacie')
*!*	*		do cws_registra_110 with mihc
*!*		Endif
	Requery('lugarinterna')
*	mtipo = pac_tipopacIENTE
	mtipo = "INT" &&Iif(pac.pac_tipopac=3,'GUA',Iif(pac.pac_tipopac=2,'AMB','INT'))
	m9 = pac.pac_sector

	Requery('tabintserv')



	miespe =''
	If Reccount('tabintserv')>0

		miespe = tabintserv.codesp
*		Do cws_traslado_110 WITH 1,micta,54035,miespe
*	Do cws_admision With mtipo,mihc,micta,0,miespe
	Else
*		If Reccount('lugarinterna')=1
		Select mwksECESP
		midiesp = 1000
		Scan
			If m9  $ Alltrim(mwksECESP.Descrip)
				midiesp = mwksECESP.estado
				Exit
			Endif
		Endscan
		mret = SQLExec(mcon1,"SELECT * FROM ZapServEspec "+;
			" WHERE  NroServicio  = ?midiesp ","mwkespxpiso")
		miespe = mwkespxpiso.codesp
*			Do cws_traslado_110 WITH 1,micta,54035,m8
	Endif
	If Empty(miespe )
		miespe = 'CLIN'
	Endif
	SELECT lugarinterna
		Do While !Eof() And Inlist(LUG_codsector, 'PQU','PRP','EME','CEG','IQB')
			Skip 1
		Enddo
		If Eof()
			Go Bottom
		Endif
	Select pac
	replace PAC_sector WITH lugarinterna.LUG_codsector, PAC_habita  WITH lugarinterna.LUG_habitacion,;
  	PAC_cama WITH lugarinterna.LUG_cama, PAC_catego  WITH lugarinterna.LUG_categoria,PAC_especi  WITH miespe
	Select pac
*	If pac_tipopac =1
*	Do cws_traslado_car WITH 1,micta,54095,""


	Select pac
	Skip 1

Enddo

Do sP_desconexion

For ti=1 To 3
	SQLDisconnect(ti)

Next ti
miconex = 0
