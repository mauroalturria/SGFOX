*
* Etiquetas Oncología / Insumos FRMFARMACIA04
*
Lparameters mdescri2, mubicacion1, mubicacion2, mnropof, mcopias, mdocumento

Dimension vdat[8]

*!* 2019-10-03 - Contemplar NRO.DOC. en etiqueta

mNombre1 = Left(Alltrim(mwketcitos.pacient),18)
mNombre  = Left(Alltrim(mwketcitos.pacient),18) + ' DOC ' + Alltrim(Transform(mdocumento))

If Len(Alltrim(mNombre))>30

	mDife   = Len(Alltrim(mNombre)) - 30
	mQuito  = 18 - mDife
	mNombre = Left(Alltrim(mwketcitos.pacient), mQuito)
	mNombre = mNombre + ' DOC ' + Alltrim(Transform(mdocumento))

Endif

vdat[1] = Alltrim(mdescri2)

mval1   = Upper(Alltrim(mwketcitos.solucio))
mval2   = Chrtran(mval1, 'Ó', 'O')

vdat[2] = mval2
vdat[3] = Alltrim(mwketcitos.prinpac2) + '-' + Alltrim(mlvia)
vdat[4] = Alltrim(mwketcitos.observa)
vdat[5] = Alltrim(mwketcitos.manejos)
vdat[6] = Dtoc(mwketcitos.fecelab)
vdat[7] = Dtoc(mwketcitos.fecvenc)
vdat[8] = Iif( mubicacion1 = 2, 'I:' + Alltrim(mubicacion2), Iif(mubicacion1 = 1,'HD','EX'))

If Len(vdat[1]) > 30

*!*		mEtq  =	"! 0 100 330 1"+chr(10)+;
*!*			"PITCH 200"+chr(10)+;
*!*			"WIDTH 228"+chr(10)+;
*!*			"TEXT 1(0,0,1,1) 150 9 PRECAUCION"+CHR(10)+;
*!*			"GRAPHIC RECALL SGETQ 15 35 "+chr(10)+;
*!*			"BARCODE DATAMATRIX (5,F,,,2,*) 330 30"+chr(10)+;
*!*			"*"+mnropof+chr(10)+;
*!*			mNombre + chr(10)+;
*!*			"*"+chr(10)+;
*!*			"TEXT 1(0,0,1,1) 16 130 " + mNombre + chr(10)+;
*!*			"TEXT 1(0,0,1,1) 16 164 " + Left(vdat[1],30) + chr(10)+;
*!*			"TEXT 1(0,0,1,1) 16 188 " + Substr(vdat[1],31) + chr(10)+;
*!*			"TEXT 1(0,0,1,1) 16 212 " + vdat[2] + chr(10)


	mEtq  =	"! 0 100 330 1"+Chr(10)+;
		"PITCH 200"+Chr(10)+;
		"WIDTH 228"+Chr(10)+;
		"TEXT 1(0,0,1,1) 150 9 PRECAUCION"+Chr(10)+;
		"BARCODE DATAMATRIX (5,F,,,2,*) 330 30"+Chr(10)+;
		"*"+mnropof+Chr(10)+;
		mNombre1 + Chr(10)+;
		"*"+Chr(10)+;
		"TEXT 1(0,0,1,1) 16 130 " + mNombre + Chr(10)+;
		"TEXT 1(0,0,1,1) 16 164 " + Left(vdat[1],30) + Chr(10)+;
		"TEXT 1(0,0,1,1) 16 188 " + Substr(vdat[1],31) + Chr(10)+;
		"TEXT 1(0,0,1,1) 16 212 " + vdat[2] + Chr(10)

	mobs3y4 = vdat[3] + "," + vdat[4]
	
	If Len(mobs3y4) > 30
		mEtq1 = "TEXT 1(0,0,1,1) 16 236 " + Left(mobs3y4,30) + Chr(10)
		mobs34y5 = Substr(mobs3y4,31) + ',' + vdat[5]
		mEtq2 = "TEXT 1(0,0,1,1) 16 262 " + Left(mobs34y5,30) + Chr(10)
	Else
		mEtq1 =	"TEXT 1(0,0,1,1) 16 236 " + mobs3y4 + Chr(10)
		mEtq2 = "TEXT 1(0,0,1,1) 16 262 " + vdat[5] + Chr(10)
	Endif

	mEtq  = mEtq + mEtq1 + mEtq2 +;
		"TEXT 1(0,0,1,1) 16 310 Vence     : " + vdat[7] + Chr(10)+;
		"TEXT 1(0,0,1,1) 16 285 Elaborado : " + vdat[6] + Chr(10)+;
		"TEXT 1(0,0,1,1) 282 310 " + mnropof + Chr(10)+;
		"TEXT 1(0,0,1,1) 320 285 " + vdat[8] + Chr(10)+;
		"END"

