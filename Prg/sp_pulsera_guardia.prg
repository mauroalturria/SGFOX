* sp_pulsera_guardia
* Pulseras de identificación de pacientes en espera de cama (frmguardia78 page2)

Lparameters mNombre, mAdmision, mFecha

mNomb = mNombre
mAdm = mAdmision
mFec = mFecha

mIdArch = "C:\TEMP\Pul"+Sys(2015)+".TXT"

If File(mIdArch)
	Erase (mIdArch)
Endif

mText1   = 'S.G.'
mText2   = 'SHOCK ROOM'
mbarcode = Left(mNomb,21) + " (PROT) " + mAdm + " (FECHA) " + mFec

If Len(mbarcode)>80
	mbarcode = Left(mNomb,21) + " (PROT) " + mAdm + " (FECHA) " + mFec
Endif

mLabel = "! 0 100 900 1"+ Chr(10) + ;
	"PITCH 200"+ Chr(10) + ;
	"WIDTH 78"+ Chr(10) + ;
	"TEXT 0(0,180,1,1 ) 140 690 " + mText1 + Chr(10) + ;
	"TEXT 0(0,180,1,1 ) 150 670 " + mText2 + Chr(10) + ;
	"GRAPHIC RECALL SGLOGO 40 710"+Chr(10)+;
	"TEXT 6010(0,270,1,1) 10 650 " + Left(mNomb,21) + Chr(10) + ;
	"TEXT 6010(0,270,1,1) 40 650 " + "Fecha: " + mFec + " PROT. " + mAdm + Chr(10) + ;
	"BARCODE DATAMATRIX (5,F,,,2,*) 5 50"+ Chr(10) + ;
	"*" + mbarcode + "*" + Chr(10) + ;
	"END"



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

Set Printer To Name "pulseadulto"

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
