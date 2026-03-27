**** registro pacientes sap
Lparameters nrohclinica,micuit

Private mresultado, merror,cprov(26)
Dimension cprov(26)
If mxambito<>1
	Return
Endif
xnrohclinica = nrohclinica
If Vartype(micuit)#"C"
	micuit=''
Endif

Do sp_busco_estados With 7, " and tipo = 48 ", "mwkAdmonline"
miresp ="AUN NO ESTA EN LINEA"
If mwkAdmonline.estado = 1 Or mwkusuario.codigovax = 54035
	If !Used('mwkcodpostal')
		mRet = SQLExec(mcon1,"SELECT codpostal,Tabloca1.descrip,idprovincia , Tabpcia1.descrip as desprov FROM Tabloca1 "+;
			"  INNER JOIN Tabpcia1 ON Tabloca1.idprovincia = Tabpcia1.ID "+;
			" ","mwkcodpostal")
	Endif

	mbusco1 = "where reg_nrohclinica = ?xnrohclinica and "
	msql_reg_ant = msql_reg
	Do sp_busco_nombre_paciente_1 With mbusco1, 1, '',,"mwkcswpac"
	msql_reg = msql_reg_ant
	mifec = sp_busco_fecha_serv("DD")
	m1 = Alltrim(mwkcswpac.reg_nrohclinica)
	nomape = Chrtran(mwkcswpac.reg_nombrepac, "§$%/()=?`'!><;:_#*+_", "                Ñ   ")
	m2 = Alltrim(Substr(nomape ,1,At(",",nomape ,1)-1)) && VER
	m3 = Alltrim(Substr(nomape ,At(",",nomape ,1)+1))
	m4 = ""
*	m5 = Dtoc(mwkcswpac.reg_fecnacimiento)
	m5 = Strtran(Dtoc(mwkcswpac.reg_fecnacimiento),"/",".")
	m6 = Alltrim(Nvl(mwkcswpac.reg_sexo,'I'))
	m7 = Alltrim(tratamiento(m6, Int(prg_edad(mwkcswpac.reg_fecnacimiento,mifec ,"N" )) ))
	m8 = "AR" &&Nacionalidad()
	m9 = Alltrim(Nvl(mwkcswpac.reg_domicilio,"."))
	m9 = Chrtran(m9, "§$%/()=?`'!><;:_#*+_,'ºª", "                Ñ       ")
	m10 = "AR" && Nacionalidad()
	m11 = Transform(Nvl(mwkcswpac.reg_cpostal,0))
	m12 =Alltrim( Nvl(mwkcswpac.reg_localidad,''))
	m13 = Transform(provincia(Nvl(mwkcswpac.reg_provincia,''),-1),"@L 99")
	Select mwkcodpostal
	lcambio = .F.
	Locate For codpostal = Val(m11)
	If !Found() Or  idprovincia = 25
		m11 = '1001'
		m13 = '00'
		m12 = 'CAPITAL FEDERAL'
		lcambio = .T.
	Endif
	If Found()
		Locate For codpostal = Val(m11) And Descrip=m12
		If !Found()
			Locate For codpostal = Val(m11)
		Endif
		mposcoma = At(",",Descrip)
		lcambio = (m12 = Alltrim(Iif(mposcoma=0,Descrip,Left(Descrip,mposcoma-1))))
		m12 = Alltrim(Iif(mposcoma=0,Descrip,Left(Descrip,mposcoma-1)))
		nprovcp = provincia(mwkcodpostal.desprov,-1)
		If Val(m13)#nprovcp
			lcambio = .T.
			m13 = Transform(nprovcp ,"@L 99")
		Endif
	Endif
	If Empty(m12)
		lcambio = .T.
		m12 = 'CAPITAL FEDERAL'
	Endif
	m14 =Alltrim( Nvl(mwkcswpac.reg_telefonos,''))
	mireg = mwkcswpac.REG_nroregistrac
&& Nro celular
	mRet = SQLExec(mcon1,"SELECT * FROM TabRegTel WHERE trt_Registracio = ?mireg and trt_TipoLinea = 'M' and Trt_pasiva = '1900-01-01' ","MWKREGTEL")
	If mRet <=0
*		Set Step On
	Endif
	If lcambio
		mireg = mwkcswpac.REG_nroregistrac
		mcpos = Val(m11)
		mprovi = Upper(Iif(m13 = '00','CAPITAL FEDERAL',provincia("",Val(m13)+1)))
		mRet = SQLExec(mcon1,"update registracio set reg_cpostal = ?mcpos, reg_localidad= ?m12,  "+;
			" reg_provincia = ?mprovi WHERE REG_nroregistrac = ?mireg")

	Endif

	m15 = Iif(Reccount('MWKREGTEL')>0,Alltrim(Transform(MWKREGTEL.trt_numero)),'')
	m16 = "" && telefono de la empresa
	cmail = ''&&Nvl(mwkcswpac.reg_email,"")
