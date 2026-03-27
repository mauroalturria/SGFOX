*Close Tables
*ultimo proceso 06/09/2017 23/08/2017  22/06/2017 - 19/05/2017
*MCON1 = Sqlconnect("172.16.1.4")
*MCON1 = Sqlconnect("172.16.1.190")
DO sp_conexion
mfecpas = Ctod('01-01-1900')
*** ultima actualizacion 23/06/2016
* mret = SQLExec(mcon1,"select * FROM TabMedFoto where  FechaBaja = ?mfecpas and tipo = 2 and idmedico in (5122,5123,5129,5131,5132,5133,5135,5137) order by id desc ","mprofFotList")
*mret = SQLExec(mcon1,"select * FROM TabMedFoto where  FechaToma >= '2017-08-23' and tipo = 2  order by id desc ","mprofFotList")
mret = SQLExec(mcon1,"select TabMedFoto.* FROM TabMedFoto,PRESTADORES where  idmedico = PRESTADORES.ID AND fecpasivap = '1900-01-01' AND  FechaBaja = ?mfecpas and tipo = 3    ","mprofFotList")
**   and idmedico = 4229 
*!*	mret = SQLExec(mcon1,"select ID FROM TabMedFoto where idmedico = ?midmed and "+;
*!*			" FechaBaja = ?mfecpas and tipo = ?mtipo ","mprofFotoctr")
SET STEP ON
If mret <= 0
	?"ERROR CONSULTA 1 "
	Return .F.
Endif 


Select mprofFotList
Scan ALL
	wait windows transform(mprofFotList.idmedico) nowait
	use in select("mFirma")
	Use In Select("Imagen")
	=Obt_Foto(mprofFotList.idmedico)
	Use In Select("Imagen")
	use in select("mFirma")
Select mprofFotList
Endscan 

do sp_desconexion
Return .F.


*!*------------------------------------------------------------------------------------------------------------------------------
Procedure Obt_Foto
Parameters codigov
*!*------------------------------------------------------------------------------------------------------------------------------

lcdirectorio = 'C:\temp\imagenes\firmas'
If !Directory(lcdirectorio)
	Md &lcdirectorio
Endif
If File("C:\temp\imagenes\firmas\firma_ms.tif")
	Erase "C:\temp\imagenes\firmas\firma_ms.tif"
Endif
If File("C:\temp\imagenes\firmas\firma_ms.tif")
	.lfirma = .F.
	Return
Endif
If File("C:\temp\imagenes\firmas\firma_ms.tif")
	Erase "C:\temp\imagenes\firmas\firma_ms.tif"
Endif
If File("C:\temp\imagenes\firmas\firma_ms.tif")
	.lfirma = .F.
	Return
Endif

*Do sp_busco_prof_foto With codigov,2   && en codigov trae el id de medico


mfecpas = ctod("01/01/1900")
mret = SQLExec(mcon1,"select ID , FechaBaja , FechaToma , IdMedico "+;
	", Imagen,Tipo FROM TabMedFoto where idmedico = ?codigov and Tipo  = 3 "  ,"mprofFoto")

Select Top 1 Imagen  As firmag From mprofFoto ;
	order By Id Desc ;
	into Cursor mprofFirma

If Reccount('mprofFirma') = 0
	?"NO TIENE FIRMA"
	Return .F.
Endif 	
If Isnull(mprofFirma.firmag)
	Return .F.
Endif 	
*!*------------------------------------------------------------------------------------------------------------------------------
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
	Return
Endif
If File("C:\temp\imagenes\firmas\imagen.fpt")
	Erase ("C:\temp\imagenes\firmas\imagen.fpt")
Endif
If File("C:\temp\imagenes\firmas\imagen.fpt")
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
If !File(lcnombre)
	?"no esta el archivo"
	Return .f.
Endif 

*!*	set classlib to "c:\desaguemes\lib\lib_fbases_sg.vcx"
*!*	Local oForm as Form

*!*	oForm = Newobject("Form")
*!*	oForm.AddObject("Olefirmaguardar","firma")

*Local Olefirmaguardar as "SIGPLUS.SigPlusCtrl.1"
*!*	Olefirmaguardar=Createobject("SIGPLUS.SigPlusCtrl.1")
*oForm.Olefirmaguardar.sigCompressionMode = 0
*oForm.Olefirmaguardar.encryptionMode = 0

*oForm.Olefirmaguardar.DisableMessageBoxes(1)

**********************oForm.Olefirmaguardar.Importsigfile(lcnombre)

*Use C:\temp\imagenes\firmas\Imagen.Dbf In 0 Alias mFirma
*!*	lfile = mFirma.firmag
*!*	lok = Strtofile(lfile ,lcnombre)
*!*	lcfirma = "C:\temp\imagenes\firmas\" + Alltrim(Transform(codigov)) + "_firma_ms.tif"
*!*	oForm.Olefirmaguardar.Imagefileformat= 6
*!*	oForm.Olefirmaguardar.Writeimagefile(lcfirma)
*!*	use in select("mFirma")
*!*	oForm.Release
*!*	oForm = null

*!*	If File(lcfirma)
*!*		lcarchivo = Filetostr(lcfirma)
*!*	*!*		If !sp_grabo_prof_foto(codigov,'"'+lcarchivo+'"',3)
*!*	*!*			Return .F.
*!*	*!*		Endif
*!*		Use In Select("mprofFotoctr")
*!*	*	Delete File (lcfirma)
*!*	Endif 

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
