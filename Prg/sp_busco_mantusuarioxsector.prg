PARAMETERS mcodigovax
*********************************************************************************
* Busco los sectores a los que tiene permiso el usuario
*********************************************************************************

mret = sqlexec(mcon1, "select CodigoVax,CodSector from TabMantDetSector "+;
" where codigovax = ?mcodigovax", "mwkEstxSector")

if mret < 0
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif