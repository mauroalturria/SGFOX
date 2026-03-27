PARAMETERS mot

*********************************************************************************
* Busco una orden de trabajo
*********************************************************************************

mret = sqlexec(mcon1, "select  ID,fechasolucion,FechaIngSolic from tabmantenimiento " +;
      " where id = ?mot", "mwkOt" )


IF mret < 0
	MESSAGEBOX("ERROR de LECTURA , Reintente", 48, "Validacion")
ENDIF
