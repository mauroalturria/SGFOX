*** Marcelo Torres, 24/08/2022
*** sp_fomato_video_yuy2
Lparameters hCapture

Set Procedure To sp_api_structure.prg Additive
Set Procedure To sp_video_functions.prg Additive


Local loPrinterStruct, hPrinter, lcSrvName, lcPrnName, lcDrvName, lcStr
Local cBuffer, nBufsize, nResult

#Define WM_CAP_START 0x0400
#Define WM_CAP_GET_VIDEOFORMAT   (WM_CAP_START+44)
#Define WM_CAP_SET_VIDEOFORMAT   (WM_CAP_START+45)
#Define BITMAPINFOHEADER_SIZE 40

loPrinterStruct = Create('struct_Video_INFO')

*!*	loPrinterStruct.fld('biSize')         = 0
*!*	loPrinterStruct.fld('biWidth')        = 0
*!*	loPrinterStruct.fld('biHeight')       = 0
*!*	loPrinterStruct.fld('biPlanes')       = 0
*!*	loPrinterStruct.fld('biBitCount')     = 0
*!*	loPrinterStruct.fld('biCompression')  = 0
*!*	loPrinterStruct.fld('biSizeImage')    = 0
*!*	loPrinterStruct.fld('biXPelsPerMeter')= 0
*!*	loPrinterStruct.fld('biYPelsPerMeter')= 0
*!*	loPrinterStruct.fld('biClrUsed')      = 0
*!*	loPrinterStruct.fld('biClrImportant') = 0

*!*	SET STEP ON

**nBufsize=4096
nBufsize=40

cBuffer = Padr(num2dword(BITMAPINFOHEADER_SIZE), nBufsize, Chr(0))


* ----------------------------------
nResult = fmsg(WM_CAP_GET_VIDEOFORMAT, nBufsize, @cBuffer, 1,hCapture)


*!*	a1 =buf2dword(SUBSTR(cBuffer, 1,4))
*!*	a2 = buf2dword(SUBSTR(cBuffer, 5,4))
*!*	a3 = buf2dword(SUBSTR(cBuffer, 9,4))
*!*	a4 = buf2dword(SUBSTR(cBuffer, 13,2))
*!*	a5 = buf2dword(SUBSTR(cBuffer, 15,2))
*!*	a6 = buf2dword(SUBSTR(cBuffer, 17,4))
*!*	a7 = buf2dword(SUBSTR(cBuffer, 21,4))
*!*	a8 = buf2dword(SUBSTR(cBuffer, 25,4))
*!*	a9 = buf2dword(SUBSTR(cBuffer, 29,4))
*!*	a10 = buf2dword(SUBSTR(cBuffer, 33,4))
*!*	a11 = buf2dword(SUBSTR(cBuffer, 37,4))

*!*	SET STEP ON


* ----------------------------------
loPrinterStruct.fld('biSize')         = buf2dword(Substr(cBuffer, 1,4))
loPrinterStruct.fld('biWidth')        = buf2dword(Substr(cBuffer, 5,4))
loPrinterStruct.fld('biHeight')       = buf2dword(Substr(cBuffer, 9,4))
loPrinterStruct.fld('biPlanes')       = buf2dword(Substr(cBuffer, 13,2))
loPrinterStruct.fld('biBitCount')     = buf2dword(Substr(cBuffer, 15,2))
loPrinterStruct.fld('biCompression')  = buf2dword(Substr(cBuffer, 17,4))
loPrinterStruct.fld('biSizeImage')    = buf2dword(Substr(cBuffer, 21,4))
loPrinterStruct.fld('biXPelsPerMeter')= buf2dword(Substr(cBuffer, 25,4))
loPrinterStruct.fld('biYPelsPerMeter')= buf2dword(Substr(cBuffer, 29,4))
loPrinterStruct.fld('biClrUsed')      = buf2dword(Substr(cBuffer, 33,4))
loPrinterStruct.fld('biClrImportant') = buf2dword(Substr(cBuffer, 37,4))

** Reemplazamos el valor para pasarselo como seteo
*!*	SET STEP ON

