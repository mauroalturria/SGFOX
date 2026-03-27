Parameters dat1,dat2,dat3,dat4,dat5


* Mensajes OSANA desde entorno visual - versión 2 (2021-10-28 )
* 2022-07-14 - Actualización
* 2022-07-26 - Agregado de Centro Médico Lima
* 2022-08-01 - Limitación a Hospital de Día / Fono
* 2023-03-30 - Limitar envío de emails para Kinesio y Fono
* 2023-04-19 - Limitar envío de whatsapp para Kinesio y Fono

*-------------  Para prueba --------------
*Do sp_conexion
*dat3 = '9328244-0' && qas
*Set Step On
*-----------------------------------------------

lnenviomail = 1

If !Vartype(dat3)="C"
	Messagebox("El código de reserva no es válido.",48,"Envío de mensajeria")
	Return
Endif

mcodreserva = Alltrim(dat3)

lnambito = mxambito

TEXT To lcsql Noshow Pretext 7
select id,codent,codesp,codmed,codprest,codreserva,codserv,fechatur,horatur,diasem,hhmmTur,
pre_descriprest,reg_nroregistrac,reg_nombrepac,reg_sexo,reg_email,reg_numdocumento,reg_telefonos
from turnos
inner join SQLUser.PRESTACIONS on turnos.codprest = sqluser.PRESTACIONS.PRE_codprest
inner join SQLUser.REGISTRACIO on turnos.afiliado = registracio.REG_nroregistrac
where turnos.codreserva = ?mcodreserva
ENDTEXT

If !Prg_EjecutoSql(lcSql,'mwkturnoid')
	Return .F.
Endif

If !Used('mwkturnoid')
	Return .F.
Endif


* Busco si es Lima o SG
lncentrolima = 0
If mxambito=1
	Select mwkTurnoid
	lnbuscopresta  	= mwkTurnoid.codprest
	lnbuscomedico 	= mwkTurnoid.codmed
	lndiasemana    	= mwkTurnoid.diasem
	lfechaturno      	= mwkTurnoid.fechatur
	lhoraturno		= mwkTurnoid.hhmmTur

	lcSql = "select * from MedPresta where codprest = ?lnbuscopresta and codmed = ?lnbuscomedico and diasem = ?lndiasemana and  (?lfechaturno BETWEEN fecVigend and fecVigenH) and (?lhoraturno BETWEEN hhmmDes AND hhmmHas) AND sala like '%LIMA%'"
	If !Prg_EjecutoSql(lcSql,'mwkLima')
		Return .F.
	Endif
	If Reccount('mwkLima')>0 Or mxcentromedico = 2
		lncentrolima = 2
	Else
		lncentrolima = 1
	Endif
	Use In Select('mwkLima')
Endif

Select mwkTurnoid

*	# No dejo enviar mensajería para los siguientes servicios
If  Inlist(mwkTurnoid.codserv,1130,2218,7600)
	Return .F.
Endif



Scan All

*	# Turno ID
	mv8 = ''
	mv8 = 'A-'+Alltrim(Str(lnambito))+'-I-' + Alltrim(Str(mwkTurnoid.Id))
	midturno = mwkTurnoid.Id


* Busco el tipo de turno según la prestación
	lcpresta = Upper(Alltrim(mwkTurnoid.pre_descriprest))
	lcTipoturno = ''
	lcTipoConsulta = ''
	lcturnodistancia = At('DISTANCIA',Alltrim(lcpresta))>0
	If lcturnodistancia
		lcTipoturno = 'VIRTUAL'
		lcTipoConsulta = 'V'
	Else
		lcTipoturno = 'PRESENTIAL'
		lcTipoConsulta = 'P'
	Endif
	mv11 = lcTipoturno && Virtual o Presencial

*	# Consulta de Exclusión (Si la consulta trae registros, no enviá wapp)
	mCodMed  = mwkTurnoid.codmed
	mCodPres = mwkTurnoid.codprest
	mCodEsp  = Alltrim(mwkTurnoid.codesp)
	lexistefiltro = prg_osana_mensajes_filtros(mCodEsp,mCodPres,mCodMed,lcTipoConsulta)

	If lexistefiltro
		Return .F.
	Endif

