*
* Busqueda de Historias Anteriores x H.Clinica
*
Parameters mhclinica

If used('Mwkhistoria2')
	Use in Mwkhistoria2
Endif

mret = sqlexec(mcon1,"select hci_nroAdm,hca_registrac,adm_registrac as pac_codhci,"+;
 	"adm_nroadm as pac_codadmision,adm_fechaalta as pac_fechaalta,REG_nombrepac as pac_nombrepaciente,"+;
 	"adm_fechaadm as pac_fechaadmision, cast('' as character(30)) as hca_estado2, reg_nrohclinica,"+;
 	"hca_codbarra,cast('' as character(1)) as MTE_Descripcion, adm_motivoalta as pac_motivoalta,"+;
 	"hcmfechaingr,reg_nroRegistrac,hcmdestino,hca_estado,hca_orden,TabHCIArchivo.id,hca_motFalta,"+;
 	"hca_reimprime,TabHCIArchivo.id as idtarch,HCE_descrip,ent_descrient,hca_depurab,hca_fechaalta"+;
 	" from TabHciAdm "+;
 	" Join registracio On (reg_nroRegistrac = adm_registrac)"+;
 	" Left join tabHCIArchivo On (tabHCIArchivo.hci_nroAdm  = adm_nroadm)"+;
 	" Left join tabHCIMovst On (tabHCIMovst.hcmnroadm = adm_nroadm)"+;
 	" Left join TabHCEstado On (TabHCEstado.hce_id = tabHCIArchivo.hca_estado)"+;
 	" Left join entidades On (entidades.ent_codent = adm_codent)"+;
 	" where adm_codhce = ?mhclinica","mwkhistoria2") 	

If mret < 0
	=aerror(merror)
	Messagebox("EN CONSULTA DE HISTORIAS ANTERIORES"+chr(10)+;
		alltrim(merror(3))+chr(10)+"AVISAR A SISTEMAS",16, "ERROR")
	Cancel
Endif
