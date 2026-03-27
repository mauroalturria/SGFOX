#DEFINE DC_BINS             6
#DEFINE DMBIN_TRACTOR       8

CLEAR
DIMENSION asPrn[1]
FOR nPrn = 1 TO APRINTERS(asPrn)
  sPrn = asPrn[nPrn, 1]
  ? PADR(sPrn,25), " ", IIF(IsDotPrinter (sPrn), "Matriz", "")
NEXT
RETURN

FUNCTION IsDotPrinter (sPrn)
  LOCAL nBins, sBuff
  DECLARE LONG DeviceCapabilities IN WinSpool.drv ;
    STRING @ sPrinter, STRING @ sPort, ;
    INTEGER nCapability, STRING @ sReturn, STRING @ pDevMode
  sBuff = SPACE(512)
  * Lista de words de bandejas
  nBins = DeviceCapabilities (sPrn, NULL, DC_BINS, @sBuff, NULL)
  IF nBins > 0
    sBuff = PADR(sBuff, nBins)
  ENDIF
  CLEAR DLLS DeviceCapabilities
  RETURN CHR(DMBIN_TRACTOR) $ sBuff
ENDFUNC