*	# Filtro prestaciones para Foniatría que son presenciales (JIRA GGP-2079) y Audiología (JIRA GGP-2142)
	lpaso = .T.

	If !lcturnodistancia And Inlist(mwkTurnoid.codesp ,"FONI","AUDI","KINE")
		lpaso = .F.
	Endif

	If !lpaso
		Return .F.
	Endif

*	# Filtro prestaciones para Fono y Kinesio (JIRA GGP-2949) 
	lpaso = .T.

	If Inlist(mwkTurnoid.codesp ,"FONI","AUDI","KINE")
		lpaso = .F.
	Endif

	If !lpaso
		Return .F.
	Endif



*	# Busco el lugar el ámbito

	mbuscoambito = lnambito

	lcSql = "select * from TabAmbito where id = ?mbuscoambito"
	If !Prg_EjecutoSql(lcSql,'mwkambito')
		Return .F.
	Endif

	lclugar = ""
	Select mwkambito
	lclugar = Alltrim(mwkambito.desclarga)

	msigo = .T.

	mv1 = ''
	mv2 = ''
	mv3 = ''
	mv4 = ''
	mv5 = ''
	mv6 = ''
	mv7 = ''
	mv9 = ''
	mv10 = ''

*	# Paciente
	mregistracio = mwkTurnoid.reg_nroregistrac
	lcpaciente = filtrochar(Alltrim(mwkTurnoid.reg_nombrepac))
	lhaycoma = At(',',lcpaciente,1)
	mv4 = Substr(lcpaciente,1,lhaycoma-1) && Apellido
	mv4 = Strtran(mv4,'#','Ñ')
	mv4 = prg_saca_char (mv4)

	mv3 = Substr(lcpaciente,lhaycoma+1,Len(lcpaciente)-Len(mv4))  && Nombre
	mv3 = Strtran(mv3,'#','Ñ')
	mv3 = prg_saca_char (mv3)

	mv5 = Alltrim(Str(mwkTurnoid.reg_numdocumento)) && Nro Documento
	mv6 = Iif(Isnull(Alltrim(mwkTurnoid.reg_email)),'NO TIENE',Alltrim(mwkTurnoid.reg_email)) && eMail
	If Empty(mv6)
		mv6 = "NO TIENE"
	Endif

	If mwkusuario.codigovax = 57814
		mv6 = 'fcastelli@sg.com.ar'
	Endif

*	# Profesional
	midcodmed = mwkTurnoid.codmed
	Do sp_busco_medico_dat With midcodmed
	lcdatprof = Alltrim(mwkdatmed.nombre)
	lcdatprof = filtrochar(lcdatprof)
	lhaycoma = At(',',lcdatprof,1)
	If lhaycoma > 0
		mv2 = Substr(lcdatprof,1,lhaycoma-1) && Apellido
		mv2 = Strtran(mv2,'#','Ñ')
		mv1 = Substr(lcdatprof,lhaycoma+1,Len(lcdatprof)-Len(mv2)) && Nombre
		mv1 = Strtran(mv1,'#','Ñ')
	Else
		lhayespacio = At(' ',lcdatprof)
		mv2 = Substr(lcdatprof,1,lhayespacio-1) && Apellido
		mv2 = Strtran(mv2,'#','Ñ')
		mv1 = Substr(lcdatprof,lhayespacio+1,Len(lcdatprof)-Len(mv2)) && Nombre
		mv1 = Strtran(mv1,'#','Ñ')
	Endif

*	# Trato del Profesional
	lncodprof = mwkdatmed.codprof
	lcsexo = Alltrim(mwkdatmed.sexo)
	lcSql = "select * from SQLUser.TabProfesion where id = ?lncodprof"
	If !Prg_EjecutoSql(lcSql,'mwkTrato')
		Return .F.
	Endif
	lctrato = ""
	Select mwkTrato
	If lcsexo = "F"
		lctrato = Alltrim(mwkTrato.titulof)
	Else
		lctrato = Alltrim(mwkTrato.titulo)
	Endif

