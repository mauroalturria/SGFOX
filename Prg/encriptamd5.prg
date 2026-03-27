#include "C:\DESAGUEMES\wincrypt.h"
FUNCTION EncriptaMD5(cxclave)  && Encriptacion MD5, devolviendo caracteres Hexadecimales

PRIVATE encripAscii, encripHexa

encripAscii = hashmd5(cxclave)  && Devuelve string en caracteres Ascii
 
encripHexa  = Ascii2Hexa(encripAscii)  && Convierte la cxclave encriptada a representacion Hexa

RETURN encripHexa


FUNCTION Ascii2Hexa(cxclaveAscii)   && Representacion en Hexa
PRIVATE cxclaveHexa, i, ValorAscii, ValorHexa

cxclaveHexa = ''
FOR i = 1 TO LEN(cxclaveAscii)
 ValorAscii =  ASC(SUBSTR(cxclaveAscii, i, 1))
 ValorHexa  = SUBSTR(TRANSFORM(ValorAscii,"@0"),9,2)
 *?i, ValorAscii, TRANSFORM(ValorAscii,"@0")
 cxclaveHexa =  cxclaveHexa + ValorHexa
ENDFOR

RETURN LOWER(cxclaveHexa)



FUNCTION HashMD5(tcData)

  LOCAL lnStatus, lnErr, lhProv, lhHashObject, lnDataSize, lcHashValue, lnHashSize
  lhProv = 0
  lhHashObject = 0
  lnDataSize = LEN(tcData)
  lcHashValue = REPLICATE(CHR(0), 16)
  lnHashSize = LEN(lcHashValue)


  TRY

    DECLARE INTEGER GetLastError ;
      IN win32api AS GetLastError

    DECLARE INTEGER CryptAcquireContextA ;
      IN WIN32API AS CryptAcquireContext ;
      INTEGER @lhProvHandle, ;
      STRING  cContainer, ;
      STRING  cProvider, ;
      INTEGER nProvType, ;
      INTEGER nFlags

    * load a crypto provider
    lnStatus = CryptAcquireContext(@lhProv, 0, 0, dnPROV_RSA_FULL, dnCRYPT_VERIFYCONTEXT)
    IF lnStatus = 0
      THROW GetLastError()
    ENDIF

    DECLARE INTEGER CryptCreateHash ;
      IN WIN32API AS CryptCreateHash ;
      INTEGER hProviderHandle, ;
      INTEGER nALG_ID, ;
      INTEGER hKeyhandle, ;
      INTEGER nFlags, ;
      INTEGER @hCryptHashHandle

    * create a hash object that uses MD5 algorithm
    lnStatus = CryptCreateHash(lhProv, dnCALG_MD5, 0, 0, @lhHashObject)
    IF lnStatus = 0
      THROW GetLastError()
    ENDIF


    DECLARE INTEGER CryptHashData ;
      IN WIN32API AS CryptHashData ;
      INTEGER hHashHandle, ;
      STRING  @cData, ;
      INTEGER nDataLen, ;
      INTEGER nFlags

    * add the input data to the hash object
    lnStatus = CryptHashData(lhHashObject, tcData, lnDataSize, 0)
    IF lnStatus = 0
      THROW GetLastError()
    ENDIF


    DECLARE INTEGER CryptGetHashParam ;
      IN WIN32API AS CryptGetHashParam ;
      INTEGER hHashHandle, ;
      INTEGER nParam, ;
      STRING  @cHashValue, ;
      INTEGER @nHashSize, ;
      INTEGER nFlags

    * retrieve the hash value, if caller did not provide enough storage (16 bytes for MD5)
    * this will fail with dnERROR_MORE_DATA and lnHashSize will contain needed storage size
    lnStatus = CryptGetHashParam(lhHashObject, dnHP_HASHVAL, @lcHashValue, @lnHashSize, 0)
    IF lnStatus = 0
      THROW GetLastError()
    ENDIF


    DECLARE INTEGER CryptDestroyHash ;
      IN WIN32API AS CryptDestroyHash;
      INTEGER hKeyHandle

    * free the hash object
    lnStatus = CryptDestroyHash(lhHashObject)
    IF lnStatus = 0
      THROW GetLastError()
    ENDIF


    DECLARE INTEGER CryptReleaseContext ;
      IN WIN32API AS CryptReleaseContext ;
      INTEGER hProvHandle, ;
      INTEGER nReserved

    * release the crypto provider
    lnStatus = CryptReleaseContext(lhProv, 0)
    IF lnStatus = 0
      THROW GetLastError()
    ENDIF

  CATCH TO lnErr

    * clean up the hash object and release provider
    IF lhHashObject != 0
      CryptDestroyHash(lhHashObject)
    ENDIF


    IF lhProv != 0
      CryptReleaseContext(lhProv, 0)
    ENDIF

    ERROR("HashMD5 Failed")

  ENDTRY

  RETURN lcHashValue

ENDFUNC