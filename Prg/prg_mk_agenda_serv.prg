Lparameters xfdesde,xconsul,xcuil ,xserv
If myip='172.16.1.7'
*	Set Step On
Endif
*https://serviciosqas.sg.com.ar/interfaces/markey_obtsalaespimg.php
*    ?fecha=2026-01-09&consultorio=&profesional=23-33075564-4&servicio=
Do sp_busco_estados With 57,' and tipo = 92 and subestado = ?mxcentromedico ','mwkAgendaMK'&&

If mwkAgendaMK.estado = 1
	lclink = Alltrim(mwkAgendaMK.Descrip)
	lclink = lclink + '?fecha=' + Alltrim(xfdesde) + '&'+'consultorio=' + Transform(xconsul)
	lclink = lclink + '&'+'profesional=' + Alltrim(xcuil ) + '&'+'servicio=' + Transform(xserv)

	Local oHttp, cUrl, cResponse

	Try
		oHttp = Createobject("WinHttp.WinHttpRequest.5.1")
	Catch To loError
		Messagebox("No se pudo crear el objeto WinHttp. Error: " + loError.Message)
		Return
	Endtry

	cUrl = lclink

	Try
		cUrl = lclink &&* agrega un query param único para evitar caché
		cUrl = cUrl + Iif("?" $ cUrl, "&", "?") + "_ts=" + Ttoc(Datetime(),1)
		oHttp.Open("GET", cUrl, .F.)
		oHttp.SetRequestHeader("Accept", "application/json")
		oHttp.SetRequestHeader("Cache-Control", "no-cache")
		oHttp.SetRequestHeader("Pragma", "no-cache")
		oHttp.SetRequestHeader("If-Modified-Since", "Sat, 01 Jan 2000 00:00:00 GMT")
		oHttp.Send()
	Catch To loError
		Messagebox("Error al enviar la solicitud: " + loError.Message)
		Return
	Endtry

	If oHttp.Status = 200
		cResponse = oHttp.ResponseText
		lcresp = cResponse
	Else
		lcresp = Transform(oHttp.Status)
	Endif
	Strtofile(lcresp,"jsonresp.txt")
	If mwkusuario.sector = 'SISTEMAS'
		Messagebox("Respuesta:"+Chr(10)+Alltrim(lcresp))
	Endif
	Release oHttp
	Wait Clear
	If !Empty(lcresp)
		Create Cursor mwkjson (MedicoCodigo c(13),mediCodigoInterno  c(13),Medico c(50),turnCodigoInterno c(30);
			,turnCodigo N(12),turnFecha D,consCodigoInterno c(20);
			,turnFechaInicio T,turnFechaFin T,turnLlegada T,paciCodigo N(10),paciCodigoInterno N(10);
			,paciHistoriaClinica c(10),paciPaciente c(50),paciNroDocumento N(15); &&,mediCodigoInterno N(5)
			,mediCodigo N(5),mediMedico c(50),cobeDescripcion c(50),planDescripcion c(50),cobeCodigoInterno N(5);
			,planCodigoInterno N(5),turnCodigoAdmision c(50),turnCodigoVale c(50),turnPrioridad c(50);
			,turnSobreTurno L,turnEspontaneo L,tuprCodigo N(10),procCodigoInterno N(10),procDescripcion c(50);
			,procVirtual L,turnSeRetira T ,turnReemplazo L,mediCodigoReemplazado N(5),mediMedicoReemplazado c(50);
			,tconCodigoInterno c(1),tconDescripcion c(20),turnAdmitido L,turnMostrar L)


		Do While Len(Alltrim(lcresp))>20

			lcMedicoCodigo = json(lcresp,'MedicoCodigo',0)
			lcmediCodigoInterno  = json(lcresp,'mediCodigoInterno',0)
			lcMedico = json(lcresp,'mediMedico',0)
			lcturnCodigoInterno = json(lcresp,'turnCodigoInterno',0)
			lcturnCodigo =  Val(json(lcresp,'turnCodigo',0))
			lcturnFecha = prg_ctod(Left(json(lcresp,'turnFecha',0),10))
			lcturnFechaInicio =  prg_ctod(Strtran(Left(json(lcresp,'turnFechaInicio',0),19),"T"," "),'T')
			lcturnFechaFin = prg_ctod(Strtran(Left(json(lcresp,'turnFechaFin',0),19),"T"," "),'T')
			lcjason =  json(lcresp,'turnLlegada',0)
			lcturnLlegada = prg_ctod(Strtran(Iif(lcjason ='null', "1900-01-01T00:00:00" ,lcjason ),"T"," "),'T')
			lcpaciCodigo = Val(json(lcresp,'paciCodigo',0))
			lcpaciCodigoInterno = Val(json(lcresp,'paciCodigoInterno',0))
			lcpaciHistoriaClinica = json(lcresp,'paciHistoriaClinica',0)
			lcpaciPaciente = json(lcresp,'paciPaciente',0)
			lcpaciNroDocumento = Val(json(lcresp,'paciNroDocumento',0))
		  	lcconsCodigoInterno = json(lcresp,'consCodigoInterno',0)
			DO sp_busco_medico_cuit WITH lcmediCodigoInterno 
			lcmediCodigo = MwkDatMedcuit.id                &&&Val(json(lcresp,'mediCodigo',0)) trae el valor de mk
			lcmediMedico = json(lcresp,'mediMedico',0)
			lccobeDescripcion = json(lcresp,'cobeDescripcion',0)
			lcplanDescripcion = json(lcresp,'planDescripcion',0)
			lccobeCodigoInterno = Val(json(lcresp,'cobeCodigoInterno',0))
			lcplanCodigoInterno = Val(json(lcresp,'planCodigoInterno',0))
			lctconCodigoInterno  = json(lcresp,'tconCodigoInterno',0)
			lctconDescripcion  = json(lcresp,'tconDescripcion',0)
			lcjason = json(lcresp,'turnCodigoAdmision',0)
			lcturnCodigoAdmision = Iif(lcjason ='null','',lcjason )
			lcturnCodigoVale = json(lcresp,'turnCodigoVale',0)
			lcjason = json(lcresp,'turnPrioridad',0)
			lcturnPrioridad =  Iif(lcjason ='null','',lcjason )
			lcjason =  json(lcresp,'turnSobreTurno',0)
			lcturnSobreTurno = (lcjason<>'false')
			lcjason = json(lcresp,'turnEspontaneo',0)
			lcturnEspontaneo =  (lcjason<>'false')
			lctuprCodigo =  Val(json(lcresp,'tuprCodigo',0))
			lcprocCodigoInterno = Val(json(lcresp,'procCodigoInterno',0))
			lcprocDescripcion = json(lcresp,'procDescripcion',0)
			lcjason =  json(lcresp,'turnReemplazo',0)
			lcturnReemplazo = (lcjason<>'false')
			lcmediCodigoReemplazado =  Val(json(lcresp,'mediCodigoReemplazado',0))
			lcmediMedicoReemplazado = json(lcresp,'mediMedicoReemplazado',0)
			lcjason =  json(lcresp,'procVirtual',0)
			lcprocVirtual =  (lcjason<>'false')
			lcjason =  json(lcresp,'turnSeRetira',0)
			lcturnSeRetira = prg_ctod(Iif(lcjason ='null', "1900-01-01T00:00:00" ,lcjason ))


			Insert Into mwkjson  (MedicoCodigo,mediCodigoInterno,Medico,turnCodigoInterno,turnCodigo,turnFecha,turnFechaInicio,;
				turnFechaFin,turnLlegada,paciCodigo,paciCodigoInterno,paciHistoriaClinica,paciPaciente,paciNroDocumento,;
				mediCodigo,mediMedico,cobeDescripcion,planDescripcion,cobeCodigoInterno,planCodigoInterno,; &&mediCodigoInterno,
				turnCodigoAdmision,turnCodigoVale,turnPrioridad,turnSobreTurno,turnEspontaneo,tuprCodigo,;
				procCodigoInterno,procDescripcion,procVirtual,turnSeRetira,turnReemplazo ,mediCodigoReemplazado ,mediMedicoReemplazado,;
				tconCodigoInterno,tconDescripcion,consCodigoInterno  )  ;  &&,turnAdmitido,turnMostrar
			Values (lcMedicoCodigo,lcmediCodigoInterno,lcMedico,lcturnCodigoInterno,lcturnCodigo,lcturnFecha,lcturnFechaInicio,;
				lcturnFechaFin,lcturnLlegada,lcpaciCodigo,lcpaciCodigoInterno,lcpaciHistoriaClinica,lcpaciPaciente,lcpaciNroDocumento,;
				lcmediCodigo,lcmediMedico,lccobeDescripcion,lcplanDescripcion,lccobeCodigoInterno,lcplanCodigoInterno,;&&lcmediCodigoInterno,
				lcturnCodigoAdmision,lcturnCodigoVale,lcturnPrioridad,lcturnSobreTurno,lcturnEspontaneo,lctuprCodigo,;
				lcprocCodigoInterno,lcprocDescripcion,lcprocVirtual,lcturnSeRetira,lcturnReemplazo ,lcmediCodigoReemplazado  ,lcmediMedicoReemplazado,;
				lctconCodigoInterno,lctconDescripcion,lcconsCodigoInterno  )  &&,lcturnAdmitido,lcturnMostrar

			npositem = At('procVirtual',lcresp)+20
			lcresp =Substr(lcresp ,npositem)
		Enddo
	Endif
Endif
Function json(texto,clave,comillas)
lcjson = texto
lcjsonclave = '"'+Alltrim(clave)+'":'
lninicio = At(lcjsonclave,lcjson)
lcstring = Substr(lcjson,lninicio,Len(lcjson)-lninicio)
lextra = At(":",lcstring)
lcstring = Substr(lcstring,lextra+1,Len(lcstring)-lextra)
If Left(lcstring,1)='"'
	lcstring = Strextract(lcstring,'"','"')
Else
	lextra = At(",",lcstring)-1
	lcstring = Left(lcstring,lextra )
Endif
Return lcstring
Endfunc
Function jsonitems(texto,clave,ocur)
lcjson = texto
lcjsonclave = '"'+Alltrim(clave)+'":'
lninicio = At(lcjsonclave,lcjson,ocur)
lcstring = Substr(lcjson,lninicio,Len(lcjson)-lninicio)
lextra = At(":",lcstring)
lcstring = Substr(lcstring,lextra+1,Len(lcstring)-lextra)
If Left(lcstring,1)='"'
	lcstring = Strextract(lcstring,'"','"')
Else
	lextra = At(",",lcstring)-1
	lcstring = Left(lcstring,lextra )
Endif
Return lcstring
Endfunc
