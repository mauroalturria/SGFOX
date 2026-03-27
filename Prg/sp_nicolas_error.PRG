PARAMETER merror, mess, mess1, mprog, mlineno

LOCAL cError
LOCAL mDate

mDate = sp_busco_fecha_serv("DD")   

cError = "------------------- " + DTOC(mDate) +" "+ TIME() + "----------------" + CHR(10)
cError = cError + 'Error number: ' + LTRIM(STR(merror)) + CHR(10)
cError = cError + 'Error message: ' + mess + CHR(10)
cError = cError + 'Line of code with error: ' + mess1 + CHR(10)
cError = cError + 'Line number of error: ' + LTRIM(STR(mlineno)) + CHR(10)
cError = cError + 'Program with error: ' + mprog + CHR(10)
cError = cError + "-------------------------------------------------------------------"

MESSAGEBOX(cError,48,"Error de importación")