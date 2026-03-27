*********************************************************************************
* BUSCA Datos de la historia                                                    *
*********************************************************************************
lparameters mbusco

mret = sqlexec(mcon1,"select TabHCArchivo.* , TabHCEstado.* , REG_nrohclinica, REG_nombrepac " + ;
	", REG_numdocumento, REG_nroregistrac,REG_distrito,abrevio,descrip " + ;
	" FROM registracio " + ;
	" left outer join TabHCArchivo on registracio.REG_nroregistrac = TabHCArchivo.hca_registrac " + ;
	" left outer join TabHCEstado on TabHCEstado.hce_id = TabHCArchivo.hca_estado " + ;
	" left outer join TabHCUbica on TabHCUbica.codubi = TabHCArchivo.hca_motfalta " + ;
	" where " + mbusco , "mwkhistoria" )

if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
endif
