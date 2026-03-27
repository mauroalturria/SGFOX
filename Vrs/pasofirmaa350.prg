*Close Tables

*MCON1 = Sqlconnect("172.16.1.4")
*MCON2 = Sqlconnect("172.16.1.190")
mcon1 = sqlconnect('Conec01', '_SYSTEM', 'SYS')
mcon2 = mcon1
do sp_conexion
mfecpas = ctod('01-01-1900')
set step on
mret = SQLExec(mcon2,"select id,FechaBaja, FechaToma, IdMedico,Tipo FROM TabMedFoto where  Tipo  = 2 and FechaBaja = ?mfecpas ","mprofFotList")
**   and idmedico = 4229
*!*	mret = SQLExec(mcon1,"select ID FROM TabMedFoto where idmedico = ?midmed and "+;
*!*			" FechaBaja = ?mfecpas and tipo = ?mtipo ","mprofFotoctr")

select mprofFotList
scan all
	scat memv
	use in select("mFirma")
	Use In Select("Imagen")
	=Obt_Foto(mprofFotList.idmedico)
	Use In Select("Imagen")
	use in select("mFirma")
 	select mprofFotList
endscan

do sp_desconexion
return .f.


*!*------------------------------------------------------------------------------------------------------------------------------
Procedure Obt_Foto
Parameters codigov
*!*------------------------------------------------------------------------------------------------------------------------------

lcdirectorio = 'C:\temp\imagenes\firmas'
If !Directory(lcdirectorio)
	Md &lcdirectorio
Endif
If File("C:\temp\imagenes\firmas\firma_ms.sig")
	Erase "C:\temp\imagenes\firmas\firma_ms.sig"
Endif
If File("C:\temp\imagenes\firmas\firma_ms.sig")
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
mret = SQLExec(mcon2,"select ID , FechaBaja , FechaToma , IdMedico "+;
	", Imagen,Tipo FROM TabMedFoto where idmedico = ?codigov and Tipo  = 2 "  ,"mprofFoto")

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
lcnombre    = 'C:\temp\imagenes\firmas\firma_ms.sig'
Use C:\temp\imagenes\firmas\Imagen.Dbf In 0 Alias mFirma
lfile = mFirma.firmag
lok = Strtofile(lfile ,lcnombre)
lcnombre    = 'C:\temp\imagenes\firmas\firma_ms.sig'
If !File(lcnombre)
	?"no esta el archivo"
	Return .f.
Endif 

set classlib to "c:\desaguemes\lib\lib_fbases_sg.vcx"
Local oForm as Form

oForm = Newobject("Form")
oForm.AddObject("Olefirmaguardar","firma")

*Local Olefirmaguardar as "SIGPLUS.SigPlusCtrl.1"
*!*	Olefirmaguardar=Createobject("SIGPLUS.SigPlusCtrl.1")
*oForm.Olefirmaguardar.sigCompressionMode = 0
*oForm.Olefirmaguardar.encryptionMode = 0

*oForm.Olefirmaguardar.DisableMessageBoxes(1)

oForm.Olefirmaguardar.Importsigfile(lcnombre)

*Use C:\temp\imagenes\firmas\Imagen.Dbf In 0 Alias mFirma
lfile = mFirma.firmag
lok = Strtofile(lfile ,lcnombre)
lcfirma = "C:\temp\imagenes\firmas\" + Alltrim(Transform(codigov)) + "_firma_ms.tif"
oForm.Olefirmaguardar.Imagefileformat= 6
oForm.Olefirmaguardar.Writeimagefile(lcfirma)
use in select("mFirma")
oForm.Release
oForm = null

If File(lcfirma)
	lcarchivo = Filetostr(lcfirma)
	If !sp_grabo_prof_foto(codigov,'"'+lcarchivo+'"',3)
		Return .F.
	Endif
	Use In Select("mprofFotoctr")
*	Delete File (lcfirma)
Endif 
