Parameters tcPin, tcMsg, tcTipo

If Vartype(tcTipo)<>"C"
	tcTipo = "1"
Endif 


If !PRG_MODO_EXE()
	lcPin = "5993060"
	lcMsg = "Hola3 " + Ttoc(Datetime())
	lcTipo = "1"
Else
	lcPin = tcPin
	lcMsg = tcMsg
	lcTipo = tcTipo
Endif 

lcIp0 = '201.251.101.133'
If !Envio(lcIp0)
	lcIp1 = '201.216.254.189'
	If !Envio(lcIp1)
		Return .f.
	Endif 
Endif 	

*!*------------------------------------------------------------------------------------------------------------------------------
Function Envio
Parameters tcIp
*!*------------------------------------------------------------------------------------------------------------------------------


lcUrl = "http://" 
lcUrl = lcUrl + tcIp
lcUrl = lcUrl + "/beeperremoto4/beeperremoto3.0.asp?PIN="
lcUrl = lcUrl + lcPin
lcUrl = lcUrl + "&MENSAJE=" 
lcUrl = lcUrl + lcMsg
lcUrl = lcUrl + "&Tipo=" 
lcUrl = lcUrl + lcTipo 

Public loHTTP
loHTTP = CREATEOBJECT("WinHttp.WinHttpRequest.5.1")    
loHTTP.Open("POST", lcUrl , .F.)
loHTTP.Send()
lcDat = Strtran(Strtran(loHTTP.ResponseText,Chr(13),""),Chr(10),"")

lnPosIni = At("<BODY>",lcDat) + 6
lnPosFin = At("</BODY>",lcDat) - lnPosIni

Return (Int(Val(Substr(lcDat,lnPosIni, lnPosFin))) = 0)

*!*	?"------------"
*!*	?loHTTP.ResponseText