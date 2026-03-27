****
** grabo la nueva entidad en protocolo de guardia
****
lparameters mprot, mentidad

mret = sqlexec(mcon1, "update guardia set codent = ?mentidad where protocolo = ?mprot")

if mret < 0
	=aerr(eros)
	messagebox("ERROR de ESCRITURA, AVISAR A SISTEMAS", 48, "Validacion")
endif			
