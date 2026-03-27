Parameters lnCodVale, tcname 
*!*	mwkvalpro.val_codvaleasist

If Parameters() = 0
	lnCodVale = 55780437
	Return .f.
Endif 

If Vartype(tcname)!="C"
	tcname = ""
Endif 

Set Procedure To "c:\desaguemes\Prg\json.prg" Additive 


*!*	"https://online.sg.com.ar/intranet/lanzador/prog/winf/ajax/"

Do sp_busco_estados With 57, " and tipo = 32 ", "mwkteurl"



If !Used("mwkteurl")
	Return .f.
Endif 

If Reccount("mwkteurl")	= 0
	Return .f.
Endif 	

lcurlbase = ""

Select mwkteurl
lcurlbase = Alltrim(mwkteurl.descrip)

Use In Select("mwkteurl")


lclink = lcurlbase + "geturlpacs.php?nrovale=" + Alltrim(Str(lnCodVale,16,0)) + "&donde=" + tcname


Local xmlHTTP As "Microsoft.XMLHTTP"
lcresp = "" 

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
lcresp = xmlHTTP.responseText

lnServidor = xmlHTTP.Status

Wait Clear


If !xmlHTTP.Status = 200
	Messagebox('Tipo de Error: '+Alltrim(Str(xmlHTTP.Status)),48,'Problemas con el Servidor')
Else
	If !Vartype(lcresp)="C"
		lcresp = ""
	Endif
Endif

If !Empty(lcResp)

	objson = json_decode(lcResp)

	If Not Empty(json_getErrorMsg())
		lcmsg =  'Error in decode:'+json_getErrorMsg()
		Messagebox(lcmsg,16,"Aviso")
		Return .f.
	Endif

	lcEstado = objson.Get('Estado')
	lcMensaje = objson.Get('Mensaje')
	
	If lcEstado = "OK"
		If prg_veo_url(lcMensaje)
			Return .f.
		Endif  
	Else
		Messagebox(lcMensaje,16,"Aviso")
		Return .f.
	Endif 

*!*		?lcEstado
*!*		?lcMensaje 
	
Endif 	