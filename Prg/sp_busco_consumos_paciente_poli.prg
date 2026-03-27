
****
** Busco consumo por paciente
****

Parameters mregistracio, msql_cons, lincluyequir, lsoloinfo

LOCAL cEntidades

If Type('lIncluyeQuir')#"N"
	lincluyequir=0
Endif

If !Used('mwkpMed')
	Do sp_busco_phordatos
Endif
If Vartype(block_ent)# "C"
	Public block_ent
	block_ent = ''
Endif
* ---------- Marcelo Torres, 13/03/2024
cEntidades = block_ent

IF cEntidades = "ALL"
  cEntidades = ""
ENDIF 
* -------------------------------------
 mcon4 = SQLConnect("bristol")
mseg = Seconds()
If mxambito >1
	mbuscov  =  " and VAL_fechasolicitud>='2024-05-24' "
Else
	mbuscov  = ''
Endif

Use In Select("mwkserv")

mret = SQLExec(mcon1, "select ser_codserv, ser_descripserv,scv_mnemonico "+;
	"from servicios, servcargval " + ;
	"where ser_codserv = servcargval.scv_codservicio " + ;
	"and scv_mnemonico is not null and ser_fechapasiva is null ", "mwkserv")

If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
Endif

mret = SQLExec(mcon1, "select ser_codserv, ser_descripserv "+;
	"from servicios " + ;
	"where ser_fechapasiva is null ", "mwkservint")

If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
Endif

mret = SQLExec(mcon1, "select CUE_codcuenta,CUE_descripcuenta as nombre "+;
	"from cuentas " + ;
	"where CUE_fechapasiva is null ", "mwkcuentas")

If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
Endif
*mfitraent = IIF(Empty(block_ent ),''," cob_codentidad in ( "+block_ent +") and ")
mfitraent = IIF(Empty(cEntidades ),''," cob_codentidad in ( "+cEntidades +") and ")

mret = SQLExec(mcon1, "select VAL_codadmision, VAL_tipopaciente, VAL_fechasolicitud, VAL_horasolicitud, " + ;
	"VAL_codvaleasist, VAL_nroprotocolo, PAC_sectorinternac,PAC_cama,PAC_habitacion, val_prestador,val_codservvale " + ;
	",VAL_observaciones,"+;
	"val_codpun,VAL_OperadorCarga,val_nrointfactura,VAL_estado,PAC_codhci  "+;
	"from pacientes, valesasist,coberturas " + ;
	"where PAC_codadmision = VAL_codadmision and PAC_codadmision = COB_pacientes " + ;
	""+mbuscov  , "mwkconsumos1")

If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
Endif

&&  and VAL_fechasolicitud >to_date('01/01/1900','dd/mm/yyyy')

mseg = Seconds()
*mfitraent = IIF(Empty(block_ent ),''," HIS_codentidad in ( "+block_ent +") and ")
mfitraent = IIF(Empty(cEntidades ),''," HIS_codentidad in ( "+cEntidades +") and ")

mret = SQLExec(mcon1, "select VAL_codadmision, VAL_tipopaciente, VAL_fechasolicitud, VAL_horasolicitud, " + ;
	"VAL_codvaleasist, VAL_nroprotocolo, PAC_sectorinternac,PAC_cama,PAC_habitacion ,val_prestador,val_codservvale " + ;
	",VAL_observaciones,"+;
	"val_codpun,VAL_OperadorCarga,val_nrointfactura,VAL_estado,PAC_codhci "+;
	"from histambgua, pacientes, valesasist " + ;
	"where his_codadmision = PAC_codadmision and " +;
	"PAC_codadmision = VAL_codadmision " + ;
	mbuscov  , "mwkconsumos2")

If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
Endif

cwhere = Iif(lsoloinfo,' where VAL_nroprotocolo > 0 ','')

If lincluyequir = 0

	Select *, 1 As tv From mwkconsumos1 &cwhere ;
		union All ;
		select *, 1 As tv From mwkconsumos2 &cwhere;
		into Cursor mwkcons_prev

Else

	Select *, 1 As tv From mwkconsumos1 &cwhere ;
		union All ;
		select *, 1 As tv From mwkconsumos2 &cwhere;
		into Cursor mwkconsumos3
