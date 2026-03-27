Parameters pturnoacancelar

* Avisa a Markey cuando se cancela desde el SG un turno.
* 2022-10-19 = Agregado de parámetros: motivo de cancelación / origen

* turnoacancelar = id de la tabla turno de SG - Pasar como ID compuesto (A-1-ID-xxxxxx)
* tipoturno = si es de tabla turno = 1 o turnocancel = 2
* paciente = registracion del paciente (No es obligatorio)

*!*	pturnoacancelar = 20791016
*!*	Do sp_conexion
*!*	Set Step On
** ----------------------- 06/05/2025 - utiliza la tabla tabctromedico
mret = SQLExec(mcon1,"SELECT id as centromedico, ambito from tabctromedico "+;
	" where activo = 1 and ambito = ?mxAmbito and centromedico = ?mxcentromedico and centromedicoMK > 0", "mwkctrlAmbitoCentro")

Select mwkctrlAmbitoCentro
lEncontro =  Reccount("mwkctrlAmbitoCentro")>0
Use In Select("mwkctrlAmbitoCentro")

If !lEncontro
	Return 0
Endif

* ----------------------------------------

turnoacancelar = pturnoacancelar

lturnoacancelar = buscoturno(turnoacancelar,1)

If Vartype(lturnoacancelar)='C'
	lturnoacancelar = Int(Val(lturnoacancelar))
Endif


If !lturnoacancelar>0
	Return 0
Endif

lpaciente = buscoturno(turnoacancelar,2)

Do sp_busco_estados With 61	,' and tipo = 0 ','mwkdesarrollo'&& indica que estamos en prueba
Do Case
Case  mwkdesarrollo.estado = 1
	lclink = "https://serviciosqas.sg.com.ar/api/mk_cancelar_turno.php"
Case  mwkdesarrollo.estado = 2
	lclink = "https://desa.sg.com.ar/api/mk_cancelar_turno.php"
Case  mwkdesarrollo.estado = 0
	lclink = "https://servicios.sg.com.ar/api/mk_cancelar_turno.php"
Endcase
Use In Select('mwkdesarrollo')
lcurl = lclink

lmotivo = 2
If Used('mwkmotivo')
	lmotivo = mwkmotivo.Id
Endif

lclink1 = lcurl + '?CodigoTurno=' + Transform(lturnoacancelar) + '&CodigoPaciente=' + Alltrim(Str(lpaciente)) + '&MotivoCancelacion=' + Alltrim(Str(lmotivo))  + '&Origen=VISUAL'
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

*lcsalida = "ID a cancelar = " + Alltrim(lturnoacancelar) + " - Paciente: " + Alltrim(Str(lpaciente)) + " - Respuesta: " + lcResp + " - URL: " + lclink
*Strtofile(lcsalida,"salidacancelmk.txt")

Release xmlHTTP

abuscar = json(lcResp,"Mensaje")

Messagebox(abuscar,64,"Aviso de Cancelación de Turno")


Function buscoturno(turno,tipo)
lcsql = 'select  afiliado,Nvl(idturnoexterno,0) as externo from turnos where id = '+Alltrim(Str(turno))
mret = SQLExec(mcon1,lcsql,'mwkturnosg')
Do Case
Case tipo = 1
	lcResp = mwkturnosg.externo
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
