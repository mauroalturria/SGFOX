****
** grabo nro de orden de internacin
****
mret = sqlexec(mcon1, "update TabDatos set NroOrdenInt = NroOrdenInt +1 where id = 1")

mret = sqlexec(mcon1, "select NroOrdenInt from TabDatos ","mwkordin")
if mret < 0
	=aerr(eros)
	messagebox(eros(3), 64,'Validacion')
endif
