Lparameters xtipotoken,xcodent,xafiliado,xcantp,xtoken,xsuper,xeslabo,xnrodoc,lesprueba

*http://172.16.50.122/traditum/comunicador.php?destino=homi&funcion=
*		msjsolautori&IdAfiliado=040638800&Token=1234&IdRol=PS
*    &CantidadPrac=1&CodigoPractica1=17010107
*     &IdNomenclador1=1&CantPrestacionAutorizar1=1
*!*	CodigoPractica1=17010107&IdNomenclador1=1&CantPrestacionAutorizar1=1&
*!*	CodigoPractica2=................&IdNomenclador2=1&CantPrestacionAutorizar2=1&
*!*	CodigoPractica3=................&IdNomenclador3=1&CantPrestacionAutorizar3=1&
*!*	CodigoPractica4=................&IdNomenclador4=1&CantPrestacionAutorizar4=1&
If Vartype(lesprueba)<>"N"
	lesprueba = 0
Endif
If Vartype(xsuper)<>"N"
	xsuper = 0
Endif
If Vartype(xnrodoc)<>"N"
	xnrodoc = 1
Endif
If Vartype(xeslabo)<>"N"
	xeslabo = 0
Endif
mhoy = sp_busco_fecha_serv("DD")
If Transform(Val(Transform(xtoken)),"@L 9999") <>Alltrim(Transform(xtoken))
	Messagebox("INGRESE UN TOKEN VALIDO DE 4 DIGITOS",16,"Control de INgreso")
	Return .F.
Else
	xmtoken = xtoken
Endif
If xcantp=0
Use In Select('mwkjson')
	Create Cursor mwkjson (ok N(1), codprest N(9),nroautor N(10),estado c(200),autoriza c(200))
	Insert Into mwkjson (ok, codprest,nroautor,estado,autoriza) Values (1,0,VAL(xtoken),'APROBADO',''  )
	Return .T.
Endif
If myip='172.16.1.7'
	Set Step On
Endif
nitera = 0
csec=Iif(mwkexe.nomexe="GUARDIA","GUA",Iif( At('TURNOS',mwkexe.nomexe )>0,"AMB","INT"))
*https://servicios.sg.com.ar/interfaces/ajax/sg_valoriza_sap_srv.php?aplicacion=MK&codigoPractica=22010101&codigoEmpresa=948
codigoentidad = Alltrim(Transform(xcodent))
IdAfiliado = Padl(Alltrim(Transform(xafiliado)),9,'0')
Token = Transform(xmtoken)
cccod = xcodent
tkautoriza = ''
Use In Select('mwkjson')
Create Cursor mwkjson (ok N(1), codprest N(9),nroautor N(10),estado c(200),autoriza c(200))
Do sp_busco_estados With 10 , " and tipo = 3 and  estado = 1 ","mwktokenLOG"
Do sp_busco_estados With 57 , " and tipo = 23 and subestado = ?cccod ","mwktoken"
If mhoy =Ctod(ALLTRIM(mwktokenLOG.DESCRIP)) AND  mwktokenLOG.ESTADO = 1
	mRet = SQLExec(mcon1,"insert into Zabtraderr (TE_CodigoPractica,TE_IdAfiliado, TE_error, TE_sector,TE_token) "+;
		" values (?xnrodoc ,?xafiliado,'Inicia' ,?CSEC,?xmtoken  )")
