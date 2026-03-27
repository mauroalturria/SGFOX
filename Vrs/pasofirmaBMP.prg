*Close Tables
*ultimo proceso16/03/2017  29/11/2017 20/10/2017 06/09/2017 23/08/2017  22/06/2017 - 19/05/2017-09/10/2020
*MCON1 = Sqlconnect("172.16.1.4")
*MCON1 = Sqlconnect("172.16.1.190")
mfecpas = Ctod('01-01-1900')
Set Step On
mcpathact = Allt(Sys(5))+Sys(2003)
Cd "C:\documenta\pasados"
Create Cursor medfirm (CODMED N(4))
mnarch = Adir(midir,"*.*")
Cd Alltrim(mcpathact)
For i= 1 To mnarch
	mimed = Val(midir(i,1))
	Insert Into medfirm Values (mimed)
Next
Do sp_conexion

mret = SQLExec(mcon1,"select Tabmedfoto.ID, Tabmedfoto.FechaBaja, Tabmedfoto.FechaToma,"+;
	" Tabmedfoto.IdMedico, Tabmedfoto.Tipo,fecpasivap FROM TabMedFoto,prestadores  where  idmedico=prestadores.id"+;
	" and fecpasivap  = '1900-01-01' and FechaBaja = ?mfecpas and tipo = 3 ","mprofFotoctr")

Set Step On
*Use c:\desaguemes\medfirm.Dbf In 0 Exclusive
**   esto va  Select * From mprofFotoctr Where idmedico  Not In (Select CODMED From medfirm) Into Cursor mprofFotList
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
*	=Obt_Foto(mprofFotList.idmedico)
	=obt_foto_tif(mprofFotList.idmedico )
	Use In Select("Imagen")
	Use In Select("mFirma")
	Select mprofFotList
Endscan


Do sp_desconexion
Return .F.
Procedure obt_foto_tif
Parameters codigov
mfecpas = Ctod("01/01/1900")
mret = SQLExec(mcon1,"select ID , FechaBaja , FechaToma , IdMedico "+;
	", Imagen,Tipo FROM TabMedFoto where idmedico = ?codigov  and tipo =3 ","mprofFoto")
Do sp_busco_prof_foto With codigov,3

If Used('mprofFoto')

	Select Top 1 Imagen  As firmag From mprofFoto ;
		WHERE tipo = 3;
		ORDER By Id Desc ;
		INTO Cursor mprofFirma

	If Reccount('mprofFirma')> 0
		
		If !Isnull(mprofFirma.firmag)

			=creobinfitma(codigov)
			lcdirectorio = 'C:\temp\imagenes\firmas'&&\'  + Alltrim(Str(codigov))
			lcnombre    = lcdirectorio  +'\' + Alltrim(Str(codigov))  + '_firma_ms' +  '.tiff'
			If !Directory(lcdirectorio)
				Md &lcdirectorio
			Endif
			Use c:\temp\imagenes\firmas\Imagen.Dbf In 0 Alias mFirma
			lfile = mFirma.firmag
			lok = Strtofile(lfile ,lcnombre)

*   thisform.pg.pganexos.imgf.Picture = lcnombre


		Endif
	Endif
Endif
*!*	If Used('ima')
*!*		Use In ima
*!*	Endif

*!*	If Used('__DATA')
*!*		Use In __DATA
*!*	Endif

*!*	If Used ('imagen')
*!*		Use In Imagen
*!*	Endif

*!*	Select Imagen As foto From mprofFoto;
*!*		where tipo= 1;
*!*		into Cursor ima


*!*	If File("C:\temp\imagenes\imagen.dbf")
*!*		Erase ("C:\temp\imagenes\imagen.dbf")
*!*	Endif
*!*	If File("C:\temp\imagenes\imagen.fpt")
*!*		Erase ("C:\temp\imagenes\imagen.fpt")
*!*	Endif
*!*	Select ima
*!*	Copy To "C:\temp\imagenes\imagen"
*!*	Use In ima

*!*	* cambia el campo grneral de tipo memo
*!*	LL = Fopen("C:\temp\imagenes\imagen.dbf",12)
*!*	Fseek(LL,43)
*!*	Fwrite(LL,'M')
*!*	Fclose(LL)

*!*	* graba los datos campo memo en un archivo
*!*	Use "C:\temp\imagenes\imagen.dbf" Alias ima
*!*	miresp = ''

