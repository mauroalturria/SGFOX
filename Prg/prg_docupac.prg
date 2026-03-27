Parameters archivolocal,archivoftp

Do sp_busco_estados With 57,' and Tipo = 52 and Estado = 1','mwkLink'

If Reccount('mwkLink')=0
	Messagebox('Error al subir documentos al servidor'+Chr(10)+'Tipo de Error: URL no habilitada',48,'AVISO')
	Return 0
Endif

Select mwkLink
lcLink = Alltrim(mwkLink.descrip)

If Empty(lcLink)
	Messagebox('Error al subir documentos al servidor'+Chr(10)+'Tipo de Error: No existe URL',48,'AVISO')
	Return 0
Endif

Use In Select('mwkLink')

mArchivoftp_0 = archivoftp
mArchivopdf = archivolocal

lfecha = sp_busco_fecha_serv('DD')

lfolder_a  = Alltrim(Str(Year(lfecha)))
lfolder_m = Padl(Alltrim(Str(Month(lfecha))),2,'0')
lfolder_d  = Padl(Alltrim(Str(Day(lfecha))),2,'0')

lfolder = lfolder_a + lfolder_m + lfolder_d

mArchivoftp = lfolder + '/' + mArchivoftp_0 + '.pdf'

clavepre = Sys(2015)
clave = Right(clavepre,Len(clavepre)-1)

midata = Strconv(Filetostr(mArchivopdf),13)

cfile = mArchivopdf
miinforme = ""

lcsql = "INSERT INTO ZabDocuPacTmp (DPT_binario, DPT_clave, DPT_ruta) VALUES(?midata,?clave, ?mArchivoFTP)"

mret = SQLExec(mcon1,lcsql)

lcsql = ""


If mret>0

	lcUcnroregisRL = lcLink+"?id="+Alltrim(clave)+"&tipo=2"

	Strtofile(lcUcnroregisRL,"miurl.txt")

	Local xmlHTTP As "Microsoft.XMLHTTP"
	xmlHTTP = Createobject("Microsoft.XMLHTTP")

	If Alltrim(Type("xmlHTTP")) <> "O"
		Messagebox( "No se pudo crear el objeto (XMLHTTP).",48,"Aviso")
		Return
	Endif

	xmlHTTP.Open("GET", lcUcnroregisRL , .F.)

*xmlHTTP.setRequestHeader ("Content-Type", "text/xml;charset=utf-8")

*xmlHTTP.setRequestHeader ("Authorization","94ecbc1edeee37aaef258dd36bed9888")

*xmlHTTP.Send(lcXML)

	xmlHTTP.Send()

	Do While xmlHTTP.readyState<>4
		DoEvents
	Enddo

	lnServidor = xmlHTTP.Status


	If !lnServidor = 200
		Messagebox('Error en guardar el documento.' +Chr(10)+'Tipo de Error: '+Transform(lnServidor)+Chr(10)+'Mensaje: ' + errorservidor(lnServidor), 16 , 'Documentación ')
		mArchivoftp = ""
	Else
		lcResp = xmlHTTP.responseText
	Endif

	Release xmlHTTP

	Return mArchivoftp

Endif


Function errorservidor(nro)
Do Case
Case nro = 400
	mensaje = "Solicitud Incorrecta"
Case nro = 404
	mensaje = "No se encuentra el documento solicitado"
Otherwise
	mensaje = "Tipo de Error no definido"
Endcase
Return mensaje
Endfunc
