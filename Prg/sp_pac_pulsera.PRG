*
* Pulseras de identificacion de pacientes (HDO / ADM.INT.)
*

Lparameters mNomb, mNacio, mCober, mDocu, mAdm, mSexo, mestado, mesquem, mlsector, mAdmRn, mNomRn, mSecu, mFHN

If Vartype(mlsector)<>'C'
	mlsector = '(HDO)'
Endif
If Vartype(mAdmRn)<>'C'
	mAdmRn = mAdm
Endif 
If Vartype(mNomRn)<>'C'
	mNomRn = mNomb
Endif 
If Vartype(mSecu)<>'C'
	mSecu = mSecu
Endif 
If Vartype(mFHN)<>'C'
	mFHN= ""
Endif 





mIdArch = "C:\TEMP\P"+Strtran(Transform(Seconds()),'.','')+".TXT"

If File(mIdArch)
	Erase (mIdArch)
Endif

If !Empty(mDocu)
	mret = sqlexec(mcon1, "select Reg_NumDocumento from registracio where REG_nrohclinica = ?mDocu ", "MWKREG011")
	If mret <= 0
		Messagebox("ERROR AL BUSCAR LA REGISTRACION",16,"ERROR")
		Return .F.
	Endif 
	
	If Reccount("MWKREG011") > 0
		mDocu = Alltrim(Transform(MWKREG011.Reg_NumDocumento))
	Endif 
	Use In Select("MWKREG011")
Endif 

Do Case

Case mlsector = '(HDO)' && Hospital de día oncologico

	mText1   = 'S.G.'
	mText2   = 'IDENTIFICACION'

	mbarcode = Left(mNomb,21) + " DOC " + mDocu + " (ADM) " + mAdm + Chr(10) +	Alltrim(mesquem)

	If Len(mbarcode)>80
		mbarcode = Left(mNomb,21) + " DOC " + mDocu + Chr(10) +;
			IIF(Len(Alltrim(mesquem))>45,Substr(Alltrim(mesquem),1,45)+"...",Alltrim(mesquem))
*		mbarcode = Left(mNomb,16) + " (HC) " + mDocu + Chr(10) + Alltrim(mesquem)
	Endif

	mLabel = "! 0 100 900 1"+ Chr(10) + ;
		"PITCH 200"+ Chr(10) + ;
		"WIDTH 78"+ Chr(10) + ;
		"TEXT 0(0,180,1,1 ) 140 690 " + mText1 + Chr(10) + ;
		"TEXT 0(0,180,1,1 ) 150 670 " + mText2 + Chr(10) + ;
		"GRAPHIC RECALL SGLOGO 40 710"+Chr(10)+;
		"TEXT 6010(0,270,1,1) 10 650 " + Left(mNomb,21) + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 40 650 " + mNacio + "  -  "+ mSexo + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 70 650 " + Left(mCober,25) + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 100 650 " + "DOC " + mDocu + " ADM. " + mAdm + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 130 650" + mestado + Chr(10) + ;
		"BARCODE DATAMATRIX (5,F,,,2,*) 5 50"+ Chr(10) + ;
		"*" + mbarcode + "*" + Chr(10) + ;
		"END"

Case mlsector = '(ADMCIAM)' && CIAM
	mText1   = 'S.G.'
	mText2   = 'SHOCK ROOM'
	mbarcode = Left(mNomb,21) + " DOC " + mDocu + " (ADM) " + mAdm

	If Len(mbarcode)>80
		mbarcode = Left(mNomb,21) + " DOC " + mDocu + " (ADM) " + mAdm
	Endif

	mLabel = "! 0 100 900 1"+ Chr(10) + ;
		"PITCH 200"+ Chr(10) + ;
		"WIDTH 78"+ Chr(10) + ;
		"TEXT 0(0,180,1,1 ) 140 690 " + mText1 + Chr(10) + ;
		"TEXT 0(0,180,1,1 ) 150 670 " + mText2 + Chr(10) + ;
		"GRAPHIC RECALL SGLOGO 40 710"+Chr(10)+;
		"TEXT 6010(0,270,1,1) 10 650 " + Left(mNomb,21) + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 40 650 " + Dtoc(mNacio) + "  -  "+ mSexo + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 70 650 " + Left(mCober,25) + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 100 650 " + "DOC " + mDocu + " ADM. " + mAdm + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 130 650" + mestado + Chr(10) + ;
		"BARCODE DATAMATRIX (5,F,,,2,*) 5 50"+ Chr(10) + ;
		"*" + mbarcode + "*" + Chr(10) + ;
		"END"