*!*	Do prg_saveBin With foto,"C:\temp\imagenes\"+Alltrim(Str(codigov ,9,0)),miresp,'tif'

*!*	If Used('__DATA')
*!*		Use In __DATA
*!*	Endif
*!*	If Used ('imagen')
*!*		Use In Imagen
*!*	Endif
*!*	If Used('ima')
*!*		Use In ima
*!*	Endif
PROCEDURE creobinfitma
lparameters mlid
If Used('ima')
	Use In ima
Endif

If Used('__DATA')
	Use In __DATA
Endif

If Used ('imagen')
	Use In Imagen
Endif

If File("C:\temp\imagenes\imagen.dbf")
	Erase ("C:\temp\imagenes\imagen.dbf")
Endif
If File("C:\temp\imagenes\imagen.fpt")
	Erase ("C:\temp\imagenes\imagen.fpt")
Endif

Select mprofFirma
Copy To "C:\temp\imagenes\firmas\imagen"
Use In mprofFirma

* cambia el campo grneral de tipo memo
LL = Fopen("C:\temp\imagenes\firmas\imagen.dbf",12)
Fseek(LL,43)
Fwrite(LL,'M')
Fclose(LL)

* graba los datos campo memo en un archivo

*miresp = ''

*Do prg_saveBin With foto,"C:\temp\imagenes\firmas\"+Alltrim(Str(mlid,9,0)),miresp,'sig'

If Used('__DATA')
	Use In __DATA
Endif
If Used ('imagen')
	Use In Imagen
Endif
If Used('mprofFirma')
	Use In mprofFirma
ENDIF
*===========================

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


mfecpas = Ctod("01/01/1900")
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
lcnombre    = 'C:\temp\imagenes\firmas\firma_ms.TIF'
Use c:\temp\imagenes\firmas\Imagen.Dbf In 0 Alias mFirma
lfile = mFirma.firmag
lok = Strtofile(lfile ,lcnombre)
lcnombre    = 'C:\temp\imagenes\firmas\firma_ms.TIF'
If !File(lcnombre)
	?"no esta el archivo"
	Return .F.
Endif

lcfirma = "C:\temp\imagenes\firmas\" + Alltrim(Transform(codigov)) + "_firma_ms.tif"
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
	lfirma = .F.
	Return
Endif
If File("C:\temp\imagenes\firmas\imagen.fpt")
	Erase ("C:\temp\imagenes\firmas\imagen.fpt")
Endif
If File("C:\temp\imagenes\firmas\imagen.fpt")
	Messagebox("NO SE PUDO RECUPERAR LA FIRMA DEL PROFESIONAL!!"+Chr(13)+;
		"SALGA TOTALMENTE DE LA APLICACION Y VUELVA A INGRESAR" +Chr(13)+;
		"SI PERSISTE EL ERROR COMUNIQUESE CON SISTEMAS",48,"ALERTA")
	lfirma = .F.
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
lcnombre    =  "C:\temp\imagenes\firmas\" + Alltrim(Transform(codigov)) + "_firma_ms.tif"
Use c:\temp\imagenes\firmas\Imagen.Dbf In 0 Alias mFirma
lfile = mFirma.firmag
lok = Strtofile(lfile ,lcnombre)
lcnombre    =  "C:\temp\imagenes\firmas\" + Alltrim(Transform(codigov)) + "_firma_ms.tif"
Use In Select("mFirma")
=Adir(acontrolfirma, "C:\temp\imagenes\firmas\" + Alltrim(Transform(codigov)) + "_firma_ms.tif")
If File( "C:\temp\imagenes\firmas\" + Alltrim(Transform(codigov)) + "_firma_ms.tif")
	If acontrolfirma(1,2)<10
		Messagebox("NO SE PUDO RECUPERAR LA FIRMA")
		Erase  "C:\temp\imagenes\firmas\" + Alltrim(Transform(codigov)) + "_firma_ms.tif"
	Endif
Endif


Use In Select("mFirma")


If File(lcfirma)
	lcarchivo = Filetostr(lcfirma)
*!*		If !sp_grabo_prof_foto(codigov,'"'+lcarchivo+'"',3)
*!*			Return .F.
*!*		Endif
	Use In Select("mprofFotoctr")
*	Delete File (lcfirma)
Endif
