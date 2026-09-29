Parameters valor

valor = '3749316-9'

Set Step On

* * * ENVIO DE MAIL DE EPICRISIS - Fabián * * *
* Esto modifica a prg_envio_mail_epicrisis que había realizado en su momento.
* Historial:
* 2021-12-14 = Envio mail de epicrisis al paciente
* 2022-10-12 = Modificaciòn de texto
* 2026-09-28 = Nueva versión de envío de mail dado que estaba obsoleto en visual. El archivo original queda como backup

If Vartype(valor) <> "C" Or Empty(Alltrim(valor))
	Return
Endif

Do sp_busco_estados With 57,' and tipo = 100 ','mwklinkepi'

If mwklinkepi.estado = 0
	Return
Endif

url = Alltrim(mwklinkepi.Descrip)

lcparametros = "?hc="+Alltrim(valor)+"&tipo=epi"

lclink = Alltrim(url)+lcparametros

Wait "ENVIANDO MAIL DE EPICRISIS - AGUARDE POR FAVOR" Window Nowait Noclear

Local xmlHTTP As "Microsoft.XMLHTTP"

xmlHTTP = Createobject("Microsoft.XMLHTTP")

If Alltrim(Type("xmlHTTP")) <> "O"
	Messagebox( "No se pudo crear el objeto (XMLHTTP). No se pudo enviar la guía.",48,"Aviso")
	Return
Endif

xmlHTTP.Open("GET", lclink)

xmlHTTP.Send()

Do While xmlHTTP.readyState<>4
	DoEvents
Enddo

lnServidor = xmlHTTP.Status
lcResu = xmlHTTP.responseText

If xmlHTTP.Status = 200
	Messagebox('El mensaje de Epicrisis al paciente fue enviado con éxito.' ,64,'Aviso')
Else
	Messagebox('No se pudo enviar mensaje de Epicrisis al paciente. Error HTTP ' + Transform(lnServidor),64,'Aviso')
Endif

Release xmlHTTP

Use In Select('mwklinkepi')

Wait Clear
