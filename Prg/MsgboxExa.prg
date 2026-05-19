Lparameters tcCaption, tnIcon, tcTitle, tcButtons, tcIconFile
* msgboxex.prg
* description: modifies the Captions of messagebox Buttons
* Parameters:
* tcCaption - the text that appears in the dialog box.
* tnIcon - the Icon sign
* tcTitle - the text that appears in the Title bar of the dialog box
* tcButtons - the Captions to be used in the Buttons using the comma "," delimiter
* use the "&" character to determine the hotkeys to be used - eg: "option&1,option&2,option&3"
* use a "\" to disable the Button
* tcIconFile - the Icon File to replace the default from messagebox()
* returns: the index number according to the option selected - eg. returns the value 3 if the 3rd Button was selected.
* sample:
* =MsgBoxEx("This is a common text", "!", "Window Title", "Option 1,Option 2,Option 3")

* Special thanks to:
* Herman Tan - Article: 'Centering VFP MessageBox in any Form'
* http://hermantan.blogspot.com/2008/07/centering-vfp-messagebox-in-any-form.html
* Craig boyd - Article: 'BindEvents on Steroids'
* http://www.sweetpotatosoftware.com/spsblog/2005/08/07/bindeventonsteroids.aspx

Local loMsgB, lnReturn
loMsgB = Createobject("xmbMsgBoxEx")
lnReturn = loMsgB.SendMessage(tcCaption, tnIcon, tcTitle, tcButtons, tcIconFile)
loMsgB = Null
Return lnReturn

Define Class xmbMsgBoxEx As Custom
	nButtonCnt = 0
	cButtons   = ""
	nbutttype  = 0
	cIconFile  = ""
	hIcon      = 0

	Procedure SendMessage
	Lparameters tcCaption, tnIcon, tcTitle, tcButtons, tcIconFile
	If Vartype(tntimeout) = "C" And (Pcount() = 4)
		tcButtons = tntimeout
		tntimeout = 0
	Endif

	Private pnButtonCnt, pcButtons, pnbutttype, pcIconFile, phIcon
	This.cIconFile = Iif(Empty(tcIconFile),"", tcIconFile)
	This.nButtonCnt = Getwordcount(tcButtons, ",")
	This.cButtons = tcButtons
*!* stop 16
*!* question 32
*!* exclamation 48
*!* info 64
	If Vartype(tnIcon) = "C"
		tnIcon = Upper(tnIcon)
		Do Case
		Case tnIcon = "X"
			tnIcon = 16
		Case tnIcon = "?"
			tnIcon = 32
		Case tnIcon = "!"
			tnIcon = 48
		Case tnIcon = "I"
			tnIcon = 64
		Otherwise
			tnIcon = 0
		Endcase
	Endif

* check if an Icon will be shown
* if an Icon File was passed, we need to ensure that messagebox() will
* show an Icon, that will be changed further.

	#Define image_bitmap 0
	#Define image_Icon 1
	#Define lr_loadfromFile 0x0010
	#Define lr_defaultsize 0x0040
	This.hIcon = 0
	If Not Empty(This.cIconFile) And ;
			(Not (Bittest(tnIcon, 4) Or Bittest(tnIcon, 5) Or Bittest(tnIcon, 6)))
		tnIcon = tnIcon + 16
		This.hIcon = xmbLoadImage(0, Fullpath(This.cIconFile), image_Icon,;
			0,0, lr_loadfromFile + lr_defaultsize)
	Endif

