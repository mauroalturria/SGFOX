Parameters lcIp

*lcIp = "172.16.1.31"
*lcIp = "172.16.1.12"
*lcIp = "172.16.1.12"

lcFile = "C:\temp\vnc.vnc"
lcClaveSG = "3687f4883610aa8c"
lcClaveBristol = "335821ff4b09bc23"

If "172.16" $ Alltrim(lcIp)
	lcPass = lcClaveSG 
Else
	lcPass = lcClaveBristol 
Endif

lnHand = Fcreate(lcFile)
Fputs(lnHand ,"[connection]")
Fputs(lnHand ,"host=" + lcIp)
Fputs(lnHand ,"port=5900")
Fputs(lnHand ,"password=" + lcPass)
Fputs(lnHand ,"[options]")
Fputs(lnHand ,"use_encoding_1=1")
Fputs(lnHand ,"copyrect=1")
Fputs(lnHand ,"viewonly=0")
Fputs(lnHand ,"fullscreen=0")
Fputs(lnHand ,"8bit=0")
Fputs(lnHand ,"shared=1")
Fputs(lnHand ,"belldeiconify=0")
Fputs(lnHand ,"disableclipboard=0")
Fputs(lnHand ,"swapmouse=0")
Fputs(lnHand ,"fitwindow=0")
Fputs(lnHand ,"cursorshape=1")
Fputs(lnHand ,"noremotecursor=0")
Fputs(lnHand ,"preferred_encoding=7")
Fputs(lnHand ,"compresslevel=-1")
Fputs(lnHand ,"quality=6")
Fputs(lnHand ,"localcursor=1")
Fputs(lnHand ,"scale_den=1")
Fputs(lnHand ,"scale_num=1")
Fputs(lnHand ,"local_cursor_shape=1")
FClose(lnHand)

Declare Integer ShellExecute In shell32;
	integer HWnd,;
	string  lpOperation,;
	string  lpFile,;
	string  lpParameters,;
	string  lpDirectory,;
	integer nShowCmd

lnModo = 1

lcParam = ""
lcdirlocal = ""
lnshellreturn = ShellExecute(0, "Open", lcFile , lcParam , lcdirlocal ,1)