Case mlsector = '(ADMPGUA)' && PLANILLA DE GUARDIA
	mText1   = 'S.G.'
	mText2   = 'SHOCK ROOM'
	mbarcode = Left(mNomb,21) + " DOC " + mDocu + " (PROT) " + mAdm

	If Len(mbarcode)>80
		mbarcode = Left(mNomb,21) + " DOC " + mDocu + " (PROT) " + mAdm
	Endif

	mLabel = "! 0 100 900 1"+ Chr(10) + ;
		"PITCH 200"+ Chr(10) + ;
		"WIDTH 78"+ Chr(10) + ;
		"TEXT 0(0,180,1,1 ) 140 690 " + mText1 + Chr(10) + ;
		"TEXT 0(0,180,1,1 ) 150 670 " + mText2 + Chr(10) + ;
		"GRAPHIC RECALL SGLOGO 40 710"+Chr(10)+;
		"TEXT 6010(0,270,1,1) 10 650 " + Left(mNomb,21) + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 40 650 " + Dtoc(mNacio) + "  -  "+ Nvl(mSexo,'') + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 70 650 " + Left(mCober,25) + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 100 650 " + "DOC " + mDocu + " PROT. " + mAdm + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 130 650" + mestado + Chr(10) + ;
		"BARCODE DATAMATRIX (5,F,,,2,*) 5 50"+ Chr(10) + ;
		"*" + mbarcode + "*" + Chr(10) + ;
		"END"

Case  mlsector = "(ADMINT)" Or mlsector = "(ADMINTPED)" && Adminisión Internación / Pediatria

	mbarcode = mlsector + " DOC " + mDocu + " (ADM) " + mAdm

	mLabel = "! 0 100 900 1"+ Chr(10) + ;
		"WIDTH 78"+ Chr(10) + ;
		"TEXT 0(0,180,1,1 ) 110 695 "+"- ADM.INT. -"+ Chr(10) + ;
		"GRAPHIC RECALL SGLOGO 30 715"+ Chr(10) + ;
		"TEXT 6010(0,270,1,1) 20 690 " + Left(mNomb,25) + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 50 690 " + "Edad : "+ mNacio + " - "+ mSexo + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 80 690 " + Left(mCober,25) + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 110 690 " + "DOC " + mDocu + " ADM. " + mAdm + Chr(10) + ;
		"BARCODE DATAMATRIX (5,F,,,2,*) 5 50"+ Chr(10) + ;
		"*" + mbarcode + "*" + Chr(10) + ;
		"END"

Case mlsector = "(ADMINTNEO)" && Adminisión Internación / Neo

	mLabel = "! 0 100 1000 1" + Chr(10) + ;
		"WIDTH 87"+ Chr(10) + ;
		"TEXT 2(0,270,1,1) 10 455 " + Left(mNomb,16) + Chr(10) + ;
		"TEXT 1(0,270,1,1) 40 455 " + Left(mCober,21) + Chr(10) + ;
		"TEXT 1(0,270,1,1) 65 455 " + "(" + mSexo + ") - DOC " + mDocu + Chr(10) + ;
		"BARCODE_FONT TEXT 1(0,0,1,1,1,1)"+ Chr(10) + ;
		"BARCODER270 CODE128(2:4) 120 400 25 " + mAdm + Chr(10) + ;
		"END"

*!*		mLabel = "! 0 100 1000 1" + Chr(10) + ;
*!*			"WIDTH 78"+ Chr(10) + ;
*!*			"TEXT 2(0,270,1,1) 10 455 " + Left(mNomb,16) + Chr(10) + ;
*!*			"TEXT 1(0,270,1,1) 40 455 " + Left(mCober,21) + Chr(10) + ;
*!*			"TEXT 1(0,270,1,1) 65 455 " + "(" + mSexo + ") - DOC " + mDocu + Chr(10) + ;
*!*			"BARCODE_FONT TEXT 1(0,0,1,1,1,1)"+ Chr(10) + ;
*!*			"BARCODER270 CODE128(2:4) 120 400 25 " + mAdm + Chr(10) + ;
*!*			"END"