Endif
Do While nitera <2
	lclink = Alltrim(mwktoken.Descrip)
	Do Case
	Case xtipotoken = 1 && funcion solo autoriza
		lclink =lclink + "msjsolautori"
	Endcase
	lclink = lclink + '&'+'IdAfiliado=' + IdAfiliado + '&'+'Token=' + Token
	ncantprac = xcantp
	lclink = lclink + '&'+'IdRol=' + 'PS' + '&'+'CantidadPrac=' + Alltrim(Transform(ncantprac))
	lclink = lclink + '&'+'TipAdmi='+Alltrim(csec)

	For xi = 1 To ncantprac
		codigopractica = Alltrim(Transform( token_prest(xi,1)))
		cantidadpresta = Alltrim(Transform( token_prest(xi,2)))
		lclink = lclink + '&'+'CodigoPractica'+Alltrim(Transform(xi))+'=' + codigopractica +;
			'&'+'IdNomenclador'+Alltrim(Transform(xi))+'=4' + ;
			'&'+'CantPrestacionAutorizar'+Alltrim(Transform(xi))+'='+cantidadpresta
	Next xi
	Local xmlHTTP As "Microsoft.XMLHTTP"
	xmlHTTP = Createobject("Microsoft.XMLHTTP")
	If Alltrim(Type("xmlHTTP")) <> "O"
		Messagebox( "No se pudo crear el objeto (XMLHTTP). ",48,"Aviso")
		mRet = SQLExec(mcon1,"insert into Zabtraderr (TE_CodigoPractica,TE_IdAfiliado, TE_error, TE_sector,TE_token) "+;
			" values (?xnrodoc ,?xafiliado,'No se pudo crear el objeto' ,?CSEC,?xmtoken  )")
		Return .T.
	Endif
	xmlHTTP.Open("GET", lclink)
	xmlHTTP.Send()
	Do While xmlHTTP.readyState<>4
		DoEvents
	Enddo
	lcresp = xmlHTTP.responseText

	lnServidor = xmlHTTP.Status

	Wait Clear
	codigopractica = Alltrim(Transform( token_prest(1,1)))
	ccadlink =Left(lclink ,250)
*	Set Step On
	If !xmlHTTP.Status = 200
		nstatus = Left(Transform(xmlHTTP.Status ),4)
		Messagebox('Tipo de Error: '+Alltrim(Str(xmlHTTP.Status)),48,'Problemas con el Servidor')
		ccadlink  = Left(nstatus +lclink  ,250)
		mRet = SQLExec(mcon1,"insert into Zabtraderr (TE_CodigoPractica,TE_IdAfiliado, TE_error, TE_sector,TE_token) "+;
			" values (?codigopractica ,?xafiliado,?ccadlink  ,?CSEC,?nstatus )")
	Else
		If !Vartype(lcresp)="C" Or Empty(lcresp)

			mRet = SQLExec(mcon1,"insert into Zabtraderr (TE_CodigoPractica,TE_IdAfiliado, TE_error, TE_sector,TE_token) "+;
				" values (?codigopractica ,?xafiliado,?ccadlink  ,?CSEC,'NoRt' )")
			lcresp = ""
		Else
			If Empty(lcresp)
				mRet = SQLExec(mcon1,"insert into Zabtraderr (TE_CodigoPractica,TE_IdAfiliado, TE_error, TE_sector,TE_token) "+;
					" values (?codigopractica ,?xafiliado,?ccadlink  ,?CSEC,'NoRt' )")
			Endif
		Endif
	Endif
	If myip='172.16.1.7' Or lesprueba=1
		Messagebox(lcresp)
		miniresp = Left(lcresp,250)
		mRet = SQLExec(mcon1,"insert into Zabtraderr (TE_CodigoPractica,TE_IdAfiliado, TE_error, TE_sector,TE_token) "+;
			" values (?xnrodoc ,?xafiliado, ?miniresp ,?CSEC,?xmtoken  )")
	Endif
	Strtofile(lcresp,"jsonresp.txt")
	If xsuper = 0
		If Val(Transform(xmtoken ))=0
			mRet = SQLExec(mcon1,"insert into Zabtraderr (TE_CodigoPractica,TE_IdAfiliado, TE_error, TE_sector,TE_token) "+;
				" values (?xnrodoc ,?xafiliado,'indica con autorizacion' ,?CSEC,?xmtoken  )")
		Endif
		Return .F.
		Exit
	Else
		codp = Alltrim(Transform( token_prest(1,1)))
		If At("NUMERO DE TOKEN INVALIDO",lcresp)>0 And nitera = 0 And  xeslabo= 1
			mRet = SQLExec(mcon1,"insert into Zabtraderr (TE_CodigoPractica,TE_IdAfiliado, TE_error, TE_sector,TE_token) "+;
				" values (?codp,?xafiliado,'Numero de Token invalido con Laboratorio' ,?CSEC,?Token )")
			Token = ''
			nitera = 1
		Else
			If At("NUMERO DE TOKEN INVALIDO",lcresp)>0   And  xeslabo= 0
				mRet = SQLExec(mcon1,"insert into Zabtraderr (TE_CodigoPractica,TE_IdAfiliado, TE_error, TE_sector,TE_token) "+;
					" values (?codp,?xafiliado,'Numero de Token invalido' ,?CSEC,?Token )")
			Endif
			nitera =2
			Exit
		Endif
	Endif
