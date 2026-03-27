LOCAL oForm
oForm = CREATEOBJECT("Tform")
oForm.Show(1)
* end of main

DEFINE CLASS Tform As Form
#DEFINE WM_CAP_START  0x0400
#DEFINE WM_CAP_DRIVER_CONNECT    (WM_CAP_START+10)
#DEFINE WM_CAP_DRIVER_DISCONNECT (WM_CAP_START+11)
#DEFINE WM_CAP_DRIVER_GET_CAPS   (WM_CAP_START+14)
#DEFINE WM_CAP_SET_PREVIEW       (WM_CAP_START+50)
#DEFINE WM_CAP_SET_OVERLAY       (WM_CAP_START+51)
#DEFINE WM_CAP_SET_PREVIEWRATE   (WM_CAP_START+52)
#DEFINE WM_CAP_GET_STATUS        (WM_CAP_START+54)
#DEFINE WM_CAP_GRAB_FRAME        (WM_CAP_START+60)

	Width=340
	Height=310
	Autocenter=.T.
	Caption="Using Video Capture"
	MinButton=.F.
	MaxButton=.F.
	hWindow=0
	hCapture=0
	capWidth=0
	capHeight=0
	capOverlay=0
	
	ADD OBJECT cmdGetFrame As CommandButton WITH Default=.T.,;
	Left=15, Top=264, Height=27, Width=90, Caption="Get Frame",;
	Enabled=.F.

	ADD OBJECT cmdPreview As CommandButton WITH Default=.T.,;
	Left=106, Top=264, Height=27, Width=100, Caption="Preview Video",;
	Enabled=.F.

	ADD OBJECT cmdClose As CommandButton WITH Cancel=.T.,;
	Left=250, Top=264, Height=27, Width=70, Caption="Close"

PROCEDURE Activate
	IF THIS.hWindow = 0
		DECLARE INTEGER GetFocus IN user32
		THIS.hWindow = GetFocus()
		THIS.CreateCaptureWindow
		THIS.DriverConnect
	ENDIF

PROCEDURE Destroy
	THIS.ReleaseCaptureWindow

PROCEDURE cmdClose.Click
	ThisForm.Release

PROCEDURE cmdGetFrame.Click
	ThisForm.GetFrame

PROCEDURE cmdPreview.Click
	ThisForm.StartPreview

PROCEDURE GetFrame
	THIS.msg(WM_CAP_GRAB_FRAME, 0,0)

PROCEDURE CreateCaptureWindow
#DEFINE WS_CHILD   0x40000000
#DEFINE WS_VISIBLE 0x10000000

	DECLARE INTEGER capCreateCaptureWindow IN avicap32;
		STRING lpszWindowName, LONG dwStyle,;
		INTEGER x, INTEGER y,;
		INTEGER nWidth, INTEGER nHeight,;
		INTEGER hParent, INTEGER nID

	THIS.hCapture = capCreateCaptureWindow("",;
		WS_CHILD+WS_VISIBLE,;
		10,8,320,240, THIS.hWindow, 1)

PROCEDURE DriverConnect
	THIS.msg(WM_CAP_DRIVER_CONNECT, 0,0)
	IF THIS.IsCaptureConnected()
		THIS.GetCaptureDimensions
		STORE .T. TO THIS.cmdGetFrame.Enabled,;
			THIS.cmdPreview.Enabled
		THIS.Caption = THIS.Caption + ": connected, " +;
			LTRIM(STR(THIS.capWidth)) + "x" +;
			LTRIM(STR(THIS.capHeight))
	ELSE
		THIS.Caption = THIS.Caption + ": failed to connect"
	ENDIF

PROCEDURE DriverDisconnect
	THIS.msg(WM_CAP_DRIVER_DISCONNECT, 0,0)
	
PROCEDURE ReleaseCaptureWindow
	IF THIS.hCapture <> 0
		THIS.DriverDisconnect
		DECLARE INTEGER DestroyWindow IN user32 INTEGER hWnd
		= DestroyWindow(THIS.hCapture)
		THIS.hCapture = 0
	ENDIF

PROCEDURE msg(msg, wParam, lParam, nMode)
	IF THIS.hCapture = 0
		RETURN
	ENDIF

	IF VARTYPE(nMode) <> "N" Or nMode=0
		DECLARE INTEGER SendMessage IN user32;
			INTEGER hWnd, INTEGER Msg,;
			INTEGER wParam, INTEGER lParam
		= SendMessage(THIS.hCapture, msg, wParam, lParam)
	ELSE
		DECLARE INTEGER SendMessage IN user32;
			INTEGER hWnd, INTEGER Msg,;
			INTEGER wParam, STRING @lParam
		= SendMessage(THIS.hCapture, msg, wParam, @lParam)
	ENDIF

FUNCTION IsCaptureConnected
* analyzing fCaptureInitialized member of the CAPDRIVERCAPS structure
#DEFINE CAPDRIVERCAPS_SIZE 44
	LOCAL cBuffer, nResult
	cBuffer = Repli(Chr(0),CAPDRIVERCAPS_SIZE)
	THIS.msg(WM_CAP_DRIVER_GET_CAPS, Len(cBuffer), @cBuffer, 1)
	THIS.capOverlay = buf2dword(SUBSTR(cBuffer,5,4))
	nResult = Asc(SUBSTR(cBuffer, 21,1))
RETURN (nResult<>0)

PROCEDURE GetCaptureDimensions
* reading uiImageWidth and uiImageHeight members
* of the CAPSTATUS structure
#DEFINE CAPSTATUS_SIZE 76
	LOCAL cBuffer
	cBuffer = Repli(Chr(0), CAPSTATUS_SIZE)
	THIS.msg(WM_CAP_GET_STATUS, Len(cBuffer), @cBuffer, 1)
	THIS.capWidth = buf2dword(SUBSTR(cBuffer,1,4))
	THIS.capHeight = buf2dword(SUBSTR(cBuffer,5,4))
	
PROCEDURE StartPreview
	THIS.msg(WM_CAP_SET_PREVIEWRATE, 30,0)
	THIS.msg(WM_CAP_SET_PREVIEW, 1,0)
	IF THIS.capOverlay <> 0
		THIS.msg(WM_CAP_SET_OVERLAY, 1,0)
	ENDIF

PROCEDURE StopPreview
	THIS.msg(WM_CAP_SET_PREVIEW, 0,0)
ENDDEFINE

FUNCTION buf2dword(lcBuffer)
RETURN Asc(SUBSTR(lcBuffer, 1,1)) + ;
	BitLShift(Asc(SUBSTR(lcBuffer, 2,1)),  8) +;
	BitLShift(Asc(SUBSTR(lcBuffer, 3,1)), 16) +;
	BitLShift(Asc(SUBSTR(lcBuffer, 4,1)), 24)