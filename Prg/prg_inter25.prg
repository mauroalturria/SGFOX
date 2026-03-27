*********************************************************************
* Interleave 2 of 5 Code Section
*********************************************************************

private rtnp 
	nbarra = ncodbar
	rtnp = _StrToI2of5(nbarra)
	
return rtnp

*------------------------------------------------------
* FUNCTION _StrToI2of5(tcString) * INTERLEAVED 2 OF 5
*------------------------------------------------------
* Convierte un string para ser impreso con
* fuente True Type "PF Interleaved 2 of 5" ó "PF Interleaved 2 of 5 Wide"
* Solo caracteres numéricos
* USO: _StrToI2of5('1234567890')
* RETORNA: Caracter
*------------------------------------------------------
FUNCTION _StrToI2of5(tcString)
  LOCAL lcStart, lcStop, lcRet, lcCheck, ;
    lcCar, lnLong, lnI, lnSum, lnAux
  lcStart = CHR(40)
  lcStop = CHR(41)
  lcRet = ALLTRIM(tcString)
  *--- Genero dígito de control
  lnLong = LEN(lcRet)
  lnSum = 0
  lnCount = 1
  FOR lnI = lnLong TO 1 STEP -1
    lnSum = lnSum + VAL(SUBSTR(lcRet,lnI,1)) * ;
      IIF(MOD(lnCount,2) = 0,1,3)
    lnCount = lnCount + 1
  ENDFOR
  lnAux = MOD(lnSum,10)
  lcRet = lcRet + ALLTRIM(STR(IIF(lnAux = 0,0,10 - lnAux)))
  lnLong = LEN(lcRet)
  *--- La longitud debe ser par
  IF MOD(lnLong,2) # 0
    lcRet = '0' + lcRet
    lnLong = LEN(lcRet)
  ENDIF
  ncodbar = lcRet
  *--- Convierto los pares a caracteres
  lcCar = ''
  FOR lnI = 1 TO lnLong STEP 2
    IF VAL(SUBS(lcRet,lnI,2)) < 50
      lcCar = lcCar + CHR(VAL(SUBS(lcRet,lnI,2)) + 48)
    ELSE
      lcCar = lcCar + CHR(VAL(SUBS(lcRet,lnI,2)) + 142)
    ENDIF
  ENDFOR
  *--- Armo código
  lcRet = lcStart + lcCar + lcStop
  RETURN lcRet
ENDFUNC
