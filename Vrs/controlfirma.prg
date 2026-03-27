*Close Tables
*ultimo proceso 08/09
*MCON1 = Sqlconnect("172.16.1.4")
*MCON1 = Sqlconnect("172.16.1.190")
do sp_conexion
set step on
mfecpas = ctod('01-01-1900')
*** ultima actualizacion 23/06/2016
mret = sqlexec(mcon1,"select idmedico FROM TabMedFoto,prestadores  where prestadores.id = idmedico and  TabMedFoto.FechaBaja = ?mfecpas"+;
	" and tipo = 3 and prestadores.fecpasivap= ?mfecpas ","mprofFotList")
*mret = SQLExec(mcon1,"select * FROM TabMedFoto where  FechaToma > '2016-09-01' and tipo = 2  order by id desc ","mprofFotList")
*!*	mret = SQLExec(mcon1,"select * FROM TabMedFoto where  FechaBaja = ?mfecpas and tipo = 2 and idmedico in (374) order by id desc ","mprofFotList")
**   and idmedico = 4229
*!*	mret = SQLExec(mcon1,"select ID FROM TabMedFoto where idmedico = ?midmed and "+;
*!*			" FechaBaja = ?mfecpas and tipo = ?mtipo ","mprofFotoctr")

if mret <= 0
	?"ERROR CONSULTA 1 "
	return .f.
endif


select mprofFotList
scan all
	wait windows transform(mprofFotList.idmedico) nowait
	codigov = mprofFotList.idmedico
	mtipo = 2
	release mlcfirma,msolfirma ,lfile ,lok
	lcdirectorio = 'C:\temp\imagenes\firmas'
	if !directory(lcdirectorio)
		md &lcdirectorio
	endif
	mret = SQLExec(mcon1,"select ID , FechaBaja , FechaToma , IdMedico "+;
	", Imagen,Tipo FROM TabMedFoto where idmedico = ?codigov and tipo = 3 and FechaBaja = ?mfecpas","mprofFoto")
	select top 1 Imagen  as firmag from mprofFoto ;
		order by id desc ;
		into cursor mprofFirma
	lcfirma = "C:\temp\imagenes\firmas\" + alltrim(transform(codigov)) + "_firma_ms.tif"

	if reccount('mprofFirma') =0
	else
		if isnull(mprofFirma.firmag)
		else

			if file(lcfirma )
				erase lcfirma
			endif
			if file(lcfirma )
				messagebox("NO SE PUDO RECUPERAR LA FIRMA DEL PROFESIONAL!!"+chr(13)+;
					"SALGA TOTALMENTE DE LA APLICACION Y VUELVA A INGRESAR" +chr(13)+;
					"SI PERSISTE EL ERROR COMUNIQUESE CON SISTEMAS",48,"ALERTA")
				set step on
			endif

			if used('ima')
				use in ima
			endif

			if used('__DATA')
				use in __DATA
			endif

			if used ('imagen')
				use in Imagen
			endif

			if file("C:\temp\imagenes\firmas\imagen.dbf")
				erase ("C:\temp\imagenes\firmas\imagen.dbf")
			endif
			if file("C:\temp\imagenes\firmas\imagen.dbf")
				messagebox("NO SE PUDO RECUPERAR LA FIRMA DEL PROFESIONAL!!"+chr(13)+;
					"SALGA TOTALMENTE DE LA APLICACION Y VUELVA A INGRESAR" +chr(13)+;
					"SI PERSISTE EL ERROR COMUNIQUESE CON SISTEMAS",48,"ALERTA")
				set step on
			endif
			if file("C:\temp\imagenes\firmas\imagen.fpt")
				erase ("C:\temp\imagenes\firmas\imagen.fpt")
			endif
			if file("C:\temp\imagenes\firmas\imagen.fpt")
				set step on
			endif

			select mprofFirma
			copy to "C:\temp\imagenes\firmas\imagen"
			use in mprofFirma

* cambia el campo grneral de tipo memo
			LL = fopen("C:\temp\imagenes\firmas\imagen.dbf",12)
			fseek(LL,43)
			fwrite(LL,'M')
			fclose(LL)
			if used('__DATA')
				use in __DATA
			endif
			if used ('imagen')
				use in Imagen
			endif
			if used('mprofFirma')
				use in mprofFirma
			endif
			lcdirectorio = 'C:\temp\imagenes\firmas'
			lcnombre    = lcfirma
			use C:\temp\imagenes\firmas\imagen.dbf in 0 alias mFirma
			lfile = mFirma.firmag
			lok = strtofile(lfile ,lcnombre)
			lcnombre    = lcfirma
			use in select("mFirma")
		endif
	endif

endscan

do sp_desconexion
return .f.


*!*------------------------------------------------------------------------------------------------------------------------------
procedure Obt_Foto
	parameters codigov
