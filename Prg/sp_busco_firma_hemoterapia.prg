
* Busco Firma del Profesional de Hemoterapia
* 2016/10/28 - Fabián
* ------------------------------------------

Lparameters lnTipo && 1 = Imprime / 2 = Reimprime

*ldHoy = sp_busco_fecha_serv("DD")

*!*	Do Case

*!*	Case lnTipo = 2
*!*	* Crear tabla de control de reimpresión con firma del profesional
*!*	* Por ahora usar:
*!*	* Dra Porrino para estas fechas anteriores
*!*		lnID = 2312 && Prestadores
*!*	Case lnTipo = 1
*!*	* Dra Dabusti para estas fechas posteriores
*!*		lnID = 4975
*!*	Otherwise
*!*		lnID = 0
*!*	Endcase

* 2018/12 Se pidió agregar en TabEstado / Propietario 7 / Tipo 58 el código del Médico que Firma
* A partir de esta fecha y hasta nuevo aviso hay que dejar a Dra. Porrino

lcSQL = 'select * from tabestados where propietario = 7 and tipo = 58'
If !Prg_EjecutoSql(lcSQL,"mwkIdCodMedFirma")
	Return .F.
Endif
If !Used('mwkIdCodMedFirma')
	Messagebox('Error en la obtención de la firma. No hay cursor generado',48,'Error Código de Firma Mèdica')
	Return .F.
Endif

lnID = mwkIdCodMedFirma.estado

* Busco Datos de Prestador para la firma

lcSQL = "SELECT * FROM PRESTADORES WHERE ID = ?lnID"
If !Prg_EjecutoSql(lcSQL,"mwkMedicoFirma")
	Messagebox(Upper("Error en la conexión. No se obtuvieron los datos de la firma."),48,"Impresión de Reporte de Hemoterapia")
	Return .F.
Endif

* Busco Foto

lcSQL = "SELECT IMAGEN FROM TABMEDFOTO WHERE IDMEDICO = ?lnID AND TIPO = 3 and fechabaja = '1900-01-01'"
If !Prg_EjecutoSql(lcSQL,"mwkImagenFirma")
	Messagebox(Upper("Error en la conexión. No se obtuvo la firma."),48,"Impresión de Reporte de Hemoterapia")
	Return .F.
Endif

* Busco Imágen de Firmas

Public mlcfirma

lcdirectorio = 'C:\temp\imagenes\firmas'
If !Directory(lcdirectorio)
	Md &lcdirectorio
Endif

If File("C:\temp\imagenes\firmas\firmahemot.jpg")
	Erase "C:\temp\imagenes\firmas\firmahemot.jpg"
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
	Strtofile(lcImagen,"C:\temp\imagenes\firmas\firmahemot.jpg")
	Use In firmamed
Else
*	Messagebox("NO SE ENCUENTRA LA FIRMA DEL PROFESIONAL. AVISAR A SISTEMAS",48,"Impresión de Reporte de Hemoterapia")
	mlcfirma = ""
	Return 0
Endif

lcnombre = "C:\temp\imagenes\firmas\firmahemot.jpg"
mlcfirma = lcnombre
Select mwkmedicofirma
Return 1
