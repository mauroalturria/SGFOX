*********************************************************************************
* BUSCA caja                                                  *
*********************************************************************************
lparameters mHC,mcaja



mret = sqlexec(mcon1,"SELECT cast(CASE  WHEN hca_estado is Null THEN 1  ELSE 0 END as Integer) as elegido, "+;
	" pac_codhce as  reg_nrohclinica,pac_nombrepaciente,hca_registrac,tabHCIArchivo.id as idArch,cast( 1 as Integer) as base,hca_orden,hca_estado   " +;
	"  FROM registracio ,pacientes " + ;
	"  left join tabHCIArchivo ON tabHCIArchivo.hci_nroAdm = pacientes.pacientes " +;
	"  WHERE reg_nrohclinica = ?mHC and pac_motivoalta = 6 AND  registracio.registracio  = pac_codhci and hca_orden = ?mcaja ", "mwkPasarCajaBiz" )


if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	mret=0
	cancel
endif
