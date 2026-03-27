*========================
FUNCTION ReadLocalTime()
*========================
* Lee mediante API el GetLocalTime
* Retorno: DATETIME o .NULL. si existe error
* Autor: LMG - 1998.09.14
*========================
LOCAL lcAuxi, ltDateTime, ;
lcSetDate, lcSetHours, lcSetCentury, ;
lcSetSysformats, lcSetMark

lcSetSysformats = SET("SYSFORMATS")
lcSetCentury = SET("CENTURY")
lcSetDate = SET("DATE")
lcSetHours = SET("HOURS")
lcSetMark = SET("MARK")

SET SYSFORMATS OFF
SET CENTURY ON
SET DATE YMD
SET HOURS TO 24
SET MARK TO "/"

DECLARE GetLocalTime IN win32api ;
STRING @lcAuxi

lcAuxi=SPAC(32)

IF GetLocalTime(@lcAuxi)
ltDateTime = CTOT( _256to10(SUBS(lcAuxi,1,2), 4) + "/" + ;
_256to10(SUBS(lcAuxi,3,2), 2) + "/" + ;
_256to10(SUBS(lcAuxi,7,2), 2) + " " + ;
_256to10(SUBS(lcAuxi,9,2), 2) + ":" + ;
_256to10(SUBS(lcAuxi,11,2), 2) + ":" + ;
_256to10(SUBS(lcAuxi,13,2), 2) )
ELSE
ltDateTime = .NULL.
ENDIF

SET MARK TO &lcSetMark
SET HOURS TO &lcSetHours
SET DATE &lcSetDate
SET CENTURY &lcSetCentury
SET SYSFORMATS &lcSetSysformats

RETURN ltDateTime
ENDFUNC

*========================
FUNCTION WriteLocalTime(ltDateTime)
*========================
* Escribe mediante API el GetLocalTime
* Parametro: Debe pasarse una variable del tipo DateTime
* Retorno: .T. si pudo cambiar fecha y hora
* .F. envio un parámetro no válido o error
* Autor: LMG - 1998.09.14
*========================
IF TYPE("ltDateTime") # "T"
RETURN .F.
ENDIF

LOCAL lcCadena

lcCadena = _10to256(YEAR(ltDateTime),2) + ;
_10to256(MONTH(ltDateTime),2) + ;
_10to256(DOW(ltDateTime),2) + ;
_10to256(DAY(ltDateTime),2) + ;
_10to256(HOUR(ltDateTime),2) + ;
_10to256(MINUTE(ltDateTime),2) + ;
_10to256(SEC(ltDateTime),2) + ;
_10to256(000,2) + SPAC(24)

DECLARE SetLocalTime IN win32api ;
STRING lcCadena

RETURN SetLocalTime(lcCadena)
ENDFUNC

*========================
FUNCTION _256to10(lcPar, lnCant)
*========================
* Toma un par de caracteres en base 256 y lo
* convierte en "lnCant" caracteres en base 10
* Usada por: ReadLocalTime()
* Autor: LMG - 1998.09.14
*========================
RETURN PADL(ALLTRIM(STR(ASC(SUBSTR(lcPar,2)) * 256 + ;
ASC(SUBSTR(lcPar,1)))), lnCant, "0")
ENDFUNC

*========================
FUNCTION _10to256(lnNumero, lnCant)
*========================
* Toma número en base 10 y lo convierte
* en "lnCant" caracteres en base 256
* Usada por: WriteLocalTime()
* Autor: LMG - 1998.09.14
*========================
LOCAL lcRetorno, lnAscii

lcRetorno=''
DO WHILE lnNumero >= 256
lnAscii=MOD(lnNumero,256)
lcRetorno=lcRetorno + CHR(lnAscii)
lnNumero=INT(lnNumero / 256)
ENDDO
lnAscii=lnNumero
lcRetorno=lcRetorno + CHR(lnAscii)
RETURN PADR(lcRetorno, lnCant, CHR(0))
ENDFUNC
*======================== 