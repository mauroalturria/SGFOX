****
** busco vales de demanda espontanea
****

parameter mfecdes, mfechas, mbusco, msql_tot

mret = sqlexec(mcon1, "select ser_descripserv,VAL_codadmision,  "+;
	"VAL_tipopaciente, datepart(dd,VAL_fechasolicitud) as dia, " + ;
	"pia_codprest, VAL_circuitoorigen,VAL_fechasolicitud,VAL_codservvale  " + ;
	"from valesasist, presinsuvas, servicios " + ;
	"where  valesasist = pia_valesasist and " + ;
	"VAL_codservvale = ser_codserv and VAL_codservvale in (7000,6800,5310,1248,6400,9800) and "  + ;
	"VAL_fechasolicitud >= ?mfecdes and " + ;
	"VAL_fechasolicitud <= ?mfechas  " + ;
	"group by valesasist,VAL_codservvale, VAL_codadmision,VAL_tipopaciente, datepart(dd,VAL_fechasolicitud) " , "mwktotval")
if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif
mret =	sqlexec(mcon1, "select pre_codprest,pre_especialidad" + ;
	" from prestacions " , "mwkpres")
if mret<1
	=aerr(eros)
	messagebox(eros(2))
endif

select * from mwktotval,mwkpres ;
	where 	pre_codprest = pia_codprest  ;
	group by VAL_codservvale, VAL_tipopaciente, dia,VAL_codadmision order by  pre_especialidad, dia ;
	into cursor mwktotvales

select *,count(dia) as total from mwktotvales;
	group by VAL_codservvale, VAL_tipopaciente, dia order by  pre_especialidad, dia ;
	into cursor mwktotval1
	
	
msql_tot = "select ser_descripserv, 0 as canti , VAL_tipopaciente, " + ;
	"'Guardia  ' as origen " + ;
	"from mwktotval order by ser_descripserv into cursor mwktotva1"

