*
* Datos de la Historia
*
Lparameters mfiltrar
do sp_sectorint with 1

mret = sqlexec(mcon1,"SELECT hci_nroAdm->pac_codhci,hci_nroAdm->pac_codadmision,hci_nroAdm->pac_fechaalta,hci_nroAdm->pac_nombrepaciente,hci_nroAdm->pac_fechaadmision,"+;
	"hci_nroAdm->pac_codhce as  reg_nrohclinica,hci_nroAdm->pac_motivoalta, hca_estado,hca_codbarra,"+;
	"cast(0 as Integer) as elegido,"+;
	"hca_registrac,hca_orden,tabHCIArchivo.id as idArch,"+;
	"cast(0 as Integer) as encontrado,"+;
	"hci_nroAdm->pac_sectorinternac,"+;
	"hci_nroAdm->pac_habitacion,hci_nroAdm->pac_cama,hca_fechaAlta "+;
	" FROM %INORDER TabHCIArchivo "+;
	 mfiltrar,"mwkhistoria20" )

If mret<1
	=aerr(eros)
	Messagebox(eros(3))
	Return
Endif
mret = sqlexec(mcon1,"SELECT * FROM TabHCEstado","mwktabhest")

mret = sqlexec(mcon1,"SELECT * FROM motivoegreso ","mwkmoti")

SELECT pac_codhci,pac_codadmision,pac_fechaalta,pac_nombrepaciente,pac_fechaadmision,;
	reg_nrohclinica,MTE_Descripcion,pac_motivoalta, hca_estado,hca_codbarra,;
	elegido, sp_busco_entcob(pac_codadmision) as cob_codentidad,hca_registrac,hca_orden,idArch,encontrado,0 as TPV_Estado,;
	.f. as TPV_Audit,'' as TPV_Observa,HCE_color,HCE_descrip,SEC_descripsec,pac_sectorinternac,;
	pac_habitacion,pac_cama,HCE_desred,hca_fechaAlta ;
	from mwkhistoria20,mwksectorint,mwktabhest,mwkmoti;
	where sec_codsector = pac_sectorinternac and hce_id = hca_estado;
	and MTE_codmotivo = pac_motivoalta;
	into cursor mwkhistoria2

do sp_sectorint 

