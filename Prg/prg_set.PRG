Set Ansi On
Set Bell Off
Set Cent On
Set Compatible Off
Set Conf On
Set Date To French
Set Decimal To 2
Set Dele On
Set Exact On
Set Exclu Off
Set Fdow To 1
Set Hours To 24
Set Near On
Set Notify Off
Set Path To scx, lib, mnu, prg, Exe, bmp, rep
Set Optimize On
Set Point To ","
Set Safety Off
Set Separator To "."
Set Status Off
Set Status Bar Off
Set Talk Off
Set Sysmenu Off

If Int(Version(5)/100) = 9
	SYS(3099,70)
*	Set Enginebehavior 70
Endif 
