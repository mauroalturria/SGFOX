Parameters dato2,dato3,dato4,dato5,dato6,dato9,dato20

Create Cursor mwkafipqr (qrver i(1),qrfecha c(12),qrcuit c(11),qrptoVta c(5),qrtipoCmp c(3),qrnroCmp c(8),;
	qrimporte c(15),qrmoneda c(3),qrctz N(13,6),qrtipoDocRec i(2),qrnroDocRec N(20),;
	qrtipoCodAut c(1),qrcodAut c(14))

* fecha
ldfecha = dato6

* Obtener datos:
lnver=1
lcfecha=Alltrim(Str(Year(ldfecha)))+'-'+Alltrim(Str(Month(ldfecha)))+'-'+Alltrim(Str(Day(ldfecha)))
lncuit='30663434191'
lnptoVta=Alltrim(Str(Val(dato4)))
lntipoCmp=sp_afip_codigo_comprobante(dato3,dato2)
lnnroCmp=dato5
lnimporte=dato9
lcmoneda="PES"
lnctz=1
lntipoDocRec=99
lnnroDocRec=0
lctipoCodAut="E"
lncodAut=dato20

Insert Into mwkafipqr ;
	(qrver,qrfecha,qrcuit,qrptoVta,qrtipoCmp,qrnroCmp,qrimporte,qrmoneda,qrctz,;
	qrtipoDocRec,qrnroDocRec,qrtipoCodAut,qrcodAut) ;
	Values ;
	(lnver,lcfecha,lncuit,lnptoVta,lntipoCmp,lnnroCmp,lnimporte,lcmoneda,lnctz,;
	lntipoDocRec,lnnroDocRec,lctipoCodAut,lncodAut)

Select mwkafipqr
lcurl = 'https://www.afip.gob.ar/fe/qr/?p='
lcjson = '{"ver":'+Alltrim(Str(lnver))+',"fecha":"'+Alltrim(lcfecha)+'","cuit":'+Alltrim(lncuit)+','+;
	'"ptoVta":'+Alltrim(lnptoVta)+',"tipoCmp":'+Alltrim(lntipoCmp)+',"nroCmp":'+Alltrim(lnnroCmp)+','+;
	'"importe":'+Alltrim(lnimporte)+',"moneda":"'+Alltrim(lcmoneda)+'","ctz":'+Alltrim(Str(lnctz))+',"tipoDocRec":'+Alltrim(Str(lntipoDocRec))+','+;
	'"nroDocRec":'+Alltrim(Transform(lnnroDocRec))+',"tipoCodAut":"'+lctipoCodAut+'","codAut":'+Alltrim(lncodAut)+'}'

*Paso a base64
lcdata = Strconv(lcjson,13)
lcdata = Strtran(lcdata, "+", "-")
lcdata = Strtran(lcdata, "/", "_")
lcdata = Strtran(lcdata, "=", "")


*Verifico que estén los archivos necesarios
lcfileorigen = 'X:\qepd1a1\ultimos\exe\qrcodelib.dll'
llhayorigen = File(lcfileorigen)
lcpathactual = Curdir()+'qrcodelib.dll'

If !File(lcpathactual) And llhayorigen
Copy File (lcfileorigen) To (lcpathactual)
Endif

Local lcMiTexto, lcMiArchivoImagen, loQR, lcQR_Imagen
lcMiTexto = lcurl+lcdata
lcMiArchivoImagen = 'C:\temp\afipqr\'
If !Directory(lcMiArchivoImagen)
	Md (lcMiArchivoImagen)
Endif
lcMiArchivoImagen = lcMiArchivoImagen + "afipqr.bmp"
Delete File (lcMiArchivoImagen)
Set Procedure To FOXBARCODEQR Additive
loQR = Createobject("FoxBarCodeQR")
* usando la lib barcodeimage
*lcQR_Imagen = loQR.QRBarCodeImage(lcMiTexto, lcMiArchivoImagen, 6, 2)

* usando la lib qrimage
lcQR_Imagen = loQR.FullQRCodeImage(lcMiTexto,lcMiArchivoImagen,200,0)
Set Procedure To

lhayqr = ''
If File(lcMiArchivoImagen)
	lhayqr = lcMiArchivoImagen
Endif

Use In Select('mwkafipqr')

Return lhayqr

