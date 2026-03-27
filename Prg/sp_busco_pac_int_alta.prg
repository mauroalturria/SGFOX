*!*	----------------------------------------------------------------------------------
*!*	 Busco paciente para alta de admision
*!*	----------------------------------------------------------------------------------
Parameter mcodadmi
Do sp_busco_estados With 57," and tipo = 53  order by subestado ","mwkhabcmsec"
mwcm = ''
If mwkhabcmsec.estado = 1
	mwcm = " and sec_codsector in (select sec_codsector from sectores where sec_centromedico = ?mxcentromedico) "
Endif

mret = SQLExec(mcon1, "select PAC_codadmision,PAC_nombrepaciente, PAC_habitacion, PAC_cama, " + ;
	"ENT_descrient, PAC_fechaalta, PAC_fotoccarnetos,sec_codsector , " + ;
	"PAC_fotocdni, PAC_fotocrechab, PAC_ordeninternac, PAC_operadm, PAC_operalta, " + ;
	"PAC_domicilio, PAC_codhci, ENT_codent, PIN_codcontrato, PAC_codcie10diagalt, " + ;
	"PAC_fechaadmision, PAC_horaadmision, entidexclu.fecpasiva, TPV_Estado,PAC_codhce, pac_observaciones, " + ;
	"PAC_ordeninternac, ORICodAutoriz, ORINroOrden, ORIObservac, ORITipoOrden, ORIVigDesde,SEC_circaltas,pac_categoria " + ;
	"from pacientes " + ;
	"Inner Join sectores on  sec_codsector = PAC_sectorinternac " + ;
	"Inner Join pacinternad on pin_codadmision = PAC_codadmision " + ;
	"Inner Join entidades on Ent_CodEnt = pin_codentidad " + ;
	"left join entidexclu on pacinternad.pin_codentidad = entidexclu.codent and " + ;
	"entidexclu.tpopac = 'INT' " +;
	"left outer join TabPacVip on pacientes.PAC_codhci = TabPacVip.TPV_NroReg " + ;
	"left join  ordeninternac on ordeninternac.oricodadmision = pacientes.PAC_codadmision "+;
	"where PAC_codadmision = ?mcodadmi"+mwcm , "mwkpacint")

If mret<1
	Messagebox("ERROR AL GENERAR EL CURSOR",48,"VALIDACION")
*!*		=aerr(eros)
*!*		messagebox (eros(2))
*!*		messagebox (eros(3))
Endif
