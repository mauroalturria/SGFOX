LOCAL oForm
oForm = CREATEOBJECT("Tform")
oForm.VISIBLE = .T.
READ EVENTS

DEFINE CLASS Tform AS FORM
  WIDTH = 760
  HEIGHT = 500
  AUTOCENTER = .T.
  CAPTION = "Using Video Capture"
  MINBUTTON = .F.
  MAXBUTTON = .F.
  SHOWWINDOW = 2
  BORDERSTYLE = 2
  SHOWTIPS = .T.

  ADD OBJECT cmdClose AS COMMANDBUTTON WITH CANCEL = .T.,;
    LEFT = 10, TOP = 150, HEIGHT = 27, WIDTH = 100, CAPTION = "Close"

  ADD OBJECT cmdGetFrame AS COMMANDBUTTON WITH;
    LEFT = 10, TOP = 5, HEIGHT = 27, WIDTH = 100, CAPTION = "Get Frame",;
    ENABLED = .F., TOOLTIPTEXT = "Updates the frame"

  ADD OBJECT cmdPreview AS COMMANDBUTTON WITH DEFAULT = .T.,;
    LEFT = 10, TOP = 33, HEIGHT = 27, WIDTH = 100, CAPTION = "Preview Video",;
    ENABLED = .F., TOOLTIPTEXT = "Turns preview mode on"

  ADD OBJECT cmdSave AS COMMANDBUTTON WITH LEFT = 10, TOP = 61,;
    HEIGHT = 27, WIDTH = 100, CAPTION = "Save to BMP",;
    TOOLTIPTEXT = "Saves current frame to BMP file"

  ADD OBJECT cmdFormat AS COMMANDBUTTON WITH LEFT = 10, TOP = 100,;
    HEIGHT = 27, WIDTH = 100, CAPTION = "Format",;
    TOOLTIPTEXT = "Displays available formats"

  ADD OBJECT capwindow AS TCaptureWindow

  PROCEDURE INIT
    =BINDEVENT(THIS.capwindow, "ResizeCaptureWindow",THIS, "OnCaptureWindowResized", 1)
  ENDPROC

  PROCEDURE ACTIVATE
    IF THIS.capwindow.hWindow = 0
      IF THIS.capwindow.InitCaptureWindow(THIS.HWND, 120, 5)
        STORE .T. TO THIS.cmdGetFrame.ENABLED,;
          THIS.cmdPreview.ENABLED
        THISFORM.capwindow.StartPreview
      ENDIF
    ENDIF
  ENDPROC

  PROCEDURE DESTROY
    CLEAR EVENTS
  ENDPROC

  PROCEDURE cmdClose.CLICK
    THISFORM.RELEASE
  ENDPROC

  PROCEDURE cmdGetFrame.CLICK
    THISFORM.capwindow.GetFrame
  ENDPROC

  PROCEDURE cmdPreview.CLICK
    THISFORM.capwindow.StartPreview
  ENDPROC

  PROCEDURE cmdFormat.CLICK
    THISFORM.capwindow.FormatDlg
  ENDPROC

  PROCEDURE cmdSave.CLICK
    THISFORM.capwindow.SaveToDib
  ENDPROC

  PROCEDURE OnCaptureWindowResized
    WITH THIS.capwindow
      IF .capWidth = 0 OR .capHeight = 0
        RETURN
      ENDIF
      THIS.WIDTH = MAX(320, .capLeft+.capWidth+5)
      THIS.HEIGHT = MAX(240, .capTop+.capHeight+25)
      THIS.cmdClose.TOP = THIS.HEIGHT-60
    ENDWITH
  ENDPROC

ENDDEFINE