Enddo

If !Empty(lcresp)
	mnroitem = Alines(token_resp,lcresp)

	nitem = 1
	codp = Alltrim(Transform( token_prest(1,1)))
	tklin = Strtran(token_resp(1 ),"<BR>", "")
	If At("BIEN",tklin )=0 &&& no se ejecuto correctamente
		Messagebox("ERROR AL VALIDAR TRADITUM",16,"Control")
		clcresp= Left(lcresp,250)
		mRet = SQLExec(mcon1,"insert into Zabtraderr (TE_CodigoPractica,TE_IdAfiliado, TE_error, TE_sector,TE_token) "+;
			" values (?xnrodoc ,?xafiliado,?clcresp,?CSEC,?xmtoken  )")
		miniresp = Left(lcresp,250)
		mRet = SQLExec(mcon1,"insert into Zabtraderr (TE_CodigoPractica,TE_IdAfiliado, TE_error, TE_sector,TE_token) "+;
			" values (?codp ,?xafiliado, ?miniresp ,?CSEC,?xmtoken  )")
	Else
		tklin = Strtran(token_resp(2),"<BR>", "")
		tknroautor = Int(Val(Substr(tklin,At("=", tklin) +1)))
		tklin = Strtran(token_resp(3),"<BR>", "")
		tkestado  = Substr(tklin,At(",", tklin) +1)
		tkok = Iif(At('APROBADO',tkestado)>0,1,0)
		xind = 1
		Do While At('PRT=',token_resp(xind))=0 And xind<mnroitem
			xind =xind +1
*!*				If xind =100
*!*					Messagebox("ERROR AL VALIDAR TRADITUM",16,"Control")
*!*					Return .T.
*!*				Endif
		Enddo

		For xi = xind  To mnroitem
			tklin =  Strtran(token_resp(xi),"<BR>", "")
			tkcodprest =  Val(json(tklin ,'PRT',0))
			cestado = '0'
			If tkcodprest >0
				tkautoriza = json(tklin ,'Est',0)
				tkaut = json(tklin ,'PRTAUT',0)
				cestado= Iif(tkautoriza = '0',tkestado ,tkautoriza )
			Endif
			tkok = Iif(At('APROBADO',tkautoriza )>0,1,0)
			Insert Into mwkjson (ok, codprest,nroautor,estado,autoriza) Values (tkok,tkcodprest,tknroautor,tkestado,tkautoriza  )
			If At('APROBADO',tkautoriza )=0
				mRet = SQLExec(mcon1,"insert into Zabtraderr (TE_CodigoPractica,TE_IdAfiliado, TE_error, TE_sector,TE_token) "+;
					" values (?tkcodprest,?xafiliado,?cestado,?CSEC,?Token )")
			Endif
		Next xi
	Endif
Endif
Select mwkjson
Go Top
Release xmlHTTP
If mhoy =Ctod(ALLTRIM(mwktokenLOG.DESCRIP)) AND  mwktokenLOG.ESTADO = 1 And Val(Transform(xmtoken ))=0
	mRet = SQLExec(mcon1,"insert into Zabtraderr (TE_CodigoPractica,TE_IdAfiliado, TE_error, TE_sector,TE_token) "+;
		" values (?tkcodprest,?xafiliado,?cestado,?CSEC,?xeslabo )")
Endif
Return .T.
Function json(texto,clave,comillas)
lcjson = texto
lcjsonclave = Alltrim(clave)+'='
lcjson = Substr(lcjson, At(lcjsonclave,lcjson))
lninicio = At(lcjsonclave,lcjson)+Len(lcjsonclave)
lfin = At("=",lcjson,2)
lcstring = Substr(lcjson,lninicio,lfin-lninicio )
lextra = Rat(",",lcstring)
lcstring = Strtran(Left(lcstring,lextra-1),"<BR>", "")
Return lcstring
Endfunc





