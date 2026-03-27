*
* Estadísticos etiquetas emitidas
*
Lparameters mdesde,mhasta

Dimension vubica[4]

Use in select("mwkinforme")
Use in select("mwkinforme3")

mdesdet = dtot(mdesde)
mhastat = dtot(mhasta + 1)

*!*	mret = sqlexec(mcon1,"Select TCE_nropof,TCE_fechaemite,TCE_fechapasiva,TCE_idusuario,"+;
*!*		" TFI_pactivo,TFI_dosis,"+;
*!*		" TFI_solucion,TFI_volumen,TFI_viasadm,TFI_tiempo,TFI_utiempo,"+;
*!*		" TCE_insumocodigo,TCE_insumodescrip,"+;
*!*		" TCE_medidauso,(TCE_medidauso/TBC_dosis) as lcantidad,"+;
*!*		" TCI_lote,TCI_vence,TCI_marca,"+;
*!*		" TCE_nombrepac,TCE_partida,TFP_diagnos,TFP_matricula,TFP_medico,"+;
*!*		" TFP_peso,TFP_pisocama,TFP_supcor,TFP_talla,TFP_usuario,"+;
*!*		" TEC_pactivo,TCE_medidauso,TEC_solucion,TEC_fecelab,TEC_fecvenc,TEC_obsa,TEC_obsb,TEC_obsetq,"+;
*!*		" TFP_fecpasiva as Fecha_Baja_Plan,"+;
*!*		" Tabfarmesq.TFE_esquema as Esquema,registracio.REG_numdocumento as Documento,"+;
*!*		" REG_nrohclinica as HClinica,"+;
*!*		" TCP_origen,REG_nroregistrac,"+;
*!*		" Entidades.ent_descrient,"+;
*!*		" TFP_ubicacion as lubicacion,"+;
*!*		" TFA_fecha, TFA_conombre"+;
*!*		" From TabFarmCitosE" +;
*!*		" Left Join TabFarmEtqCitos on TEC_nropof = TCE_nropof"+;
*!*		" Join TabFarmCitosP on TCP_partida = TabFarmCitosE.TCE_partida" +;
*!*		" Join TabFarmCitosI on TCI_partida = TabFarmCitosE.TCE_partida and TCI_insumocodigo = TCE_insumocodigo"+;
*!*		" Join TabFarmPlan on TFP_registracio = TabFarmCitosP.TCP_registracio"+;
*!*		" Join TabFarmPlanI on TabFarmPlanI.TFI_idplan = TabFarmPlan.Id and TFI_insumocodig = TCE_insumocodigo"+;
*!*		" Join TabFarmbaseco on TabFarmbaseco.TBC_inscod = TabFarmCitosE.TCE_insumocodigo "+;
*!*		" Join Tabfarmesq on tabfarmesq.id = TabFarmPlan.TFP_esquema"+;
*!*		" Join Registracio on REG_nroregistrac = TabFarmCitosP.TCP_registracio"+;
*!*		" Left Join Afiliacion on Afiliacion.Registracio = Registracio.REG_nroregistrac" + ;
*!*		" Left Join Entidades on Entidades.ENT_codent = Afiliacion.AFI_codentidad" +;
*!*		" Left Join TabFarmApto on TFA_registracio = Registracio.REG_nroregistrac"+;
*!*		" Where TCE_fechaemite >= ?mdesdet and TCE_fechaemite < ?mhastat" +;
*!*		" Order by TCE_nropof","mwkinforme")

