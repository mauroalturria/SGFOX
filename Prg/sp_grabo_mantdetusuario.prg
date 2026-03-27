PARAMETERS mcodigovax,mcodsector,abm

mret = sqlexec(mcon1, " select * from TabMantDetSector "+;
" WHERE  codigovax  = ?mcodigovax   and codsector = ?mcodsector   ", "mwkControl")

IF abm = 1
   IF RECCOUNT('mwkControl') = 0
	mret = sqlexec(mcon1, " INSERT INTO TabMantDetSector "+;
	"(codigovax,codsector)	values(?mcodigovax,?mcodsector) ")
   ENDIF 	

ELSE
  IF RECCOUNT('mwkControl') > 0
   	mret = sqlexec(mcon1,   " DELETE FROM TabMantDetSector "+;
   	" WHERE codigovax= ?mcodigovax and codsector = ?mcodsector ")
  endif 	
ENDIF 

if mret < 0
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
ENDIF
