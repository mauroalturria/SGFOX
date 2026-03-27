* Nombre de archivo
Select mwkValeLog
cDestino1 = Alltrim(Str(mwkValeLog.vale))
cDestino2 =  Strtran(Alltrim(mwkpamipacreg.reg_nombrepac),' ','_')
cDestino = cDestino1 + '_' + cDestino2


* Rutina para saber que archivos tengo.

If Used("mwkpamipdf")
	If Reccount("mwkpamipdf")>0

		folderactual = 'C:\qepd1a1\exe\'

* Armanos el BAT que lanzara el Script Merge


		TEXT TO cComando TEXTMERGE NOSHOW PRETEXT 15
	<<m.folderactual>>bin\gswin32c.exe -dBATCH -dNOPAUSE -dCompatibilityLevel=1.4 -dPDFSETTINGS=/printer -dFirstPage=1 -sDEVICE=pdfwrite -sOutputFile=
		ENDTEXT


* Aca busco el nombre del archivo.

		mbuscoarch = Strtran('c:\tempdoc\pami\','\','/') + cDestino + ".pdf"
		cComando = cComando + mbuscoarch

		Select mwkpamipdf
		Go Top In 'mwkpamipdf'
		Scan All
			mNomArch = " " + Alltrim(Strtran(mwkpamipdf.archivo,'\','/'))
			cComando = cComando +mNomArch
		Endscan

		cArchivo = "C:\temp\makepdf.bat"
*cArchivo = cDestinobat

* Creamos el archivo BAT
		Strtofile(cComando,cArchivo)

* Ejecutamos el archivo BAT
		oShell = Createobject("WScript.Shell")
		oShell.Run(cArchivo,0,.T.)

* Abrimos el Archivo fusionado

*		If Thisform.chkverPDF.Value = 1
*!*				cArchivo1 = mbuscoarch
*!*				If File(cArchivo1)
*!*					oShell.Run(cArchivo1,1)
*!*				Endif
*		Endif

*--- Eliminamos el archivo backup.bat
		Delete File (cArchivo)
	Endif
Endif


*!*	If Messagebox(cdestino + '  Mando mail ?',4,'') = 7
*!*	Return .f.
*!*	endif

*!*	If File(mbuscoarch)
*!*	madjunto = Alltrim(Strtran(mbuscoarch,'\','/'))
*!*	Do z_7_pami_envio_mail With madjunto,Strtran(cdestino,'_',' ')
*!*	Do z_8_pami_envio_pac With madjunto,Strtran(cdestino,'_',' ')
*!*	Endif
