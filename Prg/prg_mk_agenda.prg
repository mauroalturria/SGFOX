Lparameters xfdesde,xfhasta,xhdesde,xhhasta,xconsul,xcuil,xestado

If myip='172.16.1.7'
*	Set Step On
Endif
*http://172.16.50.116/api/mk_sg_agendaMedica.php?fdesde=2024-10-01&fhasta=2024-10-01&hdesde=;
&hhasta=&consul=&cuil=27-22349730-1&estado=T
Do sp_busco_estados With 57,' and tipo = 55 and subestado = ?mxcentromedico ','mwkAgendaMK'&&

If mwkAgendaMK.estado = 1
	lclink = Alltrim(mwkAgendaMK.Descrip)
	lclink = lclink + '?fdesde=' + Alltrim(xfdesde) + '&'+'fhasta=' + Transform(xfhasta)
	lclink = lclink + '&'+'hdesde=' + Alltrim(xhdesde) + '&'+'hhasta=' + Transform(xhhasta)
	lclink = lclink + '&'+'consul=' +  Alltrim(xconsul)
	lclink = lclink + '&'+'cuil=' +  Alltrim(xcuil)
	lclink = lclink + '&'+'estado=' + Alltrim(xestado)

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
		Create Cursor mwkjson (MedicoCodigo c(13),Medico c(50),turnCodigoInterno c(30),turnCodigo N(12),turnFecha D;
			,turnFechaInicio T,turnFechaFin T,turnLlegada T,paciCodigo N(10),paciCodigoInterno N(10);
			,paciHistoriaClinica c(10),paciPaciente c(50),paciNroDocumento N(15),mediCodigoInterno N(5);
			,mediCodigo N(5),mediMedico c(50),cobeDescripcion c(50),planDescripcion c(50),cobeCodigoInterno N(5);
			,planCodigoInterno N(5),turnCodigoAdmision c(50),turnCodigoVale c(50),turnPrioridad c(50);
			,turnSobreTurno L,turnEspontaneo L,tuprCodigo N(10),procCodigoInterno N(10),procDescripcion c(50);
			,procVirtual L,turnSeRetira T ,turnReemplazo L,mediCodigoReemplazado N(5),mediMedicoReemplazado c(50);
			,tconCodigoInterno c(1),tconDescripcion c(20),turnAdmitido L,turnMostrar L)


		lcMedicoCodigo = json(lcresp,'MedicoCodigo',0)
		lcMedico = json(lcresp,'mediMedico',0)
		Do While Len(Alltrim(lcresp))>20
			lcturnCodigoInterno = json(lcresp,'turnCodigoInterno',0)
			lcturnCodigo =  Val(json(lcresp,'turnCodigo',0))
			lcturnFecha = prg_ctod(Left(json(lcresp,'turnFecha',0),10))
			lcturnFechaFin = prg_ctod(Strtran(Left(json(lcresp,'turnFechaFin',0),19),"T"," "),'T')
			lcjason =  json(lcresp,'turnLlegada',0)
			lcturnLlegada = prg_ctod(Strtran(Iif(lcjason ='null', "1900-01-01T00:00:00" ,lcjason ),"T"," "),'T')
			lcpaciCodigo = Val(json(lcresp,'paciCodigo',0))
			lcpaciCodigoInterno = Val(json(lcresp,'paciCodigoInterno',0))
			lcpaciHistoriaClinica = json(lcresp,'paciHistoriaClinica',0)
			lcpaciPaciente = json(lcresp,'paciPaciente',0)
			lcpaciNroDocumento = Val(json(lcresp,'paciNroDocumento',0))
			lcmediCodigoInterno = Val(json(lcresp,'mediCodigoInterno',0))
			lcmediCodigo =  Val(json(lcresp,'mediCodigo',0))
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
			lcjason =  json(lcresp,'turnReemplazo',0)
			lcturnReemplazo = (lcjason<>'false')
			lcmediCodigoReemplazado =  Val(json(lcresp,'mediCodigoReemplazado',0))
			lcmediMedicoReemplazado = json(lcresp,'mediMedicoReemplazado',0)
			lcjason =  json(lcresp,'turnSeRetira',0)
			lcturnSeRetira = prg_ctod(Iif(lcjason ='null', "1900-01-01T00:00:00" ,lcjason ))
			npositem = At('procedimientos',lcresp)+14
			lcresp =Substr(lcresp ,npositem)
			Do While Len(Alltrim(lcresp))>20 And At(']',Alltrim(lcresp))>10
				lctuprCodigoInterno = json(lcresp,'tuprCodigoInterno',0)
				lcturCodigoInterno = Val(Substr(lctuprCodigoInterno ,At("ID",lctuprCodigoInterno )+3))
				lcprocCodigoInterno = Val(json(lcresp,'procCodigoInterno',0))
				lcprocDescripcion = json(lcresp,'procDescripcion',0)
				lcturnFechaInicio =  prg_ctod(Strtran(Left(json(lcresp,'turnFechaInicio',0),19),"T"," "),'T')
				lcjason =  json(lcresp,'procVirtual',0)
				lcprocVirtual =  (lcjason<>'false')
				Insert Into mwkjson  (MedicoCodigo,Medico,turnCodigoInterno,turnCodigo,turnFecha,turnFechaInicio,;
					turnFechaFin,turnLlegada,paciCodigo,paciCodigoInterno,paciHistoriaClinica,paciPaciente,paciNroDocumento,;
					mediCodigoInterno,mediCodigo,mediMedico,cobeDescripcion,planDescripcion,cobeCodigoInterno,planCodigoInterno,;
					turnCodigoAdmision,turnCodigoVale,turnPrioridad,turnSobreTurno,turnEspontaneo,tuprCodigo,;
					procCodigoInterno,procDescripcion,procVirtual,turnSeRetira,turnReemplazo ,mediCodigoReemplazado ,mediMedicoReemplazado,;
					tconCodigoInterno,tconDescripcion  )  ;  &&,turnAdmitido,turnMostrar
				Values (lcMedicoCodigo,lcMedico,lcturnCodigoInterno,lcturnCodigo,lcturnFecha,lcturnFechaInicio,;
					lcturnFechaFin,lcturnLlegada,lcpaciCodigo,lcpaciCodigoInterno,lcpaciHistoriaClinica,lcpaciPaciente,lcpaciNroDocumento,;
					lcmediCodigoInterno,lcmediCodigo,lcmediMedico,lccobeDescripcion,lcplanDescripcion,lccobeCodigoInterno,lcplanCodigoInterno,;
					lcturnCodigoAdmision,lcturnCodigoVale,lcturnPrioridad,lcturnSobreTurno,lcturnEspontaneo,lctuprCodigo,;
					lcprocCodigoInterno,lcprocDescripcion,lcprocVirtual,lcturnSeRetira,lcturnReemplazo ,lcmediCodigoReemplazado  ,lcmediMedicoReemplazado,;
					lctconCodigoInterno,lctconDescripcion  )  &&,lcturnAdmitido,lcturnMostrar
				npositem = At('}',lcresp)+1
				lcresp =Substr(lcresp ,npositem)
			Enddo
			npositem = At('}',lcresp)+1
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
