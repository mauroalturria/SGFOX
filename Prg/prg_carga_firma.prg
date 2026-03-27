&&& carga_firma
Lparameters codigov,mtipo,mlfirma

Release mlcfirma,msolfirma

If mtipo = 1 &&&auditor
	If File("C:\temp\imagenes\firma_ac.tif")
		Erase "C:\temp\imagenes\firma_ac.tif"
	Endif
*busco en tabdocgral la firma y lo grabo en C:\temp\imagenes\firma_ac.jpg
	Do sp_busco_docgral With 19, "frmautor01",,codigov,,"C:\temp\imagenes\firma_ac."
*!*		mPropietario = 38
	If !File("C:\temp\imagenes\firma_ac.tif")
		Do sp_busco_docgral With 19, "frmautor01",,54035,,"C:\temp\imagenes\firma_ac."
	Endif
Else
	If mlfirma

*	busco en tabdocgral la firma y lo grabo en C:\temp\imagenes\firma_ac.jpg
		lcdirectorio = 'C:\temp\imagenes\firmas'
		If !Directory(lcdirectorio)
			Md &lcdirectorio
		Endif

		Do sp_busco_prof_foto With codigov,3   && en codigov trae el id de medico
		Select Top 1 Imagen  As firmag From mprofFoto ;
			order By Id Desc ;
			into Cursor mprofFirma

		If Reccount('mprofFirma') =0
			mlfirma = .F.
		Else
			If Isnull(mprofFirma.firmag)
				mlfirma = .F.
			Else
				If File("C:\temp\imagenes\firmas\firma_ms.tif")
					Erase "C:\temp\imagenes\firmas\firma_ms.tif"
				Endif
				If File("C:\temp\imagenes\firmas\firma_ms.tif")
					Messagebox("NO SE PUDO RECUPERAR LA FIRMA DEL PROFESIONAL!!"+Chr(13)+;
						"SALGA TOTALMENTE DE LA APLICACION Y VUELVA A INGRESAR" +Chr(13)+;
						"SI PERSISTE EL ERROR COMUNIQUESE CON SISTEMAS",48,"ALERTA")
					mlfirma = .F.
					Return
				Endif

				If Used('ima')
					Use In ima
				Endif

				If Used('__DATA')
					Use In __DATA
				Endif

				If Used ('imagen')
					Use In Imagen
				Endif

				If File("C:\temp\imagenes\firmas\imagen.dbf")
					Erase ("C:\temp\imagenes\firmas\imagen.dbf")
				Endif
				If File("C:\temp\imagenes\firmas\imagen.dbf")
					Messagebox("NO SE PUDO RECUPERAR LA FIRMA DEL PROFESIONAL!!"+Chr(13)+;
						"SALGA TOTALMENTE DE LA APLICACION Y VUELVA A INGRESAR" +Chr(13)+;
						"SI PERSISTE EL ERROR COMUNIQUESE CON SISTEMAS",48,"ALERTA")
					mlfirma = .F.
					Return
				Endif
				If File("C:\temp\imagenes\firmas\imagen.fpt")
					Erase ("C:\temp\imagenes\firmas\imagen.fpt")
				Endif
				If File("C:\temp\imagenes\firmas\imagen.fpt")
					Messagebox("NO SE PUDO RECUPERAR LA FIRMA DEL PROFESIONAL!!"+Chr(13)+;
						"SALGA TOTALMENTE DE LA APLICACION Y VUELVA A INGRESAR" +Chr(13)+;
						"SI PERSISTE EL ERROR COMUNIQUESE CON SISTEMAS",48,"ALERTA")
					mlfirma = .F.
					Return
				Endif

				Select mprofFirma
				Copy To "C:\temp\imagenes\firmas\imagen"
				Use In mprofFirma

* cambia el campo grneral de tipo memo
				LL = Fopen("C:\temp\imagenes\firmas\imagen.dbf",12)
				Fseek(LL,43)
				Fwrite(LL,'M')
				Fclose(LL)
				If Used('__DATA')
					Use In __DATA
				Endif
				If Used ('imagen')
					Use In Imagen
				Endif
				If Used('mprofFirma')
					Use In mprofFirma
				Endif
				lcdirectorio = 'C:\temp\imagenes\firmas'
				lcnombre    = 'C:\temp\imagenes\firmas\firma_ms.tif'
				Use C:\temp\imagenes\firmas\Imagen.Dbf In 0 Alias mFirma
				lfile = mFirma.firmag
				lok = Strtofile(lfile ,lcnombre)
				lcnombre    = 'C:\temp\imagenes\firmas\firma_ms.tif'
				Use In Select("mFirma")

				=Adir(acontrolfirma,"C:\temp\imagenes\firmas\firma_ms.tif")
				If File("C:\temp\imagenes\firmas\firma_ms.tif")
					If acontrolfirma(1,2)<10
						Messagebox("NO SE PUDO RECUPERAR LA FIRMA")
						Erase "C:\temp\imagenes\firmas\firma_ms.tif"
					Endif
				Endif
			Endif
		Endif
	Endif
Endif


Return
