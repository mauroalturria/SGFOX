****
** busco camas en habitacions
****
parameter mcodsec, msql_cama
 
if vartype (mcodsec)="C"
	mret = sqlexec(mcon1, "select hab_codhabitacion, hab_codcama, hab_codpaciente, hab_codbloqueo, " + ;
		"hab_habilitada,sec_descripsec  " + ;
		"from habitacions inner join sectores on sec_codsector = hab_sectores  " + ;
		"where hab_codpaciente = 'BLOQUEO'  and hab_sectores = ?mcodsec  and sec_internacion = 1 " + ;
		"order by hab_codhabitacion, hab_codcama", "mwkcamas")
else
	mret = sqlexec(mcon1, "select hab_codhabitacion, hab_codcama, hab_codpaciente, hab_codbloqueo, " + ;
		"hab_habilitada,sec_descripsec  " + ;
		"from habitacions inner join sectores on sec_codsector = hab_sectores  " + ;
		"where hab_codpaciente = 'BLOQUEO'   and sec_internacion = 1 " + ;
		"order by hab_codhabitacion, hab_codcama", "mwkcamas")
endif
msql_cama = "select  sec_descripsec, hab_codhabitacion , hab_codcama "+;
	"from mwkcamas into cursor mwkcama"


