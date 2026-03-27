Lparameters idturnobp

* Set Step On

Set Proc To json Additive && Usar el prg de json

* prg_bp_devolucion - 2022/06/28
* modificación de links / ajuste de parametrización json - 2022/07/12

* - - - Para Prueba - - -
*idturnobp =    19589749
*Do sp_conexion
*Set Step On
* - - - - - - - - - - - - - - - - 

lidturnobp = idturnobp

mccon = ''
mccon = Left(SQLGetprop(mcon1,'ConnectString'),80)

Do Case
Case  (".190" $ mccon) && Desarrollo 190
	lclink = "https://desa.sg.com.ar/ws-osana/sg-curlbp.php?v1="
Case  (".50.110" $ mccon) && Desarrollo 50.110
	lclink = "https://desa.sg.com.ar/ws-osana/dev_turno-srv.php?idturno="
Case  (".50.102" $ mccon) && QAS 50.102
	lclink = "https://serviciosqas.sg.com.ar/ws-osana/dev_turno-srv.php?idturno="
Otherwise  && Producción
	lclink = "https://servicios.sg.com.ar/ws-osana/dev_turno-srv.php?idturno="
Endcase

lclink = lclink + Alltrim(Transform(lidturnobp))+"&ambito="+Alltrim(Transform(mxambito))

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
lcResp = xmlHTTP.responseText

Strtofile(lcResp,'bptxt.txt')

lcResp = Strtran(lcResp,"[","")
lcResp = Strtran(lcResp,"]","")

objson = json_decode(lcResp)
If Not Empty(json_getErrorMsg())
	lcmsg =  'Error in decode:'+json_getErrorMsg()
	Messagebox(lcmsg,16,"Aviso")
Endif
lcResp = objson.Get('message')

lnServidor = xmlHTTP.Status

lerror = .F.

If !xmlHTTP.Status = 200
	Messagebox('Tipo de Error: '+Alltrim(Str(xmlHTTP.Status)),48,'Problemas con el Servidor')
Else
	If !Vartype(lcResp)="C"
		lcResp = "ERROR BORRAR"
	Endif
	If 'ERROR' $ Upper(lcResp)
		lerror = .T.
	Endif
	Messagebox(lcResp,64,'Aviso - Devolución de Pago')
Endif

Release xmlHTTP