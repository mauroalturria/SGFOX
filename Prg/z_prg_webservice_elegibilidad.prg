Lparameters afiliado,tipoDocumento,numeroDocumento,codigoEntidad


* Para prueba
Do sp_conexion
afiliado = 20131656786009
tipoDocumento = 1
numeroDocumento = 131656789
codigoEntidad = 67
* -------------------------------------------
afiliado = 20251068100
tipoDocumento = 1
numeroDocumento = 25251068
codigoEntidad = 67
*--------------------------------------------

nafiliado = Transform(afiliado)
If Vartype(tipoDocumento)<>"N"
	ntipoDocumento = "1"
Else
	ntipoDocumento = Transform(tipoDocumento)
Endif

nnumeroDocumento = Transform(numeroDocumento)
ncodigoEntidad = Transform(codigoEntidad)

lcURL = "https://conectividadws.markey.com.ar/apiRest/validarElegibilidad"

fecha =Strtran(Left(prg_dtoc(sp_busco_fecha_serv("DD")),10),'-','')

TEXT To lcXML Textmerge Noshow Pretext 7
{
    "afiliado": "<<nafiliado>>",
    "tipoDocumento": <<ntipoDocumento>>,
    "numeroDocumento": "<<nnumeroDocumento>>",
    "codigoSeguridad": "",
    "tokenEmpresa": "7da37d1a-5a86-4fb5-90fa-45f02f3122f5",
    "tokenUsuario": "646ebbc5-0032-4aa9-b176-af24978e83cc",
    "fecha": "20230911",
    "codigoEntidad": "<<ncodigoEntidad>>",
    "usuario": "SG"
}
Endtext

Set Step On 

Local xmlHTTP As "Microsoft.XMLHTTP"
xmlHTTP = Createobject("Microsoft.XMLHTTP")
If Alltrim(Type("xmlHTTP")) <> "O"
	Messagebox( "No se pudo crear el objeto (XMLHTTP).",48,"Aviso")
	Return
Endif
xmlHTTP.Open("POST", lcURL, .T.)
xmlHTTP.setRequestHeader ("Content-Type", "application/json")
xmlHTTP.setRequestHeader ("token","70bdcaca-sdda-1664-h0cy-60684b51412a")

xmlHTTP.Send(lcXML)

Do While xmlHTTP.readyState<>4
	DoEvents
Enddo

lcResp = ""

lnServidor = xmlHTTP.Status

*!*	if !xmlHTTP.Status = 200
*!*		Messagebox('Tipo de Error: '+Alltrim(Str(xmlHTTP.Status)),48,'Problemas con el Servidor')
*!*	Else
*!*		If lnServidor = 200
*!*			lcResp = xmlHTTP.responseText
*!*			Strtofile(lcResp,"jsonresp.txt")
*!*		Endif
*!*	Endif

lcResp = xmlHTTP.responseText
Strtofile(lcResp,"jsonresp.txt")


Release xmlHTTP

*!*	If !Empty(lcResp)

	Create Cursor mwkjson (estado c(10),mensaje c(50),transaccion c(20),broker c(50),autoriza c(20),ntrans c(20))

	lcestado = json(lcResp,"estado",0)
	lcmensaje = json(lcResp,"mensaje",0)
	lctrans = json(lcResp,"transaccion",0)
	lcbroker = json(lcResp,"Broker",0)
	lctransaccion = json(lcResp,"NroTransaccion",0)
	lcautorizacion = json(lcResp,"NroAutorizacion",0)

	Insert Into mwkjson (estado,mensaje,transaccion,broker,autoriza,ntrans) Values (lcestado,lcmensaje,lctrans,lcbroker,lcautorizacion,lctransaccion)

*!*	Endif


*{"estado":"Ok","mensaje":"Transacción realizada con éxito","transaccion":"12820986","mensajeOriginal":

*{"Broker":"UTHGRA","CodigoOperacion":null,"Condicion":"G","FechaPreAutorizacion":null,"Mensaje":"Afiliado: LUIS ALBERTO ABALLAY - Nro Doc: 13165678","NroAutorizacion":"14092023163725","NroPreAutorizacion":null,"NroTransaccion":"12820986","Ok":true,"Prestaciones":[],"Ticket":""}}


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