Case mlsector = '(ADMAMBU)'  && Admision Ambulatorio

	mText1   = 'S.G.'
	mText2   = 'AMBULATORIO'
	mbarcode = Left(mNomb,21) + " DOC " + mDocu + " (ADM) " + mAdm + Chr(10) +	Alltrim(mesquem)

	If Len(mbarcode)>80
		mbarcode = Left(mNomb,21) + " DOC " + mDocu + Chr(10) + Alltrim(mesquem)
	Endif

	mLabel = "! 0 100 900 1"+ Chr(10) + ;
		"PITCH 200"+ Chr(10) + ;
		"WIDTH 78"+ Chr(10) + ;
		"TEXT 0(0,180,1,1 ) 140 690 " + mText1 + Chr(10) + ;
		"TEXT 0(0,180,1,1 ) 150 670 " + mText2 + Chr(10) + ;
		"GRAPHIC RECALL SGLOGO 40 710"+Chr(10)+;
		"TEXT 6010(0,270,1,1) 10 650 " + Left(mNomb,21) + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 40 650 " + mNacio + "  -  "+ mSexo + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 70 650 " + Left(mCober,25) + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 100 650 " + "DOC " + mDocu + " ADM. " + mAdm + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 130 650" + Left(mestado,25) + Chr(10) + ;
		"BARCODE DATAMATRIX (5,F,,,2,*) 5 50"+ Chr(10) + ;
		"*" + mbarcode + "*" + Chr(10) + ;
		"END"

Case  mlsector = "(ADMPROTQ)" && Protocolo Quirurgico

	mbarcode = mlsector + " DOC " + mDocu + " (ADM) " + mAdm

	mLabel = "! 0 100 900 1"+ Chr(10) + ;
		"WIDTH 78"+ Chr(10) + ;
		"TEXT 0(0,180,1,1 ) 110 695 "+"- AMB -"+ Chr(10) + ;
		"GRAPHIC RECALL SGLOGO 30 715"+ Chr(10) + ;
		"TEXT 6010(0,270,1,1) 20 690 " + Left(mNomb,25) + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 50 690 " + mNacio + " - "+ mSexo + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 80 690 " + Left(mCober,25) + Chr(10) + ;
		"TEXT 6010(0,270,1,1) 110 690 " + "DOC " + mDocu + " ADM. " + mAdm + Chr(10) + ;
		"BARCODE DATAMATRIX (5,F,,,2,*) 5 50"+ Chr(10) + ;
		"*" + mbarcode + "*" + Chr(10) + ;
		"END"


Case  mlsector = "(MMBB)" && Mama Bebe

	lcSep = Chr(10)
*!*	, mAdmRn, mNomRn

