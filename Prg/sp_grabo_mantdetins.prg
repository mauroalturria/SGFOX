PARAMETERS  mNroOt

mret = sqlexec(mcon1, "DELETE FROM TabMantdetinsumo WHERE idotins = ?mNroOt")
SELECT mwkPrinsumo02
  SCAN 
    mcantidad= cantidad
    mcodinsumo= codinsumo
    mcodPuntero = ins_codPuntero
	mret = sqlexec(mcon1, "INSERT INTO  TabMantdetinsumo(idotins,cantidad,codInsumo,codPuntero ) "+;
	" values(?mNroOt,?mcantidad,?mcodinsumo,?mcodPuntero )")
  ENDSCAN 	


IF MRET < 1
	=AERR(EROS)
	MESSAGEBOX('ERROR EN EL INGRESO, REINTENTE O AVISE A SISTEMAS', 64,'VALIDACION')	
ENDIF

