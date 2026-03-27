*********************************************************************************
* BUSCA caja                                                  *
*********************************************************************************
Lparameters mcaja

Public mcon1

mret = sqlexec(mcon1,"SELECT cast(CASE  WHEN hca_estado is Null THEN 1  ELSE 0 END as Integer) as elegido," +;
	" pac_codhce as  reg_nrohclinica,pac_nombrepaciente,hca_registrac,tabHCIArchivo.id as idArch," +;
	" cast( 0 as Integer) as base,hca_orden,hca_estado,ent_descrient" +;
	" FROM pacientes" +;
	" left join tabHCIArchivo On (tabHCIArchivo.hci_nroAdm = pacientes.pac_codadmision)" +;
	" left join coberturas On (coberturas.cob_pacientes = tabHCIArchivo.hci_nroAdm)" +;
	" left join entidades On (entidades.ent_codent = coberturas.cob_codentidad)" +;
	" WHERE hca_orden = ?mcaja and hca_orden <> 0 and pac_motivoalta = 6" +;
	" order by reg_nrohclinica","mwkCajaArch" )

If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "ERROR")
	Cancel
Endif
