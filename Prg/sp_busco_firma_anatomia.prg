* Busco Firma del Profesional (Anatomía)
* 2018/07/25 - Fabián
* ------------------------------------------
Parameters lnIDdoc

* Busco Datos de Prestador para la firma

lcSQL = "SELECT * FROM PRESTADORES WHERE ID = ?lnIDdoc"

mMensaje = ""
mMensaje1 = ""
mMensaje2 = ""

mret = SQLExec(mcon1,lcSQL,"mwkMedicoFirma")

If mret < 1
	mMensaje1 = "Error en Informe Anatomía Patológica: No se obtuvieron los datos de la firma."
	Return .F.
Endif

* Busco la firma:

lcSQL = "SELECT IMAGEN FROM TABMEDFOTO WHERE IDMEDICO = ?lnIDdoc AND TIPO = 3 and fechabaja = '1900-01-01'"

mret = SQLExec(mcon1,lcSQL,"mwkImagenFirma")

If mret < 1
	mMensaje2 = "Error en Informe Anatomía Patológica: No se obtuvo la imágen de la firma."
	Return .F.
Endif

* Busco Imágen de Firmas

Public mlcfirma

lcdirectorio = 'C:\temp\imagenes\firmas'
If !Directory(lcdirectorio)
	Md &lcdirectorio
Endif

If File("C:\temp\imagenes\firmas\firmaanato.tif")
	Erase "C:\temp\imagenes\firmas\firmaanato.tif"
Endif

Select mwkImagenFirma
If Reccount("mwkImagenFirma")>0
	Copy To "C:\temp\imagenes\firmas\firmamed.dbf"
	Use In mwkImagenFirma
	imagen = Fopen("C:\temp\imagenes\firmas\firmamed.dbf",12)
	Fseek(imagen,43)
	Fwrite(imagen,'M')
	Fclose(imagen)
	Use "C:\temp\imagenes\firmas\firmamed.dbf"
	Select firmamed
	lcImagen = imagen
	Strtofile(lcImagen,"C:\temp\imagenes\firmas\firmaanato.tif")
	Use In firmamed
	lcnombre = "C:\temp\imagenes\firmas\firmaanato.tif"
	mlcfirma = lcnombre
	Return 1
Else
*	Messagebox("NO SE ENCUENTRA LA FIRMA DEL PROFESIONAL. AVISAR A SISTEMAS",48,"Impresión de Informes")
	mlcfirma = ""
	Return 0
Endif