Else

*!*		mEtq  =	"! 0 100 330 1"+chr(10)+;
*!*			"PITCH 200"+chr(10)+;
*!*			"WIDTH 228"+chr(10)+;
*!*			"TEXT 1(0,0,1,1) 150 9 PRECAUCION"+CHR(10)+;
*!*			"GRAPHIC RECALL SGETQ 15 35 "+chr(10)+;
*!*			"BARCODE DATAMATRIX (5,F,,,2,*) 330 30"+chr(10)+;
*!*			"*"+mnropof+chr(10)+;
*!*			mNombre + chr(10)+;
*!*			"*"+chr(10)+;
*!*			"TEXT 1(0,0,1,1) 16 130 " + mNombre + chr(10)+;
*!*			"TEXT 1(0,0,1,1) 16 164 " + vdat[1] + chr(10)+;
*!*			"TEXT 1(0,0,1,1) 16 188 " + vdat[2] + chr(10)+;
*!*			"TEXT 1(0,0,1,1) 16 212 " + vdat[3] + chr(10)+;
*!*			"TEXT 1(0,0,1,1) 16 236 " + vdat[4] + chr(10)+;
*!*			"TEXT 1(0,0,1,1) 16 262 " + vdat[5] + chr(10)+;
*!*			"TEXT 1(0,0,1,1) 16 310 Vence     : " + vdat[7] + chr(10)+;
*!*			"TEXT 1(0,0,1,1) 16 285 Elaborado : " + vdat[6] + chr(10)+;
*!*			"TEXT 1(0,0,1,1) 282 310 " + mnropof + chr(10)+;
*!*			"TEXT 1(0,0,1,1) 373 285 " + vdat[8] + chr(10)+;
*!*			"END"

	mEtq  =	"! 0 100 330 1"+Chr(10)+;
		"PITCH 200"+Chr(10)+;
		"WIDTH 228"+Chr(10)+;
		"TEXT 1(0,0,1,1) 150 9 PRECAUCION"+Chr(10)+;
		"BARCODE DATAMATRIX (5,F,,,2,*) 330 30"+Chr(10)+;
		"*"+mnropof+Chr(10)+;
		mNombre1 + Chr(10)+;
		"*"+Chr(10)+;
		"TEXT 1(0,0,1,1) 16 130 " + mNombre + Chr(10)+;
		"TEXT 1(0,0,1,1) 16 164 " + vdat[1] + Chr(10)+;
		"TEXT 1(0,0,1,1) 16 188 " + vdat[2] + Chr(10)+;
		"TEXT 1(0,0,1,1) 16 212 " + vdat[3] + Chr(10)+;
		"TEXT 1(0,0,1,1) 16 236 " + vdat[4] + Chr(10)+;
		"TEXT 1(0,0,1,1) 16 262 " + vdat[5] + Chr(10)+;
		"TEXT 1(0,0,1,1) 16 310 Vence     : " + vdat[7] + Chr(10)+;
		"TEXT 1(0,0,1,1) 16 285 Elaborado : " + vdat[6] + Chr(10)+;
		"TEXT 1(0,0,1,1) 282 310 " + mnropof + Chr(10)+;
		"TEXT 1(0,0,1,1) 373 285 " + vdat[8] + Chr(10)+;
		"END"

