*
* Estadísticos etiquetas emitidas
*
Lparameters mdesde,mhasta

Dimension vubica[4]

Use In Select("mwkinforme")
Use In Select("mwkinforme3")

mdesdet = Dtot(mdesde)
mhastat = Dtot(mhasta + 1)

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

* Set Step On

mret = SQLExec(mcon1,"Select TCE_nropof,TCE_fechaemite,TCE_fechapasiva,TCE_idusuario,"+;
	" TFI_pactivo,TFI_dosis,"+;
	" TFI_solucion,TFI_volumen,TFI_viasadm,TFI_tiempo,TFI_utiempo,"+;
	" TCE_insumocodigo,TCE_insumodescrip,"+;
	" TCE_medidauso,(TCE_medidauso/TBC_dosis) as lcantidad,"+;
	" TCI_lote,TCI_vence,TCI_marca,"+;
	" TCE_nombrepac,TCE_partida,TFP_diagnos,TFP_matricula,TFP_medico,"+;
	" TFP_peso,TFP_pisocama,TFP_supcor,TFP_talla,TFP_usuario,"+;
	" TEC_pactivo,TCE_medidauso,TEC_solucion,TEC_fecelab,TEC_fecvenc,TEC_obsa,TEC_obsb,TEC_obsetq,"+;
	" TFP_fecpasiva as Fecha_Baja_Plan,"+;
	" I.TFE_esquema as Esquema,"+;
	" TCP_origen," +;
	" TFP_ubicacion as lubicacion,c.tcp_registracio"+;
	" From TabFarmCitosE as a" +;
	" Left Join TabFarmEtqCitos as b on b.TEC_nropof = a.TCE_nropof" +;
	" Join TabFarmCitosP as c on c.TCP_partida = a.TCE_partida" +;
	" Join TabFarmLog as d on {fn CONCAT('EMITE ',a.TCE_nropof)} = d.TFL_motivo" +;
	" and d.TFL_partida = a.TCE_partida and d.TFL_insumocodigo = a.TCE_insumocodigo" +;
	" Join TabFarmCitosI as e on e.TCI_partida = a.TCE_partida and e.TCI_insumocodigo = a.TCE_insumocodigo" +;
	" and e.TCI_lote = d.TFL_lote" +;
	" Join TabFarmPlan as f on f.TFP_registracio = c.TCP_registracio" +;
	" Join TabFarmPlanI as g on g.TFI_idplan = f.Id and g.TFI_insumocodig = a.TCE_insumocodigo" +;
	" Join TabFarmbaseco as h on h.TBC_inscod = a.TCE_insumocodigo"+;
	" Join Tabfarmesq as i on i.id = f.TFP_esquema" +;
	" Where a.TCE_fechaemite >= ?mdesdet and a.TCE_fechaemite < ?mhastat" +;
	" Order by a.TCE_nropof","mwkinformeB")

Select tcp_registracio FROM mwkinformeB ORDER BY tcp_registracio GROUP BY tcp_registracio INTO CURSOR mwkinformeC

Select tcp_registracio, DevuelveEntidad(tcp_registracio) as ent_descrient From mwkinformeC Group By tcp_registracio Into Cursor mwkRegistraciones

Select mwkRegistraciones
Go Top

Use In Select("mwkFarmAptoB")
Use In Select("mwkFarmApto")
Use In Select("mwkFarmAptoC")

nCuenta = 0
cRegistracio = ""

Scan All

	If nCuenta < 10

		cRegistracio = cRegistracio + Transform(mwkRegistraciones.tcp_registracio)+","
		nCuenta = nCuenta + 1
	Else

		If Len(cRegistracio) > 0
			cRegistracio = Left(cRegistracio,Len(cRegistracio)-1)

			mret = SQLExec(mcon1,"select a.*,b.REG_numdocumento as Documento, b.REG_nrohclinica as HClinica, b.Reg_nroregistrac "+;
				"from TabFarmApto as a " +;
				"inner join registracio as b on a.TFA_registracio = b.REG_nroregistrac " +;
				"inner Join Afiliacion as c on c.Registracio = b.REG_nroregistrac " + ;
				"where a.TFA_registracio in ("+cRegistracio+") " +;
				" order by c.AFI_fechabaja desc","mwkFarmAptoC")

			Select * From mwkFarmAptoC Group By TFA_registracio Into Cursor mwkFarmApto

			If Used("mwkFarmAptob")
				Insert Into mwkFarmAptoB ;
					Select * From mwkFarmApto
			Else
				Select * From mwkFarmApto Into Cursor mwkFarmAptoB Readwrite
			Endif
		Endif

		cRegistracio = Transform(mwkRegistraciones.tcp_registracio)+","
		nCuenta = 1

	Endif

	Select mwkRegistraciones

Endscan

