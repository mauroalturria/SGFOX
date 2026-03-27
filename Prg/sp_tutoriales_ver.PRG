*
* Visualizar archivos de Videos / AVI
*
Lparameters mavidir

Declare LONG mciSendString IN "winmm.dll";
	STRING lpstrCommand,;
	STRING lpstrReturnString,;
	LONG uReturnLength,;
	LONG hwndCallback

*=mciSendString("play c:/temp/hce1.avi fullscreen", 0, 0, 0)
*=mciSendString("play c:/temp/hce.mpg fullscreen", 0, 0, 0)

mreproduce = "play "+StrTran(mavidir,'\','/')+" fullscreen"
=mciSendString(mreproduce, 0, 0, 0)
=mciSendString('', 0, 0, 0)

Release mciSendString