* this messagebox will be modified before it is shown
	Local lnoption, lnIndex
	Do Case
	Case This.nButtonCnt = 1
		This.nbutttype = 0 && ok
	Case This.nButtonCnt = 2
		This.nbutttype = 4 && yes / no
	Case This.nButtonCnt = 3
		This.nbutttype = 2 && abort / retry / ignore
	Otherwise
	Endcase

	Bindevent( 0, 0x06, This, 'WndProc' )
	lnoption = Messagebox(tcCaption, tnIcon + This.nbutttype, tcTitle)
	Unbindevents( 0, 0x06 )

	Local lnOffset
	lnOffset = Icase(This.nButtonCnt = 3, 2, This.nButtonCnt = 2, 5 , 0)
	lnIndex = lnoption - lnOffset

	If This.hIcon <> 0
		=xmbdeleteobject(This.hIcon) && clear Icon handle
	Endif

	Return lnIndex

	Endproc

* Windows event handler procedure
* MSDN WindowProc callback function
* http://msdn.microsoft.com/en-us/library/windows/desktop/ms633573(v=vs.85).aspx
* http://hermantan.blogspot.com/2008/07/centering-vfp-messagebox-in-any-form.html
* Here we will make all the modifications in the Windows dialog
	Procedure WndProc( th_Wnd, tn_Msg, t_wParam, t_lParam )

	If (tn_Msg == 0x06) And (t_wParam == 0) And (t_lParam <> 0)

		wParam = t_lParam

		#Define dlg_ctrlid_Icon 0x0014
		#Define stm_setIcon 0x0170
		#Define stm_setimage 0x0172
		If Not Empty(This.hIcon)
* changing the dialog Icon
			Local lhIconwindow
			lhIconwindow = xmbGetDlgItem(wParam, dlg_ctrlid_Icon)
			If lhIconwindow <> 0
				If This.hIcon <> 0
					=xmbSendMessage(lhIconwindow, stm_setIcon, This.hIcon, 0)
				Endif
			Endif
		Endif

* Set tansparency
		If Vartype(_Screen.xmbMessageboxTransp) = "N"
			Local lnTransp
			lnTransp = _Screen.xmbMessageboxTransp
			If lnTransp > 30 And lnTransp < 255 && values lower than 30 generate an almost invisible dialog!!!
				lnTransp = Min(Int(lnTransp), 254)
				=xmbSetWindowLong( wParam, -20, ;
					BITOR( xmbGetWindowLong( wParam, -20 ), 0x80000 ))
				=xmbSetLayeredWindowAttributes( wParam, 0, lnTransp, 2 )
			Endif
		Endif

* change Button attributes
		Local N, lnOffset, lcCaption
		lnOffset = Icase(This.nButtonCnt = 3, 2, This.nButtonCnt = 2, 5 , 0)
		Local lnBtnhWnd
		For N = 1 To This.nButtonCnt
			lcCaption = Getwordnum(This.cButtons, N, ",") + Chr(0)
* disable current Button
			If Left(lcCaption, 1) = "\"
				lcCaption = Substr(lcCaption, 2) && get the rest of the string
				lnBtnhWnd = xmbGetDlgItem(wParam, lnOffset + N)
				=xmbEnableWindow(lnBtnhWnd, 0)
			Endif

* change the Caption
			=xmbSetDlgItemtext(wParam, lnOffset + N, lcCaption)
		Endfor

	Endif

	Local pOrgProc
	pOrgProc = xmbGetWindowLong( _vfp.HWnd, -4 )
	= xmbCallWindowProc( pOrgProc, th_Wnd, tn_Msg, t_wParam, t_lParam )
	Endproc

Enddefine

*********************************************************************
Function xmbSetDlgItemtext(hdlg, nidDlgItem, lpString)
*********************************************************************
Declare Integer SetDlgItemText In user32 As xmbsetDlgItemtext ;
	LONG hdlg,;
	LONG nidDlgItem,;
	STRING lpString
Return xmbSetDlgItemtext(hdlg, nidDlgItem, lpString)
Endfunc

*********************************************************************
Function xmbCallNextHookEx(hhook, ncode, wParam, Lparam)
*********************************************************************
Declare Long callnexthookex In user32 As xmbcallnexthookex ;
	LONG hhook, Long ncode, Long wParam, Long Lparam
