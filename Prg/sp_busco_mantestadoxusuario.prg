PARAMETERS msector
*********************************************************************************
* Busco  permiso de usuario x sector
*********************************************************************************
mret = sqlexec(mcon1, "select IdEstado,sector from " +;
     " TabMantDetUsuario where sector = ?msector ", "mwkEstxUsuario" )


IF mret < 0
	MESSAGEBOX("ERROR de LECTURA , Reintente", 48, "Validacion")
ENDIF
