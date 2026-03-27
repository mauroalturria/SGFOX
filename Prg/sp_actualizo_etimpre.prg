*********************************************************************************
* SACA de Etiquetas la señal para imprimir                                            *
*********************************************************************************
mret = sqlexec(mcon1,"update TabHCArchivo set hca_reimprime = 0 " + ;
					" where hca_reimprime = 1 " )

if mret < 0
	=aerr(eros)
	messagebox("NO ACTUALIZO, AVISAR A SISTEMAS",16, "Validacion") 
endif