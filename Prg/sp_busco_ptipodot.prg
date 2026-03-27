****
** Busco Conceptos
****
mret = sqlexec(mcon1, "	SELECT * FROM TabPTipoDot ", "mwktipodot")
if mret < 0
	=aerr(eros)
	messagebox(eros(3))
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif