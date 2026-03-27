*********************************************************************************
* BUSCA Datos de la historia                                                    *
*********************************************************************************
lparameters mbusco
mret = sqlexec(mcon1,"SELECT pac_codhci,pac_codadmision,pac_fechaalta, "+;
	"  pac_nombrepaciente,pac_fechaadmision, "+;
	"  pac_codhce as  reg_nrohclinica,MTE_Descripcion,pac_motivoalta, hca_estado,hca_codbarra,"+;
	"  cast(0 as Integer) as elegido,cob_codentidad,ENT_CODENT,"+;
	"   hca_registrac,hca_orden,tabHCIArchivo.id as idArch,ent_descrient   " +;
	"  FROM tabHCIArchivo,pacientes, motivoegreso ,coberturas, entidades " + ;
	"  WHERE  hci_nroAdm = pac_codadmision and "+;
	" MTE_codmotivo = pac_motivoalta and "+;
	"  hci_nroAdm = cob_pacientes and " + ;
	"  cob_codentidad = ent_codent " +;
	" AND pac_tipopac < 2 "+  mbusco  , "mwkhistoria" )

if mret < 0
	=aerr(eros)
	messagebox(eros(3))
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	mret=0
	cancel
endif