*!*		mLabel = "! 0 100 2205 1"+ lcSep + ;
*!*			"WIDTH 200"+ lcSep + ;
*!*			"C PULSERA MADRE-HIJO"+ lcSep + ;
*!*			"TEXT 0(0,180,1,1 ) 170 1990 PULSERA DE"+ lcSep + ;
*!*			"TEXT 0(0,180,1,1 ) 180 1970 IDENTIFICACION"+ lcSep + ;
*!*			"TEXT 3(0,270,1,1) 40 1890 " + Left(mNomb,25) + lcSep + ;
*!*			"TEXT 2(0,270,1,1) 100 1890 Bebe: " + mAdmRn + lcSep + ;
*!*			"BARCODE_FONT TEXT 2(0,0,1,1,1,1)"+ lcSep + ;
*!*			"BARCODER270 CODE128(3:9) 160 1670 50 " + mAdm + lcSep + ;
*!*			"C PULSERA HIJO 1 (ETIQ CENTRAL)"+ lcSep + ;
*!*			"TEXT 2(0,270,1,1) 230 980 " + Left(mNomRn,25) + lcSep + ;
*!*			"TEXT 1(0,270,1,1) 270 980 " + mAdm + " " + Proper(Left(mNomb,20))  + lcSep + ;
*!*			"BARCODE_FONT TEXT 1(0,0,1,1,1,1)"+ lcSep + ;
*!*			"BARCODER270 CODE128(2:4) 340 925 35 " + mAdmRn + lcSep + ;
*!*			"END"


	mLabel = "! 0 100 2205 1"+ lcSep + ;
		"WIDTH 200"+ lcSep + ;
		"C PULSERA MADRE-HIJO"+ lcSep + ;
		"TEXT 0(0,180,1,1 ) 170 1990 PULSERA DE"+ lcSep + ;
		"TEXT 0(0,180,1,1 ) 180 1970 IDENTIFICACION"+ lcSep + ;
		"TEXT 2(0,270,1,1) 40 1960 " + mNomb + lcSep + ;
		"TEXT 2(0,270,1,1) 70 1960 " + "Dni: " + mDocu + lcSep + ;
		"TEXT 2(0,270,1,1) 100 1960 Bebe: " + mAdmRn + lcSep + ;
		"BARCODE_FONT TEXT 2(0,0,1,1,1,1)"+ lcSep + ;
		"BARCODER270 CODE128(3:9) 160 1670 50 " + mAdm + lcSep + ;
		"C PULSERA HIJO 1 (ETIQ CENTRAL)"+ lcSep + ;
		"TEXT 0(0,270,1,1) 210 1000 " + mNomRn + lcSep + ;
		"TEXT 1(0,270,1,1) 240 1000 " + mAdm + " " + Proper(Left(mNomb,20))  + lcSep + ;
		"TEXT 1(0,270,1,1) 260 1000 " + "Dni: " + mDocu + lcSep + ;
		"BARCODE_FONT TEXT 1(0,0,1,1,1,1)"+ lcSep + ;
		"BARCODER270 CODE128(2:4) 320 925 35 " + mAdmRn + lcSep + ;
		"END"

*!*		! 0 100 2205 1
*!*			WIDTH 200C 
*!*			PULSERA MADRE-HIJO
*!*			TEXT 0(0,180,1,1 ) 170 1990 PULSERA DE
*!*			TEXT 0(0,180,1,1 ) 180 1970 IDENTIFICACION
*!*			TEXT 3(0,270,1,1)   40 1960 HENRIQUEZ,BEBE DE KAREN J
*!*			TEXT 2(0,270,1,1) 100 1960 BEBE 457444-6
*!*			BARCODE_FONT TEXT 2(0,0,1,1,1,1)
*!*			BARCODER270 CODE128(3:9) 160 1670 50 457444-6
*!*			C PULSERA HIJO 1 (ETIQ CENTRAL)
*!*			TEXT 2(0,270,1,1) 210 1000 Hijo de HENRIQUEZ,KAREN J
*!*			TEXT 1(0,270,1,1) 240 1000 450090-8 para agregar datos de la madre
*!*			BARCODE_FONT TEXT 1(0,0,1,1,1,1)
*!*			BARCODER270 CODE128(2:4) 340 925 35 450090-8
*!*			END	


Case  mlsector = "(MMMM)" && Mama - Bebe (Mama)

	lcSep = Chr(10)

*!*		mLabel = "! 0 100 2205 1"+ lcSep + ;
*!*			"WIDTH 200"+ lcSep + ;
*!*			"C PULSERA MADRE-HIJO"+ lcSep + ;
*!*			"TEXT 0(0,180,1,1 ) 170 1990 PULSERA DE"+ lcSep + ;
*!*			"TEXT 0(0,180,1,1 ) 180 1970 IDENTIFICACION"+ lcSep + ;
*!*			"TEXT 2(0,270,1,1) 40 1960 " + mNomb + lcSep + ;
*!*			"TEXT 2(0,270,1,1) 70 1960 " + "Dni: " + mDocu + Space(5) + "Sec: " + mSecu + lcSep + ;
*!*			"BARCODE_FONT TEXT 2(0,0,1,1,1,1)"+ lcSep + ;
*!*			"BARCODER270 CODE128(3:9) 160 1670 50 " + mAdm + lcSep + ;
*!*			"C PULSERA HIJO 1 (ETIQ CENTRAL)"+ lcSep + ;
*!*			"TEXT 0(0,270,1,1) 240 1000 " + mNomRn + lcSep + ;
*!*			"TEXT 1(0,270,1,1) 260 1000 " + "Dni: " + mDocu + Space(5) + "Sec: " + mSecu +  lcSep + ;
*!*			"BARCODE_FONT TEXT 1(0,0,1,1,1,1)"+ lcSep + ;
*!*			"BARCODER270 CODE128(2:4) 320 925 35 " + mAdm + lcSep + ;
*!*			"END"


