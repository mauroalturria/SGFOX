*
* Busqueda de HC con log de movimientos 
*
* Estado = 18 - "RECIBIDOS EN FACT" 
*
* mdesde   = fecha desde
* mhasta   = fecha hasta
* mlestado = estado 
* mlsector = sector  vacio => todos
*
Lparameters mdesde, mhasta, mlestado, mlsector

If vartype(mlestado) # "N"
	mlestado  = 18
Endif

If used('mwkctrling')
	Use in mwkctrling
Endif
mbusSec = ""
if !empty(mlsector)
	mbusSec = " and pacientes.PAC_sectorinternac = ?mlsector"
endif	

mret = sqlexec(mcon1,"select TLO_admision,pac_fechaalta,pac_nombrepaciente,mte_descripcion,"+;
    " ent_descrient,HCE_descrip,PAC_habitacion, PAC_cama,SEC_descripsec,pac_codhce as reg_nrohclinica, "+;
    " pac_fechaadmision,TLO_fecestado,hce_descrip,hca_fechaAlta "+;
	" From TabHciLog, pacientes, TabHCIArchivo"+;
	" join coberturas on (cob_pacientes = pac_codadmision)"+;
	" join entidades on (ent_codent = cob_codentidad)"+;
	" join motivoegreso on (MTE_codmotivo = pac_motivoalta)"+;
	" left join SECTORES on (SEC_codsector = PAC_sectorinternac)"+;
	" left join TabHCEstado On (hce_id = hca_estado)"+;
	" where pac_codadmision = TLO_admision and hci_nroAdm = TLO_admision"+;
	" and TLO_estado = ?mlestado"+;
	" and TLO_fecestado >= ?mdesde and TLO_fecestado < ?mhasta"+;
	mbusSec+;
	" order by pac_fechaalta","mwkctrling")

If mret < 0
	Messagebox("EN CONSULTA - LOG DE MOVIMIENTOS HC -"+CHR(13)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif















