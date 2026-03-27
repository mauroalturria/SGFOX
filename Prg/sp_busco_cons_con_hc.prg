****
** busco consumo por paciente
****

parameters mregistracio, msql_cons

mret = sqlexec(mcon1, "select VAL_codadmision, VAL_codvaleasist, ser_descripserv " + ;
	"from pacientes " + ;
	"left join valesasist on pacientes.PAC_codadmision = valesasist .VAL_codadmision " + ;
	"left outer join preinsuvas on preinsuvas .pia_valesasist = valesasist .valesasist " + ;
	"left outer join prestacions on preinsuvas .pia_codprest = prestacions pre_codprest " + ;
	"where " + ;
	"VAL_codsector = 'AMB' and " + ;
	"PAC_codhci = ?mregistracio " + ;
	"group by PAC_codhci ", "mwkconsumos1")

