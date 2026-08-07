Lparameters dFecDesde, dFecHasta

Local lcComandoCreate
Local lnLineas
Local lcLineas
Local lnI
Local lcNombre
Local lcTipo
Local lcAncho
Local lcDec
Local nRespuesta
Local oIn
Local mFecDesde
Local mFecHasta
Local xmlHTTP
Local loStream

nRespuesta = 1

*!*	*1. Generar estructura de cursor
*!*	TEXT To lcContenido Textmerge Noshow Pretext 7
*!*	TQP_ESTADO           |   N  |     4 |   0
*!*	IDPROTO              |   N  |     4 |   0
*!*	TQP_HORAINI          |   T  |     8 |   0
*!*	TQP_URGENCIA         |   N  |     4 |   0
*!*	CODADMISION          |   C  |     8 |   0
*!*	PACNOMBRE            |   C  |    50 |   0
*!*	NROPROTOCOLO         |   N  |     4 |   0
*!*	TQC_NROVALEQ         |   N  |     4 |   0
*!*	TQC_HORALLEGA        |   T  |     8 |   0
*!*	TQC_HORASALIDA       |   T  |     8 |   0
*!*	PAC_TIPOPAC          |   I  |     4 |   0
*!*	PAC_FECHAADMISION    |   D  |     8 |   0
*!*	PAC_FECHAALTA        |   D  |     8 |   0
*!*	TQS_SALA             |   C  |     3 |   0
*!*	FECHAQUIROF          |   D  |     8 |   0
*!*	ESTADOQ              |   C  |    50 |   0
*!*	TQS_HABILILITADO     |   I  |     4 |   0
*!*	HORAINGRE            |   I  |     4 |   0
*!*	CODMED               |   I  |     4 |   0
*!*	IDQUIRO              |   I  |     4 |   0
*!*	TQC_NROVALEQS        |   I  |     4 |   0
*!*	TQC_NROVALEQFS       |   I  |     4 |   0
*!*	REG_NROHCLINICA      |   C  |    10 |   0
*!*	REG_SEXO             |   C  |     9 |   0
*!*	EDAD                 |   I  |     4 |   0
*!*	TQC_HORALLEGA        |   T  |     8 |   0
*!*	TQC_HORAINIANESMED   |   T  |     8 |   0
*!*	TQP_HORAINI          |   T  |     8 |   0
*!*	TQP_HORAFIN          |   T  |     8 |   0
*!*	TQC_HORAFINANESMED   |   T  |     8 |   0
*!*	TQC_HORASALIDA       |   T  |     8 |   0
*!*	ENT_CODENT           |   N  |     8 |   0
*!*	ENT_DESCRIENT        |   C  |    45 |   0
*!*	CAMASOLIC            |   L  |     1 |   0
*!*	NROQUIROFANO         |   I  |     4 |   0
*!*	SER_DESCRIPSERV      |   C  |    30 |   0
*!*	QUIROFANO            |   I  |     4 |   0
*!*	TQC_NROQUIRO         |   C  |    50 |   0
*!*	DIAGNOSTICO          |   C  |   250 |   0
*!*	OPERACION            |   C  |   250 |   0
*!*	NROREGISTRAC         |   N  |     9 |   0
*!*	ADMISION             |   C  |    20 |   0
*!*	EXISTEVALEQ          |   I  |     4 |   0
*!*	PRE_DESCRIPREST      |   C  |    48 |   0
*!*	VERIFICADO           |   L  |     1 |   0
*!*	TQP_ESTADO           |   I  |     4 |   0
*!*	PAC_CODAMBITO        |   I  |     4 |   0
*!*	PAC_CENTROMEDICO     |   N  |     4 |   0
*!*	CODAMBITO2           |   I  |     4 |   0
*!*	CENTROMEDICO2        |   N  |     4 |   0
*!*	PAC_FECHAADMISION2   |   D  |     8 |   0
*!*	PAC_FECHAALTA2       |   D  |     8 |   0
*!*	ENDTEXT


Do sp_busco_estados With 57," and tipo = 96", "mwkQuiroWeb"

Select mwkQuiroWeb
Go Top

If mwkQuiroWeb.estado = 1
	lcUrl = Alltrim(mwkQuiroWeb.Descrip)
Endif

**lcUrl = "http://localhost/profesional/Api/facturacion/sp_busco_factura_quiro.php"

Use In Select("mwkQuiroWeb")

mFecDesde = Dtos(dFecDesde)
mFecHasta = Dtos(dFecHasta)

mFecDesde = Left(mFecDesde,4)+"-"+Substr(mFecDesde,5,2)+"-"+ Right(mFecDesde,2)
mFecHasta = Left(mFecHasta,4)+"-"+Substr(mFecHasta,5,2)+"-"+ Right(mFecHasta,2)

nRespuesta = fCargaDatos(mFecDesde,mFecHasta, lcUrl)


Return nRespuesta


** -----------------------------------------
Function fCargaDatos(mFecDesde,mFecHasta, lcUrl)
** -----------------------------------------
Local lcJson
Local lOk
Local nCuenta
Local lResult
Local lcResp
Local nRespuesta
Local lnServidor
Local xmlHTTP
Local lcOldDate, lcOldMark, lnOldCent

