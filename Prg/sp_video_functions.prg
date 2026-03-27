*** ------------------------------------
FUNCTION buf2dword(lcBuffer)
RETURN Asc(SUBSTR(lcBuffer, 1,1)) + ;
	BitLShift(Asc(SUBSTR(lcBuffer, 2,1)),  8) +;
	BitLShift(Asc(SUBSTR(lcBuffer, 3,1)), 16) +;
	BitLShift(Asc(SUBSTR(lcBuffer, 4,1)), 24)

*** ------------------------------------
FUNCTION num2dword(lnValue)
#DEFINE m0 0x100
#DEFINE m1 0x10000
#DEFINE m2 0x1000000
	IF lnValue < 0
		lnValue = 0x100000000 + lnValue
	ENDIF
	LOCAL b0, b1, b2, b3
	b3 = Int(lnValue/m2)
	b2 = Int((lnValue - b3*m2)/m1)
	b1 = Int((lnValue - b3*m2 - b2*m1)/m0)
	b0 = Mod(lnValue, m0)
RETURN Chr(b0)+Chr(b1)+Chr(b2)+Chr(b3)

*!*	FUNCTION buf2dword(lcBuffer)
*!*	RETURN Asc(SUBSTR(lcBuffer, 1,1)) + ;
*!*	    BitLShift(Asc(SUBSTR(lcBuffer, 2,1)), 8) +;
*!*	    BitLShift(Asc(SUBSTR(lcBuffer, 3,1)), 16) +;
*!*	    BitLShift(Asc(SUBSTR(lcBuffer, 4,1)), 24)