*
* Busqueda de Historias en Rotación
*
lparameters mwhere,msector

if vartype(mwhere)<>"C"
	mwhere = ""
endif

if vartype(mtipo)<>"N"
	mtipo = 0
endif

mfechanull = ctod("01/01/1900")
mret = sqlexec(mcon1,"select pac_codhce,pac_nombrepaciente,hci_nroadm,pac_fechaadmision,hcmfechasal,"+;
	"hcmretira,hcmdestino,hcmdescmed,Cob_codentidad,ent_descrient,hcmfechaIngr,HCE_descrip,"+;
	"hcmnrohCli,hcmnroadm,PAC_fechaalta,TLO_fecestado,TLO_obser,HCE_color,HCE_desred,"+;
	"PAC_codhci,PAC_codadmision,HCA_codbarra,SEC_descripsec,TabHCIMovst.hcmorigen, "+;
	"TabHCIArchivo.hca_estado,TabHCIArchivo.hca_fechaAlta,TabHCILog.tlo_estado "+;
	" from TabHCIArchivo"+;
	" left join TabHCIMovst On (TabHCIMovst.hcmnroadm = TabHCIArchivo.hci_nroadm) "+;
	" left join pacientes On (pacientes.pac_codadmision = TabHCIArchivo.hci_nroadm)"+;
	" left join coberturas On (coberturas .cob_pacientes = pacientes .pac_codadmision)"+;
	" left join entidades On (coberturas .cob_codentidad = entidades .ent_codent)"+;
	" left join TabHCEstado On (TabHCEstado .hce_id = TabHCIArchivo.hca_estado)"+;
	" left join TabHCILog On (TabHCILog .TLO_admision = pacientes .pac_codadmision)"+;
	" left join SECTORES On (SEC_codsector = PAC_sectorinternac)"+;
	" where nvl(hcmfechaIngr,'1900-01-01') = ?mfechanull" + mwhere,"MwkUSector1")

if mret < 0
	messagebox('EN CONSULTA DE MOVIMIENTOS DE H.C.'+chr(10)+;
		"AVISE A SISTEMAS",16,'ERROR')
	cancel
	mret=0
endif
if vartype(msector)="C"
	mwhere = " and TabHCIMovst.hcmnroadm = TabHCIArchivo.hci_nroadm"+;
		" and TabHCIArchivo.hca_estado = 5  and hcmdestino like '%" + alltrim(msector)+ "%' "
	mwheref = " Like('*" + alltrim(msector)+ "*',hcmdestino) "
	mret = sqlexec(mcon1,"select pac_codhce,pac_nombrepaciente,hci_nroadm,pac_fechaadmision,hcmfechasal,"+;
		"hcmretira,hcmdestino,hcmdescmed,Cob_codentidad,ent_descrient,hcmfechaIngr,HCE_descrip,"+;
		"hcmnrohCli,hcmnroadm,PAC_fechaalta,TLO_fecestado,TLO_obser,HCE_color,HCE_desred,"+;
		"PAC_codhci,PAC_codadmision,HCA_codbarra,SEC_descripsec,TabHCIMovst.hcmorigen,"+;
		"TabHCIArchivo.hca_estado,TabHCIArchivo.hca_fechaAlta,TabHCILog.tlo_estado "+;
		" from TabHCIArchivo, TabHCIMovst,pacientes  "+;
		" left join coberturas on (coberturas .cob_pacientes = pacientes .pac_codadmision)"+;
		" left join entidades on (coberturas .cob_codentidad = entidades .ent_codent)"+;
		" left join TabHCEstado on (TabHCEstado .hce_id = TabHCIArchivo.hca_estado)"+;
		" left join TabHCILog on (TabHCILog .TLO_admision = pacientes .pac_codadmision)"+;
		" left join SECTORES on (SEC_codsector = PAC_sectorinternac)"+;
		" where pacientes.pac_codadmision = TabHCIArchivo.hci_nroadm and  hcmfechaIngr = ?mfechanull" +;
		 mwhere,"MwkUSector2")
	
	 select * from MwkUSector1 where &mwheref ;
	 	union all ;
	 	select * from MwkUSector2 into cursor MwkUSector
 else
	select * from MwkUSector1 into cursor MwkUSector
endif
