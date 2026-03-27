****
** busco consumo por paciente
****

Parameters mregistracio, msql_cons,mfecdes ,mcuenta
If Vartype(mcuenta)="C"
	mbuspac = 	" PAC_codadmision = '"+Alltrim(mcuenta)+"' "
Else
	mbuspac = 	" PAC_codhci = ?mregistracio "
Endif
mret = SQLExec(mcon1, "select VAL_codadmision, VAL_tipopaciente, VAL_fechasolicitud, VAL_horasolicitud," + ;
	"VAL_codvaleasist, VAL_nroprotocolo, nombre, ser_descripserv, presinsuvas.pia_codprest, " + ;
	"tabbacteriotipomuestra.BAC_descripmuestra,presinsuvas.PIA_codmuestrapx,tabbacteriotipomuestra.BAC_codigomuestra " +;
	"from pacientes, servicios, valesasist  "+;
	" inner join presinsuvas on presinsuvas.pia_valesasist  = valesasist.VAL_codpun "+;	
	" left outer join prestadores " + ;
	"on valesasist.VAL_prestador = prestadores.id " + ;
	"left join tabbacteriotipomuestra on presinsuvas.PIA_codmuestrapx = tabbacteriotipomuestra.id " +;
	"where PAC_codadmision = VAL_codadmision and " + ;
	"VAL_codservvale = ser_codserv and " + ;
	"(VAL_codsector = 'GUA') and " + ;
	" VAL_fechasolicitud>=?mfecdes and "+mbuspac +;
	"order by VAL_fechasolicitud desc ", "mwkconsumos1")

mret = SQLExec(mcon1, "select VAL_codadmision, VAL_tipopaciente, VAL_fechasolicitud, VAL_horasolicitud," + ;
	"VAL_codvaleasist, VAL_nroprotocolo, nombre, ser_descripserv, presinsuvas.pia_codprest, " + ;
	"tabbacteriotipomuestra.BAC_descripmuestra,presinsuvas.PIA_codmuestrapx,tabbacteriotipomuestra.BAC_codigomuestra " +;
	"from pacientes, servicios, histambgua, " + ;
	"valesasist "+;
	" inner join presinsuvas on presinsuvas.pia_valesasist  = valesasist.VAL_codpun "+;
	" left outer join prestadores " + ;
	"on valesasist.VAL_prestador = prestadores.id " + ;
	"left join tabbacteriotipomuestra on presinsuvas.PIA_codmuestrapx = tabbacteriotipomuestra.id " +;
	"where his_codadmision = PAC_codadmision and " + ;
	"(VAL_codsector = 'GUA') and " + ;
	"PAC_codadmision = VAL_codadmision and " + ;
	"VAL_codservvale = ser_codserv and " + ;
	" VAL_fechasolicitud>=?mfecdes and "+;
	"his_nroregistrac = ?mregistracio " + ;
	"order by VAL_fechasolicitud desc ", "mwkconsumos2")


Select * From mwkconsumos1 ;
	union All ;
	select * From mwkconsumos2 ;
	into Cursor mwkconsumos3

msql_cons = "select VAL_codadmision, VAL_tipopaciente, VAL_fechasolicitud, VAL_codvaleasist, " + ;
	"iif(isnull(VAL_nroprotocolo), space(10), str(VAL_nroprotocolo)) as VAL_nroprotocolo, " + ;
	"iif(isnull(nombre), space(40), nombre) as prestanombre, ser_descripserv as servicio ,pia_codprest, " + ;
	"BAC_descripmuestra,PIA_codmuestrapx,BAC_codigomuestra " +;
	"from mwkconsumos3 group by VAL_fechasolicitud, VAL_codvaleasist,pia_codprest order by VAL_fechasolicitud desc into cursor mwkconsu"
