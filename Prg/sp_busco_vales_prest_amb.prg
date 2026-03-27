****
** busco consumo por paciente
****

Parameters mregistracio, msql_cons,mfecdes ,mbuscop
If Vartype(mbuscop)<>"C"
	mbuscop = ''
Endif

mret = SQLExec(mcon1, "select VAL_codadmision, VAL_tipopaciente, VAL_fechasolicitud, " + ;
	" VAL_codvaleasist, VAL_nroprotocolo, nombre, ser_descripserv, presinsuvas.pia_codprest " + ;
	" from pacientes, servicios, valesasist  "+;
	" inner join presinsuvas on presinsuvas.pia_valesasist  = valesasist.VAL_codpun "+;
	" left outer join prestadores " + ;
	" on valesasist.VAL_prestador = prestadores.id " + ;
	" where PAC_codadmision = VAL_codadmision and " + ;
	" VAL_codservvale = ser_codserv and " + ;
	" (VAL_codsector <> 'GUA') and " + ;
	" VAL_fechasolicitud>?mfecdes and "+;
	" PAC_codhci = ?mregistracio " + mbuscop+;
	" order by VAL_fechasolicitud desc ", "mwkconsumos1")

mret = SQLExec(mcon1, "select VAL_codadmision, VAL_tipopaciente, VAL_fechasolicitud, " + ;
	" VAL_codvaleasist, VAL_nroprotocolo, nombre, ser_descripserv, presinsuvas.pia_codprest " + ;
	" from pacientes, servicios, histambgua, " + ;
	" valesasist "+;
	" inner join presinsuvas on presinsuvas.pia_valesasist  = valesasist.VAL_codpun "+;
	" left outer join prestadores " + ;
	" on valesasist.VAL_prestador = prestadores.id " + ;
	" where his_codadmision = PAC_codadmision and " + ;
	" (VAL_codsector <> 'GUA') and " + ;
	" PAC_codadmision = VAL_codadmision and " + ;
	" VAL_codservvale = ser_codserv and " + ;
	" VAL_fechasolicitud>?mfecdes and "+;
	" his_nroregistrac = ?mregistracio " + mbuscop +;
	" order by VAL_fechasolicitud desc ", "mwkconsumos2")


Select * From mwkconsumos1 ;
	union All ;
	select * From mwkconsumos2 ;
	into Cursor mwkconsumos3

msql_cons = "select VAL_codadmision, VAL_tipopaciente, VAL_fechasolicitud, VAL_codvaleasist, " + ;
	"iif(isnull(VAL_nroprotocolo), space(10), str(VAL_nroprotocolo)) as VAL_nroprotocolo, " + ;
	"iif(isnull(nombre), space(40), nombre) as prestanombre, ser_descripserv as servicio ,pia_codprest " + ;
	"from mwkconsumos3 order by VAL_fechasolicitud desc into cursor mwkconsu"