Endif

*!*  04/10/2013
*!*  Se cambia directorio para guardar archivo TXT C:\TEMP a C:\TEMPDOC con código de impresión
*!*  no se elimina el archivo, solo al comenzar la impresión, al finalizar del mismo queda copia
*!*  para control (seguimiento de errores)

*mIdArch = "C:\TEMPDOC\ETQ"+STRTRAN(TRANSFORM(SECONDS()),'.','')+".TXT"

mIdArch = "C:\TEMPDOC\ETQ-" + mnropof + ".TXT"

If File(mIdArch)
	Erase (mIdArch)
Endif

mArch = Fcreate(mIdArch)

=Fwrite(mArch , mEtq)
=Fclose(mArch)

mhf = Fopen(mIdArch)

If mhf > 0

	mprint_org =  Set("Printer",2)

	Set Printer To Name Getprinter()
	Set Device To Printer
	Set Console Off
	Set Printer On

	For veces = 1 To mcopias
		=Fseek(mhf, 0)
		Do While !Feof(mhf)
			mcadena = Fgets(mhf)
			? mcadena
		Enddo
	Endfor

	Set Device To Screen
	Set Printer To Name (mprint_org)
	Set Printer Off
	Set Console On

	=Fclose(mhf)

Endif

*!*		If File(mIdArch)
*!*			Erase (mIdArch)
*!*		Endif

Release vdat

Return



























*!*	Lparameters mNomb,mNacio,mCober,mDocu,mAdm,mSexo,mestado,mesquem

*!*	mText1     = 'S.G.'
*!*	mText2     = 'IDENTIFICACION'

*!*	*mNomb      = ''
*!*	*mDocu      = ''
*!*	*mSexo      = 'MASCULINO'
*!*	*mCobertura = 'Hominis Plan de Salud'
*!*	*mAdm       = '12-21231A'
*!*	*mestado    = 'Alergico'
*!*	*mNacio     = '04/09/1971 (41)'
*!*	*mestado    = "Alérgico - Verificar Ñ o ñ"

*!*	mIdArch = "C:\TEMP\E"+STRTRAN(TRANSFORM(SECONDS()),'.','')+".TXT"

*!*	If File(mIdArch)
*!*		Erase (mIdArch)
*!*	Endif

*!*	mLabel = "! 0 100 900 1"+ chr(10) + ;
*!*		"PITCH 200"+ chr(10) + ;
*!*		"WIDTH 78"+ chr(10) + ;
*!*		"TEXT 0(0,180,1,1 ) 140 690 " + mText1 + chr(10) + ;
*!*		"TEXT 0(0,180,1,1 ) 150 670 " + mText2 + chr(10) + ;
*!*		"TEXT 6010(0,270,1,1) 10 650 " + Left(mNomb,21) + chr(10) + ;
*!*		"TEXT 6010(0,270,1,1) 40 650 " + mNacio + "  -  "+ mSexo + chr(10) + ;
*!*		"TEXT 6010(0,270,1,1) 70 650 " + mCober + chr(10) + ;
*!*		"TEXT 6010(0,270,1,1) 100 650 " + "HC. " + mDocu + " ADM. " + mAdm + chr(10) + ;
*!*		"TEXT 6010(0,270,1,1) 130 650" + mestado + chr(10) + ;
*!*		"BARCODE DATAMATRIX (5,F,,,2,*) 5 50"+ chr(10) + ;
*!*		"*" + left(mNomb,21) + " (HC) " + mDocu + " (ADM) " + mAdm + chr(10) + ;
*!*		Alltrim(mesquem)+ "*" + chr(10) + ;
*!*		"END"

