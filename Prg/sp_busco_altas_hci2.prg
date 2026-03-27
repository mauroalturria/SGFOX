*********************************************************************************
* BUSCA Datos de la historia                                                    *
*********************************************************************************
lparameters mbusco,mbandera
public mcon1

mret = sqlexec(mcon1,"select PAC_fechaalta,pac_codadmision from pacientes where " + mbusco ,"mwkhistoria2" )


mret = sqlexec(mcon1,"SELECT pac_codhci,pacientes.pacientes,pac_fechaalta, "+;
	"  pac_nombrepaciente,pac_fechaadmision, "+;
	"  pac_codhce as  reg_nrohclinica,MTE_Descripcion,pac_motivoalta, hca_estado,hca_codbarra,"+;
	"  cob_codentidad,ENT_CODENT,pac_codadmision,hca_registrac,hca_orden,tabHCIArchivo.id as idArch,ENT_descrient,ENT_nroprestadorexterno   " +;
	"  FROM  coberturas, entidades,pacientes " + ;
	"  left join motivoegreso on motivoegreso .MTE_codmotivo = pacientes.pac_motivoalta "+;
	"  left join tabHCIArchivo ON tabHCIArchivo.hci_nroAdm = pacientes.pacientes " +;
	"  WHERE pac_codadmision = cob_pacientes and " + ;
	"  cob_codentidad 		= ent_codent " + ;
	mbusco  , "mwkhistoria" )

if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	mret=0
	cancel
endif
