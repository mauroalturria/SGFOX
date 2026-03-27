PUBLIC oForm 
oForm = CreateObject("Tform") 
oForm.Visible = .T. 

DEFINE CLASS Tform As Form 
    Width=540 
    Height=250 
    Caption=" Scrolling text horizontally" 
    Autocenter=.T. 
     
    SrcLen=3000  && width of the source memory device context 
    TrgLen=400   && target width 
    TrgHeight=20 && target height 
    StepLen=1    && incrementing offset by 
    SrcOffs=0    && initial offset 
     
    * sample long string to be scrolled 
    content = "cadena de texto  " +; 
        "texto  " +; 
        "texto  " +; 
        "texto  " +; 
        "texto  " +; 
        "texto  " +; 
        "texto  " +; 
        "texto  " +; 
        "texto" 

    hMemDC=0   && memory device context 
    hMemBmp=0  && memory bitmap 
    hForm=0    && form"s window handle 
    hFormDC=0  && form"s device context 

    ADD OBJECT lbl1 As Tlbl WITH Left=120, Top=70, Caption="Output:" 
    ADD OBJECT lbl2 As Tlbl WITH Left=220, Top=70, Caption="Speed:" 
    ADD OBJECT tm As Timer WITH interval=0 
    ADD OBJECT ogOutput As Toutput WITH Left=120, Top=90 
    ADD OBJECT ogSpeed As Tspeed WITH Left=220, Top=90 

PROCEDURE Init 
    THIS.decl 
    THIS.CreateSource 

PROCEDURE Destroy 
* releasing system resources 
    = ReleaseDC(THIS.hForm, THIS.hFormDC) 
    = DeleteObject(THIS.hMemBmp) 
    = DeleteDC(THIS.hMemDC) 

PROCEDURE Activate 
    IF ThisForm.hForm = 0 
    * retrieving window handle and device context for the form 
        ThisForm.hForm = GetFocus() 
        ThisForm.hFormDC = GetWindowDC(ThisForm.hForm) 
    ENDIF 
     
PROCEDURE tm.timer 
    ThisForm.CopyToTarget  && refreshing display window 

PROCEDURE ogSpeed.InteractiveChange 
* changing scroll speed 
    DO CASE 
    CASE THIS.Value = 1 
        ThisForm.tm.interval = 0 
    CASE THIS.Value = 2 
        ThisForm.tm.interval = 100 
    CASE THIS.Value = 3 
        ThisForm.tm.interval = 50 
    CASE THIS.Value = 4 
        ThisForm.tm.interval = 20 
    CASE THIS.Value = 5 
        ThisForm.tm.interval = 10 
    CASE THIS.Value = 6 
        ThisForm.tm.interval = 5 
    ENDCASE 

PROCEDURE CreateSource 
* creating compatible device context and placing text on it 
    DECLARE INTEGER GetDesktopWindow IN user32 
    DECLARE INTEGER CreateCompatibleDC IN gdi32 INTEGER hdc 
    DECLARE INTEGER CreateCompatibleBitmap IN gdi32;   
        INTEGER hdc, INTEGER nWidth, INTEGER nHeight 

    LOCAL hDsk, hDskDC, hBr, rect 
    hDsk = GetDesktopWindow() 
    hDskDC = GetWindowDC(hDsk) 
     
    * creating memory device context 
    * the whole string will be printed on it 
    THIS.hMemDC = CreateCompatibleDC(hDskDC) 
    THIS.hMemBmp = CreateCompatibleBitmap(hDskDC,; 
        THIS.SrcLen, THIS.TrgHeight) 

    = DeleteObject(SelectObject(THIS.hMemDC, THIS.hMemBmp)) 

    * setting background color 
    hBr = CreateSolidBrush(ThisForm.BackColor) 
    rect = num2dword(0) + num2dword(0) +; 
        num2dword(THIS.SrcLen) + num2dword(THIS.TrgHeight) 
    = FillRect(THIS.hMemDC, @rect, hBr) 
    = DeleteObject(hBr) 

    * setting text parameters 
*    = SetBkColor(THIS.hMemDC, Rgb(0,0,128)) 
    = SetBkMode(THIS.hMemDC, 1)  && transparent 
    = SetTextColor(THIS.hMemDC, ThisForm.ForeColor) 

    * default font is used for this device context 
    * use CreateFont+SelectObject functions to select another font 
    = TextOut(THIS.hMemDC, 0,0, THIS.content, Len(THIS.content)) 
    = ReleaseDC(hDsk, hDskDC) 
     