mLabel = "! 0 100 2205 1"+ lcSep + ;
		"WIDTH 200"+ lcSep + ;
		"C PULSERA MADRE-HIJO"+ lcSep + ;
		"TEXT 0(0,180,1,1 ) 170 1990 PULSERA DE"+ lcSep + ;
		"TEXT 0(0,180,1,1 ) 180 1970 IDENTIFICACION"+ lcSep + ;
		"TEXT 2(0,270,1,1) 40 1960 " + mNomb + lcSep + ;
		"TEXT 2(0,270,1,1) 70 1960 " + "Dni: " + mDocu + Space(5) + "Sec: " + mSecu + lcSep + ;
		"BARCODE_FONT TEXT 2(0,0,1,1,1,1)"+ lcSep + ;
		"BARCODER270 CODE128(3:9) 160 1670 50 " + mAdm + lcSep + ;
		"C PULSERA HIJO 1 (ETIQ CENTRAL)"+ lcSep + ;
		"TEXT 0(0,90,1,1) 340 650 " + mNomRn + lcSep + ;
		"TEXT 1(0,90,1,1) 300 650 " + "Dni: " + mDocu + Space(5) + "Sec: " + mSecu +  lcSep + ;
		"BARCODE_FONT TEXT 1(0,0,1,1,1,1)"+ lcSep + ;
		"BARCODER90 CODE128(2:4) 240 725 35 " + mAdm + lcSep + ;
		"END"

Case mlsector = "(ADMINTNEOFH)" && Adminisión Internación / Neo / Fecha Hora 20200205

	mLabel = "! 0 100 1000 1" + Chr(10) + ;
		"WIDTH 87"+ Chr(10) + ;
		"TEXT 2(0,270,1,1) 10 455 " + Left(mNomb,16) + Chr(10) + ;
		"TEXT 1(0,270,1,1) 40 455 " + Left(mCober,21) + Chr(10) + ;
		"TEXT 1(0,270,1,1) 65 455 " + "DOC " + mDocu + " - " + mFHN + Chr(10) + ;
		"BARCODE_FONT TEXT 1(0,0,1,1,1,1)"+ Chr(10) + ;
		"BARCODER270 CODE128(2:4) 120 400 25 " + mAdm + Chr(10) + ;
		"END"


Endcase

mArch = Fcreate(mIdArch)

=Fwrite(mArch , mLabel)
=Fclose(mArch)

*
* IMPRESORA x DEFECTO
*
Declare Integer GetDefaultPrinter In winspool.drv;
			STRING  @ pszBuffer,;
			INTEGER @ pcchBuffer

nBufsize = 250
cPrinter = Replicate(Chr(0), nBufsize)
= GetDefaultPrinter(@cPrinter, @nBufsize)
cPrinter = Substr(cPrinter, 1, At(Chr(0),cPrinter)-1)

*
* IMPRIMO PULSERA
*
Set Printer On

DO CASE
	CASE mlsector = "(ADMINTNEO)" Or mlsector = "(ADMINTNEOFH)"
		Set Printer To Name "pulsepedia"

	CASE mlsector = "(MMBB)" Or mlsector = "(MMMM)"
		Set Printer To Name "pulsemmbb"

	OTHERWISE
		Set Printer To Name "pulseadulto"

ENDCASE
Set Console Off

Type (mIdArch) && To Printer && Prompt

Set Console On

Set Printer Off
Set Printer To

*
* SETEO IMPRESORA POR DEFECTO
*

Set Printer To Name (cPrinter)

If File(mIdArch) And prg_modo_exe()
	Erase (mIdArch)
Endif

Return
