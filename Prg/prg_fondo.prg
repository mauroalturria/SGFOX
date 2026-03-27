Set Safety Off

Copy File "x:\qepd1a1\BackInfo\BackInfo.exe" to "c:\temp\BackInfo.exe"

If _screen.ViewPortWidth > 800 && 1024
	Copy file "x:\qepd1a1\BackInfo\Back1024.ini" to "c:\temp\BackInfo.ini"
	Copy file "x:\qepd1a1\BackInfo\1024X768.bmp" to "c:\temp\1024X768.bmp"

	Run /n c:\temp\BackInfo.exe
	delete file c:\temp\1024X768.bmp
Else
	Copy file "x:\qepd1a1\BackInfo\Back800.ini" to "c:\temp\BackInfo.ini"
	Copy file "x:\qepd1a1\BackInfo\800X600.bmp" to "c:\temp\800X600.bmp"
	Run /n c:\temp\BackInfo.exe
	
	delete file c:\temp\800X600.bmp
Endif 

delete file c:\temp\BackInfo.ini
delete file c:\temp\BackInfo.exe