Return xmbCallNextHookEx(hhook, ncode, wParam, Lparam)
Endfunc

*********************************************************************
Function xmbGetDlgItem(hdlg, nidDlgItem)
*********************************************************************
* hdlg [in] handle to the dialog box that contains the control.
* nidDlgItem [in] specifies the identifier of the control to be retrieved.
* http://msdn.microsoft.com/en-us/library/ms645481(vs.85).aspx
Declare Integer GetDlgItem In user32 As xmbgetDlgItem ;
	LONG hdlg,;
	LONG nidDlgItem
Return xmbGetDlgItem(hdlg, nidDlgItem)
Endfunc

*********************************************************************
Function xmbEnableWindow(HWnd, fEnable)
*********************************************************************
Declare Integer EnableWindow In user32 As xmbEnablewindow Integer HWnd, Integer fEnable
Return xmbEnableWindow(HWnd, fEnable)
Endfunc

*********************************************************************
Function xmbSendMessage(hwindow, msg, wParam, Lparam)
*********************************************************************
* http://msdn.microsoft.com/en-us/library/bb760780(vs.85).aspx
* http://www.news2news.com/vfp/?group=-1&function=312
Declare Integer SendMessage In user32 As xmbsendmessage;
	INTEGER hwindow, Integer msg,;
	INTEGER wParam, Integer Lparam
Return xmbSendMessage(hwindow, msg, wParam, Lparam)
Endfunc

*********************************************************************
Function xmbLoadImage(hinst, lpszname, utype, cxdesired, cydesired, fuload)
*********************************************************************
Declare Integer LoadImage In user32 As xmbloadimage;
	INTEGER hinst,;
	STRING lpszname,;
	INTEGER utype,;
	INTEGER cxdesired,;
	INTEGER cydesired,;
	INTEGER fuload
Return xmbLoadImage(hinst, lpszname, utype, cxdesired, cydesired, fuload)
Endfunc

*********************************************************************
Function xmbdeleteobject(hobject)
*********************************************************************
Declare Integer DeleteObject In gdi32 As xmbdeleteobject Integer hobject
Return xmbdeleteobject(hobject)
Endfunc

*********************************************************************
Function xmbCallWindowProc(lpPrevWndFunc, nhWnd, uMsg, wParam, Lparam)
*********************************************************************
Declare Long CallWindowProc In User32 ;
	AS xmbCallWindowProc ;
	LONG lpPrevWndFunc, Long nhWnd, ;
	LONG uMsg, Long wParam, Long Lparam
Return xmbCallWindowProc(lpPrevWndFunc, nhWnd, uMsg, wParam, Lparam)
Endfunc

*********************************************************************
Function xmbGetWindowLong(nhWnd, nIndex)
*********************************************************************
Declare Long GetWindowLong In User32 ;
	AS xmbGetWindowLong ;
	LONG nhWnd, Integer nIndex
Return xmbGetWindowLong(nhWnd, nIndex)
Endfunc

*********************************************************************
Function xmbSetWindowLong(nhWnd, nIndex, nNewVal)
*********************************************************************
Declare Integer SetWindowLong In Win32Api ;
	AS xmbSetWindowLong ;
	INTEGER nHWnd, Integer nIndex, Integer nNewVal
Return xmbSetWindowLong(nhWnd, nIndex, nNewVal)
Endfunc

*********************************************************************
Function xmbSetLayeredWindowAttributes(nhWnd, cColorKey, nOpacity, nFlags)
*********************************************************************
Declare Integer SetLayeredWindowAttributes In Win32Api ;
	AS xmbSetLayeredWindowAttributes ;
	INTEGER nHWnd, String cColorKey, ;
	INTEGER nOpacity, Integer nFlags
Return xmbSetLayeredWindowAttributes(nhWnd, cColorKey, nOpacity, nFlags)
Endfunc

*********************************************************************
