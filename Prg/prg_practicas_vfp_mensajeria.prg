Lparameters phc,pcodmed,pentidad,pnroafiliado,pprotocolo,hayac,nombrearchivo,ntipo

* 2021/12/01

mhc = phc
mentidad = pentidad
mafiliado = pnroafiliado
mproto = pprotocolo

* Para prueba:
*!*	pcodmed = 6347
*!*	mhc = '3457239-1'
*!*	mentidad = 948
*!*	mafiliado = 2793277365700
*!*	mproto = '07984215-22'
*!*	ntipo = 0
*!*	Do sp_conexion
*!*   Set Step On

mccon = ''
mccon = Left(SQLGetprop(mcon1,'ConnectString'),80)
lsubtipo = 0

Do Case
Case  (".190" $ mccon) && Desarrollo
	lsubtipo = 0
Case  (".50.110" $ mccon) && Desarrollo
	lsubtipo = 0
Case  (".50.102" $ mccon) && QAS
	lsubtipo = 1
Otherwise  && Producción
	lsubtipo = 2
Endcase

Do sp_busco_estados With 7,' and Tipo = 106 and estado = 1 and subestado = ' + Alltrim(Str(lsubtipo)),'mwkhabred'
If !Reccount('mwkhabred')>0
	Messagebox ('No existe la configuración en mwkhabred. Avise a sistemas',16,'AVISO')
	Return 0
Endif
lOrigen = Alltrim(mwkhabred.Descrip)

=existeunidad()
=unidadredup(mletraunidad,lOrigen)

* ------------------------------------------------------------------------------------
* PACIENTE
* ------------------------------------------------------------------------------------
lcsql = 'select * from SQLUser.REGISTRACIO where REG_nrohclinica = ?mhc'
If !Prg_EjecutoSql(lcsql,'mwkregistro')
	Return .F.
Endif
lcpaciente = filtrochar(Alltrim(mwkregistro.reg_nombrepac))
lhaycoma = At(',',lcpaciente,1)
mv4 = Substr(lcpaciente,1,lhaycoma-1) && Apellido
mv4 = Strtran(mv4,'#','Ñ')
mv4 = prg_saca_char (mv4)
mv3 = Substr(lcpaciente,lhaycoma+1,Len(lcpaciente)-Len(mv4))  && Nombre
mv3 = Strtran(mv3,'#','Ñ')
mv3 = prg_saca_char (mv3)
mv5 = Alltrim(Str(mwkregistro.reg_numdocumento)) && Nro Documento
mv6 = Iif(Isnull(Alltrim(mwkregistro.reg_email)),'NO TIENE',Alltrim(mwkregistro.reg_email)) && eMail
mnroregistra = mwkregistro.reg_nroregistrac

* ------------------------------------------------------------------------------------
* MEDICO
* ------------------------------------------------------------------------------------
midcodmed = pcodmed
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
* ------------------------------------------------------------------------------------

lcsub = ""

Do Case
Case ntipo = 0
	maltacomp = "0"
	lcsub = "bc"
Case ntipo = 1
	maltacomp = "1"
	lcsub = "ac"
Case ntipo = 2
	lcsub = "acsa"
	maltacomp = "1"
Case ntipo = 3
	lcsub = "acsaant"
	maltacomp = "1"
Endcase

If !Vartype(nombrearchivo)='C'
	Messagebox('No existe el nombre del archivo origen',16,'AVISO')
	Return 0
Endif

lcarchorig = nombrearchivo

mhayarch = copioarchivos(lcarchorig,mletraunidad)
= unidadreddown(mletraunidad)

* Módulo de envío

mfechahora = sp_busco_fecha_serv('DT')
lclink = ''

lcsql = "select * from SQLUser.TabRegTel where TRT_Registracio = ?mnroregistra and TRT_tipo = 7 and TRT_Pasiva = '1900-01-01' order by id desc"
If !Prg_EjecutoSql(lcsql,'mwkwapp')
	Return .F.
Endif

mv7 = buscowapp(mwkwapp.trt_numero)

mv8 = '1'   &&  // ID Turno
mv9 = Alltrim(Str(Year(mfechahora)))+'-'+Padl(Alltrim(Str(Month(mfechahora))),2,'0')+'-'+Padl(Alltrim(Str(Day(mfechahora))),2,'0')    &&  '2021-05-07'   &&     // Fecha + Hora Turno '2021-04-07 16:30'
mv10 = 'PRACTICA'   &&  // Especialidad
If Vartype(mwkdatmed.matriculas) = "C"
	mv11 = Alltrim(mwkdatmed.matriculas)
Else
	If Vartype(mwkdatmed.matriculas) = "N"
		mv11 = Alltrim(Str(mwkdatmed.matriculas))
	Else
		mv11 = ""
	Endif
Endif


