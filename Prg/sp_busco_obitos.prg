lparameters mbusco,mbandera

mret = sqlexec(mcon1,"SELECT hci_nroAdm->pac_codhci , hci_nroAdm->pac_codadmision  , hci_nroAdm->pac_fechaalta "+;
	" , hci_nroAdm->pac_nombrepaciente , hci_nroAdm->pac_fechaadmision ,ent_descrient,hci_nroAdm->pac_codhce as reg_nrohclinica "+;
	" , MTE_Descripcion , hci_nroAdm->pac_motivoalta , hca_estado , hca_codbarra , "+;
	" cob_codentidad , hca_registrac , hca_orden "+;
	" , tabHCIArchivo . id as idArch,cast(0 as integer) as elegido,ent_descrient "+;
	" FROM coberturas,entidades,tabHCIArchivo  "+;
	" left join motivoegreso on motivoegreso.MTE_codmotivo = tabHCIArchivo.hci_nroAdm->pac_motivoalta "+;
	" WHERE hci_nroAdm = cob_pacientes "+;
	"   and cob_codentidad = ent_codent " +;
	" AND hci_nroAdm->pac_codadmision between '100000-0' and '999999-9' "+;
	" and hci_nroAdm->pac_motivoalta =6 "+;
	iif(empty(mbusco),'',mbusco), "mwkhistoria" )

if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	mret=0
	cancel
endif
