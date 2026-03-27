LPARAMETERS cnroregis,cconsu
cnroregis = Transform(cnroregis)
 
lcUcnroregisRL = "https://sg-impl-api-ext.pic.osanasalud.com/ext/webhook/sg"

entidad = "PreadmisionLlamador"
nroReg = cnroregis 
consultorio = cconsu


*!*	{
*!*	    "entidad": "PreadmisionLlamador",
*!*	    "nroReg": 4068569,
*!*	    "consultorio": "1er ss cons45"
*!*	}


lcXML = '{"entidad": "PreadmisionLlamador","nroReg": '+Alltrim(transform(nroReg))+',"consultorio": "'+consultorio+'"}'


*!*	TEXT To lcXML Textmerge Noshow Pretext 7
*!*	        {
*!*	            "entidad ": <<entidad>>,
*!*	            "nroReg ": "<<nroReg>>",
*!*	            "consultorio ": "<<consultorio>>",
*!*	        }
*!*	ENDTEXT


Local xmlHTTP As "Microsoft.XMLHTTP"
xmlHTTP = Createobject("Microsoft.XMLHTTP")

If Alltrim(Type("xmlHTTP")) <> "O"
	Messagebox( "No se pudo crear el objeto (XMLHTTP).",48,"Aviso")
	Return
Endif

xmlHTTP.Open("POST", lcUcnroregisRL , .F.)

xmlHTTP.setRequestHeader ("Content-Type", "text/xml;charset=utf-8")

*xmlHTTP.setRequestHeader ("Authorization","94ecbc1edeee37aaef258dd36bed9888")

xmlHTTP.Send(lcXML)

Do While xmlHTTP.readyState<>4
	DoEvents
Enddo

lnServidor = xmlHTTP.Status

If !xmlHTTP.Status = 200
	Messagebox('Tipo de Error: '+Alltrim(Str(xmlHTTP.Status)), 48, 'Problemas con el Servidor')
Else
	If lnServidor = 200
		lcResp = xmlHTTP.responseText
 	Endif
Endif

Release xmlHTTP
 