If Vartype(mwkdatmed.matprov)="C"
	mv12 = Alltrim(mwkdatmed.matprov)
Else
	If Vartype(mwkdatmed.matprov)="N"
		mv12 = Alltrim(Str(mwkdatmed.matprov))
	Else
		mv12 = ""
	Endif
Endif


mv13 = Alltrim(pentidad)
mv13 = Strtran(mv13,'#','Ñ')
mv14 = Alltrim(pnroafiliado)
mv15 = '1'  && // Nro de receta - para prácticas queda en 1

If mhayarch
	mv16 = lcsub  + mproto + ".pdf"
Else
	mv16 = ""
Endif

mmtipoturno = 'Practica'


parametros =  '?v1=' + mv1 + '&v2=' + mv2 + '&v3=' + mv3 + '&v4=' + mv4 + '&v5=' + mv5 + '&v6=' + mv6 + '&v7=' + mv7 + '&v8=' + mv8 + '&v9=' + mv9 + '&v10=' + mv10 + '&v11=' + mv11 + '&v12=' + mv12 + '&v13=' + mv13 + '&v14=' + mv14 + '&v15=' + mv15 + '&v16=' + mv16 + '&tipoturno=' + mmtipoturno + '&altacomp=' + maltacomp

lenvio = enviowhapp(parametros)

If lenvio
	Messagebox("Envío de práctias con éxito",48,"Aviso")
Endif


*!*	mprotocolo = Alltrim(mwkEnvioW.protocolo)
*!*	lnenviado = 0

*!*	lnregistracion = mwkregistro.reg_nroregistrac


*!*	lcrespfinal = Iif(Empty(lcresp),'Resp. Vacia',lcresp)
*!*	mpac = mv4 + ' ' + mv3
*!*	mdoc = mv2 + ' ' + mv1
*!*	Select mwklogenv
*!*	Insert Into mwklogenv(url,detalle,fecestudio,uid,fechahora,protocolo,pac,med,envio) Values (lclink,lcrespfinal,mfechaestudio,lcrespfinal,mfechahora,mprotocolo,mpac,mdoc,lnenviado)

*!*	lcsql = "update ZabPDFctrl set zpc_fecha = ?mfechaestudio,zpc_enviado = ?lnenviado,zpc_fechahora = ?mfechahora, "+;
*!*		"zpc_estado = 1 where zpc_nroprotocolo = ?mprotocolo"

*!*	If !Prg_EjecutoSql(lcsql,'')
*!*		Return .F.
*!*	Endif

*!*	Endif

* -------------------------------------------------------------------------------------------
* COPIO ARCHIVOS PDF
* -------------------------------------------------------------------------------------------

Function copioarchivos (lcorig,lcdest)
larchok = .T.
If File(lcorig)
	If Directory(lcdest)
		lcarchivo = Juststem(lcorig)+'.pdf'
		Copy File (lcorig) To (lcdest+lcarchivo)
		If !File(lcdest+lcarchivo)
			larchok = .F.
		Endif
	Endif
Endif
Return larchok
Endfunc

* -------------------------------------------------------------------------------------------
* LEVANTO LA UNIDAD DE RED
* -------------------------------------------------------------------------------------------

Function unidadredup(lcUndd, lcOrigen,lcrecon,lcuser,lcpass,mret)
lcErrorAnt = On("ERROR")
On Error =Aerr(eros)
objNetwork = Createobject("Wscript.Network")
If Vartype(lcuser)="C"
	objNetwork.MapNetworkDrive(lcUndd, lcOrigen,lcrecon,lcuser,lcpass)
Else
	objNetwork.MapNetworkDrive(lcUndd, lcOrigen,0)
Endif
On Error
If Vartype(eros)="N"
	Strtofile(eros(2)+Chr(10)+eros(3),"C:\temp\errorunidad.txt")
Endif
Release objNetwork
On Error &lcErrorAnt
objNetwork = .F.
Endfunc

* -------------------------------------------------------------------------------------------
* DESCONECTO LA RED
* -------------------------------------------------------------------------------------------

Function unidadreddown(lcUndd)
lcErrorAnt = On("ERROR")
On Error =Aerr(eros)
objNetwork = Createobject("Wscript.Network")
objNetwork.RemoveNetWorkDrive(lcUndd)
On Error
If Vartype(eros)="N"
	Strtofile(eros(2)+Chr(10)+eros(3),"C:\temp\errorunidad.txt")
Endif
Release objNetwork
Release mletraunidad
On Error &lcErrorAnt
objNetwork = .F.
Endfunc

* -------------------------------------------------------------------------------------------
* BUSCO UNIDAD DISPONIBLE
* -------------------------------------------------------------------------------------------