DEFINE CLASS TCaptureWindow AS CUSTOM
  #DEFINE WM_CAP_START  0x0400
  #DEFINE WM_CAP_DRIVER_CONNECT    (WM_CAP_START+10)
  #DEFINE WM_CAP_DRIVER_DISCONNECT (WM_CAP_START+11)
  #DEFINE WM_CAP_DRIVER_GET_CAPS   (WM_CAP_START+14)
  #DEFINE WM_CAP_FILE_SAVEDIB      (WM_CAP_START+25)
  #DEFINE WM_CAP_DLG_VIDEOFORMAT   (WM_CAP_START+41)
  #DEFINE WM_CAP_GET_VIDEOFORMAT   (WM_CAP_START+44)
  #DEFINE WM_CAP_SET_VIDEOFORMAT   (WM_CAP_START+45)
  #DEFINE WM_CAP_SET_PREVIEW       (WM_CAP_START+50)
  #DEFINE WM_CAP_SET_OVERLAY       (WM_CAP_START+51)
  #DEFINE WM_CAP_SET_PREVIEWRATE   (WM_CAP_START+52)
  #DEFINE WM_CAP_SET_SCALE         (WM_CAP_START+53)
  #DEFINE WM_CAP_GET_STATUS        (WM_CAP_START+54)
  #DEFINE WM_CAP_GRAB_FRAME        (WM_CAP_START+60)

  #DEFINE WS_CHILD 0x40000000
  #DEFINE WS_VISIBLE 0x10000000
  #DEFINE SWP_SHOWWINDOW 0x40
  #DEFINE BITMAPINFOHEADER_SIZE 40
  #DEFINE CAPDRIVERCAPS_SIZE 44

  hWindow = 0
  hCapture = 0
  capWidth = 0
  capHeight = 0
  capOverlay = 0
  capLeft = 0
  capTop = 0

  PROCEDURE INIT
    THIS.DECLARE
  ENDPROC

  PROCEDURE DESTROY
    THIS.ReleaseCaptureWindow
  ENDPROC

  PROCEDURE InitCaptureWindow(hParent, nLeft, nTop)
    WITH THIS
      .hWindow = m.hParent
      .capLeft = m.nLeft
      .capTop = m.nTop
      STORE 0 TO .capWidth, .capHeight

      .hCapture = capCreateCaptureWindow("",;
        BITOR(WS_CHILD,WS_VISIBLE), .capLeft, .capTop,;
        1,1, .hWindow, 1)

      IF .DriverConnect()
        .msg(WM_CAP_SET_SCALE, 1, 0)
        .ResizeCaptureWindow
      ENDIF
    ENDWITH
    RETURN THIS.IsCaptureConnected()
  ENDPROC

  PROCEDURE msg(msg, wParam, LPARAM, nMode)
    DO CASE
      CASE THIS.hCapture = 0
      CASE VARTYPE(nMode) <> "N" OR nMode = 0
        =SendMsgInt(THIS.hCapture, msg, wParam, LPARAM)
      OTHERWISE
        =SendMsgStr(THIS.hCapture, msg, wParam, @LPARAM)
    ENDCASE
  ENDPROC

  PROCEDURE ResizeCaptureWindow
    THIS.GetVideoFormat
    =SetWindowPos(THIS.hCapture, 0, THIS.capLeft,THIS.capTop,;
      THIS.capWidth, THIS.capHeight, SWP_SHOWWINDOW)
  ENDPROC

  PROCEDURE DriverConnect
    THIS.msg(WM_CAP_DRIVER_CONNECT, 0,0)
    IF THIS.IsCaptureConnected()
      RETURN .T.
    ELSE
      RETURN .F.
    ENDIF
  ENDPROC

  PROCEDURE DriverDisconnect
    THIS.msg(WM_CAP_DRIVER_DISCONNECT, 0,0)
  ENDPROC

  PROCEDURE ReleaseCaptureWindow
    IF THIS.hCapture <> 0
      THIS.DriverDisconnect
      = DestroyWindow(THIS.hCapture)
      THIS.hCapture = 0
    ENDIF
  ENDPROC

  PROCEDURE GetFrame
    THIS.msg(WM_CAP_GRAB_FRAME, 0,0)
  ENDPROC

  PROCEDURE GetVideoFormat
    LOCAL cBuffer, nBufsize
    nBufsize = 4096
    cBuffer = PADR(THIS.num2dword(BITMAPINFOHEADER_SIZE), nBufsize, CHR(0))
    THIS.msg(WM_CAP_GET_VIDEOFORMAT, nBufsize, @cBuffer, 1)
    THIS.capWidth = THIS.buf2dword(SUBSTR(cBuffer, 5,4))
    THIS.capHeight = THIS.buf2dword(SUBSTR(cBuffer, 9,4))
  ENDPROC

  PROCEDURE FormatDlg
    THIS.msg(WM_CAP_DLG_VIDEOFORMAT, 0,0)
    THIS.ResizeCaptureWindow
  ENDPROC

  FUNCTION IsCaptureConnected
    LOCAL cBuffer, nResult
    cBuffer = REPLI(CHR(0),CAPDRIVERCAPS_SIZE)
    THIS.msg(WM_CAP_DRIVER_GET_CAPS, LEN(cBuffer), @cBuffer, 1)
    THIS.capOverlay = THIS.buf2dword(SUBSTR(cBuffer,5,4))
    nResult = ASC(SUBSTR(cBuffer, 21,1))
    RETURN (nResult <> 0)
  ENDPROC

  PROCEDURE StartPreview
    THIS.msg(WM_CAP_SET_PREVIEWRATE,30,0)
    THIS.msg(WM_CAP_SET_PREVIEW, 1,0)
    IF THIS.capOverlay <> 0
      THIS.msg(WM_CAP_SET_OVERLAY,1,0)
    ENDIF
  ENDPROC

  PROCEDURE StopPreview
    THIS.msg(WM_CAP_SET_PREVIEW, 0,0)
  ENDPROC

  PROCEDURE SaveToDib
    LOCAL cFilename
    cFilename = "pic" + SYS(2015) + ".bmp" + CHR(0)
    THIS.msg(WM_CAP_FILE_SAVEDIB, 0, @cFilename, 1)
  ENDPROC

  PROCEDURE DECLARE
    DECLARE INTEGER DestroyWindow IN user32 INTEGER hWindow

    DECLARE INTEGER capCreateCaptureWindow IN avicap32;
      STRING lpszWindowName, LONG dwStyle,;
      INTEGER x, INTEGER Y, INTEGER nWidth,;
      INTEGER nHeight, INTEGER hParent, INTEGER nID

    DECLARE INTEGER SetWindowPos IN user32;
      INTEGER hWindow, INTEGER hWndInsertAfter,;
      INTEGER x, INTEGER Y, INTEGER cx, INTEGER cy,;
      INTEGER wFlags

    DECLARE INTEGER SendMessage IN user32 AS SendMsgInt;
      INTEGER hWindow, INTEGER Msg,;
      INTEGER wParam, INTEGER LPARAM

    DECLARE INTEGER SendMessage IN user32 AS SendMsgStr;
      INTEGER hWindow, INTEGER Msg,;
      INTEGER wParam, STRING @LPARAM
  ENDPROC

  PROCEDURE buf2dword(lcBuffer)
    RETURN ASC(SUBSTR(lcBuffer, 1,1)) + ;
      BITLSHIFT(ASC(SUBSTR(lcBuffer, 2,1)),  8) +;
      BITLSHIFT(ASC(SUBSTR(lcBuffer, 3,1)), 16) +;
      BITLSHIFT(ASC(SUBSTR(lcBuffer, 4,1)), 24)
  ENDPROC

  PROCEDURE num2dword(lnValue)
    #DEFINE m0 0x100
    #DEFINE m1 0x10000
    #DEFINE m2 0x1000000
    IF lnValue < 0
      lnValue = 0x100000000 + lnValue
    ENDIF
    LOCAL b0, b1, b2, b3
    b3 = INT(lnValue/m2)
    b2 = INT((lnValue - b3*m2)/m1)
    b1 = INT((lnValue - b3*m2 - b2*m1)/m0)
    b0 = MOD(lnValue, m0)
    RETURN CHR(b0)+CHR(b1)+CHR(b2)+CHR(b3)
  ENDPROC

ENDDEFINE