*********************************************************************************
* BUSCA caja                                                                    *
*********************************************************************************
lparameters mcaja,mdigito

*Public mcon1

mret = sqlexec(mcon1,"SELECT pac_codhce as reg_nrohclinica,pac_nombrepaciente,caja,digito"+;
	" FROM pacientes" + ;
	" left join tabHCIArchivo ON tabHCIArchivo.hci_nroAdm = pacientes.pac_codadmision" +;
	" inner join tabHCICajas ON tabHCICajas.id = tabHCIArchivo.hca_orden"  +;
	" WHERE " + iif(empty(mcaja),'',"hca_orden = ?mcaja and" ) + " hca_orden <> 0 and digito = ?mdigito " + ;
	" group by pac_codhce"+;
	" order by caja" , "mwkListado" )

if mret < 0
*!*	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	mret = 0
	cancel
endif
