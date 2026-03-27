 LPARAMETERS lcFileName
 LOCAL lnReturn, lcBuffer

 Declare Integer GetShortPathNameA In Win32API As GetShortPathName String, String, Integer

 lcBuffer = SPACE(255)
 lnReturn= GetShortPathName(lcFileName, @lcBuffer, 255)

 Clear Dlls "GetShortPathName"
 
 Return (Left(lcBuffer, lnReturn))
