Lparameters mama

* 2023-03-09 Registración MMBB
* Se habilita desde FrmQuiro28 -> TabEstados - Prop 57 Tipo 4

lcmama = mama
lsigo = .T.

lnconx = ''
lnconx = Left(SQLGetprop(mcon1,'ConnectString'),80)


Do Case
Case  (".190" $ lnconx) && Desarrollo 190
	lcURL = "https://desa.sg.com.ar/api/sanatorio/mama-bebe/record"
Case  (".50.110" $ lnconx) && Desarrollo 50.110
	lcURL = "https://desa.sg.com.ar/api/sanatorio/mama-bebe/record"
Case  (".50.102" $ lnconx) && QAS 50.102
	lcURL = "https://desa.sg.com.ar/api/sanatorio/mama-bebe/record"
Otherwise  && Producción
	lcURL = "https://servicios.sg.com.ar/api/sanatorio/mama-bebe/record"
Endcase

lcsql = "select PAC_codhci from PACIENTES where PAC_codadmision = ?lcmama"
SQLExec(mcon1,lcsql,'mwkmama')

lnregmama = mwkmama.PAC_codhci

lcXML = ""

Create Cursor mwkhijos (registracion N)

If Used('mwkrelregg')

	Select mwkrelregg

	Scan All
		lchijo = Alltrim(mwkrelregg.Trr_admdest)
		lcsql = "select PAC_codhci from PACIENTES where PAC_codadmision = ?lchijo"
		SQLExec(mcon1,lcsql,'mwkfilio')
		Insert Into mwkhijos(registracion)Values(mwkfilio.PAC_codhci)
		Select mwkrelregg
	Endscan

Else
	lsigo = .F.
Endif

If !lsigo
	Return 0
Endif


TEXT To lcXML Textmerge Noshow Pretext 7
{"AppGuid": "MK","NroRegistracionMadre": <<lnregmama>>,"Hijos": [
ENDTEXT

lclineafinal = ""
lncantpresa = 0
Select mwkhijos
If Reccount('mwkhijos')>0
	Scan All
		lncantpresa = lncantpresa + 1
		lclinea = '{"NroRegistracion":' + Alltrim(Str(mwkhijos.registracion)) + ' },'
		lclineafinal = lclineafinal + lclinea
	Endscan
	lccierre = Left(lclineafinal,Len(lclineafinal)-1) +']'
Else
	lccierre = '"" '
Endif

lcXML = lcXML + lccierre + '}'

Strtofile(lcXML,'mamabebe.txt')

fechahoraini = sp_busco_fecha_serv("DT")
fecha = Ttod(fechahoraini)

Wait "Comunicando Registración. Aguarde por favor." Window Nowait Noclear

Local xmlHTTP As "Microsoft.XMLHTTP"
xmlHTTP = Createobject("Microsoft.XMLHTTP")
If Alltrim(Type("xmlHTTP")) <> "O"
	Messagebox( "No se pudo crear el objeto (XMLHTTP). No se pudo enviar la guía.",48,"Aviso")
	Return
Endif
xmlHTTP.Open("POST", lcURL, .F.)
xmlHTTP.setRequestHeader ("Content-Type", "text/xml;charset=utf-8")
xmlHTTP.setRequestHeader ("Authorization","94ecbc1edeee37aaef258dd36bed9888")

xmlHTTP.Send(lcXML) && Si lo paso así va al Body
Do While xmlHTTP.readyState<>4
	DoEvents
Enddo

lnServidor = xmlHTTP.Status

Wait Clear

If !xmlHTTP.Status = 200
	Messagebox('Tipo de Error: '+Alltrim(Str(xmlHTTP.Status)),48,'Problemas con el Servidor')
Else
	If lnServidor = 200
		lcResp = xmlHTTP.responseText
		Strtofile(lcResp,"jsonresp.txt")
		If json(lcResp,'Estado') = 'ERROR'
			lerror = json(lcResp,'Mensaje')
			Messagebox(lerror,16,'AVISO')
		Else
* OK - Puedo grabar en la tabla ERROR u OK
		Endif
	Endif
Endif

fechahorafin = sp_busco_fecha_serv("DT")
If Vartype(lcResp)<>"C"
	lcResp = "error"
Endif
* Grabo Log
lcsql = ""
lcsql = "INSERT INTO SQLUser.zablogmmbb"+;
	"(LMB_admisionmadre, LMB_envio, LMB_estado, LMB_fecha, LMB_fechorafin, LMB_fechoraini, LMB_registracionmadre, LMB_respuesta)"+;
	"VALUES( ?lcmama, ?lcXML, ?lnServidor, ?fecha,?fechahorafin,?fechahoraini, ?lnregmama, ?lcResp)"
mret = SQLExec(mcon1,lcsql)
If mret < 0
	Messagebox("Error en la grabación de Log",16,"Registración Mamá - Bebé")
Endif


Release xmlHTTP



Function json(texto,clave)
lcjson = texto
lcjsonclave = '"'+Alltrim(clave)+'":'
lninicio = At(lcjsonclave,lcjson)
lcstring = Substr(lcjson,lninicio,Len(lcjson)-lninicio)
lextra = At(":",lcstring)
lcstring = Substr(lcstring,lextra+1,Len(lcstring)-lextra)
lcstring = Strextract(lcstring,'"','"')
Return lcstring
Endfunc
