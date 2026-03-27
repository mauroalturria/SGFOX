****
** grabo ultima fecha de actualizacion
****
lparameters mnewfecha

mret = sqlexec(mcon1, "update SQLUser.TabDatos set Fecha_UAct_Alim =?mnewfecha ")
if mret<1
	=aerr(eros)
	Message(eros(3))
endif