*mfitraent = IIF(Empty(block_ent ),''," cob_codentidad in ( "+block_ent +") and ")
mfitraent = IIF(Empty(cEntidades ),''," cob_codentidad in ( "+cEntidades +") and ")

	mret = SQLExec(mcon1, "select vaq_codadmision, VAQ_tipopaciente, VAQ_fechasolicitud, vaq_horacomienzo , " + ;
		"vaq_codpunq, vaq_protocolo, PAC_sectorinternac,PAC_cama,PAC_habitacion,vaq_medicocabecera,vaq_codservvale " + ;
		",VAQ_observaciones,"+;
		"vaq_codpunq,PAC_codhci  "+;
		"from pacientes, VALESQUIROF,coberturas  " + ;
		"where PAC_codadmision = vaq_codadmision and PAC_codadmision = COB_pacientes and " +mfitraent + ;
		"PAC_codhci = ?mregistracio and VAQ_fechasolicitud >to_date('01/01/1900','dd/mm/yyyy') " , "mwkconsumos4")

	If mret <= 0
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Endif
*mfitraent = IIF(Empty(block_ent ),''," HIS_codentidad in ( "+block_ent +") and ")
mfitraent = IIF(Empty(cEntidades ),''," HIS_codentidad in ( "+cEntidades +") and ")

	mret = SQLExec(mcon1, "select vaq_codadmision, vaq_tipopaciente, vaq_fechasolicitud, vaq_horacomienzo, " + ;
		"vaq_codpunq, vaq_protocolo, PAC_sectorinternac,PAC_cama,PAC_habitacion, vaq_medicocabecera,vaq_codservvale " + ;
		",VAQ_observaciones,vaq_codpunq,PAC_codhci  "+;
		"from pacientes, histambgua , VALESQUIROF " + ;
		"where his_codadmision = PAC_codadmision and " + mfitraent +;
		"PAC_codadmision = vaq_codadmision and " + ;
		"his_nroregistrac = ?mregistracio and VAQ_fechasolicitud >to_date('01/01/1900','dd/mm/yyyy') " , "mwkconsumos5")

	If mret <= 0
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Endif

	cwhere = Iif(lsoloinfo,' where VAQ_protocolo > 0 ','')

	Select vaq_codadmision As val_codadmision, vaq_tipopaciente As val_tipopaciente ;
		,vaq_fechasolicitud As val_fechasolicitud, vaq_horacomienzo As val_horasolicitud ;
		,vaq_protocolo As val_codvaleasist ;
		,vaq_codpunq As val_nroprotocolo ;
		,pac_sectorinternac,PAC_cama,PAC_habitacion,Val(vaq_medicocabecera) As val_prestador ;
		,vaq_codservvale As val_codservvale ;
		,Left(VAQ_observaciones,35) As VAL_observaciones,vaq_codpunq As val_codpun,1 As VAL_OperadorCarga,1 As val_nrointfactura,3 As VAL_estado,PAC_codhci ;
		,2 As tv ;
		from mwkconsumos4 &cwhere ;
		union All ;
		select vaq_codadmision As val_codadmision, vaq_tipopaciente As val_tipopaciente ;
		,vaq_fechasolicitud As val_fechasolicitud, vaq_horacomienzo As val_horasolicitud ;
		,vaq_protocolo As val_codvaleasist ;
		,vaq_codpunq As val_nroprotocolo ;
		,pac_sectorinternac,PAC_cama,PAC_habitacion,Val(vaq_medicocabecera) As val_prestador ;
		,vaq_codservvale As val_codservvale ;
		,Left(VAQ_observaciones,35) As VAL_observaciones,vaq_codpunq As val_codpun,1 As VAL_OperadorCarga,1 As val_nrointfactura,3 As VAL_estado,PAC_codhci ;
		,2 As tv ;
		from mwkconsumos5 &cwhere ;
		into Cursor mwkconsumos6

	Select mwkconsumos3.*,nombre,ser_descripserv, ser_codserv,scv_mnemonico  ;
		from mwkconsumos3 	;
		left Join mwkpmed On val_prestador = mwkpmed.Id ;
		left Join mwkserv On val_codservvale = mwkserv.ser_codserv ;
		union All ;
		select mwkconsumos6.*,Left(nombre,40) As nombre,ser_descripserv, ser_codserv,"  " As scv_mnemonico  ;
		from mwkconsumos6 ;
		left Join mwkcuentas On val_prestador = CUE_codcuenta;
		left Join mwkservint On val_codservvale = mwkservint.ser_codserv ;
		into Cursor mwkconsumoss7

	Select mwkconsumoss7.*,0 As _selection From mwkconsumoss7 Into Cursor mwkconsumoss

	Use In Select("mwkconsumoss7")


Endif


msql_cons = "select VAL_codadmision, VAL_tipopaciente, VAL_fechasolicitud, " + ;
	"Int(VAL_codvaleasist) as VAL_codvaleasist, " + ;
	"iif(isnull(VAL_nroprotocolo), space(10), str(VAL_nroprotocolo)) as VAL_nroprotocolo,"    + ;
	"iif(isnull(nombre), space(40), nombre) as nombre, ser_descripserv, PAC_sectorinternac,PAC_cama,PAC_habitacion," + ;
	"tv, ser_codserv ,scv_mnemonico,"+;
	"VAL_observaciones,val_codpun,VAL_horasolicitud ,VAL_OperadorCarga,val_nrointfactura,VAL_estado,PAC_codhci,_selection "+;
	"from mwkconsumoss "+;
	"order by VAL_fechasolicitud desc,VAL_horasolicitud desc,VAL_tipopaciente asc "+;
	"into cursor mwkconsu"