mret = sqlexec(mcon1,"Select TCE_nropof,TCE_fechaemite,TCE_fechapasiva,TCE_idusuario,"+;
	" TFI_pactivo,TFI_dosis,"+;
	" TFI_solucion,TFI_volumen,TFI_viasadm,TFI_tiempo,TFI_utiempo,"+;
	" TCE_insumocodigo,TCE_insumodescrip,"+;
	" TCE_medidauso,(TCE_medidauso/TBC_dosis) as lcantidad,"+;
	" TCI_lote,TCI_vence,TCI_marca,"+;
	" TCE_nombrepac,TCE_partida,TFP_diagnos,TFP_matricula,TFP_medico,"+;
	" TFP_peso,TFP_pisocama,TFP_supcor,TFP_talla,TFP_usuario,"+;
	" TEC_pactivo,TCE_medidauso,TEC_solucion,TEC_fecelab,TEC_fecvenc,TEC_obsa,TEC_obsb,TEC_obsetq,"+;
	" TFP_fecpasiva as Fecha_Baja_Plan,"+;
	" Tabfarmesq.TFE_esquema as Esquema,registracio.REG_numdocumento as Documento,"+;
	" REG_nrohclinica as HClinica,"+;
	" TCP_origen,REG_nroregistrac,"+;
	" Entidades.ent_descrient,"+;
	" TFP_ubicacion as lubicacion,"+;
	" TFA_fecha, TFA_conombre"+;
	" From TabFarmCitosE" +;
	" Left Join TabFarmEtqCitos on TEC_nropof = TCE_nropof"+;
	" Join TabFarmCitosP on TCP_partida = TabFarmCitosE.TCE_partida" +;
	" Join TabFarmLog on {fn CONCAT('EMITE ',TCE_nropof)} = TFL_motivo"+;
	" and TFL_partida = TabFarmCitosE.TCE_partida and TFL_insumocodigo = TabFarmCitosE.TCE_insumocodigo"+;
	" Join TabFarmCitosI on TCI_partida = TabFarmCitosE.TCE_partida and TCI_insumocodigo = TCE_insumocodigo"+;
	" and TCI_lote = TabFarmLog.TFL_lote"+;
	" Join TabFarmPlan on TFP_registracio = TabFarmCitosP.TCP_registracio"+;
	" Join TabFarmPlanI on TabFarmPlanI.TFI_idplan = TabFarmPlan.Id and TFI_insumocodig = TCE_insumocodigo"+;
	" Join TabFarmbaseco on TabFarmbaseco.TBC_inscod = TabFarmCitosE.TCE_insumocodigo "+;
	" Join Tabfarmesq on tabfarmesq.id = TabFarmPlan.TFP_esquema"+;
	" Join Registracio on REG_nroregistrac = TabFarmCitosP.TCP_registracio"+;
	" Left Join Afiliacion on Afiliacion.Registracio = Registracio.REG_nroregistrac" + ;
	" Left Join Entidades on Entidades.ENT_codent = Afiliacion.AFI_codentidad" +;
	" Left Join TabFarmApto on TFA_registracio = Registracio.REG_nroregistrac"+;
	" Where TCE_fechaemite >= ?mdesdet and TCE_fechaemite < ?mhastat" +;
	" Order by TCE_nropof","mwkinforme")
	
If mret < 0
	Messagebox("EN CONSULTA DE ETIQUETAS EMITIDAS",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif

Use in select("mwkdesca")
mret = sqlexec(mcon1,"select * from TabFarmLog where TFL_motivo like '%Descarte %'","mwkdesca")

If mret < 0
	Messagebox("EN CONSULTA LOG DE ETIQUETAS EMITIDAS",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif


vubica[1]='HOSP. DE DIA'
vubica[2]='INTERNACION '
vubica[3]='EXTERNO     '
vubica[4]='NO ESPECIF. '

Use in select("mwkinforme2")
Use in select("mwkinforme3")

If used("mwkinforme")
	If reccount("mwkinforme")>0
	
		Select mwkinforme.*,;
			iif(TCP_origen=1,'OBRA SOCIAL     ',;
			iif(TCP_origen=2,'SANATORIO GÜEMES',;
			iif(TCP_origen=3,'PLAN de SALUD   ',;
			'OTRO            '))) as Origen, vubica[iif(nvl(lubicacion,0)=0,4,lubicacion)] as ubicacion,;
			nvl(TFL_potencia,0) as descarte;
			From mwkinforme ;
			left join mwkdesca on ;
			TFL_partida=TCE_partida and;
			TFL_insumocodigo=TCE_insumocodigo and;
			right(alltrim(TFL_motivo),9) = alltrim(TCE_nropof);
			Into cursor mwkinforme

		Select * ;
			from mwkinforme ;
			order by TCE_nropof, tfi_pactivo asc ;
			into cursor mwkinforme2

		Select TCE_nropof,tce_nombrepac,tce_fechaemite,;
		nvl(tce_fechapasiva,dtot({//})) as tce_fechapasiva,;
			alltrim(tce_idusuario) as tce_idusuario,;
			tce_insumodescrip,tce_medidauso,tfp_diagnos,;
			tfi_pactivo,tfi_dosis,tfi_solucion,tfi_volumen,tfi_viasadm,;
			tfi_tiempo,tfi_utiempo,TCE_insumocodigo,lcantidad,tci_lote,;
			tci_vence,tci_marca,TCE_partida,tfp_peso,tfp_pisocama,;
			tfp_supcor,tfp_talla,tfp_matricula,tfp_medico,;
			tfp_usuario,tec_pactivo,tce_medidauso1,tec_solucion,;
			tec_fecelab,tec_fecvenc,tec_obsa,tec_obsb,tec_obsetq,;
			nvl(fecha_baja_plan,dtot({//})) as fecha_baja_plan,;
		    esquema,documento,hclinica,ent_descrient,;
			tfa_fecha,tfa_conombre,Origen,ubicacion,descarte;
			group by tce_nropof,tfi_pactivo,tce_partida;
			from mwkinforme2 ;
			into cursor mwkinforme3


*     group by tce_partida,tce_nropof,tce_insumocodigo order by tce_nropof,tce_nombrepac;			
*     group by TCE_nropof, TCE_insumocodigo ;			

	Endif
Endif

Use in select("mwkinforme")
Use in select("mwkinforme2")
Use in select("mwkdesca")

Return .T.
