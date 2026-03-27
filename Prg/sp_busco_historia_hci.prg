*********************************************************************************
* BUSCA Datos de la historia                                                    *
*********************************************************************************
Lparameters mbusco, mtipo

If vartype(mtipo)<>"C"
	mtipo = 'S'
Endif

*!* Para demo
*!* mbusco = "and reg_nrohclinica = 30460000"

*!* Query para 2008

mret = sqlexec(mcon1,"SELECT hci_nroAdm,hca_registrac,pac_codhci,pac_codadmision ,pac_fechaalta,"+;
	"pac_nombrepaciente,pac_fechaadmision, cast('' as character(30)) as hca_estado2,reg_nrohclinica,"+;
	"hca_codbarra, MTE_Descripcion, pac_motivoalta,hcmfechaingr,reg_nroRegistrac,hcmdestino,hca_estado,"+;
	"hca_orden,tabHCIArchivo.id,hca_motFalta,hca_reimprime,TabHCIArchivo.id as idtarch,HCE_descrip,ent_descrient,"+;
	"hca_depurab,hca_fechaAlta "+;
	" FROM (Pacientes Join coberturas On cob_pacientes = pac_codadmision)" +;
	" Join registracio On (reg_nroRegistrac = pac_codhci)" +;
	" Left join motivoegreso On (motivoegreso.MTE_codmotivo = Pacientes.pac_motivoalta)" +;
	" Left join tabHCIArchivo On (tabHCIArchivo.hci_nroAdm  = Pacientes.pac_codadmision)" +;
	" Left join tabHCIMovst On (tabHCIMovst.hcmnroadm = Pacientes.pac_codadmision)" +;
	" Left join TabHCEstado On (TabHCEstado.hce_id = tabHCIArchivo.hca_estado)" +;
	" Left join entidades On (entidades.ent_codent = coberturas.cob_codentidad)" +;
	" where pac_codadmision between '100000-0' and '999999-9'  " + mbusco, "mwkhistoria" )


If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	Cancel
Endif

*If mtipo = 'S'
*	Update mwkhistoria set hca_estado = 5 where hcmfechaingr = ctot("01/01/1900")
*Endif