Select a.*,b.TFA_fecha, b.TFA_conombre, ;
	b.Documento, b.HClinica,c.ent_descrient ;
	FROM mwkinformeB As a ;
	LEFT Join mwkFarmAptoB As b On a.tcp_registracio = b.TFA_registracio ;
	LEFT JOIN mwkRegistraciones as c ON a.tcp_registracio = c.tcp_registracio ;
	INTO Cursor mwkinforme



*!*	mret = SQLExec(mcon1,"Select TCE_nropof,TCE_fechaemite,TCE_fechapasiva,TCE_idusuario,"+;
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
*!*		" Join TabFarmLog on {fn CONCAT('EMITE ',TCE_nropof)} = TFL_motivo"+;
*!*		" and TFL_partida = TabFarmCitosE.TCE_partida and TFL_insumocodigo = TabFarmCitosE.TCE_insumocodigo"+;
*!*		" Join TabFarmCitosI on TCI_partida = TabFarmCitosE.TCE_partida and TCI_insumocodigo = TCE_insumocodigo"+;
*!*		" and TCI_lote = TabFarmLog.TFL_lote"+;
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

If mret < 0
	Messagebox("EN CONSULTA DE ETIQUETAS EMITIDAS",16,"ERROR")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

Use In Select("mwkdesca")
mret = SQLExec(mcon1,"select * from TabFarmLog where TFL_motivo like '%Descarte %'","mwkdesca")

If mret < 0
	Messagebox("EN CONSULTA LOG DE ETIQUETAS EMITIDAS",16,"ERROR")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif


vubica[1]='HOSP. DE DIA'
vubica[2]='INTERNACION '
vubica[3]='EXTERNO     '
vubica[4]='NO ESPECIF. '

Use In Select("mwkinforme2")
Use In Select("mwkinforme3")

If Used("mwkinforme")
	If Reccount("mwkinforme")>0

		Select mwkinforme.*,;
			iif(TCP_origen=1,'OBRA SOCIAL     ',;
			iif(TCP_origen=2,'SANATORIO GÜEMES',;
			iif(TCP_origen=3,'PLAN de SALUD   ',;
			'OTRO            '))) As Origen, vubica[iif(nvl(lubicacion,0)=0,4,lubicacion)] As ubicacion,;
			nvl(TFL_potencia,0) As descarte;
			From mwkinforme ;
			left Join mwkdesca On ;
			TFL_partida=TCE_partida And;
			TFL_insumocodigo=TCE_insumocodigo And;
			right(Alltrim(TFL_motivo),9) = Alltrim(TCE_nropof);
			Into Cursor mwkinforme

		Select * ;
			from mwkinforme ;
			order By TCE_nropof, tfi_pactivo Asc ;
			into Cursor mwkinforme2

		Select TCE_nropof,tce_nombrepac,tce_fechaemite,;
			nvl(tce_fechapasiva,Dtot({//})) As tce_fechapasiva,;
			alltrim(tce_idusuario) As tce_idusuario,;
			tce_insumodescrip,tce_medidauso,tfp_diagnos,;
			tfi_pactivo,tfi_dosis,tfi_solucion,tfi_volumen,tfi_viasadm,;
			tfi_tiempo,tfi_utiempo,TCE_insumocodigo,lcantidad,tci_lote,;
			tci_vence,tci_marca,TCE_partida,tfp_peso,tfp_pisocama,;
			tfp_supcor,tfp_talla,tfp_matricula,tfp_medico,;
			tfp_usuario,tec_pactivo,tce_medidauso1,tec_solucion,;
			tec_fecelab,tec_fecvenc,tec_obsa,tec_obsb,tec_obsetq,;
			nvl(fecha_baja_plan,Dtot({//})) As fecha_baja_plan,;
			esquema,Documento,HClinica,ent_descrient,;
			TFA_fecha,TFA_conombre,Origen,ubicacion,descarte;
			group By TCE_nropof,tfi_pactivo,TCE_partida;
			from mwkinforme2 ;
			into Cursor mwkinforme3


*     group by tce_partida,tce_nropof,tce_insumocodigo order by tce_nropof,tce_nombrepac;
*     group by TCE_nropof, TCE_insumocodigo ;

	Endif
Endif

Use In Select("mwkinforme")
Use In Select("mwkinforme2")
Use In Select("mwkdesca")

SELECT mwkinforme3
*browse

Return .T.


* ------------------------------------------
Function DevuelveEntidad(nRegistracion)

Local cEntidad
Local cAlias

cEntidad = ""
cAlias = Alias()

mret = SQLExec(mcon1,"select b.ent_descrient " +;
	"from Afiliacion as a " +;
	"left join Entidades as b on a.AFI_codentidad = b.Ent_codent " +;
	"where a.Registracio = ?nRegistracion", "mwkEntInforme")

* and a.AFI_fechabaja is null

If mret > 0
	Select mwkEntInforme
	Go Bottom

	cEntidad = mwkEntInforme.ent_descrient

Endif

Use In Select("mwkEntInforme")

Select (cAlias)

Return cEntidad



