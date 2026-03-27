PARAMETERS msector
*********************************************************************************
* Busco todos un sector 
*********************************************************************************
mret = sqlexec(mcon1, "select codsector,codigovax from " +;
     "  TabMantDetSector where codsector = ?msector ", "mwkEstxSector" )


IF mret < 0
	MESSAGEBOX("ERROR de LECTURA , Reintente", 48, "Validacion")
ENDIF