*	# Especialidad
	lcCodEsp  = Alltrim(mwkTurnoid.codesp)
	lcNombreEspecialidad = lcCodEsp
	lcSql = "select ESP_descripcion from ESPECIALID WHERE ESP_codesp = ?lcCodEsp"
	If !Prg_EjecutoSql(lcSql,'mwkEspecialidad')
		Return .F.
	Endif
	Select mwkEspecialidad
	lcNombreEspecialidad = Alltrim(mwkEspecialidad.ESP_descripcion)
	mv10 = filtrochar(lcNombreEspecialidad)  && Especialidad

*	# Filtro envío de email por Especialidad
	If Inlist(mv10,'KINESIOLOGIA','FONOAUDIOLOGIA')
		lnenviomail = 0
	Endif

*	# Fecha turno
	Select mwkTurnoid
	ldfechaturno = mwkTurnoid.horatur
	mv9_anyo = Year(ldfechaturno)
	mv9_mes = Padl(Month(ldfechaturno),2,'0')
	mv9_dia = Padl(Day(ldfechaturno),2,'0')
	mv9_hora = Alltrim(Substr(Ttoc(ldfechaturno),12,5))
	mv9   = Alltrim(Str(mv9_anyo))+'-'+Alltrim(mv9_mes)+'-'+Alltrim(mv9_dia)+' '+Alltrim(mv9_hora)  && Fecha + Hora Turno '2021-04-07 16:30'

	linfoturno = "Fecha: " + Alltrim(mv9_dia) + "/" + Alltrim(mv9_mes) + "/" + Alltrim(Str(mv9_anyo)) + " Hora: " + mv9_hora


*	# Teléfono Whatsapp
	lcSql = "select trt_numero as celular from tabregtel where TRT_Registracio = ?mregistracio and TRT_Pasiva = '1900-01-01' and TRT_tipo in (4,5,7) order by TRT_tipo desc"
	If !Prg_EjecutoSql(lcSql,'mwkpacwapp')
		Return .F.
	Endif

	If !Used('mwkpacwapp')
		Messagebox('No se pudo acceder a la información de líneas telefónicas en este momento.',48,'AVISO')
		Return .F.
	Endif

	If !Reccount('mwkpacwapp')>0
		Messagebox('Este paciente no tiene asociado una línea de celular para envío de Whatsapp.',48,'AVISO')
		Return .F.
	Endif

	Insert Into mwkpacwapp (celular) Values (Alltrim(mwkTurnoid.reg_telefonos))

	Select mwkpacwapp
	Go Top In 'mwkpacwapp'

	Do While msigo

		m7temp = Alltrim(mwkpacwapp.celular)

		olevism = Newobject('vism','lib_olevism')

		olevism.olecontrol1.MServer = Allt(mwktabcfg.OLEServer)
		olevism.olecontrol1.NameSpace = Allt(mwktabcfg.olespaces)

		mimensaje="D ProcNormalizaCelular^DESPMENS("+m7temp+")"

		olevism.olecontrol1.Code = mimensaje
		olevism.olecontrol1.execflag = 1

		lcolevismerror = olevism.olecontrol1.P0 && error
		lcolevismdato = olevism.olecontrol1.P1 && valor

		If Len(lcolevismdato)>0
			msigo = .F.
		Endif

		mv7 = Alltrim(lcolevismdato)

		If mwkusuario.codigovax = 54035 && Car
			mv7 = '5491144704384'
		Endif

		olevism.olecontrol1.MServer = ""
		olevism.olecontrol1.NameSpace = ""

		= prg_olevism_reset(olevism.olecontrol1)

		Skip
		Loop
	Enddo

	If Empty(mv7)
		Messagebox('No hay número de whatsapp asignado para envío de mensajes.',48,'Aviso')
		Return .F.
	Endif

* Envio de Wapp

	If Empty(lcolevismerror)

		lnenviado = 0

		mccon = ''
		mccon = Left(SQLGetprop(mcon1,'ConnectString'),80)

		Do Case
		Case  (".190" $ mccon) && Desarrollo 190
			lclink = "https://desa.sg.com.ar/ws-osana/sg-curl2.php"
		Case  (".50.110" $ mccon) && Desarrollo 50.110
			lclink = "https://desa.sg.com.ar/ws-osana/sg-curl2.php"
		Case  (".50.102" $ mccon) && QAS 50.102
			lclink = "https://desa.sg.com.ar/ws-osana/sg-curl2_qas.php"
			*lclink = "https://serviciosqas.sg.com.ar/ws-osana/sg-curl2.php"
		Otherwise  && Producción
			lclink = "https://servicios.sg.com.ar/ws-osana/sg-curl2.php"
		Endcase

