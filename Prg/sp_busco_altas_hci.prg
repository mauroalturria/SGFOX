*********************************************************************************
* BUSCA Datos de la historia                                                    *
*********************************************************************************
Lparameters mbusco, mbandera, mfecha, mfecha1,mbuscof

Use in select("mwkhistoria")
Use in select("mwkhistoria1")
Use in select("mwkhistoria2")
if vartype(mbuscof)#"C"
	mbuscof = ''
endif
do sp_sectorint with 1
mret = sqlexec(mcon1,"SELECT * FROM TabHCEstado","mwktabhest")

mret = sqlexec(mcon1,"SELECT * FROM motivoegreso ","mwkmoti")

*!*	mret = sqlexec(mcon1,"SELECT pac_codhci,pac_codadmision,pac_fechaalta,pac_nombrepaciente,pac_fechaadmision,"+;
*!*		"pac_codhce as  reg_nrohclinica,pac_motivoalta, "+;
*!*		"cob_codentidad,"+;
*!*		"PAC_sectorinternac,"+;
*!*		"PAC_habitacion,PAC_cama "+;
*!*		" FROM pacientes Join coberturas On cob_pacientes=pac_codadmision "+;
*!*		" where pac_tipopac = 1"+ mbusco + mbuscof ,"mwkhistoria10" )
&&& agrego esto porque supongo que busco pacya dados de alta pac_tipopac = 1
mret = sqlexec(mcon1,"SELECT pac_codhci,pac_codadmision,pac_fechaalta,pac_nombrepaciente,pac_fechaadmision,"+;
	"pac_codhce as  reg_nrohclinica,pac_motivoalta, hca_estado,hca_codbarra,"+;
	"cob_codentidad,hca_registrac,hca_orden,tabHCIArchivo.id as idArch,"+;
	"TPV_Estado,TPV_Audit,TPV_Observa,PAC_sectorinternac,"+;
	"PAC_habitacion,PAC_cama, hca_fechaAlta "+;
	" FROM pacientes Join coberturas On cob_pacientes=pac_codadmision "+;
	" left join tabHCIArchivo On (hci_nroAdm = pac_codadmision)"+;
	" left outer join TabPacVip On (TPV_NroReg = pac_codhci)"+;
	" where 1=1 "+ mbusco + mbuscof ,"mwkhistoria10" )

If mret < 0
	Messagebox("EN CONSULTA 1 LOG H.C. INTERNACION",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif

SELECT pac_codhci,pac_codadmision,pac_fechaalta,pac_nombrepaciente,pac_fechaadmision,;
	reg_nrohclinica,MTE_Descripcion,pac_motivoalta, hca_estado,hca_codbarra,;
	0 as elegido, cob_codentidad,hca_registrac,hca_orden,idArch,;
	0 as encontrado,TPV_Estado,;
	TPV_Audit,TPV_Observa,HCE_color,HCE_descrip,SEC_descripsec,PAC_sectorinternac,;
	PAC_habitacion,PAC_cama, HCE_desred,hca_fechaAlta ;
	from mwkhistoria10,mwksectorint,mwkmoti;
	left join mwktabhest on hce_id = hca_estado;
	where sec_codsector = pac_sectorinternac ;
	and MTE_codmotivo = pac_motivoalta;
	into cursor mwkhistoria1


Select mwkhistoria1
Go top

mbusco2 = mwkhistoria1.pac_codadmision

mret = sqlexec(mcon1,"SELECT * from tabhcilog"+;
	" where TLO_admision = ?mbusco2 and TLO_estado = 0","mwkhistoria2")

If mret < 0
	Messagebox("EN CONSULTA 2 LOG H.C. INTERNACION",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif

Select mwkhistoria1.*,mwkhistoria2.TLO_fecestado ;
	from mwkhistoria1  ;
	left join mwkhistoria2 on mwkhistoria2.TLO_admision = mwkhistoria1.pac_codadmision;
	into cursor mwkhistoria

Use in select("mwkhistoria1")
Use in select("mwkhistoria2")

do sp_sectorint
Return .T.