Function existeunidad()
Public mletraunidad
lcLetra = "DEFGHIJKLMNOPQRSTUVWXYZ"
lnmax = Len(lcLetra)
lnunidad = 1
Do While lnunidad>0
	lcletraexiste = Substr(lcLetra,lnunidad,1)+":\"
	If !Directory(lcletraexiste)
		lnunidad = 0
	Else
		lnunidad = lnunidad + 1
	Endif
Enddo
mletraunidad = Left(lcletraexiste,2)
Endfunc

* -------------------------------------------------------------------------------------------
* ENVIO WHATSAPP Y MAIL
* -------------------------------------------------------------------------------------------
Function enviowhapp(parametros)
mccon = ''
mccon = Left(SQLGetprop(mcon1,'ConnectString'),80)

Do Case
Case  (".190" $ mccon) && Desarrollo 190
	lclink =	"https://desa.sg.com.ar/intranet/lanzador/prog/wambdev/ajax/prestapdf.php"
Case  (".50.110" $ mccon) && Desarrollo 50.110
	lclink =	"https://desa.sg.com.ar/intranet/lanzador/prog/wambdev/ajax/prestapdf.php"
Case  (".50.102" $ mccon) && Desarrollo 50.102
	lclink = "https://profesionalqas.sg.com.ar/intranet/lanzador/prog/wamb/ajax/prestapdf.php"
Otherwise  && Producción
	lclink = "https://profesional.sg.com.ar/intranet/lanzador/prog/wamb/ajax/prestapdf.php"
Endcase
lclink = Strtran(lclink+parametros,' ','%20')

* Modelo de envío 1

*!*	loXmlHttp = Newobject( "Microsoft.XMLHTTP" )
*!*	If Vartype(loXmlHttp)="O"
*!*		loXmlHttp.Open( "POST" , lclink, .f. )
*!*		If loXmlHttp.ReadyState = 1
*!*			loXmlHttp.Send()
*!*			If loXmlHttp.ReadyState = 4
*!*				lcresp = Alltrim(loXmlHttp.responseText)
*!*				If loXmlHttp.Status = 200
*!*					If !Vartype(lcresp)="C"
*!*						lcresp = "ERROR BORRAR"
*!*					Endif
*!*					lcmsgtel = "Número de celular: " + mv7
*!*					lerror = .F.
*!*					If 'ERROR' $ Upper(lcresp)
*!*						lerror = .T.
*!*					Endif
*!*					If !Empty(lcresp) And !lerror
*!*						Messagebox('El pedido de pràcticas fue enviado con éxito.'+Chr(10)+lcmsgtel,64,'Aviso')
*!*					Else
*!*						Messagebox('No se pudo enviar el pedido de pràcticas al Whatsapp del paciente.',48,'Aviso')
*!*					Endif
*!*				Else
*!*					lcresp = "No se puedo enviar. Error: " + Alltrim(Str(loXmlHttp.Status))
*!*					Messagebox(lcresp,16,"Problema con XMLHTTP 1")
*!*				Endif
*!*			Else
*!*				lcresp = "Problema de conexión. Estado: " + Alltrim(Str(loXmlHttp.ReadyState))
*!*				Messagebox(lcresp,16,"Problema con XMLHTTP 2")
*!*			Endif
*!*		Else
*!*			lcresp = "NO ENVIADO - ESTADO: "+Alltrim(Str(loXmlHttp.ReadyState))
*!*			Messagebox(lcresp,16,"Problema con XMLHTTP 3")
*!*		Endif
*!*	Else
*!*		lcresp = "NO ENVIADO - Problema XMLHTTP 4"
*!*		Messagebox(lcresp,16,'Aviso')
*!*	Endif
*!*	Release loXmlHttp

* Modelo de envío 2

Local loHTTP
Local lbResu
lbResu=.T.
loHTTP = Createobject("WinHttp.WinHttpRequest.5.1")
loHTTP.Open("GET", lclink , .F.)
loHTTP.Send()
lbResu = Empty(loHTTP.ResponseText)
loHTTP = Null
Release loHTTP
Return lbResu
Endfunc

* -------------------------------------------------------------------------------------------
* LIMPIO CARACTERES
* -------------------------------------------------------------------------------------------

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

* -------------------------------------------------------------------------------------------
* NORMALIZA WAPP
* -------------------------------------------------------------------------------------------
Function buscowapp(m7temp)

olevism = Newobject('vism','lib_olevism')

olevism.olecontrol1.MServer = Allt(mwktabcfg.OLEServer)
olevism.olecontrol1.NameSpace = Allt(mwktabcfg.olespaces)

mimensaje="D ProcNormalizaCelular^DESPMENS("+m7temp+")"

olevism.olecontrol1.Code = mimensaje
olevism.olecontrol1.execflag = 1

lcolevismerror = olevism.olecontrol1.P0 && error
lcolevismdato = olevism.olecontrol1.P1 && valor
If Empty(lcolevismerror)
	Return lcolevismdato
Else
	Return ""
Endif
Endfunc