lcOldDate = Set("DATE")
lnOldCent = Set("CENTURY")
lcOldMark = Set("MARK")
lcJson = ""
lResult = .t.

TEXT To lcJson Textmerge Noshow Pretext 7
{
    "dDesde": "<<mFecDesde>>",
    "dHasta": "<<mFecHasta>>"
}
ENDTEXT

lOk = prg_crea_xmlhttp(@xmlHTTP)

If lOk

	xmlHTTP.Open("POST", lcUrl, .F.)
	xmlHTTP.setRequestHeader("Content-Type","application/json")
	xmlHTTP.setTimeouts(60000, 60000, 60000, 600000)    &&para que espere 60 segundos la consulta

	xmlHTTP.Send(lcJson)

	nCuenta = 0

	Do While xmlHTTP.readyState<>4
		DoEvents

		nCuenta = nCuenta + 1
		If nCuenta >= 1000
			lResult = .F.
			Exit
		Endif
	Enddo


	If xmlHTTP.Status = 200 AND lResult
* Si el servicio devuelve el archivo en formato binario/texto en la respuesta:
*lcRespuesta = xmlHTTP.responseBody

* 3. Usar ADODB.Stream para guardar el binario directo a disco
		loStream = Createobject("ADODB.Stream")
		loStream.Type = 1  &&adTypeBinary
		loStream.Open()
		loStream.Write(xmlHTTP.responseBody)

* Guardar archivo (2 = Sobrescribir si ya existe)
		loStream.SaveToFile("c:\temp\archivo_recibido.csv", 2)
		loStream.Close()

		If fCreaArchivoDBF()
*           Config necesaria para parsear las fechas ISO "yyyy-mm-dd hh:mm:ss" del CSV ---
			Set Century On
			Set Date To YMD
			Set Mark To "-"
			Set Hours To 24

			Try
				Append From c:\temp\archivo_recibido.Csv Delimited With Character ";"
*           Descartar la fila de encabezado que se importa como registro 1 ---
				Go Top
				Delete

			Catch To oErr

				Messagebox("Error al armar cursor. " +Chr(10)+ oErr.Message, 16, "Cursor temporal")
				lResult = .f.

			Endtry

*           Restaurar configuracion regional ---
			Set Date To &lcOldDate
			Set Century &lnOldCent
			Set Mark To &lcOldMark
		Endif

	Else
		Messagebox("Error: " + Alltrim(Str(xmlHTTP.Status)) + " - " + xmlHTTP.responseText, 16, "Error de consulta")
		lResult = .f.
	Endif


	Release xmlHTTP

Else

	Messagebox("No se pudo consultar el servicio Facturaciónn-Quirofano. Error xmlHTTP",16,"Comunicación")
	lResult = .f.

Endif

objson = Null

Return lResult

* ----------------------------------------------
Function fCreaArchivoDBF()

Use In Select("mwkProtocolos1")

Create Cursor mwkProtocolos1 (;
	TQP_ESTADO N(4,0),;
	IDPROTO N(10,0),;
	TQP_HORAINI T ,;
	TQP_URGENCIA N(4,0),;
	CODADMISION C(10),;
	PACNOMBRE C(50),;
	NROPROTOCOLO N(10,0),;
	TQC_NROVALEQ N(10,0) ,;
	TQC_HORALLEGA T ,;
	TQC_HORASALIDA T ,;
	PAC_TIPOPAC I,;
	PAC_FECHAADMISION d ,;
	PAC_FECHAALTA d ,;
	TQS_SALA C(5) ,;
	FECHAQUIROF d ,;
	ESTADOQ C(50) ,;
	TQS_HABILITADO N(4,0) ,;
	HORAINGRE N(4,0) , ;
	CODMED N(10,0) , ;
	IDQUIRO N(12,0) , ;
	TQC_NROVALEQS N(12,0) , ;
	TQC_NROVALEQFS N(12,0) , ;
	REG_NROHCLINICA C(10) , ;
	REG_SEXO C(3) , ;
	EDAD N(3,0) , ;
	TQC_HORAINIANESMED T  , ;
	TQP_HORAFIN T  , ;
	TQC_HORAFINANESMED T  , ;
	ENT_CODENT N(8,0) , ;
	ENT_DESCRIENT C(45) , ;
	CAMASOLIC L ,;
	NROQUIROFANO N(4,0) , ;
	SER_DESCRIPSERV C(30) , ;
	QUIROFANO N(15,0) , ;
	TQC_NROQUIRO N(15,0) , ;
	DIAGNOSTICO C(100) , ;
	OPERACION C(150) , ;
	NROREGISTRAC N(15,0) , ;
	ADMISION C(20) , ;
	EXISTEVALEQ N(1,0) , ;
	PRE_DESCRIPREST C(50) , ;
	VERIFICADO L , ;
	PAC_CODAMBITO N(3,0) , ;
	PAC_CENTROMEDICO N(4,0) , ;
	CODAMBITO2 N(3,0) , ;
	CENTROMEDICO2 N(4,0) , ;
	PAC_FECHAADMISION2 d , ;
	PAC_FECHAALTA2 d )

Return .T.

