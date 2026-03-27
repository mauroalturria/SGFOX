Lparameters cnroregis, cCodPrest, cCodEnt, cCodEstado,fechactrl,cproto

cnroregis= Transform(cnroregis)
cCodPrest= Transform(cCodPrest)
cCodEnt= Transform(cCodEnt)
cCodEstado= Transform(cCodEstado)
ncodestado = Val(cCodEstado)
mactproto ="  "
mwprest  = ''
If myip = '172.16.1.7'
	Set Step On
Endif
If !Empty(cproto)
	mactproto =", protocolo=?cproto,fechahoraate = currENT_timestamp "
ENDIF
If !Empty(cCodPrest)
	mwprest =" and  CodPrest =?cCodPrest "
ENDIF
mret = SQLExec(mcon1, "select * from Zabguardiadom  "+;
	" WHERE  nroregistrac = "+cnroregis+mwprest+" and not codestado in (7, 9 ) ","mwkexisteGA") 
If mret < 0
	Messagebox('ERROR EN LA BUSQUEDA, REINTENTE',16,'Validacion')
ENDIF
SELECT id FROM  mwkexisteGA WHERE fechahoraing >= fechactrl ORDER BY fechahoraing INTO CURSOR mwkbusca
SELECT mwkbusca
mid = mwkbusca.id
mret = SQLExec(mcon1, "update Zabguardiadom  SET codestado = ?ncodestado "+mactproto +;
	" WHERE  id = ?mid ")  &&omite los dados de baja y los desiste 
If mret < 0
	Messagebox('ERROR EN LA GENERACION DEL CURSOR, REINTENTE',16,'Validacion')
Endif

Do sp_busco_estados With 57,' and tipo = 29 ','mwkpregua'&&
If mwkpregua.estado=1
*lcURL = "desa.sg.com.ar/api/sanatorio/pre-admision/notifica/"
	lcURL= Alltrim(mwkpregua.Descrip)

	TEXT To lcXML Textmerge Noshow Pretext 7
{
    "AppGuid": "OSANA",
    "NroReg": <<cnroregis>>,
    "CodPrest": <<cCodPrest>>,
    "CodEnt":  <<cCodEnt>>,
    "CodEstado":  <<cCodEstado>>
 }
	ENDTEXT

	Local xmlHTTP As "Microsoft.XMLHTTP"
	xmlHTTP = Createobject("Microsoft.XMLHTTP")
	If Alltrim(Type("xmlHTTP")) <> "O"
		Messagebox( "No se pudo crear el objeto (XMLHTTP).",48,"Aviso")
		Return
	Endif
	xmlHTTP.Open("POST", lcURL, .T.)
	xmlHTTP.setRequestHeader ("Content-Type", "text/xml;charset=utf-8")
	xmlHTTP.setRequestHeader ("Authorization","94ecbc1edeee37aaef258dd36bed9888")
	xmlHTTP.Open("POST", lcURL , .F.)

	xmlHTTP.Send(lcXML)

	Do While xmlHTTP.readyState<>4
		DoEvents
	Enddo

	lnServidor = xmlHTTP.Status

*!*	If !xmlHTTP.Status = 200
*!*		Messagebox('Tipo de Error: '+Alltrim(Str(xmlHTTP.Status)),48,'Problemas con el Servidor')
*!*	Else
*!*		If lnServidor = 200
	lcResp = xmlHTTP.responseText
	Strtofile(lcResp,"jsonresp.txt")
*!*		Endif
*!*	Endif
	If mwkusuario.sector = 'SISTEMAS'
		Messagebox("Respuesta:"+Chr(10)+Alltrim(lcresp))
	Endif
	Release xmlHTTP
	Wait Clear
	If !Empty(lcResp)
		Create Cursor mwkjson (estado c(10),mensaje c(50),transaccion c(20),broker c(50),autoriza c(20),ntrans c(20))

		lcestado = json(lcResp,"estado",0)
		lcmensaje = json(lcResp,"mensaje",0)
		lctrans = json(lcResp,"transaccion",0)
		lcbroker = json(lcResp,"Broker",0)
		lctransaccion = json(lcResp,"NroTransaccion",0)
		lcautorizacion = json(lcResp,"NroAutorizacion",0)

		Insert Into mwkjson (estado,mensaje,transaccion,broker,autoriza,ntrans) Values (lcestado,lcmensaje,lctrans,lcbroker,lcautorizacion,lctransaccion)

*{"estado":"Ok","mensaje":"Transacción realizada con éxito","transaccion":"12820986","mensajeOriginal":

*{"Broker":"UTHGRA","CodigoOperacion":null,"Condicion":"G","FechaPreAutorizacion":null,"Mensaje":"Afiliado: LUIS ALBERTO ABALLAY - Nro Doc: 13165678","NroAutorizacion":"14092023163725","NroPreAutorizacion":null,"NroTransaccion":"12820986","Ok":true,"Prestaciones":[],"Ticket":""}}
	Endif
Endif
Function json(texto,clave,comillas)
lcjson = texto
lcjsonclave = '"'+Alltrim(clave)+'":'
lninicio = At(lcjsonclave,lcjson)
lcstring = Substr(lcjson,lninicio,Len(lcjson)-lninicio)
lextra = At(":",lcstring)
lcstring = Substr(lcstring,lextra+1,Len(lcstring)-lextra)
lcstring = Strextract(lcstring,'"','"')
Return lcstring
Endfunc
