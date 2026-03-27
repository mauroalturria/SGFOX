*Close Tables
*ultimo proceso16/03/2017  29/11/2017 20/10/2017 06/09/2017 23/08/2017  22/06/2017 - 19/05/2017-09/10/2020
*MCON1 = Sqlconnect("172.16.1.4")
*MCON1 = Sqlconnect("172.16.1.190")
mfecpas = Ctod('01-01-1900')
Set Step On
mcpathact = Allt(Sys(5))+Sys(2003)
Cd "C:\documenta\firmas"
Create Cursor medfirm (CODMED N(12.2))
mnarch = Adir(midir,"*.*")
Cd Alltrim(mcpathact)
For i= 1 To mnarch
	mnmed = Substr(midir(i,1),4)

	mimed = Val(mnmed)
	If mimed=0
		mnmed = Substr(midir(i,1),3)

		mimed = Val(mnmed)
	Endif
	Insert Into medfirm Values (mimed)
Next
SET STEP ON
Do sp_conexion

*** ultima actualizacion 04/11/2019
*mret = SQLExec(mcon1,"select * FROM TabMedFoto where  FechaBaja = ?mfecpas and tipo = 2 and idmedico in (5463) order by id desc ","mprofFotList")
*mret = SQLExec(mcon1,"select * FROM TabMedFoto where  FechaToma >= '2019-07-11' and tipo = 2 order by id desc ","mprofFotList")
*mret = SQLExec(mcon1,"select * FROM TabMedFoto where   FechaToma >= '2020-03-03' and FechaBaja = ?mfecpas and tipo = 2  order by id desc ","mprofFotoctr")
mret = SQLExec(mcon1,"select Tabmedfoto.ID, Tabmedfoto.FechaBaja, Tabmedfoto.FechaToma,"+;
	" Tabmedfoto.IdMedico, Tabmedfoto.Tipo,fecpasivap FROM TabMedFoto,prestadores  where  idmedico=prestadores.id"+;
	" and fecpasivap  = '1900-01-01' and FechaBaja = ?mfecpas and tipo >1 ","mprofFotoctr")
Set Step On
*Use c:\desaguemes\medfirm.Dbf In 0 Exclusive
Select * From mprofFotoctr Where idmedico  Not In (Select CODMED From medfirm) Into Cursor mprofFotList
**   and idmedico = 4229
*!*	mret = SQLExec(mcon1,"select ID FROM TabMedFoto where idmedico = ?midmed and "+;
*!*			" FechaBaja = ?mfecpas and tipo = ?mtipo ","mprofFotoctr")
If mret <= 0
	?"ERROR CONSULTA 1 "
	Return .F.
Endif


Select mprofFotList
Scan All
	Wait Windows Transform(mprofFotList.idmedico) Nowait
	Use In Select("mFirma")
	Use In Select("Imagen")
	=Obt_Foto(mprofFotList.idmedico)
	Use In Select("Imagen")
	Use In Select("mFirma")
	Select mprofFotList
Endscan


Do sp_desconexion
Return .F.


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


mfecpas = Ctod("01/01/1900")
mret = SQLExec(mcon1,"select ID , FechaBaja , FechaToma , IdMedico "+;
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
Use c:\temp\imagenes\firmas\Imagen.Dbf In 0 Alias mFirma
lfile = mFirma.firmag
lok = Strtofile(lfile ,lcnombre)
lcnombre    = 'C:\temp\imagenes\firmas\firma_ms.sig'
If !File(lcnombre)
	?"no esta el archivo"
	Return .F.
Endif

Set Classlib To "c:\desaguemes\lib\lib_fbases_sg.vcx"
Local oForm As Form

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
Use In Select("mFirma")
oForm.Release
oForm = Null

If File(lcfirma)
	lcarchivo = Filetostr(lcfirma)
*!*		If !sp_grabo_prof_foto(codigov,'"'+lcarchivo+'"',3)
*!*			Return .F.
*!*		Endif
	Use In Select("mprofFotoctr")
*	Delete File (lcfirma)
Endif

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