*Chrtran(cmail , "§$%/()=?`'!><;:_#*+_", "")
*!*		If At("@",cmail) >20
*!*			cmail =''
*!*		Else
*!*			If !prg_valido_mail(cmail)
*!*				cmail =''
*!*			Endif
*!*		Endif
	m17 = Alltrim(cmail)
	m18 = '' &&EstadoCivil()
	m19 = '' &&Religion()
	m20 = "X" && Lista de Religiones ?
	m21 = "" && VIP
	m22 = "" && Donante de Organos
	m23 = "" && Inactivo
	m24 = Iif("DISCA" $ Nvl(mwkcswpac.REG_bloq_comen,' '), "X","" )&& Discapacidad
	m25 = TipoDocumento(Val(mwkcswpac.reg_tipodocumento))
	If Val(mwkcswpac.reg_cuit)>0
		m25 = 'CL'
		m26 = Alltrim(mwkcswpac.reg_cuit)
	Else
		If Empty(micuit)
			m26 = Transform(mwkcswpac.reg_numdocumento)
		Else
			m25 = 'CL'
			m26 = Alltrim(micuit)

		Endif

	Endif
	m27 = "" && Apellido ????
	m28 = "" && Nombre de Referencia ???
	m29 = "" && Direccion ???????
	m30 = "" && Pais ????
	m31 = "" && CP ?
	m32 = "" && Localidad
	m33 = "" && Telefono
	m34 = "" && Email
	m35 = ""
	m36 = "" && Representante legal ????
	m37 = "" && Apellido ????
	m38 = "" && Nombre de Referencia ???
	m39 = "" && Direccion ???????
	m40 = "" && Pais ????
	m41 = "" && CP ?
	m42 = "" && Localidad
	m43 = "" && Telefono
	m44 = "" && Email
	m45 = ""
	m46 = "" && Representante legal ????

	mccampos = ''
	For I = 1 To 46
		mccampos = mccampos +Evaluate("m" + Alltrim(Transform(I)))+Iif(I<46,",","")
	Next

	mresultado = 0
	merror = 0
	mcopt = ''
	musuario = mwkusuario.idusuario
If !Used("mwkservprueba")
*	Do sp_busco_estados With 7, " and tipo = 45 ", "mwkservprueba"
Endif
	Go Top In mwkservprueba
	mstringcon = Alltrim(mwkservprueba.Descrip)
	If mwkservprueba.estado = 1
		miconex = Sqlstringconnect("Driver={InterSystems ODBC};PORT=1972;SERVER="+mstringcon )
	Else
		miconex = mcon1
	Endif

	mRet = SQLExec(miconex ,"CALL WS.AProcesarSP_GrabaAProcesar('SI_PO_0006_Alta_Paciente_Out',1,?mccampos,?musuario,?@mresultado, ?@merror","C1")
	If 	miconex # mcon1
		SQLDisconnect(miconex)
	Endif
	miresp = "Resultado : " + Transform(mresultado)+"Error : " + Transform(merror)
Endif
Return miresp
Function tratamiento(lcSexo, lnEdad)
*!*	?lcSexo
*!*	?lcEdad
lnEdadTope = 18

Do Case
Case lnEdad = 0
	lcResu = "0005" && Recien Nacido

Case lcSexo = "F"
	If lnEdad > lnEdadTope
		lcResu = "0002" && 	Señora
	Else
		lcResu = "0004" && 	Niña
	Endif

Case lcSexo = "M"

	If lnEdad > lnEdadTope
		lcResu = "0001" && 	Señor
	Else
		lcResu = "0003" && 	Niño
	Endif

Otherwise
	lcResu  = ""

*!*		0006	Empresa

Endcase

Return lcResu

Function provincia(lcProv,noc)

cprov(1)="CABA"
cprov(2)="Buenos Aires"
cprov(3	)="Catamarca"
cprov(4	)="Cordoba"
cprov(5	)="Corrientes"
cprov(6	)="Entre Rios"
cprov(7	)="Jujuy"
cprov(8	)="Mendoza"
cprov(9	)="La Rioja"
cprov(10)="Salta"
cprov(11)="San Juan"
cprov(12)="San Luis"
cprov(13)="Santa Fe"
cprov(14)="Santiago del Estero"
cprov(15)="Tucuman"
cprov(16)="XXX"
cprov(17)="Chaco"
cprov(18)="Chubut"
cprov(19)="Formosa"
cprov(20)="Misiones"
cprov(21)="Neuquen"
cprov(22)="La Pampa"
cprov(23)="Rio Negro"
cprov(24)="Santa Cruz"
cprov(25)="Tierra de Fuego"
cprov(26)=" "
For I =1 To 26
	If Upper(cprov(I))=Alltrim(lcProv)
		Exit
	Endif
Next I

nprov = Iif(I=27,0,I-1)
If noc < 0
	Return nprov
Else
	Return cprov(noc)
Endif
Function TipoDocumento(lnTipo)
Do Case
Case lnTipo = 1
	lcResu = 'LE' &&	Libreta de Enrolamiento
Case lnTipo = 2
	lcResu = 'LC' && 	Libreta cívica
Case lnTipo = 3
	lcResu = 'CI' &&	Cédula de identidad
Case lnTipo = 4
	lcResu = 'DI' && 	Documento Nacional de Identificación
Case lnTipo = 5
	lcResu = 'PA' &&	Pasaporte
Case lnTipo = 6
	lcResu = 'LM' &&	Libreta de Matrimonio
Case lnTipo = 7
	lcResu = 'LF' &&	Libreta Familiar
Case lnTipo = 9
	lcResu = 'OT' &&	Otros

Otherwise
	lcResu = "OT"

Endcase
Return lcResu
*--------------------------------------------------------------------------------------
