****
** Busca insumos
***
mret = sqlexec(mcon1, "select insumos,INS_codinsumo, INS_descriinsumo, INSaccion1 "+;
	"from insumos  " + ;
	"where INS_fechapasivo is null" , "mwkinsumos")
if mret < 0
	=aerr(eros)
	messagebox("ERROR "+eros(3)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
endif
