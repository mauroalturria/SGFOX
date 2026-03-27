****
** busco consumo por paciente
****

parameters mregistracio, msql_cons

mret = sqlexec(mcon1, "select VAL_codadmision, VAL_tipopaciente, VAL_fechasolicitud, " + ;
	"VAL_codvaleasist, VAL_nroprotocolo, nombre, ser_descripserv " + ;
	"from pacientes, servicios, valesasist left outer join prestadores " + ;
	"on valesasist.VAL_prestador = prestadores.id " + ;
	"where PAC_codadmision = VAL_codadmision and " + ;
	"VAL_codservvale = ser_codserv and " + ;
	"(VAL_codsector <> 'GUA') and " + ;
	"PAC_codhci = ?mregistracio " + ;
	"order by VAL_fechasolicitud desc ", "mwkconsumos1")

mret = sqlexec(mcon1, "select VAL_codadmision, VAL_tipopaciente, VAL_fechasolicitud, " + ;
	"VAL_codvaleasist, VAL_nroprotocolo, nombre, ser_descripserv " + ;
	"from pacientes, servicios, histambgua, " + ;
	"valesasist left outer join prestadores " + ;
	"on valesasist.VAL_prestador = prestadores.id " + ;
	"where his_codadmision = PAC_codadmision and " + ;
	"(VAL_codsector <> 'GUA') and " + ;
	"PAC_codadmision = VAL_codadmision and " + ;
	"VAL_codservvale = ser_codserv and " + ;
	"his_nroregistrac = ?mregistracio " + ;
	"order by VAL_fechasolicitud desc ", "mwkconsumos2")


select * from mwkconsumos1 ;
	union all ;
	select * from mwkconsumos2 ;
	into cursor mwkconsumos3

msql_cons = "select VAL_codadmision, VAL_tipopaciente, VAL_fechasolicitud, VAL_codvaleasist, " + ;
	"iif(isnull(VAL_nroprotocolo), space(10), str(VAL_nroprotocolo)) as VAL_nroprotocolo, " + ;
	"iif(isnull(nombre), space(40), nombre) as nombre, ser_descripserv " + ;
	"from mwkconsumos3 order by VAL_fechasolicitud desc into cursor mwkconsu"
