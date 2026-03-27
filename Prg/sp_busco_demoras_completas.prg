*PENDIENTES DE INTERCONSULTAS

mret = SQLExec(mcon1,"select TabPacDemoras.id as registro1,tpde_Fechadesde as tpid_Fechadesde,tpde_TextoDemora as tpid_interconsulta"+;
	",tpde_codadmision as tpid_codadmision,"+;
	" pac_nombrepaciente,PAC_cama,PAC_sectorinternac,sec_descripsec,"+;
	" ent_descrient from TabPacDemoras"+;
	" inner join tabestados on TabPacDemoras.tpde_estado = tabestados.estado and propietario = 15 "+;
	" and tipo = 8 and tabestados.descrip = 'PENDIENTE'"+;
	" inner join TabEstados as estados1 on tpde_Demora = estados1.estado  and estados1.propietario = 15 and estados1.tipo = 11 and  estados1.descrip ='INTERCONSULTA' "+;
	" inner join pacientes on TabPacDemoras.tpde_codadmision = PAC_codadmision "+;
	" inner join coberturas on cob_pacientes = PAC_codadmision "+;
	" LEFT JOIN SECTORES ON PAC_sectorinternac = sec_CODSECTOR "+;
	" left  join entidades 	on entidades.ent_codent	  = coberturas.cob_codentidad "+;
	" ","mwkdempendinter")


If mret < 1
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
	*!*		= Aerror(eros)
	*!*		Messagebox(eros(3))
	Return .F.
Endif

*PENDIENTES DE ESTUDIOS
mret = SQLExec(mcon1,"select TabPacDemoras.id as registro1,tpde_Fechadesde as tpide_Fechadesde,tpde_TextoDemora as tpidE_estudio,tpde_codadmision as tpide_codadmision,"+;
	" pac_nombrepaciente,PAC_cama,PAC_sectorinternac,sec_descripsec,"+;
	" ent_descrient from TabPacDemoras"+;
	" inner join tabestados on TabPacDemoras.tpde_estado = tabestados.estado and propietario = 15 "+;
	" and tipo = 8 and tabestados.descrip = 'PENDIENTE'"+;
	" inner join TabEstados as estados1 on tpde_Demora = estados1.estado  and estados1.propietario = 15 and estados1.tipo = 11  and estados1.descrip = 'ESTUDIOS'"+;
	" inner join pacientes on TabPacDemoras.tpde_codadmision = PAC_codadmision "+;
	" inner join coberturas on cob_pacientes = PAC_codadmision "+;
	" LEFT JOIN SECTORES ON PAC_sectorinternac = sec_CODSECTOR "+;
	" left  join entidades 	on entidades.ent_codent	  = coberturas.cob_codentidad "+;
	"","mwkdempendiestudio")


If mret < 1
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
	*!*		= Aerror(eros)
	*!*		Messagebox(eros(3))
	Return .F.
Endif


*PENDIENTES SOCIALES
mret = SQLExec(mcon1,"select TabPacDemoras.id as registro1,tpde_Fechadesde as tpids_Fechadesde,tpde_TextoDemora as tpids_social"+;
	",tpde_codadmision as tpids_codadmision,"+;
	" pac_nombrepaciente,PAC_cama,PAC_sectorinternac,sec_descripsec,"+;
	" ent_descrient from TabPacDemoras"+;
	" inner join tabestados on TabPacDemoras.tpde_estado = tabestados.estado and propietario = 15 "+;
	" and tipo = 8 and tabestados.descrip = 'PENDIENTE'"+;
	" inner join TabEstados as estados1 on tpde_Demora = estados1.estado  and estados1.propietario = 15 and estados1.tipo = 11 and estados1.descrip ='SOCIALES'"+;
	" inner join pacientes on TabPacDemoras.tpde_codadmision = PAC_codadmision "+;
	" inner join coberturas on cob_pacientes = PAC_codadmision "+;
	" LEFT JOIN SECTORES ON PAC_sectorinternac = sec_CODSECTOR "+;
	" left  join entidades 	on entidades.ent_codent	  = coberturas.cob_codentidad "+;
	" ","mwkdempendisocial")


If mret < 1
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
	*!*		= Aerror(eros)
	*!*		Messagebox(eros(3))
	Return .F.
Endif

*PENDIENTES DE PROVISIÓN
mret = SQLExec(mcon1,"select TabPacDemoras.id as registro1,tpde_Fechadesde as tpidp_Fechadesde,tpde_TextoDemora as tpidp_provision,tpde_codadmision as tpidp_codadmision,"+;
	" pac_nombrepaciente,PAC_cama,PAC_sectorinternac,sec_descripsec,"+;
	" ent_descrient from TabPacDemoras"+;
	" inner join tabestados on TabPacDemoras.tpde_estado = tabestados.estado and propietario = 15 "+;
	" and tipo = 8 and tabestados.descrip = 'PENDIENTE'"+;
	" inner join TabEstados as estados1 on tpde_Demora = estados1.estado  and estados1.propietario = 15 and estados1.tipo = 11 and estados1.descrip =  'PROVISION'"+;
	" inner join pacientes on TabPacDemoras.tpde_codadmision = PAC_codadmision "+;
	" inner join coberturas on cob_pacientes = PAC_codadmision "+;
	" LEFT JOIN SECTORES ON PAC_sectorinternac = sec_CODSECTOR "+;
	" left  join entidades 	on entidades.ent_codent	  = coberturas.cob_codentidad "+;
	"","mwkdempendiprov")


If mret < 1
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
	*!*		= Aerror(eros)
	*!*		Messagebox(eros(3))
	Return .F.
Endif
