Parameters pturnoacancelar

* Avisa a Markey cuando se cancela desde el SG un turno.
* 2022-10-19 = Agregado de parámetros: motivo de cancelación / origen

* turnoacancelar = id de la tabla turno de SG - Pasar como ID compuesto (A-1-ID-xxxxxx)
* tipoturno = si es de tabla turno = 1 o turnocancel = 2
* paciente = registracion del paciente (No es obligatorio)

*pturnoacancelar = 19337287
*Do sp_conexion
*Set Step On

lnconx = ''
lnconx = Left(SQLGetprop(mcon1,'ConnectString'),80)
lsigo = .F.

Do Case
Case  (".190" $ lnconx) && Desarrollo 190
	lsigo = .T.
Case  (".50.110" $ lnconx) && Desarrollo 50.110
	lsigo = .T.
Case  (".50.102" $ lnconx) && QAS 50.102
	lsigo = .T.
Otherwise  && Producción
	lsigo = .T.
Endcase
lsigo=.f.
If !lsigo
	Return 0
Endif

* ----------------------------------------

turnoacancelar = pturnoacancelar

lturnoacancelar = buscoturno(turnoacancelar,1)

lpaciente = buscoturno(turnoacancelar,2)

lcurl = milink(mcon1)

lmotivo = 2
If Used('mwkmotivo')
	lmotivo = mwkmotivo.Id
Endif

lclink1 = lcurl + '?CodigoTurno=' + Alltrim(lturnoacancelar) + '&CodigoPaciente=' + Alltrim(Str(lpaciente)) + '&MotivoCancelacion=' + Alltrim(Str(lmotivo))  + '&Origen=VISUAL'
lclink = Strtran(lclink1,' ','%20')

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

lnServidor = xmlHTTP.Status

If !xmlHTTP.Status = 200
	Messagebox('Tipo de Error: '+Alltrim(Str(xmlHTTP.Status)),48,'Problemas con el Servidor')

Else
* Tratamiento de error de lcResp
Endif

lcsalida = "ID a cancelar = " + Alltrim(lturnoacancelar) + " - Paciente: " + Alltrim(Str(lpaciente)) + " - Respuesta: " + lcResp + " - URL: " + lclink
Strtofile(lcsalida,"salidacancelmk.txt")

Release xmlHTTP

abuscar = json(lcResp,"Mensaje")

Messagebox(abuscar,64,"Aviso de Cancelación de Turno")


Function milink(micon)

lncon = ''
lncon = Left(SQLGetprop(micon,'ConnectString'),80)

Do Case
Case  (".190" $ lncon) && Desarrollo 190
	lclink = "https://desa.sg.com.ar/api/mk_cancelar_turno.php"
Case  (".50.110" $ lncon) && Desarrollo 50.110
	lclink = "https://desa.sg.com.ar/api/mk_cancelar_turno.php"
Case  (".50.102" $ lncon) && QAS 50.102
	lclink = "https://serviciosqas.sg.com.ar/api/mk_cancelar_turno.php"
Otherwise  && Producción
	lclink = "https://servicios.sg.com.ar/api/mk_cancelar_turno.php"
Endcase

Return lclink

Endfunc

Function buscoturno(turno,tipo)
lcsql = 'select * from turnos where id = '+Alltrim(Str(turno))
mret = SQLExec(mcon1,lcsql,'mwkturnosg')
Do Case
Case tipo = 1
	lcResp = mwkturnosg.idturnoexterno
Case tipo = 2
	lcResp = mwkturnosg.afiliado
Endcase
Use In Select('mwkturnosg')
Return lcResp
Endfunc

Function buscoturnocancel(turno)
lidturno = turno
lcsql = 'select * from turnos where id = ?lidtuno'
SQLExec(mcon1,lcsql,'mwkturnosg')
lcResp = mwkturnosg.idturno
Use In Select('mwkturnosg')
Return lcResp
Endfunc

Function idcompuesto(turno)
lcidcomp = "A-"+Alltrim(Str(mxambito))+"-ID-"+Alltrim(Str(turno))
Return lcidcomp
Endfunc

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