PROCEDURE CopyToTarget 
* copying smaller portions from memory device context to the target 
#DEFINE SRCCOPY     13369376 
    LOCAL hTarget, hTargetDC, x,y 
     
    * the target either main FoxPro window or the form 
    IF THIS.ogOutput.Value = 1 
        hTarget = GetActiveWindow() 
        hTargetDC = GetWindowDC(hTarget) 
        x = 100 
        y = 100 
    ELSE 
        hTarget = 0 
        hTargetDC = ThisForm.hFormDC 
        x = 10 
        y = 30 
        THIS.TrgLen = ThisForm.Width - 10 
    ENDIF 
     
    = BitBlt(hTargetDC, x,y, THIS.TrgLen, THIS.TrgHeight,; 
        THIS.hMemDC, THIS.SrcOffs, 0, SRCCOPY) 

    * incrementing offset for the following copying steps 
    THIS.SrcOffs = THIS.SrcOffs + THIS.StepLen 
    IF THIS.SrcOffs + THIS.TrgLen > THIS.SrcLen 
        THIS.SrcOffs = 0 
    ENDIF 
     
    IF hTarget <> 0 
        = ReleaseDC(hTarget, hTargetDC) 
    ENDIF 

PROCEDURE decl 
    DECLARE INTEGER GetFocus IN user32 
    DECLARE INTEGER GetActiveWindow IN user32 
    DECLARE INTEGER DeleteDC IN gdi32 INTEGER hdc 
    DECLARE INTEGER DeleteObject IN gdi32 INTEGER hObj 
    DECLARE INTEGER GetWindowDC IN user32 INTEGER hwnd 
    DECLARE INTEGER CreateSolidBrush IN gdi32 LONG crColor 
    DECLARE INTEGER ReleaseDC IN user32 INTEGER hwnd, INTEGER hdc 
    DECLARE INTEGER SetBkColor IN gdi32 INTEGER hdc, LONG crColor 
    DECLARE INTEGER SelectObject IN gdi32 INTEGER hdc, INTEGER hObj 
    DECLARE INTEGER SetBkMode IN gdi32 INTEGER hdc, INTEGER iBkMode 
    DECLARE INTEGER SetTextColor IN gdi32 INTEGER hdc, INTEGER crColor 

    DECLARE INTEGER FillRect IN user32; 
        INTEGER hDC, STRING @RECT, INTEGER hBrush 

    DECLARE INTEGER TextOut IN gdi32; 
        INTEGER hdc, INTEGER x, INTEGER y,;   
        STRING lpString, INTEGER nCount 

    DECLARE INTEGER BitBlt IN gdi32 INTEGER hDestDC,; 
        INTEGER x, INTEGER y, INTEGER nWidth, INTEGER nHeight,; 
        INTEGER hSrcDC, INTEGER xSrc, INTEGER ySrc, INTEGER dwRop 
ENDDEFINE 

DEFINE CLASS Tlbl As Label 
    Autosize=.T. 
    Backstyle=0 
ENDDEFINE 

DEFINE CLASS Toutput As OptionGroup 
    ButtonCount=2 
    Autosize=.T. 
    Option1.Caption="Screen" 
    Option1.Top=5 
    Option1.Autosize=.T. 
    Option2.Caption="Form" 
    Option2.Top=30 
    Option2.Autosize=.T. 
ENDDEFINE 

DEFINE CLASS Tspeed As OptionGroup 
    ButtonCount=6 
    Autosize=.T. 
    Option1.Caption="Stop" 
    Option2.Caption="Slow" 
    Option3.Caption="..." 
    Option4.Caption="Recommended" 
    Option5.Caption="..." 
    Option6.Caption="Fast" 

PROCEDURE Init 
    LOCAL ii, obj, nTop 
    nTop = 5 
    FOR ii=1 To 6 
        obj = Eval("THIS.Option" + LTRIM(STR(ii))) 
        WITH obj 
            .Top=nTop 
            .Autosize=.T. 
            nTop = nTop + 20 
        ENDWITH 
    ENDFOR 
ENDDEFINE 

FUNCTION  num2dword (lnValue) 
#DEFINE m0       256 
#DEFINE m1     65536 
#DEFINE m2  16777216 
    LOCAL b0, b1, b2, b3 
    b3 = Int(lnValue/m2) 
    b2 = Int((lnValue - b3*m2)/m1) 
    b1 = Int((lnValue - b3*m2 - b2*m1)/m0) 
    b0 = Mod(lnValue, m0) 
RETURN Chr(b0)+Chr(b1)+Chr(b2)+Chr(b3)