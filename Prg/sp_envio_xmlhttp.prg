*** Marcelo Torres, 06/05/2025
*** Recibe como parametros :
*** la url del servicio
*** el json
*** titulo de la tarea
*** Devuelve un array en el caso de que reciba datos del servicio.

Lparameters cUrl,cJson, cTarea

Local xmlHTTP
Local lOk
Local lnServidor
Local lcResp
Local lcError
Local oDatos
Local lResultado
Local aDatos

* Set Step On

xmlHTTP = ""
lcResp = ""
lcError = ""
cTarea = Iif(Vartype(cTarea) <> "C", "Servicio",cTarea)
aDatos = Null

prg_crea_xmlhttp(@xmlHTTP)

lOk = Vartype(xmlHTTP) = "O"

If lOk

	xmlHTTP.Open("POST", cUrl, .F.)
	xmlHTTP.setRequestHeader ("Content-Type", "application/json;charset=utf-8")

	xmlHTTP.Send(cJson)

	Do While xmlHTTP.readyState<>4
		DoEvents
	Enddo

	lnServidor = xmlHTTP.Status

	Wait Clear

* Create Cursor mwkprestaciones (prestacion c(50))

	If !(lnServidor = 200)
		Messagebox('Problemas con el Servidor Local.'+Chr(10)+'Status : '+Transform(lnServidor),48,"Informe " + cTarea)
		lOk = .F.
		Do Log_errores With Error(), "Error respuesta del Servicio " + cTarea, "Status " + Transform(lnServidor), Program(), 0
	Else

		If lnServidor = 200

			lcResp = xmlHTTP.responseText

			lcError = ""

			Wait "PARSEANDO JSON A TABLA DE DATOS, AGUARDE ..." Window Nowait

			If Empty(lcResp)  && respuesta en blanco

				Do Log_errores With Error(), oDatos._Mensaje, "Respuesta en blanco. Posible error de servidor. "+ cTarea, Program(), 0

			ELSE
			
				oJson = Newobject('json','json.prg')
				oDatos = oJson.decode(lcResp)

*SET STEP ON

				If !Empty(oJson.cError)
					Messagebox(oJson.cError + Chr(10)+ "Se generó el archivo : " + Chr(10) +"c:\temp\erroremailinvest.log",16,"Email " + cTarea )

					Do Log_errores With Error(), oJson.cError, "Error Parser. "+ cTarea, Program(), 0

					Strtofile(lcResp,"c:\temp\erroremailinvest.log")
				Else

					If oDatos._Estado = "ERROR"
						Messagebox(oDatos._Mensaje, "Email " + cTarea )
						Do Log_errores With Error(), oDatos._Mensaje, "Error en la salida de email. "+ cTarea, Program(), 0
					Else

						If Type("oDatos.Array") = "A"
							aDatos = oDatos.Array
						Endif

					Endif
				Endif

			Endif

		Endif

	Endif


Else

	Messagebox("No se pudo crear el objeto HTTP.",16,"Email " + cTarea)
	Do Log_errores With Error(), "No se pudo crear el objeto HTTP", "Error HTTP. "+ cTarea, Program(), 0

Endif

xmlHTTP = Null
oJson = Null
oDatos = Null

Return aDatos
