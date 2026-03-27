*********************************************************************************
* BUSCA caja                                                  *
*********************************************************************************
lparameters mHC

*otra opcion
mret = sqlexec(mcon1,"SELECT cast(CASE  WHEN hca_estado is Null THEN 1  ELSE 0 END as Integer) as elegido, "+;
	" pac_codhce as  reg_nrohclinica,pac_nombrepaciente,hca_registrac,tabHCIArchivo.id as idArch,cast( 1 as Integer) as base,hca_orden,hca_estado   " +;
	"  FROM registracio,pacientes " + ;
	"  left join tabHCIArchivo ON tabHCIArchivo.hci_nroAdm = pacientes.pac_codadmision " +;
	"  WHERE reg_nrohclinica = ?mHC and pac_motivoalta = 6 AND  registracio.registracio  = pac_codhci and (hca_orden = 0 or hca_orden  is null ) ", "mwkPasarCajaBiz" )


if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	mret=0
	cancel
endif
