********************************************************************************************
* Ejecuta el cursor de especialidades de guardia, trae el codigo y la descripción ordenada *
* por descripción para listar combos                                            		   *
********************************************************************************************

mret = sqlexec(mcon1,"select descrip, codesp, atiendeen from guardiaespecialid " + ;
	"where id<100000 order by descrip", "mwkespecial")


if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif
