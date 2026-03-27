****
** grabo codigo vax
****
lparameters mnewvax
mret = sqlexec(mcon1, "update SQLUser.TabDatos set newvax =?mnewvax ")
if mret<1
	=aerr(eros)
	Message(eros(3))
endif
