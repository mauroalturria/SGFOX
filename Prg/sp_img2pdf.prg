Parameters Imagen

Local lcUrl, lcImagenPath, lcContenido, loHttp

* Conversión de imágenes JPG a PDF - Fabiánn 2026-06-03

*Do sp_conexion

Do sp_busco_estados With  57, " and tipo = 94", "mwkURL"

Select mwkURL
lcUrl = Alltrim(mwkURL.Descrip)

 
*!*	If !Vartype("Imagen")="C"
	lcImagenPath = Imagen
*!*	Else
*!*		lcImagenPath = Getfile("jpg")
*!*	Endif


If !File(lcImagenPath)
	Messagebox("El archivo de imagen no existe.", 16, "Error")
	Return
Endif


lcContenido = Filetostr(lcImagenPath)
lcContenidoBase64 = Strconv(lcContenido, 13)
lcNombre = Justfname(lcImagenPath)
lcNombreArchivo = Sys(2015)+".jpg"


loHttp = Createobject("WinHttp.WinHttpRequest.5.1")
loHttp.Open("POST", lcUrl, .F.)

loHttp.SetRequestHeader("Content-Type", "image/jpeg")
loHttp.SetRequestHeader("File-Name", lcNombreArchivo)

lcRespuesta = ""

Try
	loHttp.Send(lcContenidoBase64)

	If loHttp.Status = 200
		lcPdfBin = loHttp.ResponseBody
*STRTOFILE(lcPdfBin, "informe.pdf")
		lcRespuesta = lcPdfBin
	Else
		Messagebox("Error en el servidor: " + Str(loHttp.Status), 48, "Error al Convertir PDF")
	Endif
Catch To loError
	Messagebox("Error de conexión: " + loError.Message, 16, "Error al Convertir PDF")
Endtry

Return lcRespuesta