*!*------------------------------------------------------------------------------------------------------------------------------

	lcdirectorio = 'C:\temp\imagenes\firmas'
	if !directory(lcdirectorio)
		md &lcdirectorio
	endif
	if file("C:\temp\imagenes\firmas\firma_ms.sig")
		erase "C:\temp\imagenes\firmas\firma_ms.sig"
	endif
	if file("C:\temp\imagenes\firmas\firma_ms.sig")
		.lfirma = .f.
		return
	endif
	if file("C:\temp\imagenes\firmas\firma_ms.tif")
		erase "C:\temp\imagenes\firmas\firma_ms.tif"
	endif
	if file("C:\temp\imagenes\firmas\firma_ms.tif")
		.lfirma = .f.
		return
	endif

*Do sp_busco_prof_foto With codigov,2   && en codigov trae el id de medico


	mfecpas = ctod("01/01/1900")
	mret = sqlexec(mcon1,"select ID , FechaBaja , FechaToma , IdMedico "+;
		", Imagen,Tipo FROM TabMedFoto where idmedico = ?codigov and Tipo  = 2 "  ,"mprofFoto")

	select top 1 Imagen  as firmag from mprofFoto ;
		order by id desc ;
		into cursor mprofFirma

	if reccount('mprofFirma') = 0
		?"NO TIENE FIRMA"
		return .f.
	endif
	if isnull(mprofFirma.firmag)
		return .f.
	endif
*!*------------------------------------------------------------------------------------------------------------------------------
	if used('ima')
		use in ima
	endif

	if used('__DATA')
		use in __DATA
	endif

	if used ('imagen')
		use in Imagen
	endif

	if file("C:\temp\imagenes\firmas\imagen.dbf")
		erase ("C:\temp\imagenes\firmas\imagen.dbf")
	endif
	if file("C:\temp\imagenes\firmas\imagen.dbf")
		return
	endif
	if file("C:\temp\imagenes\firmas\imagen.fpt")
		erase ("C:\temp\imagenes\firmas\imagen.fpt")
	endif
	if file("C:\temp\imagenes\firmas\imagen.fpt")
		return
	endif


	select mprofFirma
	copy to "C:\temp\imagenes\firmas\imagen"
	use in mprofFirma

* cambia el campo grneral de tipo memo
	LL = fopen("C:\temp\imagenes\firmas\imagen.dbf",12)
	fseek(LL,43)
	fwrite(LL,'M')
	fclose(LL)
	if used('__DATA')
		use in __DATA
	endif
	if used ('imagen')
		use in Imagen
	endif
	if used('mprofFirma')
		use in mprofFirma
	endif
	lcdirectorio = 'C:\temp\imagenes\firmas'
	lcnombre    = 'C:\temp\imagenes\firmas\firma_ms.sig'
	use C:\temp\imagenes\firmas\Imagen.dbf in 0 alias mFirma
	lfile = mFirma.firmag
	lok = strtofile(lfile ,lcnombre)
	lcnombre    = 'C:\temp\imagenes\firmas\firma_ms.sig'
	if !file(lcnombre)
		?"no esta el archivo"
		return .f.
	endif

	set classlib to "c:\desaguemes\lib\lib_fbases_sg.vcx"
	local oForm as form

	oForm = newobject("Form")
	oForm.addobject("Olefirmaguardar","firma")

*Local Olefirmaguardar as "SIGPLUS.SigPlusCtrl.1"
*!*	Olefirmaguardar=Createobject("SIGPLUS.SigPlusCtrl.1")
*oForm.Olefirmaguardar.sigCompressionMode = 0
*oForm.Olefirmaguardar.encryptionMode = 0

*oForm.Olefirmaguardar.DisableMessageBoxes(1)

	oForm.Olefirmaguardar.Importsigfile(lcnombre)

*Use C:\temp\imagenes\firmas\Imagen.Dbf In 0 Alias mFirma
	lfile = mFirma.firmag
	lok = strtofile(lfile ,lcnombre)
	lcfirma = "C:\temp\imagenes\firmas\" + alltrim(transform(codigov)) + "_firma_ms.tif"
	oForm.Olefirmaguardar.Imagefileformat= 6
	oForm.Olefirmaguardar.Writeimagefile(lcfirma)
	use in select("mFirma")
	oForm.release
	oForm = null

	if file(lcfirma)
		lcarchivo = filetostr(lcfirma)
*!*		If !sp_grabo_prof_foto(codigov,'"'+lcarchivo+'"',3)
*!*			Return .F.
*!*		Endif
		use in select("mprofFotoctr")
*	Delete File (lcfirma)
	endif

*!*				*!* ------------------ Firma "electrónica" ---------------------------------------------------
*!*				lcdirectorio = 'C:\temp\imagenes\firmas\'  + Alltrim(Str(mwkprestador.Id))
*!*				lcnombre     = lcdirectorio  +'\' + Alltrim(Str(mwkprestador.Id))  + '.sig'

*!*				If File(lcnombre)
*!*					lcarchivo = Filetostr(lcnombre)
*!*					If !sp_grabo_prof_foto(mcodid,lcarchivo,2)
*!*						Return .F.
*!*					Endif

*!*					Use In Select("mprofFotoctr")
*!*					Erase &lcnombre
*!*					Rd &lcdirectorio
*!*					Endif