*!*	nCompression = buf2dword(SUBSTR(cBuffer, 17,4))

*!*	SET STEP ON

loPrinterStruct.fld('biWidth')       = 640
loPrinterStruct.fld('biHeight')      = 480
loPrinterStruct.fld('biBitCount')    = 16
loPrinterStruct.fld('biCompression') = 844715353
loPrinterStruct.fld('biSizeImage')   = 614400
*SET STEP ON

** Establecer el nuevo seteo
*!*	WM_CAP_SET_VIDEOFORMAT
*!*	wParam = (WPARAM) (wSize);
*!*	lParam = (LPARAM) (LPVOID) (psVideoFormat);

cBuffer = ""

cBuffer = loPrinterStruct.Structure

*!*	a1 =buf2dword(SUBSTR(cBuffer, 1,4))
*!*	a2 = buf2dword(SUBSTR(cBuffer, 5,4))
*!*	a3 = buf2dword(SUBSTR(cBuffer, 9,4))
*!*	a4 = buf2dword(SUBSTR(cBuffer, 13,2))
*!*	a5 = buf2dword(SUBSTR(cBuffer, 15,2))
*!*	a6 = buf2dword(SUBSTR(cBuffer, 17,4))
*!*	a7 = buf2dword(SUBSTR(cBuffer, 21,4))
*!*	a8 = buf2dword(SUBSTR(cBuffer, 25,4))
*!*	a9 = buf2dword(SUBSTR(cBuffer, 29,4))
*!*	a10 = buf2dword(SUBSTR(cBuffer, 33,4))
*!*	a11 = buf2dword(SUBSTR(cBuffer, 37,4))

*!*	SET STEP ON

nResult = fmsg(WM_CAP_SET_VIDEOFORMAT, nBufsize, cBuffer,1,hCapture)

If nResult <> 1
	Messagebox("No se puede establecer la conexión con la cámara",16,"ERROR")
Endif


Return


Define Class struct_Video_INFO As Struct
*!* Original Structure definition:
**  Public Type BITMAPINFOHEADER '40 bytes
*!*	        biSize As Long 4
*!*	        biWidth As Long 4
*!*	        biHeight As Long 4
*!*	        biPlanes As Integer 2
*!*	        biBitCount As Integer 2
*!*	        biCompression As Long 4
*!*	        biSizeImage As Long 4
*!*	        biXPelsPerMeter As Long 4
*!*	        biYPelsPerMeter As Long 4
*!*	        biClrUsed As Long 4
*!*	        biClrImportant As Long 4
*!*	End Type

	Procedure Init
	This.AddField( 'biSize',         'LONG',    0 )
	This.AddField( 'biWidth',        'LONG',    0 )
	This.AddField( 'biHeight',       'LONG',    0 )
	This.AddField( 'biPlanes',       'PASCAL_INTEGER',    0 )
	This.AddField( 'biBitCount',     'PASCAL_INTEGER',    0 )
	This.AddField( 'biCompression',  'LONG',    0 )
	This.AddField( 'biSizeImage',    'LONG',    0 )
	This.AddField( 'biXPelsPerMeter','LONG',    0 )
	This.AddField( 'biYPelsPerMeter','LONG',    0 )
	This.AddField( 'biClrUsed',      'LONG',    0 )
	This.AddField( 'biClrImportant', 'LONG',    0 )

	Endproc
Enddefine

*** ----------------------------------------
Function fmsg(msg, wParam, Lparam, nMode, hCapture)

Local nResult

If hCapture = 0
	Return 0
Endif

If Vartype(nMode) <> "N" Or nMode=0
	Declare Integer SendMessage In user32;
		INTEGER HWnd, Integer Msg,;
		INTEGER wParam, Integer Lparam
	nResult = SendMessage(hCapture, msg, wParam, Lparam)
Else
	Declare Integer SendMessage In user32;
		INTEGER HWnd, Integer Msg,;
		INTEGER wParam, String @Lparam
	nResult = SendMessage(hCapture, msg, wParam, @Lparam)
Endif

Return nResult
