If !Directory("C:\temp\informes")
	Mkdir "C:\temp\informes"
ENDIF
If !Directory("C:\temp\afipqr")
	Mkdir "C:\temp\afipqr"
ENDIF
 
lcdirupdate  = "x:\qepd1a1\ultimos\exe\qrcodelib.dll"  
lcdirlocal   = "C:\qepd1a1\Exe\qrcodelib.dll"  
IF !FILE(lcdirlocal)
	Copy File (lcdirupdate ) To (lcdirlocal)
endif