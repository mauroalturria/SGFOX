*********************************************************************************
* BUSCA Etiquetas para imprimir                                            *
*********************************************************************************
mret = sqlexec(mcon1,"select TabHCArchivo.*, REG_nrohclinica, REG_nombrepac, REG_numdocumento " + ;
	" FROM TabHCArchivo" + ;
	" left outer join registracio on registracio.REG_nroregistrac = TabHCArchivo.hca_registrac " + ;
	" where hca_reimprime = 1 " + ;
	"ORDER BY hca_orden, REG_nombrepac", "mwkbuspacimp")

if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	do sp_desconexion with "error"
	cancel
endif
