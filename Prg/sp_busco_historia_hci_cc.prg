*********************************************************************************
* BUSCA Datos de la historia                                                    *
*********************************************************************************
lparameters mbusco

*********************************************************************************
* BUSCA Datos de la historia                                                    *
*********************************************************************************
* version nueva

mret = sqlexec(mcon1,"SELECT hci_nroAdm,hca_registrac,pac_codhci," +;
	" pacientes.pacientes,pac_fechaalta," +;
	" pac_nombrepaciente,pac_fechaadmision, cast('' as character(30)) as hca_estado2," +;
	" reg_nrohclinica,hca_codbarra, MTE_Descripcion, pac_motivoalta,hcmfechaingr," +;
	" reg_nroRegistrac,hcmdestino,hca_estado,hca_orden,tabHCIArchivo.id,pac_codadmision," +;
	" hca_motFalta,hca_reimprime,TabHCIArchivo.id as idtarch" +;
	" FROM registracio,coberturas,Pacientes " +;
	" left join motivoegreso on motivoegreso.MTE_codmotivo = Pacientes.pac_motivoalta" +;
	" left join tabHCIArchivo ON tabHCIArchivo.hci_nroAdm  = Pacientes.pac_codadmision" +;
	" left join tabHCIMovst ON tabHCIMovst.hcmnroadm = Pacientes.pac_codadmision" +;
	" WHERE  " +;
	" reg_nroRegistrac = pac_codhci" +;
	" AND cob_pacientes = pac_codadmision" + mbusco  , "mwkhistoria" )

* pac_fechaalta is not null AND

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	cancel
endif
update mwkhistoria set hca_estado = 5 where hcmfechaingr = ctot("01/01/1900")