*		lclink = prg_tablinks("SGCURL2")

		If Empty(lclink) Or "ERROR" $ Upper(lclink)

			lcresp = "Error con la obtención del link"

		Else

			lclink = lclink + '?v1=' + mv1 + '&v2=' + mv2 + '&v3=' + mv3 + '&v4=' + mv4 + '&v5=' + mv5 + '&v6=' + mv6 + '&v7=' + mv7 + '&v8=' + mv8 + '&v9=' + mv9 + '&v10=' + mv10 + '&tipv=' + mv11 + '&trato=' + lctrato + '&centro=' + Alltrim(Str(lncentrolima)) + '&enviomail=' + Alltrim(Str(lnenviomail))

			lclink = Strtran(lclink,' ','%20')

			Wait "Enviando mensaje de whatsapp. Aguarde por favor." Window Nowait Noclear

* Forma de envío 1 - Algunos equipos tienen problemas con Certificado

*!*		loXmlHttp = Newobject( "Microsoft.XMLHTTP" )
*!*		If Vartype(loXmlHttp)="O"
*!*			loXmlHttp.Open( "POST" , lclink, .F. )
*!*			If loXmlHttp.ReadyState = 1
*!*				loXmlHttp.Send()
*!*				If loXmlHttp.ReadyState = 4
*!*					lcresp = Alltrim(loXmlHttp.responseText)
*!*					If loXmlHttp.Status = 200
*!*						If !Vartype(lcresp)="C"
*!*							lcresp = "ERROR BORRAR"
*!*						Endif
*!*						lcmsgtel = "Número de celular: " + mv7
*!*						lerror = .F.
*!*						If 'ERROR' $ Upper(lcresp)
*!*							lerror = .T.
*!*						Endif
*!*						If !Empty(lcresp) And !lerror
*!*							Messagebox('El recordatorio de turno fue enviado con éxito.'+Chr(10)+lcmsgtel,64,'Aviso')
*!*						Else
*!*							Messagebox('No se pudo enviar recordardatorio de turno al Whatsapp del paciente.',48,'Aviso')
*!*						Endif
*!*					Else
*!*						lcresp = "No se puedo enviar. Estado: " + Alltrim(Str(loXmlHttp.Status))
*!*						Messagebox(lcresp,16,"Problema con XMLHTTP 1")
*!*					Endif
*!*				Else
*!*					lcresp = "Problema de conexión. Estado: " + Alltrim(Str(loXmlHttp.ReadyState))
*!*					Messagebox(lcresp,16,"Problema con XMLHTTP 2")
*!*				Endif
*!*			Else
*!*				lcresp = "NO ENVIADO - ESTADO: "+Alltrim(Str(loXmlHttp.ReadyState))
*!*				Messagebox(lcresp,16,"Problema con XMLHTTP 3")
*!*			Endif
*!*		Else
*!*			lcresp = "NO ENVIADO - Problema XMLHTTP 4"
*!*			Messagebox(lcresp,16,'Aviso')
*!*		Endif
*!*		Release loXmlHttp



* Forma de Envío 2 - Algunas tienen problema de Certificado
*!*		Try
*!*			xmlHTTP = Createobject("MSXML2.XMLHTTP.6.0")
*!*			lcVersion = "6"
*!*		Catch
*!*			xmlHTTP = Createobject("MSXML2.XMLHTTP.3.0")
*!*			lcVersion = "3"
*!*		Endtry
*!*		xmlHTTP.Open( "POST" , lclink, .F. )
*!*		xmlHTTP.Send()
*!*		lcresp = Alltrim(xmlHTTP.responseText)

*!*		Do While xmlHTTP.readyState<>4
*!*			DoEvents
*!*		Enddo

