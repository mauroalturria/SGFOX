*
* Pulseras de identificacion de pacientes (HDO / ADM.INT.)
*

Lparameters mNomb, mNacio, mCober, mDocu, mAdm, mSexo, mestado, mesquem, mlsector

If Vartype(mlsector)<>'C'
	mlsector = '(HDO)'
Endif

mIdArch = "C:\TEMP\P"+Strtran(Transform(Seconds()),'.','')+".TXT"

If File(mIdArch)
	Erase (mIdArch)
Endif

Do Case

Case mlsector = '(HDO)' && Hospital de día oncologico

	mText1   = 'S.G.'
	mText2   = 'IDENTIFICACION'
	mbarcode = Left(mNomb,21) + " (HC) " + mDocu + " (ADM) " + mAdm + Chr(10) +	Alltrim(mesquem)

	If Len(mbarcode)>80
		mbarcode = Left(mNomb,21) + " (HC) " + mDocu + Chr(10) + Alltrim(mesquem)
	Endif

	mLabel = "! 0 100 900 1"+ Chr(10) + ;
		"PITCH 200"+ Chr(10) + ;
		"WIDTH 78"+ Chr(10) + ;
		"TEXT 0(0,180,1,1 ) 140 690 " + mText1 + Chr(10) + ;
		"TEXT 0(0,180,1,1 ) 150 670 " + mText2 + Chr(10) + ;
		"GRAPHIC RECALL SGLOGO 40 710"+Chr(10)+;
		"TEXT 6010(0,270,1,1) 10 650 " + Left(mNomb,21) + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 40 650 " + mNacio + "  -  "+ mSexo + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 70 650 " + mCober + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 100 650 " + "HC. " + mDocu + " ADM. " + mAdm + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 130 650" + mestado + Chr(10) + ;
		"BARCODE DATAMATRIX (5,F,,,2,*) 5 50"+ Chr(10) + ;
		"*" + mbarcode + "*" + Chr(10) + ;
		"END"

Case mlsector = '(ADMCIAM)' && CIAM
	mText1   = 'S.G.'
	mText2   = 'CIAM'
	mbarcode = Left(mNomb,21) + " (HC) " + mDocu + " (ADM) " + mAdm + Chr(10) +	Alltrim(mesquem)

	If Len(mbarcode)>80
		mbarcode = Left(mNomb,21) + " (HC) " + mDocu + Chr(10) + Alltrim(mesquem)
	Endif

	mLabel = "! 0 100 900 1"+ Chr(10) + ;
		"PITCH 200"+ Chr(10) + ;
		"WIDTH 78"+ Chr(10) + ;
		"TEXT 0(0,180,1,1 ) 140 690 " + mText1 + Chr(10) + ;
		"TEXT 0(0,180,1,1 ) 150 670 " + mText2 + Chr(10) + ;
		"GRAPHIC RECALL SGLOGO 40 710"+Chr(10)+;
		"TEXT 6010(0,270,1,1) 10 650 " + Left(mNomb,21) + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 40 650 " + mNacio + "  -  "+ mSexo + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 70 650 " + mCober + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 100 650 " + "HC. " + mDocu + " ADM. " + mAdm + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 130 650" + mestado + Chr(10) + ;
		"BARCODE DATAMATRIX (5,F,,,2,*) 5 50"+ Chr(10) + ;
		"*" + mbarcode + "*" + Chr(10) + ;
		"END"		

Case  mlsector = "(ADMINT)" Or mlsector = "(ADMINTPED)" && Adminisión Internación / Pediatria

	mbarcode = mlsector + " (HC) " + mDocu + " (ADM) " + mAdm

	mLabel = "! 0 100 900 1"+ Chr(10) + ;
		"WIDTH 78"+ Chr(10) + ;
		"TEXT 0(0,180,1,1 ) 110 695 "+"- ADM.INT. -"+ Chr(10) + ;
		"GRAPHIC RECALL SGLOGO 30 715"+ Chr(10) + ;
		"TEXT 6010(0,270,1,1) 20 690 " + Left(mNomb,25) + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 50 690 " + "Edad : "+ mNacio + " - "+ mSexo + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 80 690 " + Left(mCober,25) + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 110 690 " + "HC. " + mDocu + " ADM. " + mAdm + Chr(10) + ;
		"BARCODE DATAMATRIX (5,F,,,2,*) 5 50"+ Chr(10) + ;
		"*" + mbarcode + "*" + Chr(10) + ;
		"END"

