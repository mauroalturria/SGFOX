*
* Llamador CPC - B4Code / Ej.: Do c:\desaguemes\Prg\sp_insert_llamacpc With 10, 710845, 6620, 'DERM' 
*
Parameters lconsultorio, lregistra, lmedico, lespecialidad

*https://serviciosdev.sg.com.ar/llamador-cpc/medico/sg_llamacpc_medico.php?consultorio=41&piso=4P&paciente=3717277&medico=3066&especialidad=OBST&tipo=I&idreg=0

lconsultorio = "4P"
lregistra =  3717277
lmedico =  3066
lespecialidad = "OBST"


	Local xmlHTTP, lclink, lnServidor, lcResp

	Set Step On

	xmlHTTP = Createobject("Microsoft.XMLHTTP")

	If Vartype(xmlHTTP) <> "O"
		Messagebox("No se pudo crear el objeto (XMLHTTP) - NOMBRE DEL EJECUTABLE.", 48, "Aviso")
		Return
	Endif

	lclink = ;
    "https://serviciosdev.sg.com.ar/llamador-cpc/medico/sg_llamacpc_medico.php?consultorio=" + ;
    ALLTRIM(TRANSFORM(m.lconsultorio)) + ;
    "&paciente=" + ALLTRIM(TRANSFORM(m.lregistra)) + ;
    "&medico="   + ALLTRIM(TRANSFORM(m.lmedico)) + ;
    "&especialidad="+ALLTRIM(m.lespecialidad)

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

		Messagebox( ;
			"Tipo de Error HTTP: " + Alltrim(Str(lnServidor)) + Chr(13) + ;
			IIF(!Empty(lcResp), "Respuesta del servidor:" + Chr(13) + lcResp, ""), ;
			48, ;
			"NOMBRE DEL EJECUTABLE - Problemas con el servidor" ;
			)
	Else
		lcResp = ""
		Try
			lcResp = xmlHTTP.responseText
		Catch
			lcResp = ""
		Endtry

		If "ok" $ lcResp And '"ok":true' $ lcResp
			Messagebox( ;
				"Estimado profesional, se acaba de realizar la llamada al paciente.", ;
				64, ;
				"REGISTRO" ;
				)
		Else

			Messagebox( ;
				"La llamada se realizó, pero la respuesta no es la esperada:" + Chr(13) + lcResp, ;
				48, ;
				"REGISTRO" ;
				)
		Endif
	Endif

Release xmlHTTP
Return