*!*	*!* 2017-03-27

*!*	*!*	mLabel = "! 0 100 900 1"+ chr(10) + ;
*!*	*!*		"PITCH 200"+ chr(10) + ;
*!*	*!*		"WIDTH 78"+ chr(10) + ;
*!*	*!*		"TEXT 0(0,180,1,1 ) 140 690 " + mText1 + chr(10) + ;
*!*	*!*		"TEXT 0(0,180,1,1 ) 150 670 " + mText2 + chr(10) + ;
*!*	*!*		"GRAPHIC RECALL SGLOGO 40 710"+chr(10)+;
*!*	*!*		"TEXT 6010(0,270,1,1) 10 650 " + Left(mNomb,21) + chr(10) + ;
*!*	*!*		"TEXT 6010(0,270,1,1) 40 650 " + mNacio + "  -  "+ mSexo + chr(10) + ;
*!*	*!*		"TEXT 6010(0,270,1,1) 70 650 " + mCober + chr(10) + ;
*!*	*!*		"TEXT 6010(0,270,1,1) 100 650 " + "HC. " + mDocu + " ADM. " + mAdm + chr(10) + ;
*!*	*!*		"TEXT 6010(0,270,1,1) 130 650" + mestado + chr(10) + ;
*!*	*!*		"BARCODE DATAMATRIX (5,F,,,2,*) 5 50"+ chr(10) + ;
*!*	*!*		"*" + left(mNomb,21) + " (HC) " + mDocu + " (ADM) " + mAdm + chr(10) + ;
*!*	*!*		Alltrim(mesquem)+ "*" + chr(10) + ;
*!*	*!*		"END"





*!*	*!*	mLabel = "! 0 100 900 1"+ chr(10) + ;
*!*	*!*		"PITCH 200"+ chr(10) + ;
*!*	*!*		"WIDTH 78"+ chr(10) + ;
*!*	*!*		"TEXT 0(0,180,1,1 ) 140 690 " + mText1 + chr(10) + ;
*!*	*!*		"TEXT 0(0,180,1,1 ) 150 670 " + mText2 + chr(10) + ;
*!*	*!*		"GRAPHIC RECALL SGLOGO 40 710"+chr(10)+;
*!*	*!*		"TEXT 6010(0,270,1,1) 10 650 " + mNomb + chr(10) + ;
*!*	*!*		"TEXT 6010(0,270,1,1) 40 650 " + mNacio + "  -  "+ mSexo + chr(10) + ;
*!*	*!*		"TEXT 6010(0,270,1,1) 70 650 " + mCober + chr(10) + ;
*!*	*!*		"TEXT 6010(0,270,1,1) 100 650 " + "HC. " + mDocu + " ADM. " + mAdm + chr(10) + ;
*!*	*!*		"TEXT 6010(0,270,1,1) 130 650" + mestado + chr(10) + ;
*!*	*!*		"BARCODE DATAMATRIX (5,F,,,2,*) 10 50"+ chr(10) + ;
*!*	*!*		"*" + "NOMBRE: "+mNomb + chr(10) + ;
*!*	*!*		"HC: " + mDocu + " ADM: " + mAdm + chr(10) + ;
*!*	*!*		"FECNAC: "+mNacio + " SEXO: " + mSexo + chr(10) + ;
*!*	*!*		Alltrim(mesquem)+ "*" + chr(10) + ;
*!*	*!*		"END"
*!*	*!*
*!*	*"FECNAC: "+mNacio + " SEXO: " + mSexo + chr(10) + ;
*!*	*"ESQ: "+alltrim(mesquem)+ "*" + chr(10) + ;

*!*	mArch = FCREATE(mIdArch)

*!*	=FWRITE(mArch , mLabel)
*!*	=Fclose(mArch)

*!*	Type (mIdArch) TO PRINTER PROMPT

*!*	If File(mIdArch)
*!*		Erase (mIdArch)
*!*	Endif

*!*	Return
