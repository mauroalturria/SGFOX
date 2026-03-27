Parameters tnRegi, tnTipo

Local loHTTP
Local lbResu
lbResu=.T.
Do sp_busco_estados With 7, " and tipo = 55 ", "mwkmailenc"
*Endif
Go Top In mwkmailenc
mstringcon = mwkmailenc.Descrip
If mwkmailenc.estado = 1
	lcUrl = Alltrim(mstringcon )+"/online/encuestasat/envio.php?MREGI=" + Transform(tnRegi) + "&MTIPO=" + Transform(tnTipo)

&& PRUEBA GUSTAVO
*!*	lcUrl = "http://172.16.1.200:8060/online/encuestasat/envio.php?MREGI=1334166&MTIPO=1"

	loHTTP = Createobject("WinHttp.WinHttpRequest.5.1")
	loHTTP.Open("GET", lcUrl , .F.)
	loHTTP.Send()
	lbResu = Empty(loHTTP.ResponseText)

	loHTTP = Null
	Release loHTTP
Endif
Return lbResu