Case mlsector = "(ADMINTNEO)" && Adminisión Internación / Neo

	mLabel = "! 0 100 1000 1" + Chr(10) + ;
		"WIDTH 78"+ Chr(10) + ;
		"TEXT 2(0,270,1,1) 10 455 " + Left(mNomb,16) + Chr(10) + ;
		"TEXT 1(0,270,1,1) 40 455 " + Left(mCober,21) + Chr(10) + ;
		"TEXT 1(0,270,1,1) 65 455 " + "(" + mSexo + ") - HC." + mDocu + Chr(10) + ;
		"BARCODE_FONT TEXT 1(0,0,1,1,1,1)"+ Chr(10) + ;
		"BARCODER270 CODE128(2:4) 120 400 25 " + mAdm + Chr(10) + ;
		"END"

Case mlsector = '(ADMAMBU)'  && Admision Ambulatorio

	mText1   = 'S.G.'
	mText2   = 'AMBULATORIO'
	mbarcode = Left(mNomb,21) + " (HC) " + mDocu + " (ADM) " + mAdm + Chr(10) +	Alltrim(mesquem)

	If Len(mbarcode)>80
		mbarcode = Left(mNomb,21) + " (HC) " + mDocu + Chr(10) + Alltrim(mesquem)
	Endif

	mLabel = "! 0 100 900 1"+ Chr(10) + ;
		"PITCH 200"+ Chr(10) + ;
		"WIDTH 78"+ Chr(10) + ;
		"TEXT 0(0,180,1,1 ) 140 690 " + mText1 + Chr(10) + ;
		"TEXT 0(0,180,1,1 ) 150 670 " + mText2 + Chr(10) + ;
		"GRAPHIC RECALL SGLOGO 40 710"+Chr(10)+;
		"TEXT 6010(0,270,1,1) 10 650 " + Left(mNomb,21) + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 40 650 " + mNacio + "  -  "+ mSexo + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 70 650 " + mCober + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 100 650 " + "HC. " + mDocu + " ADM. " + mAdm + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 130 650" + left(mestado,25) + Chr(10) + ;
		"BARCODE DATAMATRIX (5,F,,,2,*) 5 50"+ Chr(10) + ;
		"*" + mbarcode + "*" + Chr(10) + ;
		"END"

Case  mlsector = "(ADMPROTQ)" && Protocolo Quirurgico

	mbarcode = mlsector + " (HC) " + mDocu + " (ADM) " + mAdm

	mLabel = "! 0 100 900 1"+ Chr(10) + ;
		"WIDTH 78"+ Chr(10) + ;
		"TEXT 0(0,180,1,1 ) 110 695 "+"- AMB -"+ Chr(10) + ;
		"GRAPHIC RECALL SGLOGO 30 715"+ Chr(10) + ;
		"TEXT 6010(0,270,1,1) 20 690 " + Left(mNomb,25) + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 50 690 " + mNacio + " - "+ mSexo + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 80 690 " + Left(mCober,25) + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 110 690 " + "HC. " + mDocu + " ADM. " + mAdm + Chr(10) + ;
		"BARCODE DATAMATRIX (5,F,,,2,*) 5 50"+ Chr(10) + ;
		"*" + mbarcode + "*" + Chr(10) + ;
		"END"

Endcase

mArch = Fcreate(mIdArch)

=Fwrite(mArch , mLabel)
=Fclose(mArch)

Set PRINTER ON
If mlsector = "(ADMINTNEO)"
	Set printer to name "pulsepedia"
Else
	Set printer to name "pulseadulto"
Endif

Type (mIdArch) && To Printer && Prompt

Set printer off
Set printer TO

If File(mIdArch)
	Erase (mIdArch)
Endif

Return
