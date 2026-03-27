****
** grabo valores de llamadas
****
lparameters mvmLoc,mvmCel,mvmDDN
mret = sqlexec(mcon1, "update TabDatos set ValorMinutoCelular=?mvmcel ,ValorMinutoLocal=?mvmLoc ")
if mret<1
	=aerr(eros)
	Message(eros(3))
endif