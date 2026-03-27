****
** busco consumo por paciente
****

parameters mregistracio, msql_cons,lincluyequir,lsoloinfo
if type('lIncluyeQuir')#"N"
	lincluyequir=0
endif
if !used('mwkpMed')
	do sp_busco_phordatos
endif
mseg = seconds()
mret = sqlexec(mcon1, "select ser_codserv, ser_descripserv,scv_mnemonico "+;
	"from servicios, servcargval " + ;
	"where ser_codserv = servcargval.scv_codservicio " + ;
	"and scv_mnemonico is not null and ser_fechapasiva is null "+;
	"order by ser_descripserv", "mwkserv")

	mret = sqlexec(mcon1, "select VAL_codadmision, VAL_tipopaciente, VAL_fechasolicitud, VAL_horasolicitud, " + ;
		"VAL_codvaleasist, VAL_nroprotocolo, PAC_sectorinternac, val_prestador,val_codservvale " + ;
		",tpestado,tpfecharetiro,tpobserva,tpprotocolo,tpregistrac,tpusuario "+;
		"from pacientes, valesasist " + ;
		"left outer join TabProtocolo on (VAL_nroprotocolo = tpprotocolo) " + ;
		"where PAC_codadmision = VAL_codadmision and " + ;
		"PAC_codhci = ?mregistracio and VAL_fechasolicitud >to_date('01/01/1900','dd/mm/yyyy')  " + ;
		" group by VAL_codadmision, VAL_codvaleasist", "mwkconsumos1")
&&and VAL_fechasolicitud >to_date('01/01/1900','dd/mm/yyyy')
mseg = seconds()

	mret = sqlexec(mcon1, "select VAL_codadmision, VAL_tipopaciente, VAL_fechasolicitud, VAL_horasolicitud, " + ;
		"VAL_codvaleasist, VAL_nroprotocolo, PAC_sectorinternac ,val_prestador,val_codservvale " + ;
		",tpestado,tpfecharetiro,tpobserva,tpprotocolo,tpregistrac,tpusuario "+;
		"from histambgua, pacientes, valesasist " + ;
		"left outer join TabProtocolo on (VAL_nroprotocolo = tpprotocolo) " + ;
		"where his_codadmision = PAC_codadmision and " + ;
		"PAC_codadmision = VAL_codadmision and " + ;
		"his_nroregistrac = ?mregistracio  and VAL_fechasolicitud >to_date('01/01/1900','dd/mm/yyyy') " + ;
		" group by VAL_codadmision, VAL_codvaleasist", "mwkconsumos2")
cwhere = iif(lsoloinfo,' where VAL_nroprotocolo > 0 ','')
if lincluyequir=0
	select *, 1 as tv from mwkconsumos1 &cwhere ;
		union all ;
		select *, 1 as tv from mwkconsumos2 &cwhere;
		into cursor mwkcons_prev
else
	select *, 1 as tv from mwkconsumos1 &cwhere ;
		union all ;
		select *, 1 as tv from mwkconsumos2 &cwhere;
		into cursor mwkconsumos3

		mret = sqlexec(mcon1, "select vaq_codadmision, VAQ_tipopaciente, VAQ_fechasolicitud, vaq_horacomienzo , " + ;
			"vaq_codpunq, vaq_protocolo, PAC_sectorinternac,vaq_medicocabecera,vaq_codservvale " + ;
			",tpestado,tpfecharetiro,tpobserva,tpprotocolo,tpregistrac,tpusuario "+;
			"from pacientes, VALESQUIROF  " + ;
			"left outer join TabProtocolo on (vaq_protocolo = tpprotocolo) " + ;
			"where PAC_codadmision = vaq_codadmision and " + ;
			"PAC_codhci = ?mregistracio and VAQ_fechasolicitud >to_date('01/01/1900','dd/mm/yyyy') " + ;
			" group by vaq_codadmision, vaq_codpunq ", "mwkconsumos4")
		mret = sqlexec(mcon1, "select vaq_codadmision, vaq_tipopaciente, vaq_fechasolicitud, vaq_horacomienzo, " + ;
			"vaq_codpunq, vaq_protocolo, PAC_sectorinternac, vaq_medicocabecera,vaq_codservvale " + ;
			",tpestado,tpfecharetiro,tpobserva,tpprotocolo,tpregistrac,tpusuario "+;
			"from pacientes , histambgua , VALESQUIROF " + ;
			"left outer join TabProtocolo on (vaq_protocolo = tpprotocolo) " + ;
			"where his_codadmision = PAC_codadmision and " + ;
			"PAC_codadmision = vaq_codadmision and " + ;
			"his_nroregistrac = ?mregistracio and VAQ_fechasolicitud >to_date('01/01/1900','dd/mm/yyyy') " + ;
			" group by vaq_codadmision, vaq_codpunq", "mwkconsumos5")
	cwhere = iif(lsoloinfo,' where VAQ_protocolo > 0 ','')

	select vaq_codadmision as val_codadmision, vaq_tipopaciente as val_tipopaciente ;
		, vaq_fechasolicitud as val_fechasolicitud, vaq_horacomienzo as val_horasolicitud;
		,vaq_protocolo as val_codvaleasist ;
		, vaq_codpunq as val_nroprotocolo ;
		, pac_sectorinternac,val(vaq_medicocabecera) as val_prestador ,vaq_codservvale as val_codservvale ;
		,tpestado,tpfecharetiro,tpobserva,tpprotocolo,tpregistrac,tpusuario , 2 as tv  ;
		from mwkconsumos4 &cwhere;
		union all ;
		select vaq_codadmision as val_codadmision, vaq_tipopaciente as val_tipopaciente ;
		, vaq_fechasolicitud as val_fechasolicitud, vaq_horacomienzo as val_horasolicitud;
		,vaq_protocolo as val_codvaleasist ;
		, vaq_codpunq as val_nroprotocolo;
		, pac_sectorinternac,val(vaq_medicocabecera) as val_prestador ,vaq_codservvale as val_codservvale;
		,tpestado,tpfecharetiro,tpobserva,tpprotocolo,tpregistrac,tpusuario, 2 as tv  ;
		from mwkconsumos5 &cwhere;
		into cursor mwkconsumos6

	select * from mwkconsumos3 ;
		union all ;
		select * from mwkconsumos6 ;
		into cursor mwkcons_prev
endif
select mwkcons_prev.*,nombre, ser_descripserv, ser_codserv,scv_mnemonico from  mwkcons_prev;
	left join mwkpmed on val_prestador = mwkpmed.id ;
	left join mwkserv on val_codservvale = mwkserv.ser_codserv ;
	into cursor mwkconsumoss

msql_cons = "select VAL_codadmision, VAL_tipopaciente, VAL_fechasolicitud, VAL_codvaleasist, " + ;
	"iif(isnull(VAL_nroprotocolo), space(10), str(VAL_nroprotocolo)) as VAL_nroprotocolo, " + ;
	"iif(isnull(nombre), space(40), nombre) as nombre, ser_descripserv, PAC_sectorinternac, tv, ser_codserv   " + ;
	",tpestado,tpfecharetiro,tpobserva,tpprotocolo,tpregistrac,tpusuario,scv_mnemonico "+;
	"from mwkconsumoss "+;
	"order by VAL_fechasolicitud desc,VAL_horasolicitud desc,VAL_tipopaciente asc "+;
	"into cursor mwkconsu"