* Forma de Envío 3

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
			lcresp = xmlHTTP.responseText

			lnServidor = xmlHTTP.Status

			Wait Clear

			If !xmlHTTP.Status = 200
				Messagebox('Tipo de Error: '+Alltrim(Str(xmlHTTP.Status)),48,'Problemas con el Servidor')
			Else
				If !Vartype(lcresp)="C"
					lcresp = "ERROR BORRAR"
				Endif
				lcmsgtel = "Número de celular: " + mv7 + Chr(10) + "Turno: " + linfoturno
				lerror = .F.
				If 'ERROR' $ Upper(lcresp)
					lerror = .T.
				Endif
				If !Empty(lcresp) And !lerror
					If  Upper('turno ya registrado') $ Upper(lcresp)
						Messagebox('Este turno ya fue registrado e informado anteriormente.'+Chr(10)+'Código de Reserva: '+Alltrim(mcodreserva),48,'Aviso')
					Else
						Messagebox('El recordatorio de turno fue enviado con éxito.'+Chr(10)+lcmsgtel,64,'Confirmación de envío de mensaje de Turno')
					Endif
				Else
					Messagebox('No se pudo enviar recordardatorio de turno al Whatsapp del paciente.'+Chr(10)+lcresp,48,'Problemas con el servicio de mensajeria')
				Endif
			Endif

			Release xmlHTTP

		Endif

	Else
		lcresp = "NO ENVIADO - Problema con número de Telèfono"
		Messagebox(lcresp,48,"AVISO")

	Endif


* 	# Grabo en Caché

	lcSql = "insert into ZabWsMsg (ZWM_idtipomsg,ZWM_idturno,ZWM_idwsrespu,ZWM_respuesta,ZWM_adjunto, CodAmbito) values (1,?midturno,?lcresp,?lcresp,'',?lnambito)"
	If !Prg_EjecutoSql(lcSql)
		Return .F.
	Endif

*!*	* MaríaDB (No activado aún)

*!*	hConn = Sqlstringconnect("Driver={MariaDB ODBC 3.1 Driver}; PORT=3306; Server=172.16.240.2; Database=CATALOGO_PROD; Uid=teleconsultas; Pwd=teleconsultasm@riaDB")
*!*	If hConn < 0
*!*		Messagebox('No se pudo conectar a Ma.DB',48,'Aviso')
*!*		Return .F.
*!*	Endif
*!*	mret = SQLExec(hConn,lcsql)
*!*	If mret<0
*!*		Messagebox('Error al grabar mensaje en sistema MaDB.',48,'Aviso')
*!*	Endif
*!*	SQLDisconnect(hConn)

	Select mwkTurnoid
Endscan


Use In Select('mwkdatregpac')
Use In Select('mwkpacwapp')
Use In Select('mwkturnoid')
Use In Select('mwkambito')
Use In Select('mwkdatmed')
Use In Select('mwkTrato')
Use In Select('mwkEspecialidad')
Use In Select('mwkpacwapp')
Use In Select('mwkespecialidad')
Use In Select('mwktrato')
Use In Select('mwkdatmed')


Release mcodreserva,mCodMed,mCodPres,mCodEsp,lexistefiltro,lcpresta,lcTipoturno,lcTipoConsulta,midturno,lcturnodistancia,;
	mbuscoambito,lclugar,mregistracio,lcpaciente,midcodmed,lcdatprof
Release mv1,mv2,mv3,mv4,mv5,mv6,mv7,mv8,mv9,mv10,mv11

* Return

*!*	Strtofile(lclink,'linklog.txt')
*!*	_Cliptext=lclink
*!*	Wait

Function filtrochar(FiltroCadena)
NewCadena = ''
Cadena = Alltrim(Upper(FiltroCadena))
Cadena = Strtran(Cadena,'Ñ','N')
Cadena = Strtran(Cadena,'Á','A')
Cadena = Strtran(Cadena,'É','E')
Cadena = Strtran(Cadena,'Í','I')
Cadena = Strtran(Cadena,'Ó','O')
Cadena = Strtran(Cadena,'Ú','U')

For nLong = 1 To Len(Cadena)
	cChar = Substr(Cadena,nLong,1)
	nChar = Asc(cChar)
	If Between(nChar,65,90) Or Inlist(nChar,32,44)
		NewCadena = NewCadena + cChar
	Endif
Endfor

Return NewCadena
Endfunc

