****
** Busco Modulo
****

PARAMETERS mid 

mret = sqlexec(mcon1, "SELECT * FROM tabPmodulo where id = ?mid " , "mwkModulo")

if mret < 0
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif