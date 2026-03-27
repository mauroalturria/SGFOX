*
* Llamador CPC - B4Code / Ej.: Do c:\desaguemes\Prg\sp_insert_llamacpc With 10, 710845, 6620, 'DERM'
*
Parameters lconsultorio, lregistra, lmedico, lespecialidad, lpiso

Local xmlHTTP, lclink, lnServidor, lcResp
If  Vartype(lpiso)<>"C"
	lpiso = ""
Endif

xmlHTTP = Createobject("Microsoft.XMLHTTP")

If Vartype(xmlHTTP) <> "O"
	Messagebox("No se pudo crear el objeto (XMLHTTP) - NOMBRE DEL EJECUTABLE.", 48, "Aviso")
	Return
Endif

lcFechaHora = Strtran(Dtoc(Date()),"/","") +Strtran(Time(),":","")  &&& no usamos la hora de la PC

lcFechaHora =Chrtran(Ttoc(sp_busco_fecha_serv("DT")),"/: ","")

Do sp_busco_estados With 57,' and tipo = 91 ','mwkllamaCPC'&&   
*https://serviciosdev.sg.com.ar/llamador-cpc/medico/sg_llamacpc_medico.php
If mwkllamaCPC.estado = 1
	lclink = Alltrim(mwkllamaCPC.Descrip)
	lclink = lclink +"?consultorio=" + Alltrim(Transform(m.lconsultorio)) + ;
		"&paciente=" + Alltrim(Transform(m.lregistra)) + ;
		"&medico="   + Alltrim(Transform(m.lmedico)) + ;
		"&especialidad="+Alltrim(m.lespecialidad) + ;
		"&piso="+Alltrim(m.lpiso) + ;
		"&nocache="+lcFechaHora

	xmlHTTP.Open("GET", lclink, .F.)
	xmlHTTP.Send()

	lnServidor = xmlHTTP.Status

	If lnServidor <> 200
		lcResp = ""
		Try
			lcResp = xmlHTTP.responseText
		Catch
			lcResp = ""
		Endtry

		Messagebox( "Tipo de Error HTTP: " + Alltrim(Str(lnServidor)) + Chr(13) + ;
			IIF(!Empty(lcResp), "Respuesta del servidor:" + Chr(13) + lcResp, ""), 	48, "NOMBRE DEL EJECUTABLE - Problemas con el servidor" )
	Else
		lcResp = ""
		Try
			lcResp = xmlHTTP.responseText
		Catch
			lcResp = ""
		Endtry

		If "ok" $ lcResp And '"ok":true' $ lcResp
			Messagebox("Estimado profesional, se acaba de realizar la llamada al paciente.", 64,"REGISTRO" )
		Else

			Messagebox(	"La llamada se realizó, pero la respuesta no es la esperada:" + Chr(13) + lcResp, 48,"REGISTRO" )
		Endif
	Endif
Endif
Release xmlHTTP
Return
