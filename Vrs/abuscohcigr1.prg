mfecha = ctod("01/07/2006")
mfecha = ctod("01/07/2006")
	mret = sqlexec(mcon1,"SELECT pac_codhci,pacientes.pacientes,pac_fechaalta, "+;
			"  pac_nombrepaciente,pac_fechaadmision, "+;
			"  pac_codhce as  reg_nrohclinica,MTE_Descripcion,pac_motivoalta, "+;
			" hca_estado,hca_codbarra,"+;
			"  cast(CASE  WHEN hca_estado is Null THEN 1  ELSE 0 END as Integer) as elegido,"+;
			" pac_codadmision->cob_codentidad,ENT_CODENT,pac_codadmision,hca_registrac,"+;
			" hca_orden,tabHCIArchivo.id as idArch,ent_descrient   " +;
			"  FROM pacientes, coberturas, entidades " + ;
			"  left join motivoegreso on MTE_codmotivo = pac_motivoalta "+;
			"  left join tabHCIArchivo ON hci_nroAdm = pacientes.pacientes " +;
			"  WHERE pac_codadmision = cob_pacientes and " + ;
			"  cob_codentidad 		= ent_codent " + ;
			' AND PAC_fechaalta >= ?mfecha AND PAC_fechaalta <= ?mfecha1 '+;
			 ' AND pac_tipopac < 2 ' , "mwkhistoria" )
